close all;clear;clc;warning off all;

img_left = imread('imageTwoEye/29left.png'); 
img_right = imread('imageTwoEye/29right.png'); 

img_left_gray = rgb2gray(img_left);
img_right_gray = rgb2gray(img_right);

[img_left_SLIC,leftLabel] = SLIC_main(img_left);
[img_right_SLIC,rightLabel] = SLIC_main(img_right);

img_left_SLIC_gray = rgb2gray(img_left_SLIC);
img_right_SLIC_gray = rgb2gray(img_right_SLIC);

[image_m, image_n] = size(img_left_gray);

leftLabel_max = max(max(leftLabel));
rightLabel_max = max(max(rightLabel));

img_left_hist = zeros(leftLabel_max,256);
img_right_hist = zeros(rightLabel_max,256);

img_left_center = zeros(4,leftLabel_max);
img_right_center = zeros(4,rightLabel_max);

img_left_center(1,:) = 1000;
img_left_center(3,:) = 1000;
img_right_center(1,:) = 1000;
img_right_center(3,:) = 1000;


img_left_center_point = zeros(2,leftLabel_max);
img_right_center_point = zeros(2,rightLabel_max);

for i = 1:image_m
    for j = 1:image_n
        img_left_hist(leftLabel(i,j),img_left_gray(i,j)) = img_left_hist(leftLabel(i,j),img_left_gray(i,j)) + 1;
        img_right_hist(rightLabel(i,j),img_right_gray(i,j)) = img_right_hist(rightLabel(i,j),img_right_gray(i,j)) + 1;
        
        %��Ŀͼ���ͳ��
        if i < img_left_center(1,leftLabel(i,j))
            img_left_center(1,leftLabel(i,j)) = i;
        else if i > img_left_center(2,leftLabel(i,j))
                img_left_center(2,leftLabel(i,j)) = i;
            end
        end
        
        if j < img_left_center(3,leftLabel(i,j))
            img_left_center(3,leftLabel(i,j)) = j;
        else if j > img_left_center(4,leftLabel(i,j))
                img_left_center(4,leftLabel(i,j)) = j;
            end 
        end
        
        %��Ŀͼ���ͳ��
        if i < img_right_center(1,rightLabel(i,j))
            img_right_center(1,rightLabel(i,j)) = i;
        else if i > img_right_center(2,rightLabel(i,j))
                img_right_center(2,rightLabel(i,j)) = i;
            end
        end
        
        if j < img_right_center(3,rightLabel(i,j))
            img_right_center(3,rightLabel(i,j)) = j;
        else if j > img_right_center(4,rightLabel(i,j))
                img_right_center(4,rightLabel(i,j)) = j;
            end 
        end
    end
end

%���㳬���ؿ������
for i = 1:leftLabel_max
    img_left_center_point(1,i) =  (img_left_center(1,i) + img_left_center(2,i))./2;
    img_left_center_point(2,i) =  (img_left_center(3,i) + img_left_center(4,i))./2;
    img_left_SLIC_gray(uint16(img_left_center_point(1,i)), uint16(img_left_center_point(2,i))) = 255;
end


for i = 1:rightLabel_max
    img_right_center_point(1,i) =  (img_right_center(1,i) + img_right_center(2,i))./2;
    img_right_center_point(2,i) =  (img_right_center(3,i) + img_right_center(4,i))./2;
    img_right_SLIC_gray(uint16(img_right_center_point(1,i)), uint16(img_right_center_point(2,i))) = 255;
end

figure,imshow(img_left_SLIC_gray);title('image_left_gray');
figure,imshow(img_right_SLIC_gray);title('image_right_gray');

similar = zeros(1,leftLabel_max);
dist = zeros(1,leftLabel_max);

% img_left_center_point = uint16(img_left_center_point);

for i = 1:leftLabel_max  %����Ŀͼ���е�ÿһ�������ؿ��������
    if img_left_center_point(2,i) > 100  %����Ŀͼ�����д���100�����������������ֹ��ƥ��
        for j = 1:rightLabel_max %����Ŀͼ���ÿһ�������ؿ��������
            distance = sqrt((img_left_center_point(1,i) - img_right_center_point(1,j)).^2 + (img_left_center_point(2,i) - img_right_center_point(2,j)).^2)
            if  distance < 300
                s = ChiSquareDistance(img_left_hist(i,:),img_right_hist(j,:));
                if s > similar(i)
                    similar(i) = s;
                    dist(i) = distance;
                end
            end
        end
    end
end

image_deep = zeros(image_m,image_n);

for i = 1:image_m
    for j = 1:image_n
        image_deep(i,j) = dist(leftLabel(i,j));
    end
end

Y = image_deep(:);

Y = mapminmax(Y',0,255);

Y = Y';

image_deep_better = reshape(Y,384,512);

figure,imshow(uint8(image_deep_better));



        