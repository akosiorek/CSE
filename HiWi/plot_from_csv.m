function plot_from_csv()
    close all, clear all, clc
    
    dim = '2x1';
    p_peak = 15.47;
    total_cols = 5;
    
    cache_size = 32 * 2^10;
    cache_boundary = cache_size / 8 / total_cols;
    normalData = sprintf('normal/%s.txt', dim);
    transposedData = sprintf('transposed/%s.txt', dim);
    blasData = sprintf('blas/%s.txt', dim);
    
    if ismember('transposedData', who)
        data_files = {normalData, transposedData, blasData};
    else
        data_files = {normalData blasData};
    end
    colors = 'rkb';
    
    max_num = 0;
    max_perf = 0;
    
    figure(1)
    hold on
    grid on
    for i = 1:numel(data_files)
        data = csvread(data_files{i});
        data = data(:, 1:21);
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
    %title(sprintf('Performance of C = Ax + C with x = [%s]', dim))
    if ismember('transposedData', who)        
        legend('Normal', 'Transposed', 'MKL', 'P_{peak}', 'Cache limit')
    else
        legend('Normal', 'MKL', 'P_{peak}', 'Cache limit')
    end

    print('-depsc', dim)
end