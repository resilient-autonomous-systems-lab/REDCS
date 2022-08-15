function attack_data = ramp_attack_policy(Z_attack_data,t_sim_stop)
%% function attack_data = attack_policy(Z_attack_data,t_sim_stop)
% ramp attack policy
% inputs:
%        t_sim_stop: total simulation time
%        Z_attack: [3*n_attacked_nodes,n_sim_samples] attack parameters (percenatages) for each attack node
%              Z_attack(1:n_attacked_nodes,:)                     : attack start time for each attack node
%              Z_attack(n_attacked_nodes+1:2*n_attacked_nodes,:)  : attack time spans for each attack node
%              Z_attack(2*n_attacked_nodes+1:3*n_attacked_nodes,:): attack final deviations for each attack node
% output:
%        attack_start_times
%

%% attack policy parameters
attack_start_time_interval       = round([0.1 0.2]*t_sim_stop);
delta_attack_start_time_interval = attack_start_time_interval(2) - attack_start_time_interval(1);
attack_time_span_max = round(0.3*t_sim_stop);
attack_max = 50;
n_attacked_nodes = round(size(Z_attack_data,1)/3);

%% generate attacks
% attack start times
attack_start_times = attack_start_time_interval(1) + ...
    delta_attack_start_time_interval*Z_attack_data(1:n_attacked_nodes,:);

% attack time spans
attack_time_span   = attack_time_span_max*Z_attack_data(n_attacked_nodes+1:2*n_attacked_nodes,:);

% attack final deviations
attack_final_deviations = attack_max*Z_attack_data(2*n_attacked_nodes+1:3*n_attacked_nodes,:);

attack_data = [attack_start_times;
               attack_time_span;
               attack_final_deviations];
