import numpy as np
import cv2
import os
import datetime
import tempfile
import shutil

from firebase_admin import credentials, db, storage, initialize_app

from firebase_functions import https_fn, options

initialize_app()

options.set_global_options(
    region=options.SupportedRegion.US_CENTRAL1,
    memory=options.MemoryOption.MB_512,
)

def dbObj():
    authPath = os.path.join(os.path.dirname(__file__), "cue-cetera-726df-firebase-adminsdk-z8vba-4ba059bdf8.json")
    cred_obj = credentials.Certificate(authPath)
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = authPath

def pull_from_db():
    dbObj()

    ref = db.reference("Videos/paths")
    path = ref.order_by_child('Path').get()
    path_val = ""
    currPath = ""

    for key, val in path.items():
        path_val = val
        path_val = path_val['Path']

    if path_val[0] == "/":
        currPath = path_val[1:]

    # Need to add error for if path is not found

    source_blob_name = currPath

    destination_file_name = r"videoAnalysis.mp4"

    bucket = storage.bucket()
    blob = bucket.blob(source_blob_name)
    blob.download_to_filename(destination_file_name)
    return destination_file_name

@https_fn.on_call()
def vid_to_imgs(req: https_fn.CallableRequest):
    delete_db()
    file_name=pull_from_db()

    # Create imgs folder
    osPath = os.path.join(os.path.dirname(__file__), "imgs")
    if not os.path.isdir(osPath):
        os.mkdir(osPath)
    FPS = 3
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
            img_name = f"frame{timeStamp}.jpg"
            img_path = os.path.join(osPath + '/', img_name)
            cv2.imwrite(img_path, image)
            curr_img = "imgs/" + img_name
            upload_img(curr_img)
            curr_step += 1
        cnt += 1

    return "Converted video to images."

# adds classification labels to database.
def add_to_db(file_name):
    ref = db.reference("Images")
    ref.child("Paths").push().set({
        "Path": file_name,
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
    add_to_db(file_name)
    return blob

# again for security purposes
def delete_img(blobs):
    for blob_item in blobs:
        blob_item.delete()
