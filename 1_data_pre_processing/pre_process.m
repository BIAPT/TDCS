%Danielle Nadin 24-11-2019
%EEG pre-processing pipeline in EEGlab

%% Load data
eeglab;
%Comment out the one that is irrelevant

%Option 1 - mff import
EEG = pop_mffimport(); 

% % Option 2 - load existing dataset
% [setname,setpath] = uigetfile('*.set');
% EEG = pop_loadset(setname,setpath);

[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG,EEG);
eeglab redraw;

% %% Read channel locations - DO NOT DO IF USING CUSTOM CHAN LOCS
% chanpath = 'GSN-HydroCel-129 (1).sfp';
% EEG.chanlocs = pop_chanedit(EEG.chanlocs,'load',{chanpath,'filetype','autodetect'});

%% Filter: notch, low-pass and high-pass
EEG = pop_eegfiltnew(EEG,59,61,[],1); %notch at 60 Hz
EEG = pop_eegfiltnew(EEG,0.1,0); % high-pass at 0.1 Hz
EEG = pop_eegfiltnew(EEG,0,50); %low-pass at 50 Hz

%% Downsample to 250 Hz
EEG = pop_resample(EEG,250);
eeglab redraw;

%% Remove non-scalp channels
noscalp = [1 8 14 17 21 25 32 38 43 44 48 49  56 57 63 68 73 81 88 94 99 ...
    100 107 113 114 119 120 121 125 126 127 128]; 
EEG = pop_select(EEG,'nochannel',noscalp);
eeglab redraw;

%% Remove noisy channels (MANUAL)
pop_eegplot(EEG); %display channel data
EEG = pop_select(EEG); %GUI to select channels to remove  

%% Average reference
EEG = pop_reref(EEG,[]); 
eeglab redraw;

%% Run ICA
EEG = pop_runica(EEG,'pca',30);
eeglab redraw;
