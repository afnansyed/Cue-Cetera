# Cue-Cetera
GitHub Repository for CpE Design project Cue-Cetera

## Project System Architecture

Our project follows the following system structure:

![sys_diagram](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/system_diagram.png)

We use Firebase to store the video the user uploads. This allows the app server to access the video in order to convert it into frames and apply the machine learning model to the set of images. In doing so, it creates a folder of the frames extracted from the video, with their corresponding timeframes, along with an array of labels that map to each frame. The folder and array are then uploaded to Firebase so it could be accessed by the front end.

More information about the the video conversion and prediction can be found [here](https://github.com/AmaniN16/Cue-Cetera/tree/main/ModelControl).

More information about the CNN Model and training methods used for the model can be found [here](https://github.com/AmaniN16/Cue-Cetera/tree/main/ModelControl/training).
 
More information about the Flutter Application can be found [here](https://github.com/AmaniN16/Cue-Cetera/tree/main/cue_cetera)

We logged each of our contributions in the following [table](https://github.com/AmaniN16/Cue-Cetera/blob/main/TeamContibutionsLog.md)


## Datasets
----
The dataset we are using to train our machine learning model was made using datasets from the [FER-2013](https://www.kaggle.com/datasets/msambare/fer2013) and [EMOTIC](https://s3.sunai.uoc.edu/emotic/index.html) datasets. The train and test data files consist of 224x224 images that correspond to the train/test labels, which match each image to an emotion. 

In total, there are 7 emotions.

### Shape of data files:
```
train_data   :   (29994, 224, 224, 3) 
train_labels :   (29994,)
test_data    :   (7598, 224, 224, 3) 
test_labels  :   (7598,)
```


### How to load the datasets
Our project has the following file structure for the model system:

![file_str](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/file_str.png)

Download the following datasets and place them in a `datasets` folder as shown in the diagram above:
- [`train_data.npy`](https://drive.google.com/file/d/1i2jtb_qB7lU_q1wY92LdHxY2KueWIZGR/view?usp=sharing)
- [`train_labels.npy`](https://drive.google.com/file/d/1W0QuMZmwaUrRuHqyv2o0EeZpldsXgbuk/view?usp=drive_link)
- [`test_data.npy`](https://drive.google.com/file/d/1gx1xulZUNzYMWoFcdpNYKwLXoBclme25/view?usp=sharing)
- [`test_labels.npy`](https://drive.google.com/file/d/1cT88dypR13W8nO-k4d_n82tUI6oPq7Fk/view?usp=drive_link)

Example of loading data:

```
X_train = np.load('train_data.npy')
t_train = np.load('train_labels.npy')
```

`t_train[0]` returns an array of size 1 that corresponds to the first image in `X_train`, where `t_train[0]` is the label corresponding to the emotion.

## Emotional Classifications
Our model assigns every frame within the requested video a value of 0 to 6. This value corresponds to the emotion being displayed within that frame, and follows this mapping:

0) Disapproving
1) Angry
2) Fearful
3) Happy
4) Sad
5) Surprised
6) Neutral

These classifications are then dislayed on the front-end through text, along with a symbol representing whether that emotion is positive, negative, or neutral.

Positive contains: Happy and Surprised

Negative contains: Disapproving, Angry, Fearful, and Sad

Neutral contains: Neutral.

## Mockup of App Interface
----

![mock](https://user-images.githubusercontent.com/44105687/228713447-0aa8bc12-45b7-43fb-868b-49f98540b667.PNG)


## Google Firebase Database
----
The database storing the filepath for each video uploaded by the user

![fire1](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/firebase_img_1.png)

The database storing the video itself for each video uploaded by the user

![fire2](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/firebase_img_2.png)
