function [sim_out, effect_index,stealth_index] = get_simulation_object_sample_system(sim_inp_in,attack_data)
% Returns an array of Simulink.SimulationInput object for parrallel
% execution
%
%       This function is specific to the sample_system used to develop the code.
%       Use this as a template to create get_simulation_objec_*** for the
%       relevant system later.
%
%
% Input:
% - batch_size [Integer]: The size of object to return

% Olugbenga Moses Anubi 7/29/2022


%% Parameters
batch_size = size(attack_data,2);

%% load system parameters 
%*******************************************
% REPLACE WITH CALL TO RELEVANT RUNFILE
%*******************************************
Run_sim  


%% Simulation objects

% NOTE: All variables will be supplied by a call to the run file 
%                     (Run_Sim in this case)
if(isempty(sim_inp_in))

    model = 'sample_system';
    load_system(model);

    % build rapid accelerator target
    Simulink.BlockDiagram.buildRapidAcceleratorTarget(model);

    % simulation input objects'
    sim_inp = repmat(Simulink.SimulationInput(model),batch_size,1);
    for iter = 1:batch_size

        sim_inp(iter) = sim_inp(iter).setModelParameter('SimulationMode','rapid-accelerator');
        sim_inp(iter) = sim_inp(iter).setModelParameter('RapidAcceleratorUpToDateCheck','off');

        sim_inp(iter) = sim_inp(iter).setVariable('A',A);
        sim_inp(iter) = sim_inp(iter).setVariable('B',B);
        sim_inp(iter) = sim_inp(iter).setVariable('C',C);
        sim_inp(iter) = sim_inp(iter).setVariable('Cc',Cc);
        sim_inp(iter) = sim_inp(iter).setVariable('x0',x0);
        sim_inp(iter) = sim_inp(iter).setVariable('x_hat0',x_hat0);
        sim_inp(iter) = sim_inp(iter).setVariable('K',K);
        sim_inp(iter) = sim_inp(iter).setVariable('L',L);

        sim_inp(iter) = sim_inp(iter).setVariable('noise_trigger',1);
        sim_inp(iter) = sim_inp(iter).setVariable('noise_seed',randi(100));

        sim_inp(iter) = sim_inp(iter).setVariable('t_sim_stop',t_sim_stop);
        sim_inp(iter) = sim_inp(iter).setVariable('detection_start',detection_start);

    end
else
    sim_inp = sim_in_in;
end

%% Run simulation in parralel 
for iter = 1:batch_size
    attack_start_times      = 2*ones(n_meas,1);
    attack_full_times       = attack_start_times +  10;
    attack_final_deviations = zeros(n_meas,1);

    attack_start_times(attack_indices)      = attack_data(1:n_attacked_nodes,iter);
    attack_full_times(attack_indices)       = attack_start_times(attack_indices) + attack_data(n_attacked_nodes+1:2*n_attacked_nodes,iter);
    attack_final_deviations(attack_indices) = attack_data(2*n_attacked_nodes+1:3*n_attacked_nodes,iter);

    sim_inp(iter) = sim_inp(iter).setVariable('attack_start_times',attack_start_times);
    sim_inp(iter) = sim_inp(iter).setVariable('attack_full_times',attack_full_times);
    sim_inp(iter) = sim_inp(iter).setVariable('attack_final_deviations',attack_final_deviations);
end

sim_out = parsim(sim_inp);

%% prune the error simulation outputs


%% calculate effectiveness and stealthiness
[effect_index, stealth_index] = get_error_from_nominal(sim_out,yc_nominal,r_nominal);
