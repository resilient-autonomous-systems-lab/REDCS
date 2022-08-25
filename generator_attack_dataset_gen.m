function [sim_obj,Z_attack_data,effect_index,stealth_index] = generator_attack_dataset_gen(gen_net,generate_data_flag,inp_size,n_sim_samples,t_sim_stop)
%% function [sim_obj,Z_attack_data,effect_index,stealth_index] = generator_attack_dataset_gen(gen_net,i_epoch,generate_data_flag,inp_size,n_sim_samples,t_sim_stop)
% Description
%

if generate_data_flag == true
    %%% Attack data
    Z_train        = 100*(0.5 - rand(inp_size,n_sim_samples,"single"));   % uniformly random noise as input
    Z_train_dlarray = dlarray(Z_train,"CB");                     % covert to dlarray
    
    Z_attack_data = double(extractdata(forward(gen_net,Z_train_dlarray)));

    attack_start_time_interval  = round([0.1 0.2]*t_sim_stop);
    attack_time_span_max_rate   = 0.3;
    attack_max = 50;
    policy_param = {attack_start_time_interval, attack_time_span_max_rate, attack_max};
    attack_data = ramp_attack_policy(policy_param,Z_attack_data,t_sim_stop);

    % getting simulation object
    sim_obj = [];
    [sim_obj, effect_index,stealth_index]  = get_simulation_object_sample_system(sim_obj,attack_data);

    save('generator_attack_data','sim_obj','effect_index','stealth_index','Z_attack_data','-v7.3');

else
    local_var_gen = load('generator_attack_data.mat');
    sim_obj       = local_var_gen.sim_obj;
    Z_attack_data = local_var_gen.Z_attack_data;
    effect_index  = local_var_gen.effect_index;
    stealth_index = local_var_gen.stealth_index;
end