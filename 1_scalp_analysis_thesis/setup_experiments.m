%{
    Danielle Nadin 2020-04-27
    Setup experimental variables for analyzing tDCS scalp data. 
    Modified from Yacine's motif analysis augmented code. 
%}

% General Experiment Variables
settings = load_settings();
raw_data_path = settings.raw_data_path;
output_path = settings.output_path;
%participants = {'TDCS1','TDCS2','TDCS3','TDCS5','TDCS6','TDCS7','TDCS8','TDCS9','TDCS10','TDCS11','TDCS12','TDCS13','TDCS14','TDCS15','TDCS16'};
participants = {'TDCS1','TDCS2','TDCS3','TDCS5','TDCS6','TDCS7','TDCS8','TDCS9','TDCS10','TDCS11'};
sessions = {'T2','T3'};
states = {'baseline','post30'};
eyes = 'EO'; %eyes open or eyes closed 

% Power Spectra and Topography Variables
power_param = struct();
power_param.topo_frequency_band = [8 13]; % topographic map
power_param.spect_frequency_band = [1 30]; % spectrogram/PSD
power_param.figures = 1; %Do you want to generate individual subject figures?
power_param.file_name = 'power_metrics_T2_T3.csv'; %csv file name to export results

% wPLI Variables
wpli_param = struct();
wpli_param.frequency_band = [8 13]; % This is in Hz
wpli_param.window_size = 10; %in sec
wpli_param.number_surrogate = 20; % Number of surrogate wPLI to create
wpli_param.p_value = 0.05; % the p value to make our test on
wpli_param.step_size = 1; %in sec
wpli_param.figure = 1; %Do you want to generate individual subject figures?

% dPLI Variables
dpli_param = struct();
dpli_param.frequency_band = [8 13]; % This is in Hz
dpli_param.window_size = 10; %in sec
dpli_param.number_surrogate = 20; % Number of surrogate wPLI to create
dpli_param.p_value = 0.05; % the p value to make our test on
dpli_param.step_size = 1 ; %in sec
dpli_param.figure = 1; %Do you want to generate individual subject figures?

% Threshold sweep Experiment Variable
sweep_param = struct();
sweep_param.range = 0.90:-0.01:0.01; %more connected to less connected

% graph theory experiment variables
graph_param = struct();
graph_param.threshold = [.42 .5;.38 .45;.57 .63;.4 .62;.59 .74;.37 .34;.58 .69;.74 .58;.27 .43;.62 .36];
graph_param.number_surrogate = 10;
graph_param.figure = 1; 
graph_param.file_name = 'graph_metrics_T2_T3_max_custom_threshold.csv'; %csv file name to export results

% hubs experiment variables
hubs_param = struct();
hubs_param.threshold = [.42 .5;.38 .45;.57 .63;.4 .62;.59 .74;.37 .34;.58 .69;.74 .58;.27 .43;.62 .36]; 
hubs_param.figure = 1; %Do you want to generate individual subject figures?
hubs_param.file_name = 'hub_metrics_T2_T3_max_custom_threshold.csv'; %csv file name to export cosine similarity values

% motif Experiment Variables
motif_param = struct();
motif_param.number_rand_network = 100;
motif_param.bin_swaps = 10;
motif_param.weight_frequency = 0.1;
motif_param.figure = 1; %Do you want to generate individual subject figures?
motif_param.file_name = 'motif_metrics_T2_T3.csv'; %csv file name to export cosine similarity values

% The other parameters are recording dependant and will be dynamically generated
