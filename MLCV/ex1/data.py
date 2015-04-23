__author__ = 'Adam Kosiorek'

import mnist
import cv2
import numpy as np
import pydot
import matplotlib.pyplot as plt
from StringIO import StringIO
from sklearn import tree

# MNIST dataset must be unpacked in this folder !
MNIST_PATH = '../data/mnist'

def reshapeDataset(dataset):
    shape = dataset.shape
    numOfFeatures = shape[1] * shape[2]
    return dataset.reshape((shape[0], numOfFeatures))

# Deskew function taken from:
# http://opencv-python-tutroals.readthedocs.org/en/latest/py_tutorials/py_ml/py_svm/py_svm_opencv/py_svm_opencv.html
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

# ZCA-Whitening according to:
# http://ufldl.stanford.edu/wiki/index.php/UFLDL_Tutorial
def doWhiten(dataset, filter=None):
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

def doSubtractMean(dataset, mean=None):
    returnMean = False
    if mean is None:
        mean = np.mean(dataset, axis=0)
        returnMean = True
    data = dataset - np.tile(mean, [dataset.shape[0], 1])
    if returnMean:
        data = (data, mean)
    return data

def getData(fraction=1, deskew=False, subtractMean=False, whiten=False):
    assert 0 < fraction <= 1 , '0 < fraction <= 1 !'

    maxIndex = lambda x, y: int(x*y)
    trainSet, trainLabels = mnist.load_mnist('training', path=MNIST_PATH, selection=slice(0, maxIndex(fraction, 60000)))
    testSet, testLabels = mnist.load_mnist('testing', path=MNIST_PATH, selection=slice(0, maxIndex(fraction, 10000)))

    if deskew:
        trainSet = deskewSet(trainSet)
        testSet = deskewSet(testSet)

    trainSet = reshapeDataset(trainSet)
    testSet = reshapeDataset(testSet)

    if subtractMean:
        trainSet, mean = doSubtractMean(trainSet)
        testSet = doSubtractMean(testSet, mean)

    if whiten:
        trainSet, filter = doWhiten(trainSet)
        testSet = doWhiten(testSet, filter)

    trainData = (trainSet, trainLabels)
    testData = (testSet, testLabels)

    return trainData, testData

def plot_tree(classifier, name):
    data = StringIO()
    tree.export_graphviz(classifier, out_file=data)
    graph = pydot.graph_from_dot_data(data.getvalue())
    graph.write_png(name + '.png')

def plot_feature_importance(classifier, name):
    importance = classifier.feature_importances_
    importance = importance.reshape(28, 28)
    plt.matshow(importance, cmap=plt.cm.hot)
    plt.title('Pixel importance')
    plt.savefig(name + '.png' )