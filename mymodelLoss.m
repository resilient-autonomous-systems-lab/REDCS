function [gradients,net_state,loss] = mymodelLoss(net,z,sim_inp,n_meas,attack_indices,stealthiness_tol, effectiveness_tol, r_nominal, yc_nominal)

%% run network
[net_output,net_state] = forward(net,z);
% attack = am_scale * net_output;
batch_size       = length(sim_inp);
n_attacked_nodes = length(attack_indices);

%% Run simulation in parralel 
for iter = 1:batch_size
    attack_start_times      = 2*ones(n_meas,1);
    attack_full_times       = attack_start_times +  10;
    attack_final_deviations = zeros(n_meas,1);

    attack_start_times(attack_indices)      = 5*net_output(1:n_attacked_nodes,iter);
    attack_full_times(attack_indices)       = attack_start_times(attack_indices) + 10*net_output(n_attacked_nodes+1:2*n_attacked_nodes,iter);
    attack_final_deviations(attack_indices) = 2*net_output(2*n_attacked_nodes+1:3*n_attacked_nodes,iter);

    sim_inp(iter) = sim_inp(iter).setVariable('attack_start_times',attack_start_times);
    sim_inp(iter) = sim_inp(iter).setVariable('attack_full_times',attack_full_times);
    sim_inp(iter) = sim_inp(iter).setVariable('attack_final_deviations',attack_final_deviations);
end

sim_out = parsim(sim_inp);

%% calculate effectiveness and stealthiness
[yc_error, r_error] = get_error_from_nominal(sim_out,yc_nominal,r_nominal);


% effectiveness = zeros(1,batch_size);
% stealthiness  = zeros(1,batch_size);
% 
% for iter = 1:batch_size
%     %% prepare the test attack signal
% %     attack_sim = double(gather(extractdata(attack(:,iter))));  % covert dlarray back to normal array which can be used in simulink
% %     attack_sim_t = timeseries(kron(ones(10,1),attack_sim.'));  % create timeseries object
% %     assignin('base','attack_sim',attack_sim_t)                 % assign the attack data to workspace in order to be used in simulink model
% % 
% %     %% run simulation
% %     out = sim('sample_system');
% %     measurements = out.measurements;
% %     states = out.states;
% %     estiamte = out.estimate;
%     detection_start = sim_inp(iter).Variables(10).Value;
%     critical_meas_time_series = sim_out(iter).critical_measurement;
%     critical_meas = critical_meas_time_series.data(critical_meas_time_series.time>=detection_start); % get critical measurement after detection start
%     
%     r_time_series = sim_out(iter).residual;
%     r = r_time_series.data(r_time_series.time>=detection_start);  % get detection ressidual after detection start
%     
% 
%     %% metrics
%     effectiveness(1,iter) = effectiveness(critical_meas, yc_nominal);
%     stealthiness(1,iter) = detection(r, r_nominal);
% end

%% calculate loss 
yc_error_gpu = gpuArray(dlarray(yc_error,"CB"));
r_error_gpu  = gpuArray(dlarray(r_error,"CB"));
my_relu = @(x) x.*(x>=0);
loss = sum(my_relu(effectiveness_tol - yc_error_gpu) + my_relu(r_error_gpu - stealthiness_tol))/batch_size;

%% calculate grdients: THIS IS A BIG QUESTION MARK.
gradients = dlgradient(loss,net.Learnables);


