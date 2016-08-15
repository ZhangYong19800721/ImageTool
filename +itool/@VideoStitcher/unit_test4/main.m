clear all;
close all;

mystitcher = itool.VideoStitcher();

yuvs(1) = itool.YUV();
yuvs(1).filename = 'Clip_L_10KF.yuv';
yuvs(1).row_num = 1080;
yuvs(1).col_num = 1920;
yuvs(1).frame_num = 7000;
yuvs(1).format = 'yuv420p';

yuvs(2).filename = 'Clip_M_10KF.yuv';
yuvs(2).row_num = 1080;
yuvs(2).col_num = 1920;
yuvs(2).frame_num = 7000;
yuvs(2).format = 'yuv420p';

yuvs(3).filename = 'Clip_R_10KF.yuv';
yuvs(3).row_num = 1080;
yuvs(3).col_num = 1920;
yuvs(3).frame_num = 7000;
yuvs(3).format = 'yuv420p';
 
mystitcher = mystitcher.estimate(yuvs);

tic
result = mystitcher.stitch(yuvs,9900);
toc

save('stitch.mat');

