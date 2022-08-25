function gen_net = training_generator(i_epoch, gen_net,dis_net,alpha,thresholds,loss_curve_param)

%% Generator parameter
beta = 1-alpha;
thresh_1 = thresholds(1);
thresh_2 = thresholds(2);
inp_size = gen_net.Layers(1, 1).InputSize;
out_size = gen_net.Layers(end-1,1).OutputSize;

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

%% plot parameters
t = linspace(0,2*pi,1000);
[U,S] = svd(eye(out_size));
z1_plot = sqrt(thresh_1)*U*(S^-0.5)*[cos(t);sin(t)];
z2_plot = sqrt(thresh_2)*U*(S^-0.5)*[cos(t);sin(t)];

%% input data
Z_data    = 20*(0.5 - rand(inp_size,n_samples,"single"));   % uniformly random noise as input
Z_dlarray = dlarray(Z_data,"CB");                     % covert to dlarray
% Z         = gpuArray(Z_dlarray);                      % use gpu

% Pretrained network performace
out = double(predict(gen_net,Z_dlarray));
f1_out = f1(dis_net,out,thresh_1);
f2_out = f2(dis_net, out,thresh_2);
pre_score = sum((f1_out<=0) & (f2_out<=0))/n_samples;
disp("pre-trained score = " + num2str(pre_score) + " ::: Target = " + num2str(alpha))

figure, plot(out(1,:),out(2,:), '.'), axis equal
hold on, plot(z1_plot(1,:),z1_plot(2,:),'r');
hold on, plot(z2_plot(1,:),z2_plot(2,:),'k');
title('pre-training performance')

%% Loop over one epoch of mini-batches
for ind = 1:mini_batch_size:n_samples
    iteration = iteration +1;

    % Getting mini-batch input data
    idx = ind:min(ind+mini_batch_size-1,n_samples);
    Z_iter = Z_dlarray(:,idx);

    % Evaluate the model gradients, state, and loss using dlfeval and the modelLoss function and update the network state.
    [gradients,net_state,loss] = dlfeval(@model_loss,gen_net,Z_iter, beta*mini_batch_size,dis_net,thresh_1, thresh_2); % forward propogation, simulation, loss calculation, gradient calculation

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

f1_out = f1(dis_net,out,thresh_1);
f2_out = f2(dis_net,out,thresh_2);
post_score = sum((f1_out<=0) & (f2_out<=0))/n_samples;
disp("post-trained score = " + num2str(post_score) + " ::: Target = " + num2str(alpha))

figure, plot(out(1,:),out(2,:), '.'), axis equal
hold on, plot(z1_plot(1,:),z1_plot(2,:),'r');
hold on, plot(z2_plot(1,:),z2_plot(2,:),'k');
title('post-training performance')


function [gradients,states,loss] = model_loss(net,Z,beta_n,dis_net,thresh_1,thresh_2)

[g_theta, states] = forward(net,Z);
loss    = relu((sum(exp(f1(dis_net,g_theta,thresh_1))) - beta_n)) + ...
           relu((sum(exp(f2(dis_net,g_theta,thresh_2))) - beta_n));

gradients = dlgradient(loss,net.Learnables);

function out = f1(net,x,thresh_1)
y = forward(net,x);
out =  y - thresh_1;  % inidicator function outer circle

function out = f2(net,x,thresh_2)
y = forward(net,x);
out =  thresh_2 - y;  % inidicator function inner circle