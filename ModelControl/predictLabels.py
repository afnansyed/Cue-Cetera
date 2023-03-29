import tensorflow as tf
from tensorflow import keras
import matplotlib.pyplot as plt
import numpy as np
import numpy.random as npr
import joblib 
import cv2 
import os
import time
import datetime

class Emotion_ML:
  def __init__(self):
    self.file_name = ""
    self.labels = []
    self.images = []

  def vid_to_imgs(self, file_name):
    self.file_name = file_name
    # Create imgs folder
    if not os.path.isdir("imgs"):
        os.mkdir("imgs")
    FPS = 10
    # Read the video and its fps
    video = cv2.VideoCapture(file_name)
    vid_fps = video.get(cv2.CAP_PROP_FPS)
    if vid_fps < FPS:
        FPS = vid_fps
        
    vid_length = video.get(cv2.CAP_PROP_FRAME_COUNT) / vid_fps
    
    steps = []
    for i in np.arange(0, vid_length, 1/FPS):
        steps.append(i)
    
    cnt = 0
    curr_step = 0
    success = True
    while success:
        success,image = video.read()
        if not success:
            break
        # Get the length of clip
        frame_len = cnt/vid_fps
        # Increment step
        if(curr_step == len(steps)):
            break
        else:
            length_ = steps[curr_step]

        if frame_len >= length_:
            # save frame if length is <= current frame length
            
            #format filename
            timeStamp = str(datetime.timedelta(seconds=frame_len))
            try:
                timeStamp, ms = timeStamp.split(".")
                ms = int(ms)
                ms = round(ms/1e4)
                timeStamp = f"{timeStamp}.{ms:02}".replace(":", "-")
            except ValueError:
                timeStamp = (timeStamp + ".00").replace(":", "-")
            # save image to folder
            cv2.imwrite(os.path.join("imgs/", f"frame{timeStamp}.jpg"), image)
            curr_step +=1
        cnt +=1
        
        
        
  def predict_emotions(self, img_dir):
    # emotion map
    emotions = {0:'Affection', 1:'Anger', 2:'Annoyance', 3:'Anticipation',
               4:'Aversion', 5:'Confidence',6:'Disapproval', 7:'Disconnection',
               8:'Disquietment', 9:'Doubt/Confusion', 10:'Embarrassment',
               11:'Engagement',12:'Esteem', 13:'Excitement', 14:'Fatigue',
               15:'Fear', 16:'Happiness', 17:'Pain', 18:'Peace', 19:'Pleasure',
               20:'Sadness', 21:'Sensitivity', 22:'Suffering', 23:'Surprise',
               24:'Sympathy', 25:'Yearning', 26:'Disgust', 27:'Neutral'}

    # import model
    model3 = joblib.load('training/models/Model3_trained.pkl');
    img_dir = "imgs/"
    num_imgs = len([name for name in os.listdir(img_dir) if os.path.isfile(os.path.join(img_dir, name))])
    imgs = []
    for image in os.listdir(img_dir):
        img = cv2.imread(os.path.join(img_dir, image))
        arr = cv2.resize(img, (48, 48), interpolation=cv2.INTER_CUBIC)
        imgs.append(arr)
    
    self.images = imgs
    # reshape image
    imgs = np.array(imgs).reshape(-1, 48, 48, 3)

    # preprocess data for model
    imgs_rs = keras.applications.mobilenet_v2.preprocess_input(imgs)

    #predict labels
    y_imgs = np.argmax(model3.predict(imgs_rs), axis=1)

    self.labels = []
    for i in range(len(y_imgs)):
        self.labels.append(emotions[y_imgs[i]])


if __name__ == "__main__":
    model = Emotion_ML()
    #model.vid_to_imgs('vid_to_frames/emotions_vid.mp4')
    #model.predict_emotions("imgs/")
    #labels = model.labels
