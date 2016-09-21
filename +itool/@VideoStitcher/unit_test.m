function exit = unit_test()
%UNIT_TEST 单元测试函数
%   此处显示详细说明
    yuv = itool.YUV();
    yuv.filename = 'E:\WorkSpace\itool\+itool\@VideoStitcher\unit_test\Clip_M_10KF.yuv';
    yuv.row_num = 1080;
    yuv.col_num = 1920;
    yuv.frame_num = 10000;
    yuv.format = 'yuv420p';
    
    clip_yuv = yuv.clip(7501,10000,'Clip_M_2500F.yuv');
    
    clip_yuv.play(100);
    
    yuv = itool.YUV();
    yuv.filename = 'E:\WorkSpace\itool\+itool\@VideoStitcher\unit_test\Clip_R_10KF.yuv';
    yuv.row_num = 1080;
    yuv.col_num = 1920;
    yuv.frame_num = 10000;
    yuv.format = 'yuv420p';
    
    clip_yuv = yuv.clip(7501,10000,'Clip_R_2500F.yuv');
    
    clip_yuv.play(100);
    exit = true;
end

