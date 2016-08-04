function obj = crop(obj,movie_data,row_factor,col_factor)
%CROP �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    [obj.row_num, obj.col_num, ~, obj.frame_num] = size(movie_data); %��ȡ֡�Ĵ�С����֡��
    obj.row_area = 1:(row_factor * obj.row_num);
    obj.col_area = (obj.col_num - col_factor * obj.col_num + 1):obj.col_num;
    obj.row_num_area = length(obj.row_area);
    obj.col_num_area = length(obj.col_area);
    obj.movie_area = movie_data(obj.row_area,obj.col_area,:,:);
    obj.mask_area = obj.mask(obj.row_area,obj.col_area);
    obj.mask_area = reshape(repmat(obj.mask_area,1,obj.frame_num),[size(obj.mask_area) obj.frame_num]);
end

