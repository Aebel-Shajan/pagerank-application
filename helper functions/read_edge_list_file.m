function [adj_matrix] = read_edge_list_file(filename)
% Read the text file
fid = fopen(filename, 'r');

% Ignore comment lines
tline = fgetl(fid);
while ischar(tline)
    if tline(1) ~= '%'
        break;
    end
    tline = fgetl(fid);
end

% Parse the first non-comment line to get the number of vertices
dims = sscanf(tline, '%d %d %d');
num_vertices = dims(1);

% Initialize the adjacency matrix
adj_matrix = zeros(num_vertices);

% Read the remaining lines and update the adjacency matrix
tline = fgetl(fid);
while ischar(tline)
    edge = sscanf(tline, '%d %d');
    u = edge(1);
    v = edge(2);
    
    adj_matrix(u, v) = 1;
    adj_matrix(v, u) = 1; % The graph is undirected
    
    tline = fgetl(fid);
end
% Close the file
fclose(fid);

end