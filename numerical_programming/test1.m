clc
n = 100;
i = (i:n)';
h = 1/(n + 1);
% f = ones(size(i));
% 
% u = @(x) 0.5 * (x - x .^2);
% u_precise = u(h * i);
% 
% K = toeplitz([2 -1 zeros(1, n)]);
% 
% u_approx = h^2 * inv(K) * f;
% 
% norm(u_approx - u_precise)
% 
% figure(1)
% hold on
% grid
% plot(i, u_precise, 'k');
% plot(i, u_approx, 'r');
% legend('precise', 'approximate');
% hold off

T = toeplitz([2 -1 zeros(1, n - 1)]);
T(1, 1) = 1;
u = cos(pi * i * h / 2);
c = (pi/2)^2;
f = c * u;
U = h^2 * inv(T) \ f;
e = 1 - U(1)

% k1=pi;
% k2=-pi;
% N=300;
% Y=[];
% X=[0:0:N];
% R=[];
% for l=1:1:N
%     Y=[];
%     for k=1:1:N
%         y = sign(k/N-l/N)*(exp(i*(k1 * l/N + k2 * k/N ))-exp(i*(k2 * l/N + k1 * k/N )) );
%         Y =[Y,y];    
%     end
%     X=[X;Y];
% end
% 
% size(X,1);
% X;
% 
% Z=fft2(X);
% U=fftshift(Z);
% U(1,2);
% abs(U(1,2));
% abs(U(1,2)).^2;
% F=[0:0:N];
% for l=1:1:N
%     T=[];
%     for k=1:1:N
%         T=[T,abs(U(l,k))]  ;  
%     end
%     F=[F;T];
% end
% F=log(F+1);
% F = mat2gray(F);
% figure
% mesh(F)
% figure
% imshow(F,[])