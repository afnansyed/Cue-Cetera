# Training Notebook Information

## Training structure
The following structure is used:

![file_structure](https://github.com/dianas11xx/Cue-Cetera/blob/main/ModelControl/readme_imgs/file_structure.jpg)

## Pre-requisites to run
Before running the training folder, make sure you have the train datasets downloaded and put into a folder called `datasets` alongside the training.ipynb notebook (as shown in the file structure image above):
- [`train_data`](https://drive.google.com/file/d/1i2jtb_qB7lU_q1wY92LdHxY2KueWIZGR/view?usp=sharing)
- [`train_labels`](https://drive.google.com/file/d/1wWGWjUqYe483GSULzRGE7Bp2iD9BUsv4/view?usp=sharing)

The models created will be saved as a pickle file inside of a folder called `models` alongside the training.ipynb notebook (as shown in the file structure image above).
The model that performed the best out of all 5 was model 3, so it was saved as a pickle file called `Model3_trained.pkl`, which is available to download below:
- [`Model3_trained.pkl`](https://drive.google.com/file/d/1UzJZCJAuHcSxOCfhjRrInMVtZSn-7g0W/view?usp=sharing)

## CNN Model 

Our current model (Model 3) is a convolution neural network, created using the sequential API, to classify images into one of 28 categories of emotions. The CNN consists of an input layer, hidden layers, and an output layer. For the hidden layers, we used a series of 2D convolutional layers to perform elementwise multiplication and then normalized the output of each layer by re-scaling and re-centering using batch normalization. After this, MaxPooling was used to downsample the images in order to extract the most important features and then a dropout layer is used to prevent overfitting. In the output layer, in order to transition from the convolutional layers to the fully connected layer, we used the Flatten method where all the dimensions are kept and put into one vector. The output layer has 28 neurons, since there are 28 classes of emotions, with a softmax activation. We decided to use Adam as the optimizer with a learning rate of 0.0001. We also used sparse categorical cross-entropy as our loss function since there are 28 label classes. A summary of the model, along with its layers is displayed in the following table:

![model_summary](https://github.com/dianas11xx/Cue-Cetera/blob/main/ModelControl/readme_imgs/full_ms.png)

Using an epoch of 25, each taking around 25 minutes, and a patience of 10, the model converged with:
- 54.22% accuracy in training
- 50.14% accuracy in validation

![learning_curve](https://github.com/dianas11xx/Cue-Cetera/blob/main/ModelControl/readme_imgs/learning_curve.png)

### Test performance

Using the test datasets and labels, we applied the test data to the model and it converged with:
- 48.30% accuracy in testing

This value is close to the validation accuracy score, meaning that the model is not overfitting. Here is a summary of its perforamnce:
![test_info](https://github.com/dianas11xx/Cue-Cetera/blob/main/ModelControl/readme_imgs/test_performance.png)

### Model observations

One of the main observations made during the training of this model was that the accuracy in the training and validation sets was continuously increasing with each epoch, so in the future, we plan to use a slightly higher learning rate and more epochs to see where the model performs the best. Also, when the model was applied to our test sets, the accuracy was 48.30%, which is close to our validation accuracy, meaning that the model is not overfitting, but the parameters still need tuning since the accuracy is low. 

We also plan to continue experimenting with the MobileNetV2 with the Imagenet as the weights to perform transfer learning on the datasets with unfrozen layers. 



