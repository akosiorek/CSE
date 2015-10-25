


%% Convolution
disp('Ex1 Convolution')
lena = imread('../lena.gif');
kernel = ones(3);
blurred = convolution(lena, kernel, 'mirror');

figure(1)
subplot(1, 2, 1)
subimage(lena)
title('original')

subplot(1, 2, 2)
subimage(blurred)
title('blurred')
suptitle('Ex 1.1 - Convolution')


%% Gaussian
disp('Ex2 Gaussian Filtering')

for sigma = [1, 3]
    fprintf('Sigma = %i\n', sigma)
    
    filter2d = gaus2d(sigma);
    tic
    filtered_2d = conv(lena, filter2d);
    toc
    
    filterX = gaus(sigma);
    filterY = filterX';
    
    tic
    tilered_1d = conv(conv(lena, filterX), filterY);
    toc
    
    same = all(filtered_2d == filtered_1d)
    if same
        disp('Images filtered by 2d and 1d filters match\n')
    else
        disp('Images filtered by 2d and 1d filters do not match\n')
    end
end


%% Image Gradients
disp('Ex3 Image Gradients')

lena = imread('../lena.gif');
[m, o] = gradients(lena, false);
[ms, os] = gradients(lena, true);

figure(3)
subplot(2, 2, 1)
subimage(m)
title('magnitude, original')

subplot(2, 2, 2)
subimage(o)
title('orientation, original')


subplot(2, 2, 3)
subimage(ms)
title('magnitude, smoothed')

subplot(2, 2, 4)
subimage(os)
title('orientation, smoothed')

suptitle('Gradients - From original and smooted image')