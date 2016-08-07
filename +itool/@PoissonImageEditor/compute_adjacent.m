function neighbors = compute_adjacent(obj, mask)  
  
    [height, width]      = size(mask);  
    [row_mask, col_mask] = find(mask);
    
    neighbors = sparse(length(row_mask), length(row_mask), 0);
    
    %�±�ת����
    roi_idxs = sub2ind([height, width], row_mask, col_mask);
  
    for k = 1:size(row_mask, 1),  
        %4 �ڽӵ�  
        connected_4 = [row_mask(k), col_mask(k)-1;%left
            row_mask(k), col_mask(k)+1;%right
            row_mask(k)-1, col_mask(k);%top
            row_mask(k)+1, col_mask(k)];%bottom
        
        ind_neighbors = sub2ind([height, width], connected_4(:, 1), connected_4(:, 2));
      
        %���ֲ��Һ��� i = ismembc2(t, X)������t��X�е�λ�ã�����X����Ϊ�����ĵ���ֵ����  
        for neighbor_idx = 1: 4, %number of neighbors,  
            adjacent_pixel_idx =  ismembc2(ind_neighbors(neighbor_idx), roi_idxs);  
            if (adjacent_pixel_idx ~= 0)  
                neighbors(k, adjacent_pixel_idx) = 1;  
            end  
        end   
    end  
end  