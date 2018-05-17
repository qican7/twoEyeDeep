

%% 
% 寻找标号为label_L的超像素内的所有像素点 返回所有像素点的坐标矩阵L 及像素点个数len
%% 
function [L,len] = PixelFinding(nlabels, label_L)

[m, n] = find(nlabels == label_L);
L = [m,n];
len = size(m);
 
    