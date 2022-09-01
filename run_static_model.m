 function [effect_index,stealth_index] = run_static_model(attack_data,sim_param)

H = sim_param{1,1};
x = sim_param{1,2};

ya = H*x + attack_data;
x_hat = pinv(H,0.01)*ya;

effect_index = vecnorm(x-x_hat,1);
stealth_index = vecnorm(ya-H*x_hat,1);
