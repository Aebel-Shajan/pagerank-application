function [rank_table] = pr_ranking_table(adjacency_matrix, node_labels, alpha, v, iterations)
n = size(adjacency_matrix, 1);
if nargin < 3
    alpha = 0.85;
end
if nargin < 4
    v = ones(n, 1)/n;
end
if nargin < 5
    iterations = 50;
end
p = pagerank(adjacency_matrix, alpha, v, iterations);
[ranks, indicies] = sort(p, 'descend');
rank_node_labels = node_labels(indicies);
amount = min(100, n);
top_page_ranks = ranks(1:amount);
top_node_labels = rank_node_labels(1:amount);
rank_table = table(top_page_ranks, top_node_labels);
end