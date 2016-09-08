classdef ImageStitcher
    %ImageStitcher �����ͼ��ƴ��Ϊȫ��ͼ��
    %   �����ͼ��ƴ��Ϊһ��ȫ��ͼ��
    
    properties
        cameras % struct�ṹ�����飬������¼����Ĳ���
        canvas_row_num; % ���������� 
        canvas_col_num; % ���������� 
    end
    
    methods
        canvas = stitch(obj, images, isline) % ����N��image�����ƴ�ӽ��
        canvas = stitch_test(obj, images, sequence)
        obj = estimate(obj, images) % ����N��image������ƴ�Ӳ���
        obj = bundle_adjust(obj,images,radius) % �������N��image����Ⱥ��΢��
    end
    
    methods(Static)
        % H = estimate_homography(image1, image2) % ʹ��SURF������������ͼ֮���͸�ӱ任����
        % H = estimate_homography2(image1, f1, image2, f2) % ʹ��SURF������������ͼ֮���͸�ӱ任����
        inliers = find_inliers(features_point1, features_point2) % Ѱ����������֮���inliers��
        H = DLT(match_points1, match_points2) % ʹ��DLT�㷨��������ƥ���֮���͸�ӱ任����
        % pos_c = cylindrical(pos_e,s) % ��ֱ������ϵ����ת��ΪԲ������ϵ����
        XYZ_euclid = inv_cylindrical(XYZ_cylind) % ��Բ������ϵ����ת��Ϊֱ������ϵ���� 
        % pos_s = spherical(pos_e,s) % ��ֱ������ϵ����ת��Ϊ��������ϵ����
        pos_e = inv_spherical(pos_s) % ����������ϵ����ת��Ϊֱ������ϵ���� 
        % [canvas,mask] = homography(r,R,image) % ��ͼ��ʹ��H����ͶӰ�任
        [inliers_count,inliers] = neighbour(images) % ����ͼ������֮���ƥ�����
    end
    
end

