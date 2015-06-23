function interpolated = ex4_interpolate(stencil, error)
    
    N = (size(error, 1) - 1) * 2 + 1;
    
    interpolated = zeros(N, 1);
    
    % boundary conditions
    interpolated(1) = error(1);
    interpolated(end) = error(end);
    
    % copy coninciding points
    for x = 1 : 2 : N
        interpolated(x) = error(0.5*(x + 1));
    end
    
    L = stencil(1);
    C = stencil(2);
    R = stencil(3);    
    
    % full weight the rest
    for x = 2 : 2 : N
        xC = x / 2;
        interpolated(x) = -(L * error(xC) + R * error(xC + 1)) / C;
    end    
end