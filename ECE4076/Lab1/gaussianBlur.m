function blur = gaussianBlur(img)
% This performs a Gaussian blur on the image specified from the root
% directory. Assuming that we will reduce the image size.
% img should be an imread() object.

s = size(img);

B = 1/159 * [
    [2 4  5  4  2];
    [4 9  12 9  4];
    [5 12 15 12 5];
    [4 9  12 9  4];
    [2 4  5  4  2];
];

fs = floor(size(B)/2); %Filter Size
bs = s - 2 * fs; %Blur Size
blur = zeros(bs);

for i = 1 + fs(1) : s(1) - fs(1)
    for j = 1 + fs(2) : s(2) - fs(2)
       A=0;
       for m = 1:5
           for n = 1:5
               A = A + B(m,n)*img(i-3+m,j-3+n);
           end
       end
       blur(i-fs(1),j-fs(2))=A;
    end
end

blur = uint8(floor(blur));