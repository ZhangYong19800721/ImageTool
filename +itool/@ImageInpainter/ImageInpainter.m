classdef ImageInpainter         
    %IMAGEINPAINTER �޲�ͼ�����
    %   ʵ����2004��A.Criminisi���㷨������ԭ��Ϊ��Region Filling and Object Removal by Exemplar-Based Image Inpaiting��
    
    properties
        row_num; % ͼ�������
        col_num; % ͼ�������
        boundx; % ���������ı߽�
        boundy; % ���������ı߽�
        deltax; % ���x��С
        deltay; % ���y��С
        current_mask; % ��ǰ�ɰ�
    end
    
    methods
        function obj = ImageInpainter()
            obj.deltax = 5;
            obj.deltay = 5;
        end
    end
    
    methods
        image = inpaint(obj,origin_image,mask)
        C = update_confidence(obj,confidence,range_x,range_y);
        D = update_dataterm(obj,image,mask)
        [patch, range_x, range_y] = get_patch(obj,mat,x,y)
        [exampler,x,y] = find_best_exampler(obj,patch,patch_mask,image)
        distance = match_distance(obj,patch,exampler,patch_mask)
        C = compute_confidence(obj,confidence)
        P = compute_priority(obj,confidence,dataterm,boundary)
    end
end

