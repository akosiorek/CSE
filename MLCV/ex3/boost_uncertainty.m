function boost_uncertainty()
    clc; clear all; close all;
   
    load ada.mat
%     load rus.mat
%     load lp.mat
%     load total.mat
    [testSamples, testLabels] = loadMnistData('test', 0.1);
    
    
    [labels, scores] = predict(adaBoost, testSamples);
    
    scores = scores ./ repmat(sum(scores, 2), 1, size(scores, 2));
    
    correctScores = scores(labels == testLabels, :);
    incorrectScores = scores(labels ~= testLabels, :);
    
    correctUncertainty = uncertainty(correctScores);
    incorrectUncertainty = uncertainty(incorrectScores);
    
    
    plotHistogram(correctUncertainty, 10, 'ada_correct');
    plotHistogram(incorrectUncertainty, 10, 'ada_incorrect');
    
    
    
    
end


function u = uncertainty(scores)     
    u = -sum(scores .* log(scores), 2)    
end