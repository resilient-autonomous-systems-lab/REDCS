% clear 
% clc

%% load parameters
H = load('H.mat').H;
x = load('x.mat').x;

n_meas = size(H,1);

%% Attack parameters
attack_percentage = 0.5;

% attack location
n_attacked_nodes = round(attack_percentage*n_meas); % number of attacked nodes
attack_indices = randperm(n_meas,n_attacked_nodes);  % inidices of nodes to attack;
sim_param = {H,x,n_attacked_nodes, attack_indices};



