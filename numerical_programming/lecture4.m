

%%  Orthogonality
n = 20;
x = 2 * pi * [0:(n - 1)] / n;
y = exp(1i * x);
plot(real(y), imag(y), '*');
grid on