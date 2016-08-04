function [exampler,x,y] = find_best_exampler(obj,patch,patch_mask,image)
%FIND_BEST_EXAMPLER 找到最优的匹配块
%   
    mindist = inf;
    for row = 1:obj.row_num
        for col = 1:obj.col_num
            current_exampler_mask = obj.get_patch(obj.current_mask,row,col);
            if ~isempty(find(current_exampler_mask,1))
                continue; 
            else
                current_exampler = obj.get_patch(image,row,col);
                distance = obj.match_distance(patch,current_exampler,patch_mask);
                if distance < mindist
                    exampler = current_exampler;
                    mindist = distance;
                    x = row;
                    y = col;
                end
            end
        end
    end
end

