from tensorflow import keras
import numpy as np
import joblib
import cv2
import os
import datetime
import ipywidgets

import firebase_admin
from firebase_admin import db, storage
import firebase_admin.auth as auth

from flask import Flask, request

app = Flask(__name__)


class Emotion_ML:
    def __init__(self):
        self.file_name = ""
        self.labels = []
        self.images = []


# These app.route entries above each function are from flask. When a request is called at that url
# ending it runs that function.

# @app.route('/call_db', methods=['PUT', 'PATCH'])
def dbObj():
    authPath = os.path.join(os.path.dirname(__file__), "cue-cetera-726df-firebase-adminsdk-z8vba-e4c583ce09.json")
    cred_obj = firebase_admin.credentials.Certificate(authPath)
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = authPath
    databaseURL = 'https://cue-cetera-726df-default-rtdb.firebaseio.com/'
    bucket = 'cue-cetera-726df.appspot.com'

    firebase_admin.initialize_app(cred_obj, {
        'databaseURL': databaseURL,
        'storageBucket': bucket
    })

    ### end of function so flask request goes through ###

    # req = request.get_data()
    # print(req)
    # return jsonify(req)


# @app.route('/pull', methods=['PUT', 'PATCH'])
def pull_from_dB():
    ref = db.reference("Videos/paths")
    path = ref.order_by_child('Path').get()
    path_val = ""

    for key, val in path.items():
        path_val = val
        path_val = path_val['Path']

    if path_val[0] == "/":
        currPath = path_val[1:]

    source_blob_name = currPath

    # The path to which the video should be downloaded so processing can work.
    destination_file_name = r"videoAnalysis.mp4"

    bucket = storage.bucket()
    blob = bucket.blob(source_blob_name)
    blob.download_to_filename(destination_file_name)

    # req = request.get_data()
    # print(req)
    # return jsonify(req)

# adds classification labels to database.
def add_to_db(file_name, emotion, label):
    ref = db.reference("Images")
    ref.child("Classification").push().set({
        "Path": file_name,
        "Emotion": emotion,
        "Label": label,
    })

# not in use at the moment but for security once the user's session is over
def delete_db():
    ref = db.reference("/")
    data = ref.get()
    for key, val in data.items():
        delete_user_ref = ref.child(key)
        delete_user_ref.delete()

# uploads images to the firebase database storage
def upload_img(file_name):
    bucket = storage.bucket()
    blob = bucket.blob(file_name)
    blob.upload_from_filename(file_name)
    return blob


# again for security purposes
# @app.route('/delete_img', methods=['PUT', 'PATCH'])
def delete_img(blobs):
    for blob_item in blobs:
        blob_item.delete()

    # req = request.get_data()
    # print(req)
    # return jsonify(req)

# @app.route('/vid_to_img', methods=['PUT', 'PATCH'])
def vid_to_imgs(file_name="videoAnalysis.mp4"):
    # Create imgs folder
    osPath = os.path.join(os.path.dirname(__file__), "imgs")
    if not os.path.isdir(osPath):
        os.mkdir(osPath)
    FPS = 10
    # Read the video and its fps
    video = cv2.VideoCapture(file_name)
    vid_fps = video.get(cv2.CAP_PROP_FPS)
    if vid_fps < FPS:
        FPS = vid_fps

    vid_length = video.get(cv2.CAP_PROP_FRAME_COUNT) / vid_fps

    steps = []
    for i in np.arange(0, vid_length, 1 / FPS):
        steps.append(i)

    cnt = 0
    curr_step = 0
    success = True
    while success:
        success, image = video.read()
        if not success:
            break
        # Get the length of clip
        frame_len = cnt / vid_fps
        # Increment step
        if (curr_step == len(steps)):
            break
        else:
            length_ = steps[curr_step]

        if frame_len >= length_:
            # save frame if length is <= current frame length

            # format filename
            timeStamp = str(datetime.timedelta(seconds=frame_len))
            try:
                timeStamp, ms = timeStamp.split(".")
                ms = int(ms)
                ms = round(ms / 1e4)
                timeStamp = f"{timeStamp}.{ms:02}".replace(":", "-")
            except ValueError:
                timeStamp = (timeStamp + ".00").replace(":", "-")
            # save image to folder
            cv2.imwrite(os.path.join(osPath + '/', f"frame{timeStamp}.jpg"), image)
            curr_step += 1
        cnt += 1

    # req = request.get_data()
    # print(req)
    # return jsonify(req)

# Where the ml model makes the predictions
# @app.route('/predict', methods=['POST', 'PATCH'])
def predict_emotions(img_dir=os.path.join(os.path.dirname(__file__), "imgs/")):
    # emotion map
    emotions = {0:'Affection', 1:'Anger', 2:'Annoyance', 3:'Anticipation',
               4:'Aversion', 5:'Confidence',6:'Disapproval', 7:'Disconnection',
               8:'Disquietment', 9:'Doubt/Confusion', 10:'Embarrassment',
               11:'Engagement',12:'Esteem', 13:'Excitement', 14:'Fatigue',
               15:'Fear', 16:'Happiness', 17:'Pain', 18:'Peace', 19:'Pleasure',
               20:'Sadness', 21:'Sensitivity', 22:'Suffering', 23:'Surprise',
               24:'Sympathy', 25:'Yearning', 26:'Disgust', 27:'Neutral'}

    # import model
    model3 = keras.models.load_model('Model3_trained_updated');
    # num_imgs = len([name for name in os.listdir(img_dir) if os.path.isfile(os.path.join(img_dir, name))])
    imgs = []
    img_dirs = []
    blobs = []
    for image in os.listdir(img_dir):
        img = cv2.imread(os.path.join(img_dir, image))
        arr = cv2.resize(img, (48, 48), interpolation=cv2.INTER_CUBIC)
        imgs.append(arr)

        curr_img = "imgs/" + image
        img_dirs.append(curr_img)
        curr_blob = upload_img(curr_img)
        blobs.append(curr_blob)

    # for i in range(len(img_dirs)):
    #     add_to_db(img_dirs[i])

    # reshape image
    imgs = np.array(imgs).reshape(-1, 48, 48, 3)

    # preprocess data for model
    imgs_rs = keras.applications.mobilenet_v2.preprocess_input(imgs)

    #predict labels
    y_imgs = np.argmax(model3.predict(imgs_rs), axis=1)

    labels = []
    for i in range(len(y_imgs)):
        labels.append(emotions[y_imgs[i]])
        add_to_db(img_dirs[i], emotions[y_imgs[i]], np.random.randint(2)) # random number for classification

    # req = request.get_data()
    # print(req)
    # return jsonify(req)


if __name__ == "__main__":
    model = Emotion_ML()
    dbObj()

    ### Following commented out lines are for the user session ###
# make anonymous user
#     anonymous_user = auth.create_user()
#     uid = anonymous_user.uid
#     token = auth.create_custom_token(uid)

    pull_from_dB()
    vid_to_imgs("videoAnalysis.mp4")
    osPath = os.path.join(os.path.dirname(__file__), "imgs/")
    predict_emotions(osPath)
    # labels = model.labels

    # app.run(debug=True) # Flask backend starter