# Cue-Cetera
GitHub Repository for CpE Design project Cue-Cetera

## Datasets
----
The dataset we are using to train our machine learning model was made using datasets from the [FER-2013](https://www.kaggle.com/datasets/msambare/fer2013) and [EMOTIC](https://s3.sunai.uoc.edu/emotic/index.html) datasets. The train and test data files consist of 48x48 images that correspond to the train/test labels, which match each image to an emotion. 

In total, there are 28 emotions.

### Shape of data files:
```
train_data   :   (51975, 48, 48, 3) 
train_labels :   (51975, 2)
test_data    :   (10493, 48, 48, 3) 
test_labels  :   (10493, 2)
```


### How to load the datasets

Download the following datasets:
- [`train_data`](https://drive.google.com/file/d/12QDb71SQnwhGzMomq2PHXaTFtb8SW3CH/view?usp=sharing)
- [`train_labels`](https://drive.google.com/file/d/1fXeNpeEwm9vSEWlln8Fgte4vz2-fL7qY/view?usp=sharing)
- [`test_data`](https://drive.google.com/file/d/1GeD7xCBOCFEbDc8Ly-Bc9TWAiD-jCEQg/view?usp=sharing)
- [`test_labels`](https://drive.google.com/file/d/1Q0xs_LpzsPHFib5vlBuA8owtc-2w9bCi/view?usp=sharing)

Example of loading data:

```
X_train = np.load('data_train.npy)
t_train = np.load('labels_train.npy)
```

`t_train[0]` returns an array of size 2 that corresponds to the first image in `X_train`, where `t_train[0][0]` is the label and `t_train[0][1]` is the valence.
