function [yc_error, r_error] = run_model(sim_inp,attack_data,n_meas,attack_indices, r_nominal, yc_nominal)

batch_size       = length(sim_inp);
n_attacked_nodes = length(attack_indices);

%% Run simulation in parralel 
for iter = 1:batch_size
    attack_start_times      = 2*ones(n_meas,1);
    attack_full_times       = attack_start_times +  10;
    attack_final_deviations = zeros(n_meas,1);

    attack_start_times(attack_indices)      = attack_data(1:n_attacked_nodes,iter);
    attack_full_times(attack_indices)       = attack_start_times(attack_indices) + attack_data(n_attacked_nodes+1:2*n_attacked_nodes,iter);
    attack_final_deviations(attack_indices) = attack_data(2*n_attacked_nodes+1:3*n_attacked_nodes,iter);

    sim_inp(iter) = sim_inp(iter).setVariable('attack_start_times',attack_start_times);
    sim_inp(iter) = sim_inp(iter).setVariable('attack_full_times',attack_full_times);
    sim_inp(iter) = sim_inp(iter).setVariable('attack_final_deviations',attack_final_deviations);
end

sim_out = parsim(sim_inp);

%% calculate effectiveness and stealthiness
[yc_error, r_error] = get_error_from_nominal(sim_out,yc_nominal,r_nominal);