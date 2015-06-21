function interp = ex2_interpolate(e)
   
    S = size(e) .* 2 -1;  % restricted residual size
    Ny = S(1);
    Nx = S(2);
    
    interp = zeros(Ny, Nx);
    
    for y = 2:Ny-1
        for x = 2:Nx-1
       
            xm = mod(x, 2);
            ym = mod(y, 2);
            
            if xm && ym % coincides with a coarse grid point
                interp(y, x) = e((y+1)/2, (x+1)/2);
            elseif xm   % between 2 points on y axis
                interp(y, x) = 0.5 * (e(y/2, (x+1)/2) + e(y/2 + 1, (x+1)/2));
            elseif ym   % between 2 points on x axis
                interp(y, x) = 0.5 * (e((y+1)/2, x/2) + e((y+1)/2, x/2 + 1));
            else        % between 4 points
                interp(y, x) = 0.25 * (...
                        e(y/2, x/2) + e(y/2, x/2 + 1) ...
                    +   e(y/2 + 1, x/2) + e(y/2 + 1, x/2 + 1) );       
        end
        end
end