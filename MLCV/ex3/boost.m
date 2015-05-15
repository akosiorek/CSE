function boost()
    clc; clear all; close all;    
    
    fraction = 1;
    [trainSamples, trainLabels] = loadMnistData('train', fraction);
    [testSamples, testLabels] = loadMnistData('test', fraction);
    
    lpBoost = fitensemble(trainSamples, trainLabels, 'LPBoost', 500, 'Tree', 'nprint', 1) 
    save('lp.mat', 'lpBoost')
    totalBoost = fitensemble(trainSamples, trainLabels, 'TotalBoost', 500, 'Tree', 'nprint', 1)
    save('total.mat', 'totalBoost')
    
    iters = 100;
    adaBoost = fitensemble(trainSamples, trainLabels, 'AdaBoostM2', iters, 'Tree', 'nprint', 1)  
    save('ada.mat', 'adaBoost')
    rusBoost = fitensemble(trainSamples, trainLabels, 'RUSBoost', 100, 'Tree', 'nprint', 1)
    save('rus.mat', 'rusBoost')
    
    accuracy = zeros(10, 3);    
    accuracy(1, 1) = adaBoost.NTrained;
    accuracy(1, 2) = checkModel(adaBoost, testSamples, testLabels)     
    accuracy(1, 3) = checkModel(rusBoost, testSamples, testLabels)
   
    for i=2:10
        adaBoost  = adaBoost.resume(iters, 'nprint', 1)
        save('ada.mat', 'adaBoost')
        accuracy(i, 1) = adaBoost.NTrained;
        accuracy(i, 2) = checkModel(adaBoost, testSamples, testLabels)
        
        rusBoost = rusBoost.resume(iters, 'nprint', 1)
        save('rus.mat', 'rusBoost')
        accuracy(i, 3) = checkModel(rusBoost, testSamples, testLabels)
    end
    

    save('accuracy.mat', 'accuracy');
    
    figure(1)
    grid on
    hold on
    xlabel('NLearners');
    ylabel('Accuracy');
    
    plot(accuracy(:, 1), accuracy(:, 2), 'b*')
    plot(accuracy(:, 1), accuracy(:, 3), 'r*')    
    plot(lpBoost.NTrained, checkModel(lpBoost, testSamples, testLabels), 'g*')
    plot(totalBoost.NTrained, checkModel(totalBoost, testSamples, testLabels), 'k*')
    legend('AdaBoost', 'RUSBoost', 'LPBoost', 'TotalBoost');
    print('-depsc', 'boost_plot_big');
end

function accuracy = checkModel(model, samples, labels)
   assert(size(samples, 1) == size(labels, 1));    
   
   if iscell(model)
       accuracy = 0;
       for i = 1:numel(model)
           accuracy = accuracy + checkModel(model{i}, samples, labels);
       end
       accuracy = accuracy / numel(model);
   else   
        prediction = predict(model, samples);
        accuracy = nnz(prediction == labels) / numel(labels);    
   end
end