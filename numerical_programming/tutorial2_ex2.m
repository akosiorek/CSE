function tutorial2_ex2()
clc; clear all; close all

a = 0;
b = 1;
N = 30;
M = 128;

x = linspace(a, b * (1 - 1 / N), N);
f1 = cos(2 * pi * x);
f2 = (x - x(2)) .^ 2;

F1 = fourier_transform2(f1, M);
F2 = fourier_transform(f2);

x_plot = [0:M-1] / M;
figure(1)
hold on
grid on
plot(x_plot, real(F1), 'r*');
plot(x_plot, imag(F1), 'bo');
legend('real', 'imag');
axis([0 1 0 2]);


% n = [0:29];
% x = cos(2 * pi * n / 10);
% N = [30, 64, 128, 256];
% X = cell(3);
% F = cell(3);
% for i = 1:length(N)
%     X{i} = abs(fft(x, N(i)));
%     F{i} = [0 : (N(i) - 1)] / N(i);
%     subplot(length(N), 1, i);
%     plot(F{i}, X{i}, '-x');
%     title(strcat('N = ', num2str(N(i))));
%     axis([0 1 0 20]);
% end



end


function coeffs = fourier_transform(x) 

    N = length(x);
    F = diag([0:(N-1)]) * repmat([0:(N-1)], N, 1) * 2 * pi / N;
    F = exp(i * F);
    coeffs = F * x';
end

function coeffs = fourier_transform2(x, M) 

    N = length(x);
    F = repmat([0:(N-1)], M, 1);
    M = [0:M-1];    
    for i = 1:length(M)
        F(i, :) = F(i, :) * M(i);
    end    
    F = exp(i * F * 2 * pi / N) / length(x);   
    coeffs = F * x';
end

function values = inverse(X)

    N = length(X);
    F = diag([0:(N-1)]) * repmat([0:(N-1)], N, 1) * 2 * pi;
    F = exp(-i * F);
    values = F \ X;
end