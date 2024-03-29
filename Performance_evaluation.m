function [test_score_dis,test_score_sim,y_stealth,y_effect,stealth_index, effect_index] = Performance_evaluation(gen_net,stealth_net,effect_net,thresholds,n_test,t_sim_stop,plot_flag)
%% function test_score = Performance_evaluation(gen_net,stealth_net,effect_net,thresholds)
% two tests:
%           1) run generator, obtain stealth and effect indexes from discriminators
%           2) run generator, obtain stealth and effect indexes from model simualtion
% Inputs: 
%        gen_net          : dl object for generator network
%        stealth_net      : dl object for stealthiness network
%        effect_net       : dl object for effectiveness network
%        thresholds       : [1-by-2] [thresh_1 (threshold for steathiness), thresh_2 (threshold for effectiveness)]
%        n_test           : [scalar] number of test samples
%        t_sim_stop       : [scalar] total simulation time
%        plot_flag        : [false/true] plot flag for test performance
% Outputs:
%        test_score_dis       : [scalar] the ratio of feasible attacks among all samples (with discrimiantors)
%        test_score_sim       : [scalar] the ratio of feasible attacks among all samples (with model simualtion)
%        y_stealth            : [n_test-by-1] stealth index of test samples (with discrimiantors)
%        y_effect             : [n_test-by-1] effect index of test samples (with discrimiantors)
%        stealth_index        : [n_test-by-1] stealth index of test samples (with model simulation)
%        effect_index         : [n_test-by-1] effect index of test samples (with model simulation) 
%
% Author: Olugbenga Moses Anubi, Florida state university
%         Yu Zheng, Florida state university
% 08/19/2022

%% Testing performance with repect to the trained discriminators
thresh_1 = thresholds(1);
thresh_2 = thresholds(2);

inp_size = gen_net.Layers(1, 1).InputSize;


Z_test        = 100*(0.5 - rand(inp_size,n_test,"single"));   % uniformly random noise as input
Z_tet_dlarray = dlarray(Z_test,"CB");                         % covert to dlarray

test_out = double(forward(gen_net,Z_tet_dlarray));

y_stealth = extractdata(forward(stealth_net,test_out));
y_effect  = extractdata(forward(effect_net,test_out));

f1_out = y_stealth - thresh_1;
f2_out = thresh_2 - y_effect;

test_score_dis = sum((f1_out<=0) & (f2_out<=0))/n_test;
% disp("Testing score = " + num2str(test_score) + " ::: Target = " + num2str(alpha))

if plot_flag
    figure,
    subplot(121)
    hold on, plot(y_stealth,'.')
    hold on, plot(thresh_1*ones(1,n_test))
    title("Stealthiness")
    subplot(122)
    hold on, plot(y_effect,'.')
    hold on, plot(thresh_2*ones(1,n_test))
    title("Effectiveness")
    
    sgtitle("Testing Performance with discriminators")
end

%% Testing performance with repect to the model simulation
Z_attack_data = double(extractdata(test_out));

attack_start_time_interval  = round([0.1 0.2]*t_sim_stop);
attack_time_span_max_rate   = 0.3;
attack_max = 50;
policy_param = {attack_start_time_interval, attack_time_span_max_rate, attack_max};

attack_data = ramp_attack_policy(policy_param,Z_attack_data,t_sim_stop);

sim_obj = [];
[sim_obj, effect_index,stealth_index]  = get_simulation_object_sample_system(sim_obj,attack_data);

f1_out = stealth_index - thresh_1;
f2_out = thresh_2 - effect_index;

test_score_sim = sum((f1_out<=0) & (f2_out<=0))/n_test;

if plot_flag
    save('test_result','sim_obj','effect_index','stealth_index','Z_attack_data','-v7.3');
    
    figure,
    subplot(121)
    hold on, plot(stealth_index,'.')
    hold on, plot(thresh_1*ones(1,n_test))
    title("Stealthiness")
    subplot(122)
    hold on, plot(effect_index,'.')
    hold on, plot(thresh_2*ones(1,n_test))
    title("Effectiveness")
    
    sgtitle("Testing Performance with model simulation")
end