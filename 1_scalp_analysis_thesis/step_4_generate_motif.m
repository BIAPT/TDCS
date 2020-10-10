%{
    Modified by Danielle Nadin 2020-05-01
    Yacine Mahdid 2020-01-08
    This script will calculate the motif on the dpli matrices at
    alpha generated previously in the experiment 14. It will save them at
    the same place as the pli matrices. This  alculate the distance and the
    sink information.

    * Warn  ing: This e xperiment use the setup_experiments.m script to
    load variables. Therefore if you are trying to edit this code and you
    don't know what a varia ble mean take a look at the setup_experiments.m
    script.
%} 
 
%% Seting up the variables
clear % to keep only what is need ed for this experiment
setup_experiments % see this file to edit the experiments

% Create the motif output    directory
motif_output_path = mkdir_if_not_exist(output_path,'motif');
dpli_input_path = strcat(output_path,filesep,'dpli');

% Iterate over the participants
for p = 1:length(participants)
    
    % Create the participants directory
    participant = participants{p};
    disp(strcat("Participant :", participant));
    
    % Iterate over the sessions
    for t = 1:length(sessions)
        session = sessions{t};
        disp(strcat("Session : ",session));
        motif_participant_output_path =  mkdir_if_not_exist(motif_output_path,strcat(participant,filesep,session));
        dpli_participant_input_path = strcat(dpli_input_path,filesep,participant,filesep,session);
        
        % Iterate over the states
        for s = 1:length(states)
            state = states{s};
            disp(strcat("State :", state));
            
            motif_state_filename = strcat(motif_participant_output_path,filesep,state,'_motif.mat');
            
            % Load the wpli result
            data = load(strcat(dpli_participant_input_path,filesep,state,'_dpli.mat'));
            result_dpli = data.result_dpli;
            dpli_matrix  = result_dpli.data.avg_dpli;
            channels_location = result_dpli.metadata.channels_location;
            
            % Transform the dpli into phase lead
            phase_lead_matrix = make_phase_lead(dpli_matrix);
            
            % Filter the channels location to match the filtered motifs
            [phase_lead_matrix,channels_location] = filter_non_scalp(phase_lead_matrix,channels_location);
            
            % Calculate motif with 3 connection
            [frequency, source, target, distance] = motif_3(phase_lead_matrix, ...
                channels_location, motif_param.number_rand_network, ...
                motif_param.bin_swaps, motif_param.weight_frequency);
            
            % Save the motif data into a structure and into disk
            % we need all the information for the next experiments
            result_motif = struct();
            result_motif.channels_location = channels_location;
            result_motif.dpli_matrix = dpli_matrix;
            result_motif.phase_lead_matrix = phase_lead_matrix;
            result_motif.frequency = frequency;
            result_motif.source = source;
            result_motif.target = target;
            result_motif.distance = distance;
            
            save(motif_state_filename, 'result_motif');
            
            if motif_param.figure
                motif_ids = [1,7];
                for m = 1:length(motif_ids)
                    motif_id = motif_ids(m);
                    disp(strcat("Analyzing motif: ",string(motif_id)));
                      
                    % Create the motif figure
                    freq = result_motif.frequency(motif_id, :);
                    source = result_motif.source(motif_id, :);
                    dist = result_motif.distance(motif_id, :);
                    location = result_motif.channels_location;
                    
                    % Get the Z-Score of each values to plot in the topographic map
                    n_freq = normalize_motif(freq);
                    n_source = normalize_motif(source);
                    n_distance = normalize_motif(dist);
                    
                    title_name = strcat(participant," at ", session," ", state, " for Motif ", string(motif_id));
                    output_figure_path = strcat(motif_participant_output_path,filesep,state,'_motif_',string(motif_id),'.fig');
                    plot_motif(n_freq, n_source, n_distance, location, title_name);
                    savefig(output_figure_path)
                    close(gcf)
                           
                end  
            end
            
        end
    end  
end