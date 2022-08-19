function test_score = Performance_evaluation(gen_net,stealth_net,effect_net,thresholds)

%% Testing performance
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

sgtitle("Testing Performance")
