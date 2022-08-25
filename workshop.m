function workshop
clc
clear
close all


%% global training parameters
n_epoch         = 2;

generate_generator_data_flag = true;
n_random_sim_samples = 2000;  % Number of random attack dataset per epoch used to train descriminators
n_generator_sim_sample = round(n_random_sim_samples/2);

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


loss_fig_dis = figure;
disLossTrain = animatedline(Color=C(2,:));
ylim([0 inf])
xlabel("Iteration")
ylabel("Loss")
grid on


start = tic;
loss_curve_param = {loss_fig_gen,genLossTrain,start};


 %%% random attack dataset 
[Z_attack_data_rand,distance_index_rand] = random_attack_dataset_gen(out_size,n_random_sim_samples);

%% Training
for i_epoch = 1:n_epoch
    %% prepare attack dataset for discriminator training
    %%% generator attack dataset
    [Z_attack_data_gen,distance_index_gen] = generator_attack_dataset_gen(gen_net,generate_generator_data_flag,inp_size,n_generator_sim_sample);

    %%% compose training dataset for discriminator
    Z_attack_data = [Z_attack_data_rand,Z_attack_data_gen];
    distance_index = [distance_index_rand,distance_index_gen].';
    
    save('sim_sample_system_data','distance_index','Z_attack_data','-v7.3');


    %% Train Discriminator network
    [discriminator_net,training_info] = training_discriminators(out_size,Z_attack_data,distance_index,maxEpochs);

    % Display the training progress
    n_iter = length(training_info.TrainingLoss);

    figure(loss_fig_dis)
    D = duration(0,0,toc(start),Format="hh:mm:ss");
    addpoints(disLossTrain,(i_epoch-1)*n_iter+linspace(1,n_iter,n_iter),double(training_info.TrainingLoss))
    title("discriminator,  " + "epoch: " + 1 + ", Elapsed: " + string(D))
    drawnow

    %% Training Generator with adam
    gen_net = training_generator(i_epoch,gen_net,discriminator_net,alpha,thresholds,loss_curve_param);

end

%% Testing performance
[test_score_dis,test_score_sim,~,~] = Performance_evaluation(gen_net,discriminator_net,thresholds,10000,true);
disp("Testing score with discriminators = " + num2str(test_score_dis) + " ::: Target = " + num2str(alpha))
disp("Testing score with model simualtion = " + num2str(test_score_sim) + " ::: Target = " + num2str(alpha))

keyboard