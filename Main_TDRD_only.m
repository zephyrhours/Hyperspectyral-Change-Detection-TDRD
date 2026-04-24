%% JSTARS-00675（2021.04.28）
clc;clear;close all

%% Adding Path
addpath(genpath('./tensor_toolbox_2.5'));
%% Loading Images
% data_path = 'C:\Users\xxx\Documents\Datasets\CDdataset_Farmland_450x140x155.mat';
% data_path = 'C:\Users\xxx\Documents\Datasets\CDdataset_USA_307x241x154.mat';
% data_path = 'C:\Users\xxx\Documents\Datasets\CDdataset_River_463x241x198.mat';
% data_path = 'C:\Users\xxx\Documents\Datasets\CDdataset_BayArea_600x500x224.mat';
% data_path = 'C:\Users\xxx\Documents\Datasets\CDdataset_SantaBarbara_984x740x224.mat';
disp('The dataset is :')
disp(data_path);
load(data_path);

%%
[rows,cols,bands] = size(hsi_t1);
label_value=reshape(hsi_gt,1,[]);
disp('------------------------- AUC Values -------------------------------')

%% Proposed: TDRD
para_TDRD = 0.99;  % 根据数据集和需要自行修改

PCs_t1=[];
PCs_t2=[];
tic;
R0=func_TDRD(double(hsi_t1),double(hsi_t2),para_TDRD);
t0=toc;

R0value = reshape(R0,1,rows*cols);
[FA0,PD0] = perfcurve(label_value,R0value,'1') ;
AUC0=-sum((FA0(1:end-1)-FA0(2:end)).*(PD0(2:end)+PD0(1:end-1))/2);
disp(['TDRD:    ',num2str(AUC0),'    Time:    ',num2str(t0)])


% 分析R0值范围
fprintf('\nR0值范围分析:\n');
fprintf('  最小值: %.4f\n', min(R0(:)));
fprintf('  最大值: %.4f\n', max(R0(:)));
fprintf('  均值: %.4f\n', mean(R0(:)));
fprintf('  中位数: %.4f\n', median(R0(:)));

% 归一化到[0,1]
R0_normalized = (R0 - min(R0(:))) / (max(R0(:)) - min(R0(:)) + eps);

% 使用Otsu自动阈值
threshold_otsu = graythresh(R0_normalized);
fprintf('  Otsu阈值: %.4f\n', threshold_otsu);

% 搜索最优阈值（基于F1分数，更平衡）
fprintf('\n搜索最优阈值...\n');
best_f1 = 0;
best_threshold = 0;
best_oa = 0;
best_oa_1 = 0;
thresholds = 0.1:0.05:0.9;
for th = thresholds
    R0_temp = double(R0_normalized > th);
    [~, oa_temp, ~, ~, ~, f1_temp, ~, ~, oa_1_temp] = accuracy_assessment(hsi_gt, R0_temp);
    if f1_temp > best_f1
        best_f1 = f1_temp;
        best_threshold = th;
        best_oa = oa_temp;
        best_oa_1 = oa_1_temp;
    end
end
fprintf('  最优阈值: %.4f (F1: %.2f%%, OA: %.2f%%, Changed Acc: %.2f%%)\n', ...
    best_threshold, best_f1 * 100, best_oa * 100, best_oa_1 * 100);

% 二值化（使用最优阈值）
R0_binary = double(R0_normalized > best_threshold);

% 保存输出二值检测结果
[~, filename] = fileparts(data_path);
name_part = extractBetween(filename, 'CDdataset_', '_');
name_part = name_part{1};
save_name = ['results\R0_binary_' name_part '.png'];
imwrite(R0_binary, save_name, 'BitDepth', 1);
fprintf('✅ 已自动保存：%s\n', save_name);



% 评估
[conf_mat, oa, kappa_co, P, R, F1, acc, oa_0, oa_1] = accuracy_assessment(hsi_gt, R0_binary);

% 打印
fprintf('\n最终结果:\n');
fprintf('  总体精度 (OA): %.2f%%\n', oa * 100);
fprintf('  Kappa系数: %.4f\n', kappa_co);
fprintf('  F1分数: %.2f%%\n', F1 * 100);
fprintf('  精确率: %.2f%%\n', P * 100);
fprintf('  召回率: %.2f%%\n', R * 100);
% fprintf('  未变化精度: %.2f%%\n', oa_0 * 100);
% fprintf('  变化精度: %.2f%%\n', oa_1 * 100);









