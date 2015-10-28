function [magnitude, orientation] = gradients(img, smooth)
   
    
    filter_h = [-1, -1, -1; 0, 0, 0; 1, 1, 1];
    filter_v = [-1, 0, 1; -1, 0, 1; -1, 0, 1];
    
    if smooth == 1
        g = gaus(1);
        filter_h = convolution(filter_h, g', 'mirror');
        filter_v = convolution(filter_v, g, 'mirror');
    elseif smooth == 2
        g = gaus2d(1);
        img = convolution(img, g, 'mirror');
    end
    
    grad_h = convolution(img, filter_h, 'mirror');
    grad_v = convolution(img, filter_v, 'mirror');
    magnitude = sqrt(grad_h.^2 + grad_v.^2);
    orientation = atan2(grad_v, grad_h);
end