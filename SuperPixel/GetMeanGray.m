function meanGray = GetMeanGray(labels,numlabels,img_gray)
    [height,width] = size(labels);
    olabels = zeros(height,width);
    for r = 1 : height
        for c = 1 : width
            olabels(r,c) = labels(r,c);
        end
    end
    
    sz = height*width;
    gvec = zeros(sz,1);
    for i = 1 : sz
        gvec(i) = img_gray(i);
    end
    
    sigma = zeros(numlabels,1);
    count = zeros(numlabels,1);
    meanGray = zeros(numlabels,1);
    for i = 1 : sz
        sigma(olabels(i)) = sigma(olabels(i)) + gvec(i);
        count(olabels(i)) = count(olabels(i)) + 1;
    end
    for i = 1 : numlabels
        meanGray(i) = sigma(i)/count(i);
    end
    
%     maxmean = max(meanGray);
%     minmean = min(meanGray);
%     for i = 1 : numlabels
%         meanGray(i) = 255*((meanGray(i) - minmean)/(maxmean - minmean));
%     end
    meanGray = mat2gray(meanGray);
end
