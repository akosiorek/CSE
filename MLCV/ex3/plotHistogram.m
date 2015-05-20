function plotHistogram(data, bins, name)   
    minValue = min(data);
    maxValue = max(data);
    
    x = linspace(minValue, maxValue, bins + 1);
    xx = zeros(bins, 1);
    y = zeros(bins, 1);
    
    for i = 1:bins
        y(i) = nnz(data >= x(i) & data < x(i + 1)); 
        xx(i) = (x(i) + x(i+1)) / 2;
    end
    
%     x = round(1000*x)/1000;
    plot(xx, y, '*');  
    xlabel('Uncertainty')
    ylabel('Number of data points')
    grid on
    set(gca, 'XTick', x);
    axis([minValue maxValue 0 max(y)+1])
    
    print('-depsc', name);
end