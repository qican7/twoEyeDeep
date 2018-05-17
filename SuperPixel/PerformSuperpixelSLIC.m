function [klabels,clustersize] = PerformSuperpixelSLIC(img_Lab,Texture, kseedsl, kseedsa, kseedsb, kseedsx, kseedsy, STEP, compactness)

[m_height, m_width, m_channel] = size(img_Lab);
numseeds = size(kseedsl);
img_Lab = double(img_Lab);
%���ر�ǩ��ʽΪ(x, y) (��, ��)
klabels = zeros(m_height, m_width);
%����ߴ�
clustersize = zeros(numseeds, 1);
inv = zeros(numseeds, 1);
sigmal = zeros(numseeds, 1);
sigmaa = zeros(numseeds, 1);
sigmab = zeros(numseeds, 1);
sigmax = zeros(numseeds, 1);
sigmay = zeros(numseeds, 1);
invwt = 1/((double(STEP)/double(compactness))*(double(STEP)/double(compactness)));
%invwt = double(compactness)/double(STEP);
distvec = 100000*ones(m_height, m_width);
numk = numseeds;
for itr = 1: 10   %��������
    sigmal = zeros(numseeds, 1);
    sigmaa = zeros(numseeds, 1);
    sigmab = zeros(numseeds, 1);
    sigmax = zeros(numseeds, 1);
    sigmay = zeros(numseeds, 1);
    clustersize = zeros(numseeds, 1);
    inv = zeros(numseeds, 1);
    distvec = double(10000000*ones(m_height, m_width));
    
    %���ݵ�ǰ���ӵ���Ϣ����ÿһ�����صĹ���
    for n = 1: numk
        y1 = max(1, kseedsy(n, 1)-STEP);
        y2 = min(m_height, kseedsy(n, 1)+STEP);
        x1 = max(1, kseedsx(n, 1)-STEP);
        x2 = min(m_width, kseedsx(n, 1)+STEP);
        %�����ؼ������
        for x = x1: x2
            for y = y1: y2
                %dist_lab = abs(img_Lab(y, x, 1)-kseedsl(n))+abs(img_Lab(y, x, 2)-kseedsa(n))+abs(img_Lab(y, x, 3)-kseedsb(n));
                dist_lab = (img_Lab(y, x, 1)-kseedsl(n, 1))^2+(img_Lab(y, x, 2)-kseedsa(n, 1))^2+(img_Lab(y, x, 3)-kseedsb(n, 1))^2;
                dist_xy = (double(y)-kseedsy(n, 1))*(double(y)-kseedsy(n, 1)) + (double(x)-kseedsx(n, 1))*(double(x)-kseedsx(n, 1));
                %dist_xy = abs(y-kseedsy(n)) + abs(x-kseedsx(n));
                
                t_num = (y-1)*m_width +x;
                seed_num = abs(fix((kseedsy(n, 1)-1))*m_width + fix(kseedsx(n, 1)));
%                 seed_num = abs(round((kseedsy(n, 1)-1))*m_width + round(kseedsx(n, 1)));
                dist_tex = sqrt(sum((Texture(t_num,2:7)-Texture(seed_num,2:7)).^2,2));
               
                %���� = labɫ�ʿռ���� + �ռ����Ȩ�ء��ռ����
                dist = 95*(dist_lab + dist_xy * invwt) + 5*dist_tex;
                
                %����Χ����ĸ����ӵ����ҵ������Ƶ� ��Ǻ����klabels
                %m = (y-1)*m_width+x;
                if (dist<distvec(y, x))
                    distvec(y, x) = dist;
                    klabels(y, x) = n;
                end
            end
        end
    end
% ��ն�
% for iternum = 1:10
    [loc_x,loc_y] = find(klabels==0);
    loction = [loc_x,loc_y];
    len_loc = length(loction);
    for c = 1:len_loc
        if (loction(c,1)==1 && loction(c,2)==1)
            klabels(loction(c,1),loction(c,2)) = 1;
            else if(loction(c,1)==1)
                klabels(loction(c,1),loction(c,2))= klabels(loction(c,1),loction(c,2)-1); 
                else if(loction(c,2)==1)
                    klabels(loction(c,1),loction(c,2))= klabels(loction(c,1)-1,loction(c,2)); 
                    else
                        klabels(loction(c,1),loction(c,2))= klabels(loction(c,1)-1,loction(c,2)-1);
                    end
                end
        end
    end
% end
    
    %���¼������ӵ�λ�� ʹ�����ݶ���С�ط��ƶ�
    ind = 1;
    for r = 1: m_height
        for c = 1: m_width 
            sigmal(klabels(r, c),1) = sigmal(klabels(r, c),1)+img_Lab(r, c, 1);
            sigmaa(klabels(r, c),1) = sigmaa(klabels(r, c),1)+img_Lab(r, c, 2);
            sigmab(klabels(r, c),1) = sigmab(klabels(r, c),1)+img_Lab(r, c, 3);
            sigmax(klabels(r, c),1) = sigmax(klabels(r, c),1)+c;
            sigmay(klabels(r, c),1) = sigmay(klabels(r, c),1)+r;
            clustersize(klabels(r, c),1) = clustersize(klabels(r, c),1)+1;
        end
    end
    for m = 1: numseeds
        if (clustersize(m, 1)<=0)
            clustersize(m, 1) = 1;
        end
        inv(m, 1) = 1/clustersize(m, 1);
    end
    for m = 1: numseeds
        kseedsl(m, 1) = sigmal(m, 1)*inv(m, 1);
        kseedsa(m, 1) = sigmaa(m, 1)*inv(m, 1);
        kseedsb(m, 1) = sigmab(m, 1)*inv(m, 1);
        kseedsx(m, 1) = sigmax(m, 1)*inv(m, 1);
        kseedsy(m, 1) = sigmay(m, 1)*inv(m, 1);
    end
end


end


