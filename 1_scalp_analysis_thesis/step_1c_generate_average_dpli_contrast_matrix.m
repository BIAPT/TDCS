%{ 
Modified by Danielle Nadin on 2020-05-25 to fit in tDCS scalp analysis
pipeline

Yacine Mahdid April 16 2020
 This script is addressing the task
 https://github.com/BIAPT/awareness-perturbation-complexity-index/issues/12
%}

%% Seting up the variables
clear;
setup_experiments % see this file to edit the experimen

%Group data by stimulation intensity; row = participant, column = session
stim = [2 0 1; 1 2 0; 0 1 2; 1 2 0; 2 0 1; 1 2 0; 0 1 2];

%get common locations across sessions for each participant
for p = 1:length(participants)
    
    participant = participants{p};
    dpli_output_path = strcat(output_path,filesep,'dpli',filesep,participant);

    dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participant,filesep,sessions{1},filesep,'dpli_BvP30_common_location');
    load(dpli_input_path);
    location_1 = dpli_common_location;
    
    dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participant,filesep,sessions{2},filesep,'dpli_BvP30_common_location');
    load(dpli_input_path);
    location_2 = dpli_common_location;
    
    dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participant,filesep,sessions{3},filesep,'dpli_BvP30_common_location');
    load(dpli_input_path);
    location_3 = dpli_common_location;
    
    dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participant,filesep,sessions{1},filesep,'dpli_BvP30_common_region');
    load(dpli_input_path);
    region_1 = dpli_common_region;
    
    dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participant,filesep,sessions{2},filesep,'dpli_BvP30_common_region');
    load(dpli_input_path);
    region_2 = dpli_common_region;
    
    dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participant,filesep,sessions{3},filesep,'dpli_BvP30_common_region');
    load(dpli_input_path);
    region_3 = dpli_common_region;
    
    [dpli_common_location, dpli_common_region] = get_subset(location_1,location_2,region_1,region_2);
    [dpli_common_location, dpli_common_region] = get_subset(dpli_common_location,location_3,dpli_common_region,region_3);
    save(strcat(dpli_output_path,filesep,'dpli_common_location.mat'),'dpli_common_location');
    save(strcat(dpli_output_path,filesep,'dpli_common_region.mat'),'dpli_common_region');
               
end

%get common locations across participants
dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participants{1},filesep,'dpli_common_location');
load(dpli_input_path);
location_1 = dpli_common_location;

dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participants{2},filesep,'dpli_common_location');
load(dpli_input_path);
location_2 = dpli_common_location;

dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participants{3},filesep,'dpli_common_location');
load(dpli_input_path);
location_3 = dpli_common_location;

dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participants{4},filesep,'dpli_common_location');
load(dpli_input_path);
location_4 = dpli_common_location;

dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participants{5},filesep,'dpli_common_location');
load(dpli_input_path);
location_5 = dpli_common_location;

dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participants{6},filesep,'dpli_common_location');
load(dpli_input_path);
location_6 = dpli_common_location;

dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participants{7},filesep,'dpli_common_location');
load(dpli_input_path);
location_7 = dpli_common_location;


dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participants{1},filesep,'dpli_common_region');
load(dpli_input_path);
region_1 = dpli_common_region;

dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participants{2},filesep,'dpli_common_region');
load(dpli_input_path);
region_2 = dpli_common_region;

dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participants{3},filesep,'dpli_common_region');
load(dpli_input_path);
region_3 = dpli_common_region;

dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participants{4},filesep,'dpli_common_region');
load(dpli_input_path);
region_4 = dpli_common_region;

dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participants{5},filesep,'dpli_common_region');
load(dpli_input_path);
region_5 = dpli_common_region;

dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participants{6},filesep,'dpli_common_region');
load(dpli_input_path);
region_6 = dpli_common_region;

dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participants{7},filesep,'dpli_common_region');
load(dpli_input_path);
region_7 = dpli_common_region;

[dpli_common_location, dpli_common_region] = get_subset(location_1,location_2,region_1,region_2);
[dpli_common_location, dpli_common_region] = get_subset(dpli_common_location,location_3,dpli_common_region,region_3);
[dpli_common_location, dpli_common_region] = get_subset(dpli_common_location,location_4,dpli_common_region,region_4);
[dpli_common_location, dpli_common_region] = get_subset(dpli_common_location,location_5,dpli_common_region,region_5);
[dpli_common_location, dpli_common_region] = get_subset(dpli_common_location,location_6,dpli_common_region,region_6);
[dpli_common_location, dpli_common_region] = get_subset(dpli_common_location,location_7,dpli_common_region,region_7);

avg_common_location = dpli_common_location;
avg_common_region = dpli_common_region;
avg_left_ind = find([avg_common_location.is_left]);
avg_right_ind = find([avg_common_location.is_right]);

%filter matrices and concatenate each stimulation group

contrast_stim0=[];
contrast_stim1=[];
contrast_stim2=[];

for p = 1:length(participants)
    
    participant = participants{p};
    
    for t = 1:length(sessions)
        
        session = sessions{t};
        
        dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participant,filesep,session,filesep,'full_dpli_contrast');
        load(dpli_input_path);
        
        dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participant,filesep,session,filesep,'dpli_BvP30_common_location');
        load(dpli_input_path);
        
        left_ind = find([dpli_common_location.is_left]);
        right_ind = find([dpli_common_location.is_right]);
        
        %filter for averaging
        f_full_contrast_matrix = filter_matrix(full_dpli_contrast, [dpli_common_location(left_ind) dpli_common_location(right_ind)],...
            [avg_common_location(avg_left_ind) avg_common_location(avg_right_ind)]);
        
        if stim(p,t) == 0
            contrast_stim0 = cat(3,contrast_stim0,f_full_contrast_matrix);
        elseif stim(p,t) == 1
            contrast_stim1 = cat(3,contrast_stim1,f_full_contrast_matrix);
        elseif stim(p,t) == 2
            contrast_stim2 = cat(3,contrast_stim2,f_full_contrast_matrix);
        end
        
    end
    
end

contrast_stim0=mean(contrast_stim0,3);
contrast_stim1=mean(contrast_stim1,3);
contrast_stim2=mean(contrast_stim2,3);

% Create figures
h1=figure;
plot_pli(contrast_stim0, [avg_common_region(avg_left_ind) avg_common_region(avg_right_ind)], contrast_stim0(:), '*RdYlBu')
title("Average contrast dPLI baseline vs. post30 dPLI (sham)");
colorbar;

h2=figure;
plot_pli(contrast_stim1, [avg_common_region(avg_left_ind) avg_common_region(avg_right_ind)], contrast_stim1(:), '*RdYlBu')
title("Average contrast dPLI baseline vs. post30 dPLI (1 mA)");
colorbar;

h3=figure;
plot_pli(contrast_stim2, [avg_common_region(avg_left_ind) avg_common_region(avg_right_ind)], contrast_stim2(:), '*RdYlBu')
title("Average contrast dPLI baseline vs. post30 dPLI (2 mA)");
colorbar;

%Save figures
filename = strcat(output_path,filesep,'dpli',filesep,'avg_contrast_whole_dpli_stim0');
saveas(h1,filename);

filename = strcat(output_path,filesep,'dpli',filesep,'avg_contrast_whole_dpli_stim1');
saveas(h2,filename);

filename = strcat(output_path,filesep,'dpli',filesep,'avg_contrast_whole_dpli_stim2');
saveas(h3,filename);

close all
