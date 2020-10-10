# Scalp-level analysis of tDCS data
The structure of this repository and basis of this code were modified from the work of Yacine Mahdid which can be found here: https://github.com/BIAPT/Scripts/tree/master/Motif%20Analysis%20Augmented%20(Source%2CTarget%20and%20Distance)

## Code Structure
* `utils` helper functions
* `settings.txt`: configure data input and output paths
* `setup_project.m`: download the required version of NeuroAlgo
* `setup_experiments.m`: configure analysis parameters
* step_1: constructing the wPLI and dPLI matrices
* step_2: power analysis
* step_3: binary graph theory analysis
* step_4: motif analysis

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
4. Edit `setup_experiments.m` script to setup the experiment environment properly.
5.  Run your desired analyses one by one or include them in a script to run automatically. Note that you will need to run step_3a_threshold_sweep and manually write the thresholds output to the command window in `setup_experiments.m` prior to running step_3b or step_3c. 
