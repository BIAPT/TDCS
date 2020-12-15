%{
    Danielle Nadin 2020-04-27
    Setup experimental variables for analyzing tDCS scalp data. 
    Modified from Yacine's motif analysis augmented code. 
%}

% General Experiment Variables
settings = load_settings();
raw_data_path = settings.raw_data_path;
output_path = settings.output_path;
participants = {'TDCS1','TDCS2','TDCS3','TDCS5','TDCS6','TDCS7','TDCS8','TDCS9','TDCS10','TDCS11','TDCS12','TDCS13','TDCS14','TDCS15','TDCS16'};
%participants = {'TDCS1','TDCS2','TDCS3','TDCS5','TDCS6','TDCS7','TDCS8','TDCS9','TDCS10','TDCS11'};
sessions = {'T1','T2','T3'};
states = {'baseline','post30'};
eyes = 'EO'; %eyes open or eyes closed 

% Power Spectra and Topography Variables
power_param = struct();
power_param.topo_frequency_band = [8 13]; % topographic map
power_param.spect_frequency_band = [1 30]; % spectrogram/PSD
power_param.figures = 1;
power_param.average = 0; % TODO: Do you want to generate the average topographic map (across participants)?

% wPLI Variables
wpli_param = struct();
wpli_param.frequency_band = [8 13]; % This is in Hz
wpli_param.window_size = 10; % This is in seconds and will be how we chunk the whole dataset
wpli_param.number_surrogate = 20; % Number of surrogate wPLI to create
wpli_param.p_value = 0.05; % the p value to make our test on
wpli_param.step_size = 1; 
wpli_param.figure = 1;

% dPLI Variables
dpli_param = struct();
dpli_param.frequency_band = [8 13]; % This is in Hz
dpli_param.window_size = 10; % This is in seconds and will be how we chunk the whole dataset
dpli_param.number_surrogate = 20; % Number of surrogate wPLI to create
dpli_param.p_value = 0.05; % the p value to make our test on
dpli_param.step_size = 1 ;
dpli_param.figure = 1; 

% Threshold sweep Experiment Variable
sweep_param = struct();
sweep_param.range = 0.90:-0.01:0.01; %more connected to less connected

% graph theory experiment variables
graph_param = struct();
graph_param.threshold = [.42 .5;.38 .45;.57 .63;.4 .62;.59 .74;.37 .34;.58 .69;.74 .58;.27 .43;.62 .36];
graph_param.number_surrogate = 10;
graph_param.figure = 1; 
graph_param.average = 0; %TODO

% hubs experiment variables
hubs_param = struct();
hubs_param.threshold = [.42 .5;.38 .45;.57 .63;.4 .62;.59 .74;.37 .34;.58 .69;.74 .58;.27 .43;.62 .36]; 
hubs_param.figure = 1;
hubs_param.average = 0; %TODO

% motif Experiment Variables
motif_param = struct();
motif_param.number_rand_network = 100;
motif_param.bin_swaps = 10;
motif_param.weight_frequency = 0.1;
motif_param.average = 0; %% TODO
motif_param.figure = 1;


% The other parameters are recording dependant and will be dynamically
% generated
