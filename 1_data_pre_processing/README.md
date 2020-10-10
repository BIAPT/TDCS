# EEG Pre-Processing
The following scripts automates the objective parts of the data pre-processing in EEGLAB (filtering, downsampling). User input is still required to select and remove noisy channels, to select ICA components to remove, and to remove noisy epochs. 

## Protocol
* Load data: If you are loading the raw mff file, comment out Option 2. If you are loading a set file, comment out Option 1. 
* Read channel locations (OPTIONAL): This option should only be uncommented if you are NOT using custom channel locations. For this iteration, custom channel locations were used for all participants except TDCS6. 
* Filtering: notch at 60 Hz, high-pass at 0.1 Hz, low-pass at 50 Hz
* Downsampling: downsample to 250 Hz to reduce data file size (this is okay because it is above the Nyquist frequency).
* Remove non-scalp channels: removes channels 1 8 14 17 21 25 32 38 43 44 48 49 56 57 63 73 81 88 94 99 100 107 113 114 119 120 121 125 126 127 128
* Manually remove noisy channels: Plots the channel data and opens GUI to select channels you wish to remove. Scroll through the data and select noisy channels.
* Average reference: Re-references to an average reference.
* ICA: Runs an ICA in EEGLAB, with the setting 'pca' set to 30 such that 30 ICs are computed instead of 90+. You must manually select which ICs to remove. I did the following: use ICLabel and viewpropos extensions to label ICs that are eye components, plot the channel data and the IC time-series, compare the two to ensure that the flagged ICs are indeed eye movement artifacts. Typically, there is one artifact for eye movements when eyes are closed, and one for eye blinks when eyes are open. 
* Interpolate noisy channels (OPTIONAL): If there are noisy channels that you removed but that are surrounded by channels with good quality, you can interpolate them (Tools > Interpolate electrods > Use specific channels of other dataset, Interpolation method: Spherical). Note that for this study, only < 10% of channels (e.g. 9 channels) were allowed to be interpolated per subject. In practice, only up to 2 channels needed to be interpolated for some subjects.
* Segment the data: Segment the data into eyes closed and eyes open epochs using event markers. 
* Visually inspect the data: Plot channel data and manually remove segments which contain large muscle or movement artifacts. 

## Dependencies
* MATLAB 2018a or above
* EEGLAB (v14.1.2)
* MFFMatlabIO plugin for EEGLAB (v3.0)
* firfilt plugin for EEGLAB (v1.6.2)
* OPTIONAL: ICLabel plugin for EEGLAB (v1.2.5)
* OPTIONAL: viewpropos plugin for EEGLAB (v1.5.4)

