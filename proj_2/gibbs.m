close all;
n = 64;
beta = 0.65;
nSweeps = 120;
mc1 = zeros(n, n) + 1;
mc2 = zeros(n, n);

mc1sum = zeros(1, nSweeps);
mc2sum = zeros(1, nSweeps);

num_points = 1:n*n;

if 1 == 1
	order = 1:n*n;
	for i = 1:120
		for j = 1:n*n
			[r, c] = ind2sub([n n], num_points(j));
			if i == 1
				disp([num2str(r), ', ' num2str(c)]);
			end
			nb1 = getNeighbors(r, c, mc1);
			nb2 = getNeighbors(r, c, mc2);

			p1 = exp(beta * sum(nb1 == 1));
			p1 = p1 / (p1 + exp(beta * sum(nb1 == 0)));

			p2 = exp(beta * sum(nb2 == 1));
			p2 = p2 / (p2 + exp(beta * sum(nb2 == 0)));

			u = rand();
			mc1(r, c) = u <= p1;
			mc2(r, c) = u <= p2;

		end
		mc1sum(i) = sum(sum(mc1));
		mc2sum(i) = sum(sum(mc2));
	end


	plot(1:120, mc1sum, 1:120, mc2sum)
end


