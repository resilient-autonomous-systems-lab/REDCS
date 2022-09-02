function workshop
clc
clear
close all

%% load system base parameters
Run_sim;

%% global training parameters
n_epoch         = 10;

generate_generator_data_flag = true;
n_random_sim_samples = 10000;  % Number of random attack dataset per epoch used to train descriminators
n_generator_sim_sample = round(n_random_sim_samples);

%% Initialize Generator network
alpha = 0.7;  % probability of success
% beta  = 1 - alpha;

thresh_1 = 4;  % threshold for stealthiness
thresh_2 = 0.04;  % threshold for effectivness
thresholds = [thresh_1,thresh_2];


inp_size = 10;
out_size = 3*n_attacked_nodes;  % dimension of smallest Eucliden space containing set S.

activation_fcns_gen = ["relu","sigmoid","tanh","sigmoid"];
n_neurons_gen = [50*inp_size,100*inp_size,50*inp_size,out_size];
gen_net = create_dl_network(inp_size,activation_fcns_gen,n_neurons_gen);


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
loss_curve_param_gen = {loss_fig_gen,genLossTrain,start};
loss_curve_param_dis1 = {loss_fig_dis1,dis1LossTrain,start};
loss_curve_param_dis2 = {loss_fig_dis2,dis2LossTrain,start};

 %%% random attack dataset 
[sim_obj_rand,Z_attack_data_rand,effect_index_rand,stealth_index_rand] = random_attack_dataset_gen(n_attacked_nodes,n_random_sim_samples,policy_param);

%% Training
for i_epoch = 1:n_epoch
    %% prepare attack dataset for discriminator training
    %%% generator attack dataset
    [sim_obj_gen,Z_attack_data_gen,effect_index_gen,stealth_index_gen] = generator_attack_dataset_gen(gen_net,generate_generator_data_flag,inp_size,n_generator_sim_sample,policy_param);

    %%% compose training dataset for discriminator
    sim_obj = [sim_obj_rand;sim_obj_gen];
    Z_attack_data = dlarray([Z_attack_data_rand,Z_attack_data_gen],'CB');
    effect_index = dlarray([effect_index_rand;effect_index_gen].','CB');
    stealth_index = dlarray([stealth_index_rand;stealth_index_gen].','CB');
    
    save('sim_sample_system_data','sim_obj','effect_index','stealth_index','Z_attack_data','-v7.3');


    %% Train Discriminator network
    [effect_net,stealth_net] = training_discriminators(n_attacked_nodes,Z_attack_data,effect_index,stealth_index,loss_curve_param_dis1,loss_curve_param_dis2,i_epoch);

    %% Training Generator with adam
    gen_net = training_generator(i_epoch,gen_net,stealth_net,effect_net,alpha,thresholds,loss_curve_param_gen);

end

%% Testing performance
[test_score_dis,test_score_sim,~,~,~,~] = Performance_evaluation(gen_net,stealth_net,effect_net,thresholds,500,policy_param,true);
disp("Testing score with discriminators = " + num2str(test_score_dis) + " ::: Target = " + num2str(alpha))
disp("Testing score with model simualtion = " + num2str(test_score_sim) + " ::: Target = " + num2str(alpha))

keyboard