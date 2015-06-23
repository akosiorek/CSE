function ex2()
   close all, clc
   
   % Configuration
   tolerance = 1e-12;
   epsi = 1;
   preSmoothing = 2;
   postSmoothing = 2;
   level = 10;   
   
   % Initialization
   N = 2 ^ level;
   h = 1 / N;
   f = @(x) 2 * x - (2 * eps + 1);
   L = -(epsi * h^-2 + h^-1);
   C =  2*epsi * h^-2 + h^-1;
   R = -epsi * h^-2;
   stencil = [L  C  R];
   
   u = zeros(N + 1, 1);
   rhs = f(linspace(0, 1, N + 1))';
   rhs(1) = 0;
   rhs(end) = 0;
   
   % Execution
   iter = 0;
   maxResidual = max(abs(ex4_residual(stencil, u, rhs)));
   error(1) = maxResidual;
   tic
   while  maxResidual > tolerance
       u = ex4_wCycle(u, rhs, stencil, preSmoothing, postSmoothing, level);
       maxResidual = max(abs(ex4_residual(stencil, u, rhs)));
       iter = iter + 1;
       error(iter+1) = maxResidual;
   end
   toc
   
   % Post-procesing
   fprintf('Executed %d iterations\n', iter);
   
   
   
   
   figure(1)
   hold on
   grid on
   plot(0:numel(error)-1, error, 'k.-');
   legend('wCycle');
    
    
    
end


function u = init(Ny, Nx)
   
    y = linspace(0, 1, Ny + 1);
    x = linspace(0, 1, Nx + 1);    
    
    [Y, X] = meshgrid(y, x);
    u = sin(pi * X) .* sin(pi * Y);    
end