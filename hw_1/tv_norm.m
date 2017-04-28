

% tv_norm.m
% calculate the tv norm given 
	% p:  stationary distribution
	% K:  transition matrix
	% n:  steps
	% v0: initial distribution 
function d = tv_norm(v1, v2)

	d_sum = 0;
	num_states = numel(v1);

	for i = 1:num_states
		d_sum = d_sum + abs(v1(i) - v2(i));
	end

	d = 1/2 * d_sum;
end