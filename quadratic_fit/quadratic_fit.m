function [weights] = quadratic_fit(Z_input,Z_output)
%%
% Inputs:
%        Z_input: [2-by-n_samples]
%        Z_output: [1-by-n_samples]

% weights = sum(kernel_fcn(Z_input.').',1)\sum(Z_output,1);
h = kernel_fcn(Z_input.');
weights = (h*h.')\h*Z_output;
weights = dlarray(weights,"CB");