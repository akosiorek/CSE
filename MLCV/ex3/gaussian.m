function gaussian()
    
    clear all, close all, clc;

    n1 = 80;        % number of data points from each class
    n2 = 40;        
    S1 = eye(2);    % the two covariance matrices
    S2 = [1 0.95; 0.95 1];      
    m1 = [0.75; 0];     % the two means
    m2 = [-0.75; 0];    
      
    % train data
    seed = 0.2;
    [x1, y1] = createData(n1, 1, m1, S1, seed);
    [x2, y2] = createData(n2, -1, m2, S2, seed);
    trainData = [x1 x2]'; 
    trainLabels = [y1; y2];
    
    figure(1)
    hold on
    grid on
    plot(x1(1, :), x1(2, :), 'r+', 'LineWidth', 2)
    plot(x2(1, :), x2(2, :), 'bo', 'LineWidth', 2)
    xlabel('x')
    ylabel('y')
    
    % test data
    seed = 0.4;
    [xs1, ys1] = createData(n1, 1, m1, S1, seed);
    [xs2, ys2] = createData(n2, -1, m2, S2, seed);
    testData = [xs1 xs2]'; 
    testLabels = [ys1; ys2];
    
    print -depsc 'GP_trainset'
    
    figure(2)
    hold on
    grid on
    plot(xs1(1, :), xs1(2, :), 'r+', 'LineWidth', 2)
    plot(xs2(1, :), xs2(2, :), 'bo', 'LineWidth', 2)
    xlabel('x')
    ylabel('y')
    
    print -depsc 'GP_testset'
    
 
    
    name = 'covLINiso_likErf_infEP'
    meanfunc = @meanConst; 
    hyp.mean = 0;
    covfunc = @covLINard;   
    hyp.cov = log([1 1]);
%     covfunc = @covSEard;   
%     hyp.cov = log([1 1 1]);
    likfunc = @likErf;
%     hyp.lik = log([1]);
    infFunc = @infEP;

    hyp = minimize(hyp, @gp, -40, @infEP, meanfunc, covfunc, likfunc, trainData, trainLabels);
    [a b c d lp] = gp(hyp, infFunc, meanfunc, covfunc, likfunc, trainData, trainLabels, testData, testLabels);

    probs = getProbs(lp);
    labels = toLabels(probs);
    accuracy = checkModel(labels, testLabels) 
    
    probs(testLabels == -1) = 1 - probs(testLabels == -1);
    trueProbs = probs(labels == testLabels);
    falseProbs = probs(labels ~= testLabels);
    
    trueUncertainty = uncertainty(trueProbs);
    falseUncertainty = uncertainty(falseProbs);
    
    figure(3)
    plotHistogram(trueUncertainty, 10, strcat(name, '_true'));
    figure(4)
    plotHistogram(falseUncertainty, 10, strcat(name, '_false'));
end


function [x, y] = createData(n, label, mean, covMatrix, seed) 
   x = bsxfun(@plus, chol(covMatrix)'*gpml_randn(seed, 2, n), mean);  
   y = label * ones(n, 1);
end
    

function acc = checkModel(labels, groundtruth)
      acc = nnz(labels == groundtruth) / size(groundtruth, 1);
end

function u = uncertainty(p)
    u = -(p .* log(p) + (1 - p) .* log(1 - p));
end

function probs = getProbs(logProbs)
   probs = exp(logProbs);    
end

function labels = toLabels(probs)
    labels = probs;
    labels(labels < 0.5) = -1;
    labels(labels > 0.5) = 1;
end