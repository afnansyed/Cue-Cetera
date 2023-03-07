# Cue-Cetera
GitHub Repository for CpE Design project Cue-Cetera

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

Download the following datasets:
- [`train_data`](https://drive.google.com/file/d/1i2jtb_qB7lU_q1wY92LdHxY2KueWIZGR/view?usp=sharing)
- [`train_labels`](https://drive.google.com/file/d/1wWGWjUqYe483GSULzRGE7Bp2iD9BUsv4/view?usp=sharing)
- [`test_data`](https://drive.google.com/file/d/1gx1xulZUNzYMWoFcdpNYKwLXoBclme25/view?usp=sharing)
- [`test_labels`](https://drive.google.com/file/d/1LmztIEkIW4gpPW-r6Nr7rIVdogPca7p1/view?usp=sharing)

Example of loading data:

```
X_train = np.load('data_train.npy)
t_train = np.load('labels_train.npy)
```

`t_train[0]` returns an array of size 1 that corresponds to the first image in `X_train`, where `t_train[0][0]` is the label corresponding to the emotion.
