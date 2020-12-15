%{
    Yacine Mahdid 2020-01-08
    Modified by Danielle Nadin 2020-10-30
%}

%% Seting up the variables
clear % to keep only what is needed for this experiment
setup_experiments % see this file to edit the experiments

% Create output structure
result_motif_contrast = struct();

result_motif_contrast.BvP30 = struct();
result_motif_contrast.BvP30.channels_location = struct();
result_motif_contrast.BvP30.motif_frequency = [];
result_motif_contrast.BvP30.motif_normalized_frequency = [];

% Iterate over the participants
for p = 1:length(participants)
    
    participant = participants{p};
    disp(strcat("Participant :", participant));
    
    motif_input_path = strcat(output_path,filesep,'motif',filesep,participant);
    
    % Iterate over the sessions
    for t = 1:length(sessions)
        session = sessions{t};
        disp(strcat("Session :",session));
        motif_participant_input_path = strcat(motif_input_path,filesep,session);
        
        %Iterate over number of comparisons (nstates-1)
        for s = 1:length(states)-1
            
            state_1 = states{1};
            state_2 = states{s+1};
            
            %Import motif data for state 1 and state 2
            load(strcat(motif_participant_input_path,filesep,state_1,'_motif.mat'));
            matrix_1_motif = result_motif.frequency;
            channels_location_1 = result_motif.channels_location;
            
            load(strcat(motif_participant_input_path,filesep,state_2,'_motif.mat'));
            matrix_2_motif = result_motif.frequency;
            channels_location_2 = result_motif.channels_location;
            
            %Get common locations between states 1 and 2
            motif_common_location = get_common_location(channels_location_1,channels_location_2);
            
            result_motif_contrast.BvP30.channels_location = motif_common_location;
                       
            %Filter the vectors to have the same size
            f_motif_1 = filter_matrix(matrix_1_motif, channels_location_1, motif_common_location);
            f_motif_2 = filter_matrix(matrix_2_motif, channels_location_2, motif_common_location);
            
            % Calculate contrast matrix
            motif_contrast = f_motif_2 - f_motif_1; %post-baseline
            normalized_motif_contrast = (motif_contrast - mean(motif_contrast,2))./std(motif_contrast);

            result_motif_contrast.BvP30.frequency = motif_contrast;
            result_motif_contrast.BvP30.normalized_frequency = normalized_motif_contrast;
            
        end
        
        output_filename = strcat(motif_participant_input_path,filesep,'motif_contrasts.mat');
        save(output_filename,'result_motif_contrast');
        
    end
end