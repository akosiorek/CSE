%%  1. T-periodic function f1 -> 2pi periodic f2

function tutorial3_ex2()
    clc, clear all, close all

    t = (0:9) / 10;
    flow_rate = [0 35 0.125 5 0 5 1 0.5 0.125 0];
    
    % add points to show periodicity
    t = [t 1];
    flow_rate = [flow_rate 0];
    
    f_coefs = fft(flow_rate) / length(flow_rate);
    
    N = 1000;
    t_vis = linspace(0, 1 - 1/N, N);
    y_trig = trig_interp(t_vis, f_coefs);

    % normalize t before fitting the poly
%     t = (t - mean(t_vis)) / std(t);
    
    poly = polyfit(t, flow_rate, length(flow_rate) - 1);
    y_poly = polyval(poly, t_vis);


    figure(1)
    hold on
    plot(t, flow_rate, 'b-o');
    plot(t_vis, y_trig, 'r');
    plot(t_vis, y_poly, 'g');
    grid on;
    xlabel('time [ms]');
    ylabel('coeffs');
    legend('exact', 'trig', 'polynomial');
end

function val = trig_interp(x, f_coefs) 

    a = real(f_coefs);
    b = imag(f_coefs);
    val = zeros(size(x));
    for i = 1:length(a)
        val = val + a(i) * cos(-2 * pi *(i - 1) * x) + b(i) * sin(-2 * pi *(i - 1) * x);
    end
    
%     val = zeros(size(x));
%     for k = 1:length(f_coefs)
%         val = val + f_coefs(k) * exp(1i * 2 * pi * (k - 1) * x);
%     end

end