function gen_net = training_generator(i_epoch, gen_net,stealth_net,effect_net,alpha,thresholds,loss_curve_param)
%% function gen_net = traning_generator(i_epoch, gen_net,stealth_net,effect_net,alpha,thresholds,loss_curve_param)
% train generator network, plot pre-training and post-training performance
% Inputs: 
%        i_epoch          : [scalar] current epoch, used for plotting loss curve
%        gen_net          : dl object for generator network
%        stealth_net      : dl object for stealthiness network
%        effect_net       : dl object for effectiveness network
%        alpha            : [scalar] probability of success
%        thresholds       : [1-by-2] [thresh_1 (threshold for steathiness), thresh_2 (threshold for effectiveness)]
%        loss_curve_param : [1-by-3] cell array {loss_fig_gen, genLossTrain, start}
% Outputs: 
%        gen_net          : trained generator network
%
% Author: Olugbenga Moses Anubi, Florida state university
%         Yu Zheng, Florida state university
% 08/19/2022

%% Generator parameter
beta = 1-alpha;
thresh_1 = thresholds(1);
thresh_2 = thresholds(2);
inp_size = gen_net.Layers(1, 1).InputSize;

mini_batch_size = 5000;
n_batch         = 100;
n_samples       = n_batch*mini_batch_size;

loss_fig_gen = loss_curve_param{1,1};
genLossTrain = loss_curve_param{1,2};
start = loss_curve_param{1,3};

%% parameters for Adam optimizer
learnRate = 0.0002;
gradientDecayFactor = 0.5;
squaredGradientDecayFactor = 0.999;

% initialize Adam optimizer
trailingAvg = [];
trailingAvgSq = [];

% training
iteration = 0;

%% input data
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
plot(y_stealth,'b.'), hold on, plot(ones(n_samples,1)*thresh_1,'k')
subplot(122)
plot(y_effect,'b.'), hold on, plot(ones(n_samples,1)*thresh_2,'k')
sgtitle("Training Performance")

%% Loop over one epoch of mini-batches
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
hold on, plot(y_stealth,'r.')
subplot(122)
hold on, plot(y_effect,'r.')


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