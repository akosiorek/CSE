% Gauss-Seidel smoother using a three-point stencil, a solution
% vector y and a right hand side rhs as input.
function y = smooth(stencil,y,rhs);

l = length(y);

for i = 2 : 1 : l-1
    % Gauss-Seidel
    y(i) = 1/stencil(2)*(rhs(i) - stencil(1)*y(i-1)-stencil(3)*y(i+1));
end

return
