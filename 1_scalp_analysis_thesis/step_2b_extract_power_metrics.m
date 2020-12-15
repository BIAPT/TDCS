%{
    Danielle Nadin 2020-10-14
    Healthy TDCS study.

    Extract and format the following scalp EEG metrics (9 metrics) for statistical analysis:
    - Absolute power (delta, theta, alpha, beta)
    - Absolute power (peak alpha frequency)
    - Relative power (delta, theta, alpha, beta)
%}

%% Seting up the variables 
clear % to keep only what is needed for this experiment
close all 
setup_experiments % see this file to edit the experiments

% Create power output directory
power_output_path = mkdir_if_not_exist(output_path,'power');

% Bandpasses of interest
delta_bandpass = [1 4];
theta_bandpass = [4 8];
alpha_bandpass = [8 13];
beta_bandpass = [13 30];

% Create variables for output 
id = {};
ses = {};
sta = {};
abs_peak_alpha = [];
abs_delta = [];
abs_theta = [];
abs_alpha = [];
abs_beta = [];
rel_delta = [];
rel_theta = [];
rel_alpha = [];
rel_beta = [];

%% Loop over participants, sessions and states

% Iterate over the participants
for p = 1:length(participants)
    
    % Create the participants directory
    participant = participants{p};
    disp(strcat("Participant: ", participant));
    power_participant_output_path =  mkdir_if_not_exist(power_output_path, participant);
    
    % Iterate over sessions
    for t = 1:length(sessions)
        session = sessions{t};
        power_participant_session_output_path =  mkdir_if_not_exist(power_participant_output_path, session);
        
        % Iterate over the states
        for s = 1:length(states)
            state = states{s};
            disp(strcat("State: ", state));
            
            % Load the power data
            load(strcat(power_participant_session_output_path,filesep,state,'_power.mat'));
            
            %% Calculate power metrics
            
            % absolute spectral power - units: uV^2/Hz
       
            
            %find indices for each frequency bandpass
            indices = find(result_sp.data.frequencies >= delta_bandpass(1) & result_sp.data.frequencies <= delta_bandpass(2));
            absolute_delta = squeeze(result_sp.data.spectrums(1,indices,:));
            absolute_delta = mean(mean(absolute_delta,2));
            
            indices = find(result_sp.data.frequencies >= theta_bandpass(1) & result_sp.data.frequencies <= theta_bandpass(2));
            absolute_theta = squeeze(result_sp.data.spectrums(1,indices,:));
            absolute_theta = mean(mean(absolute_theta,2));
            
            indices = find(result_sp.data.frequencies >= alpha_bandpass(1) & result_sp.data.frequencies <= alpha_bandpass(2));
            absolute_alpha = squeeze(result_sp.data.spectrums(1,indices,:));
            absolute_alpha = mean(mean(absolute_alpha,2));
            
            indices = find(result_sp.data.frequencies >= beta_bandpass(1) & result_sp.data.frequencies <= beta_bandpass(2));
            absolute_beta = squeeze(result_sp.data.spectrums(1,indices,:));
            absolute_beta = mean(mean(absolute_beta,2));
            
            index = find(result_sp.data.frequencies == result_sp.data.peak_frequency);
            absolute_peak_alpha = squeeze(result_sp.data.spectrums(1,index,:));
            absolute_peak_alpha = mean(absolute_peak_alpha);
            
            absolute_broadband = mean(mean(squeeze(result_sp.data.spectrums),2));
            
            relative_delta = absolute_delta / absolute_broadband;
            relative_theta = absolute_theta / absolute_broadband;
            relative_alpha = absolute_alpha / absolute_broadband;
            relative_beta = absolute_beta / absolute_broadband;
            
            
            id = [id ; participants{p}];
            ses = [ses ; sessions{t}];
            sta = [sta ; states{s}];
            
            abs_peak_alpha = [abs_peak_alpha ; absolute_peak_alpha];
            abs_delta = [abs_delta ; absolute_delta];
            abs_theta = [abs_theta ; absolute_theta];
            abs_alpha = [abs_alpha ; absolute_alpha];
            abs_beta = [abs_beta ; absolute_beta];
            rel_delta = [rel_delta ; relative_delta];
            rel_theta = [rel_theta ; relative_theta];
            rel_alpha = [rel_alpha ; relative_alpha];
            rel_beta = [rel_beta ; relative_beta];
            
          
            
             
        end
        
    end
end

%create table of results
power_metrics = table(id,ses,sta,abs_peak_alpha,abs_delta,abs_theta,...
    abs_alpha,abs_beta,rel_delta,rel_theta,rel_alpha,rel_beta);
writetable(power_metrics,'power_metrics_T1_EC.csv')