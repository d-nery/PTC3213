%EP2_5.m

h1=9.26;
EP2_0 %fornece os valores de eps0, R1, N1, etc

V2=1000;

Q1=sum(lambda(1:N1));

C1=1000*Q1;

%energia anterior ao deslocamento
We1=0.5*C1*(V2^2);

%novos parâmetros
h1=9.261; %supondo um deslocamento de 1mm para cima

EP2_0 

Q2=sum(lambda(1:N1));

C2=1000*Q2;

%cálculo da energia depois de deslocar
We2=0.5*C2*(V2^2);

%cálculo da força
F=(We2 - We1)/0.001 %na direção j