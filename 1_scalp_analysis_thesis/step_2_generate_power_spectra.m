%{
    Danielle Nadin 2020-04-29
    Modified for healthy tDCS analysis. 

    Yacine Mahdid 2020-01-08
    This script is used to generate power spectra for the MDFA dataset.
    This was requested by the reviewer to make sure that the motif are not
    epiphenomenon of the shift in alpha power.
%}
 
%% Seting up the variables 
clear % to keep only what is needed for this experiment
close all 
setup_experiments % see this file to edit the experiments

% Create power output directory
power_output_path = mkdir_if_not_exist(output_path,'power');

% Create average result struct
% sp - spectral power (uV^2/Hz), for computing power ratios
% td - topographic distribution (dB), for plotting head maps
avg_data = struct();
avg_data.power_td = zeros(length(states),97);
avg_data.power_count = zeros(length(states),97);
avg_data.avg_power_td = zeros(length(states),97);
avg_data.location = -1;

%% Loop over participants, sessions and states

% Iterate over the participants
for p = 1:length(participants)
    
    % Create the participants directory
    participant = participants{p};
    disp(strcat("Participant: ", participant));
    power_participant_output_path =  mkdir_if_not_exist(power_output_path, participant);
    
    % Iterate over sessions
    for t = 1:length(sessions)
        session = sessions{t};
        power_participant_session_output_path =  mkdir_if_not_exist(power_participant_output_path, session);
        
        % Iterate over the states
        for s = 1:length(states)
            state = states{s};
            disp(strcat("State: ", state));
            
            % Load the recording
            raw_data_filename = strcat(participant,'_',session,'_',state,'_',eyes,'.set');
            data_location = strcat(raw_data_path,filesep,participant,filesep,'DATA',filesep,session);
            recording = load_set(raw_data_filename,data_location);
            power_state_filename = strcat(power_participant_session_output_path,filesep,state,'_power.mat');
            
            %% Calculate power
            
            % topographic distribution - units: dB (10*log10(spect/windows))
            % in this case, window size = full length of recording 
            window_size = floor(recording.length_recording / recording.sampling_rate); % in seconds
            step_size = window_size;
            result_td = na_topographic_distribution(recording, window_size, step_size, power_param.topo_frequency_band);
            [filt_power, filt_location] = filter_non_scalp_vector(result_td.data.power, result_td.metadata.channels_location);
            result_td.data.filt_power = filt_power;
            result_td.data.filt_location = filt_location;
            result_td.data.normalized_filt_power = (filt_power - mean(filt_power,2))./std(filt_power);
            
            % absolute spectral power - units: uV^2/Hz
            window_size = 2; % in seconds
            step_size = 0.1; % in seconds
            time_bandwith_product = 2;
            number_tapers = 3;
            bandpass = power_param.spect_frequency_band;
            [recording.data,recording.channels_location] = filter_non_scalp_recording(recording.data,recording.channels_location); %filter non-scalp chans
            result_sp = na_spectral_power(recording, window_size, time_bandwith_product, number_tapers, bandpass,step_size);
            result_sp.metadata.channels_location = recording.channels_location;
            result_sp.metadata.number_channels = length(recording.channels_location);
            
            %find average peak frequency within topo_frequency_band range
            indices = find(result_sp.data.frequencies >= power_param.topo_frequency_band(1) & result_sp.data.frequencies <= power_param.topo_frequency_band(2));
            data = squeeze(result_sp.data.spectrums(1,indices,:));
            [~,ind] = max(mean(data,2));
            peak = result_sp.data.frequencies(indices(ind));
            result_sp.data.peak_frequency = peak;
            result_td.data.peak_frequency = peak;
            
            %compute topographic distribution at peak frequency
            window_size = floor(recording.length_recording / recording.sampling_rate); % in seconds
            step_size = window_size;
            result_peak_td = na_topographic_distribution(recording, window_size, step_size, [result_td.data.peak_frequency result_td.data.peak_frequency]);
            [filt_power, filt_location] = filter_non_scalp_vector(result_peak_td.data.power, result_td.metadata.channels_location);
            result_peak_td.data.filt_power = filt_power;
            result_peak_td.data.filt_location = filt_location;
            result_peak_td.data.normalized_filt_power = (filt_power - mean(filt_power,2))./std(filt_power);
            result_peak_td.data.peak_frequency = peak;
            
            %save results for spectral power and topographic distributions
            save(power_state_filename, 'result_sp','result_td','result_peak_td');
            
            %% Figures (individual participant/session/state)
            if power_param.figures
                
                %Plot spectrogram
                figure
                plot_matrix(squeeze(result_sp.data.spectrums)',result_sp.data.timestamps,result_sp.data.frequencies)
                ylabel('Frequency (Hz)')
                xlabel('Time (s)')
                title(strcat(participant," at ",session," ", state, " Spectrogram (uV^2/Hz)"))
                colormap jet
                set(gca,'FontSize',12)
                output_figure_path = strcat(power_participant_session_output_path,filesep,state,'_spectrogram.fig');
                savefig(output_figure_path)
                close(gcf)

                %Plot PSD (average spectrogram over time)
                figure(1)
                hold on
                plot(result_sp.data.frequencies,mean(squeeze(result_sp.data.spectrums),2),'LineWidth',2)
                ylabel('Power (uV^2/Hz)')
                xlabel('Frequency (Hz)')
                title(strcat(participant," at ",session, " PSD"))
                set(gca,'LineWidth',2,'FontSize',12)
                hold off
                
                if s == length(states) %once you've plotted all the states 
                    if s == 2
                        legend('baseline','post30')
                    elseif s == 3
                        legend('baseline','post0','post30')
                    end
                    output_figure_path = strcat(power_participant_session_output_path,filesep,'_psd.fig');
                    savefig(output_figure_path)
                    close(gcf)
                end
          
               
                % Plot topographic distrubution (full band)
                figure
                topographic_map(result_td.data.normalized_filt_power,result_td.data.filt_location);
                title(strcat(participant," at ", session," ", state," ",...
                    num2str(power_param.topo_frequency_band(1))," to ",...
                    num2str(power_param.topo_frequency_band(2)), " Hz Power Topography (z-score)"))
                output_figure_path = strcat(power_participant_session_output_path,filesep,state,'_topographic_map.fig');
                savefig(output_figure_path)
                close(gcf)
                
                % Plot topographic distribution at peak frequency
                figure
                topographic_map(result_peak_td.data.normalized_filt_power,result_peak_td.data.filt_location);
                title(strcat(participant," at ", session," ", state," ",...
                    num2str(result_peak_td.data.peak_frequency)," Hz Power Topography (z-score)"))
                output_figure_path = strcat(power_participant_session_output_path,filesep,state,'_topographic_map_peak.fig');
                savefig(output_figure_path)
                close(gcf)
            
            end
            
            %% Averaging topographic distribution (across participants)
            
            %TO DO: Collect data for average topography, if applicable
            if power_param.average
                
                if(isstruct(avg_data.location) == 0)
                    avg_data.location = result_td.data.filt_location; %assumes first participant in average has all 129 channels
                end
                
                for e_i=1:length(avg_data.location)
                    current_label = avg_data.location(e_i).labels;
                    is_found = 0;
                    for j=1:length(recording.channels_location)
                        if(strcmp(recording.channels_location(j).labels, current_label))
                            is_found = j;
                            break;
                        end
                    end
                    
                    if(is_found ~= 0)
                        j = is_found;
                        avg_data.power_td(s,e_i) = avg_data.power_td(s, e_i) +  result_td.data.filt_power(j);
                        avg_data.power_count(s,e_i) = avg_data.power_count(s,e_i) + 1;
                    end
                end
                
            end
        end
        
    end
end

%% Figure: average topographic distribution (across participants)

%TO DO: Generate the average topography figure, if applicable
if power_param.average
    
    for s = 1:length(states)
        for c_i = 1:99
            avg_data.avg_power_td(s,c_i) = avg_data.power_td(s,c_i) ./ avg_data.power_count(c_i);
        end
    end
    
    
    figure
    for e_i = 1:length(states)
        avg_data.normalized_avg_power_td = (avg_data.avg_power_td(e_i,:)-mean(avg_data.avg_power_td(e_i,:),2))./std(avg_data.avg_power_td(e_i,:));
        subplot(ceil(length(states)/3),3,e_i)
        title(strcat("Power at ",states{e_i}))
        topographic_map(avg_data.normalized_avg_power_td,avg_data.location);
    end
    save(strcat(power_output_path,filesep,'_average_power.mat'), 'avg_data');
    output_figure_path = strcat(power_output_path,filesep,'_average_power.fig');
    savefig(output_figure_path)
    
end

%% Helper functions 

function topographic_map(data,location)
topoplot(data,location,'maplimits','absmax', 'electrodes', 'off');
min_color = min(data);
max_color = max(data);
caxis([min_color max_color])
colormap('jet')
colorbar;
end