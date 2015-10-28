function f = convolution(img, kernel, border)
    
    [X, Y] = size(kernel);
    assert(mod(X, 2) == 1);
    assert(mod(Y, 2) == 1);
       
    X = (X - 1) / 2;
    Y = (Y - 1) / 2;
    img = make_border(img, X, Y, border);
    kernel = fliplr(flipud(kernel));
    [N, M] = size(img);   
    f = zeros(size(img));
   
    for x = 1+X : N-X
        for y = 1+Y : M-Y
            f(x, y) = sum(sum(img(x-X:x+X, y-Y:y+Y) .* kernel));
        end
    end
    f = f(1+X:end-X, 1+Y:end-Y);
end




     