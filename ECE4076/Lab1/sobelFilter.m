function [gradientx,gradienty] = sobelFilter(img)
% This performs a Gaussian blur on the image specified from the root
% directory. Assuming that we will reduce the image size.
% img should be an imread() object, in UINT8 form.

img = double(img);

s = size(img);

Bx = 1/8 * [
    [-1 0 1];
    [-2 0 2];
    [-1 0 1];
];
By = Bx';

fs = floor(size(Bx)/2); %Filter Size
bs = s - 2 * fs; %Blur Size
gradientx = zeros(bs);
gradienty = zeros(bs);

for i = 1 + fs(1) : s(1) - fs(1)
    for j = 1 + fs(2) : s(2) - fs(2)
       Ax=0;
       Ay=0;
       for m = 1:3
           for n = 1:3
               Ax = Ax + Bx(m,n)*img(i-2+m,j-2+n);
               Ay = Ay + By(m,n)*img(i-2+m,j-2+n);
           end
       end
       gradientx(i-fs(1),j-fs(2))=Ax;
       gradienty(i-fs(1),j-fs(2))=Ay;
    end
end

% Shift median point to 0 because of negative and positive edges.
gradientx = gradientx + 256/2; %Half value of UINT8/2
gradienty = gradienty + 256/2; %Half value of UINT8/2

gradientx = uint8(floor(gradientx));
gradienty = uint8(floor(gradienty));