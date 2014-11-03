function numerics()
clc
clear all
close

 
coeffs = [1 -18 144 -672 2016 -4032 5376 -4608 2304 -512];

x = linspace(1.920, 2.080, 161);

power = (x - 2) .^ 9;
poly = polyval(coeffs, x);

figure(1)
hold on
grid on
plot(x, power, 'r');
plot(x, poly, 'b');
plot(x, sorted_poly(coeffs, x), 'g');
hold off
end

function vals = sorted_poly(coeffs, x)

    order = length(coeffs)
    vals = zeros(size(x));

    for i = 1:length(x)
        inter = coeffs .* x(i) .^ (order-1:-1:0);
        inter = sort(inter);
        for j = 1:order/2
            vals(i) = vals(i) + inter(j) + inter(order - j + 1);
        end
    end
end