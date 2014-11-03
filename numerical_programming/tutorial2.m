
%%  Polynomial Interpolation
%   
%   given (xi, yi), i =0:N, find a polynomial p(x) s.t.:
%       1) degree <= N
%       2) p(xi) = yi
%       existence -> Lagrange
%       unique -> ? but it is
%
%   if p(x), deg(p(x)) = N & p(x) = 0 for xi => p(x) = 0 for every x
   
close, clc, clear all

%% Exercise 1

% f = @(x) 1 ./ (1 + x .^ 2);
% N = [5, 15, 25, 35]; %# points
% colour = 'rgbk';
% 
% x0 = -5;
% xN = 5;
% vis_interval = 0.02;
% 
% x_vis = x0:vis_interval:xN;
% 
% figure(1)
% hold on
% grid on
% for i = 1:length(N)
%    x = linspace(x0, xN, N(i)); 
%    p = polyfit(x, f(x), N(i) - 1);
%    p_values = polyval(p, x_vis);
%    plot(x_vis, p_values, colour(i))
% end
% hold off

%% Exercise 2
