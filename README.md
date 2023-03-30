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
The dataset we are using to train our machine learning model was made using datasets from the [FER-2013](https://www.kaggle.com/datasets/msambare/fer2013) and [EMOTIC](https://s3.sunai.uoc.edu/emotic/index.html) datasets. The train and test data files consist of 48x48 images that correspond to the train/test labels, which match each image to an emotion. 

In total, there are 28 emotions.

### Shape of data files:
```
train_data   :   (51975, 48, 48, 3) 
train_labels :   (51975,)
test_data    :   (10493, 48, 48, 3) 
test_labels  :   (10493,)
```


### How to load the datasets
Our project has the following file structure for the model system:

![file_str](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/file_str.png)

Download the following datasets and place them in a `datasets` folder as shown in the diagram above:
- [`train_data`](https://drive.google.com/file/d/1i2jtb_qB7lU_q1wY92LdHxY2KueWIZGR/view?usp=sharing)
- [`train_labels`](https://drive.google.com/file/d/1wWGWjUqYe483GSULzRGE7Bp2iD9BUsv4/view?usp=sharing)
- [`test_data`](https://drive.google.com/file/d/1gx1xulZUNzYMWoFcdpNYKwLXoBclme25/view?usp=sharing)
- [`test_labels`](https://drive.google.com/file/d/1LmztIEkIW4gpPW-r6Nr7rIVdogPca7p1/view?usp=sharing)

Example of loading data:

```
X_train = np.load('data_train.npy')
t_train = np.load('labels_train.npy')
```

`t_train[0]` returns an array of size 1 that corresponds to the first image in `X_train`, where `t_train[0]` is the label corresponding to the emotion.


### Valence mapping of 28 Emotions:
For each emotion, we mapped the valence, which is a value between 0-9 that represents the positive/negative scale of each emotion (9 being the most positive and 0 being the most negative).
- `0. Affection`: 8
- `1. Anger`: 3
- `2. Annoyance`: 3
- `3. Anticipation`: 6
- `4. Aversion`: 5
- `5. Confidence`: 6
- `6. Disapproval`: 3
- `7. Disconnection`: 5
- `8. Disquietment`: 5
- `9. Doubt/Confusion`: 5
- `10. Embarrassment`: 5
- `11. Engagement`: 7
- `12. Esteem`: 6  
- `13. Excitement`: 7
- `14. Fatigue`: 5
- `15. Fear`: 5
- `16. Happiness`: 9
- `17. Pain`: 3
- `18. Peace`: 6
- `19. Pleasure`: 6
- `20. Saddness`: 4
- `21. Sensitivity`: 6
- `22. Suffering`: 5
- `23. Surprise`: 6
- `24. Sympathy`: 7
- `25. Yearning`: 6
- `26. Disgust`: 4
- `27. Neutral`: 5



## Mockup of App Interface
----

![mock](https://user-images.githubusercontent.com/44105687/228713447-0aa8bc12-45b7-43fb-868b-49f98540b667.PNG)


## Google Firebase Database
----
The database storing the filepath for each video uploaded by the user

![fire1](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/firebase_img_1.png)

The database storing the video itself for each video uploaded by the user

![fire2](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/firebase_img_2.png)
