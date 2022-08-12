n = 100; % number of bins
M = 2;  % input size cutt-off
input_bin_edges      = [-inf linspace(-M,M,n-1) inf];
output_bin_edges     = [0 logsig(input_bin_edges(2:end-1)) 1];
uniform_output_edges = linspace(0,1,n+1);

n_samples = 100000;
input_samples = M*2*(0.5-rand(n_samples,1));
output_samples = logsig(input_samples);


figure,
subplot(311)
histogram(input_samples,input_bin_edges);
title('Input histogram')

subplot(312)
histogram(output_samples,output_bin_edges);
title('Output histogram nonuniform')

subplot(313)
histogram(output_samples,uniform_output_edges);
title('Output histogram nonuniform')