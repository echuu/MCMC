% calculate the tv norm given 
	% p      :  stationary distribution
	% lbda_2 :  transition matrix
	% n      :  steps 
	% x0     :  initial state
function bound = dh_bound(p, lbda_2, n, x0)

	ratio = (1 - p(x0)) / (4 * p(x0));

	bound = sqrt(ratio) * (lbda_2^n);
end