function out = kernel_fcn(x)
%%
% Inputs:
%        x: [2-by-n_samples]

out = [ones(1,size(x,2)); 
       x(1,:);
       x(2,:);
       x(1,:).^2;
       x(2,:).^2];