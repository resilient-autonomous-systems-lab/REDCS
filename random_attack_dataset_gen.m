function [sim_obj,Z_attack_data,effect_index,stealth_index] = random_attack_dataset_gen(n_attacked_nodes,n_sim_samples,t_sim_stop)
%% function [sim_obj,Z_attack_data,effect_index,stealth_index] = random_attack_dataset_gen(generate_data_flag,n_attacked_nodes,n_sim_samples,t_sim_stop)
% generate random attack dataset for training discriminators
%
%

try
    local_var_rand = load('random_attack_data.mat');
    sim_obj       = local_var_rand.sim_obj;
    Z_attack_data = local_var_rand.Z_attack_data;
    effect_index  = local_var_rand.effect_index;
    stealth_index = local_var_rand.stealth_index;
catch
    %% Attack data
    Z_attack_data    = rand(3*n_attacked_nodes,n_sim_samples);
    attack_start_time_interval  = round([0.1 0.2]*t_sim_stop);
    attack_time_span_max_rate   = 0.3;
    attack_max = 50;
    policy_param = {attack_start_time_interval, attack_time_span_max_rate, attack_max};
    attack_data = ramp_attack_policy(policy_param,Z_attack_data,t_sim_stop);

    %% getting simulation object
    sim_obj = [];
    [sim_obj, effect_index,stealth_index]  = get_simulation_object_sample_system(sim_obj,attack_data);

    save('random_attack_data','sim_obj','effect_index','stealth_index','Z_attack_data','-v7.3');
end
end