function interp = ex2_interpolate_semi(e)
   
    % restricted residual size
    Ny = size(e, 1);
    Nx = size(e, 2) * 2 -1;
    
    interp = zeros(Ny, Nx);
    
    for y = 2:Ny-1
        for x = 2:Nx-1
            if mod(x, 2) % coincides with a coarse grid point
                interp(y, x) = e(y, (x+1)/2);
            else    % between 2 points on x axis
                interp(y, x) = 0.5 * (e(y, x/2) + e(y, x/2 + 1));      
        end
        end
end