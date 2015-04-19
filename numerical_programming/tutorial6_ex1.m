function tutorial6_ex1()
    close all, clear all, clc
    
    F = 1/6;
    f = @(x) x.^5;
    w = @(x, k) (k + 1) .* x .^ k;
    map = @(x, k) x .^ (1/(k + 1));
    k = 4.5;
    
    n = 10 .^ [1:7]';
    for i = 1:length(n)
        x = rand(n(i), 1);
        y(i) = mean(f(x));
        x = map(x, k);
        yw(i) = mean(f(x) ./ w(x, k));
        
        error(i) = abs(F - y(i));
        errorw(i) = abs(F - yw(i));
    end
    F
    y
    error
    
    figure(1)
    loglog(n, error, 'r-')
    hold on
    plot(n, 1./sqrt(n), 'g--')
    plot(n, errorw, 'b-');
    legend('approximation error', 'sqrt(n)', 'importance sampling k=4');
    
    
    
end