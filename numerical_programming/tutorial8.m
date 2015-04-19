function tutorial8
   
    %% ex1
    disp('Power iteration:')
    
    A = [2 -1; -1 2];
    k = 3;
    u = zeros(2, k + 1);
    u(:, 1) = [1 0]';
    [V, L] = eig(A);
    disp('norm(eig - approx):');
    for i = 2:k+1
        u(:, i) = A * u(:, i - 1);
        u(:, i) = u(:, i) / norm(u(:, i));
        disp({i-1, '=', norm(-V(:, 2) - u(:, i))});
    end
    
    %% ex2
    disp('Rayleigh iteration')
    
    function r = rayleigh(A, x)
        r = x' * A * x / norm(x);
    end
    
    A = [2 -1; -1 2];
    k = 6;
    u = zeros(2, k + 1);
    u(:, 1) = [0.4 0]';
    [V, L] = eig(A);
    disp('norm(eig - approx):');
   
    for i = 2:k+1
        
        r = rayleigh(A, u(:, i-1))
        u(:, i) = (A - r * eye(size(A))) \ u(:, i-1);
        u(:, i) = u(:, i) / norm(u(:, i));
        if u(1, i) > 0
            u(:, i) = -u(:, i);
        end
        disp({i-1, '=', norm(V(:, 1) - u(:, i))});
    end
    
    % ex3
    disp('QR iterator')
    fi = 0;
    A = [cos(fi) sin(fi); sin(fi) 0];
    k = 3;
    for i = 1:k
       [Q, R] = qr(A);
       A = R * Q;
    end
    
    
    
    
    
    
end

