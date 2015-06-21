% computes the residual for a 2D (an)isotropic Poisson problem
% a,b    - coefficients in front of second derivatives of Poisson problem
% u      - solution vector
% rhs    - right hand side of poisson problem
function res=ex2_residual(a,b,u,rhs);

% size of solution in x- and y-direction (including boundary points)
Nx = length(u(:,1));
Ny = length(u(1,:));
% mesh size
hx = 1/(Nx-1);
hy = 1/(Ny-1);

% initialise residual
res = zeros(Nx,Ny);

% compute residual
for i = 2 : 1 : Nx-1
    for j = 2 : 1 : Ny-1
        res(i,j) = rhs(i,j) - a/hx^2*(u(i-1,j)-2*u(i,j)+u(i+1,j)) - b/hy^2*(u(i,j-1)-2*u(i,j)+u(i,j+1));
    end
end

return
