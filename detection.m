function residual = detection(r,r_nominal)
L = size(r,1);
residual = max(abs(r-r_nominal(end-L+1:end)));