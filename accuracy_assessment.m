function [conf_mat, oa, kappa_co, P, R, F1, acc, oa_0, oa_1] = accuracy_assessment(img_gt, changed_map)
% 变化检测标准评估：0=未变化，1=变化
esp = 1e-6;

% 展平 + 统一转为双精度
gt = double(img_gt(:));
pred = double(changed_map(:));

% 只保留有效标签 0 和 1
mask = (gt == 0) | (gt == 1);
gt = gt(mask);
pred = pred(mask);

% 手动计算 2x2 混淆矩阵（标准定义）
% GT=0表示未变化，GT=1表示变化
TN = sum((gt == 0) & (pred == 0));  % True Negative: 正确预测未变化
FP = sum((gt == 0) & (pred == 1));  % False Positive: 误报（未变化被预测为变化）
FN = sum((gt == 1) & (pred == 0));  % False Negative: 漏报（变化被预测为未变化）
TP = sum((gt == 1) & (pred == 1));  % True Positive: 正确预测变化

conf_mat = [TN, FP; FN, TP];

% Kappa 系数
total = TN + TP + FN + FP;
po = (TN + TP) / (total + esp);
pe = ((TN+FN)*(TN+FP) + (FP+TP)*(FN+TP)) / (total^2 + esp);
kappa_co = (po - pe) / (1 - pe + esp);

% 评估指标
P   = TP / (TP + FP + esp);       % 精确率
R   = TP / (TP + FN + esp);       % 召回率
F1  = 2 * P * R / (P + R + esp);  % F1
acc = (TP + TN) / (total + esp);  % 准确率
oa  = acc;                        % 总体精度 OA

oa_0 = TN / (TN + FP + esp);      % 未变化类精度 (TN / GT中未变化的像素数)
oa_1 = TP / (TP + FN + esp);      % 变化类精度 (TP / GT中变化的像素数) = 召回率
end