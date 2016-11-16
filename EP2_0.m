%EP2_0.m

%PTC 3212 - Eletromagnetismo
%2º Exercício Programa

%Cálculo de carga e capacitrância para um único cilindro

%ITEM 1)
%permissividade do meio:
eps0 = 8.854e-12;

%raio do cilindro 1:
R1=2e-2;

%define raio dos cilindros de carga uniforme (discretização):
a=1e-4; %esse valor fornece um erro de 0,02%

%calcula número de cilindros uniformemente sobre o(s) corpo(s):
N1=round((2*pi*(R1/2))/a);

%determinando as coordenadas dos eixos do cilindro 1(x e y):

i=1:N1;
phi=(i-1)*(2*pi/N1);
x=R1*cos(phi);
y=R1*sin(phi)+h1;

%caso haja M corpos (cilindro ou plano ou qualquer outra coisa) calcular
%as coordenadas dos cilindros de carga para casa um deles e incluir
%nos vetores x e y acima
%sendo então N = N1 + N2 + .... + NM
N=N1; 

%cria matriz de indices i e j, de dimensão NXN:
i=1:N; 
j=i;
[i,j]=meshgrid(i,j);

%calcula os valores de r1 e r2 para cada i,j.
%Note que, para i==j, r1 tem que ser = a.
r1=sqrt((x(i) - x(j)).^2 + (y(i)-y(j)).^2);
%acha os elementos da matriz onde i==j:
ind=find(i==j);
%redefine r1=a nesses indices:
r1(ind)=a*ones(size(ind));

r2=sqrt((x(i)-x(j)).^2+(y(i)+y(j)).^2);

%calcula matriz S (por metro de comprimento):
S=log(r2./r1)/(2*pi*eps0);

V1=1;
V=ones(N1,1)*V1;

lambda=S\V;
