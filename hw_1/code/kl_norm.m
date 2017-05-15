% calculate the kl divergence norm given
	% p:  stationary distribution
	% K:  transition matrix
	% n:  steps
	% v0: initial distribution 
function d = kl_norm(v1, v2)

	d_sum = 0;
	num_states = numel(v1);

	for i = 1:num_states
		d_sum = d_sum + v2(i) * log(v2(i) / v1(i));
	end

	d = d_sum;
end