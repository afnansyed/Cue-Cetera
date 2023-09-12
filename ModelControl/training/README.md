# Training Notebook Information

## Training structure
The following structure is used:

![file_structure](https://github.com/dianas11xx/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/file_structure.jpg)

## Pre-requisites to run
Before running the training folder, make sure you have the train datasets downloaded and put into a folder called `datasets` alongside the training.ipynb notebook (as shown in the file structure image above):
- [`train_data`](https://drive.google.com/file/d/1I5tPiknclCqdPgPZH2zK3ezgVcX1BA-U/view?usp=sharing)
- [`train_labels`](https://drive.google.com/file/d/1W0QuMZmwaUrRuHqyv2o0EeZpldsXgbuk/view?usp=drive_link)

The models created will be saved as a pickle file and tensorflow lite model inside of a folder called `models` alongside the Training.ipynb notebook (as shown in the file structure image above).

Our most current model: ['model.tflite'](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/models/model.tflite), 


## Pre-Alpha Model: Convolutional Neural Network (CNN)

Our pre-alpha model (Model 3) is a convolution neural network, created using the sequential API, to classify images into one of 28 categories of emotions. The CNN consists of an input layer, hidden layers, and an output layer. For the hidden layers, we used a series of 2D convolutional layers to perform elementwise multiplication and then normalized the output of each layer by re-scaling and re-centering using batch normalization. After this, MaxPooling was used to downsample the images in order to extract the most important features and then a dropout layer is used to prevent overfitting. In the output layer, in order to transition from the convolutional layers to the fully connected layer, we used the Flatten method where all the dimensions are kept and put into one vector. The output layer has 28 neurons, since there are 28 classes of emotions, with a softmax activation. We decided to use Adam as the optimizer with a learning rate of 0.0001. We also used sparse categorical cross-entropy as our loss function since there are 28 label classes. A summary of the model, along with its layers is displayed in the following table:

![model_summary](https://github.com/dianas11xx/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/full_ms.PNG)

Using an epoch of 25, each taking around 25 minutes, and a patience of 10, the model converged with:
- 54.22% accuracy in training
- 50.14% accuracy in validation

![learning_curve](https://github.com/dianas11xx/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/learning_curve.PNG)

### Test performance

Using the test datasets and labels, we applied the test data to the model and it converged with:
- 48.30% accuracy in testing

This value is close to the validation accuracy score, meaning that the model is not overfitting. Here is a summary of its performance:

![test_info](https://github.com/dianas11xx/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/test_performance.PNG)

### Model observations

One of the main observations made during the training of this model was that the accuracy in the training and validation sets was continuously increasing with each epoch, so in the future, we plan to use a slightly higher learning rate and more epochs to see where the model performs the best. Also, when the model was applied to our test sets, the accuracy was 48.30%, which is close to our validation accuracy, meaning that the model is not overfitting, but the parameters still need tuning since the accuracy is low. 

# Alpha Model: Transfer Learning Model 

In our current model, we used the pre-trained MobileNetV2 architecture as our base model with Imagenet set as the weights to perform transfer learning on the datasets. One of the main updates we did during training was using images of size 224x224 instead of 48x48. This allowed our model to be able to identify more patterns in the dataset. 

We made all the pre-trained weights trainable since our dataset is large and may need to tune some of the weights in order to get a more accurate prediction. We also added self-defined layers to the top and bottom of the model so that it could be more defined to our dataset and problem. In the input layer, we added 2 additional layers that perform data augmentation to the dataset, which would make the data the model is being trained on more distinct, allowing the model to be more adaptive to unique data, such as images taken at an angle. We then pass it through the mobilenet_v2 preprocessing function that scales the pixel values between -1 and 1 for the base model. The hidden layers of the model consist of the MobileNetV2 base model layers, a Global Average Pooling layer, and a Dropout layer of 0.2 intensity to prevent overfitting. Our output layer had 7 neurons, each representing different emotions, with a softmax activation function, since it is a multi-class classification task, and an L2 regularizer with a learning rate of 1e-2 to prevent overfitting. 

When compiling the model, we used Adam as the optimizer with a learning rate of 1e-7 and sparse categorical cross-entropy as our loss function since there are 7 classes. 

Using an epoch of 50, batch size of 32, and patience of 5, the model converged with:
- 76.97% accuracy in training
- 66.89% accuracy in validation


![learning_curve](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/Learning_curve2.png)

### Test performance

Using the test datasets and labels, we applied the test data to the model and it converged with:
- 65.53% accuracy in testing

Here is a summary of its performance:

![test_info](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/test_per2.png)

Here are some examples of predictions made in the test set for every emotion:

![dis_ex](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/disapproval_ex.png)
![angry_ex](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/angry_ex.png)
![fear_ex](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/fear_ex.png)
![happy_ex](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/happy_ex.png)
![sad_ex](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/sad_ex.png)
![sur_ex](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/surprised_ex.png)
![Neutral_ex](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/neutral_ex.png)


### Model observations

One of the main observations made during the training of this model was that the accuracy in the training and validation sets started increasing gradually as the number of epochs increased, but the validation accuracy didn't go above 66% even when the training accuracy kept going up, which meant the model started to overfit. We plan on experimenting with different regularizers and adding more layers to the top layer to decrease overfitting in the model and increase the accuracy in testing.
