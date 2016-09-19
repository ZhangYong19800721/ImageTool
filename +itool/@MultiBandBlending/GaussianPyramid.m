function G = GaussianPyramid(input, level)
    G{1} = input;
    for i=2:level
        G{i} = itool.MultiBandBlending.reduce(G{i-1});
    end
end