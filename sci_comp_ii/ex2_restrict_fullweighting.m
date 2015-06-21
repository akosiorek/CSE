function restricted = ex2_restrict_fullweighting(r)
   
     if mod(size(r, 1), 2) ~= 1
        disp('Cannot coarsen along Y axis')
        return
    end
    
    if mod(size(r, 2), 2) ~= 1
        disp('Cannot coarsen along X axis')
        return
    end   
    
    S = (size(r) - 1) ./ 2 + 1;  % restricted residual size
    Ny = S(1);
    Nx = S(2);
    
    restricted = zeros(Ny, Nx);
    for y = 2:Ny-1
        for x = 2:Nx-1
            restricted(y, x) = ...
                0.25 * r(2*y -1, 2*x - 1) ...
                + 0.125 * ( r(2*y - 1, 2*x - 2) + r(2*y - 2, 2*x - 1) ...
                          + r(2*y,2*x - 1) + r(2*y - 1, 2*x) ) ...
                + (1/16) * ( r(2*y - 2,2*x - 2) + r(2*y,2*x - 2) ...
                           + r(2*y - 2, 2*x) + r(2*y, 2*x) );
        end
    end    
end