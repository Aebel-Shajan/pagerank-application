function [dangling_node_vector] = get_dangling_nodes(matrix)
    dangling_node_vector = ones(size(matrix, 1), 1);
    for j = 1:size(matrix, 2)
        for i = 1:size(matrix, 1)
            if matrix(i, j) ~= 0
                dangling_node_vector(j) = 0;
                break;
            end
        end
    end
end