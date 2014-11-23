function tutorial4_ex1()
    clear all; close all;
    % http://en.wikipedia.org/wiki/Gibbs_phenomenon
   
    N = 27 * 2 .^ (0:7);
    f = @(x) 2 * (x > 0.25 & x < 0.75);
    
    x_vis = linspace(0, 1, 500);
    f_vis = f(x_vis);
    
    
    figure(1)
    for ind = 1:length(N)
        n = N(ind);
        
        x_val = linspace(0, 1 - 1/n, n);    
        f_val = f(x_val);    
        f_hat = FT_bf(-1, f_val);    
        f_spectral = zeros(size(x_vis));        
        
        for k = 1:n
            if k <= N / 2
                f_spectral = f_spectral + f_hat(k) * exp(1i * 2 * pi * (k - 1) * x_vis);
            else
                f_spectral = f_spectral + f_hat(k) * exp(1i * 2 * pi * ((k - 1) - n) * x_vis);
            end
        end 
        
        subplot(ceil(length(N) / 2), 2, ind);
        hold on, grid on
        plot(x_vis, f_vis, 'r-');
        plot(x_vis, real(f_spectral), 'b-');
        if n < 256
            plot(x_val, f_val, 'ko');
        end
        title(num2str(n));
    end
    legend('function', 'interpolant', 'nodes');
    
end

