function test_score = Performance_evaluation(gen_net,stealth_net,effect_net,thresholds)
%% function test_score = Performance_evaluation(gen_net,stealth_net,effect_net,thresholds)
% two tests:
%           1) run generator, obtain stealth and effect indexes from discriminators
%           2) run generator, obtain stealth and effect indexes from model simualtion
% Inputs: 
%        gen_net          : dl object for generator network
%        stealth_net      : dl object for stealthiness network
%        effect_net       : dl object for effectiveness network
%        thresholds       : [1-by-2] [thresh_1 (threshold for steathiness), thresh_2 (threshold for effectiveness)]
% Outputs:
%        test_score       : [scalar] the ratio of feasible attacks among all samples
%
% Author: Olugbenga Moses Anubi, Florida state university
%         Yu Zheng, Florida state university
% 08/19/2022

%% Testing performance with repect to the trained discriminators
thresh_1 = thresholds(1);
thresh_2 = thresholds(2);

n_test = 10000;
inp_size = gen_net.Layers(1, 1).InputSize;


Z_test        = 100*(0.5 - rand(inp_size,n_test,"single"));   % uniformly random noise as input
Z_tet_dlarray = dlarray(Z_test,"CB");                         % covert to dlarray

test_out = double(forward(gen_net,Z_tet_dlarray));

f1_out = forward(stealth_net,test_out) - thresh_1;
f2_out = forward(effect_net,test_out) - thresh_2;
test_score = sum((f1_out<=0) & (f2_out<=0))/n_test;
% disp("Testing score = " + num2str(test_score) + " ::: Target = " + num2str(alpha))

figure,
y_stealth = forward(stealth_net,test_out);
y_effect  = forward(effect_net,test_out);
subplot(121)
hold on, plot(y_stealth,'.')
title("Stealthiness ::: Threshold = " + num2str(thresh_1))
subplot(122)
hold on, plot(y_effect,'.')
title("Effectiveness ::: Threshold = " + num2str(thresh_2))

sgtitle("Testing Performance with discriminators")

%% Testing performance with repect to the model simulation
Z_attack_data = double(extractdata(test_out));
attack_data = ramp_attack_policy(Z_attack_data,t_sim_stop);
sim_obj = [];
[sim_obj, effect_index,stealth_index]  = get_simulation_object_sample_system(sim_obj,attack_data);

figure,
subplot(121)
hold on, plot(stealth_index,'.')
title("Stealthiness ::: Threshold = " + num2str(thresh_1))
subplot(122)
hold on, plot(effect_index,'.')
title("Effectiveness ::: Threshold = " + num2str(thresh_2))

sgtitle("Testing Performance with model simulation")