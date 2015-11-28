function perceptron()
close all
% x = [
%     0 0;
%     -0.1 0.1;
%     -0.3 -0.2;
%     0.2 0.1;
%     0.2 -0.1;
%     -1.1 -1;
%     -1.3 -1.2;
%     -1 -1;
%     1 1;
%     0.9 1.2;
%     1.1 1;
%     ];

% y = [1 1 1 1 1 -1 -1 -1 -1 -1 -1]';

x = [-0.7 0.8; -0.9 0.6; -0.3 -0.2; -0.6 0.7; 0.6 -0.8; 0.2 -0.5; 0.3 0.2];
y = [1 1 1 1 -1 -1 -1]';

 
as = x(y == 1, :);
bs = x(y == -1, :);


xx = [min(x(:))-1 max(x(:))+1];

N = 4;
w = [0 0]';
b = 0;

figure(1)
for k = 1:N
    subplot(2, 2, k)
    title(sprintf('Iteration %d', k-1));
   
    z = out(x, w, b);
    diff = (z ~= y);
    
    errors = sum(diff);
    slope = -w(1) / w(2);
    fprintf('Iter = %d, Errors = %d, Slope = %f\n', k-1, errors, slope);
    
    hold on
    plot(as(:, 1), as(:, 2), 'mo', 'MarkerSize', 10, 'LineWidth', 4);
    plot(bs(:, 1), bs(:, 2), 'rx', 'MarkerSize', 10, 'LineWidth', 4);
    yy = slope * xx - b / w(2);
    plot(xx, yy, 'b', 'LineWidth', 2);
    axis([xx xx]);
    pause
    
    w = w + sum(repmat(y(diff), [1 2]) .* x(diff, :))';
    b = b + sum(y(diff));
end


end


function a = activ(x, w, b)
    a = x * w + b;
end

function o = out(x, w, b)
    o = -1 + 2 * (activ(x, w, b) >= 0);
end