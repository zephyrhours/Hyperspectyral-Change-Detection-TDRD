%% Demo for TDRD method
% Reference: 
%       1. Three-Order Tucker Decomposition and Reconstruction Detector for
%          Unsupervised Hyperspectral Change Detection>
% Author: Zephyr Hou
% Time: 2021.07.04
clc;clear;close all
%% Adding Path
addpath(genpath('./datasets'));
addpath(genpath('./tensor_toolbox_2.5'));
%% Loading Images
[imgname,pathname]=uigetfile('*.*', 'Select the  *.mat dataset','.\datasets');
str=strcat(pathname,imgname);
disp('The dataset is :')
disp(str);
addpath(pathname);
load(strcat(pathname,imgname));

%% Parameters Setting
para_TDRD = 0.990;

%%
[rows,cols,bands] = size(hsi_t1);
label_value=reshape(hsi_gt,1,[]);
disp('------------------------- AUC Values -------------------------------')
PCs_t1=[];
PCs_t2=[];
tic;
R0=func_TDRD(hsi_t1,hsi_t2,para_TDRD);
t0=toc;

R0value = reshape(R0,1,rows*cols);
[FA0,PD0] = perfcurve(label_value,R0value,'1') ;
AUC0=-sum((FA0(1:end-1)-FA0(2:end)).*(PD0(2:end)+PD0(1:end-1))/2);
disp(['TDRD:    ',num2str(AUC0),'    Time:    ',num2str(t0)])

%% Plot ROC curves
figure;
plot(FA0, PD0, 'k');  hold on
% axis([0.6e-4,1,0,1])
xlabel('False alarm rate'); ylabel('Probability of detection');
legend('TDRD','location','southeast')






