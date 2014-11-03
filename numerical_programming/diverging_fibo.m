function diverging_fibo(n, alfa)
    clc
    num = fibo(n, alfa);
    reversed = reverse_fibo(num, alfa);
    close
    figure(1);
    hold on
    grid on
    plot(1:length(num), num, 'b-*');
    plot(1:length(reversed), reversed, 'r-*');
    hold off
    
    norm(num - fliplr(reversed))
   
    
end


function num = fibo(n, alfa)
    num = zeros(1, n + 1);
    if(n >= 0)
        num(1) = 1;
    end
    if(n >= 1)
        num(2) = 1;
    end
    
    if(n > 1)
        for i = 3:n+1
            num(i) = num(i - 2) + alfa * num(i - 1);
        end
    end
end

function reversed = reverse_fibo(n, alfa)
     len = length(n);
     reversed = zeros(1, len);
     reversed(1) = n(len);
     reversed(2) = n(len - 1);
     for i = 3:len
         reversed(i) = reversed(i - 2) - alfa * reversed(i - 1);
     end
end
