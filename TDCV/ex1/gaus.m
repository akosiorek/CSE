function g = gaus(sigma)
    s = round(sigma);
    g = zeros(3 * s, 1);
    o = (3 * s - 1) / 2 + 1;
    
    for x = 1:3*s
            g(x) = x-o;
    end
    g
    g = exp(-0.5 .* (g / sigma).^2) * sqrt(0.5 / pi / sigma^2); 
end