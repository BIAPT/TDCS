%{
    Yacine Mahdid 2020-01-08
    Modified by Danielle Nadin 2020-10-29
%}

%% Seting up the variables
clear % to keep only what is needed for this experiment
setup_experiments % see this file to edit the experiments

% Create output structure
result_power_contrast = struct();

result_power_contrast.BvP30 = struct();
result_power_contrast.BvP30.channels_location = struct();
result_power_contrast.BvP30.td = [];
result_power_contrast.BvP30.normalized_td = [];

% Iterate over the participants
for p = 1:length(participants)
    
    participant = participants{p};
    disp(strcat("Participant :", participant));
    
    power_input_path = strcat(output_path,filesep,'power',filesep,participant);
    
    % Iterate over the sessions
    for t = 1:length(sessions)
        session = sessions{t};
        disp(strcat("Session :",session));
        power_participant_input_path = strcat(power_input_path,filesep,session);
        
        %Iterate over number of comparisons (nstates-1)
        for s = 1:length(states)-1
            
            state_1 = states{1};
            state_2 = states{s+1};

            %Import power data for state 1 and state 2
            load(strcat(power_participant_input_path,filesep,state_1,'_power.mat'));
            
            %topographic distribution at peak alpha frequency
            vector_1 = result_peak_td.data.filt_power;
            channels_location_1 = result_peak_td.data.filt_location;
          
            load(strcat(power_participant_input_path,filesep,state_2,'_power.mat'));
            
            %topographic distribution at peak alpha frequency
            vector_2 = result_peak_td.data.filt_power;
            channels_location_2 = result_peak_td.data.filt_location;            
            
            %Get common locations between states 1 and 2 
            power_common_location = get_common_location(channels_location_1,channels_location_2);
            result_power_contrast.BvP30.channels_location = power_common_location;
            
            %Filter the vectors to have the same size
            f_power_1 = filter_matrix(vector_1, channels_location_1, power_common_location);
            f_power_2 = filter_matrix(vector_2, channels_location_2, power_common_location);
            
            % Calculate contrast matrix
            power_contrast = f_power_2 - f_power_1; %post-baseline
            normalized_power_contrast = (power_contrast - mean(power_contrast,2))./std(power_contrast);
            
            result_power_contrast.BvP30.td = power_contrast;
            result_power_contrast.BvP30.normalized_td = normalized_power_contrast;
            
        end
        
        output_filename = strcat(power_participant_input_path,filesep,'power_contrasts.mat');
        save(output_filename,'result_power_contrast');
        
    end
end