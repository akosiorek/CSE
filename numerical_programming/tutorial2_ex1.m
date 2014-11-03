function tutorial2_ex1
clear all, clc, close all
f = @(x) 1 ./ (1 + x .^ 2);
x0 = -5;
xN = 5;
vis_interval = 0.02;

N = [3, 5, 15, 25, 35];
x_vis = x0 : vis_interval : xN;

interp_function = {@linspace, @chebyshev_points};

for j = 1:length(interp_function)
    for i = 1 : length(N)
        x = interp_function{j}(x0, xN, N(i));
        f_val = f(x);
        p = polyfit(x, f_val, N(i) - 1);
        p_val = polyval(p, x_vis);
        errors = lagrange(x, x_vis);% ./ factorial(N(i) + 1);

        subplot(length(interp_function), length(N), (j - 1) * length(N) + i);
        hold on
        grid on
        plot(x_vis, p_val, 'r-');
        plot(x, f_val, 'b*');
        plot(x_vis, errors, 'g');
        title(strcat('N = ', int2str(N(i))));    
        hold off
    end
end
legend('approximation', 'precise values', 'lagrange')


end


function values = lagrange(nodes, x) 

    values = prod(repmat(x', 1, length(nodes)) - repmat(nodes, length(x), 1), 2);    
    
end

function points = chebyshev_points(x0, xN, N)

    points = cos([0:(N-1)] * pi / N) * (xN - x0) / 2;
end

%%  Comments
%
%   Since error bound is exponential for equidistant points the error
%   should explore for a large number of points, while remaining relatively
%   small for chebyshev points. According to the formula from the Worksheet
%   2 Ex 1 the definig factors is l(x) = (x - x0)(x - x1)...(x - xN). This
%   factor, however, has very similar values for equidistant points for
%   chebyshev points where their number is the same. Moreover, the error
%   measure comprise the factor of 1 / factorial(n + 1). When I divide
%   l(x) by this factor I get really small values for large point numbers
%
%
%
%
%
%
%
%
%