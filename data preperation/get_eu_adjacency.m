function [adj_matrix, countries] = get_eu_adjacency(filename)
% Returns adjacency matrix. Edges point from the rows to the columns.
data = readtable(filename);
countries = unique(data.reporter);
rows_to_remove = any(cellfun(@(x) strcmp(x, "EU27_2020"), countries), 2);
countries(rows_to_remove, :) = [];
n_countries = length(countries);
adj_matrix = zeros(n_countries);
for i = 1:height(data)
    reporter_idx = find(strcmp(countries, data.reporter(i)));
    if find(strcmp(countries, data.partner(i)))
        partner_idx = find(strcmp(countries, data.partner(i)));
        adj_matrix(reporter_idx, partner_idx) =data.OBS_VALUE(i);
    end
end
end