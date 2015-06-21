function ex2()
   close all, clc
   
   % Configuration
   tolerance = 1e-12;
   a = 1e-4;
   b = 1;
   preSmoothing = 2;
   postSmoothing = 2;
   level = 5;   
   
   % Initialization
   Nx = 2 ^ level;
   Ny = 2 ^ level;     
   
   mgID.restriction = 'semi';
   mgID.interpolation = 'semi';
   u = init(Ny, Nx);
   rhs = zeros(size(u));
   
   % Execution
   iter = 0;
   maxResidual = max(max(ex2_residual(a, b, u, rhs)));
   error_semi(1) = maxResidual;
   tic
   while  maxResidual > tolerance
       u = ex2_vCycle(a, b, u, rhs, preSmoothing, postSmoothing, level, mgID);
       maxResidual = max(max(ex2_residual(a, b, u, rhs)));
       iter = iter + 1;
       error_semi(iter+1) = maxResidual;
   end
   toc
   
   % Post-procesing
   fprintf('Semicoarsening: executed %d iterations\n', iter);
   
   
   mgID.interpolation = 'bilinear';
   mgID.restriction = 'injection';
   u = init(Ny, Nx);
   rhs = zeros(size(u));
   
   % Execution
   iter = 0;
   maxResidual = max(max(ex2_residual(a, b, u, rhs)));
   error_injection(1) = maxResidual;
   tic
   while  maxResidual > tolerance
       u = ex2_vCycle(a, b, u, rhs, preSmoothing, postSmoothing, level, mgID);
       maxResidual = max(max(ex2_residual(a, b, u, rhs)));
       iter = iter + 1;
       error_injection(iter+1) = maxResidual;
   end
   toc
   
   % Post-procesing
   fprintf('Injection: executed %d iterations\n', iter);
   
   
   
   mgID.restriction = 'full_weight';
   u = init(Ny, Nx);
   rhs = zeros(size(u));
   
   % Execution
   iter = 0;
   maxResidual = max(max(ex2_residual(a, b, u, rhs)));
   error_full_weight(1) = maxResidual;
   tic
   while  maxResidual > tolerance
       u = ex2_vCycle(a, b, u, rhs, preSmoothing, postSmoothing, level, mgID);
       maxResidual = max(max(ex2_residual(a, b, u, rhs)));
       iter = iter + 1;
       error_full_weight(iter+1) = maxResidual;
   end
   toc
   
   % Post-procesing
   fprintf('Full weighting: executed %d iterations\n', iter);
   
   
   
   u = init(Ny, Nx);
   rhs = zeros(size(u));
   
   % Execution
   iter = 0;
   maxResidual = max(max(ex2_residual(a, b, u, rhs)));
   error_gs(1) = maxResidual;
   tic
   while  maxResidual > tolerance
       u = ex2_gaussSeidel(a, b, u, rhs);
       maxResidual = max(max(ex2_residual(a, b, u, rhs)));
       iter = iter + 1;
       error_gs(iter+1) = maxResidual;
   end
   toc
   
   % Post-procesing
   fprintf('Gauss-Seidl: executed %d iterations\n', iter);
   
   
   figure(1)
   hold on
   grid on
   plot(0:numel(error_semi)-1, error_semi, 'k.-');
   plot(0:numel(error_injection)-1, error_injection, 'r.-');
   plot(0:numel(error_full_weight)-1, error_full_weight, 'b.-');
   plot(0:numel(error_gs)-1, error_gs, 'm.-');
   legend('semicoarsening', 'injection', 'full weight', 'gs');
    
    
    
end


function u = init(Ny, Nx)
   
    y = linspace(0, 1, Ny + 1);
    x = linspace(0, 1, Nx + 1);    
    
    [Y, X] = meshgrid(y, x);
    u = sin(pi * X) .* sin(pi * Y);    
end