# cue_cetera

Flutter project written using dart.
Code for the app written in different modules for each page and service.

Comments / experimentation / failed attempts / difficulties:
---------------	
- Flutter and Android Studio are the platforms used for development of the app.
- All members of the team have it installed on their personal computer devices.
- Installation and set up of Flutter + Android Studio took quite a while (~1.5 hrs) on the pc. 
- First the homepage with the two buttons was setup. This was slightly confusing as we had to first familiarize ourselves with dart and the flutter environment. 
- While doing this page, we run the emulator which was another one of our issues. When running an android device emulator, our personal laptops started freezing up and was really slow at loading. We used chrome web emulator as a temporary alternative. After this, the 'upload video' and the 'use video camera' pages where set up which could be access throught the corresponding button on the homepage. 
- The Upload video page and the play video page took quite a bit of research time as we had to access the device files which required use of different libraries.
- To make sure the user has uploaded a video of the right size, we check for the file size of the selected video and print out a message:
  ![Capture3](https://user-images.githubusercontent.com/44105687/228719377-00f5d4e9-f3c1-4691-988d-b1c869cf0de4.PNG)

- FIXED ~~Priority Issue to Fix: In the video playback page, when clicking play, the video stops at the first frame. We haven't been able to fix this.~~
 ~~- We think the issue might be with this instance of code where program is directed after clicking the play button:~~
   ![Capture2](https://user-images.githubusercontent.com/44105687/228716490-16c6895c-c482-4efd-8401-98c3ad4b2f34.PNG)


- FIXED ~~To send the video to the backend, we first thought of using Rest API where when video is played, the path url is sent to the http localhost. However, we first ran into issues with the python code for this where the localhost was giving a 404 error. We also try different methods of writing code with the dart to write the path out using Rest API. We decided to use firebase for now which is compatible with both python and flutter. We had issues with flutter uploading the video file to the database. As no errors were being generated and the logic that we are apply with code seemed correct, its was harder to debug the issue. However,, we got it to successfully work.~~
- Currently using a combination of Firebase, Firebase Functions, and Google Cloud Run to convert the video to image frames. The code for this is in the [main.py](https://github.com/AmaniN16/Cue-Cetera/blob/6b477ab1608f68f2172d61bb62d54d6c39f9ced5/cue_cetera/cue_cetera_functions/main.py) in the cue_cetera_functions folder.
  
<img width="958" alt="firebase_img_1" src="https://user-images.githubusercontent.com/44105687/228723575-a9668f42-4381-4d1d-bc18-4369388e2bde.png">

<img width="954" alt="firebase_img_2" src="https://user-images.githubusercontent.com/44105687/228723596-fdaaa734-ae09-4b74-89fb-3d3591c6da87.png">

- FIXED ~~We installed Flutter and Android Studio on the CpE Lab Comupter which gives us a better access with Android device emulator. However, since this is a lab computer we had to gain administrative access for many steps from Instructor Carsten. We are setting up to testing with a physical android tablet to run our app as it might be more convenient and help with debugging such as catching gliches. We have access to a Samsung Galexy Tab 4. But since it is an older model we might run into some compatibility issues and so, we as a team will look into pitching in to invest in an android device.~~
- We bought an android tablet to perform testing on.

- Before forming a prediction on a frame, [Google ML Kit's Face Detection](https://developers.google.com/ml-kit/vision/face-detection) was used to check if a face was present in the frame. Currently, if a face is not detected it will set the emotion as neutral. If a face is detected it will be sent to be classified by our custom model.
- The model has been packaged into a Tflite file and Flutter's [Tflite package](https://pub.dev/packages/tflite) has been used to form a prediction on each frame. The output is stored in a map with the Timestamp being a key and the classification being the value which is then converted to the Timestamp Class to display on the results display page. The model is currently downloaded separately and added to assets, but Firebase ML will be integrated in the next build to prevent this extra step.
- The code for Firebase calling and model prediction is all on the [firebase_services.dart](https://github.com/AmaniN16/Cue-Cetera/blob/a1de08926808581dde53309c216e462c955af391/cue_cetera/lib/services/firebase_services.dart) file.
  
- Emmulator used below: Google Pixel 6


## Current App Flow Diagram
![app_flow_diagram](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/app_flow_diagram.png?raw=true)

<br />
<br />

## Current pages setup status:

### 1. HOME PAGE:


![home_Page](https://raw.githubusercontent.com/AmaniN16/Cue-Cetera/5f7ea7ecb89b470617f62e96521c0d4eabf2ef15/readme_imgs/homepage.png)

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
![processing_Page](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/processing.png?raw=true)

<br />

### 7. RESULTS PAGE:

![results_Page](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/results_display_new.png?raw=true)

<br />

### 8. RESULTS INFO PAGE:

![results_info_Page](https://github.com/AmaniN16/Cue-Cetera/blob/main/readme_imgs/results_info.png?raw=true)
