%{
    Yacine Mahdid 2020-01-08
    Modified by Danielle Nadin 2020-02-15

    Generate network hubs based on previously calculated wPLI matrix.

    * Warning: This experiment use the setup_experiments.m script to
    load variables. Therefore if you are trying to edit this code and you
    don't know what a variable mean take a look at the setup_experiments.m
    script.
%}

%% Seting up the variables
clear % to keep only what is needed for this experiment
setup_experiments % see this file to edit the experiments

% Create the hubs output directory
hubs_output_path = mkdir_if_not_exist(output_path,'hubs');
wpli_input_path = strcat(output_path,filesep,'wpli');

% Create average result struct
avg_data = struct();
avg_data.degree = zeros(length(states),97);
avg_data.degree_count = zeros(length(states),97);
avg_data.avg_degree = zeros(length(states),97);
avg_data.location = -1;


% Iterate over the participants
for p = 1:length(participants)
    
    % Create the participants directory
    participant = participants{p};
    disp(strcat("Participant :", participant));
    
    % Iterate over the sessions
    for t = 1:length(sessions)
        session = sessions{t};
        disp(strcat("Session :",session));
        hubs_participant_output_path =  mkdir_if_not_exist(hubs_output_path,strcat(participant,filesep,session));
        wpli_participant_input_path = strcat(wpli_input_path,filesep,participant,filesep,session);
        
        % Iterate over the states
        for s = 1:length(states)
            state = states{s};
            disp(strcat("State :", state));
            
            hubs_state_filename = strcat(hubs_participant_output_path,filesep,state,'_hubs.mat');
            
            % Load the wpli result
            data = load(strcat(wpli_participant_input_path,filesep,state,'_wpli.mat'));
            result_wpli = data.result_wpli;
            wpli_matrix  = result_wpli.data.avg_wpli;
            channels_location = result_wpli.metadata.channels_location;
            
            % Filter the channels location to match the filtered motifs
            [wpli_matrix,channels_location] = filter_non_scalp(wpli_matrix,channels_location);
            
            % Binarize the network
            t_network = threshold_matrix(wpli_matrix, hubs_param.threshold(p,t));
            b_network = binarize_matrix(t_network);
            
            % Calculate node degree
            deg = degrees_und(b_network);
            normalized_deg = (deg - mean(deg,2))./std(deg); %z-transform
            
            % Save the degree data into a structure and into disk
            % we need all the information for the next experiments
            result_hubs = struct();
            result_hubs.channels_location = channels_location;
            result_hubs.wpli_matrix = wpli_matrix;
            result_hubs.thresholded_wpli_matrix = t_network;
            result_hubs.binarized_wpli_matrix = b_network;
            result_hubs.threshold = hubs_param.threshold;
            result_hubs.degree = deg;
            result_hubs.normalized_degree = normalized_deg;
            
            save(hubs_state_filename, 'result_hubs');
            
            if hubs_param.figure
                figure
                topographic_map(result_hubs.normalized_degree,result_hubs.channels_location);
                title(strcat(participant," at ", session," ",state," ", " Hubs"))
                output_figure_path = strcat(hubs_participant_output_path,filesep,state,'_hubs.fig');
                savefig(output_figure_path)
                close(gcf)
            end 
        end
    end
end

function topographic_map(data,location)
topoplot(data,location,'maplimits','absmax', 'electrodes', 'off');
min_color = min(data);
max_color = max(data);
caxis([min_color max_color])
colormap('jet')
colorbar;
end