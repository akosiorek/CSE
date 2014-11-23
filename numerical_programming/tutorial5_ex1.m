function tutorial5_ex1()
   
    fun = @(x) 1 ./ (x + 4);
    integral = @(x0, x, a) log(x + a) - log(x0 + a);
    tol = 10^-6;
    
    exact = integral(0, 2, 4)
    CompositeMidpoint(fun, 0, 2, 1);
    CompositeTrapezoidal(fun, 0, 2, 1);
    CompositeSimpson(fun, 0, 2, 1);
    
    determine(@(n) CompositeMidpoint(fun, 0, 2, n), exact, tol)
    determine(@(n) CompositeTrapezoidal(fun, 0, 2, n), exact, tol)
    determine(@(n) CompositeSimpson(fun, 0, 2, n), exact, tol)
    
end

function integral = CompositeMidpoint(fun, a, b, N)
    
    h = (b - a) / N;
    c_i = a + 0.5 * (2 * (1:N) - 1) * h;
    f = fun(c_i);   % A sample function
    integral = h * sum(f);

end

function integral = CompositeTrapezoidal(fun, a, b, N)
    
    h = (b - a) / N;
    x = a+h : h : b-h;
    integral = h/2 * (2 * sum(fun(x)) + fun(a) + fun(b));
 
end

function integral = CompositeSimpson(fun, a, b, N)
    
    h = (b - a) / N;
    xi0 = fun(a) + fun(b);
    xi1 = 0;
    xi2 = 0;
    x = a;
    for i = 1 : N-1
        x = x + h;
        if mod(i,2) == 0
            xi2 = xi2 + fun(x);
        else
            xi1 = xi1 + fun(x);
        end
    end
    integral = h * (xi0 + 2 * xi2 + 4 * xi1) / 3;
    
end

function n = determine(fun, exact, tol)
    
    n = 1;
    rhs = fun(1);
    while abs(rhs - exact) > tol
        n = n + 1;
        rhs = fun(n);
    end
end
    
    