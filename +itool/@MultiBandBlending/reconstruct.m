function output = reconstruct(input)
    level = length(input);
    output = input{level};
    for i = level-1:-1:1
        A = input{i}; B = itool.MultiBandBlending.expand(output); [row,col] = size(A);
        output = A + B(1:row,1:col);
    end
end