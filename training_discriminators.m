function [effect_net_trained,stealth_net_trained] = training_discriminators(n_attacked_nodes,Z_attack_data,effect_index,stealth_index,loss_curve_param_dis1,loss_curve_param_dis2,i_epoch)
%% function [effect_net_trained,stealth_net_trained,effect_training_info,stealth_training_info] = training_discriminators(effect_net,stealth_net,Z_attack_data,effect_index,stealth_index, maxEpochs)
% train the two discriminator network (regression network) to learn the relationship from attack signal to effectiveness and stealthiness respectively
% Inputs:
%        - n_attacked_nodes: [scalar] number of aattacked nodes
%        - Z_attack_data: [3-by-n_samples] training inputs (attack parameters)
%        - effect_index : [1-by-n_samples] training output (effectiveness)
%        - stealth_index: [1-by-n_samples] training output (stealthiness)
% Outputs:
%        - effect_net_trained: updated dl object 
%        - stealth_net_trained: updated dl object
% Author: Yu Zheng, Florida state university
%
% 08/18/2022
%

%% parameters
inp_size_dis = n_attacked_nodes;

%% effect network
activation_fcns_effect = ["relu","relu","relu","linear"];
n_neurons_effect = [50*inp_size_dis,100*inp_size_dis,50*inp_size_dis,1];
effect_net = create_dl_network(inp_size_dis,activation_fcns_effect,n_neurons_effect); % Effectiveness network

dataset_effect_net = {Z_attack_data,effect_index};
effect_net_trained = train_regression_network(effect_net,dataset_effect_net,loss_curve_param_dis1,i_epoch,"effect network ,");


%% stealth network
activation_fcns_stealth = ["relu","relu","relu","linear"];
n_neurons_stealth = [50*inp_size_dis,100*inp_size_dis,50*inp_size_dis,1];
stealth_net = create_dl_network(inp_size_dis,activation_fcns_stealth,n_neurons_stealth);  % Stealthiness network

dataset_stealth_net = {Z_attack_data,stealth_index};
stealth_net_trained = train_regression_network(stealth_net,dataset_stealth_net,loss_curve_param_dis2,i_epoch,"stealth network ,");


