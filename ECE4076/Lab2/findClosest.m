function [closestTo, dist] = findClosest(img, vals)
%For all pixels, find which are the closest to each mean index.

mysize = size(img);
valsize = size(vals);
k = valsize(1);

distRGB = zeros(k, mysize(1), mysize(2), 3);
for y = 1:mysize(1)
    for x = 1:mysize(2)
        for i = 1:k
            for j = 1:3
                distRGB(i,y,x,j) = (img(y,x,j) - vals(i,j));
            end
        end
    end
end
distabs = abs(distRGB);
distsq = sum(distabs, 4);
dist = sqrt(distsq);
[dist, closestTo] = min(dist,[],1);
dist=squeeze(dist);
closestTo = squeeze(closestTo);