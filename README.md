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
- [`train_data.npy`](https://drive.google.com/file/d/1I5tPiknclCqdPgPZH2zK3ezgVcX1BA-U/view?usp=sharing)
- [`train_labels.npy`](https://drive.google.com/file/d/1W0QuMZmwaUrRuHqyv2o0EeZpldsXgbuk/view?usp=drive_link)
- [`test_data.npy`](https://drive.google.com/file/d/18VcyGCQeLSblP95oCWLCzAFGhiFBq3Xq/view?usp=sharing)
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


# cue_cetera project details

Flutter project written using dart.
Main code for the app written in 'cue_cetera/lib/main.dart'


## Steps to build and run project:


- Front-end:

1. Install  + Setup Flutter and Android studio: https://docs.flutter.dev/get-started/install

2. Open project in Android studio. (File > Open Folder)

3. Set-up Flutter plug-in in settings. (File > Settings > Plugins > Install Flutter)

4. If errors are shown in files, run ‘pub get’ in the terminal.

5. Run project after connecting the tablet (Enable developer and USB debugging mode) https://docs.flutter.dev/get-started/test-drive?tab=androidstudio 

6. Home Screen/ Main Menu: Upload video or use video camera options 

    i. Click on upload video 

   ii. Select a 50 MB or less video from gallery/local device

iii. Click play button to playback the video

8.   Home Screen/ Main Menu: Upload video or use video camera options

    i.  Click on use video camera
   
   ii. Record a video using the camera

  iii. Click play button to playback the video 

- Back-end:

1. Download and setup python on computer device.

  i. https://www.python.org/downloads/

2. Use terminal to:

 i. pip install  numpy tensorflow firebase-admin opencv-python flask

3. Read README in ModelControl/training to download pkl file.

4. Go to cue-cetera/assets.

5. Add pkl file to this folder.

6. Run python predictLabels.py



# Project Documentation

	https://github.com/AmaniN16/Cue-Cetera

Comments / experimentation / failed attempts / difficulties:
---------------	
- Flutter and Android Studio are the platforms used for development of the app.
- All members of the team have it installed on their personal computer devices.
- Installation and set up of Flutter + Android Studio took quite a while (~1.5 hrs) on the pc. 
- First the homepage with the two buttons was setup. This was slightly confusing as we had to first familiarize ourselves with dart and the flutter environment. 
- While doing this page, we run the emulator which was another one of our issues. When running an android device emulator, our personal laptops started freezing up and was really slow at loading. We used chrome web emulator as a temporary alternative. After this, the 'upload video' and the 'use video camera' pages where set up which could be access throught the corresponding button on the homepage. 
- The Upload video page and the play video page took quite a bit of research time as we had to access the device files which required use of different libraries.
- To make sure th user has uploaded a video of the right size, we check for the file size of the selected video and print out a message:
  ![Capture3](https://user-images.githubusercontent.com/44105687/228719377-00f5d4e9-f3c1-4691-988d-b1c869cf0de4.PNG)

- To send the video to the backend, we first thought of using Rest API where when video is played, the path url is sent to the http localhost. However, we first ran into issues with the python code for this where the localhost was giving a 404 error. We also try different methods of writing code with the dart to write the path out using Rest API. We decided to use firebase for now which is compatible with both python and flutter. We had issues with flutter uploading the video file to the database. As no errors were being generated and the logic that we are apply with code seemed correct, its was harder to debug the issue. However,, we got it to successfully work.

- We installed Flutter and Android Studio on the CpE Lab Comupter which gives us a better access with Android device emulator. However, since this is a lab computer we had to gain administrative access for many steps from Instructor Carsten. We are setting up to testing with a physical android tablet to run our app as it might be more convenient and help with debugging such as catching gliches. We have access to a Samsung Galexy Tab 4. But since it is an older model we might run into some compatibility issues and so, we as a team will look into pitching in to invest in an android device.
- Emmulator used below: Google Pixel 6


Current pages setup status:
---------------	
```
1. HOME PAGE:
```

![MicrosoftTeams-image](https://github.com/AmaniN16/Cue-Cetera/assets/44105687/e4d19ffa-c6c8-45db-bb31-71de08054d84)


```
2. ABOUT PAGE:
```

![MicrosoftTeams-image (1)](https://github.com/AmaniN16/Cue-Cetera/assets/44105687/6e55805d-82fe-45b4-b770-be0a0db5f94e)




```
3. UPLOAD VIDEO PAGE:
```

![MicrosoftTeams-image](https://github.com/AmaniN16/Cue-Cetera/assets/44105687/fe66433c-6e4c-4758-925a-2cf07d774ce7)




```
4. PICK VIDEO FROM DEVICE PAGE PAGE:
```

![34e95a7a-f85b-443a-a5d6-29f24e821038](https://user-images.githubusercontent.com/44105687/228425794-c82b6608-aaf8-4bcd-a638-50ec1a4d5289.jpg)



```
5. RESULTS PAGE:
```

![MicrosoftTeams-image (3)](https://github.com/AmaniN16/Cue-Cetera/assets/44105687/98102289-037b-49b4-a6f0-8c37d6236965)


