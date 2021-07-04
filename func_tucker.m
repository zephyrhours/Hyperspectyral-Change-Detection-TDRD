function [hsi_new] = func_tucker(hsi,PC,paras)
%FUNC_TENSORREIMG_TUCKER Image reconstruction by tensor decomposition using tucker_als algorithm 
%   [hsi_new] = func_TensorReImg_tucker(hsi,PC,type)
%   INPUTS:
%          hsi -> the hyperspectral dataset, with size of rows x cols x bands
%           PC -> high Principal Component numbers[pc1,pc2,pc3]:
%        paras -> different normalized type:
%            1: Min-max Normalization (range scaling)
%            2: Mean Normalization
%            3: Standarization Normalization (Z-score)
%            4: Scaling to Unit Length Normalization
%   OUTPUT:
%   hsi_new -> the new result with the size of rows x cols x bands
%
% Author: Zephyr Hou
% Time: 2021-03-15
%
%All Rights Reserved.
%Contact Information: zephyrhours@gmail.com

%% Main Function
[H,W,Dim]=size(hsi);

% Tucker Decomposition
disp('Single tucker decomposition by tucker_als algorithm !')

% normalized initial datasets
hsi = func_Normalized(hsi,paras);

% hsi_t1 tensor transform
Ten_hsi=tensor(hsi);
[T,~,core,U]=tucker_als(Ten_hsi,[H,W,Dim]);

core_new=core(1:PC(1),1:PC(2),1:PC(3));
U_new{1}=U{1}(:,1:PC(1));
U_new{2}=U{2}(:,1:PC(2));
U_new{3}=U{3}(:,1:PC(3));
new_hsi = ttensor(core_new, U_new);

unfold_hsi = tenmat(new_hsi,3);
unfold_hsi = double(unfold_hsi);
hsi_new=reshape(unfold_hsi',H,W,Dim);
% normalized results
hsi_new = func_Normalized(hsi_new,paras);
end

