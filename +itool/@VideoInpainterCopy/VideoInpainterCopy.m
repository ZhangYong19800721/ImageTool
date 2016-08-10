classdef VideoInpainterCopy
    %VIDEOINPAINTER �����޸���Ƶ����
    %   ������÷���ȥ����Ƶ�е�̨��
    
    properties
        mask3d; % �ɰ�,��һ����ֵͼ����Ҫ�޲���������Ϊ1������������Ϊ0��
        movie;  % ��Ҫ���޸�������
        movie_DIV_Y; % Y������ɢ��
        movie_DIV_U; % U������ɢ��
        movie_DIV_V; % V������ɢ��
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
        function obj = VideoInpainterCopy(dx,dy,dt) % VideoInpainter���캯��
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
        D = update_dataterm(obj,dataterm,ran_t) %����������
        D = compute_dataterm(obj) %����������
        P = compute_priority(obj,confidence,dataterm,front_idx); %�������б߽������ȼ�
        [cube,valid,r_x,r_y,r_t] = get_cube(obj,matrix,x,y,z) % ��3ά����4ά��������ȡһ�������������
        [YGx,YGy,UGx,UGy,VGx,VGy,sub_x,sub_y,sub_t] = find_best_exampler(obj,c_Y_Gx,c_Y_Gy,c_U_Gx,c_U_Gy,c_V_Gx,c_V_Gy,c_mask3d,t); 
        C = update_confidence(obj,confidence,ran_x,ran_y,ran_t)
    end
end

