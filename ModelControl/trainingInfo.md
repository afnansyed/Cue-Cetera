# Training Notebook Informaation

## Training structure
The following structure is used:

## Pre-requesties to run
Before running the training folder, make sure you have the train datasets downloaded and put into a folder called `datasets` alongside the training.ipynb notebook (as shown in the file structure image above):
- [`train_data`](https://drive.google.com/file/d/1i2jtb_qB7lU_q1wY92LdHxY2KueWIZGR/view?usp=sharing)
- [`train_labels`](https://drive.google.com/file/d/1wWGWjUqYe483GSULzRGE7Bp2iD9BUsv4/view?usp=sharing)

The models created will be saved as a pickle file inside of a folder called `models` alongside the training.ipynb notebook (as shown in the file strcture img above).
The model that performed the best out of all 5 was model 3, so it was saved as a pickle file called `Model3_trained.pkl`, which is avaliable to download below:
- [`Model3_trained.pkl`](https://drive.google.com/file/d/1UzJZCJAuHcSxOCfhjRrInMVtZSn-7g0W/view?usp=sharing)

## CNN Model 

Our current model is a convolution neural network, created using the sequential API, to classify images to one of 28 categories of emotions. The CNN consists of an input layer, hidden layers and an output layers. For the input layer, we used a series of 2D convolutional layers to perform elementwise multiplication and then normalized the output of each layer by re-scaling and re-centering using batch normalization. 
