function workshop
clc
clear
close all

%% load system base parameters
Run_sim;

%% global training parameters
n_epoch         = 10;

generate_random_data_flag = true;
generate_generator_data_flag = true;
n_random_sim_samples = 20;  % Number of random attack dataset per epoch used to train descriminators
n_generator_sim_sample = round(n_random_sim_samples/2);

%% Initialize Generator network
alpha = 0.7;  % probability of success
% beta  = 1 - alpha;

thresh_1 = 0.6;  % threshold for stealthiness
thresh_2 = 0.3;  % threshold for effectivness
thresholds = [thresh_1,thresh_2];


inp_size = 10;
out_size = 3*n_attacked_nodes;  % dimension of smallest Eucliden space containing set S.

activation_fcns_gen = ["relu","tanh","relu","sigmoid"];
n_neurons_gen = [50*inp_size,100*inp_size,50*inp_size,out_size];
gen_net = create_dl_network(inp_size,activation_fcns_gen,n_neurons_gen);

%% Initialize Discriminators
inp_size_dis = 3*n_attacked_nodes;
activation_fcns_effect = ["relu","sigmoid"];
n_neurons_effect = [5*inp_size_dis,1];
effect_net = create_dl_network(inp_size_dis,activation_fcns_effect,n_neurons_effect); % Effectiveness network

activation_fcns_stealth = ["relu","tanh","sigmoid"];
n_neurons_stealth = [5*inp_size_dis,5*inp_size_dis,1];
stealth_net = create_dl_network(inp_size_dis,activation_fcns_stealth,n_neurons_stealth);  % Stealthiness network

% training parameters 
maxEpochs = 500;


%% loss curve Plot routine
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
loss_curve_param = {loss_fig_gen,genLossTrain,start};

%% Training
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
    [effect_net,stealth_net,effect_training_info,stealth_training_info] = training_discriminators(effect_net,stealth_net,Z_attack_data,effect_index,stealth_index,maxEpochs);

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

    %% Training Generator with adam
    gen_net = traning_generator(gen_net,stealth_net,effect_net,inp_size,alpha,thresholds,loss_curve_param);


end


%% Testing performance
test_score = Performance_evaluation(gen_net,stealth_net,effect_net,thresholds,alpha);
disp("Testing score = " + num2str(test_score) + " ::: Target = " + num2str(alpha))