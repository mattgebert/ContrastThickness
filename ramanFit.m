clc;clear;close all;
% ------------------Signatures:--------------------------
% We're looking for 2D peak that is 4x amplitude of G peak.
% 


% ----------------- IMPORT DATA-------------------------
% Assumes that col 1 is freq shifts, and col 2 is amplitude
delimeter = '\t';
% A = importdata('GraphenePicture/T2_2 graphene/488nm Silicon T2_2.txt',delimeter);
% img = imread('GraphenePicture/T2_Wafer08_Flake02_100x.jpg'); img = img(1100:1500,2000:2700,:);

% ramanpath='/home/matt/Google Drive Mattheuu/Physics/Honours Project/03 Labwork/03 Raman/'; %Linux
ramanpath='C:\Users\mgeb1\Google Drive\Physics\Honours Project/03 Labwork/03 Raman/'; %Windows

% filepath = [ramanpath '2018-03-29/488 nm laser/T2_1/488nm Silicon T2_11.txt'];
% imgpath = [ramanpath '2018-03-29/488 nm laser/T2_1/T2_01.bmp'];
% img = imread(imgpath);% img = img(1100:1500,2000:2700,:);

filepath = [ramanpath '2018-03-29/488 nm laser/T2_1/488nm Silicon T2_11.txt'];
imgpath = [ramanpath '2018-03-29/488 nm laser/T2_1/T2_01.bmp'];
img = imread(imgpath);% img = img(1100:1500,2000:2700,:);



A = importdata(filepath,delimeter);

% Pack data into x and y
rShift = A(:,1);
rAmp = A(:,2);

% Isolate data for G peak
gi = find(rShift > 1600 & rShift < 1700);
gShift = rShift(gi);
gAmp = rAmp(gi);
gg0 = [1650 20 100 100];

% Isolate data for 2D peak
% Assuming between range 2600 to 2800 cm^-1
d2i = find(rShift > 2600 & rShift < 2800);
d2Shift = rShift(d2i);
d2Amp = rAmp(d2i);
d2g0 = [2700 20 2000 100]; % initial parameters: shift, width and amplitude, yoffset

% Isolate data for D peak - NOT USED DUE TO LOWER RESOLUTION.
% Assuming range between
di = find(rShift > 1300 & rShift < 1400);
dShift = rShift(di);
dAmp = rAmp(di);
dg0 = [1350 20 100 100]; % initial parameters: shift, width and amplitude, yoffset

% ---------------- FITTING -----------------------------------
% Select:
shift = d2Shift;
amp = d2Amp;
g0 = d2g0(1:3);
y0 = d2g0(4);

% Runs fits for 1,2 & 4 Lorenzians
f1 = @(param,xdata) param(1,3) ./ (1 + ((param(1,1) - xdata)./ param(1,2)).^2) + param(2,1); %Anonymous function
% 
g1 = [g0; y0 0 0];
[f1, p1, r1] = lorentzFitN(shift,amp,1,g1,false);
g2 = [g0; g0; y0 0 0];
[f2, p2, r2] = lorentzFitN(shift,amp,2,g2,false);
g4 = [g0; g0; g0; g0; y0 0 0];
[f4, p4, r4] = lorentzFitN(shift,amp,4,g4,false);
    
% Group together results for plotting
f = {f1,f2,f4};p = {p1,p2,p4};r = [r1,r2,r4];
% Plot fits
figure('Name','Lorentzian Fits','units','normalized','outerposition',[0 0 1 1]) % 'pos',[10,10,480*2,480*2]
for i = 1:3
    subplot(3,2,i)
    hold on
    plot(shift, amp,'.b')
    p_i = p{i};
    s = size(p_i);
    for j = 1:(s(1)-1)
        params = [p_i(j,:); p_i(end,:)];
        plot(shift, f1(params,shift), '-g')
    end
    plot(shift, f{i}(p_i,shift), '-r')
    
    %integrate to get residual error percentage
    fitFunc = @(s) f{i}(p_i,s); %Apply fit params to function
%     residPercent = 1.0*r(i)/integral(fitFunc, shift(1), shift(end)); 
    residPercent = r(i) * 100.0 / sum(abs(fitFunc(shift))); 
%     TODO GET THIS BIT WORKING ON RESIDUAL % Later...
    
    hold off
    xlabel('Raman Shift Cm^{-1}')
    ylabel('Amplitude (AU)')
    title(['Fitting ' int2str(s(1)-1) ' Lorentzian(s) - Residuals:', num2str(r(i),'%10.2e')])%, '   Percent:',num2str(residPercent,'%10.2e'),'%'])
    legend(['Data',string(1:(s(1)-1)),'Fit'])
end
% Plot Residuals
% subplot(2,2,3)
% plot([2,4],r)
% xlabel('Lorenzians')
% ylabel('Residual Error (AU)')
% title('Residual Error')

% Plot Image
subplot(3,2,[4,6]);
imshow(img);

% Plot Full Spectrum
subplot(3,2,[5])
plot(rShift,rAmp)
xlabel('Raman Shift (cm^{-1}')
ylabel('Intensity (AU)')
title('Raman Spectrum')
