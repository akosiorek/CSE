%This function compute discrete Fourier Transform using brute force
%approach. The function is therefore very slow.
%f is a given vector whose entries are the values of a function sampled
%uniformely on the points xj=j/N with j=0,1,....,N-1.
%kind=-1 -->F transf, kind=1 -->inverse F transf


function ft=FT_bf(kind,f)
N=length(f);
ft=zeros(1,N);
for k=1:N
    ft(k)=0;
    for j=1:N
        ft(k)=ft(k)+f(j)*exp(2*pi*1i*kind*(k-1)*(j-1)/N);
    end
end

% %-Using Matrix Representation
% w=@(j) exp(1i*2*pi*j/N);
% j=(0:N-1);
% v=w(j);
% F = fliplr(vander(v));
% ft=F*f';

if kind==-1; ft=ft/N; end; %if using inverse

end