clear 
clc

%% Simulation parameters
t_sim_stop = 1000;  % total simulation time per incidence

%% Compressors model
a = 1/47.7465;
b = a*(-0.0951);
c1 = (0.0951-(1/800))/(1.3223*10^6);
c2 = (-(1/20) -(1/800)*(1/0.5834)^2)/(1.3223*10^6);
c12 =((1/0.5834)^2)*(1/400)*(1/(1.3223*10^6));
c3 = 1;
d = 0.0146;
param = {a,b,c1,c2,c12,c3,d};

P_in = 101325;           % input pressure
P_middle = 1.68*P_in;    % transmission line pressure (given by supervised control)
P_out = 2*1.68*P_in;   % output pressure (given by supervised control)

x0 = [0;0];  

q_ref1 = 5;
q_ref2 = 10;

%% transmission line
% use simulink signal builder the stochastic pressure inputs
L = 0.1;  % delay term
A = 20;   % area of pipline cut

%% controller
Kp = 2;
Ki = 1.5;
Kd = 1;



%% Noise
noise_seed = 23341;

% %% Attack parameters
% %  Attack is modeled as a scalar deviation from actual measured value
% %    - start_times: The time spot to begin attack injection
% %    - full_times : The times for attack to reach full steam
% %    - final_deviations: The final deviation from the actual signal
% 
% attack_start_injection = 2;  % Global attack injection start time
% detection_start = 1;         % bad data detection start time
% 
% % Initializing attacks (zeros)
% attack_start_times      = attack_start_injection*ones(n_meas,1); 
% attack_full_times       = attack_start_times + 10;
% attack_final_deviations = zeros(n_meas,1);
% 
% % attack location
% n_attacked_nodes = round(1.0*n_meas); % number of attacked nodes
% try % make sure the attack support not change during a training process
%     attack_indices = load('attack_support.mat').attack_indices;
% catch
%     attack_indices = sort(randperm(n_meas,n_attacked_nodes));  % inidices of nodes to attack;
%     save attack_support.mat attack_indices
% end
% 
% 
% 
% % attack policy parameters
% attack_start_time_interval  = round([0.1 0.2]*t_sim_stop);
% attack_time_span_max_rate   = 0.3;
% attack_max = 50;
% policy_param = {attack_start_time_interval, attack_time_span_max_rate, attack_max, t_sim_stop};
% 
% getting nominal values
model = 'sample_system';
noise_trigger = 0;
% out = sim(model);
% 
% r_nominal  = out.residual;
% yc_nominal = out.critical_measurement;


