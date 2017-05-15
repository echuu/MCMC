% calculate the contraction coefficient given
	% K : transition matrix
function c_k = contraction(K)
	% contraction coefficient for K is the max-TV-norm
	% between any two rows in the transition kernel
	max_c = 0;
	num_rows = size(K, 1);
	
	for r = 1:num_rows
		for rr = (r+1):num_rows
			% calculate tv-norm for rows r, rr
			c = tv_norm(K(r,:), K(rr,:));
			if c > max_c
				max_c = c;
			end
		end
	end
	c_k = max_c;
end
