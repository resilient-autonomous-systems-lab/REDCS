function effect = effectiveness(critical_meas,yc_nominal)
L = size(critical_meas,1);
effect = mean(vecnorm(critical_meas-yc_nominal(end-L+1:end),2,2));