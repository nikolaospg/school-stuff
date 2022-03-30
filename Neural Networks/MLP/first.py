import os,sysos.environ['TF_CPP_MIN_LOG_LEVEL'] = '2' 

import tensorflow as tf
from tensorflow.keras import models, layers
from tensorflow.keras import regularizers,optimizers,initializers
import numpy as np
from tensorflow.keras.datasets import mnist
import time




#Function takes a history objects and print the plots of the accuracy and the loss, for both training and validation set
def make_plots(history_object):
    import matplotlib.pyplot as plt
    plt.figure()
    plt.plot(history_object.history['accuracy'], label = 'Train')
    plt.plot(history_object.history['val_accuracy'], label = 'Validation')
    plt.legend()
    plt.title('Accuracy through epochs')
    plt.show()

    plt.figure()
    plt.plot(history_object.history['loss'], label = 'Train')
    plt.plot(history_object.history['val_loss'], label = 'Validation')
    plt.legend()
    plt.title('Learning curves')
    plt.show()

    final_tr_acc=history_object.history["accuracy"][-1]
    final_val_acc=history_object.history["val_accuracy"][-1]

    final_tr_loss=history_object.history["loss"][-1]
    final_val_loss=history_object.history["val_loss"][-1]


    print("Final Train Acc=%f Final Val Acc=%f" % (final_tr_acc, final_val_acc))
    print("Final Train Loss=%f Final Val Loss=%f" % (final_tr_loss, final_val_loss))


#This is the function I use to initialise, compile, fit and evaluate a model
#Args:
#       1) optimiser_str-> "SGD", "RMSProp" or "Default". It specifies which one of the 3 cases of the exercise to work with
#       4) rho->    The rho parameter of the RMSProp optimiser
#       5) regularisation-> "L2" or "L1". "L2" applies L2 normalisation and "L1" applies L1 normalisation WITH DROPOUT(p=0.3)
#       6) weight-> The regularisation parameter
def explore_model(optimiser_str, learning_rate, batch_size=256, rho=0.99, regularisation="L2", weight=0.01, l1=128, l2=256, epochs=100):
    
    if(optimiser_str!="SGD" and optimiser_str!="RMSProp" and optimiser_str!="Default"):
        print("Please pass \"SGD\", \"RMSProp\" or \"Default\" for the optimiser_str, you passed ",optimiser_str)
        sys.exit()
    
    print("Using:")
    #Creating the optimisers#
    if(optimiser_str=="SGD"):
        optimiser=optimizers.SGD(learning_rate=learning_rate)
        print("SGD optimiser with lr=",learning_rate)
    elif(optimiser_str=="RMSProp"):
        optimiser=optimizers.RMSprop(learning_rate=learning_rate, rho=rho)
        print("RMSProp optimiser with lr=",learning_rate,"rho",rho)
    else:
        print("Default Optimiser")

    #Finished with the optimisers#

    model=models.Sequential()
    #Creating the layers#
    #If the optimiser is SGD then we initialise using the normal distribution
    if(optimiser_str=="SGD"):
        kernel_initialiser=initializers.RandomNormal(mean=10)
        print("Weight Initialisation with ~N(10,0)")
        if(regularisation=="L2"):           #Case of L2 reg
            print("L2 Regularisation with weight",weight)
            kernel_regulariser= regularizers.l2(weight)
            model.add(layers.Dense(l1, activation="relu", input_shape=(28*28,), kernel_initializer=kernel_initialiser, kernel_regularizer=kernel_regulariser))
            model.add(layers.Dense(l2, activation="relu", kernel_initializer=kernel_initialiser, kernel_regularizer=kernel_regulariser))
            model.add(layers.Dense(10, activation="linear", kernel_initializer=kernel_initialiser, kernel_regularizer=kernel_regulariser))
        elif(regularisation=="L1"):           #Case of L1+Dropout Reg
            kernel_regulariser= regularizers.l1(weight)
            print("L1 Regularisation with weight ",weight)
            print("Dropout Regularisation with p 0.3")
            model.add(layers.Dense(l1, activation="relu", input_shape=(28*28,), kernel_initializer=kernel_initialiser, kernel_regularizer=kernel_regulariser))
            model.add(layers.Dropout(0.3))
            model.add(layers.Dense(l2, activation="relu", kernel_initializer=kernel_initialiser, kernel_regularizer=kernel_regulariser))
            model.add(layers.Dropout(0.3))
            model.add(layers.Dense(10, activation="linear", kernel_initializer=kernel_initialiser, kernel_regularizer=kernel_regulariser))
        else:       #No regularisation
            print("No regularisation")
            model.add(layers.Dense(l1, activation="relu", input_shape=(28*28,), kernel_initializer=kernel_initialiser))
            model.add(layers.Dense(l2, activation="relu", kernel_initializer=kernel_initialiser))
            model.add(layers.Dense(10, activation="linear", kernel_initializer=kernel_initialiser))

    
    #In any other case I use standard initialisation
    else:
        print("standard weight initialisation")
        if(regularisation=="L2"):           #Case of L2 reg
            print("L2 Regularisation with weight",weight)
            kernel_regulariser= regularizers.l2(weight)
            model.add(layers.Dense(l1, activation="relu", input_shape=(28*28,), kernel_regularizer=kernel_regulariser))
            model.add(layers.Dense(l2, activation="relu", kernel_regularizer=kernel_regulariser))
            model.add(layers.Dense(10, activation="linear", kernel_regularizer=kernel_regulariser))
        elif(regularisation=="L1"):           #Case of L1+Dropout Reg
            print("L1 Regularisation with weight ",weight)
            print("Dropout Regularisation with p 0.3")
            kernel_regulariser= regularizers.l1(weight)
            model.add(layers.Dense(l1, activation="relu", input_shape=(28*28,), kernel_regularizer=kernel_regulariser))
            model.add(layers.Dropout(0.3))
            model.add(layers.Dense(l2, activation="relu", kernel_regularizer=kernel_regulariser))
            model.add(layers.Dropout(0.3))
            model.add(layers.Dense(10, activation="linear", kernel_regularizer=kernel_regulariser))
        else:
            print("No regularisation")
            model.add(layers.Dense(l1, activation="relu", input_shape=(28*28,)))
            model.add(layers.Dense(l2, activation="relu"))
            model.add(layers.Dense(10, activation="linear"))
    print("Batch size ",batch_size)
    #Finished creating the layers#

    #Compiling the model#
    #If the optimiser string is "Default" I use the default Optimiser: 
    if(optimiser_str=="Default"):
        model.compile(loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True), metrics=['accuracy'])
    else:
        model.compile(loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True), metrics=['accuracy'], optimizer=optimiser)
    #Finished compiling#

    #Fitting the model#
    t1=time.time()
    history=model.fit(x_train, y_train, batch_size=batch_size, epochs=epochs, validation_split=0.2, verbose=fit_verbose)
    t2=time.time()
    print("Training time:",t2-t1)
    #Finished Fitting#

    #Making plots regarding the training#
    make_plots(history)
    #Finished making the plots#

    #Evaluating# 
    test_loss, test_acc = model.evaluate(x_test, y_test, verbose=0)
    print("Final Test Loss=%f Final Test Acc=%f" % (test_loss, test_acc))
    #Finished evaluating#

    return model
        

#Gets the model and the datasets and computes the classification metrics
def get_metrics(model, x_train, y_train, x_test, y_test):
    from sklearn.metrics import classification_report,confusion_matrix
    from scipy.special import softmax
    
    #Predicting and applying softmax (and getting the argmax)
    train_preds=model.predict(x_train)
    train_preds=np.array(softmax(train_preds, axis=1))
    train_preds=train_preds.argmax(axis=1)

    test_preds=model.predict(x_test)
    test_preds=np.array(softmax(test_preds, axis=1))
    test_preds=test_preds.argmax(axis=1)
    #Finished with the predictions and the softmax

    print("Confusion Matrix Train:")
    print(confusion_matrix(y_train, train_preds))
    print("Classification Metrics Train:")
    print(classification_report(y_train, train_preds,digits=3))

    print("Confusion Matrix Test:")
    print(confusion_matrix(y_test, test_preds))
    print("Classification Metrics Test:")
    print(classification_report(y_test, test_preds,digits=3))




#Opening the Dataset
num_features=28*28

(x_train, y_train), (x_test, y_test) = mnist.load_data()
x_train, x_test = np.array(x_train, np.float32), np.array(x_test, np.float32)                   #changing to float32

x_train, x_test = x_train.reshape([-1, num_features]), x_test.reshape([-1, num_features])       #Vectorisation
x_train, x_test = x_train / 255., x_test / 255                                                  #Converting to [0,1]
#Finished with the dataset


#Now with the model#
optimiser_str="RMSProp"
learning_rate=0.001
rho=0.99

batch_size=256
regularisation="L2"
weight=0.001
fit_verbose=2
l1=128
l2=256
epochs=100

model=explore_model(optimiser_str, learning_rate=learning_rate, batch_size=batch_size, rho=rho, regularisation=regularisation, weight=weight, l1=l1, l2=l2, epochs=epochs)

# get_metrics(model, x_train, y_train, x_test, y_test)     #This function is used on the end when I am asked to get the metrics

