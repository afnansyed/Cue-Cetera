# cue_cetera

Flutter project written using dart.
Main code for the app written in 'cue_cetera/lib/main.dart'

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

- Priority Issue to Fix: In the video playback page, when clicking play, the video stops at the first frame. We haven't been able to fix this.
  - We think the issue might be with this instance of code where program is directed after clicking the play button:
   ![Capture2](https://user-images.githubusercontent.com/44105687/228716490-16c6895c-c482-4efd-8401-98c3ad4b2f34.PNG)


- To send the video to the backend, we first thought of using Rest API where when video is played, the path url is sent to the http localhost. However, we first ran into issues with the python code for this where the localhost was giving a 404 error. We also try different methods of writing code with the dart to write the path out using Rest API. We decided to use firebase for now which is compatible with both python and flutter. We had issues with flutter uploading the video file to the database. As no errors were being generated and the logic that we are apply with code seemed correct, its was harder to debug the issue. However,, we got it to successfully work.

<img width="958" alt="firebase_img_1" src="https://user-images.githubusercontent.com/44105687/228723575-a9668f42-4381-4d1d-bc18-4369388e2bde.png">

<img width="954" alt="firebase_img_2" src="https://user-images.githubusercontent.com/44105687/228723596-fdaaa734-ae09-4b74-89fb-3d3591c6da87.png">

- We installed Flutter and Android Studio on the CpE Lab Comupter which gives us a better access with Android device emulator. However, since this is a lab computer we had to gain administrative access for many steps from Instructor Carsten. We are setting up to testing with a physical android tablet to run our app as it might be more convenient and help with debugging such as catching gliches. We have access to a Samsung Galexy Tab 4. But since it is an older model we might run into some compatibility issues and so, we as a team will look into pitching in to invest in an android device.
- Emmulator used below: Google Pixel 6


Current pages setup status:
---------------	
```
1. HOMPAGE:
```

![144dc9bd-27c1-47fc-ba2e-797e21ac1cc3](https://user-images.githubusercontent.com/44105687/228425748-3ad0cc52-328d-436e-862c-0751cda8101e.jpg)


```
2. UPLOAD VIDEO PAGE:
```

![a5f104ab-1d1b-462d-a685-552e6d04a5f3](https://user-images.githubusercontent.com/44105687/228425785-da94631b-b0ea-4a93-809e-5ba26a549148.jpg)


```
3. PICK VIDEO FROM DEVICE:
```

![34e95a7a-f85b-443a-a5d6-29f24e821038](https://user-images.githubusercontent.com/44105687/228425794-c82b6608-aaf8-4bcd-a638-50ec1a4d5289.jpg)


```
4. PLAY VIDEO:
```

![d2716f80-406c-4c03-9b80-b4904456de79](https://user-images.githubusercontent.com/44105687/228425815-a97c73bc-67a8-41c5-bbe2-0effce62b0cc.jpg)


```
5. USE VIDEO CAMERA PAGE:
```

![26a0de84-8a93-4049-9cad-ce714d25bc6f](https://user-images.githubusercontent.com/44105687/228425838-c4f263a6-ab91-4f3a-899e-c6ccdcd03c8c.jpg)


