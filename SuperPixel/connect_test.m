clear;clc

GCOLabels = importdata('GCO_Labels.mat');
SLICLabels = importdata('SLIC_Labels.mat');

[r, c, channel] = size(SLICLabels);
Slabel = zeros(r,c);
% count = zeros(3,1);
% fig = zeros(3,1);
% percent = zeros(3,1);
% for i = 1:361
%     if (GCOlabels(i)==1)
%         count(1) = count(1)+1;
%         if(uint8(ForgSurp(i))==1)
%             fig(1) = fig(1)+1; 
%         end
%     end
%     
%     if (GCOlabels(i)==2)
%         count(2) = count(2)+1;
%         if(uint8(ForgSurp(i))==1)
%             fig(2) = fig(2)+1; 
%         end
%     end
%     
%     if (GCOlabels(i)==3)
%         count(3) = count(3)+1;
%         if(uint8(ForgSurp(i))==1)
%             fig(3) = fig(3)+1; 
%         end
%     end   
%     
% %     if (GCOlabels(i)==4)
% %         count(4) = count(4)+1;
% %         if(uint8(ForgSurp(i))==1)
% %             fig(4) = fig(4)+1; 
% %         end
% %     end 
% end
% 
% for i = 1:3
%     percent(i) = double(fig(i))/double(count(i));
% end
% 
% P = find(percent==1);
% len = length(P);
% for i = 1 : len
%     for j = 1 : 361
%         if (GCOlabels(j)==P(i))
%             for x = 1: r
%                 for y = 1:c
%                     if(SLIClabel(x,y)==(j-1))
%                         Slabel(x,y)=img_gray(x,y);
% %                     else
% %                         Slabel(x,y)=0;
%                     end
%                 end
%             end
%         end
%     end
% end   
    
for i = 1:45
    if (GCOLabels(i)==1)
        for x = 1: r
            for y = 1:c
                if(SLICLabels(x,y)==(i-1))
                    Slabel(x,y)=10;
                end
            end
        end
    end
    
    if (GCOLabels(i)==2)
        for x = 1: r
            for y = 1:c
                if(SLICLabels(x,y)==(i-1))
                    Slabel(x,y)=40;
                end
            end
        end
    end
    
    if (GCOLabels(i)==3)
        for x = 1: r
            for y = 1:c
                if(SLICLabels(x,y)==(i-1))
                    Slabel(x,y)=0;
                end
            end
        end
    end
    
    if (GCOLabels(i)==4)
        for x = 1: r
            for y = 1:c
                if(SLICLabels(x,y)==(i-1))
                    Slabel(x,y)=40;
                end
            end
        end
    end
    
%     if (GCOLabels(i)==5)
%         for x = 1: r
%             for y = 1:c
%                 if(SLICLabels(x,y)==(i-1))
%                     Slabel(x,y)=100;
%                 end
%             end
%         end
%     end

%     if (GCOLabels(i)==6)
%         for x = 1: r
%             for y = 1:c
%                 if(SLICLabels(x,y)==(i-1))
%                     Slabel(x,y)=0;
%                 end
%             end
%         end
%     end
    
end

% figure,imshow(img,[]);title('ԭͼ');
figure,imshow(Slabel,[]);title('�ָ�ͼ');





