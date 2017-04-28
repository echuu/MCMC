%% q1.m
%% question 1

%% part 1.
K_0 = [  0  0.7  0.3    0     0;
       0.2    0  0.6    0   0.2;
       0.1  0.4    0  0.5     0;
         0  0.3   0.4   0   0.3;
         0    0   0.3 0.7     0];

K_1 = [0.2  0.4  0.3    0   0.1;
       0.5  0.3  0.2    0     0;
         0  0.4  0.5  0.1     0;
         0    0    0  0.3   0.7;
         0    0    0  0.7   0.3];

K_2 = [  0    0    0  0.4   0.6;
         0    0    0  0.3   0.7;
         0    0    0  0.8   0.2;
         0  0.8  0.2    0     0;
       0.3    0   0.7   0     0];

%% part 2. print out 5 eigen-values and 5 left eigen-vectors
[V0, D0] = eig(K_0.');
[V1, D1] = eig(K_1.');
[V2, D2] = eig(K_2.');

left_evec = V0(:,1);
norm_left = abs(left_evec / norm(left_evec, 1))'; % left eigen-vector


%% part 3. how many, what are the invariant probabilities?
%  axis([-1 1 -1 1])
%  scatterplot(lambda_0)


%% part 4. plot eigenvalues as dots on 2-D plane (inside unit circle)
K_01 = K_0^50;
K_02 = K_0^200;

[~, D01] = eig(K_01);
[~, D02] = eig(K_02);



%% plot D0, lambda_01, lambda_02 on 2-D plane
lambda_0  = sort(diag(D0),  'descend');
lambda_01 = sort(diag(D01), 'descend');
lambda_02 = sort(diag(D02), 'descend');


re = [real(lambda_0); real(lambda_01); real(lambda_02)];
im = [imag(lambda_0); imag(lambda_01); imag(lambda_02)];

e_values = [re im]
csvwrite('eigenvalues.csv', e_values);


%% part 5. print out K_0^200, see if ideal matrix (each row is pi)

K_02
