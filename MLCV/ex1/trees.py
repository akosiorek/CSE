__author__ = 'Adam Kosiorek'



from sklearn import tree
from sklearn.grid_search import GridSearchCV
from sklearn.metrics import accuracy_score
from ex1.data import getData, plot_feature_importance, plot_tree


trainData, testData = getData(fraction=1, deskew=True, subtractMean=True)
trainSet, trainLabels = trainData
testSet, testLabels = testData


# Parameter Grid Search with Cross-Validation
# tuned_parameters = {
#                      'criterion' : ['gini', 'entropy'],
#                      'max_depth' : [3, 5, 10, 30, 50, 70, 100],
#                      'max_features' : [3, 5, 50, 70, 100, 350, 500, 650, 784]
#                     }
#
# classifier = GridSearchCV(tree.DecisionTreeClassifier(), tuned_parameters, cv=5, n_jobs=-1)
# print classifier.fit(trainSet, trainLabels)
# print classifier.best_params_
# predictions = classifier.predict(testSet)
# print accuracy_score(predictions, testLabels)

# #Best Parameters from CrossValidation
best_params = {'max_features': 500, 'criterion': 'entropy', 'max_depth': 100}
classifier = tree.DecisionTreeClassifier(**best_params)
print classifier.fit(trainSet, trainLabels)

predictions = classifier.predict(testSet)
print accuracy_score(predictions, testLabels)
plot_tree(classifier, 'tree')
plot_feature_importance(classifier, 'tree')