function [loss,grad,net_state] = AG_indicator_loss(net,net_inp,target)
% loss function for training the indicator (discrimator networks)

[net_out,net_state] = forward(net,net_inp);
loss = mse(target, net_out);

grad = dlgradient(loss,net.Learnables);
