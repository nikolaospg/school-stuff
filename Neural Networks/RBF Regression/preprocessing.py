import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

                   

#Loading dataset and getting some rough understanding of it:
data=pd.read_csv("abalone.csv")
print(data.head())
print(data.isnull().sum())

X=data.iloc[:,0:-1]
y=data.iloc[:,-1]
#Finished loading


#Train/Test separation
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.33, random_state=42)
#Finished with the train/test

#Checking the distributions and for outliers on the train test
print(X_train.describe())

plt.boxplot(X_train.iloc[:,3])          #It seems that we are having an outlier here
plt.title("Box plot for the Height variable (Before)")
plt.show()
#Found an outlier


#Getting rid of the outlier
index=np.argmax(X_train.iloc[:,3])
X_train1=X_train.iloc[0:index,:]
X_train2=X_train.iloc[index+1:,:]
X_train=pd.concat((X_train1,X_train2), axis=0)

plt.boxplot(X_train.iloc[:,3])          #It seems that we are having an outlier here
plt.title("Box plot for the Height variable (After)")
plt.show()
#Finished with the outlier


##Separating the Males/Females/Infants

#First for Males
train_males_ind=np.where(X_train.iloc[:,0]=="M")
X_train_M=X_train.iloc[train_males_ind]
y_train_M=y_train.iloc[train_males_ind]
X_train_M=X_train_M.iloc[:,1:]

test_males_ind=np.where(X_test.iloc[:,0]=="M")
X_test_M=X_test.iloc[test_males_ind]
y_test_M=y_test.iloc[test_males_ind]
X_test_M=X_test_M.iloc[:,1:]
#Now for Females
train_females_ind=np.where(X_train.iloc[:,0]=="F")
X_train_F=X_train.iloc[train_females_ind]
y_train_F=y_train.iloc[train_females_ind]
X_train_F=X_train_F.iloc[:,1:]

test_females_ind=np.where(X_test.iloc[:,0]=="F")
X_test_F=X_test.iloc[test_females_ind]
y_test_F=y_test.iloc[test_females_ind]
X_test_F=X_test_F.iloc[:,1:]
#Now for Infants

train_infants_ind=np.where(X_train.iloc[:,0]=="I")
X_train_I=X_train.iloc[train_infants_ind]
y_train_I=y_train.iloc[train_infants_ind]
X_train_I=X_train_I.iloc[:,1:]

test_infants_ind=np.where(X_test.iloc[:,0]=="I")
X_test_I=X_test.iloc[test_infants_ind]
y_test_I=y_test.iloc[test_infants_ind]
X_test_I=X_test_I.iloc[:,1:]
##Finished separating


#Converting to numpy arrays and saving
X_train_M=np.array(X_train_M)
X_test_M=np.array(X_test_M)
y_train_M=np.array(y_train_M)
y_test_M=np.array(y_test_M)

X_train_F=np.array(X_train_F)
X_test_F=np.array(X_test_F)
y_train_F=np.array(y_train_F)
y_test_F=np.array(y_test_F)

X_train_I=np.array(X_train_I)
X_test_I=np.array(X_test_I)
y_train_I=np.array(y_train_I)
y_test_I=np.array(y_test_I)

np.save("datasets/X_train_M",X_train_M)
np.save("datasets/X_test_M",X_test_M)
np.save("datasets/y_train_M",y_train_M)
np.save("datasets/y_test_M",y_test_M)

np.save("datasets/X_train_F",X_train_F)
np.save("datasets/X_test_F",X_test_F)
np.save("datasets/y_train_F",y_train_F)
np.save("datasets/y_test_F",y_test_F)

np.save("datasets/X_train_I",X_train_I)
np.save("datasets/X_test_I",X_test_I)
np.save("datasets/y_train_I",y_train_I)
np.save("datasets/y_test_I",y_test_I)