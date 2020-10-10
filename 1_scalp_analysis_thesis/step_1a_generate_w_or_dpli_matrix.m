%{
    Danielle Nadin 2020-04-30
    Modified for healthy tDC S analysis - automate figure generation. 
  
    Yac ine Mah did 202  0- 01-08
    This script will  calcul  ate the wpli and the dpli matrices (at alpha)
    that are ne  ede d to run the subsequent analysis. The parameters for the
    analysis can be  found in this script

    * Warning: This exp  eriment use the setup_experiments.m script to 
    load variables. Therefore if you are trying to edit this code and you
    don't know what a variable mean take a look at the setup_experiments.m
    script.
%}

%% Seting up the variables
clear;
setup_experiments % see this file to edit the experiments

% Create the (w/d)pli directory
wpli_output_path = mkdir_if_not_exist(output_path,'wpli');
dpli_output_path = mkdir_if_not_exist(output_path,'dpli');
   
% Iterate over the participants
for p = 1:length(participants)
    
    participant = participants{p};
    disp(strcat("Participant : ",participant));
    
    % Iterate over sessions
    for t = 1:length(sessions)
        
        session = sessions{t};
        disp(strcat("Session:", session));
        wpli_participant_output_path = mkdir_if_not_exist(wpli_output_path,strcat(participant,filesep,session));
        dpli_participant_output_path = mkdir_if_not_exist(dpli_output_path,strcat(participant,filesep,session));
        
        % Iterate over the states
        for s = 1:length(states)
            state = states{s};

            % Load the recording
            raw_data_filename = strcat(participant,'_',session,'_',state,'_',eyes,'.set');
            data_location = strcat(raw_data_path,filesep,participant,filesep,'DATA',filesep,session);
            recording = load_set(raw_data_filename,data_location);

            % Calculate wpli
            wpli_state_filename = strcat(wpli_participant_output_path,filesep,state,'_wpli.mat');
            result_wpli = na_wpli(recording, wpli_param.frequency_band, ...
                                  wpli_param.window_size, wpli_param.step_size, ...
                                  wpli_param.number_surrogate, wpli_param.p_value);
            save(wpli_state_filename, 'result_wpli');
            
            %sort matrix by region
            [r_wpli, r_labels, r_regions, r_location] = reorder_channels(result_wpli.data.avg_wpli, result_wpli.metadata.channels_location,'biapt_egi129.csv');

            if wpli_param.figure
                
                %left brain
                left_ind = find([r_location.is_left]);
                left_matrix = r_wpli(left_ind,left_ind);
                plot_wpli(left_matrix,strcat(participant," ",session," ",state," ",eyes," Left Hemisphere wPLI"),[],'jet',0);
                imagepath = strcat(wpli_participant_output_path,filesep,state,'_left_wpli.fig');
                saveas(gcf,imagepath);
                close(gcf)
                plot_sidebar(imagepath,0,0.3,r_regions(left_ind));
                
                %right brain
                right_ind = find([r_location.is_right]);
                right_matrix = r_wpli(right_ind,right_ind);
                plot_wpli(right_matrix,strcat(participant," ",session," ",state," ",eyes," Right Hemisphere wPLI"),[],'jet',0);
                imagepath = strcat(wpli_participant_output_path,filesep,state,'_right_wpli.fig');
                saveas(gcf,imagepath);
                close(gcf)
                plot_sidebar(imagepath,0,0.3,r_regions(right_ind));
               
            end

            % Calculate dpli
            dpli_state_filename = strcat(dpli_participant_output_path,filesep,state,'_dpli.mat');
            result_dpli = na_dpli(recording, dpli_param.frequency_band, ...
                                  dpli_param.window_size, dpli_param.step_size, ...
                                  dpli_param.number_surrogate, dpli_param.p_value);
            save(dpli_state_filename, 'result_dpli');
            
            %sort matrix by region
            [r_dpli, r_labels, r_regions, r_location] = reorder_channels(result_dpli.data.avg_dpli, result_dpli.metadata.channels_location,'biapt_egi129.csv');

            if dpli_param.figure
                
                %left brain
                left_ind = find([r_location.is_left]);
                left_matrix = r_dpli(left_ind,left_ind);
                plot_pli(left_matrix,r_regions(left_ind),left_matrix(:),'*RdYlBu');
                title(strcat(participant," ",session," ",state," ",eyes," Left Hemisphere dPLI"))
                colorbar
                imagepath = strcat(dpli_participant_output_path,filesep,state,'_left_dpli.fig');
                saveas(gcf,imagepath);
                imagepath = strcat(dpli_participant_output_path,filesep,state,'_left_dpli.png');
                saveas(gcf,imagepath);
                close(gcf)
                
                %right brain
                right_ind = find([r_location.is_right]);
                right_matrix = r_dpli(right_ind,right_ind);
                plot_pli(right_matrix,r_regions(right_ind),right_matrix(:),'*RdYlBu');
                title(strcat( participant," ",session," ",state," ",eyes," Right Hemisphere dPLI"))
                colorbar
                imagepath = strcat(dpli_participant_output_path,filesep,state,'_left_dpli.fig');
                saveas(gcf,imagepath);
                imagepath = strcat(dpli_participant_output_path,filesep,state,'_right_dpli.png');
                saveas(gcf,imagepath);
                close(gcf)
                
                %full brain
                LR_matrix = r_dpli(left_ind,right_ind);
                RL_matrix = r_dpli(right_ind,left_ind);
                full_matrix = [left_matrix,LR_matrix; RL_matrix, right_matrix];
                plot_pli(full_matrix,r_regions([left_ind right_ind]),full_matrix(:),'*RdYlBu');
                title(strcat(participant," ",session," ",state," ",eyes," Whole Brain dPLI"))
                colorbar
                imagepath = strcat(dpli_participant_output_path,filesep,state,'_whole_dpli.fig');
                saveas(gcf,imagepath);
                imagepath = strcat(dpli_participant_output_path,filesep,state,'_whole_dpli.png');
                saveas(gcf,imagepath);
                close(gcf)
                
            end
        end
    end
end