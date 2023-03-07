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


### Valence mapping of 28 Emotions:
For each emotion, we mapped the valence, which is a value between 0-9 that represents the positive/negative scale of each emotion (9 being the most positive and 0 being the most negative).
- `Affection`: 8
- `Anger`: 3
- `Annoyance`: 3
- `Anticipation`: 6
- `Aversion`: 5
- `Confidence`: 6
- `Disapproval`: 3
- `Disconnection`: 5
- `Disquietment`: 5
- `Doubt/Confusion`: 5
- `Embarrassment`: 5
- `Engagement`: 7
- `Esteem`: 6  
- `Excitement`: 7
- `Fatigue`: 5
- `Fear`: 5
- `Happiness`: 9
- `Pain`: 3
- `Peace`: 6
- `Pleasure`: 6
- `Saddness`: 4
- `Sensitivity`: 6
- `Suffering`: 5
- `Surprise`: 6
- `Sympathy`: 7
- `Yearning`: 6
- `Disgust`: 4
- `Neutral`: 5
