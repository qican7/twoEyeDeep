function[img_ContoursEX,nlabels] = SLIC_main(image) 

% close all;clear;clc;warning off all;
% % load Texture_Norm;
% % load Texture_Norm;
% % T_Norm = 65535*Texture_Norm;
% % save T_Norm T_Norm;
% I = imread('plane2.png');  
% % img_gray = mat2gray(I);
% I=double(I)/255;  
%   
% w = 7;           % bilateral filter half-width  
%                  % ˫���˲�����3������Ŀ��ƣ��˲������N�������s�ͦ�r��
%                  % NԽ��ƽ������Խǿ��
% sigma = [1 0.5]; % bilateral filter standard deviations  
%                  % ��s�ͦ�r�ֱ�����ſռ��ڽ������Ws���������ƶ�����Wr��˥���̶ȡ�
%                  % ��sԽ����ɫƽ����Խ�ã���rԽ��Խģ�� 
% img = bfilter2(I,w,sigma); 
% img_gray = mat2gray(img);
% % img_r = histeq(img(:,:,1));
% % img_g = histeq(img(:,:,2));
% % img_b = histeq(img(:,:,3));
% % img = cat(3,img_r,img_g,img_b);
% figure,
% % subplot(1,3,1); imshow(img(:,:,1));title('R');
% % subplot(1,3,2); imshow(img(:,:,2));title('G'); 
% % subplot(1,3,3); imshow(img(:,:,3));title('B');
% subplot(1,2,1); imshow(I);title('I');
% subplot(1,2,2); imshow(img);title('img'); 
% % imwrite(img,'plane2_f.jpg');

% img = imread('imageTwoEye/6right.png'); 
img = image;
img_size = size(img);   %���Ԫ�أ�ͼ��ĸߡ�ͼ��Ŀ?ͼ���ͨ����
K = 100;    %�趨�����ظ���
m_compactness = 10; %�趨�����ؽ���ϵ��

%ת����LABɫ�ʿռ�
cform = makecform('srgb2lab');       %rgb�ռ�ת����lab�ռ� matlab�Դ���÷�
img_Lab = applycform(img, cform);    %rgbת����lab�ռ�

%����Ե
% img_edge = DetectLabEdge(img_Lab);
% figure,imshow(img_edge,[]);

%�õ������ص�LABXY���ӵ���Ϣ
img_sz = img_size(1)*img_size(2);
superpixel_sz = img_sz/K;
STEP = uint32(sqrt(superpixel_sz));
xstrips = uint32(img_size(2)/STEP);
ystrips = uint32(img_size(1)/STEP);
xstrips_adderr = double(img_size(2))/double(xstrips);
ystrips_adderr = double(img_size(1))/double(ystrips);
numseeds = xstrips*ystrips;
%���ӵ�xy��Ϣ��ʼֵΪ�����������������
%���ӵ�Lab��ɫ��ϢΪ��Ӧ����ӽ����ص����ɫͨ��ֵ
kseedsx = zeros(numseeds, 1);
kseedsy = zeros(numseeds, 1);
kseedsl = zeros(numseeds, 1);
kseedsa = zeros(numseeds, 1);
kseedsb = zeros(numseeds, 1);
n = 1;
for y = 1: ystrips
    for x = 1: xstrips 
        kseedsx(n, 1) = (double(x)-0.5)*xstrips_adderr;
        kseedsy(n, 1) = (double(y)-0.5)*ystrips_adderr;
        kseedsl(n, 1) = img_Lab(fix(kseedsy(n, 1)), fix(kseedsx(n, 1)), 1);
        kseedsa(n, 1) = img_Lab(fix(kseedsy(n, 1)), fix(kseedsx(n, 1)), 2);
        kseedsb(n, 1) = img_Lab(fix(kseedsy(n, 1)), fix(kseedsx(n, 1)), 3);
        n = n+1;
    end
end
n = 1;
%������ӵ���㳬���ط���

% [klabels,clustersize] = PerformSuperpixelSLIC(img_Lab,T_Norm, kseedsl, kseedsa, kseedsb, kseedsx, kseedsy, STEP, m_compactness);
[klabels,clustersize] = PerformSuperpixelSLIC_1(img_Lab,  kseedsl, kseedsa, kseedsb, kseedsx, kseedsy, STEP, m_compactness);
img_Contours = DrawContoursAroundSegments(img, klabels);
figure,imshow(img_Contours);title('img_Contours');

%�ϲ�С�ķ���
nlabels = EnforceLabelConnectivity(img_Lab, klabels, K); 
% nlabels_1 = EnforceLabelConnectivity(img_Lab, klabels_1, K); 
% save SLICLabels nlabels;
% save SLIC_Labels nlabels_1;

%��ݵõ��ķ����ǩ�ҵ��߽�
img_ContoursEX = DrawContoursAroundSegments_EX(img, nlabels);
% img_ContoursEX_1 = DrawContoursAroundSegments_EX(img, nlabels_1);

figure,imshow(img_ContoursEX);
% subplot(1,2,1); imshow(img_ContoursEX); title('img_ContoursEX');
% subplot(1,2,2); imshow(img_ContoursEX_1); title('img_ContoursEX_1');
% imwrite(img_ContoursEX,'SLIC_Tex.jpg');
% imwrite(img_ContoursEX_1,'SLIC.jpg');

%% ͳ��ÿһ�������صĳߴ��С
% dimension = zeros(1,100);
% [label_m, label_n] = size(nlabels);
% for i=1:label_m
%     for j=1:label_n
%         dimension(nlabels(i,j)) = dimension(nlabels(i,j)) + 1;
%     end
% end

%%


%%
% numlabel = max(max(nlabels));
% numlabel_1 = max(max(nlabels_1));
% ForgSurp = GetForegroundSuperpixels(img, nlabels, numlabels);
% ForgSurp_1 = GetForegroundSuperpixels(img, nlabels_1, numlabels_1);
% meanGray = GetMeanGray(nlabels,numlabel,img_gray);
% meanGray_1 = GetMeanGray(nlabels_1,numlabel_1,img_gray);
% imwrite(meanGray,'meanGray.jpg');
% imwrite(meanGray_1,'meanGray_1.jpg');

% % [x,y] = size(nlabels);
% forfor = find(ForgSurp==1)-1;
% len = length(forfor);
% ss_img = zeros(img_size(1),img_size(2));
% for i = 1:len
%     for height = 1:img_size(1)
%         for width = 1:img_size(2)
%             if(nlabels(height,width)==forfor(i))
%                 ss_img(height,width) = img_gray(height,width);
%             end
%         end
%     end
% end
% 
% forfor_1 = find(ForgSurp_1==1)-1;
% len_1 = length(forfor_1);
% ss_img_1 = zeros(img_size(1),img_size(2));
% for i = 1:len_1
%     for height = 1:img_size(1)
%         for width = 1:img_size(2)
%             if(nlabels_1(height,width)==forfor_1(i))
%                 ss_img_1(height,width) = img_gray(height,width);
%             end
%         end
%     end
% end
% 
% figure,
% subplot(1,2,1),imshow(ss_img);title('ss_img');
% subplot(1,2,2),imshow(ss_img_1);title('ss_img_1');










