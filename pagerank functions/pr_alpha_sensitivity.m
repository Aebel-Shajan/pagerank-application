function [alpha_sensitivity] = pr_alpha_sensitivity(A, alpha, v)
%PR_ALPHA_SENSITIVITY Calculates the derivative of the pagerank vector wrt
% to the alpha parameter.
% 1.Column normalisation
n = size(A, 1); % dimension
% r = sum(A, 2); % in degree
c = sum(A, 1); % out degree
e = ones(n, 1);
H = zeros(n, n);
for i = 1:numel(c)
    if c(i)~=0
        H(:, i) = A(:, i)./c(i);
    end
end

% 2.Stochastic Adjustment
a = ones(n, 1);
for j = 1:size(H, 2)
    for i = 1:size(H, 1)
        if H(i, j) ~= 0
            a(j) = 0; % computing dangling node vector
            break;
        end
    end
end

S = H + (e * a')/n;
I = eye(n);
inverse = inv(I - alpha*S);
alpha_sensitivity = -1*inverse*(I - S)*inverse*v;
end