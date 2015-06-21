function solution = ex2_vCycle(a, b, u, rhs, preSmoothing, postSmoothing, level, mgID)
    
    % base case -> 1 iter of Gauss-Seidel and return
    if level == 1
        num = prod(size(u) - 2);
        if num > 1
            for i = 1:1e0
                u = ex2_gaussSeidel(a, b, u, rhs);
            end
            solution = u;
        else
            solution = ex2_gaussSeidel(a, b, u, rhs);
        end
        return
    end
    
    
    % pre-smoothing
    for i = 1:preSmoothing
        u = ex2_gaussSeidel(a, b, u, rhs);
    end
    
    % residual restriction
    residualFine = ex2_residual(a, b, u, rhs);
    residualCoarse = restrict(residualFine, mgID);     
    
    % recurse on vCycle
    errorCoarse = zeros(size(residualCoarse));
    errorCoarse = ex2_vCycle(a, b, errorCoarse, residualCoarse, preSmoothing, ...
        postSmoothing, level - 1, mgID);
    
    % error interpolation
    errorFine = interpolate(errorCoarse, mgID);
    
    % solution correction
    u = u + errorFine;
    
    % post-smoothing
    for i = 1:postSmoothing
        u = ex2_gaussSeidel(a, b, u, rhs);
    end
    
    solution = u;    
end



function coarse = restrict(fine, mgID)
      if strcmp(mgID.restriction, 'injection')
        coarse = ex2_restrict_injection(fine);
    elseif strcmp(mgID.restriction, 'full_weight')
        coarse = ex2_restrict_fullweighting(fine);
    elseif strcmp(mgID.restriction, 'semi')
        coarse = ex2_restrict_semi(fine);
    else
        assert(0, 'Incorrect restriction mode');
        return
    end
end

function fine = interpolate(coarse, mgID) 
    if strcmp(mgID.interpolation, 'bilinear')
        fine = ex2_interpolate(coarse);
    elseif strcmp(mgID.interpolation, 'semi')
        fine = ex2_interpolate_semi(coarse);
    else
        assert(0, 'Incorrect interpolation mode');
        return
    end
end