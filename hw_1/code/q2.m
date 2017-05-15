
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
x0 = 1;           % initial state

lambdas = abs(diag(D0)); % complex modulus of eigenvalues
lbda_2  = lambdas(2);     % lambda_slem

% store results for each iteration
tv  = zeros(n, 1);
kl  = zeros(n, 1);
ck  = zeros(n, 1); % bound A
dh  = zeros(n, 1); % bound B

ck1 = contraction(K_0);

% iterate 1:n, calculate both norms
for i = 1:n
	mu_n = nu * K_0^i;
	tv(i) = tv_norm(mu_n, p);
	kl(i) = kl_norm(mu_n, p);
	ck(i) = ck1^i;
	dh(i) = dh_bound(p, lbda_2, i, x0);
end

norm_results = [tv kl ck dh];
csvwrite('norm_results.csv', norm_results);



