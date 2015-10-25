function [magnitude, orientation] = gradients(img, smooth)
   
    
    filter_h = [-1, -1, -1; 0, 0, 0; 1, 1, 1];
    filter_v = [-1, 0, 1; -1, 0, 1; -1, 0, 1];
    
    if smooth
        g = gaus(1);
        filter_h = conv2(filter_h, g');
        filter_v = conv2(filter_v, g);
    end
    
    grad_h = conv2(img, filter_h);
    grad_v = conv2(img, filter_v);
    
    magnitude = sqrt(grad_h.^2 + grad_v.^2);
    orientation = atan2(grad_v, grad_h);
end