%This code compares Steepest Descent (SD) with Conjugate Gradient (CG).
%Read carefully the code and answer the questions (indicated with the
%letter Q) below.
%--------------------------------------------------------------%

clear all;close all;
nmax = 100; %number of iterations

n=100; %size of the matrix
A=diag(1:n,0) +1* diag(ones(n-1,1),-1)+ 1*diag(ones(n-1,1),1);
b=ones(n ,1);
xx=A\b; %xx is the reference solution

%-Steepest Descent
k=1;err=zeros(1,nmax);res=zeros(1,nmax);
x=zeros(n,1);
for k=1:nmax
    r=b-A*x(:,k);
    alpha=(r'*r)/(r'*A*r); %Q: Why is alpha chosen in this way?
    x(:,k+1) = x(:,k) + alpha.*r;
    err(k+1) = norm(x(:,k+1)-xx);
    res(k+1) = norm(r);
end

%-Conjugate Gradient
k=1;
y=zeros(n,1);
errCG=zeros(1,nmax); resCG=zeros(1,nmax);
r=b-A*y(:,k); s=r; nr=r'*r ;

for k=1:nmax
    t=A*s; alpha=nr/( s'*t ) ;
    y(:,k+1)=y(:,k)+alpha*s;
    %Q: Can you show that the updated residual r is orthogonal to the one 
    %computed at the previous step?
    r=r-alpha*t ; 
    errCG(k+1) = norm(y(:,k+1)-xx);
    resCG(k+1) = norm(r);
    nrnew=r'*r ;
    s=r +(nrnew/nr)*s ; nr=nrnew;
end

figure
plot(err(2:end),'b*')
hold on;
plot(errCG(2:end),'r*')
xlabel('Iteration')
title('Error with respect to the reference solution')

%Q: What is the precise meaning of the statement: "The CG method minimizes the
%functional (e'Ae)/2 in the Krylov subspace"

%Q: Is it true that in absence of rounding errors the CG method 
%terminates after a finite number of steps? 


