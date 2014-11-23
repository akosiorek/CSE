function tutorial5_ex3()
   
    fun = @(x) cos(x) .* exp(-0.5 * x.^2);
    integral = 2^(1/2)*pi^(1/2)*exp(-1/2)
    
    MonteCarlo(fun, -1000000, 1000000, 10000000)
    
end


function integral = MonteCarlo(fun, a, b, N)
   
    x = randn(1, N) * (b - a) - a;
    integral = sum(fun(x)) * (b - a) / N;
    
    
    
end

function n = determine(fun, exact, tol)
    
    n = 1;
    rhs = fun(1);
    while abs(rhs - exact) > tol
        n = n + 1;
        rhs = fun(n);
    end
end