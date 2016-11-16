%EP2_1_2.m

%ITEM 1)
EP2_0

%distância do eixo do cilindro 1 ao plano condutor:
h1=9.26;

%distância do eixo da placa 2 ao plano condutor:
h2=9.37;

%distância do eixo do cilindro 3 ao plano condutor:
h3=10;

%comprimento da placa condutora:
d=20e-2;

%raio do cilindro 3:
R3=1e-2;

%calcula número de cilindros uniformemente sobre o(s) corpo(s):
N2=round(d/(2*a));
N3=round((2*pi*(R3/2))/a);

%determinando as coordenadas dos eixos do cilindro 1(x e y):

i=1:N1;
phi=(i-1)*(2*pi/N1);
x1=R1*cos(phi);
y1=R1*sin(phi)+h1;

%determinando as coordenadas dos eixos da placa 2(x e y):

i=1:N2;
x2=a*(2*i-N2-1);
y2(i)=h2;

%determinando as coordenadas dos eixos do cilindro 3(x e y):

clear phi;
i=1:N3;
phi=(i-1)*(2*pi/N3);
x3=R3*cos(phi);
y3=R3*sin(phi)+h3;

%caso haja M corpos (cilindro ou plano ou qualquer outra coisa) calcular
%as coordenadas dos cilindros de carga para casa um deles e incluir
%nos vetores x e y acima
x=[x1 x2 x3];
y=[y1 y2 y3];
%sendo então N = N1 + N2 + .... + NM
N=N1+N2+N3; %3 corpos

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

%calcula Cij':
for j=1:3
    if j==1
        V1=1; 
        V2=0;
        V3=0;
    elseif j==2
        V1=0; 
        V2=1;
        V3=0;
    else
        V1=0; 
        V2=0;
        V3=1;
    end
    V=[ones(N1,1)*V1; ones(N2,1)*V2; ones(N3,1)*V3];
    lambda=S\V;
    Q(1,j)=sum(lambda(1:N1));
    Q(2,j)=sum(lambda(N1+1:N1+N2));
    Q(3,j)=sum(lambda(N1+N2+1:N));
    for i=1:3
        C12(i,j)=Q(i,j)/1;
    end
end

C12;

%ITEM 2)
Csum = sum(C12,2);
C12eq10=Csum(1,1);
C12eq20=Csum(2,1);
C12eq30=Csum(3,1);
C12eq12=-C12(1,2);
C12eq23=-C12(2,3);
C12eq13=-C12(1,3);




