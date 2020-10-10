%{ 
Modified by Danielle Nadin on 2020-05-25 to fit in tDCS scalp analysis
pipeline

Yacine Mahdid April 16 2020
 This script is addressing the task
 https://github.com/BIAPT/awareness-perturbation-complexity-index/issues/12
%}

%% Seting up the variables
clear;
setup_experiments % see this file to edit the experiments

%Iterate of participants
for p = 1:length(participants)
    
    participant = participants{p};
    disp(strcat("Participant : ",participant));
    
    % Iterate over sessions
    for t = 1:length(sessions)
        
        session = sessions{t};
        disp(strcat("Session:", session));
        
        %Set up output path
        wpli_output_path = strcat(output_path,filesep,'wpli',filesep,participant,filesep,session);
        dpli_output_path = strcat(output_path,filesep,'dpli',filesep,participant,filesep,session);
        
        %Iterate over number of comparisons (nstates-1)
        for s = 1:length(states)-1
            
            state_1 = states{1};
            state_2 = states{s+1};

            %Import wpli data for state 1 and state 2
            wpli_input_path = strcat(output_path,filesep,'wpli',filesep,participant,filesep,session,filesep,state_1,'_wpli');
            load(wpli_input_path);
            wpli_matrix_1 = result_wpli.data.avg_wpli;
            wpli_channels_location_1 = result_wpli.metadata.channels_location;
            
            wpli_input_path = strcat(output_path,filesep,'wpli',filesep,participant,filesep,session,filesep,state_2,'_wpli');
            load(wpli_input_path);
            wpli_matrix_2 = result_wpli.data.avg_wpli;
            wpli_channels_location_2 = result_wpli.metadata.channels_location;
            
            %Import dpli data for state 1 and state 2
            dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participant,filesep,session,filesep,state_1,'_dpli');
            load(dpli_input_path);
            dpli_matrix_1 = result_dpli.data.avg_dpli;
            dpli_channels_location_1 = result_dpli.metadata.channels_location;
            
            dpli_input_path = strcat(output_path,filesep,'dpli',filesep,participant,filesep,session,filesep,state_2,'_dpli');
            load(dpli_input_path);
            dpli_matrix_2 = result_dpli.data.avg_dpli;
            dpli_channels_location_2 = result_dpli.metadata.channels_location;

            %Filter the non_scalp channels
            [wpli_matrix_1,wpli_channels_location_1] = filter_non_scalp(wpli_matrix_1,wpli_channels_location_1);
            [dpli_matrix_1,dpli_channels_location_1] = filter_non_scalp(dpli_matrix_1,dpli_channels_location_1);
            
            [wpli_matrix_2,wpli_channels_location_2] = filter_non_scalp(wpli_matrix_2,wpli_channels_location_2);
            [dpli_matrix_2,dpli_channels_location_2] = filter_non_scalp(dpli_matrix_2,dpli_channels_location_2);
            
            %Sort matrix by region
            [r_wpli_matrix_1, ~, r_wpli_regions_1, r_wpli_location_1] = reorder_channels(wpli_matrix_1, wpli_channels_location_1,'biapt_egi129.csv');
            [r_wpli_matrix_2, ~, r_wpli_regions_2, r_wpli_location_2] = reorder_channels(wpli_matrix_2, wpli_channels_location_2,'biapt_egi129.csv');
            
            [r_dpli_matrix_1, ~, r_dpli_regions_1, r_dpli_location_1] = reorder_channels(dpli_matrix_1, dpli_channels_location_1,'biapt_egi129.csv');
            [r_dpli_matrix_2, ~, r_dpli_regions_2, r_dpli_location_2] = reorder_channels(dpli_matrix_2, dpli_channels_location_2,'biapt_egi129.csv');
            
            %Get common locations between states 1 and 2 
            [wpli_common_location, wpli_common_region] = get_subset(r_wpli_location_1,r_wpli_location_2,r_wpli_regions_1,r_wpli_regions_2);
            [dpli_common_location, dpli_common_region] = get_subset(r_dpli_location_1,r_dpli_location_2,r_dpli_regions_1,r_dpli_regions_2);
            if s == 2
                save(strcat(dpli_output_path,filesep,'dpli_BvP30_common_location.mat'),'dpli_common_location')
                save(strcat(dpli_output_path,filesep,'dpli_BvP30_common_region.mat'),'dpli_common_region')
            end
            
            %Filter the matrices to have the same size
            f_wpli_1 = filter_matrix(r_wpli_matrix_1, r_wpli_location_1, wpli_common_location);
            f_wpli_2 = filter_matrix(r_wpli_matrix_2, r_wpli_location_2, wpli_common_location);
            
            f_dpli_1 = filter_matrix(r_dpli_matrix_1, r_dpli_location_1, dpli_common_location);
            f_dpli_2 = filter_matrix(r_dpli_matrix_2, r_dpli_location_2, dpli_common_location);
            
            % Calculate contrast matrix
            wpli_contrast = f_wpli_1 - f_wpli_2; %baseline-post
            dpli_contrast = f_dpli_1 - f_dpli_2;
            
            % Create figures
            h1=figure;
            left_ind = find([wpli_common_location.is_left]);
            left_wpli_contrast = wpli_contrast(left_ind,left_ind);
            plot_pli(left_wpli_contrast, wpli_common_region(left_ind), left_wpli_contrast(:), '*RdYlBu')
            title(strcat(participant," ",session," ",eyes," ",state_1," vs ",state_2," left wPLI"));
            colorbar;
            
            h2=figure;
            right_ind = find([wpli_common_location.is_right]);
            right_wpli_contrast = wpli_contrast(right_ind,right_ind);
            plot_pli(right_wpli_contrast, wpli_common_region(right_ind), right_wpli_contrast(:), '*RdYlBu')
            title(strcat(participant," ",session," ",eyes," ",state_1," vs ",state_2," right wPLI"));
            colorbar;
            
            
            h3=figure;
            left_ind = find([dpli_common_location.is_left]);
            left_dpli_contrast = dpli_contrast(left_ind,left_ind);
            plot_pli(left_dpli_contrast, dpli_common_region(left_ind), left_dpli_contrast(:), '*RdYlBu')
            title(strcat(participant," ",session," ",eyes," ",state_1," vs ",state_2," left dPLI"));
            colorbar;
            
            h4=figure;
            right_ind = find([dpli_common_location.is_right]);
            right_dpli_contrast = dpli_contrast(right_ind,right_ind);
            plot_pli(right_dpli_contrast, dpli_common_region(right_ind), right_dpli_contrast(:), '*RdYlBu')
            title(strcat(participant," ",session," ",eyes," ",state_1," vs ",state_2," right dPLI"));
            colorbar;
            
            h5=figure;
            LR_dpli_contrast = dpli_contrast(left_ind,right_ind);
            RL_dpli_contrast = dpli_contrast(right_ind,left_ind);
            full_dpli_contrast = [left_dpli_contrast LR_dpli_contrast; RL_dpli_contrast right_dpli_contrast];
            save(strcat(dpli_output_path,filesep,'full_dpli_contrast.mat'), 'full_dpli_contrast');
            plot_pli(full_dpli_contrast, dpli_common_region([left_ind right_ind]), full_dpli_contrast(:), '*RdYlBu')
            title(strcat(participant," ",session," ",eyes," ",state_1," vs ",state_2," Whole Brain dPLI"));
            colorbar;
 
            %Save figures
            filename = strcat(wpli_output_path,filesep,state_1,"_",state_2,"_contrast_left_wpli.png");
            saveas(h1,filename);
            
            filename = strcat(wpli_output_path,filesep,state_1,"_",state_2,"_contrast_right_wpli.png");
            saveas(h2,filename);
            
            filename = strcat(dpli_output_path,filesep,state_1,"_",state_2,"_contrast_left_dpli.png");
            saveas(h3,filename);
            
            filename = strcat(dpli_output_path,filesep,state_1,"_",state_2,"_contrast_right_dpli.png");
            saveas(h4,filename);
            
            filename = strcat(dpli_output_path,filesep,state_1,"_",state_2,"_contrast_full_dpli.png");
            saveas(h5,filename);
            filename = strcat(dpli_output_path,filesep,state_1,"_",state_2,"_contrast_full_dpli.fig");
            saveas(h5,filename);
            
            close all;
        end
    end
end

