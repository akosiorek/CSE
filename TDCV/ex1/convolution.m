function f = convolution(img, kernel, border)
    
    
    [N, M] = size(img);
    [X, Y] = size(kernel);
    X = (X - 1) / 2;
    Y = (Y - 1) / 2;
    
    assert(mod(X, 1) == 0);
    assert(mod(Y, 1) == 0);
    
    kernel = fliplr(flipud(kernel));
    
    
    if(strcmp(border, 'none'))
        f = zeros(size(img));
    else
        
        new_img = zeros(size(img) + 2*[X, Y]);
        new_img(1+X:end-X, 1+Y:end-Y) = img;
        
        if(strcmp(border, 'mirror'))
            new_img(1:X, 1+Y:end-Y) = fliplr(img(1:X, :));
            new_img(end-X+1:end, 1+Y:end-Y) = fliplr(img(end-X+1:end, :));
            new_img(1+X:end-X, 1:Y) = flipud(img(:, 1:Y));
            new_img(1+X:end-X, end-Y+1:end) = flipud(img(:, end-Y+1:end));
            
            new_img(1:X, 1:Y) = flipud(fliplr(img(1:X, 1:Y)));
            new_img(end-X:end, 1:Y) = flipud(fliplr(img(end-X+1:end, 1:Y)));
            new_img(1:X, end-Y:end) = flipud(fliplr(img(1:Y, end-Y+1:end)));
            new_img(end-X:end, end-Y:end) = flipud(fliplr(img(end-X+1:end, end-Y+1:end)));
            
        elseif(strcmp(border, 'fill'))
            new_img(1:X, 1+Y:end-Y) = repmat(img(1, :), X, 1);
            new_img(end-X+1:end, 1+Y:end-Y) = repmat(img(end, :), X, 1);
            new_img(1+X:end-X, 1:Y) = repmat(img(:, 1), 1, Y);
            new_img(1+X:end-X, end-Y+1:end) = repmat(img(:, end), 1, Y);
            
            new_img(1:X, 1:Y) = img(1, 1);
            new_img(end-X:end, 1:Y) = img(end, 1);
            new_img(1:X, end-Y:end) = img(1, end);
            new_img(end-X:end, end-Y:end) = img(end, end);
        end
        f = convolution(new_img, kernel, 'none');
        return
    end
    
    
    for x = 1+X : N-X
        for y = 1+Y : M-Y
            f(x, y) = sum(sum(img(x-X:x+X, y-Y:y+Y) .* kernel));
        end
    end
    f = f(1+X:end-X, 1+Y:end-Y);
end