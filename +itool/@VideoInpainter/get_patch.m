function cubic = get_patch(obj,matrix,x,y,z)
%GET_PATCH 取立方体数据块
%   
    [max_x,max_y,max_z] = size(matrix);
    xr=max(x-obj.gapx,1):min(x+obj.gapx,max_x);
    yr=max(y-obj.gapy,1):min(y+obj.gapy,max_y);
    fr=max(z-obj.gapf,1):min(z+obj.gapf,max_z);
    cubic = matrix(xr,yr,fr);
end

