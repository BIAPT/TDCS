%{
    Danielle Nadin 2020-10-15
    Healthy TDCS study.

    Extract and format cosine similarity of network hubs for statistical analysis.

%}

%% Seting up the variables 
clear % to keep only what is needed for this experiment
close all 
setup_experiments % see this file to edit the experiments

% Create power output directory
hub_output_path = mkdir_if_not_exist(output_path,'hubs_max_custom_threshold');

% Create variables for output 
id = {};
ses = {};
sta = {};
deg_cs = [];

%% Loop over participants, sessions and states

% Iterate over the participants
for p = 1:length(participants)
    
    % Create the participants directory
    participant = participants{p};
    disp(strcat("Participant: ", participant));
    hub_participant_output_path =  mkdir_if_not_exist(hub_output_path, participant);
 
    % Iterate over sessions
    for t = 1:length(sessions)
        session = sessions{t};
        hub_participant_session_output_path =  mkdir_if_not_exist(hub_participant_output_path, session);
        
        % Load baseline hub data
        base = load(strcat(hub_participant_session_output_path,filesep,states{1},'_hubs.mat'));
        
        % Iterate over the states
        for s = 2:length(states)
            state = states{s};
            disp(strcat("State: ", state));
            
            % Load the hub data to compare to baseline
            alt = load(strcat(hub_participant_session_output_path,filesep,state,'_hubs.mat'));
            
            %% Compute and format cosine similarity
            
            id = [id ; participants{p}];
            ses = [ses ; sessions{t}];
            sta = [sta ; states{s}];
            
            % check if number of channels is the same
            if length(base.result_hubs.normalized_degree) == length(alt.result_hubs.normalized_degree)
                base_vector = base.result_hubs.normalized_degree;
                alt_vector = alt.result_hubs.normalized_degree;
            else
                % normalize number of channels 
                vector_1 = {base.result_hubs.channels_location.labels};
                vector_2 = {alt.result_hubs.channels_location.labels};
                intersection = intersect(vector_1,vector_2,'stable');
                
                ind_vector_1 = [];
                ind_vector_2 = [];
                
                for i = 1:length(vector_1)
                    for j = 1:length(intersection)
                        if strcmp(vector_1{i},intersection{j})
                            ind_vector_1 = [ind_vector_1 i];
                        end
                    end
                end
                
                for i = 1:length(vector_2)
                    for j = 1:length(intersection)
                        if strcmp(vector_2{i},intersection{j})
                            ind_vector_2 = [ind_vector_2 i];
                        end
                    end
                end

                base_vector = base.result_hubs.normalized_degree(ind_vector_1);
                alt_vector = alt.result_hubs.normalized_degree(ind_vector_2);
            end
            
            %compute cosine similarity
            cosine_similarity = vector_cosine_similarity(base_vector,alt_vector);
            deg_cs = [deg_cs ; cosine_similarity];
                         
        end
        
    end
end

%create table of results
hub_metrics = table(id,ses,sta,deg_cs);
writetable(hub_metrics,'hub_metrics_T1_max_custom_threshold.csv')