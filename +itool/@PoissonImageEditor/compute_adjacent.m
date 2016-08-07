function neighbors = compute_adjacent(obj, mask)  
  
    [height, width]      = size(mask);  
    [row_mask, col_mask] = find(mask);
    
    neighbors = sparse(length(row_mask), length(row_mask), 0);
    
    %下标转索引
    roi_idxs = sub2ind([height, width], row_mask, col_mask);
  
    for k = 1:size(row_mask, 1),  
        %4 邻接点  
        connected_4 = [row_mask(k), col_mask(k)-1;%left
            row_mask(k), col_mask(k)+1;%right
            row_mask(k)-1, col_mask(k);%top
            row_mask(k)+1, col_mask(k)];%bottom
        
        ind_neighbors = sub2ind([height, width], connected_4(:, 1), connected_4(:, 2));
      
        %二分查找函数 i = ismembc2(t, X)：返回t在X中的位置，其中X必须为递增的的数值向量  
        for neighbor_idx = 1: 4, %number of neighbors,  
            adjacent_pixel_idx =  ismembc2(ind_neighbors(neighbor_idx), roi_idxs);  
            if (adjacent_pixel_idx ~= 0)  
                neighbors(k, adjacent_pixel_idx) = 1;  
            end  
        end   
    end  
end  