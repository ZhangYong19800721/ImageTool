classdef VideoInpainter
    %VIDEOINPAINTER �����޸���Ƶ����
    %   ������÷���ȥ����Ƶ�е�̨��
    
    properties
        mask; % �ɰ�,��һ����ֵͼ����Ҫ�޲���������Ϊ1������������Ϊ0��
        movie; % ���޲�����Ƶ����
        movie_gradient_x; % ÿһ֡��x�����ϵ��ݶ�ͼ��ɵ���Ƶ
        movie_gradient_y; % ÿһ֡��y�����ϵ��ݶ�ͼ��ɵ���Ƶ
        
        delta_x; % �޲���Ԫ�ĸ߶�Ϊ2*delta_x+1
        delta_y; % �޲���Ԫ�ĸ߶�Ϊ2*delta_y+1
        delta_t; % �޲���Ԫ�ĸ߶�Ϊ2*delta_t+1
        frame_num; % ��֡��
        row_num; % ��Ƶ֡������
        col_num; % ��Ƶ֡������
        channel_num; % ɫ��ͨ����
        front_idx; % �߽���������
        front_x; % �߽���x��������
        front_y; % �߽���y��������
        front_t; % �߽���t��������
    end
    
    methods
        function obj = VideoInpainter(dx,dy,dt) % VideoInpainter���캯��
            obj.delta_x = dx;
            obj.delta_y = dy;
            obj.delta_t = dt;
        end
    end
    
    methods
        mov = inpaint(obj,movie,mask) % ����Ƶ�����޸�
        obj = initialize(obj,movie,mask) % ��ʼ���׶�
        [idx,x,y,t] = find_front(obj) % Ѱ�Ҵ��������ı߽�
        C = compute_confidence(obj,confidence) %�������߽��ϵ����Ŷ�
        
        confidence = update_confidence(obj,conf)
        cubic = get_patch(obj,matrix,x,y,z)
        d_term = update_dataterm(obj,ix,iy,ngx,ngy,data)
    end
end

