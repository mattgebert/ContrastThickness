clc;clear;close all;

% Optimised for PDMS substrate for graphene.
%%% EXAMPLES OF GRAPHENE 
[crop, top, bottom, left, right] = deal(1);

% ----------------- IMPORT DATA-------------------------
imgpath='./100x Images2/';
imgfiles = dir([imgpath '*.jpg']);

for index = 1:length(imgfiles)
    % crop = 400; bottom = 250; right=600; left = 270; imgName = '100x Images/S01_C01_F01_100x.jpg';
%     crop = 400; bottom = 050; right=400; left = 70; imgName = '100x Images/S01_C01_F01_100x.jpg';
    imgName = imgfiles(index).name;

    img = imread([imgpath imgName]); 
    figure('Position', [10 10 1600 1000], 'Name', imgfiles(index).name)
    subplot(2,2,4);
    imshow(img)
    
    crop = 50;
    img = img(crop+top:end-crop-bottom,crop+left:end-crop-right,:);


    img = im2double(img);
    % g = img(:,:,2);
    g = rgb2gray(img);
    gsub = median(g(:));

    r = img(:,:,1);
    gr = img(:,:,2);
    g = rgb2gray(img);
    b = img(:,:,3);


    %Fig 1 - RGB Parts
    % f=figure;
    % subplot(2,2,1)
    % imshow(img);
    % subplot(2,2,2)
    % imshow(r)
    % subplot(2,2,3)
    % imshow(gr)
    % subplot(2,2,4)
    % imshow(b)
    % ax = findobj(f,'Type','Axes');
    % title(ax(4),'Colour')
    % title(ax(3),'Red')
    % title(ax(2),'Green')
    % title(ax(1),'Blue')

    % Fig 2 - Plot of contrast to substrate
    % figure
    c = (g-gsub)/(1-gsub);
    c = c(end:-1:2,1:end-1);
    s = size(g);
    sampling = 10;
    % [X,Y] = meshgrid(1:sampling:s(2)-1,1:sampling:s(1)-1);
    c = c(1:sampling:end, 1:sampling:end);
    % mesh(X,Y,c);
    % colorbar

    % Fig 3 - Histogram of contrast values.
    % figure
    % histogram(c,256)
    % xlabel('Contrast')
    % ylabel('Pixels')
    % title('Distribution of contrast values')
    % title('Distribution of contrast values for B04\_W03\_F02')
    % title('Distribution of contrast values for B04\_W06\_F03\_nearby')

    % Fig 4 - Average over a window
    avd = zeros(s(1)-2,s(2)-2);
    mask = [[1/16 1/8 1/16];...
            [1/8 1/4 1/8];...
            [1/16 1/8 1/16]]; 
    for i = 2:s(1)-1
        for j = 2:s(2)-1
            for k = 1:3
                for l = 1:3
                    avd(i-1, j-1) = avd(i-1, j-1) + mask(k,l) * g(i + k-2,j + l-2);
                end
            end
        end 
    end
    % figure
    % imshow(avd)

    % Fig 5 - Averaged filter Contrast to substrated
%     figure('Position', [10 10 1600 1000])
    subplot(2,2,1)
    gsub = median(avd(:));
    c = (avd-gsub)/(1-gsub);
    c = c(end:-1:2,1:end-1);
    s = size(avd);
    sampling = 1;
    [X,Y] = meshgrid(1:sampling:s(2)-1,1:sampling:s(1)-1);
    c = c(1:sampling:end, 1:sampling:end);
    mesh(X,Y,c);
    colorbar
    % Change view orientation
    az = 0;
    el = 90;
    view(az, el);

    % Fig 6 - Contrast values between a given range:
    subplot(2,2,2);
    hiVal = 0.075;
    hiW = 0.02;
    hi = (-hiW < (c-hiVal)) & ((c-hiVal) < hiW);
    imshow(flipud(double(hi)))
    title(strjoin([num2str(hiVal - hiW)," < Contrast < ",num2str(hiVal + hiW)]));

    % Fig 7 - Histogram of new contrast vals
    % figure
    subplot(2,2,3);
    histogram(c,256)
    xlabel('Contrast')
    ylabel('Pixels')
    title('Distribution of contrast values')

    if (mod(index,5) == 0)
        pause
    end
end
