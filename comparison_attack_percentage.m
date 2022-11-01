%% Compare different attack percentage
close all
clear
clc

% please comment line 71 in Run_sim.m


% %% obtain test results
% thresh_1 = 0.5;  % threshold for stealthiness
% thresh_2 = 0.15;  % threshold for effectivness
% 
% % 1
% test_result1 = [];
% gen_net = load("1\q1\trained_network.mat").gen_net;
% attack_indices = load("1\q1\attack_support.mat").attack_indices;
% attack_percentage = 0.25;
% n_test = 150;
% test_performance;
% test_result1 = [test_result1; test_result];
% 
% gen_net = load("1\q2\trained_network.mat").gen_net;
% attack_indices = load("1\q2\attack_support.mat").attack_indices;
% attack_percentage = 0.25;
% n_test = 150;
% test_performance;
% test_result1 = [test_result1; test_result];
% 
% gen_net = load("1\q3\trained_network.mat").gen_net;
% attack_indices = load("1\q3\attack_support.mat").attack_indices;
% attack_percentage = 0.25;
% n_test = 150;
% test_performance;
% test_result1 = [test_result1; test_result];
% 
% gen_net = load("1\q4\trained_network.mat").gen_net;
% attack_indices = load("1\q4\attack_support.mat").attack_indices;
% attack_percentage = 0.25;
% n_test = 150;
% test_performance;
% test_result1 = [test_result1; test_result];
% 
% save("test_result1.mat", "test_result1",'-v7.3');
% 
% % 2
% test_result2 =[];
% gen_net = load("2\12\trained_network.mat").gen_net;
% attack_indices = load("2\12\attack_support.mat").attack_indices;
% attack_percentage = 0.5;
% n_test = 100;
% test_performance;
% test_result2 = [test_result2; test_result];
% 
% gen_net = load("2\13\trained_network.mat").gen_net;
% attack_indices = load("2\13\attack_support.mat").attack_indices;
% attack_percentage = 0.5;
% n_test = 100;
% test_performance;
% test_result2 = [test_result2; test_result];
% 
% gen_net = load("2\14\trained_network.mat").gen_net;
% attack_indices = load("2\14\attack_support.mat").attack_indices;
% attack_percentage = 0.5;
% n_test = 100;
% test_performance;
% test_result2 = [test_result2; test_result];
% 
% gen_net = load("2\23\trained_network.mat").gen_net;
% attack_indices = load("2\23\attack_support.mat").attack_indices;
% attack_percentage = 0.5;
% n_test = 100;
% test_performance;
% test_result2 = [test_result2; test_result];
% 
% gen_net = load("2\24\trained_network.mat").gen_net;
% attack_indices = load("2\24\attack_support.mat").attack_indices;
% attack_percentage = 0.5;
% n_test = 100;
% test_performance;
% test_result2 = [test_result2; test_result];
% 
% gen_net = load("2\34\trained_network.mat").gen_net;
% attack_indices = load("2\34\attack_support.mat").attack_indices;
% attack_percentage = 0.5;
% n_test = 100;
% test_performance;
% test_result2 = [test_result2; test_result];
% 
% save("test_result2.mat", "test_result2",'-v7.3');
% 
% % 3
% test_result3 = [];
% gen_net = load("3\123\trained_network.mat").gen_net;
% attack_indices = load("3\123\attack_support.mat").attack_indices;
% attack_percentage = 0.75;
% n_test = 150;
% test_performance;
% test_result3 = [test_result3; test_result];
% 
% gen_net = load("3\124\trained_network.mat").gen_net;
% attack_indices = load("3\124\attack_support.mat").attack_indices;
% attack_percentage = 0.75;
% n_test = 150;
% test_performance;
% test_result3 = [test_result3; test_result];
% 
% gen_net = load("3\134\trained_network.mat").gen_net;
% attack_indices = load("3\134\attack_support.mat").attack_indices;
% attack_percentage = 0.75;
% n_test = 150;
% test_performance;
% test_result3 = [test_result3; test_result];
% 
% gen_net = load("3\234\trained_network.mat").gen_net;
% attack_indices = load("3\234\attack_support.mat").attack_indices;
% attack_percentage = 0.75;
% n_test = 150;
% test_performance;
% test_result3 = [test_result3; test_result];
% 
% save("test_result3.mat", "test_result3",'-v7.3');
% 
% % 4
% gen_net = load("4\trained_network.mat").gen_net;
% attack_indices = load("4\attack_support.mat").attack_indices;
% attack_percentage = 1;
% n_test = 600;
% test_performance;
% test_result4 = test_result;
% 
% save("test_result4.mat", "test_result4",'-v7.3');


%% box plotting
test_result1 = load("test_result1.mat").test_result1;
test_result2 = load("test_result2.mat").test_result2;
test_result3 = load("test_result3.mat").test_result3;
test_result4 = load("test_result4.mat").test_result4;

LW = 2;
FS = 12;
figure

subplot(2,1,1)
effects = [test_result1(:,1), test_result2(:,1),test_result3(:,1),test_result4(:,1)];
boxplot(effects)
hold on, yline(5,LineWidth=LW)
xticks([1 2 3 4])
xticklabels({'25%','50%','75%','100%'})
yticks([5 10 15])
set(gca,"FontSize",FS)
xlabel('Attack Percentage')
ylabel('Effectivenss')
grid on

subplot(2,1,2)
detect = [test_result1(:,2), test_result2(:,2),test_result3(:,2),test_result4(:,2)];
boxplot(detect)
hold on, yline(0.5,LineWidth=LW)
xticks([1 2 3 4])
xticklabels({'25%','50%','75%','100%'})
yticks([0.3 0.5 0.7]);
set(gca,"FontSize",FS)
xlabel('Attack Percentage')
ylabel('Detection Probability')
grid on
