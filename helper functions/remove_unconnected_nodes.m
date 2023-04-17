function [A_reduced, remaining_nodes] = remove_unconnected_nodes(A)
    % A is the input adjacency matrix
    
    % Calculate the degree of each node by summing the rows
    node_degrees = sum(A, 2) + sum(A, 1)';
    
    % Find the indices of unconnected nodes
    unconnected_nodes = find(node_degrees == 0);
    
    % Find the indices of the remaining nodes
    remaining_nodes = setdiff(1:size(A, 1), unconnected_nodes);

    % Remove unconnected nodes by deleting their corresponding rows and columns
    A(unconnected_nodes, :) = [];
    A(:, unconnected_nodes) = [];
    
    % Return the reduced adjacency matrix
    A_reduced = A;
    

end
