%% train a neural network for bad data detection
clear all
clc

detector_train_flag = 1;
attack_percentage = 1.0;
n_meas = 4;
%% initialize a dl network
inp_size = n_meas;
out_size = 1;
try    
    detector_net = load("Detector.mat").detector_net;
catch
    activation_fcns = ["relu","sigmoid"];
    n_neurons = [10*inp_size,out_size];
    detector_net = create_dl_network(inp_size,activation_fcns,n_neurons);  % detector network
end

%% Hyperparameters
n_epoch = 50;
mini_batch_size = 1000;
n_batch = 10;
n_samples = round(n_batch*mini_batch_size);

% initialize Adam optimizer
learnRate = 0.0001;
gradientDecayFactor = 0.5;
squaredGradientDecayFactor = 0.999;

trailingAvg = [];
trailingAvgSq = [];

%% load dataset
try 
    total_dataset = load("total_dataset.mat").total_dataset;
catch
    disp("no existing training dataset, run prepare_dataset_for_detector.m first");
    keyboard;
end
Z_input = total_dataset(1:0.9*size(total_dataset,1),1:n_meas);
Z_output = total_dataset(1:0.9*size(total_dataset,1),n_meas+1:end);

test_input = total_dataset(0.9*size(total_dataset,1)+1:end,1:n_meas);
test_output = total_dataset(0.9*size(total_dataset,1)+1:end,n_meas+1:end);

%% loss curve Plot routine
loss_fig = figure;
C = colororder;
LossTrain = animatedline(Color=C(2,:));
ylim([0 inf])
xlabel("Iteration")
ylabel("Loss")
grid on

start = tic;
iteration       = 0;
%% training
for iepoch = 1:n_epoch
    iteration = iteration+1;

    print_msg ="enter epoch "+num2str(iteration);
    disp(print_msg);

    for iter = 1:n_batch    
        % Getting mini-batch dataset
        idx = sort(randperm(size(Z_output,1),mini_batch_size));
        input_iter = dlarray(Z_input(idx,:),"BC");
        output_iter = dlarray(Z_output(idx,:),"BC");
    
        % calculate loss and gradients
        [gradients,net_state,loss] = dlfeval(@model_loss,detector_net,input_iter,output_iter); % forward propogation, simulation, loss calculation, gradient calculation 
        detector_net.State = net_state;                    % update network state

         % Update the network parameters using the Adam optimizer.
        [detector_net,trailingAvg,trailingAvgSq] = adamupdate(detector_net, gradients, ...
            trailingAvg, trailingAvgSq, iteration, ...
            learnRate, gradientDecayFactor, squaredGradientDecayFactor);

    end
    % Display the training progress.
    figure(loss_fig)
    D = duration(0,0,toc(start),Format="hh:mm:ss");
    addpoints(LossTrain,iteration,double(loss))
    title("Detector network training epoch: " + num2str(iepoch) + ", Elapsed: " + string(D))
    drawnow
end

save('Detector.mat','detector_net','-v7.3');

%% testing
pred_out = extractdata(predict(detector_net,dlarray(test_input,"BC")));
detection_out = (pred_out>=0.5);
score = 1 - sum(abs((detection_out.' - test_output)))/(0.1*size(total_dataset,1));
disp("Testing score is: "+num2str(score));


function [gradients, state, loss] = model_loss(net,input,target_output)
    
[output, state] = forward(net,input);

loss = crossentropy(output,target_output,'TargetCategories','independent');

gradients = dlgradient(loss,net.Learnables);
end