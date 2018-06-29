function [newimg, newmeans] = getAveImg(img, closestToArray, k)
mysize = size(img);
%Calculate the actual means for each
amounts = zeros(k,1);
totals = zeros(k,3);
newmeans = zeros(k,3); %Computation in for loop below

%Make new image with colours of means calculated.
newimg = zeros(mysize(1),mysize(2),3);
for i = 1:k
    [y,x] = find(closestToArray==i);
    l = length(x);
    amounts(i) = l;
    for j = 1:l
        totals(i,:) = totals(i,:) +  double(squeeze(img(y(j),x(j),:))');
    end
    for j = 1:3
        newmeans(i,j) = totals(i,j)./l;
    end
    for j = 1:l
        newimg(y(j),x(j), :) = newmeans(i,:);
    end
end
newimg = uint8(newimg);