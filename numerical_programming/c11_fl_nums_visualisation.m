% 1.1.7. Visualization. Let b = 2. The digits of a normalaized floating points number
% define m in {bp, . . . , 2bp − b} such that
% x = ±m · b^(e−p)

close all, clear all

b = 2;
p = 3;
emin = -1;
emax = 3;
F = 0;
for m = b^p : 2 * b^p - b
    
    F = [F, m * b .^ ([emin : emax] - p)];
end
figure(1)
hold on
grid
plot(F, zeros(length(F)), 'r*')


m = 0 : b^p - b;
F = m * b .^ (emin - p);

plot(F, zeros(length(F)), 'bo')
title('spacing of floating point numbers around 1')
legend('normalized nums', 'subnormal nums')

