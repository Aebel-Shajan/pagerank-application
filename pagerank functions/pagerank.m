function [p] = pagerank(A, alpha, v, iterations)
% PAGERANK Compute the PageRank vector of a directed graph represented by an
% adjacency matrix A. This function has been optimised and makes use of the
% sparsity of A.
%
% Syntax:
%   [p] = pagerank(A, alpha, v, iterations)
%
% Input arguments:
%   - A: An n-by-n sparse adjacency matrix representing the directed graph, 
%       where A(i,j) is 1 if there is an edge from node i to node j, and 0
%       otherwise.
%   - alpha: A scalar between 0 and 1 representing the probability that the
%       random surfer will follow a link, rather than jumping to a random page.
%   - v: A column vector of length n representing the personalization
%       vector.
%   - iterations: An integer that specifies the number of power method
%       iterations.
%
% Output arguments:
%   - p: Pagerank vector which ranks the nodes in a graph based on its
%       importance.
n = size(A, 1);
e = ones(n, 1);
column_sum = e' * A;
zero_columns = find(column_sum==0);
zero_col_num = length(zero_columns);
a = sparse(zero_columns, ones(zero_col_num, 1), ones(zero_col_num, 1), n, 1);
column_sum(column_sum == 0) = 1;
p = e/n; 
for k = 1:iterations
    p = alpha*(A./column_sum)*p + v*(alpha*a'*p - alpha + 1);
end
end
