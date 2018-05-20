%% ����˵��
% ����˵���� ˫Ŀ������ƥ��
% Arguments��        I_left - ��Ŀͼ��
%                   I_right - ��Ŀͼ��
%                     num_d - ŷ�Ͼ���ɸѡ�ٷֱ�
%                 num_pixel - �Ӳ�ɸѡ�ٷֱ�

% Return��       left_point - ��Ŀ���������꼰�Ӳ�
%               right_point - ��Ŀ���������꼰�Ӳ�

%% ��������
% clc;clear all;
% close all;
% num = 200;

% I_left = imread('G:\ʵ��������\2017.6 ����˫Ŀ�Ӿ���������Ŀ���ⷽ��\ʵ��\pic\4left.ppm'); %��Ŀͼ��
% I_right = imread('G:\ʵ��������\2017.6 ����˫Ŀ�Ӿ���������Ŀ���ⷽ��\ʵ��\pic\4right.ppm'); %��Ŀͼ��

%% �������
function [left_point,right_point,Pos11,parallax] = match(I_left, I_right , num_d , num_pixel)

I11 = I_left;
I22 = I_right;
if length(size(I11)) == 3
  I1=rgb2gray(I11);
else
  I1 =  I11;
end
if length(size(I22)) == 3
  I2=rgb2gray(I22);
else
  I2 =  I22;
end

% figure,imshow(I1);
% figure,imshow(I2);

Options.upright=true;
Options.tresh=0.0000001;
Ipts1=OpenSurf(I1,Options);  %1*268
Ipts2=OpenSurf(I2,Options);

% Put the landmark descriptors in a matrix
D1 = reshape([Ipts1.descriptor],64,[]);  %64*268
D2 = reshape([Ipts2.descriptor],64,[]);

% Find the best matches
err=zeros(1,length(Ipts1));   
cor1=1:length(Ipts1);
cor2=zeros(1,length(Ipts1));
for i=1:length(Ipts1)
    distance=sum((D2-repmat(D1(:,i),[1 length(Ipts2)])).^2,1);%��D2��ÿһ�зֱ�ȥ��D1��ÿһ��,�õ�ÿһ�в�ֵ��ƽ����
    [err(i),cor2(i)]=min(distance);  %err����Сֵ cor2����Сֵ��Ӧ���±꣬������ͼ1�е�i����������ͼ2�е�cor2(i)����������֮������С
end

% Sort matches on vector distance������������
[err, ind]=sort(err);  %��ÿһ�е���Сֵ���� err������ֵ ind����Ӧ�±�
cor1=cor1(ind);   %ͼ1�������������С������±�˳��
cor2=cor2(ind);   %ͼ2�������������С������±�˳��

% Make vectors with the coordinates of the best matches
Pos1_temp=[[Ipts1(cor1).y]',[Ipts1(cor1).x]'];
Pos2_temp=[[Ipts2(cor2).y]',[Ipts2(cor2).x]'];
num_pos = length(Pos2_temp(:,1))*num_d;  %ŷʽ����ɸѡ
Pos1 = Pos1_temp([1:num_pos],:);
Pos2 = Pos2_temp([1:num_pos],:);

Pos1(:,3)=1; Pos2(:,3)=1;
%ͳ��б��
skew = [Pos1(:,1)-Pos2(:,1)]./[Pos1(:,2)-Pos2(:,2)-size(I1,2)];
[skew2]= tabulate(floor(skew*100)./100);
[skew3 id_skew]= sort(skew2(:,3),'descend');
[id_skew2] = find(floor(skew*100)/100==skew2(id_skew(1),1));
num_skew = length(id_skew2);
Pos11([1:num_skew],:,:) = Pos1(id_skew2,:,:);
Pos22([1:num_skew],:,:) = Pos2(id_skew2,:,:);



%%
% Pos11 = single(Pos11(:,1:2));
% Pos22 = single(Pos22(:,1:2));

%��ȡ�任����H
% [H corrPtIdx] = findHomography(Pos11,Pos22);
% 
% tform = maketform('affine',H'); %�任��ʽ��affine������任��ʽ  projective:ͶӰ�任��ʽ
% 
% for i = 100:110
%     for j = 100:110
%         I_left(i,j) = 0;
%         coorid = imtransform([i j],tform)
%         I_right(uint8(coorid(1)),uint8(coorid(2))) = 0;
%     end
% end
% 
% figure,imshow(I_left);title('I_left');
% figure,imshow(I_right);title('I_right');

% img21 = imtransform(img2,tform); % reproject img2

I = zeros([size(I11,1) size(I11,2)*2 size(I11,3)]);
I(:,1:size(I11,2),:)=I11;
I(:,size(I11,2)+1:size(I11,2)+size(I22,2),:)=I22;
figure, imshow(uint8(I)); hold on;

% axis on;
% plot([Pos11(:,2) Pos22(:,2)+size(I1,2)]',[Pos11(:,1) Pos22(:,1)]','-');
% plot([Pos11(:,2) Pos22(:,2)+size(I1,2)]',[Pos11(:,1) Pos22(:,1)]','+');

% disp = Pos11(:,2) - Pos22(:,2);     
parallax = abs((Pos22(:,2) - Pos11(:,2)));  %��ȡ�������Ӳ�
[parallax2 id]= sort(parallax,'descend');
num = floor(length(id)*num_pixel);
% num =1;
plot([Pos11(id(1:num),2) Pos22(id(1:num),2)+size(I1,2)]',[Pos11(id(1:num),1) Pos22(id(1:num),1)]','-');
plot([Pos11(id(1:num),2) Pos22(id(1:num),2)+size(I1,2)]',[Pos11(id(1:num),1) Pos22(id(1:num),1)]','o');
hold off;


for i = 1:num
    left_point{i} = round([Pos11(id(i),2),Pos11(id(i),1),parallax(id(i))]);
    right_point{i} = round([Pos22(id(i),2),Pos22(id(i),1),parallax(id(i))]);
end
end
