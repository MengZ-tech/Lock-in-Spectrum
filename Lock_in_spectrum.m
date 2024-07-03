% % This Lock-in spectrum implementation example is regarding to a set of Outer race Fault 
% % bearing monitoring data (XJTU-SY Bearing data), where data source has been given in references in article.
% % Enjoy it!
% % Meng Zhang meng1.zhang@mail.polimi.it 

% data folder
folder_path = 'Bearing1_1'; 
files = dir(fullfile(folder_path, '*.csv'));
num_files = length(files);
direc=1; %horizontal sensor data
frequency_cover_range=801; % frequency range legnth/frequency step
all_amps = zeros(frequency_cover_range, num_files);

for file_index = 1:num_files
    % indexing all files
    filename = fullfile(folder_path, sprintf('%d.csv', file_index));
    disp(filename); 
    data = csvread(filename, 1, 0); 
    signal = data(:, direc);
    data_length = length(signal);
    time = (0:data_length-1) / 25600;
    amps = zeros(1, frequency_cover_range); 

    % Lock-in calculation of amplitudes
    for i = 1:frequency_cover_range
        frequency = 104 + 0.01*(i-1); % 104-112 Hz
        sin_wave = sin(2 * pi * frequency * time');
        cos_wave = cos(2 * pi * frequency * time');
        result_signal_sin = signal .* sin_wave;
        result_signal_cos = signal .* cos_wave;
        integration_average_sin = sum(result_signal_sin) / length(result_signal_sin);
        integration_average_cos = sum(result_signal_cos) / length(result_signal_cos);
        amp = 2*(sqrt(integration_average_sin^2 + integration_average_cos^2));
        amps(i) = amp;

    end

    all_amps(:, file_index) = amps';
end

frequency_range = (104:1:112); % frequency range

figure;
imagesc(all_amps);
xlabel('time [min]');
ylabel('frequency [Hz]');
colorbar;
set(gca, 'YTick', linspace(1, frequency_cover_range, numel(frequency_range)));
set(gca, 'YTickLabel', frequency_range);
set(gca, 'FontSize', 12, 'FontName', 'Times New Roman');
set(gcf, 'Position', [100, 100, 600, 300]); 
colormap('jet'); 
