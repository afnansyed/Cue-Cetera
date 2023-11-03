# Training Notebook Information

## Training structure
The following structure is used:

![file_structure](https://github.com/dianas11xx/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/file_structure.jpg)

## Pre-requisites to run
Before running the training folder, make sure you have the train datasets downloaded and put into a folder called `datasets` alongside the Training.ipynb notebook (as shown in the file structure image above):
- [`X_train_full`](https://drive.google.com/file/d/1cSCbA5oxufHqkWdI4BlkG9QyJDRqtNEd/view?usp=sharing)
- [`t_train_full`](https://drive.google.com/file/d/17xcpicJDM1EC7JGOf0ld15DPXqoFVLJV/view?usp=sharing)

The models created will be saved as a tensorflow lite model inside of a folder called `models` alongside the Training.ipynb notebook (as shown in the file structure image above).

Our most current model: ['model_15_rr_2.tflite'](https://drive.google.com/file/d/1USh3H_PvOOUPdZ9oBRdYtJangJ0y2vVk/view?usp=sharing)


# Release Candidate Model: Transfer Learning Model

One of the biggest updates for our release candidate model was creating our own custom dataset consisting of over 6k 224x224 grayscale images from the FER-2013, CK+, and JAFFE datasets. Our previous datasets had a significant amount of misclassifications and overlapping samples between a lot of the classes. We decided to incorporate other datasets since most of the research done on FER2013 revealed that it had a threshold of accuracy in the mid-70s, which was lower than our intended goal. As a result, our custom dataset has 6 emotions (Angry, Fear, Happy, Sad, Surprised, and Neutral), each with at least 800 samples. Updating our dataset has been something that dramatically increased the performance of the model. 

### Preprocessing
Previously, we have been applying RGB images directly to the model since most, if not all, transfer learning models expect RGB images. However, all of the images in our dataset are grayscale, and research has shown that deep-learning models that aim to find patterns in facial features and expressions don't need color information to make those distinctions, so we decided to apply only grayscale images to the model and update the preprocessing stage in the backend to incorporate these changes.

### Training
In our Release Candidate model, we used the pre-trained VGG16 architecture as the base of our model with ImageNet weights, and additional custom layers on top to perform transfer learning on our datasets. VGG16 is a 16-layer deep neural network that consists of a series of 13 2D convolutional layers, 5 max-pooling layers, and 3 fully connected layers. For the purposes of our model, we set all of the VGG16 layers to be trainable so that the weights could be refined to our data. Here is a summary of the model, along with its layers and trainable parameters:

![model_summary](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/modelSum.PNG)
The custom layers we added on top of the VGG16 layers include:
- `Flatten():` To flatten the output of the VGG16 layers into a 1D vector
- `Dense(128, activation=’relu’, regularizer=L2(1e-2)):` To create a fully connected layer with 128 neurons, relu activation function to mitigate the vanishing gradient problem and increase efficiency, and a ridge regularizer with a learning rate of 1e-2 to prevent overfitting.
- `BatchNormalization():` To help stabilize training and prevent overfitting.
- `Dropout(0.6):` To prevent overfitting and help the model learn different representations of the data.
- `Dense(6, activation=’softmax’):` Output layer with 6 neurons, each representing different emotions, with a softmax activation function since it is a multi-class classification task.

### Training/Validation Performance
To compile the model, we used Adam as the optimizer and sparse categorical cross-entropy as the loss function. We implemented a learning rate scheduler to dynamically adjust the learning rate of the optimizer whenever it starts to plateau. It monitors the validation loss and reduces the learning rate by a factor of 0.5 whenever the validation loss has no progression for 3 epochs. 

Using 300 epochs, a batch size of 64, the model converged with:
- 99% accuracy in training
- 92.50% accuracy in validation

![learning_curve_pre](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/learning%20curve.PNG)

We applied performance metrics like accuracy, precision, and recall to the validation data. Here is a summary of its performance:

![val_sum](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/per_met.PNG)

To get a deeper insight into the performance of the model, we used a confusion matrix to evaluate the true positives, true negatives, false positives, and false negatives. Here are the results:

![cm_val](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/con_mat.PNG)



### Testing Model Performance



# Beta Model: Transfer Learning Model 

### Preprocessing
One of the main focuses in our beta build was to fix any misclassifications or faulty data found in our dataset, such as highly pixelated images, since it was a factor that contributed to inaccurate results. As a group, we split up the dataset into emotions and manually cleaned each one.

In addition to updating the dataset, we applied data augmentation to the training set in order to fix the class imbalance, since emotions like Happy outweighed the others significantly. To balance the representation of each emotion, we created augmented images of each by applying a series of transformations like:
- Rotation
- Width/Height shift
- Shear range
- Zoom
- Horizontal Flip

and added them to the training dataset, making each emotion have the same number of samples.

### Training
In our Beta Model, we used the pre-trained VGG16 architecture as our base model with ImageNet weights to perform transfer learning on the datasets. 

We set all VGG16 layers to be trainable so that the weights could be updated and refined to our data. We also added custom layers on top of the VGG16 layers that were specific to our classification task. Here is a summary of the model, along with its layers:

![model_summary2](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/model_summary_beta.PNG)

Some of the custom layers we added on top of the VGG16 layers include 
- `Flatten`: To flatten the output of the VGG16 layers into a 1D vector
- `Dense(128, activation='relu')`: To create a fully connected layer with 128 neurons and relu activation to mitigate the vanishing gradient problem and increase efficiency
- `BatchNormalization()`: To help stabilize training and prevent overfitting 
- `Dropout(0.6)`: To prevent overfitting and help the model learn different representations of the data
- `Dense(6, activation='softmax')`: Output layer with 6 neurons, each representing different emotions, with a softmax activation function since it is a multi-class classification task.

### Training/Validation performance
When compiling the model, we used Adam as the optimizer and sparse categorical cross-entropy as the loss function since its a multi-class classification task.

We also implemented a learning rate scheduler to dynamically adjust the learning rate of the optimizer whenever it starts to plateau. It monitors the validation loss and reduces the learning rate by a factor of 0.5 whenever the validation loss has no progression for 3 epochs. This significantly helped with optimizing the learning rate hyper-tuning process.

Using 300 epochs, a batch size of 64, and specifying the class weights computed to account for class imbalance, the model converged with:
- 99.89% accuracy in training
- 72.21% accuracy in validation

![learning_curve_beta](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/Learning_curve_beta.PNG)

### Test Performance

Using the updated test datasets and labels, we applied the test data to the model and it converged with:
- 72.06% accuracy in testing

Here is a summary of its performance:

![test_sum_beta](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/test_sum_beta.PNG)

To get a deeper insight into the performance of the model, we used a confusion matrix to evaluate the true positives, true negatives, false positives, and false negatives. Here are the results:

![test_cm_beta](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/test_cm_beta.PNG)

### Observations

It's important to note that the distribution of the testing data is as follows:
| Emotion | # of Samples in Test Set | % of True Positives | 
| --- | --- | --- | 
| Angry | 1152 | 67.45% |
| Fear | 762 | 50.92% |
| Happy | 1827 | 86.80% |
| Sad | 994 | 60.26% |
| Surprised | 711 | 79.89% |
| Neutral | 1261 | 72.56% |

As we can see, Happy and Surprised have the highest percentage of true positives. Looking at the confusion matrix, we can see that:
- Fear is commonly misclassified as Sad
- Sad and Angry are commonly misclassified as Neutral
- And Neutral is commonly misclassified as Sad

Here are some examples of predictions made in the test set for every emotion along with their true label:

![angry_ex_b](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/angry_ex_b.PNG)

![fear_ex_b](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/Fear_ex_b.PNG)

![happy_ex_b](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/happy_ex_b.PNG)

![sad_ex_b](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/sad_ex_b.PNG)

![sur_ex_b](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/surprised_ex_b.PNG)

![Neutral_ex_b](https://github.com/AmaniN16/Cue-Cetera/blob/main/ModelControl/training/readme_imgs/neutral_ex.PNG)

As we can see, a lot of the images could be interpreted either way, such as the first image in the angry set which is classified as Neutral but predicted as Angry since the man in the image has straight/dark eyebrows and no specific expression, which makes him look angry. This can also be seen in the third image in the Neutral set, which is classified as Angry and predicted as Neutral mainly due to there being no discernible expression in the image, which means the image itself could be misclassified. A lot of these results also align with the confusion matrix, such as angry and neutral being confused for each other. 

Considering our dataset is over 33k images large, there could have been some misclassifications that we missed, which is something we plan on verifying again. We have seen improvement in training when lowering the complexity of the model and hyper-tuning the neurons in each custom layer, so it's something we will continue to do in an attempt to increase the accuracy. Our model is also overfitting significantly, so we plan on modifying the dropout rates and regularization terms in an attempt to avoid overfitting. 

# Alpha Model: Transfer Learning Model 

In Alpha  model, we used the pre-trained MobileNetV2 architecture as our base model with Imagenet set as the weights to perform transfer learning on the datasets. One of the main updates we did during training was using images of size 224x224 instead of 48x48. This allowed our model to be able to identify more patterns in the dataset. 

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


# Pre-Alpha Model: Convolutional Neural Network (CNN)

Our pre-alpha model (Model 3) is a convolution neural network, created using the sequential API, to classify images into one of 28 categories of emotions. The CNN consists of an input layer, hidden layers, and an output layer. For the hidden layers, we used a series of 2D convolutional layers to perform elementwise multiplication and then normalized the output of each layer by re-scaling and re-centering using batch normalization. After this, MaxPooling was used to downsample the images in order to extract the most important features and then a dropout layer was used to prevent overfitting. In the output layer, in order to transition from the convolutional layers to the fully connected layer, we used the Flatten method where all the dimensions are kept and put into one vector. The output layer has 28 neurons, since there are 28 classes of emotions, with a softmax activation. We decided to use Adam as the optimizer with a learning rate of 0.0001. We also used sparse categorical cross-entropy as our loss function since there are 28 label classes. A summary of the model, along with its layers is displayed in the following table:

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
