# Scalp-level analysis of tDCS data
The structure of this repository and basis of this code were modified from the work of Yacine Mahdid which can be found here: https://github.com/BIAPT/Scripts/tree/master/Motif%20Analysis%20Augmented%20(Source%2CTarget%20and%20Distance)

## Code Structure
* `utils` helper functions
* `settings.txt`: configure data input and output paths
* `setup_project.m`: download the required version of NeuroAlgo
* `setup_experiments.m`: configure analysis parameters
* step_1a: construct wPLI and dPLI matrices and plot individual subject matrices
* step_1b: compute contrast matrices between baseline and post30
* step_1c: generate average contrast matrix **This code was not complete, issues due to different number of channels across participants and time points**
* step_2a: generate spectrogram and power spectral density and plot spectrograms/bar graphs
* step_2b: extract absolute and relative power values and read to csv
* step_2c: generate contrasts in topographic power between baseline and post30
* step_2d: generate map of median change in power topography
* step_3a: find optimal threshold for an individual wPLI matrix
* step_3b: generate global graph theoretical network properties and plot individual subject bar graphs
* step_3c: generate node degree and plot individual subject topographic maps
* step_3d: export global graph theoretical network properties including node degree to csv
* step_3e: compute cosine similarity of baseline and post30 node degree and export to csv
* step_3f: generate contrasts in topography of node degree between baseline and post30
* step_3g: generate map of median change in node degree topography
* step_4a: generate 3-node funcitonal motifs and plot individual subject topographic maps
* step_4b: compute cosine similarity of baseline and post30 motif frequency and export to csv
* step_4c: generate constrasts in topography of motif frequency between baseline and post30
* step_4d: generate map of median change in motif frequency topography

## Dependencies
* **MATLAB 2018a** and above
* **NeuroAlgo 0.0.1** (downloaded with `setup_project.m`)
* **TDCS dataset** structured as outlined below 

## How to Use the Code
0. Run `setup_project.m` to install the right dependencies for this project. 
1. Edit the `raw_data_path` variable in `settings.txt`. It needs to contain the clean dataset, which should have this structure:

* raw_data_path
	* TDCS1
		* DATA
			* T1
				* TDCS1_T1_baseline_EC.fdt
				* TDCS1_T1_baseline_EC.set
				* TDCS1_T1_baseline_EO.fdt
				* TDCS1_T1_baseline_EO.set
				* TDCS1_T1_post0_EC.fdt
				* TDCS1_T1_post0_EC.set
				* TDCS1_T1_post0_EO.fdt
				* TDCS1_T1_post0_E0.set
				* TDCS1_T1_post30_EC.fdt
				* TDCS1_T1_post30_EC.set
				- TDCS1_T1_post30_EO.fdt
				- TDCS1_T1_post30_EO.set
 			- T2
				- etc.
			- T3
				- etc.
        - TDCS2
            - etc.
        - etc.
2. Edit the `output_path` in `settings.txt`. This folder only needs to exist and can be located anywhere on your computer or on an external disk. The resulting output path will be populated as follows with data matrices and figures:
* output_path
	* dpli
		* TDCS1
			- T1
			- T2
			- T3
		* TDCS2
			- etc.
		* etc.
	* graph theory
	* hubs
	* motif
	* power
	* wpli
3. In MATLAB, add the current folder to your path 
4. Edit `setup_experiments.m` script to setup the experiment variables according to your needs.
5.  Run your desired analyses one by one or include them in a script to run automatically. Note that you will need to run step_3a_threshold_sweep and manually write the thresholds output to the command window in `setup_experiments.m` prior to running step_3b to step_3g. When inputting the thresholds, each row should be a subject and each column should be an epoch (baseline, post30). Step 1 must be run before Steps 3 or 4. Step 2 can be run independently.
