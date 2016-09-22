function output_yuv = stitch(obj, input_yuv_list, count)
% stitch :         �Զ�·YUV��Ƶ����ƴ��
% input_yuv_list : �����N��YUV�ļ�����
% output_yuv ��    �����YUV�ļ�����
    output_yuv = itool.YUV();
    output_yuv.filename = 'result.yuv';
    output_yuv.row_num = 1080;
    output_yuv.col_num = 1920;
    output_yuv.frame_num = 2500;
    output_yuv.format = 'yuv444p';
    output_yuv = output_yuv.open('w');

    number_of_video = length(input_yuv_list); % ����N·��Ƶ

    for n = 1:number_of_video
        input_yuv_list{n} = input_yuv_list{n}.open('r');
    end
    
    options.is_blending = true;
    options.is_show_skeleton = false;
    options.is_gain_compensation = true;
    
    for f = 1:count
        for n = 1:number_of_video
            images(n).image = input_yuv_list{n}.read_frame();
        end
        frame = obj.image_stitcher.stitch(images,options);
        fwrite(output_yuv.fid,frame(:,:,1)');
        fwrite(output_yuv.fid,frame(:,:,2)');
        fwrite(output_yuv.fid,frame(:,:,3)');
    end
    
    for n = 1:number_of_video
        input_yuv_list{n}.close();
    end
    output_yuv.close();
end