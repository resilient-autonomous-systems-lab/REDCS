function [test_score_dis,test_score_sim,y_distance,distance_index] = Performance_evaluation(gen_net,dis_net,thresholds,n_test,plot_flag)

thresh_1 = thresholds(1);
thresh_2 = thresholds(2);

%% plot parameters
out_size = gen_net.Layers(end-1,1).OutputSize;
t = linspace(0,2*pi,1000);
[U,S] = svd(eye(out_size));
z1_plot = sqrt(thresh_1)*U*(S^-0.5)*[cos(t);sin(t)];
z2_plot = sqrt(thresh_2)*U*(S^-0.5)*[cos(t);sin(t)];


%% Testing performance with repect to the trained discriminators
inp_size = gen_net.Layers(1, 1).InputSize;


Z_test        = 100*(0.5 - rand(inp_size,n_test,"single"));   % uniformly random noise as input
Z_tet_dlarray = dlarray(Z_test,"CB");                         % covert to dlarray

test_out = double(forward(gen_net,Z_tet_dlarray));

y_distance = extractdata(forward(dis_net,test_out));

f1_out = y_distance - thresh_1;
f2_out = thresh_2 - y_distance;

test_score_dis = sum((f1_out<=0) & (f2_out<=0))/n_test;
% disp("Testing score = " + num2str(test_score) + " ::: Target = " + num2str(alpha))

%% Testing performance with repect to the model simulation
Z_attack_data = double(extractdata(test_out));
% distance_index = sum(Z_attack_data.*Z_attack_data,1);
distance_index = target_fcn(Z_attack_data);

f1_out = distance_index - thresh_1;
f2_out = thresh_2 - distance_index;

test_score_sim = sum((f1_out<=0) & (f2_out<=0))/n_test;


if plot_flag
    save('test_result','distance_index','Z_attack_data','-v7.3');
    
    figure, plot(test_out(1,:),test_out(2,:), '.'), axis equal
    hold on, plot(z1_plot(1,:),z1_plot(2,:),'r');
    hold on, plot(z2_plot(1,:),z2_plot(2,:),'k');
    title("Testing Performance")
end