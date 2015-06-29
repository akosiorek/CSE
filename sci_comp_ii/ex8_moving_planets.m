function ex8_moving_planets()
    
    dt = 0.015;
    N = 32000;
    
    [m x v] = init();
    
    X = zeros([N size(x)]);
    X(1, :, :) = x;
    for i = 2:N
        
        [x v] = velocityStoermerVerlet(x, v, m, dt);
        X(i, :, :) = x;
    end
    
    color = 'rgbm';
    figure(1)
    hold on
    grid on
    for i = 1:numel(color)
        plot(X(:, i, 1), X(:, i, 2), color(i));
    end
    legend('Sun', 'Earth', 'Jupiter', 'Halleys Comment');
    xlabel('X');
    ylabel('Y');
    title('Solar System Simulation')        
end

function [m x v] = init()
    
    m = [1; 3e-6; 9.55e-4; 1e-14];
    x = [0 0; 0 1; 0 5.36; 34.75 0];
    v = [0 0; -1 0; -0.425 0; 0 0.0296];
end


function F = computeForces(position, mass)
   
    F = zeros(size(position));
    
    n = numel(mass);
    
    for i = 1:n
        for j = i+1:n
            dist = position(j, :) - position(i, :);
            f = mass(i) * mass(j) * dist / norm(dist)^2;
            F(i, :) = F(i, :) + f;
            F(j, :) = F(j, :) - f;
        end
    end   
end

function [x v] = velocityStoermerVerlet(x, v, m, dt)
    
   
    x = x + 0.5 * dt * v;
    
    F = computeForces(x, m);
    a = F ./ repmat(m, 1, 2);
    v = v + dt * a;
    
    x = x + 0.5 * dt * v;
    
end


function [x v] = velocityExplicitEuler(x, v, m, dt)
   
    F = computeForces(x, m);
    x = x + dt * v;
    
    a = F ./ repmat(m, 1, 2);
    v = v + dt * a;
    
end