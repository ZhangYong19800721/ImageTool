function exit = unit_test()
%UNIT_TEST 单元测试函数
%   此处显示详细说明
    close all;
    rng('default');
    
    input_yuv_list{1} = itool.YUV();
    input_yuv_list{1}.filename = 'E:\WorkSpace\itool\+itool\@VideoStitcher\unit_test\Clip_M_2500F.yuv';
    input_yuv_list{1}.row_num = 1080;
    input_yuv_list{1}.col_num = 1920;
    input_yuv_list{1}.frame_num = 2500;
    input_yuv_list{1}.format = 'yuv420p';
    
    input_yuv_list{2} = itool.YUV();
    input_yuv_list{2}.filename = 'E:\WorkSpace\itool\+itool\@VideoStitcher\unit_test\Clip_L_2500F.yuv';
    input_yuv_list{2}.row_num = 1080;
    input_yuv_list{2}.col_num = 1920;
    input_yuv_list{2}.frame_num = 2500;
    input_yuv_list{2}.format = 'yuv420p';
    
    input_yuv_list{3} = itool.YUV();
    input_yuv_list{3}.filename = 'E:\WorkSpace\itool\+itool\@VideoStitcher\unit_test\Clip_R_2500F.yuv';
    input_yuv_list{3}.row_num = 1080;
    input_yuv_list{3}.col_num = 1920;
    input_yuv_list{3}.frame_num = 2500;
    input_yuv_list{3}.format = 'yuv420p';
    
    video_stitcher = itool.VideoStitcher();
    video_stitcher = video_stitcher.estimate(input_yuv_list, 1080, 1920, 135, 'cylindrical');
    outout_yuv = video_stitcher.stitch(input_yuv_list,2500);
    
    outout_yuv.play(100);

    exit = true;
end

