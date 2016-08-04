clear all;
close all;
warning off;

fid = fopen('logo_clip.yuv','r');
mov = itool.read_yuv(fid,1080,1920,'yuv420p',9);
itool.play_movie(mov);

mask = load('E:\WorkSpace\removelogo\+itool\@VideoInpainter\mask.mat');
vi = itool.VideoInpainter(mask.image);

vi = vi.inpaint(mov);

fclose(fid);