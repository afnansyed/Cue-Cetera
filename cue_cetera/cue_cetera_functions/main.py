import numpy as np
import cv2
import os
import datetime
import unittest
import logging

from firebase_admin import credentials, db, storage, initialize_app

from firebase_functions import https_fn, options

initialize_app()
logging.info("Initialized Firebase app")

options.set_global_options(
    region=options.SupportedRegion.US_CENTRAL1,
    memory=options.MemoryOption.MB_512,
)
logging.info("Region set as ", options.SupportedRegion.US_CENTRAL1)
logging.info("Memory limit for Firebase Functions set as ", options.MemoryOption.MB_512)

def dbObj():
    authPath = os.path.join(os.path.dirname(__file__), "cue-cetera-726df-firebase-adminsdk-z8vba-4ba059bdf8.json")
    cred_obj = credentials.Certificate(authPath)
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = authPath

def pull_from_db(uid):
    dbObj()

    ref = db.reference("Videos")
    path = ref.child("paths/{}".format(uid)).order_by_key().limit_to_last(1).get()
    path_val = ""
    currPath = ""
    
    for key, val in path.items():
        path_val = val
        path_val = path_val['Path']

    if path_val[0] == "/":
        currPath = path_val[1:]

    else:
        logging.warn("Video path not found, check.")
        exit()

    source_blob_name = currPath

    destination_file_name = r"videoAnalysis.mp4"

    bucket = storage.bucket()
    blob = bucket.blob(source_blob_name)
    blob.download_to_filename(destination_file_name)
    return destination_file_name

@https_fn.on_call()
def vid_to_imgs(req: https_fn.CallableRequest):
    uid = req.auth.uid
    delete_img_paths(uid)
    delete_imgs(uid)
    file_name=pull_from_db(uid)

    # Create imgs folder
    osPath = os.path.join(os.path.dirname(__file__), "imgs-{}".format(uid))
    if not os.path.isdir(osPath):
        os.mkdir(osPath)
    FPS = 1

    logging.info("FPS currently set to: ", FPS)

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
            image_re = cv2.resize(image, (224, 224), interpolation=cv2.INTER_CUBIC)
            image_re_gray = cv2.cvtColor(image_re, cv2.COLOR_BGR2GRAY)
            cv2.imwrite(img_path, image_re_gray)
            curr_img = "imgs-{}/".format(uid) + img_name
            upload_img(curr_img, uid)
            curr_step += 1
        cnt += 1

    return "Converted video to images."

# adds classification labels to database.
def add_to_db(file_name, uid):
    ref = db.reference("Images")
    ref.child("Paths/{}/".format(uid)).push().set({
        "Path": file_name,
    })

# Delete image paths before starting new inference run
def delete_img_paths(uid):
    logging.info("Deleting image paths from database.")
    ref = db.reference("Images/Paths/{}".format(uid))
    data = ref.get()
    if data:
        for key, val in data.items():
            delete_user_ref = ref.child(key)
            delete_user_ref.delete()
    else:
        logging.warn("Image paths not found.")

# uploads images to the firebase database storage
def upload_img(file_name, uid):
    bucket = storage.bucket()
    blob = bucket.blob(file_name)
    blob.upload_from_filename(file_name)
    add_to_db(file_name, uid)
    return blob

# Delete pre-existing images before starting new inference run
def delete_imgs(uid):
    logging.info("Deleting images from Firebase")
    bucket = storage.bucket()
    blobs = bucket.list_blobs(prefix="imgs-{}/".format(uid))
    for blob_item in blobs:
        blob_item.delete()



# All unit testing for backend
class TestBackend(unittest.TestCase):
    dbObj()

    def test_pull_from_db(self):
        ref = db.reference("Test")
        ref.child("Paths").push().set({
            "Path": "testPath",
        })

        path = ref.child("Paths").order_by_key().limit_to_last(1).get()
        path_val = ""
        currPath = ""

        for key, val in path.items():
            path_val = val
            path_val = path_val['Path'] 

        if path_val[0] == "/":
            currPath = path_val[1:]

        else:
            currPath = path_val

        self.assertEqual(currPath, "testPath", "Database not working correctly.")

    def test_delete_from_db(self):
        ref = db.reference("Test/")
        data = ref.get()
        self.assertIsNotNone(data, "Database delete test not possible.")
        if data:
            for key, val in data.items():
                delete_user_ref = ref.child(key)
                delete_user_ref.delete()
        
            data = ref.get()
            self.assertIsNone(data, "Database delete not completed successfully.")

    def test_upload_imgs(self):
        f = open("test.txt", "a")
        f.write("Cue-Cetera file upload testing")
        f.close()
        bucket = storage.bucket()
        blob = bucket.blob("test.txt")
        blob.upload_from_filename("test.txt")

        #Check if it exists
        bucket = storage.bucket()
        blob = bucket.blob("test.txt")
        self.assertIsNotNone(blob, "Upload unsuccessful, file does not exist")
        # blob.download_to_filename("test_success.txt")
