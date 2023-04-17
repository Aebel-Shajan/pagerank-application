function [gp] = plot_pr_graph(adjacency_matrix, node_labels, marker_max)
if nargin < 3
    marker_max = 5;
end
n = size(adjacency_matrix, 1);
p = pagerank(adjacency_matrix, 0.85, ones(n, 1)/n, 50);
graph = digraph(adjacency_matrix);
gp = plot(graph, 'layout', 'force','NodeLabel', {});
gp.EdgeColor = [0,0.5,1];
gp.EdgeAlpha = 0.1;
LWidths = marker_max*graph.Edges.Weight/max(graph.Edges.Weight);
gp.LineWidth = LWidths;
gp.MarkerSize = marker_max*max(p)/p + 0.1*marker_max;
row = dataTipTextRow('label: ',node_labels);
gp.DataTipTemplate.DataTipRows(end+1) = row;
end