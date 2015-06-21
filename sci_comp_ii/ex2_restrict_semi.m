function restricted = ex2_restrict_semi(r)
    
    if mod(size(r, 2), 2) ~= 1
        disp('Cannot coarsen along X axis')
        return
    end   
    
    % restricted residual size
    Ny = size(r, 1);
    Nx = (size(r, 2) - 1) / 2 + 1;
    
    restricted = zeros(Ny, Nx);
    for y = 2:Ny-1
        for x = 2:Nx-1
            restricted(y, x) = 0.5 * r(y, 2*x - 2) ...
                + 0.25 * (r(y, 2*x - 1) + r(y, 2*x - 2));
        end
    end    
end