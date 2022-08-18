function workshop
clc
clear
close all

%% load system base parameters
Run_sim;

%% Initialize Generator network
inp_size = 10;
out_size = 3*n_attacked_nodes;  % dimension of smallest Eucliden space containing set S.

layers = [
    featureInputLayer(inp_size,"Name","input")

    fullyConnectedLayer(50*inp_size,"Name","fc_1")
    reluLayer("Name","relu_1")

    fullyConnectedLayer(100*inp_size,"Name","fc_2")
    tanhLayer("Name","tanh")

    fullyConnectedLayer(50*inp_size,"Name","fc_3")
    reluLayer("Name","relu_2")

    fullyConnectedLayer(out_size,"Name","fc_4")
    sigmoidLayer("Name","sig")];

gen_net = dlnetwork(layers);

% Generator parameters
alpha = 0.7;  % probability of success
beta  = 1 - alpha;

thresh_1 = 0.6;  % threshold for stealthiness
thresh_2 = 0.3;  % threshold for effectivness

mini_batch_size = 5000;
n_batch         = 100;
n_samples       = n_batch*mini_batch_size;
n_epoch         = 10;

generate_random_data_flag = true;
generate_generator_data_flag = true;
n_random_sim_samples = 100;  % Number of random attack dataset per epoch used to train descriminators
n_generator_sim_sample = round(n_random_sim_samples/2);

%% Initialize Discriminators
stealth_net = create_discriminator_net(3*n_attacked_nodes,1);  % Stealthiness network
effect_net  = create_discriminator_net(3*n_attacked_nodes,1);  % Effectiveness network

% % training parameters 
% maxEpochs = 500;
% 
% options = trainingOptions('adam', ...
%     'ExecutionEnvironment','cpu', ...
%     'MaxEpochs',maxEpochs, ...
%     'MiniBatchSize',mini_batch_size, ...
%     'GradientThreshold',1, ...
%     'Verbose',false, ...
%     'Plots','none');

%% Plot routine
loss_fig_gen = figure;
C = colororder;
genLossTrain = animatedline(Color=C(2,:));
ylim([0 inf])
xlabel("Iteration")
ylabel("Loss")
grid on

loss_fig_dis1 = figure;
dis1LossTrain = animatedline(Color=C(2,:));
ylim([0 inf])
xlabel("Iteration")
ylabel("Loss")
grid on

loss_fig_dis2 = figure;
dis2LossTrain = animatedline(Color=C(2,:));
ylim([0 inf])
xlabel("Iteration")
ylabel("Loss")
grid on

start = tic;
for i_epoch = 1:n_epoch

    %% prepare attack dataset for discriminator training
    %%% random attack dataset 
    [sim_obj_rand,Z_attack_data_rand,effect_index_rand,stealth_index_rand] = random_attack_dataset_gen(generate_random_data_flag,n_attacked_nodes,n_random_sim_samples,t_sim_stop);

    %%% generator attack dataset
    [sim_obj_gen,Z_attack_data_gen,effect_index_gen,stealth_index_gen] = generator_attack_dataset_gen(gen_net,generate_generator_data_flag,inp_size,n_generator_sim_sample,t_sim_stop);

    %%% compose training dataset for discriminator
    Z_attack_data = [Z_attack_data_rand,Z_attack_data_gen];
    effect_index = [effect_index_rand;effect_index_gen];
    stealth_index = [stealth_index_rand;stealth_index_gen];
    
    save('sim_sample_system_data','sim_obj_rand','sim_obj_gen','effect_index','stealth_index','Z_attack_data','-v7.3');


    %% Train Discriminator network
%     % initialize new discriminators 
%     stealth_net = create_discriminator_net(3*n_attacked_nodes,1);  % Stealthiness network
%     effect_net  = create_discriminator_net(3*n_attacked_nodes,1);  % Effectiveness network
    [effect_net,stealth_net,effect_training_info,stealth_training_info] = training_discriminators(effect_net,stealth_net,Z_attack_data,effect_index,stealth_index);

%     effect_net_layers = [effect_net.Layers;regressionLayer];
%     [effect_series_net, effect_training_info]   = trainNetwork(Z_attack_data.',effect_index,effect_net_layers,options);
%     effect_lgraph = layerGraph(effect_series_net);
%     effect_lgraph = removeLayers(effect_lgraph,'regressionoutput');
%     effect_net = dlnetwork(effect_lgraph);
%     
%     stealth_net_layers = [stealth_net.Layers;regressionLayer];
%     [stealth_series_net, stealth_training_info] = trainNetwork(Z_attack_data.',stealth_index,stealth_net_layers,options);
%     stealth_lgraph = layerGraph(stealth_series_net);
%     stealth_lgraph = removeLayers(stealth_lgraph,'regressionoutput');
%     stealth_net = dlnetwork(stealth_lgraph);

    % Display the training progress
    figure(loss_fig_dis1)
    D = duration(0,0,toc(start),Format="hh:mm:ss");
    addpoints(dis1LossTrain,(i_epoch-1)*maxEpochs+linspace(1,maxEpochs,maxEpochs),double(effect_training_info.TrainingLoss))
    title("effect Network,  " + "epoch: " + 1 + ", Elapsed: " + string(D))

    figure(loss_fig_dis2)
    D = duration(0,0,toc(start),Format="hh:mm:ss");
    addpoints(dis2LossTrain,(i_epoch-1)*maxEpochs+linspace(1,maxEpochs,maxEpochs),double(stealth_training_info.TrainingLoss))
    title("stealth Network,  " + "epoch: " + 1 + ", Elapsed: " + string(D))
    drawnow

    keyboard


    %% Random network input sample
    Z_data    = 20*(0.5 - rand(inp_size,n_samples,"single"));   % uniformly random noise as input
    Z_dlarray = dlarray(Z_data,"CB");                     % covert to dlarray
    % Z         = gpuArray(Z_dlarray);                      % use gpu
    
    
    % Pretrained network performace
    out = double(predict(gen_net,Z_dlarray));
    f1_out = f1(stealth_net,out,thresh_1);
    f2_out = f2(effect_net, out,thresh_2);
    pre_score = sum((f1_out<=0) & (f2_out<=0))/n_samples;
    disp("pre-trained score = " + num2str(pre_score) + " ::: Target = " + num2str(alpha))
    
    perf_fig = figure;
    y_stealth = predict(stealth_net,out);
    y_effect  = predict(effect_net,out);
    subplot(121)
    plot(y_stealth,'.'), hold on, plot(ones(n_samples,1)*thresh_1,'k')
    subplot(122)
    plot(y_effect,'.'), hold on, plot(ones(n_samples,1)*thresh_2,'k')
    sgtitle("Training Performance")



    %% Training Generator with adam
    
    % parameters for Adam optimizer
    learnRate = 0.0002;
    gradientDecayFactor = 0.5;
    squaredGradientDecayFactor = 0.999;
    
    % initialize Adam optimizer
    trailingAvg = [];
    trailingAvgSq = [];
    
    % training
    iteration = 0;
    
    % Loop over one epoch of mini-batches
    for ind = 1:mini_batch_size:n_samples
        iteration = iteration +1;
    
        % Getting mini-batch input data
        idx = ind:min(ind+mini_batch_size-1,n_samples);
        Z_iter = Z_dlarray(:,idx);
    
        % Evaluate the model gradients, state, and loss using dlfeval and the modelLoss function and update the network state.
        [gradients,net_state,loss] = dlfeval(@model_loss,gen_net,Z_iter, beta*mini_batch_size,stealth_net,effect_net,thresh_1, thresh_2); % forward propogation, simulation, loss calculation, gradient calculation
    
        gen_net.State = net_state;                    % update network state
    
        % Update the network parameters using the Adam optimizer.
        [gen_net,trailingAvg,trailingAvgSq] = adamupdate(gen_net, gradients, ...
            trailingAvg, trailingAvgSq, iteration, ...
            learnRate, gradientDecayFactor, squaredGradientDecayFactor);
    
        % Display the training progress.
        figure(loss_fig_gen)
        D = duration(0,0,toc(start),Format="hh:mm:ss");
        addpoints(genLossTrain,iteration+(i_epoch-1)*n_samples,double(loss))
        title("Generator Network,  " + "epoch: " + 1 + ", Elapsed: " + string(D))
        drawnow

    end
    toc(start);


    % Post-trained network performace
    out = double(forward(gen_net,Z_dlarray));
    
    f1_out = f1(stealth_net,out,thresh_1);
    f2_out = f2(effect_net,out,thresh_2);
    post_score = sum((f1_out<=0) & (f2_out<=0))/n_samples;
    disp("post-trained score = " + num2str(post_score) + " ::: Target = " + num2str(alpha))
    
    figure(perf_fig),
    y_stealth = forward(stealth_net,out);
    y_effect  = forward(effect_net,out);
    subplot(121)
    hold on, plot(y_stealth,'.')
    subplot(122)
    hold on, plot(y_effect,'.')

end


%% Testing performance
n_test = 10000;
Z_test        = 100*(0.5 - rand(inp_size,n_test,"single"));   % uniformly random noise as input
Z_tet_dlarray = dlarray(Z_test,"CB");                     % covert to dlarray

test_out = double(forward(gen_net,Z_tet_dlarray));

f1_out = f1(stealth_net,test_out,thresh_1);
f2_out = f2(effect_net,test_out,thresh_2);
test_score = sum((f1_out<=0) & (f2_out<=0))/n_test;
disp("Testing score = " + num2str(test_score) + " ::: Target = " + num2str(alpha))

figure,
y_stealth = forward(stealth_net,test_out);
y_effect  = forward(effect_net,test_out);
subplot(121)
hold on, plot(y_stealth,'.')
title("Stealthiness ::: Threshold = " + num2str(thresh_1))
subplot(122)
hold on, plot(y_effect,'.')
title("Effectiveness ::: Threshold = " + num2str(thresh_2))

sgtitle("Testing Performance")

keyboard

function [gradients,states,loss] = model_loss(net,Z,beta_n,stealth_net,effect_net,thresh_1,thresh_2)

[g_theta, states] = forward(net,Z);
loss    = relu((sum(exp(f1(stealth_net,g_theta,thresh_1))) - beta_n)) + ...
           relu((sum(exp(f2(effect_net,g_theta,thresh_2))) - beta_n));

gradients = dlgradient(loss,net.Learnables);

function out = f1(net,x,thresh_1)
y = forward(net,x);
out =  y - thresh_1;  % inidicator function

function out = f2(net,x,thresh_2)
y = forward(net,x);
out =  thresh_2 - y;  % inidicator function


function net = create_discriminator_net(inp_size,out_size)

layers = [
    featureInputLayer(inp_size,"Name","input")

    fullyConnectedLayer(5*inp_size,"Name","fc_1")
    reluLayer("Name","relu_1")

%     fullyConnectedLayer(5*inp_size,"Name","fc_2")
%     tanhLayer("Name","tanhn_1")

    fullyConnectedLayer(out_size,"Name","fc_3")
    sigmoidLayer("Name","sigmoid")];


net = dlnetwork(layers);

