function solution = ex4_wCycle(u, rhs, stencil, preSmoothing, ...
        postSmoothing, level)
    
    % base case -> 1 iter of Gauss-Seidel and return
    if level == 1
        solution = ex4_smooth(stencil, u, rhs);
        return
    end        
    
    % pre-smoothing
    for i = 1:preSmoothing
        u = ex4_smooth(stencil, u, rhs);
    end
    
    % residual restriction
    residualFine = ex4_residual(stencil, u, rhs);
    residualCoarse = ex4_restrict(stencil, residualFine);     
    
    % recurse on wCycle
    errorCoarse = zeros(size(residualCoarse));
    stencilCoarse = ex4_computeCoarseGridStencil(stencil);
    for i = 1:2
        errorCoarse = ex4_wCycle(errorCoarse, residualCoarse, ... 
            stencilCoarse, preSmoothing, postSmoothing, level - 1);
    end
    
    % error interpolation
    errorFine = ex4_interpolate(stencil, errorCoarse);
    
    % solution correction
    u = u + errorFine;
    
    % post-smoothing
    for i = 1:postSmoothing
        u = ex4_smooth(stencil, u, rhs);
    end
    
    solution = u;    
end