clear all;
close all;

movie = load('E:\WorkSpace\itool\+itool\@VideoInpainter\unit_test\movie.mat');
mask = load('E:\WorkSpace\itool\+itool\@VideoInpainter\unit_test\mask.mat');

movie = movie.mov(:,:,:,1:10);
mask = mask.image(1:237,(1920-576+1):1920);
itool.play_movie(movie);

vi = itool.VideoInpainterCopy(4,4,2);
tic
vi = vi.inpaint(movie,mask);
toc