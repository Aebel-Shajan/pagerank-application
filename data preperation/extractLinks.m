function links = extractLinks(htmlContent)
    links = {};
    expression = '<a\s+(?:[^>]*?\s+)?href="([^"]*)"';
    matches = regexp(htmlContent, expression, 'tokens');
    for i = 1:length(matches)
        links{end+1} = matches{i}{1};
    end
end
