colormap(copper);

% an extraordinarily realistic image
a = -ones(50,50);
a(11:40,11:40) = ones(30,30);
imagesc(a);
axis image;
fprintf('original image\n');
pause

% corrupt with white noise
[n, m] = size(a);
sigma = 1;
b = a + randn(n, m)*sigma;
imagesc(b)
axis image;
fprintf('corrupted image\n');
pause
imagesc(b>0)
axis image;
fprintf('naive pixel classification\n');
pause
  
% constants for mean field iteration: shift operators and
% the parameters field strength, temperature, and learning rate 
% (it is very insensitive to parameters)
shu = spdiags(ones(m,1),1,m,m);
shd = spdiags(ones(m,1),-1,m,m);
shl = spdiags(ones(n,1),1,n,n);
shr = spdiags(ones(n,1),-1,n,n);
field = 10;
temp = 5;
rate = .5;

% mean field iteration
c = zeros(n,m);
imagesc(c)
axis image;
fprintf('iteration 0\n');
pause
for i = 1:35
  c = (1-rate)* c + rate * tanh((b + field * (shl*c + shr*c + c*shu + c*shd)) / temp);
  imagesc(c)
  axis image;
  fprintf('iteration %d\n', i);
  pause
end

imagesc(c > 0);
axis image;
fprintf('final pixel classification\n');
