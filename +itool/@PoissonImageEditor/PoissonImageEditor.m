classdef PoissonImageEditor
    %POISSONIMAGEEDITOR 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
    end
    
    methods
        result_image = poisson_solver(obj, image, mask, adjacent)
        neighbors = compute_adjacent(obj, mask)  
    end
    
end

