function [Z_attack_data,distance_index] = random_attack_dataset_gen(inp_size,n_samples)


try
    local_var_rand = load('random_data.mat');
    Z_attack_data = local_var_rand.Z_attack_data;
    distance_index  = local_var_rand.distance_index;
catch
    %% random input data
    Z_attack_data    = rand(inp_size,n_samples);
    

    %% getting simulation object
    distance_index = sum(Z_attack_data.*Z_attack_data,1);

    save('random_attack_data','distance_index','Z_attack_data','-v7.3');
end
end