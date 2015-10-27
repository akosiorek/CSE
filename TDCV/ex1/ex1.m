function ex1


    %% Convolution
    disp('Ex1 Convolution')
    lena = read_lena();
    kernel = ones(3) / 9;
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
    lena = read_lena();
    for sigma = [1, 3]


        filter2d = gaus2d(sigma);
        tic
        filtered_2d = convolution(lena, filter2d, 'mirror');
        time2d = toc;

        filterX = gaus(sigma);
        filterY = filterX';

        tic
        filtered_1d = convolution(convolution(lena, filterX,'mirror'), filterY, 'mirror');
        time1d = toc;

        fprintf('Sigma = %i\n', sigma)
        same = norm(filtered_2d - filtered_1d) < 1e-6;
        fprintf('2x 1d convolution done in: %f s\n', time1d);
        fprintf('   2d convolution done in: %f s\n', time2d);
        fprintf('Results are the same: %d\n', same);
    end


    %% Image Gradients
    disp('Ex3 Image Gradients')

    lena = read_lena();
    [m0, o0] = gradients(lena, 0);
    [m1, o1] = gradients(lena, 1);
    [m2, o2] = gradients(lena, 2);

    figure(3)
    subplot(3, 2, 1)
    subimage(m0)
    title('magnitude, original')

    subplot(3, 2, 2)
    subimage(o0)
    title('orientation, original')
    
    subplot(3, 2, 3)
    subimage(m1)
    title('magnitude, smoothed separable')

    subplot(3, 2, 4)
    subimage(o1)
    title('orientation, smoothed separable')


    subplot(3, 2, 5)
    subimage(m2)
    title('magnitude, smoothed')

    subplot(3, 2, 6)
    subimage(o2)
    title('orientation, smoothed')

    %suptitle('Gradients - From original and smoothed images')
end

function lena = read_lena()
   lena = double(imread('../lena.gif'))/255;
end