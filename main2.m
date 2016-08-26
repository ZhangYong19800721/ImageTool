clear all;
close all;

theda1 = 10;
theda2 = -10;
theda3 = 30;

theda = [0 -theda3 theda2; theda3 0 -theda1; -theda2 theda1 0] * pi / 180;
R = expm(theda);

M = R'*R;