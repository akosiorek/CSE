__author__ = 'Adam Kosiorek'

from sklearn import svm
from sklearn.grid_search import GridSearchCV
from sklearn.metrics import accuracy_score
from ex1.data import getData
from sklearn import tree

trainData, testData = getData(deskew=True, subtractMean=True)
trainSet, trainLabels = trainData
testSet, testLabels = testData

print 'fitting SVM'
## Parameter Grid Search with Cross-Validation
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
# print classifier.fit(trainSet, trainLabels)
# print classifier.best_params_

classifier = svm.SVC(kernel='poly', degree=2, C=1000)
print classifier.fit(trainSet, trainLabels)


predictions = classifier.predict(testSet)
print accuracy_score(predictions, testLabels)