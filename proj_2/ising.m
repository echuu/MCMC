
%% ising.m
%% gibbs sampler from ising model

nTrials = 2000;
startup = 3000;

beta = 0.01; % beta = 1 / temperature
M = 0;

x  = 2 * round(rand(1,4)) - 1; % random 4 vector of +/-1
Hx = -(x(1) * x(2) + x(3) * x(4) + x(1) * x(3) + x(2) * x(4));

for t = 1:startup+nTrials
	k    = fix(1 + 4*rand);
	y    = x;
	y(k) = -x(k);
	Hy   = -(y(1) * y(2) + y(3) * y(4) + y(1) * y(3) + y(2) * y(4));
	h    = min(1, exp(-beta * (Hy - Hx)));
	if rand < h
		x = y;
	end
	if t > startup
		Mx = sum(x);
		M = M + Mx;        % average magnetic moment
		d(t-startup) = Mx; % store the magnetic moment
	end
end

r = -4:1:4;
hist(d, r);
M = (M / nTrials) / 4;



