classdef ImageStitcher
    %ImageStitcher �����ͼ��ƴ��Ϊȫ��ͼ��
    %   �����ͼ��ƴ��Ϊһ��ȫ��ͼ��
    
    properties
        cameras % struct�ṹ�����飬������¼����Ĳ���
        canvas_row_num; % ���������� 
        canvas_col_num; % ���������� 
    end
    
    methods
        % canvas = stitch_test(obj, images, sequence)
        canvas = stitch(obj, images, isline) % ����N��image�����ƴ�ӽ��
        obj = estimate(obj, images, row_num, col_num) % ����N��image������ƴ�Ӳ���
        obj = bundle_adjust(obj,images,radius) % �������N��image����Ⱥ��΢��
        obj = gain_compensation(obj,images) % �������油���㷨
        obj = wave_correct(obj) % ���������㷨
    end
    
    methods(Static)
        % H = estimate_homography(image1, image2) % ʹ��SURF������������ͼ֮���͸�ӱ任����
        % H = estimate_homography2(image1, f1, image2, f2) % ʹ��SURF������������ͼ֮���͸�ӱ任����
        % pos_c = cylindrical(pos_e,s) % ��ֱ������ϵ����ת��ΪԲ������ϵ����
        % pos_s = spherical(pos_e,s) % ��ֱ������ϵ����ת��Ϊ��������ϵ����
        % [canvas,mask] = homography(r,R,image) % ��ͼ��ʹ��H����ͶӰ�任
        
        [match_index_pairs,inlier_index_pairs] = find_match(features_point1, features_point2) % Ѱ����������֮���ƥ���
        H = DLT(match_points1, match_points2) % ʹ��DLT�㷨��������ƥ���֮���͸�ӱ任����
        XYZ_euclid = inv_cylindrical(XYZ_cylind) % ��Բ������ϵ����ת��Ϊֱ������ϵ���� 
        pos_e = inv_spherical(pos_s) % ����������ϵ����ת��Ϊֱ������ϵ����
        [match_count,match_index_pair,inlier_count,inlier_index_pair] = neighbour(images) % ����ͼ������֮���ƥ�����
        exit = unit_test1();
    end
    
end

