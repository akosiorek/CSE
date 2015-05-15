function [samples, labels] = loadMnistData(name, varargin)    
    dataFolder = '../data/mnist/';
    
    if strcmp(name, 'train')
        labels = loadMNISTLabels(strcat(dataFolder, 'train-labels-idx1-ubyte'));
        samples = loadMNISTImages(strcat(dataFolder, 'train-images-idx3-ubyte'));
    elseif strcmp(name, 'test')
        labels = loadMNISTLabels(strcat(dataFolder, 't10k-labels-idx1-ubyte'));
        samples = loadMNISTImages(strcat(dataFolder, 't10k-images-idx3-ubyte'));
    else
        assert(0, 'Name must be "train" or "test"')
    end
    samples = samples';
    N = size(labels, 1);
    
    if nargin == 2
        fraction = varargin{1};
        if fraction <= 1
            N = N * fraction;
        else
            N = fraction;
        end
        labels = labels(1:N, :);
        samples = samples(1:N, :);
    end
    
    fprintf('Loaded %d samples and labels from %s set\n', N, name);
end