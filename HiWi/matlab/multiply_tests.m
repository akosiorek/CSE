function multiply_tests()
    clc, clear all
    
    sizeA1 = 3;
    sizeA2 = 3;
    sizeB2 = 4;
    
    A = createA(sizeA1, sizeA2)
    B = createB(sizeA2, sizeB2)
    C = createC(sizeA1, sizeB2)
    
    AtimesB = A * B
    
    
end


function M = reshapeToRowMajor(A, sizeA1, sizeA2)
    M = reshape(A, sizeA2, sizeA1)';
end

function A = createA(sizeA1, sizeA2)
   lengthA = sizeA1 * sizeA2;
   A = reshapeToRowMajor(0:sizeA1*sizeA2-1, sizeA1, sizeA2);
end

function B = createB(sizeB1, sizeB2)
    lengthB = sizeB1 * sizeB2;
    B = reshapeToRowMajor(lengthB - (0:lengthB-1), sizeB1, sizeB2);    
end

function C = createC(sizeC1, sizeC2)
    C = createA(sizeC1, sizeC2) + 1;
end