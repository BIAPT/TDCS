%{
    Danielle Nadin 2020-10-14
    Healthy TDCS study.

    Extract and format the following scalp EEG metrics (9 metrics) for statistical analysis:
    - Clustering coefficient
    - Global efficiency
    - Modularity
    - Binary small-worldness
%}

%% Seting up the variables 
clear % to keep only what is needed for this experiment
close all 
setup_experiments % see this file to edit the experiments

% Create power output directory
graph_output_path = mkdir_if_not_exist(output_path,'graph theory');

% Create variables for output 
id = {};
ses = {};
sta = {};
geff = [];
cc = [];
mod = [];
bsw = [];

%% Loop over participants, sessions and states

% Iterate over the participants
for p = 1:length(participants)
    
    % Create the participants directory
    participant = participants{p};
    disp(strcat("Participant: ", participant));
    graph_participant_output_path =  mkdir_if_not_exist(graph_output_path, participant);
    
    % Iterate over sessions
    for t = 1:length(sessions)
        session = sessions{t};
        graph_participant_session_output_path =  mkdir_if_not_exist(graph_participant_output_path, session);
        
        % Load the graph theory data
        load(strcat(graph_participant_session_output_path,filesep,'_graph_theory.mat'));
            
        % Iterate over the states
        for s = 1:length(states)
            state = states{s};
            disp(strcat("State: ", state));
            
            %% Format graph theory metrics
            
            id = [id ; participants{p}];
            ses = [ses ; sessions{t}];
            sta = [sta ; states{s}];
            
            geff = [geff ; result_graph.geff(s)];
            cc = [cc ; result_graph.clustering_coef(s)];
            mod = [mod ; result_graph.mod(s)];
            bsw = [bsw ; result_graph.bsw(s)];
                         
        end
        
    end
end

%create table of results
graph_metrics = table(id,ses,sta,geff,cc,mod,bsw);
writetable(graph_metrics,graph_param.file_name)