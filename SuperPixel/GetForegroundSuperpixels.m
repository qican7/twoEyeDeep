function ForgSurp = GetForegroundSuperpixels(img, labels, numlabels)

% close all;clear all;clc;
%---------------------------------------------------------
% Read image and blur it with a 3x3 or 5x5 Gaussian filter
%---------------------------------------------------------
% img = imread('plane_BiFilter 0.5.jpg');%Provide input image path
gfrgb = imfilter(img, fspecial('gaussian', 5, 5), 'symmetric', 'conv');
%---------------------------------------------------------
% Perform sRGB to CIE Lab color space conversion (using D65)
%---------------------------------------------------------
cform = makecform('srgb2lab','AdaptedWhitePoint', whitepoint('D65'));
lab = applycform(gfrgb,cform);
% figure(1),
% subplot(1,2,1),imshow(img,[]);title('Original Image');
% subplot(1,2,2),imshow(lab,[]);title('Lab Image');
%---------------------------------------------------------
% Compute Lab average values (note that in the paper this
% average is found from the unblurred original image, but
% the results are quite similar)
%---------------------------------------------------------
l = double(lab(:,:,1)); lm = mean(mean(l));
a = double(lab(:,:,2)); am = mean(mean(a));
b = double(lab(:,:,3)); bm = mean(mean(b));
% l = outkseedsl; lm = mean(l);
% a = outkseedsa; am = mean(a);
% b = outkseedsb; bm = mean(b);


%---------------------------------------------------------
% Finally compute the saliency map and display it.
%---------------------------------------------------------
sm = (l-lm).^2 + (a-am).^2 + (b-bm).^2;
figure,imshow(sm,[]);title('saliency map');
Ta=2*mean(mean(sm));

[m,n]=size(sm);
ForgSurp = zeros(numlabels,1);
for i=1:m
    for j=1:n
        if sm(i,j)>=Ta
            sm(i,j)=65535;
            ForgSurp(labels(i,j)+1) = 1;
        else
            sm(i,j)=0;
        end
    end
end
% [x,y] = size(labels);
% ss_img = zeros(x,y);
% for i=1:len_sm
%     if sm(i)>=Ta
%         for height = 1:x
%             for width = 1:y
%                 if(labels(height,width)==(i-1))
%                     ss_img(height,width) = img(height,width);
%                 end
%             end
%         end
%     end
% end
% figure,imshow(ss_img);title('saliency map');
figure,imshow(sm);title('saliency map to binary');


