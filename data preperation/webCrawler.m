function [adjacencyMatrix, linkNames] = webCrawler(websiteName, maxDepth, maxNodes, blacklist)
if nargin < 2
maxDepth = 2;
end
if nargin < 3
maxNodes = 100;
end
if nargin < 4
blacklist = [];
end

visitedWebsites = containers.Map;
adjacencyList = containers.Map;
visitQueue = {struct('url', websiteName, 'depth', 0)};

fprintf('Crawling websites: [');
progressBarWidth = 50;

while ~isempty(visitQueue) && length(visitedWebsites) < maxNodes
    current = visitQueue{1};
    visitQueue(1) = [];
    currentUrl = current.url;
    currentDepth = current.depth;

    if visitedWebsites.isKey(currentUrl) || any(contains(currentUrl, blacklist))
        continue;
    end

    try
        htmlContent = webread(currentUrl);
        visitedWebsites(currentUrl) = true;
        links = extractLinks(htmlContent);

        for i = 1:length(links)
            link = links{i};
            if ~visitedWebsites.isKey(link) && ~any(contains(link, blacklist))
                if ~adjacencyList.isKey(currentUrl)
                    adjacencyList(currentUrl) = {};
                end
                adjacencyList(currentUrl) = [adjacencyList(currentUrl) {link}];

                if currentDepth < maxDepth
                    visitQueue{end+1} = struct('url', link, 'depth', currentDepth + 1);
                end
            end
        end
    catch
        % Ignore invalid URLs or errors while reading the webpage
    end

    % Update progress bar
    progress = length(visitedWebsites) / maxNodes;
    filledBlocks = floor(progress * progressBarWidth);
    emptyBlocks = progressBarWidth - filledBlocks;
    fprintf(repmat('\b', 1, progressBarWidth + 1));
    fprintf('%s%s]', repmat('=', 1, filledBlocks), repmat(' ', 1, emptyBlocks));
end

fprintf('\n');

% Convert the adjacency list to an adjacency matrix
linkNames = keys(adjacencyList);
adjacencyMatrix = false(length(linkNames));

for i = 1:length(linkNames)
    for j = 1:length(linkNames)
        if any(strcmp(adjacencyList(linkNames{i}), linkNames{j}))
            adjacencyMatrix(i, j) = true;
        end
    end
end
