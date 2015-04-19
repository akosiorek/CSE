function worksheet9
    clear all, close all, clc
    
    %% ex1
    
    f2 = @(x) x.^3 - 2.*x + 2;
    df2 = @(x) 3 .* x .^ 2 - 2;
    x = linspace(-2, 2);
    figure(1)
    hold on
    plot(x, f2(x))
    plot(x, df2(x), 'r');
    plot(x, f2(x)./df2(x), 'g');
    grid
    legend('f', 'df', 'f/df');
    
    %% ex2
    f1 = @(x, a) 0.2 * (4 * x + a / x);
    f2 = @(x, a) 0.5 * (x + a / x);
    f3 = @(x, a) 0.01 * (99 * x  + a / x);
    
    function [fixed, iter] = findFixed(fun, tol)
       
        e = realmax;
        x0 = 1;
        x1 = x0;
        iter = 0;
        while e > tol
            
            x1 = x0;
            x0 = fun(x0);
            e = abs(x0 - x1);
            iter = iter + 1;
        end
        
        fixed = x0;
    end
    
    a = 9;
    tol = 1e-16;
    [f1_fixed, f1_iter] = findFixed(@(x) f1(x, a), tol)
    [f2_fixed, f2_iter] = findFixed(@(x) f2(x, a), tol)
    [f3_fixed, f3_iter] = findFixed(@(x) f3(x, a), tol)
    
    
    %% ex3
    n = 100;
    A = diag(1:n) + diag(ones(1, n - 1), -1) + diag(ones(1, n - 1), 1);
    b = ones(n, 1);
    x = A\b
end