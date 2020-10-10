# TDCS
Repository of code to analyze data from the TDCS study comparing 1 and 2 mA anodal tDCS to the left dorsolateral prefrontal cortex, in healthy controls.

Written by Danielle Nadin in 2019-2020 towards the completion of her MSc thesis. 

## Dataset
High-density, resting state EEG (128 channel) was collected from 15 healthy participants were invited to 3x90-minute sessions. Participants were assigned to a different stimulation group (sham vs. 1 mA vs. 2 mA) during each session, according to a predetermined, randomized, counterbalanced sequence. Consecutive visits were separated by at least 7 days to allow wash-out between tDCS sessions. Participants were blinded to the type of stimulation. Due to technical constraints, the experimenter was not blinded. 10 participants completed all 3 sessions. The remaining 5 completed only session 1 due to restrictions associated with the COVID-19 pandemic. 

During each session, resting-state EEG was recorded for 6 minutes (3 minutes eyes closed, and 3 minutes eyes open while looking at a fixation cross on a computer screen), during 3 epochs (baseline, immediately post-tDCS and 30 minutes post-tDCS). After each resting state recording, participants completed a computerized, fractal 2-back task. Sham stimulation, 1 mA or 2 mA anodal tDCS was delivered to the left dorsolateral prefrontal cortex (L-DLPFC for a duration of 20 min with simultaneous EEG recording, while participants were at rest (reading). When possible, participants' custom electrode locations were recorded at the end of each session.

Data files are named in the following format: TDCSX_TY_epoch_EZ, where X is the participant ID number, Y is the number of the session (1, 2 or 3), epoch is the within-session timepoint (baseline, post0, post30), and Z is the eye-opening state (C for closed or O for open). 

The full dataset can be found on the BIAPT lab internal server. 

## Repository Structure
Each folder represents a new iteration on the data analysis approach. The first iterations can be used to replicate the data reported in Danielle's thesis, including statistical analysis and figure generation. Each folder contains its own README.md file with instructions on how to run the code and replicate results. 

Iteration 1: Thesis
* **1_data_pre_processing**: cleaning of data
* **1_scalp_analysis_thesis**: scalp-level analysis of the data
* **1_source_analysis_thesis**: source-localized analysis of the data


