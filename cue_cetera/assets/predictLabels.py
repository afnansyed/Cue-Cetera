import tensorflow as tf
from tensorflow import keras
import numpy as np
import cv2
import os
import datetime

import firebase_admin
from firebase_admin import db, ml, storage, initialize_app
import firebase_admin.auth as auth

class Emotion_ML:
    def __init__(self):
        self.file_name = ""
        self.labels = []
        self.images = []

def dbObj():
    authPath = os.path.join(os.path.dirname(__file__), "cue-cetera-726df-firebase-adminsdk-z8vba-4ba059bdf8.json")
    cred_obj = firebase_admin.credentials.Certificate(authPath)
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = authPath
    databaseURL = 'https://cue-cetera-726df-default-rtdb.firebaseio.com/'
    bucket = 'cue-cetera-726df.appspot.com'

    initialize_app(cred_obj, {
        'databaseURL': databaseURL,
        'storageBucket': bucket
    })

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
def delete_img(blobs):
    for blob_item in blobs:
        blob_item.delete()

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

# Where the ml model makes the predictions
# NOTE: TO BE DEPRECATED ONCE PREDICTIONS MADE IN FRONT END
def predict_emotions(img_dir=os.path.join(os.path.dirname(__file__), "imgs/")):
    # emotion map
    emotions = ['Disapproval','Angry','Fear','Happy','Sad','Surprised', 'Neutral']
    
    # import model
    interpreter = tf.lite.Interpreter(model_path='../../ModelControl/training/models/model.tflite')
    interpreter.allocate_tensors()

    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()

    # num_imgs = len([name for name in os.listdir(img_dir) if os.path.isfile(os.path.join(img_dir, name))])
    imgs = []
    img_dirs = []
    blobs = []
    for image in os.listdir(img_dir):
        img = cv2.imread(os.path.join(img_dir, image))
        arr = cv2.resize(img, (224, 224), interpolation=cv2.INTER_CUBIC)
        imgs.append(arr)

        curr_img = "imgs/" + image
        img_dirs.append(curr_img)
        curr_blob = upload_img(curr_img)
        blobs.append(curr_blob)

    # reshape image
    imgs = np.array(imgs).reshape(-1, 224, 224, 3)

    # preprocess data for model
    #imgs_rs = keras.applications.mobilenet_v2.preprocess_input(imgs)
    
    predictions = []

    for img in imgs:
        interpreter.set_tensor(input_details[0]['index'], [img])

        interpreter.invoke()

        # # The function `get_tensor()` returns a copy of the tensor data.
        output_data = interpreter.get_tensor(output_details[0]['index'])
        emotion = emotions[round(np.amax(output_data))]
        predictions.append(emotion)

        print('emotion:', emotion)

    for i in range(len(predictions)):
        add_to_db(img_dirs[i], predictions[i], np.random.randint(2)) # random number for classification
    

if __name__ == "__main__":
    model = Emotion_ML()
    dbObj()

    predict_emotions()

#     ### Following commented out lines are for the user session ###
# # make anonymous user
# #     anonymous_user = auth.create_user()
# #     uid = anonymous_user.uid
# #     token = auth.create_custom_token(uid)
