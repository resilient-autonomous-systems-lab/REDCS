detector_train_flag = 0;
attack_percentage = 1;
Run_sim;

attack_data = ramp_attack_policy(policy_param,z_attack_data);

% define attack parameters in simulation
attack_start_times      = attack_start_injection*ones(n_meas,1);
attack_full_times       = attack_start_times +  100;
attack_final_deviations = zeros(n_meas,1);

attack_start_times(attack_indices)      = attack_data(1:n_attacked_nodes);
attack_full_times(attack_indices)       = attack_start_times(attack_indices) + attack_data(n_attacked_nodes+1:2*n_attacked_nodes);
attack_final_deviations(attack_indices) = attack_data(2*n_attacked_nodes+1:3*n_attacked_nodes);

%% run simulation
out = sim("sample_system.slx");

y = out.measurements;
ya = out.attacked_measurements;
ya_time = ya.Time;
ya_data = reshape(ya.Data,size(ya.Data,1),size(ya.Data,3)).';

%% plot results
LW = 1.5;
FS = 1.5;
figure
% nominal plot
subplot(4,3,1);
plot(y_nominal.Time(y_nominal.Time>detection_start),y_nominal.Data(y_nominal.Time>detection_start,1),'k-',LineWidth=LW);
ylabel('q_1',FontSize=FS);
title('Nominal measurements');
hold on, yline(q_ref*(1+eta),'r--',LineWidth=LW);
hold on, yline(q_ref*(1-eta),'r--',LineWidth=LW);
subplot(4,3,4);
plot(y_nominal.Time(y_nominal.Time>detection_start),y_nominal.Data(y_nominal.Time>detection_start,2),'k-',LineWidth=LW);
ylabel('q_2',FontSize=FS);
subplot(4,3,7);
plot(y_nominal.Time(y_nominal.Time>detection_start),y_nominal.Data(y_nominal.Time>detection_start,3),'k-',LineWidth=LW);
ylabel('q_3',FontSize=FS);
subplot(4,3,10);
plot(y_nominal.Time(y_nominal.Time>detection_start),y_nominal.Data(y_nominal.Time>detection_start,4),'k-',LineWidth=LW);
ylabel('q_4',FontSize=FS);
hold on, yline(q_ref*(1+eta),'r--',LineWidth=LW);
hold on, yline(q_ref*(1-eta),'r--',LineWidth=LW);

% attacked real plot
subplot(4,3,2);
plot(y.Time(y.Time>detection_start),y.Data(y.Time>detection_start,1),'k-',LineWidth=LW);
title('Real measurements')
hold on, yline(q_ref*(1+eta),'r--',LineWidth=LW);
hold on, yline(q_ref*(1-eta),'r--',LineWidth=LW);
subplot(4,3,5);
plot(y.Time(y.Time>detection_start),y.Data(y.Time>detection_start,2),'k-',LineWidth=LW);
subplot(4,3,8);
plot(y.Time(y.Time>detection_start),y.Data(y.Time>detection_start,3),'k-',LineWidth=LW);
subplot(4,3,11);
plot(y.Time(y.Time>detection_start),y.Data(y.Time>detection_start,4),'k-',LineWidth=LW);
hold on, yline(q_ref*(1+eta),'r--',LineWidth=LW);
hold on, yline(q_ref*(1-eta),'r--',LineWidth=LW);


% attacked real plot
subplot(4,3,3);
plot(ya_time(ya_time>detection_start),ya_data(ya_time>detection_start,1),'k-',LineWidth=LW);
title('Attacked measurements');
hold on, yline(q_ref*(1+eta),'r--',LineWidth=LW);
hold on, yline(q_ref*(1-eta),'r--',LineWidth=LW);
ylim([8.9 14])
subplot(4,3,6);
plot(ya_time(ya_time>detection_start),ya_data(ya_time>detection_start,2),'k-',LineWidth=LW);
subplot(4,3,9);
plot(ya_time(ya_time>detection_start),ya_data(ya_time>detection_start,3),'k-',LineWidth=LW);
subplot(4,3,12);
plot(ya_time(ya_time>detection_start),ya_data(ya_time>detection_start,4),'k-',LineWidth=LW);
hold on, yline(q_ref*(1+eta),'r--',LineWidth=LW);
hold on, yline(q_ref*(1-eta),'r--',LineWidth=LW);
ylim([8.9 20])