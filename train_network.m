%% train attack-net to generate feasible attacks
clear all
clc

Run_sim;    % load system parameters (*******replace by GE's parameter file later*******)


%% Network hyperparameters
inp_size = 5;     % network input size       
out_size = 3*n_attacked_nodes;     % network output size        

numEpochs = 50;       % total epoch size
miniBatchSize = 128;   % batch size at each epoch

% parameters for Adam optimizer
learnRate = 0.0002;
gradientDecayFactor = 0.5;
squaredGradientDecayFactor = 0.999;

% am_scale = 1;     % amplifier scale

% options = trainingOptions('sgdm', ...
%     'LearnRateSchedule','piecewise', ...
%     'LearnRateDropFactor',0.2, ...
%     'LearnRateDropPeriod',5, ...
%     'MaxEpochs',numEpochs, ...
%     'MiniBatchSize',miniBatchSize, ...
%     'Plots','training-progress', ...
%     'ExecutionEnvironment', 'gpu');


%% Simulation objects
model = 'sample_system';
load_system(model);

% build rapid accelerator target
Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

% simulation input objects'
for iter = 1:miniBatchSize

    sim_inp(iter) = Simulink.SimulationInput(model);
    sim_inp(iter) = sim_inp(iter).setModelParameter('SimulationMode','rapid-accelerator');
    sim_inp(iter) = sim_inp(iter).setModelParameter('RapidAcceleratorUpToDateCheck','off');

    sim_inp(iter) = sim_inp(iter).setVariable('A',A);
    sim_inp(iter) = sim_inp(iter).setVariable('B',B);
    sim_inp(iter) = sim_inp(iter).setVariable('C',C);
    sim_inp(iter) = sim_inp(iter).setVariable('Cc',Cc);
    sim_inp(iter) = sim_inp(iter).setVariable('x0',x0);
    sim_inp(iter) = sim_inp(iter).setVariable('x_hat0',x_hat0);
    sim_inp(iter) = sim_inp(iter).setVariable('K',K);
    sim_inp(iter) = sim_inp(iter).setVariable('L',L);
    
    sim_inp(iter) = sim_inp(iter).setVariable('noise_trigger',1);
    sim_inp(iter) = sim_inp(iter).setVariable('noise_seed',randi(100));

    sim_inp(iter) = sim_inp(iter).setVariable('t_sim_stop',t_sim_stop);
    sim_inp(iter) = sim_inp(iter).setVariable('detection_start',detection_start);

end

%% Getting effectiveness and stealthiness thresholds

% averaging levels
stealth_prctile_level = 100;
effect_prctile_level  = 85;

sim_out = parsim(sim_inp);

[yc_error, r_error] = get_error_from_nominal(sim_out,yc_nominal,r_nominal);

stealthiness_tol  = gpuArray(dlarray(prctile(r_error,stealth_prctile_level) * ones(1,miniBatchSize),"CB"));      % convert the steathiness threhold(i.e.=2) to gpu_dl_array
effectiveness_tol = gpuArray(dlarray(prctile(yc_error,effect_prctile_level) * ones(1,miniBatchSize),"CB"));   % convert the steathiness threhold (i.e.=0.5) to gpu_dl_array
                                                                           % Notice: threshold setting should be given based on analysis of system


% sim_inp = sim_inp.setVariable('attack_start_times',attack_start_times);
% sim_inp = sim_inp.setVariable('attack_full_times',attack_full_times);
% sim_inp = sim_inp.setVariable('attack_final_deviations',attack_final_deviations);


%% initialization
attack_net = create_attack_net(inp_size,out_size);   % create deep network (attack generator)

% initialize Adam optimizer
trailingAvg = [];
trailingAvgSq = [];


% (net,z,sim_inp,n_meas,stealthiness_tol, effectiveness_tol,detection_start, r_nominal, yc_nominal)


%% training
iteration = 0;
tic;
Loss = zeros(numEpochs,1);

% Loop over epochs.
for epoch = 1:numEpochs
    iteration = iteration +1;
    
    Z_data    = randn(inp_size,miniBatchSize,"single");   % uniformly random noise as input
    Z_dlarray = dlarray(Z_data,"CB");                     % covert to dlarray
    Z         = gpuArray(Z_dlarray);                      % use gpu

    % Evaluate the model gradients, state, and loss using dlfeval and the modelLoss function and update the network state.
    [gradients,net_state,loss] = dlfeval(@mymodelLoss,attack_net,Z, sim_inp,n_meas,attack_indices, ...
        stealthiness_tol, effectiveness_tol, ...
        r_nominal, yc_nominal); % forward propogation, simulation, loss calculation, gradient calculation
    
    attack_net.State = net_state;                    % update network state

    % Update the network parameters using the Adam optimizer.
    [attack_net,trailingAvg,trailingAvgSq] = adamupdate(attack_net, gradients, ...
            trailingAvg, trailingAvgSq, iteration, ...
            learnRate, gradientDecayFactor, squaredGradientDecayFactor);

    % Display the training progress.
    msg = ['Loss: ', num2str(gather(extractdata(loss)))];
    disp(msg);
    Loss(epoch) = loss;

end
toc;
 







