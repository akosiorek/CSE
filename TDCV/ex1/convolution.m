function f = convolution(img, kernel, border)
    
    [X, Y] = size(kernel);
    X = (X - 1) / 2;
    Y = (Y - 1) / 2;
    
    assert(mod(X, 1) == 0);
    assert(mod(Y, 1) == 0);
       
    if(strcmp(border, 'mirror'));
        img = padarray(img, [X Y], 'both', 'symmetric');
    elseif(strcmp(border, 'fill'))
        img = padarray(img, [X Y], 'both', 'replicate');
    end
    
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