% close all;clear all;clc;
% 
% I = imread('Dehazing_A.jpg');
% 
% level = graythresh(I);
% I_bw = im2bw(I,level);
% 
% I_gray = rgb2gray(I);
% I_edge = edge(I_gray,'canny');
% 
% 
% figure,
% subplot(1,3,1),imshow(I);
% subplot(1,3,2),imshow(I_bw);
% subplot(1,3,3),imshow(I_edge);

% T=10;
% final_labels = AdjacentBlocksFinding(img,nlabels, round(kseedsx), round(kseedsy), T, STEP);
% FFF = DrawContoursAroundSegments_EX(img, final_labels);
% figure,imshow(FFF);title('T =', num2str(T));

% for i = 1:numseeds
%     [mindis1, spl1, adj1] = MinFeatureDistance(img, nlabels, i);
%     [mindis2, spl2, adj2] = MinFeatureDistance(img, nlabels, adj1);
%     if(adj2==i)
%         nlabels = Merging(nlabels,i,adj1);
%     end
% end
% F = DrawContoursAroundSegments_EX(img, nlabels);
% figure,imshow(F);

% 将灰度图转化为彩虹图
% function threeDImage = gray2rainbow(grayImage)
grayImage = imread('sonar.png');
[H W tunnel] = size(grayImage);
if tunnel ~= 1
    error('Please Input Gray Image:)');
end

threeDImage = zeros(H,W,3);

for i=1:H
    for j=1:W
        if grayImage(i,j)<=51
            threeDImage(i,j,1)=0;
            threeDImage(i,j,2)=5*grayImage(i,j);
            threeDImage(i,j,3)=255;
        elseif grayImage(i,j)<=102
            tmp = grayImage(i,j)-51;
            threeDImage(i,j,1)=0;
            threeDImage(i,j,2)=255;
            threeDImage(i,j,3)=255-5*tmp;
        elseif grayImage(i,j)<=153
            tmp = grayImage(i,j)-102;
            threeDImage(i,j,1)=5*tmp;
            threeDImage(i,j,2)=255;
            threeDImage(i,j,3)=0;   
        elseif grayImage(i,j)<=204
            tmp = grayImage(i,j)-153;
            threeDImage(i,j,1)=255; 
            threeDImage(i,j,2)=255-round(128*tmp./51+0.5);  
            threeDImage(i,j,3)=0;  
        else
            tmp = grayImage(i,j)-204;
            threeDImage(i,j,1)=255; 
            threeDImage(i,j,2)=127-round(127*tmp./51+0.5);  
            threeDImage(i,j,3)=0; 
        end
    end
end
threeDImage = uint8(threeDImage);
figure,imshow(threeDImage);
imwrite(threeDImage,'6_3D.jpg');

