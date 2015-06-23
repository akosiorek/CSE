function coarseStencil = ex4_computeCoarseGridStencil(stencil)
    
    coarseStencil = [-stencil(1)^2 (stencil(1)^2 + stencil(3)^2) ...
        -stencil(3)^2] / stencil(2);
    
end