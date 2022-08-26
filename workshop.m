function workshop
clc
clear
close all


%% global training parameters
n_epoch         = 5;

generate_generator_data_flag = true;
n_random_sim_samples = 5000;  % Number of random attack dataset per epoch used to train descriminators
n_generator_sim_sample = round(n_random_sim_samples);

%% Initialize Generator network
alpha = 0.8;  % probability of success
% beta  = 1 - alpha;

thresh_1 = 0.2;  % threshold for stealthiness
thresh_2 = 0.1;  % threshold for effectivness
thresholds = [thresh_1,thresh_2];


inp_size = 5;
out_size = 2;  % dimension of smallest Eucliden space containing set S.

activation_fcns_gen = ["relu","tanh","relu","relu","sigmoid"];
n_neurons_gen = [50*inp_size,100*inp_size,100*inp_size,50*inp_size,out_size];
gen_net = create_dl_network(inp_size,activation_fcns_gen,n_neurons_gen);


%% loss curve Plot routine
loss_fig_gen = figure;
C = colororder;
genLossTrain = animatedline(Color=C(2,:));
ylim([0 inf])
xlabel("Iteration")
ylabel("Loss")
grid on


loss_fig_dis = figure;
disLossTrain = animatedline(Color=C(2,:));
ylim([0 inf])
xlabel("Iteration")
ylabel("Loss")
grid on


start = tic;
loss_curve_param_gen = {loss_fig_gen,genLossTrain,start};
loss_curve_param_dis = {loss_fig_dis,disLossTrain,start};

 %%% random attack dataset 
[Z_attack_data_rand,distance_index_rand] = random_attack_dataset_gen(out_size,n_random_sim_samples);

%% Training
for i_epoch = 1:n_epoch
    %% prepare attack dataset for discriminator training
    %%% generator attack dataset
    [Z_attack_data_gen,distance_index_gen] = generator_attack_dataset_gen(gen_net,generate_generator_data_flag,inp_size,n_generator_sim_sample);

    %%% compose training dataset for discriminator
    Z_attack_data = [Z_attack_data_rand,Z_attack_data_gen];
    distance_index = [distance_index_rand,distance_index_gen];
    
    save('sim_sample_system_data','distance_index','Z_attack_data','-v7.3');


    %% Train Discriminator network
    mini_batch_size = 1000;
    n_samples = round(length(Z_attack_data)/mini_batch_size);
    [discriminator_net,~] = training_discriminators(out_size,dlarray(Z_attack_data,'CB'),dlarray(distance_index,'CB'),n_samples,mini_batch_size,loss_curve_param_dis);

    %% Training Generator with adam
    gen_net = training_generator(i_epoch,gen_net,discriminator_net,alpha,thresholds,loss_curve_param_gen);

end

%% Testing performance
[test_score_dis,test_score_sim,~,~] = Performance_evaluation(gen_net,discriminator_net,thresholds,10000,true);
disp("Testing score with discriminators = " + num2str(test_score_dis) + " ::: Target = " + num2str(alpha))
disp("Testing score with model simualtion = " + num2str(test_score_sim) + " ::: Target = " + num2str(alpha))

keyboard