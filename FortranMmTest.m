function FortranMmTest()
     clear all; clc;
     
     sizeA1 = 3;
     sizeA2 = 5;
     sizeB2 = 4;
     
     A = zeros(sizeA1, sizeA2);
     B = zeros(sizeA2, sizeB2);
     C = zeros(sizeA1, sizeB2);
     
     for i=1:sizeA1
         for j=1:sizeA2
             index = (i-1) * sizeA2 + j;
             A(i, j) = index - 1;
         end
     end
     
    for i=1:sizeA2
        for j=1:sizeB2
         index = (i-1) * sizeB2 + j;
         B(i, j) = numel(B) - index + 1;
        end
    end
     
    for i=1:sizeA1
         for j=1:sizeB2
             index = (i-1) * sizeB2 + j;
             C(i, j) = index;
         end
     end
    
%      for i = 1:numel(A), A(i) = i-1; end
%      for i = 1:numel(B), B(i) = numel(B)-(i-1); end
%      for i = 1:numel(C), C(i) = i; end
     
     
     A
     B
     C
     A*B
     C + A*B
     
end