__author__ = 'Adam Kosiorek'

import mnist
from sklearn import svm
from sklearn.grid_search import GridSearchCV
import numpy as np
import cv2

MNIST_PATH = '../data/mnist'

def reshapeDataset(dataset):
    shape = dataset.shape
    numOfFeatures = shape[1] * shape[2]
    return dataset.reshape((shape[0], numOfFeatures))

def deskew(img):
    m = cv2.moments(img)
    if abs(m['mu02']) < 1e-2:
        return img.copy()
    skew = m['mu11']/m['mu02']
    M = np.float32([[1, skew, -0.5 * img.shape[0] * skew], [0, 1, 0]])
    img = cv2.warpAffine(img, M, img.shape, flags=cv2.WARP_INVERSE_MAP | cv2.INTER_LINEAR)
    return img

def deskewSet(dataset):
    data = [deskew(img) for img in dataset]
    return np.asarray(data)

def accuracy(predictions, labels):
    matches = np.count_nonzero(predictions == labels)
    return float(matches) / labels.shape[0]

def whiten(dataset, filter=None):
    if filter:
        filter, avg = filter
        data = dataset.T
        data = data - np.tile(avg, [data.shape[1], 1]).T
        data = filter.dot(data)
        return data.T

    else:
        eps = 1e-4

        data = dataset.T
        avg = np.mean(data, axis=1)
        data = data - np.tile(avg, [data.shape[1], 1]).T
        sigma = data.dot(data.T) / data.shape[1]
        U, S, V = np.linalg.svd(sigma)

        filter = U.dot(np.diag(1 / np.sqrt(S + eps))).dot(U.T)

        data = filter.dot(data)
        return data.T, (filter, avg)

def subtractMean(dataset, mean=None):
    returnMean = False
    if mean is None:
        mean = np.mean(dataset, axis=0)
        returnMean = True
    data = dataset - np.tile(mean, [dataset.shape[0], 1])
    if returnMean:
        data = (data, mean)
    return data

trainSet, trainLabels = mnist.load_mnist('training', path=MNIST_PATH, selection=slice(0, 60000))
testSet, testLabels = mnist.load_mnist('testing', path=MNIST_PATH, selection=slice(0, 10000))

trainSet = deskewSet(trainSet)
testSet = deskewSet(testSet)

trainSet = reshapeDataset(trainSet)
testSet = reshapeDataset(testSet)

# #mean subtraction
trainSet, mean = subtractMean(trainSet)
testSet = subtractMean(testSet, mean)

#whitening
trainSet, filter = whiten(trainSet)
testSet = whiten(testSet, filter)


print 'fitting SVM'
classifier = svm.SVC(kernel='poly', degree=2, C=1000)
# classifier = svm.SVC()

# Set the parameters by cross-validation
# c_range= [1e-2, 0.1, 1, 10, 100, 1000]
# tuned_parameters = [{'kernel': ['rbf'],
#                         'gamma': [1e-3, 1e-4],
#                         'C': c_range},
#                     {'kernel': ['linear'],
#                         'C': c_range},
#                     {'kernel':['poly'],
#                         'C' : c_range,
#                         'degree' : [2, 3, 5, 7, 9]}
#                     ]
#
# classifier = GridSearchCV(svm.SVC(cache_size=2000), tuned_parameters, cv=5, n_jobs=-1)

print classifier.fit(trainSet, trainLabels)
#print classifier.best_params_

predictions = classifier.predict(testSet)
print accuracy(predictions, testLabels)