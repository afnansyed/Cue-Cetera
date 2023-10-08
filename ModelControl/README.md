# Emotion_ML Class Information

The file [`predictLabels.py`](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/predictLabels.py) consists of a class called `Emotion_ML`. This class has two functions:
- `vid_to_imgs(self, file_name)`
- `predict_emotions(self, img_dir)`

## vid_to_imgs(self, file_name)
This function takes in the path to the mp4 file and converts it to images at a rate of 1 FPS (which could be changed). The name of each frame is saved with the time stamp in the video from which it was taken from. The directory `imgs/` is created to save each image.

## predict_emotions(self, img_dir):
This function takes in the image directory created in the last part in order to convert the set of images as an np array with the shape (-1, 224, 224, 3), so that is ready to be pre-processed for keras. In this function, we also import the model that was created in the [`Training.ipynb`](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/Training.ipynb) file as [`model_15.tflite`](https://drive.google.com/file/d/17PMx8stCFXg39bdlm7Gmco9RKp8FjLih/view?usp=sharing) 

For more information about the trained model, please read the documentation for the [`Training Notebook`](https://github.com/AmaniN16/Cue-Cetera/tree/main/ModelControl/training#training-notebook-information).

After importing the model and reshaping the images, the np array of images is applied to the model using the `model.predict` feature and the labels predicted for each image are saved. Each label is mapped to its corresponding emotion and then saved in the `self.labels` array for easy access. 

## How to use
---
```
model = Emotion_ML()
model.vid_to_imgs("path_to_video/video.mp4")
model.predict_emotions("imgs/")
emotion_labels = model.labels
```

When tested using a 15-second video (clipped from [this video](https://youtu.be/99OsgN_SuE8)), it took a total of 4.94 seconds to convert the video and make the prediction. Because of the low accuracy of the model (as explained in the [`training notebook`](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/Training.ipynb)), the labels were not completely accurate to each frame. Here are some samples:

![sample1](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/readme_imgs/pre_1.PNG)

![sample2](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/readme_imgs/pre_2.PNG)

