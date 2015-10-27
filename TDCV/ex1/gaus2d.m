function g = gaus2d(sigma)
   
    s = round(sigma);
    g = zeros(3 * s);
    o = (3 * s - 1) / 2 + 1;
    
    for x = 1:3*s
        for y = 1:3*s
            g(x, y) = (x-o)^2 + (y-o)^2;
        end
    end
    g = exp(-0.5 .* g / sigma^2) * sqrt(0.5 / pi / sigma^2);
    g = g / sum(g(:));
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    