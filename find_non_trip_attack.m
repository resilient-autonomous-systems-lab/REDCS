%% Find non-trip attack

clc
clear
close all

detector_train_flag = 0;
attack_percentage = 1;
Run_sim;

%% get a generated attack
load('attack_support.mat');
load('test_result.mat');

num_samples = size(Z_attack_data,2);
min_q1 = zeros(num_samples,1);
min_q4 = zeros(num_samples,1);

for ii =1:num_samples
    z_attack_data = Z_attack_data(:,ii);
    attack_data = ramp_attack_policy(policy_param,z_attack_data);

    % define attack parameters in simulation
    attack_start_times      = attack_start_injection*ones(n_meas,1);
    attack_full_times       = attack_start_times +  100;
    attack_final_deviations = zeros(n_meas,1);
    
    attack_start_times(attack_indices)      = attack_data(1:n_attacked_nodes);
    attack_full_times(attack_indices)       = attack_start_times(attack_indices) + attack_data(n_attacked_nodes+1:2*n_attacked_nodes);
    attack_final_deviations(attack_indices) = attack_data(2*n_attacked_nodes+1:3*n_attacked_nodes);
    
    %% run simulation
    out = sim("sample_system.slx");
    
    y = out.measurements;
    ya = out.attacked_measurements;
    ya_time = ya.Time;
    ya_data = reshape(ya.Data,size(ya.Data,1),size(ya.Data,3)).';

    %% identify if the system trip
    q1 = y.Data(:,1);
    q2 = y.Data(:,2);
    q3 = y.Data(:,3);
    q4 = y.Data(:,4);

    min_q1(ii) = min(q1(y.Time>detection_start));
    min_q4(ii) = min(q4(y.Time>detection_start));
end

figure
plot(min_q1,'k.')
title("minimal q_1")

figure
plot(min_q4,'k.')
title("minimal q_4")

