function linear_systems
    clc; clear all; close all;

    %% Conditioning
    disp('Conditioning')
    % Condition of a matrix

    A = [0.2161 0.1441;
        1.2969 0.8648];

    detA = det(A)

    b = [0.144;
        0.8642];

    x = A\b

    bp = b + 1e-8 * rand(2, 1);
    xp = A\bp

    k = norm(xp - x) / norm(x) / norm(bp - b) * norm(b)
    kappa = cond(A)

    % Preconditionaing

    B = diag(diag(A));
    kappaPrecond = cond(B\A)
    kappaRatio = kappa / kappaPrecond

    %% Gaussian Elimination
    disp('Gaussian Elimination')

    % forward substitution
    n = 100;
    L = tril(rand(n)) + eye(n);
    figure(1)
    spy(L);
    b = rand(n, 1);

    xx = L\b; % matlab solution
    x = forward_substitute(L, b);
    forward_error = norm(x - xx)

    % backward substitution
    U = triu(rand(n)) + eye(n);
    figure(2)
    spy(U)
    b = rand(n, 1);
    xx = U\b; % matlab solution
    x = backward_substitute(U, b);
    backward_error = norm(x - xx)
    
    % LU without pivoting
    A = rand(n);
    b = rand(n, 1);
    xx = A\b;
    [L, U] = LU_decomposition(A);
    y = forward_substitute(L, b);
    xLU = backward_substitute(U, y);
    LU_error = norm(xLU - xx)
    
    % LU with pivoting
    [L, U, P] = LUP_decomposition(A);
    y = forward_substitute(L, b);
    xLUP = backward_substitute(U, y);
%     xLU = recover_solution(xLUP, P);
%     disp([xLUP xLU])
%     LUP_error = norm(xLU - xx)
    
    %% QR decomposition
    disp('QR decomposition')
    
    % Gaussian elimination
    n = 100;
    L = -tril(ones(n), -1) + eye(n);
    U = triu(rand(n));
    condL = cond(L)
    condU = cond(U)
    upper_bound = n * 2 ^ (n - 1)
   
    A = L * U;
    [L, U] = lu(A);
    condL = cond(L)
    condU = cond(U)
    
    y = L\b;
    xLU = U\y;
    
    [Q, R] = qr(A);
    y = Q' * b;
    xQR = R\y;
    
    QRerror = norm(xQR - xLU)    
    
    %% Least Squares
    disp('Least Squares')
    
    d = 1e-7;
    A = [1 1;
        d 0;
        0, d];
    b = [2; d; d];
    x = [1; 1];
    
    x1 = A\b;
    normX = norm(x1 - x) / norm(x)
    
    [Q, R] = qr(A);
    b2 = Q' * b;
    x2 = R(1:2, :) \ b2(1:2);
    normQR = norm(x2 - x) / norm(x)
    
    x3 = (A' * A) \ (A' * b);
    normNormalEq = norm(x3 - x) / norm(x)
    condNormalEq = cond(A' * A)
    condA = cond(A)
    
    figure(3)
    plot(A(:, 1)', A(:, 2)', 'r*');
    title('least squares plot');    
    
    % Try my QR implementation
    [Q2, R2] = QR_decomposition(A);
    normMyQ = norm(Q - Q2)
    normMyR = norm(R - R2)

end

function x = forward_substitute(L, b)
    n = numel(b);
    x = zeros(n, 1);
     for i = 1:n     % same as above
        x(i) = b(i) / L(i, i);
        b(i + 1:n) = b(i + 1:n) - x(i) * L(i + 1:n, i);
    end
end

function x = backward_substitute(U, b)
    n = numel(b);
    x = zeros(n, 1);
      for i = n:-1:1 % my solution
        x(i) = b(i) / U(i, i);
        b(1:i-1) = b(1:i-1) - x(i) * U(1:i-1, i);
    end
end

function[L, U] = LU_decomposition(A)
   % LU without pivoting
    n = size(A, 1);
    L = eye(n);
    U = zeros(n);
    
    for i = 1:n
        U(i, i) = A(i, i);
        U(i, i+1:end) = A(i, i+1:end);
        L(i+1:end, i) = A(i+1:end, i) / U(i, i);
        A(i+1:end, i+1:end) = A(i+1:end, i+1:end) - L(i+1:end, i) * U(i, i+1:end);
    end
end

function V = swap(v, i, j) 
    tmp = v(i);
    v(i) = v(j);
    v(j) = tmp;
    V = v;
end

function p = pivot(v)
   p = find(v == max(v)); 
end

function [L, U, rows] = LUP_decomposition(A)
    % LU with pivoting
    n = size(A, 1);
    L = eye(n);
    U = zeros(n);
    P = zeros(n);
    rows = 1:n;
    
    for i = 1:n
        
        p = pivot(A(i:end, i)) - 1;
        rows = swap(rows, i, i + p);
        A(i:end, :) = A(rows(i:end), :);
        
        
        U(i, i) = A(i, i);
        U(i, i+1:end) = A(i, i+1:end);
        L(i+1:end, i) = A(i+1:end, i) / U(i, i);
        A(i+1:end, i+1:end) = A(i+1:end, i+1:end) - L(i+1:end, i) * U(i, i+1:end);
    end
end


function [Q, R] = QR_decomposition(A)
   
    Qt = eye(size(A, 1));
    
    k = size(A, 2);
    for i = 1:k
        
       % reflect ai onto an axis of the coordinate system, then it equals ai = [norm(ai) 0 ...]
       d = norm(A(i:end, i));
       
       % we could choose either sign, but we don't want 1 - aii to be 0 so we choose the opposite sign;
       % then 1 - aii = 1 - (-d) = 1 + d and d >= 0 so 1 + d >= 0
       if A(i, i) > 0
           d = -d;
       end
       % w = a11 - norm(a1) is the difference between vector x and its reflection
       w = A(i, i) - d;
       f = sqrt(-2 * w * d); % magnitude of the difference
       %  v defines the reflection place; v1 should == 1 so we normalize it by f
       v = [w; A(i+1:end, i)] / f;
       
       % reflect ai
       A(i, i) = d;
       A(i+1:end, i) = 0;
       
       %reflect aj s.t. j > i
       % here reflection is just addition; we don't have to multiply matrices
       for j = i+1:k
           f = 2 * v' * A(i:end, j);
           A(i:end, j) = A(i:end, j) - f * v;
       end
       
       % compute H and Q'
       Hi = eye(size(A, 1));
       Hi(i:end, i:end) = Hi(i:end, i:end) - 2 * v * v';
       Qt = Hi * Qt;
    end
    R = A;
    Q = Qt';
end

