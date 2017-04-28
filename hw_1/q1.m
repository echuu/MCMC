%% question 1

%% part 1. 

K_0 = [  0  0.7  0.3    0     0;
       0.2    0  0.6    0   0.2;
         0  0.4    0  0.5     0;
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
[V0, D0] = eig(K_0);
[V1, D1] = eig(K_1);
[V2, D2] = eig(K_2);



%% part 3. how many, what are the invariant probabilities?



%% part 4. plot eigenvalues as dots on 2-D plane (inside unit circle)

K_01 = K_0^50;
K_02 = K_0^200;

[~, lambda_01] = eig(K_01);
[~, lambda_02] = eig(K_02);

%% part 5. print out K_0^200, see if ideal matrix (each row is pi)

K_02
