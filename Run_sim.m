% clear 
% clc

%% Run sim
A = load('A.mat').A_bar;
B = load('B.mat').B_bar;
C = load('C.mat').C_obsv;

[n_states, n_int] = size(B);
n_meas   = size(C,1);    % number of measurements

Cc = ones(1,n_states);           % critical measurement


x0 = rand(n_states,1);
x_hat0 = x0;

%% controller
Pc = [-1 -2.5 -4 -2 -1.3 -2.5 -3 -5 -1.5 -2.4];
K = place(A,B,Pc);
disp('controller poles');
eig(A-B*K)

%% observer
Po = 2*Pc;
L = place(A.',C.',Po).';
disp('observer poles')
eig(A-L*C)

%% Noise
noise_seed = 23341;

%% Attack parameters
%  Attack is modeled as a scalar deviation from actual measured value
%    - start_times: The time spot to begin attack injection
%    - full_times : The times for attack to reach full steam
%    - final_deviations: The final deviation from the actual signal

attack_start_injection = 2;  % Global attack injection start time
detection_start = 1;         % bad data detection start time

% Initializing attacks (zeros)
attack_start_times      = attack_start_injection*ones(n_meas,1); 
attack_full_times       = attack_start_times + 10;
attack_final_deviations = zeros(n_meas,1);

% attack location
n_attacked_nodes = round(1.0*n_meas); % number of attacked nodes
try % make sure the attack support not change during a training process
    attack_indices = load('attack_support.mat').attack_indices;
catch
    attack_indices = sort(randperm(n_meas,n_attacked_nodes));  % inidices of nodes to attack;
    save attack_support.mat attack_indices
end


%% Simulation parameters
t_sim_stop = 10;  % total simulation time per incidence

% attack policy parameters
attack_start_time_interval  = round([0.1 0.2]*t_sim_stop);
attack_time_span_max_rate   = 0.3;
attack_max = 50;
policy_param = {attack_start_time_interval, attack_time_span_max_rate, attack_max, t_sim_stop};

% getting nominal values
model = 'sample_system';
noise_trigger = 0;
out = sim(model);

r_nominal  = out.residual;
yc_nominal = out.critical_measurement;


% load_system(model);
% 
% % build rapid accelerator target
% Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);
% 
% % setting model check to 'off'
% sim_inp = Simulink.SimulationInput(model);
% sim_inp = sim_inp.setModelParameter('SimulationMode','rapid-accelerator');
% sim_inp = sim_inp.setModelParameter('RapidAcceleratorUpToDateCheck','off');
% 
% sim_inp = sim_inp.setVariable('A',A);
% sim_inp = sim_inp.setVariable('B',B);
% sim_inp = sim_inp.setVariable('C',C);
% sim_inp = sim_inp.setVariable('Cc',Cc);
% sim_inp = sim_inp.setVariable('x0',x0);
% sim_inp = sim_inp.setVariable('x_hat0',x_hat0);
% sim_inp = sim_inp.setVariable('K',K);
% sim_inp = sim_inp.setVariable('L',L);
% 
% 
% sim_inp = sim_inp.setVariable('t_sim_stop',t_sim_stop);
% 
% sim_inp = sim_inp.setVariable('detection_start',detection_start);
% sim_inp = sim_inp.setVariable('attack_start_times',attack_start_times);
% sim_inp = sim_inp.setVariable('attack_full_times',attack_full_times);
% sim_inp = sim_inp.setVariable('attack_final_deviations',attack_final_deviations);
% 
% sim_out = parsim(sim_inp);
% figure, plot(sim_out.critical_measurement.Time,sim_out.critical_measurement.Data)

