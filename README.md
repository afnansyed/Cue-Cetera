# Cue-Cetera
GitHub Repository for CpE Design project Cue-Cetera

## Project System Architecture

Our project follows the following system structure:

![sys_diagram](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/system_diagram.png)

We use Firebase to store the video the user uploads. This allows the app server to access the video in order to convert it into frames and apply the machine learning model to the set of images. In doing so, it creates a folder of the frames extracted from the video, with their corresponding timeframes, along with an array of labels that map to each frame. The folder and array are then uploaded to Firebase so it could be accessed by the front end.

More information about the the video conversion and prediction can be found [here]([https://github.com/AmaniN16/Cue-Cetera/tree/main/ModelControl](https://github.com/AmaniN16/Cue-Cetera/tree/main/cue_cetera/assets)).

For more information about the Transfer Learning Model and training methods used, please read the documentation for the [`Training Notebook here`](https://github.com/AmaniN16/Cue-Cetera/tree/main/ModelControl/training#training-notebook-information).
 
More information about the Flutter Application can be found [here](https://github.com/AmaniN16/Cue-Cetera/tree/main/cue_cetera)

We logged each of our contributions in the following [table](https://github.com/AmaniN16/Cue-Cetera/blob/main/TeamContibutionsLog.md)


## Datasets
----
We created our own custom dataset using images from the [FER-2013](https://www.kaggle.com/datasets/msambare/fer2013), [CK+](https://www.jeffcohn.net/Resources/), and [JAFFE](https://zenodo.org/records/3451524) datasets. The training and validation data files consist of 224x224 grayscale images that correspond to the train/validation labels, which match each image to an emotion.

In total, there are 6 emotions.

### Shape of data files:
```
X_train_full	:   (4665, 224, 224, 1) 
t_train_full 	:   (4665,)
X_val_full	:   (2000, 224, 224, 1) 
t_val_full	:   (2000,)
```


### How to load the datasets
Our project has the following file structure for the model system:

![file_str](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/file_str.png)

Download the following datasets and place them in a `datasets` folder as shown in the diagram above:
- [`X_train_full.npy`](https://drive.google.com/file/d/1cSCbA5oxufHqkWdI4BlkG9QyJDRqtNEd/view?usp=sharing)
- [`t_train_full.npy`](https://drive.google.com/file/d/17xcpicJDM1EC7JGOf0ld15DPXqoFVLJV/view?usp=sharing)

Example of loading data:

```
X_train = np.load('X_train_full.npy')
t_train = np.load('t_train_full.npy')
```

`t_train[0]` returns an array of size 1 that corresponds to the first image in `X_train`, where `t_train[0]` is the label corresponding to the emotion.

## Emotional Classifications
Our model assigns every frame within the requested video a value of 0 to 6. This value corresponds to the emotion being displayed within that frame, and follows this mapping:


0) Angry
1) Fearful
2) Happy
3) Sad
4) Surprised
5) Neutral

These classifications are then displayed on the front-end through text, along with a symbol representing whether that emotion is positive, negative, or neutral.

Positive contains: Happy and Surprised

Negative contains: Angry, Fearful, and Sad

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
Code for the app written in different modules for every page and service.


## Steps to build and run project:

1. Install  + Setup Flutter and Android studio: https://docs.flutter.dev/get-started/install
2. Open project in Android studio. (File > Open Folder)
Set-up Flutter plug-in in settings. (File > Settings > Plugins > Install Flutter)
If errors are shown in files, run ‘pub get’ in the terminal.
3. Download the `model_15.tflite` file from [here](https://drive.google.com/file/d/1MiKzIqyuHmmhGYj4pSG5jFfeIhcSOwX7/view?usp=sharing) and place it in the cue_cetera/assets folder. 

4. Run project after connecting the tablet or setting up an emulator that has Google Play functionality (Enable developer and USB debugging mode) https://docs.flutter.dev/get-started/test-drive?tab=androidstudio 
    - NOTE: An error will pop up related to tflite, to fix this do the following:
        - Go to the "Flutter Plugins" folder in "External Libraries".
        
        ![flutter_fix_img](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/flutter_fix_1.png)

            - If this folder is not available, navigate to your "AppData" folder on your computer if using Windows, then Local>Pub>Cache>hosted>pub.dev

        ![flutter_fix_if_not](https://github.com/AmaniN16/Cue-Cetera/blob/4d0b2031c48115c1a66b6e22216a2d05c94d0e89/readme_imgs/flutter_fix_if_not.png)
        - Navigate to the "tflite-1.1.2" folder then to "android" and edit the "build.gradle" file.
        ![flutter_fix_build_gradle](https://github.com/AmaniN16/Cue-Cetera/blob/4d0b2031c48115c1a66b6e22216a2d05c94d0e89/readme_imgs/flutter_fix_2.png)

        - Scroll down to the dependencies{} block inside the android{} block and replace the word `compile` with `implementation` and save the file. It should run successfully.
        ![flutter_fix_compile](https://github.com/AmaniN16/Cue-Cetera/blob/5bb681c4145e3776a2dbb816b10bcb4bcc486ea0/readme_imgs/flutter_fix_3.png)
        ![flutter_fix_implementation](https://github.com/AmaniN16/Cue-Cetera/blob/5bb681c4145e3776a2dbb816b10bcb4bcc486ea0/readme_imgs/flutter_fix_4.png)



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

- To connect the frontend to the backend we are using a combination of Firebase, Firebase Functions, and Google Cloud Run to convert the video to image frames. The ML model we are using is a Tflite model to make the predictions on the frontend.
  
- We installed Flutter and Android Studio on the CpE Lab Comupter which gives us a better access with Android device emulator. However, since this is a lab computer we had to gain administrative access for many steps from Instructor Carsten. We are setting up to testing with a physical android tablet to run our app as it might be more convenient and help with debugging such as catching gliches. We have access to a Samsung Galexy Tab 4. But since it is an older model we might run into some compatibility issues and so, we as a team will look into pitching in to invest in an android device.
  
- As of the Beta build, model predictions have been fully integrated. Before forming a prediction on a frame, [Google ML Kit's Face Detection](https://developers.google.com/ml-kit/vision/face-detection) was used to check if a face was present in the frame. Currently, if a face is not detected it will set the emotion as neutral. If a face is detected it will be sent to be classified by our custom model. The model has been packaged into a Tflite file and Flutter's [Tflite package](https://pub.dev/packages/tflite) has been used to form a prediction on each frame.
	- The output is stored in a map with the Timestamp being a key and the classification being the value which is then converted to the Timestamp Class to display on the results display page. The model is currently downloaded separately and added to assets, but Firebase ML will be integrated in the next build to prevent this extra step.
- Emmulator used below: Google Pixel 6


## Current App Flow Diagram
![app_flow_diagram](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/app_flow_diagram.png?raw=true)

<br />
<br />

## Current pages setup status:

### 1. HOME PAGE:


![home](https://github.com/AmaniN16/Cue-Cetera/assets/44105687/b6272a17-dab2-4721-9db3-cf0b8ae9bfb1)

<br />


### 2. ABOUT PAGE:

![about_Page](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/info.png?raw=true)

<br />

### 3. SETTINGS PAGE:

![settings_Page](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/settings.png?raw=true)


<br />

### 4. PICK VIDEO FROM DEVICE PAGE PAGE:

![video_picker](https://user-images.githubusercontent.com/44105687/228425794-c82b6608-aaf8-4bcd-a638-50ec1a4d5289.jpg)

<br />


<br />

### 5. RECORD VIDEO PAGE:

![record_video](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/camera.png?raw=true)

<br />

### 6. PROCESSING PAGE:
![processing page](https://github.com/AmaniN16/Cue-Cetera/assets/44105687/12c522cc-263d-425a-beea-01b1a9ef12f6)


<br />

### 7. RESULTS PAGE:

![results_Page](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/results_display_new.png?raw=true)

<br />

### 8. RESULTS INFO PAGE:

![results_info_Page](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/results_info.png?raw=true)
