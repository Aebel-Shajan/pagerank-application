function [pagerank_steps] = get_pagerank_steps(A, alpha, v, iterations)
% GET_PAGERANK_STEPS Returns the the pagerank vector at each iteration in
% the power method.
%
% Syntax:
%   [pagerank_steps] = get_pagerank_steps(A, alpha, v, iterations)
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
%   - pagerank_steps: Cell array containing Pagerank vector at each
%   iteration.

n = size(A, 1);
e = ones(n, 1);
column_sum = e' * A;
zero_columns = find(column_sum==0);
zero_col_num = length(zero_columns);
a = sparse(zero_columns, ones(zero_col_num, 1), ones(zero_col_num, 1), n, 1);
column_sum(column_sum == 0) = 1;
p = e/n; 
pagerank_steps = cell(iterations + 1);
pagerank_steps{1} = p;
for k = 1:iterations
    p = alpha*(A./column_sum)*p + v*(alpha*a'*p - alpha + 1);
    pagerank_steps{k+1} = p;
end
end