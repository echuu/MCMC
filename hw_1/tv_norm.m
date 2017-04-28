

% tv_norm.m
% calculate the tv norm given 
	% p:  stationary distribution
	% K:  transition matrix
	% n:  steps
	% v0: initial distribution 
function d = tv_norm(p, K, n, v0)

	mu_n = v0 * K^n; % n-step transition -- 1 x # of states

	d_sum = 0;
	num_states = numel(p);

	for i = 1:num_states
		d_sum = d_sum + abs(p(i) - mu_n(i));
	end

	d = 1/2 * d_sum;
end