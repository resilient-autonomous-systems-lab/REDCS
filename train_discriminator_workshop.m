clc
clear all
close all

%% parameters
maxEpochs = 1000;

%% prepare datatset
inp_size = 2;
mini_batch_size = 1000;
n_batch         = 5000;
n_samples       = n_batch*mini_batch_size;

Z_attack_data = rand(inp_size,n_samples);
Z_dl_data = dlarray(Z_attack_data,'CB');
distance_index = f(Z_dl_data);

%% initialize loss curve plot
loss_fig_dis = figure;
C = colororder;
disLossTrain = animatedline(Color=C(2,:));
ylim([0 inf])
xlabel("Iteration")
ylabel("Loss")
grid on

%% train discriminator
start = tic;
loss_curve_param = {loss_fig_dis,disLossTrain,start};
[net_trained,Loss] = training_discriminators(inp_size,Z_dl_data,distance_index,n_samples,mini_batch_size,loss_curve_param);


%% plot function
test_out = predict(net_trained,Z_dl_data);
% figure, plot(Z_dl_data, test_out,'.'), hold on, plot(Z_dl_data,distance_index,'.');
figure, plot(test_out-distance_index,'.');

function out = f(x)

out = sum(x.*x,1);

end