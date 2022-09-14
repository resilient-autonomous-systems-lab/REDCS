function [yc_error, r_error] = get_error_from_nominal(sim_out,detection_start)
% Returns the stealthiness and effectiveness error vectors between the
% simulated output and nominal values
% 
% Inputs:
%   - sim_out [N-by-1]: Array of Simulink.SimulationOutput objects
%   - yc_nominal: A timeseries object of nominal critical values
%   - r_nominal : A timeseries object of nominal observer residual values
%
% Outputs:
%   - yc_error [N-by-1]: Error between simulated and nominal critical values
%   - r_error  N-by-1] : Error between simulated and nominal residual values

% Olugbenga Moses Anubi 7/8/2022

nominal_index = load("nominal_index.mat");
yc_nominal = nominal_index.yc_nominal;

detector_net = load("Detector.mat").detector_net;

miniBatchSize = length(sim_out);

yc_error = zeros(miniBatchSize,1);
r_error  = zeros(miniBatchSize,1);

for iter = 1:miniBatchSize
    Time_iter = sim_out(iter).critical_measurement.Time;
    yc_error_signal = sim_out(iter).critical_measurement.Data - resample(yc_nominal,Time_iter).Data;
    yc_error_signal = yc_error_signal(Time_iter>detection_start,:);
    
    y = sim_out(iter).measurements.Data;
    y = y(Time_iter>detection_start,:);
    y_dlarray = dlarray(y,"BC");
    residual  = double(extractdata(predict(detector_net,y_dlarray)));
%     residual = timeseries(residual.',y.Time);
%     r_error_signal  = vecnorm(residual.Data - resample(r_nominal,Time_iter).Data,2,2);

%     yc_error(iter) = trapz(Time_iter,yc_error_signal.^2);
%     r_error(iter)  = trapz(Time_iter,r_error_signal.^2);
    yc_error(iter) = mean(vecnorm(yc_error_signal,2,2));
    r_error(iter) = max(residual);
end