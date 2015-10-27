function g = gaus(sigma)
    s = round(sigma);
    o = (3 * s - 1) / 2 + 1;
    g = (1:3*s) - o;
    g = exp(-0.5 .* (g / sigma).^2) * sqrt(0.5 / pi / sigma^2); 
    g = g / sum(g);
end