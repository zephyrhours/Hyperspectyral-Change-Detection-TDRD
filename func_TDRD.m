function Result = func_TDRD(hsi_t1,hsi_t2,rate)
%FUNC_TDRD Tensor Decomposition and Reconstruction Detector(TDRD)
%   Result = func_TDRD(hsi_t1,hsi_t2,rate)
%   INPUTS:
%       hsi_t1 -> the hyperspectral dataset at T1 time, which size is rows x cols x bands
%       hsi_t2 -> the hyperspectral dataset at T2 time, which size is rows x cols x bands
%         rate -> the rate (\eta)
%   OUTPUT:
%       Result -> the result with the size of rows x cols
%
% Reference:
%      1. Multiscale morphological compressed change vector analysis for 
%      unsupervised multiple change detection
%     
% Author: Zephyr Hou
% Time: 2021-04-28
%
%All Rights Reserved.
%Contact Information: zephyrhours@gmail.com

%% Main Function
PCs_t1=[];
PCs_t2=[];
for mode = 1:3   % 展开模式
    % hsi_t1
    rehsi_t1 = func_unfold(hsi_t1,mode);
    Val_t1=svd(rehsi_t1);
    Sumva1 = rate * sum(Val_t1); 
    T0=cumsum(Val_t1);            % cumsum为累加函数，向下累加
    ki=find(T0>=Sumva1);   
    PCs_t1(1,mode)=ki(1);   
   % hsi_t2
    rehsi_t2 = func_unfold(hsi_t2,mode);
    Val_t2=svd(rehsi_t2);
    Sumva1 = rate * sum(Val_t2); 
    T0=cumsum(Val_t2);            % cumsum为累加函数，向下累加
    ki=find(T0>=Sumva1);   
    PCs_t2(1,mode)=ki(1);  
end 

disp(['PCs_t1:',num2str(PCs_t1)])
disp(['PCs_t2:',num2str(PCs_t2)])

hsi_t1_new = func_tucker(hsi_t1,PCs_t1,1);
hsi_t2_new = func_tucker(hsi_t2,PCs_t2,1);

Result = func_RLAD(hsi_t1_new,hsi_t2_new);







end

