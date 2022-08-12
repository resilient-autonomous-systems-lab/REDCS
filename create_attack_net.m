function net = create_attack_net(inp_size,out_size)

layers = [
    featureInputLayer(inp_size,"Name","input")
    
    fullyConnectedLayer(64,"Name","fc_1")
    reluLayer("Name","relu_1")
    
    fullyConnectedLayer(1024,"Name","fc_2")
    reluLayer("Name","relu_2")
    
    fullyConnectedLayer(out_size,"Name","fc_3")
    sigmoidLayer("Name","sigmoid")];

net = dlnetwork(layers);

% deepNetworkDesigner(layers);
figure,
plot(layerGraph(layers));
 

end