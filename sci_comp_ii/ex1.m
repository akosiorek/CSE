function ex1(N, iters)
    close all, clc
    
    h = 1/N;
    freqs = [1 3 7];
    u = init(N, freqs);
    
    errors = zeros(iters + 1, 1);
    errors(1) = max(u);
    for i = 2:iters+1
        u = jacobi(u, 1);
        errors(i) = max(u);
    end
    
    errorDecreaseRate = errors(2:end)./errors(1:end-1);
    meanErrorDecreateRate = mean(errorDecreaseRate);
    
    figure(1)
    hold on
    plot(0:iters, errors, '.-')
    plot(1:iters, errorDecreaseRate, 'r.-');
    plot(1, meanErrorDecreateRate, 'm*');
    legend('error value', 'error decrease rate', 'mean error decrease rate: ')
    xlabel('iterations')
    ylabel('error')
    grid on
    
    fprintf('Mean error decrease rate: %.3f\n', meanErrorDecreateRate);
    
    
    
    
    
end

function u = init(N, freqs)
   
    h = 1 / N;
    x = linspace(0, 1, N + 1)';
    u = zeros(N + 1, 1);
    for freq = freqs
        u = u + sin(pi * freq * h * x);
    end    
    u(1) = 0;
    u(end) = 0;
end

function u = jacobi(u0, iter) 
   
    u = zeros(size(u0));
    u(1) = u0(1);
    u(end) = u0(end);
    while iter > 0
        for i = 2:numel(u0)-1
            u(i) = 0.5 * (u0(i-1) + u0(i+1));
        end
        u0 = u;
        iter = iter - 1;
    end
end