function [rank_table] = pr_ranking_table(adjacency_matrix, node_labels)
n = size(adjacency_matrix, 1);
p = pagerank(adjacency_matrix, 0.85, ones(n, 1)/n, 50);
[ranks, indicies] = sort(p, 'descend');
rank_node_labels = node_labels(indicies);
amount = min(100, n);
top_page_ranks = ranks(1:amount);
top_node_labels = rank_node_labels(1:amount);
rank_table = table(top_page_ranks, top_node_labels);
end