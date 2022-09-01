function [Z_attack_data,effect_index,stealth_index] = random_attack_dataset_gen(sim_param,n_sim_samples)
%% function [Z_attack_data,effect_index,stealth_index] = random_attack_dataset_gen(n_attacked_nodes,n_sim_samples,H,x)
% generate random attack dataset for training discriminators
%
%
%% load param
H = sim_param{1,1};
n_attacked_nodes = sim_param{1,3};
attack_indices = sim_param{1,4};

try
    local_var_rand = load('random_attack_data.mat');
    Z_attack_data    = local_var_rand.Z_attack_data;
    effect_index   = local_var_rand.effect_index;
    stealth_index  = local_var_rand.stealth_index;
catch
    %% Attack data
    Z_attack_data = rand(n_attacked_nodes,n_sim_samples);
    attack_data = zeros(size(H,1),n_sim_samples);
    attack_data(attack_indices,:) = Z_attack_data;

    %% getting simulation object
    [effect_index,stealth_index]  = run_static_model(attack_data,sim_param);

    save('random_attack_data','effect_index','stealth_index','Z_attack_data','-v7.3');
end
end