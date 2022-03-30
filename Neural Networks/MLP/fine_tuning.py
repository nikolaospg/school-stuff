import os,sys
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2' 

import tensorflow as tf
from tensorflow.keras import models, layers
from tensorflow.keras import regularizers,optimizers,initializers
import numpy as np
from tensorflow.keras.datasets import mnist
import time
import keras_tuner as kt
from tensorflow_addons.metrics import F1Score


# #Function takes a history objects and print the plots of the accuracy and the loss, for both training and validation set
# def make_plots(history_object):
#     import matplotlib.pyplot as plt
#     plt.figure()
#     plt.plot(history_object.history['accuracy'], label = 'Train')
#     plt.plot(history_object.history['val_accuracy'], label = 'Validation')
#     plt.legend()
#     plt.title('Accuracy through epochs')
#     plt.show()

#     plt.figure()
#     plt.plot(history_object.history['loss'], label = 'Train')
#     plt.plot(history_object.history['val_loss'], label = 'Validation')
#     plt.legend()
#     plt.title('Learning curves')
#     plt.show()

#     final_tr_acc=history_object.history["accuracy"][-1]
#     final_val_acc=history_object.history["val_accuracy"][-1]

#     final_tr_loss=history_object.history["loss"][-1]
#     final_val_loss=history_object.history["val_loss"][-1]


#     print("Final Train Acc=%f Final Val Acc=%f" % (final_tr_acc, final_val_acc))
#     print("Final Train Loss=%f Final Val Loss=%f" % (final_tr_loss, final_val_loss))


#The function that helps me with the hypermodel
def model_builder(hp):

    #Defining the hyperparameters:
    hp_l1=hp.Choice('l1', values=[64, 128])
    hp_l2=hp.Choice('l2', values=[256, 512])
    hp_weight=hp.Choice('weight', values=[0.1, 0.001, 0.000001])
    hp_lr=hp.Choice('learning_rate', values=[0.1, 0.01, 0.001])
    #Finished defining the hyperparameters

    #Defining the structure of the model
    model=models.Sequential()
    
    kernel_initialiser=initializers.he_normal()
    kernel_regulariser=regularizers.l2(hp_weight)
    model.add(layers.Dense(hp_l1, activation="relu", input_shape=(28*28,), kernel_initializer=kernel_initialiser, kernel_regularizer=kernel_regulariser))
    model.add(layers.Dense(hp_l2, activation="relu", kernel_initializer=kernel_initialiser, kernel_regularizer=kernel_regulariser))
    model.add(layers.Dense(10, activation="linear", kernel_initializer=kernel_initialiser, kernel_regularizer=kernel_regulariser))

    optimiser=optimizers.RMSprop(learning_rate=hp_lr)
    model.compile(loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True), metrics=['accuracy', F1Score(num_classes=10, average="micro")], optimizer=optimiser)
    return model



#Opening the Dataset
num_features=28*28

(x_train, y_train), (x_test, y_test) = mnist.load_data()
x_train, x_test = np.array(x_train, np.float32), np.array(x_test, np.float32)                   #changing to float32

x_train, x_test = x_train.reshape([-1, num_features]), x_test.reshape([-1, num_features])       #Vectorisation
x_train, x_test = x_train / 255., x_test / 255                                                  #Converting to [0,1]
#Finished with the dataset


#Using Hyperband optimiser/ Choosing parameters#
tuner = kt.Hyperband(model_builder, objective=kt.Objective('val_f1_score', direction = 'max'),max_epochs=1000)
stop_early = tf.keras.callbacks.EarlyStopping(monitor='val_loss', patience=200)
t1=time.time()
tuner.search(x_train, y_train, epochs=1000, validation_split=0.2, callbacks=[stop_early])
t2=time.time()
print("Total time for hyperparameter search",t2-t1)
best_hps=tuner.get_best_hyperparameters(num_trials=1)[0]

print("Chosen Params: l1=%d l2=%d learning_rate=%f reg_weight=%f" % (best_hps.get('l1'), best_hps.get('l2'), best_hps.get('learning_rate'), best_hps.get('weight')))
#Finished with the hyperparameter choice#

#Building the model and estimating the best epoch for early stopping:#
model = tuner.hypermodel.build(best_hps)
history = model.fit(x_train, y_train, epochs=1000, validation_split=0.2)
val_acc_per_epoch = history.history['val_accuracy']
best_epoch = val_acc_per_epoch.index(max(val_acc_per_epoch)) + 1
print("The epoch chosen is", best_epoch)
#Got the best epoch#

