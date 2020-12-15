%{
    Danielle Nadin 2020-10-15
    Healthy TDCS study.

    Extract and format cosine similarity of network motifs for statistical analysis.

%}

%% Seting up the variables 
clear % to keep only what is needed for this experiment
close all 
setup_experiments % see this file to edit the experiments

% Create power output directory
motif_output_path = mkdir_if_not_exist(output_path,'motif');

% Create variables for output 
id = {};
ses = {};
sta = {};
motif1_cs = [];
motif7_cs = [];

%% Loop over participants, sessions and states

% Iterate over the participants
for p = 1:length(participants)
    
    % Create the participants directory
    participant = participants{p};
    disp(strcat("Participant: ", participant));
    motif_participant_output_path =  mkdir_if_not_exist(motif_output_path, participant);
 
    % Iterate over sessions
    for t = 1:length(sessions)
        session = sessions{t};
        motif_participant_session_output_path =  mkdir_if_not_exist(motif_participant_output_path, session);
        
        % Load baseline motif data
        base = load(strcat(motif_participant_session_output_path,filesep,states{1},'_motif.mat'));
        
        % Iterate over the states
        for s = 2:length(states)
            state = states{s};
            disp(strcat("State: ", state));
            
            % Load the motif data to compare to baseline
            alt = load(strcat(motif_participant_session_output_path,filesep,state,'_motif.mat'));
            
            %% Compute and format cosine similarity
            
            id = [id ; participants{p}];
            ses = [ses ; sessions{t}];
            sta = [sta ; states{s}];
            
            % check if number of channels is the same
            if size(base.result_motif.frequency,2) == size(alt.result_motif.frequency,2)
                base_vector_motif1 = normalize(base.result_motif.frequency(1,:));
                alt_vector_motif1 = normalize(alt.result_motif.frequency(1,:));
                base_vector_motif7 = normalize(base.result_motif.frequency(7,:));
                alt_vector_motif7 = normalize(alt.result_motif.frequency(7,:));
            else
                % normalize number of channels 
                vector_1 = {base.result_motif.channels_location.labels};
                vector_2 = {alt.result_motif.channels_location.labels};
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

                base_vector_motif1 = normalize(base.result_motif.frequency(1,ind_vector_1));
                alt_vector_motif1 = normalize(alt.result_motif.frequency(1,ind_vector_2));
                base_vector_motif7 = normalize(base.result_motif.frequency(7,ind_vector_1));
                alt_vector_motif7 = normalize(alt.result_motif.frequency(7,ind_vector_2));
            end
            
            %compute cosine similarity
            cosine_similarity_motif1 = vector_cosine_similarity(base_vector_motif1,alt_vector_motif1);
            motif1_cs = [motif1_cs ; cosine_similarity_motif1];
            cosine_similarity_motif7 = vector_cosine_similarity(base_vector_motif7,alt_vector_motif7);
            motif7_cs = [motif7_cs ; cosine_similarity_motif7];
                         
        end
        
    end
end

%create table of results
motif_metrics = table(id,ses,sta,motif1_cs,motif7_cs);
writetable(motif_metrics,motif_param.file_name)