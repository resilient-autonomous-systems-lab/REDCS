function [attack_data,effect_index,stealth_index] = generator_attack_dataset_gen(gen_net,generate_data_flag,inp_size,n_sim_samples,sim_param)
%% function [sim_obj,Z_attack_data,effect_index,stealth_index] = generator_attack_dataset_gen(gen_net,i_epoch,generate_data_flag,inp_size,n_sim_samples,t_sim_stop)
% Description
%
%% load param
H = sim_param{1,1};
attack_indices = sim_param{1,4};

if generate_data_flag == true
    %%% Attack data
    Z_train        = 100*(0.5 - rand(inp_size,n_sim_samples,"single"));   % uniformly random noise as input
    Z_train_dlarray = dlarray(Z_train,"CB");                     % covert to dlarray
    
    attack_data = zeros(size(H,1),n_sim_samples);
    attack_data(attack_indices,:) = double(extractdata(forward(gen_net,Z_train_dlarray)));

    % getting simulation object
    [effect_index,stealth_index]  = run_static_model(attack_data,sim_param);
    save('generator_attack_data','effect_index','stealth_index','attack_data','-v7.3');

else
    local_var_gen = load('generator_attack_data.mat');
    attack_data = local_var_gen.Z_attack_data;
    effect_index  = local_var_gen.effect_index;
    stealth_index = local_var_gen.stealth_index;
end