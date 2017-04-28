

%% test.m

K = [0.3 0.6 0.1 0.0 0.0;
	 0.2 0.0 0.7 0.0 0.1;
	 0.0 0.5 0.0 0.5 0.0;
	 0.0 0.0 0.4 0.1 0.5;
	 0.4 0.1 0.0 0.4 0.1];


[v, d] = eig(K');


v1 = v(:,1);
left_v1 = v1 / norm(v1, 1);

v2 = v(:,2);
left_v2 = (v2 / norm(v2, 1)).';


lbda = sort(diag(d), 'descend');
re = [real(lbda)];
im = [imag(lbda)];

e_values = [re im]
csvwrite('eigenvalues.csv', e_values);


