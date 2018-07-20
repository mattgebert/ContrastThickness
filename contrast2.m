clc;clear;close all;

% opticalpath='/home/matt/Google Drive Mattheuu/Physics/Honours Project/03 Labwork/01 Microscopy/';
opticalpath='C:\Users\mgeb1\Google Drive\Physics\Honours Project\03 Labwork\01 Microscopy\';
imgfiles = dir([opticalpath 'Batch04 - Columbia/*/*.jpg']);
for index = 1:length(imgfiles)
    file = imgfiles(index);
    if contains(file.name, '100x')
        img = imread([file.folder '\' file.name]);

        img = im2double(img);
        r = img(:,:,1);
        g = img(:,:,2);
        b = img(:,:,3);

        % Fig 2 - Plot of contrast vs substrate
        gsub = median(g(:));
        c = (gsub-g)/gsub;
        c = c(end:-1:2,1:end-1);
        s = size(g);
        sampling = 5;
        [X,Y] = meshgrid(1:sampling:s(2)-1,1:sampling:s(1)-1);
        c = c(1:sampling:end, 1:sampling:end);

        fig = figure('Name',['Contrast Image ' file.name],'units','normalized','outerposition',[0 0 0.8 0.8]); % 'pos',[10,10,480*2,480*2]
        subplot(2,2,1)
        imshow(img)

        subplot(2,2,3)
        mesh(X,Y,c);
        view([-37.5 30])
        colorbar

        subplot(2,2,4)
        mesh(X,Y,c);
        view([53 30])
        colorbar

        subplot(2,2,2)
        mesh(X,Y,c);
        view([0 90])
        colorbar

        folderstruct = split(split(file.folder,'/'),'\');
        foldername = folderstruct(end);
        mkdir(['Output/Contrast/' foldername{1}]);
        outputname = ['Output/Contrast/' foldername{1} '/' file.name];
        saveas(fig, replace(outputname, '.jpg', '_constrast.jpg'));
        close(fig);
    end
end