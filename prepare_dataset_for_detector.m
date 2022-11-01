%% prepare attack dataset for detector training
close all
clear all
clc

detector_train_flag = 1;
%% nominal dataset
try 
    nominal_dataset = load(nominal_dataset.mat).nominal_dataset;
catch
    attack_percentage = 1.0;
    Run_sim;
%     y = reshape(ya.Data,[size(ya.Data,3),size(ya.Data,1)]);
    y = y.Data(y.Time > detection_start,:);
    nominal_dataset = [y,zeros(size(y,1),1)];
    save nominal_dataset.mat nominal_dataset
end

%% random attack dataset
attack_percentage_list = [1.0, 0.75, 0.5, 0.25];
num = [4, 3, 2, 1];

attack_dataset = [];
for iter=1:length(attack_percentage_list)
    for ii = 1:5
        delete attack_support.mat;
    
        attack_percentage = attack_percentage_list(iter);
        Run_sim;
    
        %% Attack data
        Z_attack_data    = rand(3*n_attacked_nodes,50);
        attack_data = ramp_attack_policy(policy_param,Z_attack_data);
    
        %% getting simulation object
        sim_obj = [];
        [sim_obj]  = get_simulation_object_sample_system(sim_obj,attack_data,attack_percentage);
    
        %% append dataset
        miniBatchSize = length(sim_obj);
        
        for iter1 = 1:miniBatchSize
            y = sim_obj(iter1).measurements;
%             y = reshape(ya.Data,[size(ya.Data,3),size(ya.Data,1)]);
            y = y.Data(y.Time > detection_start,:);
            attack_dataset_batch = [y,ones(size(y,1),1)];
            attack_dataset = [attack_dataset; attack_dataset_batch];
        end
    end
end

total_dataset = [attack_dataset; repmat(nominal_dataset,50,1)];
mix_idx = randperm(size(total_dataset,1),size(total_dataset,1));
total_dataset = total_dataset(mix_idx,:);
save('total_dataset.mat','total_dataset','-v7.3');




