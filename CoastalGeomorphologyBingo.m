%% COASTAL GEOMORPHOLOGY BINGO
clear all
close all
format compact
clc

% load word list
inputFileName = 'wordlist.txt'; % Name of the text file
if ~isfile(inputFileName)
    error('The file "%s" does not exist. Please provide a valid file.', inputFileName);
end

fileID = fopen(inputFileName, 'r');
wordlist = textscan(fileID, '%s', 'Delimiter', '\n'); % Read words line by line
fclose(fileID);

% set output directory
cardDir = [pwd filesep 'bingocards\'];

% Flatten the nested cell array into a single cell array of words
wordlist = wordlist{1};

% Define the parameters for the Bingo card
numBingoCards = 50; % number of bingo cards to create
gridSize = 5; % Size of the grid (e.g., 5x5); should be an odd number for the free space
fontName = 'Bahnschrift';

% Check if there are enough words for the Bingo card (excluding free space)
numFreeSpaces = 1; % One free space
requiredWords = gridSize^2;
if length(wordlist) < requiredWords
    error('Not enough words to fill the Bingo card.');
end

% make each card!
for ii = 1:numBingoCards
    % Shuffle the word list
    shuffledWords = wordlist(randperm(length(wordlist)));

    % Create the Bingo card
    bingoCard = reshape(shuffledWords(1:requiredWords), gridSize, gridSize);

    % Add a free space in the middle for odd grid sizes
    if mod(gridSize, 2) == 1
        middleIndex = ceil(gridSize / 2); % Find the middle index
        bingoCard{middleIndex, middleIndex} = "FREE!";
    end

    % Create the figure for the Bingo card
    figure(1);
    clf
    set(gcf,'Color','w')
    hold on; box on; grid on;

    % Set up the grid and plot it
    axis equal;
    set(gca, 'XTick', 0:gridSize, 'YTick', 0:gridSize, ...
        'XTickLabel', [], 'YTickLabel', [], 'XColor', 'k', 'YColor', 'k', ...
        'LineWidth', 1.5);
    xlim([0 gridSize]);
    ylim([0 gridSize]);
    grid on;

    % Add the words to the grid
    for row = 1:gridSize
        for col = 1:gridSize
            if row == middleIndex && col == middleIndex
                text(col - 0.5, gridSize - row + 0.5, bingoCard{row, col}, ...
                    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                    'FontSize', 16,'FontName',fontName,'FontWeight','bold', 'Interpreter', 'none'); % Prevent LaTeX interpretation
            else
                word = bingoCard{row, col};
                if contains(word, ' ') || contains(word, '-') % Check if the word has spaces or hyphens
                    wordParts = split(word, {' ', '-'}); % Split the word into parts by spaces or hyphens
                    wordFormatted = strjoin(wordParts, '\n'); % Join with newline
                else
                    wordFormatted = word; % Single-line word
                end
                text(col - 0.5, gridSize - row + 0.5, wordFormatted, ...
                    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                    'FontSize', 10,'FontName',fontName, 'Interpreter', 'none'); % Prevent LaTeX interpretation
            end
        end
    end

    % Turn off axes for a clean look
    %     axis off;
    title('COASTAL GEOMORPHOLOGY BINGO!','Q3 2026','FontSize',16,'FontName',fontName)

    % add your name
    text(0,-0.2,'Name: __________________________','FontName',fontName, 'Interpreter', 'none')

    % add a serial number
    text(5,-0.2,num2str(ii,'%04.f'),'FontName',fontName)


    % Export figure to png file
    pngName = ['BingoCard_' num2str(ii,'%04.f') '.png'];
    dimensions = [21.0 29.7].*0.667; % [width height]
    printFigs(dimensions,[cardDir filesep pngName],0);

end


