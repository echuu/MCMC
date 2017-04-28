
%% q2.m


% transition matrix
K_0 = [  0  0.7  0.3    0     0;
       0.2    0  0.6    0   0.2;
       0.1  0.4    0  0.5     0;
         0  0.3   0.4   0   0.3;
         0    0   0.3 0.7     0];

nu = [1 0 0 0 0]; % initial probability
p  = K_02(1,:);   % stationary distribution
n  = 200;         % steps

% store results for each iteration
tv = zeros(n, 1);
kl = zeros(n, 1);

% iterate 1:n, calculate both norms
for i = 1:n
	tv(i) = tv_norm(p, K_0, i, nu);
	kl(i) = kl_norm(p, K_0, i, nu);
end

norm_results = [tv kl];
csvwrite('norm_results.csv', norm_results);


