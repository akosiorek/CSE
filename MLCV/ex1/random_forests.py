from sklearn.ensemble import RandomForestClassifier
from sklearn.grid_search import GridSearchCV
from sklearn.metrics import accuracy_score
from ex1.data import getData, plot_feature_importance, plot_tree


trainData, testData = getData(fraction=1, deskew=True, subtractMean=True)
trainSet, trainLabels = trainData
testSet, testLabels = testData


# # Parameter Grid Search with Cross-Validation
# tuned_parameters = {
#                      'n_estimators' : [2, 5, 10, 20, 30, 50, 70, 100],
#                      'criterion' : ['gini', 'entropy'],
#                      'max_depth' : [3, 5, 10, 30, 50, 70, 100],
#                      'max_features' : [3, 5, 50, 70, 100, 350, 500, 650, 784]
#                     }
#
# classifier = GridSearchCV(RandomForestClassifier(), tuned_parameters, cv=5, n_jobs=-1)
# print classifier.fit(trainSet, trainLabels)
# print classifier.best_params_
# predictions = classifier.predict(testSet)
# print accuracy_score(predictions, testLabels)

# #Best Parameters from CrossValidation
best_params = {'max_features': 50, 'n_estimators': 100, 'criterion': 'entropy', 'max_depth': 10}
classifier = RandomForestClassifier(**best_params)
print classifier.fit(trainSet, trainLabels)

predictions = classifier.predict(testSet)
print accuracy_score(predictions, testLabels)
# plot_tree(classifier, 'random')
plot_feature_importance(classifier, 'random')