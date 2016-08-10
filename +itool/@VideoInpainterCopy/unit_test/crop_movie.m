clear all;
close all;
warning off;

row_num = 1080;
col_num = 1920;

fid = fopen('logo_clip.yuv','r');
mov = itool.read_yuv(fid,row_num,col_num,'yuv420p',300);

xfactor = 0.22; yfactor = 0.3;
row_area = 1:(xfactor * row_num);
col_area = (col_num - yfactor * col_num + 1):col_num;

mov = mov(row_area,col_area,:,:);
itool.play_movie(mov);

fclose(fid);
save movie.mat mov