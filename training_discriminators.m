function [net,loss] = training_discriminators(inp_size,Z_dlarray,distance_index,n_samples,mini_batch_size,loss_curve_param)
%

%% Initialize Discriminators
layers = [featureInputLayer(inp_size,"Name","input")
          fullyConnectedLayer(50*inp_size,"Name","output")
          sigmoidLayer("Name","sigmoid")
          fullyConnectedLayer(1,"Name","output")];
net = dlnetwork(layers);

%% training parameters 
iteration       = 0;

% initialize Adam optimizer
learnRate = 0.0002;
gradientDecayFactor = 0.5;
squaredGradientDecayFactor = 0.999;

trailingAvg = [];
trailingAvgSq = [];

%% plot parameters
loss_fig_dis = loss_curve_param{1,1};
disLossTrain = loss_curve_param{1,2};
start = loss_curve_param{1,3};

%% training
% net_layers = [net.Layers;regressionLayer];
% [series_net, training_info]   = trainNetwork(Z_attack_data.',distance_index,net_layers,options);
% lgraph = layerGraph(series_net);
% lgraph = removeLayers(lgraph,'regressionoutput');
% net_trained = dlnetwork(lgraph);
for ind = 1:mini_batch_size:n_samples
    iteration = iteration+1;

    % Getting mini-batch input data
    idx = ind:min(ind+mini_batch_size-1,n_samples);
    Z_iter = Z_dlarray(:,idx);
    distance_index_iter = distance_index(idx,:);
    % calculate loss and gradients
    [gradients,net_state,loss] = dlfeval(@model_loss,net,Z_iter,distance_index_iter,mini_batch_size); % forward propogation, simulation, loss calculation, gradient calculation
    
    net.State = net_state;                    % update network state
    
    % Update the network parameters using the Adam optimizer.
    [net,trailingAvg,trailingAvgSq] = adamupdate(net, gradients, ...
        trailingAvg, trailingAvgSq, iteration, ...
        learnRate, gradientDecayFactor, squaredGradientDecayFactor);

    % Display the training progress.
    figure(loss_fig_dis)
    D = duration(0,0,toc(start),Format="hh:mm:ss");
    addpoints(disLossTrain,iteration,double(loss))
    title("Generator Network,  " + "epoch: " + 1 + ", Elapsed: " + string(D))
    drawnow
end


function [gradients,states,loss] = model_loss(net,input,target_output,mini_batch_size)

[output, states] = forward(net,input);
target_output_dl = dlarray(target_output.');
loss = sum((output - target_output_dl).^2) / mini_batch_size;

gradients = dlgradient(loss,net.Learnables);