classdef PoissonImageEditor
    %POISSONIMAGEEDITOR �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
    end
    
    methods
        result_image = poisson_solver(obj, image, mask, adjacent)
        neighbors = compute_adjacent(obj, mask)  
    end
    
end

