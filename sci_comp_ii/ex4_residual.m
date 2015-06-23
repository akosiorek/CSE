function res = ex4_residual(stencil, u, rhs)
   
    res = zeros(size(u));
    
    for x = 2:size(u, 1) - 1;
        res(x) = rhs(x) - stencil * u(x-1:x+1);
    end
    
    % BCs
    res(1) = rhs(1) - u(1);
    res(end) = rhs(end) - u(end);
end