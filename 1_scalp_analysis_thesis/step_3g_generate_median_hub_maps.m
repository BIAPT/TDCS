%{
    Yacine Mahdid 2020-01-08
    Modified by Danielle Nadin 2020-06-14
%}

%% Seting up the variables
clear % to keep only what is needed for this experiment
setup_experiments % see this file to edit the experiments

%Group data by stimulation intensity; row = participant, column = session
stim = [2 0 1; 1 2 0; 0 1 2; 1 2 0; 2 0 1; 1 2 0; 0 1 2; 0 1 2; 2 0 1; 1 2 0; ...
    1 NaN NaN; 2 NaN NaN; 0 NaN NaN; 0 NaN NaN; 2 NaN NaN];

%Row # of participants who didn't get sham: 11, 12, 15
%Row # of participants who didn't get 1 mA: 12, 13, 14, 15
%Row # of participants who didn't get 2 mA: 11, 13, 14
% ^ remove these rows when computing the average/median

% masterlist of 97 DEFAULT channel locations
load('C:\Users\dn-xo\OneDrive - McGill University\Research\BIAPT Lab\Thesis\TDCS\Scalp analysis\utils\EGI128_scalp_default.mat')

% Create average result struct
avg_data = struct();
avg_data.stim0 = struct();
avg_data.stim1 = struct();
avg_data.stim2 = struct();

%% Baseline vs Post30

avg_data.stim0.degree = zeros(length(participants),97);
avg_data.stim0.degree_count = zeros(1,97);
avg_data.stim0.avg_degree = zeros(1,97);
avg_data.stim0.med_degree = zeros(1,97);
avg_data.stim0.location = channels_location;

avg_data.stim1.degree = zeros(length(participants),97);
avg_data.stim1.degree_count = zeros(1,97);
avg_data.stim1.avg_degree = zeros(1,97);
avg_data.stim1.avg_degree_minus_sham = zeros(1,97);
avg_data.stim1.med_degree = zeros(1,97);
avg_data.stim1.location = channels_location;

avg_data.stim2.degree = zeros(length(participants),97);
avg_data.stim2.degree_count = zeros(1,97);
avg_data.stim2.avg_degree = zeros(1,97);
avg_data.stim2.avg_degree_minus_sham = zeros(1,97);
avg_data.stim2.med_degree = zeros(1,97);
avg_data.stim2.location = channels_location;

% Iterate over the participants
for p = 1:length(participants)
    
    participant = participants{p};
    disp(strcat("Participant :", participant));
    
    hubs_input_path = strcat(output_path,filesep,'hubs_max_custom_threshold',filesep,participant);
    
    % Iterate over the sessions
    for t = 1:length(sessions)
        
        session = sessions{t};
        disp(strcat("Session :",session));
        
        if ~isnan(stim(p,t)) %if the data point exists
            
            hubs_participant_input_path = strcat(hubs_input_path,filesep,session,filesep,'hubs_contrasts.mat');
            load(hubs_participant_input_path)
            degree = result_hubs_contrast.BvP30.degree;
            channels_location = result_hubs_contrast.BvP30.channels_location;
            
            
            if stim(p,t) == 0 %sham
                
                for i=1:length(avg_data.stim0.location)
                    current_label = avg_data.stim0.location(i).labels;
                    is_found = 0;
                    for j=1:length(channels_location)
                        if(strcmp(channels_location(j).labels, current_label))
                            is_found = j;
                            break;
                        end
                    end
                    
                    if(is_found ~= 0)
                        j = is_found;
                        avg_data.stim0.degree(p,i) = degree(j);
                        avg_data.stim0.degree_count(1,i) = avg_data.stim0.degree_count(1,i) + 1;
                    end
                end
                
            elseif stim(p,t) == 1 % 1 mA
                
                for i=1:length(avg_data.stim1.location)
                    current_label = avg_data.stim1.location(i).labels;
                    is_found = 0;
                    for j=1:length(channels_location)
                        if(strcmp(channels_location(j).labels, current_label))
                            is_found = j;
                            break;
                        end
                    end
                    
                    if(is_found ~= 0)
                        j = is_found;
                        avg_data.stim1.degree(p,i) = degree(j);
                        avg_data.stim1.degree_count(1,i) = avg_data.stim1.degree_count(1,i) + 1;
                    end
                end
                
            elseif stim(p,t) == 2 % 2 mA
                
                for i=1:length(avg_data.stim2.location)
                    current_label = avg_data.stim2.location(i).labels;
                    is_found = 0;
                    for j=1:length(channels_location)
                        if(strcmp(channels_location(j).labels, current_label))
                            is_found = j;
                            break;
                        end
                    end
                    
                    if(is_found ~= 0)
                        j = is_found;
                        avg_data.stim2.degree(p,i) = degree(j);
                        avg_data.stim2.degree_count(1,i) = avg_data.stim2.degree_count(1,i) + 1;
                    end
                end
                
            end
            
        else
            
            continue;
            
        end  
    end
end

%Compute averages
avg_data.stim0.avg_degree = sum(avg_data.stim0.degree,1) ./ avg_data.stim0.degree_count; %don't need to remove rows 11, 12, 15 because rows are all zero and won't contribute to the sum
avg_data.stim1.avg_degree = sum(avg_data.stim1.degree,1) ./ avg_data.stim1.degree_count; 
avg_data.stim2.avg_degree = sum(avg_data.stim2.degree,1) ./ avg_data.stim2.degree_count; 

%Subtract sham from average
avg_data.stim1.avg_degree_minus_sham = avg_data.stim1.avg_degree - avg_data.stim0.avg_degree;
avg_data.stim2.avg_degree_minus_sham = avg_data.stim2.avg_degree - avg_data.stim0.avg_degree;

%Compute medians
avg_data.stim0.med_degree = median(avg_data.stim0.degree([1:10,13,14],:)); %remove rows 11, 12, 15
avg_data.stim1.med_degree = median(avg_data.stim1.degree(1:11,:)); %remove rows 12, 13, 14, 15
avg_data.stim2.med_degree = median(avg_data.stim2.degree([1:10,12,15],:)); %remove rows 11, 13, 14

%Save result
save(strcat(output_path,filesep,'hubs_max_custom_threshold',filesep,'average_hubs_contrasts_BvP30.mat'),'avg_data')

%Figure
figure
for i = 1:3
    subplot(1,3,i)
    if i == 1
        topographic_map(avg_data.stim0.avg_degree,avg_data.stim0.location);
        title("Average \Delta Hubs BvP30 (sham)");
    elseif i == 2
        topographic_map(avg_data.stim1.avg_degree,avg_data.stim1.location);
        title("Average \Delta Hubs BvP30 (1 mA)");
    else
        topographic_map(avg_data.stim2.avg_degree,avg_data.stim2.location);
        title("Average \Delta Hubs BvP30 (2 mA)");
    end
end

output_figure_path = strcat(output_path,filesep,'hubs_max_custom_threshold',filesep,'average_hubs_contrasts_BvP30.fig');
savefig(output_figure_path)
close(gcf)

figure
for i = 1:3
    subplot(1,3,i)
    if i == 1
        topographic_map(avg_data.stim0.med_degree,avg_data.stim0.location);
        title("Median \Delta Hubs BvP30 (sham)");
    elseif i == 2
        topographic_map(avg_data.stim1.med_degree,avg_data.stim1.location);
        title("Median \Delta Hubs BvP30 (1 mA)");
    else
        topographic_map(avg_data.stim2.med_degree,avg_data.stim2.location);
        title("Median \Delta Hubs BvP30 (2 mA)");
    end
end

output_figure_path = strcat(output_path,filesep,'hubs_max_custom_threshold',filesep,'median_hubs_contrasts_BvP30.fig');
savefig(output_figure_path)
close(gcf)

figure
for i = 1:2
    subplot(1,2,i)
    if i == 1
        topographic_map(avg_data.stim1.avg_degree_minus_sham,avg_data.stim1.location);
        title("Average \Delta Hubs BvP30 (1 mA-sham)");
    else
        topographic_map(avg_data.stim2.avg_degree_minus_sham,avg_data.stim2.location);
        title("Average \Delta Hubs BvP30 (2 mA-sham)");
    end
end

output_figure_path = strcat(output_path,filesep,'hubs_max_custom_threshold',filesep,'average_hubs_contrasts_BvP30_minus_sham.fig');
savefig(output_figure_path)
close(gcf)

function topographic_map(data,location)
topoplot(data,location,'maplimits','absmax', 'electrodes', 'off');
min_color = min(data);
max_color = max(data);
caxis([min_color max_color])
colormap('jet')
colorbar;
end