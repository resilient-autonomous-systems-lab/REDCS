function [sim_obj,Z_attack_data,effect_index,stealth_index] = random_attack_dataset_gen(generate_data_flag,n_attacked_nodes,n_sim_samples,t_sim_stop)

if generate_data_flag == true
    %% Attack data
    Z_attack_data    = rand(3*n_attacked_nodes,n_sim_samples);
    attack_data = ramp_attack_policy(Z_attack_data,t_sim_stop);

    %% getting simulation object
    sim_obj = [];
    [sim_obj, effect_index,stealth_index]  = get_simulation_object_sample_system(sim_obj,attack_data);

    save('random_attack_data','sim_obj','effect_index','stealth_index','Z_attack_data','-v7.3');

else
    local_var_rand = load('random_attack_data.mat');
    sim_obj       = local_var_rand.sim_obj_rand;
    Z_attack_data = local_var_rand.Z_attack_data_rand;
    effect_index  = local_var_rand.effect_index_rand;
    stealth_index = local_var_rand.stealth_index_rand;
end

end