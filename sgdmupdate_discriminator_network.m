
function [net, loss, velocity] = sgdmupdate_discriminator_network(net,velocity,loss_handle,net_inp,net_out,learnRate,momentum)

[loss,gradients,state] = dlfeval(loss_handle,net,net_inp,net_out);
net.State = state;


% Update the network parameters using the SGDM optimizer.
[net,velocity] = sgdmupdate(net,gradients,velocity,learnRate,momentum);

