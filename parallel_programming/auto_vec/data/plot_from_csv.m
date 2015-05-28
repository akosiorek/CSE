function plot_from_csv()
    close all, clear all, clc
    
    colors = 'rkbm';
    names = {'scalar', 'sse4', 'avx'};
    prefix = '2x1_';
    suffix = '.txt';
    
    p_peak = 15.47;
    total_cols = 5;    
    cache_size = 32 * 2^10;
    cache_boundary = cache_size / 8 / total_cols;       
    
    max_num = 0;
    max_perf = 0;
    
    figure(1)
    hold on
    grid on
    for i = 1:numel(names)
        filename = strcat(strcat(prefix, names{i}), suffix);
        data = csvread(filename);
        plot(data(1, :), data(2, :), strcat(colors(i), '*-'), 'LineWidth', 2)
        
        max_num = max(max_num, max(data(1, :)));
        max_perf = max(max_perf, max(data(2, :)));
    end
    
    x = linspace(0, max(cache_boundary, max_num), 10);
    y = p_peak * ones(size(x));
    plot(x, y, 'm')
    
    y = linspace(0, max(max_perf, p_peak), 2);
    x = cache_boundary * ones(size(y));
    plot(x, y, 'g')
    
    xlabel('Number of rows of A')
    ylabel('Performance [GFlops]')
    legend('scalar', 'sse', 'avx', 'P_{peak}', 'Cache limit')
end