

%% 
% Ѱ�ұ��Ϊlabel_L�ĳ������ڵ��������ص� �����������ص���������L �����ص����len
%% 
function [L,len] = PixelFinding(nlabels, label_L)

[m, n] = find(nlabels == label_L);
L = [m,n];
len = size(m);
 
    