function generator_example_concentric_circles_discriminators
clc
clear
close all

%% Generator parameters
alpha = 0.8;  % probability of success
beta  = 1 - alpha;

thresh_1 = 0.2;
thresh_2 = 0.1;

mini_batch_size = 500;
n_batch         = 1000;
n_samples       = n_batch*mini_batch_size;


%% Creating Generator network
inp_size = 5;
out_size = 2;  % dimension of smallest Eucliden space containing set S.

layers = [
    featureInputLayer(inp_size,"Name","input")

    fullyConnectedLayer(10*inp_size,"Name","fc_1")
    reluLayer("Name","relu_1")

    fullyConnectedLayer(20*inp_size,"Name","fc_2")
    sigmoidLayer("Name","sig")

    fullyConnectedLayer(out_size,"Name","fc_3")
    tanhLayer("Name","tanh")];

gen_net = dlnetwork(layers);

%% Plot routine
loss_fig = figure;
C = colororder;
lineLossTrain = animatedline(Color=C(2,:));
ylim([0 inf])
xlabel("Iteration")
ylabel("Loss")
grid on

% Sigma   = randn(out_size); % 
% P       = (Sigma.'*Sigma);

t = linspace(0,2*pi,1000);
[U,S] = svd(eye(out_size));
z1_plot = sqrt(thresh_1)*U*(S^-0.5)*[cos(t);sin(t)];
z2_plot = sqrt(thresh_2)*U*(S^-0.5)*[cos(t);sin(t)];


%% Random network input sample
Z_data    = 20*(0.5 - rand(inp_size,n_samples,"single"));   % uniformly random noise as input
Z_dlarray = dlarray(Z_data,"CB");                     % covert to dlarray
% Z         = gpuArray(Z_dlarray);                      % use gpu


% Pretrained network performace
out = double(forward(gen_net,Z_dlarray));
f1_out = f1(out,thresh_1);
f2_out = f2(out,thresh_2);
pre_score = sum((f1_out<=0) & (f2_out<=0))/n_samples;
disp("pre-trained score = " + num2str(pre_score) + " ::: Target = " + num2str(alpha))

figure, plot(out(1,:),out(2,:), '.'), axis equal
hold on, plot(z1_plot(1,:),z1_plot(2,:),'r');
hold on, plot(z2_plot(1,:),z2_plot(2,:),'k');



%% Training the netwok with adam

% parameters for Adam optimizer
learnRate = 0.0002;
gradientDecayFactor = 0.5;
squaredGradientDecayFactor = 0.999;

% initialize Adam optimizer
trailingAvg = [];
trailingAvgSq = [];


% training
tic;
iteration = 0;
start = tic;

% Loop over one epoch of mini-batches
for ind = 1:mini_batch_size:n_samples
    iteration = iteration +1;

    % Getting mini-batch input data
    idx = ind:min(ind+mini_batch_size-1,n_samples);
    Z_iter = Z_dlarray(:,idx);

    % Evaluate the model gradients, state, and loss using dlfeval and the modelLoss function and update the network state.
    [gradients,net_state,loss] = dlfeval(@model_loss,gen_net,Z_iter, beta*mini_batch_size,thresh_1, thresh_2); % forward propogation, simulation, loss calculation, gradient calculation

    gen_net.State = net_state;                    % update network state

    % Update the network parameters using the Adam optimizer.
    [gen_net,trailingAvg,trailingAvgSq] = adamupdate(gen_net, gradients, ...
        trailingAvg, trailingAvgSq, iteration, ...
        learnRate, gradientDecayFactor, squaredGradientDecayFactor);

    % Display the training progress.
    figure(loss_fig)
    D = duration(0,0,toc(start),Format="hh:mm:ss");
    addpoints(lineLossTrain,iteration,double(loss))
    title("Generator Network,  " + "epoch: " + 1 + ", Elapsed: " + string(D))
    drawnow

end
toc;


% Post-trained network performace
Z_data_test    = 20*(0.5 - rand(inp_size,n_samples,"single"));   % uniformly random noise as input
Z_dlarray_test = dlarray(Z_data_test,"CB");                     % covert to dlarray
out = double(forward(gen_net,Z_dlarray_test));

f1_out = f1(out,thresh_1);
f2_out = f2(out,thresh_2);
post_score = sum((f1_out<=0) & (f2_out<=0))/n_samples;
disp("post-trained score = " + num2str(post_score) + " ::: Target = " + num2str(alpha))

figure, plot(out(1,:),out(2,:), '.'), axis equal
hold on, plot(z1_plot(1,:),z1_plot(2,:),'r');
hold on, plot(z2_plot(1,:),z2_plot(2,:),'k');

keyboard

function [gradients,states,loss] = model_loss(net,Z,beta_n,thresh_1,thresh_2)

[g_theta, states] = forward(net,Z);
loss    = relu((sum(exp(f1(g_theta,thresh_1))) - beta_n)) + ...
           relu((sum(exp(f2(g_theta,thresh_2))) - beta_n));

gradients = dlgradient(loss,net.Learnables);

function out = f1(x,thresh_1)
out =  sum(x.*x,1) - thresh_1 ;  % inidicator function

function out = f2(x,thresh_2)
out =  thresh_2 - sum(x.*x,1) ;  % inidicator function

