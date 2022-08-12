function [gen_net_loss,gen_net_grad,gen_net_state] = AG_generator_loss(gen_net,descriminator_output, thresholds, batch_size)
% loss function for training the generator (generator network)

% % Eenerating random input samples
% Z         = rand(gen_net.Layers(1).InputSize, batch_size);
% Z_dlarray = dlarray(Z,'CB');

% % Executing generator network
% [gen_net_out,gen_net_state] = forward(gen_net,Z_dlarray);

% Executing descriminator networks
stl_net_out = descriminator_output(1,:); % forward(stealth_net,gen_net_out);
eff_net_out = descriminator_output(2,:); % forward(effect_net,gen_net_out);

% Calculating the loss and gradients
stealth_threshold = thresholds(1);
effect_threshold  = thresholds(2);
gen_net_loss = sum(my_relu(effect_threshold - eff_net_out) + my_relu(stl_net_out - stealth_threshold))/batch_size;

gen_net_grad = dlgradient(gen_net_loss,gen_net.Learnables);

gen_net_state = gen_net.State;



function out = my_relu(x)
out = x.*(x>=0);