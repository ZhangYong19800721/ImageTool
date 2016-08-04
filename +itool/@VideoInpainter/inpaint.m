function obj = inpaint(obj,movie_data)
%INPAINT ����Ƶ�����޸�
%   movie_data: ��������֡�ĵ�Ӱ֡����
%   mov: �����޸���ĵ�Ӱ֡����
    
    obj = obj.crop(movie_data,0.22,0.3);
    obj.movie_inpaint = zeros(obj.row_num,obj.col_num,3,obj.frame_num,'uint8'); % ���޸������Ƶ֡��ʼ��Ϊȫ0.

    c_term = zeros(size(obj.mask_area)); % ��ʾ���Ŷ�
    d_term = zeros(size(obj.mask_area)); % ��ʾ������
    
    [obj.boundary_x,obj.boundary_y,obj.boundary_f] = obj.find_bound(); % �ҵ����������ı߽磬bx��ʾ�߽��x���꣬by��ʾ�߽��y���꣬bf��ʾ֡��
    c_term(obj.mask_area==0) = 1;  % ��ʼ�����Ŷ�,mask���Ϊ0���������Ŷȳ�ʼ��Ϊ1��mask���Ϊ1���������Ŷȳ�ʼ��Ϊ0.

    while ~isempty(obj.boundary_x) % ���߽粻Ϊ��ʱ��������䣬�߽�Ϊ��ʱֹͣ
        c_term = obj.update_confidence(c_term);
        d_term = obj.update_dataterm(d_term);
        p_term = 0 * p_term;
        max_priority = -inf;
        for n = 1:length(obj.boundary_x)
            nx = obj.boundary_x(n); ny = obj.boundary_y(n); nf = obj.boundary_f(n);
            current_priority = c_term(nx,ny,nf) * d_term(nx,ny,nf);
            if current_priority > max_priority
                max_priority = current_priority;
                max_posx = nx;
                max_posy = ny;
                max_posf = nf;
            end
        end
        
        cubic = obj.get_patch(,max_posx,max_posy,max_posf);

        [obj.boundary_x,obj.boundary_y,obj.boundary_f] = obj.find_bound(); % ���±߽�
    end
end

