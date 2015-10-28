function new_img = make_border(img, X, Y, border)
    if strcmp(border, 'none')
        new_img = img;
        return
    end
    new_img = zeros(size(img) + 2 * [X, Y]);
    new_img(1+X:end-X, 1+Y:end-Y) = img;
    
    if strcmp(border, 'mirror')
        new_img(1:X, 1+Y:end-Y) = flipud(img(1:X, :));
        new_img(end-X+1:end, 1+Y:end-Y) = flipud(img(end-X+1:end, :));
        new_img(1+X:end-X, 1:Y) = fliplr(img(:, 1:Y));
        new_img(1+X:end-X, end-Y+1:end) = fliplr(img(:, end-Y+1:end));

        new_img(1:X, 1:Y) = flipud(fliplr(img(1:X, 1:Y)));
        new_img(end-X+1:end, 1:Y) = flipud(fliplr(img(end-X+1:end, 1:Y)));
        new_img(1:X, end-Y+1:end) = flipud(fliplr(img(1:X, end-Y+1:end)));
        new_img(end-X+1:end, end-Y+1:end) = flipud(fliplr(img(end-X+1:end, end-Y+1:end)));

    elseif strcmp(border, 'last')
        new_img(1:X, 1+Y:end-Y) = repmat(img(1, :), X, 1);
        new_img(end-X+1:end, 1+Y:end-Y) = repmat(img(end, :), X, 1);
        new_img(1+X:end-X, 1:Y) = repmat(img(:, 1), 1, Y);
        new_img(1+X:end-X, end-Y+1:end) = repmat(img(:, end), 1, Y);

        new_img(1:X, 1:Y) = img(1, 1);
        new_img(end-X:end, 1:Y) = img(end, 1);
        new_img(1:X, end-Y:end) = img(1, end);
        new_img(end-X:end, end-Y:end) = img(end, end);
    end
    
end