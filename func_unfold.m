function result = func_unfold(hsi,mode)
%FUNC_UNFOLD  
% Mode-n unfold of Tensor hsi
% Author: Zephyr Hou
% Time: 2021-03-08
%%
dim = size(hsi);
result = reshape(shiftdim(hsi,mode-1), dim(mode), []);%
end

