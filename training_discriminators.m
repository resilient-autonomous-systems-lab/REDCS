function [effect_net_trained,stealth_net_trained,effect_training_info,stealth_training_info] = training_discriminators(effect_net,stealth_net,Z_attack_data,effect_index,stealth_index)
% training parameters 
maxEpochs = 500;
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
