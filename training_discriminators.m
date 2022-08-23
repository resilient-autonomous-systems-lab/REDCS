function [effect_net_trained,stealth_net_trained,effect_training_info,stealth_training_info] = training_discriminators(effect_net,stealth_net,Z_attack_data,effect_index,stealth_index, maxEpochs)
%% function [effect_net_trained,stealth_net_trained,effect_training_info,stealth_training_info] = training_discriminators(effect_net,stealth_net,Z_attack_data,effect_index,stealth_index, maxEpochs)
% train the two discriminator network (regression network) to learn the relationship from attack signal to effectiveness and stealthiness respectively
% Inputs:
%        - effect_net: the dl object
%        - stealth_net: the dl object
%        - Z_attack_data: [3-by-n_samples] training inputs (attack parameters)
%        - effect_index : [1-by-n_samples] training output (effectiveness)
%        - stealth_index: [1-by-n_samples] training output (stealthiness)
%        - maxEpochs: maximum epoch number
% Outputs:
%        - effect_net_trained: updated dl object 
%        - stealth_net_trained: updated dl object
%        - effect_training_info: reference: https://www.mathworks.com/help/deeplearning/ref/trainnetwork.html#bu6sn4c-traininfo
%        - stealth_training_info: same as above
% Author: Olugbenga Moses Anubi, Florida state university
%         Yu Zheng, Florida state university
% 08/18/2022
%

%% training parameters 
mini_batch_size = 5000;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',mini_batch_size, ...
    'GradientThreshold',1, ...
    'Verbose',false, ...
    'Plots','none');

%% training
effect_net_layers = [effect_net.Layers;regressionLayer];
[effect_series_net, effect_training_info]   = trainNetwork(Z_attack_data.',effect_index,effect_net_layers,options);
effect_lgraph = layerGraph(effect_series_net);
effect_lgraph = removeLayers(effect_lgraph,'regressionoutput');
effect_net_trained = dlnetwork(effect_lgraph);

stealth_net_layers = [stealth_net.Layers;regressionLayer];
[stealth_series_net, stealth_training_info] = trainNetwork(Z_attack_data.',stealth_index,stealth_net_layers,options);
stealth_lgraph = layerGraph(stealth_series_net);
stealth_lgraph = removeLayers(stealth_lgraph,'regressionoutput');
stealth_net_trained = dlnetwork(stealth_lgraph);
