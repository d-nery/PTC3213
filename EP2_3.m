%EP2_3.m

%ITEM 3)

EP2_1_2

%caso haja M corpos (cilindro ou plano ou qualquer outra coisa) calcular
%as coordenadas dos cilindros de carga para casa um deles e incluir
%nos vetores x e y acima
x=[x1 x3];
y=[y1 y3];
%sendo então N = N1 + N2 + .... + NM
N=N1+N3; %3 corpos

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
for j=1:2
    if j==1
        V1=1; 
        V3=0;
    else
        V1=0; 
        V3=1;
    end
    V=[ones(N1,1)*V1; ones(N3,1)*V3];
    lambda=S\V;
    Q(1,j)=sum(lambda(1:N1));
    Q(2,j)=sum(lambda(N1+1:N));
    for i=1:2
        C3(i,j)=Q(i,j)/1;
    end
end

C3;

Csum = sum(C3,2);
C3eq10=Csum(1,1);
C3eq30=Csum(2,1);
C3eq13=-C3(1,2);
