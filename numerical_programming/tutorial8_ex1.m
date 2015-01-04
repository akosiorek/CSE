function tutorial8_ex1
    clear all, close all, clc
    
    x=[1.02,0.95,0.87,0.77,0.67,0.56,0.44,0.30,0.16,0.01]';
    y=[0.39,0.32,0.27,0.22,0.18,0.15,0.13,0.12,0.13,0.15]';

    Y = x.^2;
    X = [y.^2 x.*y x y ones(numel(x), 1)];
    
    figure(1)
    hold on
    grid on
    title('orbit samples')
    plot(x, y, 'r*')    
    
    % normals eqs
    bNEQ = X'*X \(X'*Y);
    
    % QR
    [Q R] = qr(X);
    bQR = R \ (Q'*Y);
    
    % cmopre QR with normal Eqs
    disp({'QR vs normal Eqs', norm(bQR - bNEQ)});

    approximation = @(x, y, b) b(1)*y.^2 + b(2)*x.*y + b(3)*x + b(4)*y + b(5) - x.^2;
    ezplot(@(x, y) approximation(x, y, bQR));
%     ezplot(@(x, y) approximation(x, y, bNEQ));


    % perturb the input
    magnitude = 1e-2;
    a = -magnitude/2;
    b = -a;
    
    x = x + rand(size(x)) * magnitude + a;
    y = y + rand(size(y)) * magnitude + a;
    
    Y = x.^2;
    X = [y.^2 x.*y x y ones(numel(x), 1)];
    
    b = X'*X \(X'*Y);
    
    figure(2)
    hold on
    grid on
    plot(x, y, 'r*')   
    ezplot(@(x, y) approximation(x, y, b));
    title('perturbed samples')
    
    disp({'original vs perturbed norm(b)=', norm(b - bNEQ)});
    
    disp({'b-bNEQ', 'b', 'bNEQ'});
    disp([b-bNEQ b bNEQ]);


    
end