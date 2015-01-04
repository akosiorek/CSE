function c21_algebraic_interpolation
    clear all; close all;


    %% lagrange polynomial I
    x = linspace(-1, 1, 7);
    y = zeros(size(x));
    y(end-1) = 1;
    p = polyfit(x, y, length(x) - 1);

    xx = linspace(-1, 1);
    yy = polyval(p, xx);

    figure(1)
    plot(xx, yy, x, y, '*');
    grid on
    title('lagrange polynomial')

    %% lagrange polynomials II
    
%     function yy = lagrange_interp(x_in)
%        
%         numerator = prod(x_in - x);
%         p = 
%         for i = 1:length(x)
%             lj = prod / (x_in - x(i));
%             lj = lj / (prod(x(1:i)) * prod(i+1:end))
%             
%         
%         
%     end

    %% Chebyshev nodes

    n = 8;
    x = cos(pi / n * [0:n]);
    figure(3)
    plot(x, zeros(length(x)), '*');
    title('chebyshev nodes');
    grid on
    
    %% The first barycentric interpolation formula
    
    n = 8;
    x = cos(pi / n * [0:n]);    % chebyshev points 
    y = 1 ./ (1 + 25 * x.^2);   % runge function
    
    w = zeros(1, n + 1);     % weights wj = prod_k!=j (xj - xk)^-1
    for j = 1 : n+1
        w(j) = prod(x(j) - x([1 : j-1, j + 1 : end])) .^ -1;
    end
    
    
    xx = linspace(-1, 1);   % vis pints
    yy = 1 ./ (1 + 25 * xx .^ 2);
    
    
    l = 1;  % node polynomial l = prod_k=0:n (x - xk)
    s = 0;  % sum_j=0:n yj * wj / (x - xj)
    
    for j = 1 : n + 1
        l = l .* (xx - x(j));
        s = s + y(j) * w(j) ./ (xx - x(j));
    end
    
    p = l .* s; % barycentric interp polynomial  
    
    figure(4)
    hold on
    plot(xx, yy, 'b')
    plot(xx, p, 'r')
    plot(x, y, '*')
    grid on
    
%     % above interpolation is the same as polyval; uncomment \/
%     pp = polyfit(x, y, n);
%     yyy = polyval(pp, xx);
%     plot(xx, yyy, 'g')
  
    

    
end
