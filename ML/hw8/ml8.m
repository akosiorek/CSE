
close all, clear all

f0 = @(x) x.^2 + 1;
f1 = @(x) (x-2) .* (x-4);



xx = linspace(0, 5, 100);

%% problem 5
xx0 = linspace(2, 4, 100);

figure(1)
hold on
plot(xx, f0(xx), 'r-', 'LineWidth', 2);
plot(xx, f1(xx), 'b-', 'LineWidth', 2);
plot(xx0, f1(xx0), 'g-', 'LineWidth', 2);
plot([2 2], [-10 70], 'g-');
plot([4 4], [-10 70], 'g-');
title('function and its constraint');
xlabel('x');
ylabel('f(x)');
legend('f0', 'f1', 'feasible region');
 

%% problem 6

as = [0 0.5 1 3 4 5 8];
colors = 'rgbkcmy';
L = @(x, a) f0(x) + a .* f1(x);

figure(2)
hold on


for i = 1:numel(as)
    c = colors(i);
    a = as(i);
    plot(xx, L(xx, a), c, 'LineWidth', 2);
end
title('Lagrangian for different alphas');
xlabel('x')
ylabel('L(x, a)');
legend('a = 0', 'a = 0.5', 'a = 1', 'a = 3', 'a = 4', 'a = 5', 'a = 8');


%% problem 7
g = @(a) (-a.^2 + 9 * a +1) ./ (1 + a);
aa = linspace(0, 8, 100);

figure(3)
plot(aa, g(aa), 'b-', 'LineWidth', 2);
title('Lagrange dual function');
xlabel('a');
ylabel('g(a)');



