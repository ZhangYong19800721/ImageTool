classdef VideoInpainter
    %VIDEOINPAINTER �����޸���Ƶ����
    %   ������÷���ȥ����Ƶ�е�̨��
    
    properties
        mask; % �ɰ�,��һ����ֵͼ����Ҫ�޲���������Ϊ1������������Ϊ0��
        row_area; % ����Ȥ������з�Χ
        col_area; % ����Ȥ������з�Χ
        movie_area; % ����Ȥ�������Ƶ
        mask_area; % ����Ȥ������ɰ�
        row_num_area; % ����Ȥ���������
        col_num_area; % ����Ȥ���������
        % movie_gx; % x�����ϵ��ݶ�ͼ
        % movie_gy; % y�����ϵ��ݶ�ͼ
        movie_inpaint; % �����޲�����Ƶ
        gapx;
        gapy;
        gapf;
        frame_num; % ��֡��
        row_num; % ��Ƶ֡������
        col_num; % ��Ƶ֡������
        boundary_x; % �߽���x��������
        boundary_y; % �߽���y��������
        boundary_f; % �߽���f��������
    end
    
    methods
        function obj = VideoInpainter(mask)
            % VideoInpainter: ���캯��
            % mask�����ڱ궨�޲�������ɰ�
            obj.mask = mask;
            obj.gapx = 4;
            obj.gapy = 4;
            obj.gapf = 2;
        end
    end
    
    methods
        obj = inpaint(obj,movie_data) % ����Ƶ�����޸�
        obj = crop(obj,movie_data,row_factor,col_factor) % ����Ƶ���вü� 
        [x,y,f] = find_bound(obj) % Ѱ�Ҵ��������ı߽�
        confidence = update_confidence(obj,conf)
        cubic = get_patch(obj,matrix,x,y,z)
        d_term = update_dataterm(obj,ix,iy,ngx,ngy,data)
    end
end

