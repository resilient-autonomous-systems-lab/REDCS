function [net_trained,training_info] = training_discriminators(inp_size,Z_attack_data,distance_index, maxEpochs)
%

%% training parameters 
%% Initialize Discriminators
activation_fcns_effect = ["relu","tanh","sigmoid"];
n_neurons_effect = [5*inp_size,5*inp_size,1];
net = create_dl_network(inp_size,activation_fcns_effect,n_neurons_effect); % discriminator network

mini_batch_size = 1000;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',mini_batch_size, ...
    'GradientThreshold',1, ...
    'Verbose',false, ...
    'Plots','none');

%% training
net_layers = [net.Layers;regressionLayer];
[series_net, training_info]   = trainNetwork(Z_attack_data.',distance_index,net_layers,options);
lgraph = layerGraph(series_net);
lgraph = removeLayers(lgraph,'regressionoutput');
net_trained = dlnetwork(lgraph);