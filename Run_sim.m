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



%% load nominal data
% load nominal_residual.mat      % r_nominal
% load nominal_critital_meas.mat % yc_nominal
% load nominal_meas.mat          % y_nominal   
% load nominal_state_sys.mat     % x_nominal
% load nominal_estimate.mat      % xhat_nominal

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
n_attacked_nodes = round(.5*n_meas); % number of attacked nodes
attack_indices = randperm(n_meas,n_attacked_nodes);  % inidices of nodes to attack;

% % Sample attack runs (random) : FOR TESTING PURPOSES. COMMENT OUT IF NOT NEEDED
% attack_indices_complement = setdiff((1:n_meas),attack_indices).';
% I = eye(n_meas);
% E_perp = I(:,attack_indices_complement);
% N      = null(E_perp.'*C);
% x_a    = 2*randn(size(N,2),1);
% y_a    = C*N*x_a;
%  
% attack_start_times(attack_indices) = attack_start_injection + 5*rand(length(attack_indices),1);
% attack_full_times(attack_indices)   = attack_start_times(attack_indices) + .1*rand(length(attack_indices),1);
% attack_final_deviations(attack_indices) = y_a(attack_indices); %10*(rand(length(attack_indices),1) - 0.5);


%% Simulation parameters
t_sim_stop = 10;  % total simulation time per incidence

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

