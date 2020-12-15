%{
    Yacine Mahdid 2020-01-08
    Modified by Danielle Nadin 2020-10-29
%}

%% Seting up the variables
clear % to keep only what is needed for this experiment
setup_experiments % see this file to edit the experiments

% Create output structure
result_hubs_contrast = struct();

result_hubs_contrast.BvP30 = struct();
result_hubs_contrast.BvP30.channels_location = struct();
result_hubs_contrast.BvP30.degree = [];
result_hubs_contrast.BvP30.normalized_degree = [];

% Iterate over the participants
for p = 1:length(participants)
    
    participant = participants{p};
    disp(strcat("Participant :", participant));
    
    hubs_input_path = strcat(output_path,filesep,'hubs',filesep,participant);
    
    % Iterate over the sessions
    for t = 1:length(sessions)
        session = sessions{t};
        disp(strcat("Session :",session));
        hubs_participant_input_path = strcat(hubs_input_path,filesep,session);
        
        %Iterate over number of comparisons (nstates-1)
        for s = 1:length(states)-1
            
            state_1 = states{1};
            state_2 = states{s+1};

            %Import power data for state 1 and state 2
            load(strcat(hubs_participant_input_path,filesep,state_1,'_hubs.mat'));
            
            %degree
            vector_1 = result_hubs.degree;
            channels_location_1 = result_hubs.channels_location;
          
            load(strcat(hubs_participant_input_path,filesep,state_2,'_hubs.mat'));
            
            %topographic distribution at peak alpha frequency
            vector_2 = result_hubs.degree;
            channels_location_2 = result_hubs.channels_location;            
            
            %Get common locations between states 1 and 2 
            hubs_common_location = get_common_location(channels_location_1,channels_location_2);
            result_hubs_contrast.BvP30.channels_location = hubs_common_location;
            
            %Filter the vectors to have the same size
            f_hubs_1 = filter_matrix(vector_1, channels_location_1, hubs_common_location);
            f_hubs_2 = filter_matrix(vector_2, channels_location_2, hubs_common_location);
            
            % Calculate contrast matrix
            hubs_contrast = f_hubs_2 - f_hubs_1; %post-baseline
            normalized_hubs_contrast = (hubs_contrast - mean(hubs_contrast,2))./std(hubs_contrast);
            
            result_hubs_contrast.BvP30.degree = hubs_contrast;
            result_hubs_contrast.BvP30.normalized_degree = normalized_hubs_contrast;
            
        end
        
        output_filename = strcat(hubs_participant_input_path,filesep,'hubs_contrasts.mat');
        save(output_filename,'result_hubs_contrast');
        
    end
end