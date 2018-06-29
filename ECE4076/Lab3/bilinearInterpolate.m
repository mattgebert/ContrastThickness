function [values, invalidIndicies] = bilinearInterpolate(A,coords)
% Returns the bilinear interpolation of a x,y coordinate

numCoords = length(coords);
imsizeA = size(A);

%Get discretized Coordinates:
q11 = floor(coords); %Top Left
q22 = q11 + 1;%Bottom Right

%Find Invalid Indexes:
invalidIndicies = ( q22(:,1) > imsizeA(2) ) | (q22(:,2) > imsizeA(1)) | (q11(:,1) < 1) | (q11(:,2) < 1);
% invalidCoords = coords(invalidIndexes);

default = repmat([1 1], sum(invalidIndicies),1);
q11(invalidIndicies,:) = default;
q22(invalidIndicies,:) = default;

% sub2ind works with x, y.
% Here we get the indexes to access intensity points in array A
i11 = sub2ind(imsizeA, q11(:,2),q11(:,1));
i12 = sub2ind(imsizeA, q11(:,2),q22(:,1));
i21 = sub2ind(imsizeA, q22(:,2),q11(:,1));
i22 = sub2ind(imsizeA, q22(:,2),q22(:,1));


% Compile 4 intensities in a matrix for each coordinate
surroundingIntensities = A([i11 i12 i21 i22]);
bcoeffs = zeros(numCoords, 4);
values = zeros(numCoords, 1);

for i = 1:numCoords
    if (invalidIndicies(i)==0)
        %Setup a linear matrix where each line has 1, x, y, xy
        % 4 Nearby Point Coordinates:
        mat = [1 q11(i,2) q11(i,1) (q11(i,2).*q11(i,1))
            1 q11(i,2) q22(i,1) (q11(i,2).*q22(i,1))
            1 q22(i,2) q11(i,1) (q22(i,2).*q11(i,1))
            1 q22(i,2) q22(i,1) (q22(i,2).*q22(i,1))];
        % Actual coordinates: [1 x, y, xy]
        x = [1 coords(i,2) coords(i,1) coords(i,1).*coords(i,2)];
        % Get coefficients of each 
        warning off MATLAB:singularMatrix
        bcoeffs(i,:) = inv(mat).' * x';
        warning on MATLAB:singularMatrix
        % Calculate the interpolated value based on the coefficients of the 4
        % surrounding pixels
        values(i) = bcoeffs(i,:) * double(surroundingIntensities(i,:)');
    end
end