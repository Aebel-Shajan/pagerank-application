function [p] = pagerank_full(A, alpha, v, iterations)
% PAGERANK_FULL Compute the PageRank vector of a directed graph represented by an
% adjacency matrix A. This function shows clearly the full steps in the
% pagerank algorithm.
%
% Syntax:
%   [p] = pagerank_full(A, alpha, v, iterations)
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


% 1.Column normalisation
n = size(A, 1); % dimension
% r = sum(A, 2); % out degree
c = sum(A, 1); % in degree
e = ones(n, 1);
H = zeros(n, n);
for i = 1:numel(c)
    if c(i)~=0
        H(:, i) = A(:, i)./c(i);
    end
end
e_H = e'*H

% 2.Stochastic Adjustment
a = ones(size(H, 1), 1);
for j = 1:size(H, 2)
    for i = 1:size(H, 1)
        if H(i, j) ~= 0
            a(j) = 0; % computing dangling node vector
            break;
        end
    end
end
S = H + (e * a')/n
e_S = e'*S

% 3.Transition Probability
G = alpha*S + (1-alpha)*v*e'
e_G = e'*G
% 4.Power method
p = ones(n, 1);
p = p/sum(p);
for k = 1:iterations
    p = G*p;
end
p = p/sum(p)
end




