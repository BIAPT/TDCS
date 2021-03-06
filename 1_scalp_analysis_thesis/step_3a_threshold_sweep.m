  %Danielle Nadin 11-12-2019
%Sweep through range of network thresholds and compute binary small-worldness to determine 
% the 'small-world regime range' as defined in Basset et al (2008). 

% modified by Yacine Mahdid 2019-12-12
% modified by Danielle Nadin 2020-02-25 adapt for Motif Analysis Augmented pipeline

clear;
setup_experiments % see this file to edit the experiments
participant = 'TDCS11';
session = 'T3';
state = 'baseline';

%Import wpli data
wpli_input_path = strcat(output_path,filesep,'wpli',filesep,participant,filesep,session,filesep,state,'_wpli');
load(wpli_input_path);
wpli_matrix = result_wpli.data.avg_wpli;
channels_location = result_wpli.metadata.channels_location;

% Here we need to filter the non_scalp channels
[wpli_matrix,channels_location] = filter_non_scalp(wpli_matrix,channels_location);

%loop through thresholds
for j = 1:length(sweep_param.range) 
    current_threshold = sweep_param.range(j);
    disp(strcat("Doing the threshold : ", string(current_threshold)));
    
    % Thresholding and binarization using the current threshold
    t_network = threshold_matrix(wpli_matrix, current_threshold);
    b_network = binarize_matrix(t_network);
    
    % check if the binary network is disconnected
    % Here our binary network (b_network) is a weight matrix but also an
    % adjacency matrix.
    distance = distance_bin(b_network);
    
    % Here we check if there is one node that is disconnected
    if(sum(isinf(distance(:))))
        disp(strcat("Final threshold: ", string(sweep_param.range(j-1))));
        break;
    end
end