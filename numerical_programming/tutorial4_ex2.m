function tutorial4_ex2(N)
   close all; %clear all;
   
   runge = @(x) 1 ./ (1 + x .^ 2);
   s0 = 0.5;
   sN = 0.5;
   
   xMin = -1;
   xMax = 1;
   %N = 4;
   N_vis = 500;
   assert(N <= N_vis)
   
   x_vis = linspace(xMin, xMax, N_vis);
   y_vis = runge(x_vis);
   
   x_nodes = linspace(xMin, xMax, N + 1);
   y_nodes = runge(x_nodes);
   
   [a, b, h, s] = cubic_spline(x_nodes, y_nodes, s0, sN);   
   y_interp = evaluate_cubic(x_vis, x_nodes, a, b, h, s);   
   
   figure(1);
   hold on; grid on;
   plot(x_vis, y_vis, 'b-')
   plot(x_nodes, y_nodes, 'mo');
   plot(x_vis, y_interp, 'r-');
   legend('function', 'nodes', 'interpolant');   
   
   h = x_vis(2) - x_vis(1);
   h_n = x_nodes(2) - x_nodes(1);
   mp = integrate_midpoint(y_nodes, h_n);
   trap = integrate_trapezoid(y_nodes, h_n);
   simps = integrate_simpson(y_nodes, h_n);
   precise = pi / 2;
   disp([precise mp trap simps]);
   disp(abs([precise mp trap simps] - precise));
  
end

function y = evaluate_cubic(x, nodes, a, b, h, s) 
   
    y = zeros(size(x));
    node = 1;
    for i = 1:length(x)
       
        if x(i) > nodes(node + 1)
            %disp([node nodes(node) i x(i)]);
            node = node + 1;
        end
        y(i) = a(node)  + b(node) * (x(i) - nodes(node)) + s(node) / (6 * h(node)) * (nodes(node+1) - x(i))^3 + s(node+1) / (6 * h(node)) * (x(i) - nodes(node))^3;
    end
    
end


function [a, b, h, s] = cubic_spline(x, y, s0, sN)
   
    assert(length(x) == length(y));
    
    N = length(x) - 1;
    h = diff(x); % h0, h1, ..., hN-1
    d = diff(y) ./ h; % d0, d1, ..., dN-1

    A = (zeros(N + 1) + diag(h, -1) + diag(h, +1) + 2 * diag([0 h(1:N-1) + h(2:N) 0])) / 6;
    A(1, 1) = 1;
    A(1, 2) = 0;
    A(N + 1, N + 1) = 1;
    A(N+1, N) = 0;
%     A = (diag(h(2:N-1), -1) + diag(h(2:N-1), +1) + 2 * diag(h(1:N-1) + h(2:N))) / 6;
   
    
    rhs = diff(d);
    % applying boundary conditions
    rhs = [s0 rhs sN];
    
    s = A \ rhs'; % s = s0, s1, s2, ..., sN-1, sN
    s = s';
    % applying boundary conditions
%     s = [s0 s sN];
    
    b = d - diff(s) .* h / 6;
    a = y(1:N) - (s(1:N) .* h .^ 2) / 6;    
end

function integral = integrate_midpoint(y, h)
    
    integral = 0;
    for i = 1 : floor(length(y) / 2)
        integral = integral + 2 * h * y(i * 2);
    end
end

function integral = integrate_trapezoid(y, h)
   integral = ((y(1) + y(length(y))) / 2 + sum(y(2:length(y)-1))) * h;
end

function integral = integrate_simpson(y, h)
    odd = 0;
    even = 0;
    for i = 0:floor(length(y)/2)
        odd = odd + y(2 * i + 1);
    end
      for i = 1:floor(length(y)/2)
        even = even + y(2 * i);
    end
    integral = h * (y(1) + y(length(y)) + 4 * odd + 2 * even) / 3;
    
end


























