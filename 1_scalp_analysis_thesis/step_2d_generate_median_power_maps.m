%{
    Yacine Mahdid 2020-01-08
    Modified by Danielle Nadin 2020-10-29
%}

%% Seting up the variables
clear % to keep only what is needed for this experiment
setup_experiments % see this file to edit the experiments

%Group data by stimulation intensity; row = participant, column = session
stim = [2 0 1; 1 2 0; 0 1 2; 1 2 0; 2 0 1; 1 2 0; 0 1 2; 0 1 2; 2 0 1; 1 2 0; ...
    1 NaN NaN; 2 NaN NaN; 0 NaN NaN; 0 NaN NaN; 2 NaN NaN];

% masterlist of 97 DEFAULT (not custom) channel locations
load('utils\EGI128_scalp_default.mat')

% Create average result struct
avg_data = struct();
avg_data.stim0 = struct();
avg_data.stim1 = struct();
avg_data.stim2 = struct();

%% Baseline vs Post30

avg_data.stim0.td = zeros(length(participants),97);
avg_data.stim0.td_count = zeros(1,97);
avg_data.stim0.avg_td = zeros(1,97);
avg_data.stim0.med_td = zeros(1,97);
avg_data.stim0.location = channels_location;

avg_data.stim1.td = zeros(length(participants),97);
avg_data.stim1.td_count = zeros(1,97);
avg_data.stim1.avg_td = zeros(1,97);
avg_data.stim1.avg_td_minus_sham = zeros(1,97);
avg_data.stim1.med_td = zeros(1,97);
avg_data.stim1.location = channels_location;

avg_data.stim2.td = zeros(length(participants),97);
avg_data.stim2.td_count = zeros(1,97);
avg_data.stim2.avg_td = zeros(1,97);
avg_data.stim2.avg_td_minus_sham = zeros(1,97);
avg_data.stim2.med_td = zeros(1,97);
avg_data.stim2.location = channels_location;

% Iterate over the participants
for p = 1:length(participants)
    
    participant = participants{p};
    disp(strcat("Participant :", participant));
    
    power_input_path = strcat(output_path,filesep,'power',filesep,participant);
    
    % Iterate over the sessions
    for t = 1:length(sessions)
        
        session = sessions{t};
        disp(strcat("Session :",session));
        
        if ~isnan(stim(p,t)) %if the data point exists
            
            power_participant_input_path = strcat(power_input_path,filesep,session,filesep,'power_contrasts.mat');
            load(power_participant_input_path)
            td = result_power_contrast.BvP30.td;
            channels_location = result_power_contrast.BvP30.channels_location;
            
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
                        avg_data.stim0.td(p,i) = td(j);
                        avg_data.stim0.td_count(1,i) = avg_data.stim0.td_count(1,i) + 1;
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
                        avg_data.stim1.td(p,i) = td(j);
                        avg_data.stim1.td_count(1,i) = avg_data.stim1.td_count(1,i) + 1;
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
                        avg_data.stim2.td(p,i) = td(j);
                        avg_data.stim2.td_count(1,i) = avg_data.stim2.td_count(1,i) + 1;
                    end
                    
                end
                
            end
            
        else %if the data point is NaN, skip it
           
            continue;
            
        end
    end   
end

%Compute averages
avg_data.stim0.avg_td = sum(avg_data.stim0.td,1) ./ avg_data.stim0.td_count;
avg_data.stim1.avg_td = sum(avg_data.stim1.td,1) ./ avg_data.stim1.td_count;
avg_data.stim2.avg_td = sum(avg_data.stim2.td,1) ./ avg_data.stim2.td_count;

%Subtract sham from average
avg_data.stim1.avg_td_minus_sham = avg_data.stim1.avg_td - avg_data.stim0.avg_td;
avg_data.stim2.avg_td_minus_sham = avg_data.stim2.avg_td - avg_data.stim0.avg_td;

% Compute medians
avg_data.stim0.med_td = median(avg_data.stim0.td([1:10,13,14],:)); %remove rows 11, 12, 15
avg_data.stim1.med_td = median(avg_data.stim1.td(1:11,:)); %remove rows 12, 13, 14, 15
avg_data.stim2.med_td = median(avg_data.stim2.td([1:10,12,15],:)); %remove rows 11, 13, 14

%Save result
save(strcat(output_path,filesep,'power',filesep,'average_power_contrasts_BvP30.mat'),'avg_data')

%Figure
figure
for i = 1:3
    subplot(1,3,i)
    if i == 1
        topographic_map(avg_data.stim0.avg_td,avg_data.stim0.location);
        title("Average \Delta Power @ Peak frequency BvP30 (sham)");
    elseif i == 2
        topographic_map(avg_data.stim1.avg_td,avg_data.stim1.location);
        title("Average \Delta Power @ Peak frequency BvP30 (1 mA)");
    else
        topographic_map(avg_data.stim2.avg_td,avg_data.stim2.location);
        title("Average \Delta Power @ Peak frequency BvP30 (2 mA)");
    end
end

output_figure_path = strcat(output_path,filesep,'power',filesep,'average_power_contrasts_BvP30.fig');
savefig(output_figure_path)
close(gcf)

%Figure
figure
for i = 1:2
    subplot(1,2,i)
    if i == 1
        topographic_map(avg_data.stim1.avg_td_minus_sham,avg_data.stim1.location);
        title("Average \Delta Power @ Peak frequency BvP30 (1 mA-sham)");
    else
        topographic_map(avg_data.stim2.avg_td_minus_sham,avg_data.stim2.location);
        title("Average \Delta Power @ Peak frequency BvP30 (2 mA-sham)");
    end
end

output_figure_path = strcat(output_path,filesep,'power',filesep,'average_power_contrasts_BvP30_minus_sham.fig');
savefig(output_figure_path)
close(gcf)

%Figure
figure
for i = 1:3
    subplot(1,3,i)
    if i == 1
        topographic_map(avg_data.stim0.med_td,avg_data.stim0.location);
        title("Median \Delta Power @ Peak frequency BvP30 (sham)");
    elseif i == 2
        topographic_map(avg_data.stim1.med_td,avg_data.stim1.location);
        title("Median \Delta Power @ Peak frequency BvP30 (1 mA)");
    else
        topographic_map(avg_data.stim2.med_td,avg_data.stim2.location);
        title("Median \Delta Power @ Peak frequency BvP30 (2 mA)");
    end
end

output_figure_path = strcat(output_path,filesep,'power',filesep,'median_power_contrasts_BvP30.fig');
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
