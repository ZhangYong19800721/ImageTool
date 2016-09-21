function obj = estimate(obj, input_yuv_list, row_num, col_num, alfa, warper)
%ESTIMATE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    number_of_videos = length(input_yuv_list);
    for n = 1:number_of_videos
        input_yuv_list{n} = input_yuv_list{n}.open('r');
        images(n).image = input_yuv_list{n}.read_frame();
        input_yuv_list{n}.close();
    end
    obj.image_stitcher = itool.ImageStitcher().estimate(images, row_num, col_num, alfa, warper);
    
    options.is_blending = true;
    options.is_show_skeleton = false;
    options.is_gain_compensation = true;
    stitch_image = obj.image_stitcher.stitch(images,options);
    imshow(ycbcr2rgb(stitch_image));
end

