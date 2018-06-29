function [ out ] = threshold( img, thresholdVal )
%THRESHOLD Summary of this function goes here
%   Detailed explanation goes here

%out = img();
out = uint8((img>thresholdVal)*255);

end

