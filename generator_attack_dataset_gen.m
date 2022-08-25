function [Z_attack_data,distance_index] = generator_attack_dataset_gen(gen_net,generate_data_flag,inp_size,n_samples)


if generate_data_flag == true
    %%% Attack data
    Z_train        = 100*(0.5 - rand(inp_size,n_samples,"single"));   % uniformly random noise as input
    Z_train_dlarray = dlarray(Z_train,"CB");                     % covert to dlarray
    
    Z_attack_data = double(extractdata(forward(gen_net,Z_train_dlarray)));

    % run funtion
%     distance_index = sum(Z_attack_data.*Z_attack_data,1);
    distance_index = target_fcn(Z_attack_data);

    save('generator_attack_data','distance_index','Z_attack_data','-v7.3');

else
    local_var_gen = load('generator_attack_data.mat');
    Z_attack_data = local_var_gen.Z_attack_data;
    distance_index  = local_var_gen.distance_index;
end