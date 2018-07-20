clc;clear;close all;

ramanpath='/home/matt/Google Drive Mattheuu/Physics/Honours Project/03 Labwork/03 Raman/';

ramanfiles = dir([ramanpath '2018-07-12/Batch04/*.txt']);
for i = 1:length(ramanfiles)
%     A = importdata([ramanpath '2018-07-12/Batch04/' file.name]); 
    file = ramanfiles(i);
    myname = file.name;
    fprintf('Do nothing with %s\n', myname);
%     fprintf('Do something with %s\n', file.name);
end