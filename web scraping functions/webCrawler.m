function [adjacencyMatrix, linkNames] = webCrawler(websiteName, maxDepth, maxNodes, blacklist, whitelist)
% webCrawler - crawl a website and generate an adjacency matrix of links
%
% Syntax: 
% [adjacencyMatrix, linkNames] = webCrawler(websiteName, maxDepth, maxNodes, blacklist, whitelist)
%
% Inputs:
% websiteName - the starting website URL
% maxDepth - maximum depth of the crawl (default 2)
% maxNodes - maximum number of nodes to visit (default 100)
% blacklist - list of URLs to ignore
% whitelist - list of URLs to only include
%
% Outputs:
% adjacencyMatrix - adjacency matrix of links between visited websites
% linkNames - cell array of URLs of visited websites
    if nargin < 2
        maxDepth = 2;
    end
    if nargin < 3
        maxNodes = 100;
    end
    if nargin < 4
        blacklist = string([]);
    end
    if nargin < 5
        whitelist = string([]);
    end
    visitedWebsites = containers.Map;% Matlabs version of containers
    adjacencyList = containers.Map;
    currentUrl = websiteName;
    errors = string([]);
    visitQueue = {struct('url', websiteName, 'depth', 0)};
    progressBarWidth = 50;
    previousStringLength = progressBarWidth;
    index = 0;
    while ~isempty(visitQueue) && length(visitedWebsites) < maxNodes
        index = index + 1;
        current = visitQueue{1};
        visitQueue(1) = [];
        currentUrl = current.url;
        currentDepth = current.depth;
        if visitedWebsites.isKey(currentUrl) || any(contains(currentUrl, blacklist)) || ...
           (~isempty(whitelist) && ~any(contains(currentUrl, whitelist))) && index ~= 1
            continue;
        end
        try
            htmlContent = webread(currentUrl);
            visitedWebsites(currentUrl) = true;
            links = extractLinks(htmlContent);
            for i = 1:length(links)
                link = links{i};
                if startsWith(link, "/")
                    strippedUrl = erase(currentUrl, "https://");
                    if contains(strippedUrl, "/")
                        strippedUrl = extractBefore(strippedUrl, "/");
                    end
                    link = "https://" + strippedUrl + link;
                end
                if ~visitedWebsites.isKey(link) && ...
                   ~any(contains(link, blacklist)) && ...
                   (isempty(whitelist) || any(contains(link, whitelist)))
                    if ~adjacencyList.isKey(currentUrl)
                        adjacencyList(currentUrl) = string([]);
                    end
                    adjacencyList(currentUrl) = [adjacencyList(currentUrl), link];
                    if currentDepth < maxDepth
                        visitQueue{end+1} = struct('url', link, 'depth', currentDepth + 1);
                    end
                end
            end
        catch
            errors = [errors, currentUrl];
        end

        % Update progress bar
        progress = length(visitedWebsites) / maxNodes;
        filledBlocks = floor(progress * progressBarWidth);
        fprintf(repmat('\b', 1, previousStringLength));
        emptyBlocks = progressBarWidth - filledBlocks;
        info = "[" + repmat('=', 1, filledBlocks) + repmat(' ', 1, emptyBlocks) + "]" +...
            "\nPages visited: " + index + ...
            "\nDepth: " + currentDepth + ...
            "\nAdded websites: " + numel(keys(adjacencyList)) + "/" + maxNodes + ...
            "\n" + currentUrl + ...
            "\nErrors:" + numel(errors);
        fprintf(info);
        previousStringLength = strlength(info);
    end
    fprintf("\n\nErrors: %s", errors);
    % Convert the adjacency list to an adjacency matrix
    linkNames = keys(adjacencyList);
    adjacencyMatrix = false(length(linkNames));
    for i = 1:length(linkNames)
        for j = 1:length(linkNames)
            if any(strcmp( adjacencyList(linkNames{i}), linkNames{j} ) )
                adjacencyMatrix(i, j) = true;
            end
        end
    end
end

function links = extractLinks(htmlContent)
    links = {};
    expression = '<a\s+(?:[^>]*?\s+)?href="([^"]*)"';
    matches = regexp(htmlContent, expression, 'tokens');
    for i = 1:length(matches)
        links{end+1} = matches{i}{1};
    end
end
