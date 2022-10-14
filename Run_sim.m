% clear 
% clc
% 
% attack_percentage = 1.0;

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

%% transmission line
% use simulink signal builder the stochastic pressure inputs
d_inj = 0.15; % Injector diameter, m
A = (pi/4)*(d_inj*.0254)^2; % Injector cross sectional area; m3
Cd = 0.001;  
% rho = 0.68;

%% controller
Kp = 50;
Ki = 20;
Kd = 20;

%% supervised controller
q_ref = 10;  % reference pipline mass flow rate
eta = 0.1; % maximum deviation from reference pipline mass flow rate


%% Noise
noise_seed = 23341;

%% This file is resued for detector training and normal simulation
detector_net = load("Detector.mat").detector_net;


%% Attack parameters
%  Attack is modeled as a scalar deviation from actual measured value
%    - start_times: The time spot to begin attack injection
%    - full_times : The times for attack to reach full steam
%    - final_deviations: The final deviation from the actual signal

attack_start_injection = 120;  % Global attack injection start time
detection_start = 100;         % bad data detection start time

% Initializing attacks (zeros)
n_meas = 4;
attack_start_times      = attack_start_injection*ones(n_meas,1); 
attack_full_times       = attack_start_times + 100;
attack_final_deviations = zeros(n_meas,1);

% attack location
% attack_percentage = 1.0;
n_attacked_nodes = round(attack_percentage*n_meas); % number of attacked nodes
try % make sure the attack support not change during a training process
    attack_indices = load('attack_support.mat').attack_indices;
catch
    attack_indices = sort(randperm(n_meas,n_attacked_nodes));  % inidices of nodes to attack;
    save attack_support.mat attack_indices
end

% attack policy parameters
attack_start_time_interval  = round([0.12 0.22]*t_sim_stop);
attack_time_span_max_rate   = 0.5;
attack_max = 50;
policy_param = {attack_start_time_interval, attack_time_span_max_rate, attack_max, t_sim_stop};

% getting nominal values
model = "sample_system";
noise_trigger = 0;
out = sim(model);


yc_nominal = out.critical_measurement;
ya_nominal = out.attacked_measurements; 
y_nominal = out.measurements;

y_dlarray = dlarray(y_nominal.Data,"BC");
r_nominal  = double(extractdata(predict(detector_net,y_dlarray)));
r_nominal = timeseries(r_nominal.',y_nominal.Time);


