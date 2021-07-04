function Res = func_Normalized(hsi,paras)
%FUNC_NORMALIZED normalized the 3D hyperspectral dataset
%   Res = func_Normalized(hsi,paras)
%   INPUTS:
%       hsi -> the input datasets with the size of rows x cols x bands
%     paras -> different normalized type:
%            1: Min-max Normalization (range scaling)
%            2: Mean Normalization
%            3: Standarization Normalization (Z-score)
%            4: Scaling to Unit Length Normalization
%   OUTPUT:
%      Res -> the normalized result with the size of rows x cols x bands
%
% Author: Zephyr Hou
% Time: 2020-12-01
%
%All Rights Reserved.
%Contact Information: zephyrhours@gmail.com

%% Main function

if nargin==1
    warning('There is no parameter input.The output is equal to the input, please input the normalized type: 1,2,3,or 4 !')
    Res=hsi;
elseif paras~=fix(paras)
    error('MATLAB:func_Normalized:WrongNValue',...
        'The value of parameter can only be a strictly positive integer 1,2,3 or 4!')
elseif paras==1
    % 1: Min-max Normalization (range scaling)
    maxVal=max(hsi(:));
    minVal=min(hsi(:));
    Res=(hsi-minVal)/(maxVal-minVal);
    disp('Min-max Normalization (range scaling)')
elseif paras==2
    % 2: Mean Normalization
    meanVal=mean(hsi(:));
    maxVal=max(hsi(:));
    minVal=min(hsi(:));
    Res=(hsi-meanVal)/(maxVal-minVal);
    disp('Mean Normalization')
elseif paras==3
    % 3. Standarization Normalization (Z-score)
    meanVal=mean(hsi(:));
    stdVal=std(hsi(:));
    Res=(hsi-meanVal)/stdVal;
    disp('Standarization Normalization (Z-score)')
elseif paras==4
    % 4. Scaling to Unit Length Normalization
    [rows,cols,bands]=size(hsi);
    Rhsi=reshape(hsi,rows*cols,bands)';
    Nhsi=[];
    for i =1:rows*cols
        Nhsi(:,i)=Rhsi(:,i)/norm(Rhsi(:,i));
    end
    Res=reshape(Nhsi',rows,cols,bands);
    disp('Scaling to Unit Length Normalization')
else
    warning('Please input the normalized type: 1,2,3,or 4 !')
end
      
end


