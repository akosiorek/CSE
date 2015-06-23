function restricted = ex4_restrict(stencil, residual)
    
    assert(mod(size(residual, 1), 2) == 1, 'Cannot coarsen');
    N = (size(residual, 1) - 1) / 2 + 1;
    
    restricted = zeros(N, 1);
    
    % boundary conditions
    restricted(1) = residual(1);
    restricted(end) = residual(end);
    
    restrict = [-stencil(1) stencil(2) -stencil(3)] / stencil(2);
    
    for x = 2:N-1
        restricted(x) = restrict * residual(2*x-2:2*x);
    end    
end