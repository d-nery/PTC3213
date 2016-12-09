%% Exerc�cio Computacional de Eletromagnetismo(MATLAB)

%Dimens�es da figura estudada(m)
a = 0.11;
b = 0.05;
c = 0.04;
d = 0.01;
g = 0.04;
h = 0.02;

%Espessura(m)
e = 1;

%Permeabilidade magn�tica do v�cuo(H/m)
u0 = 1.2566e-6;

%Permissividade el�trica do meio condutor estudado(F/m)
u = u0;

%Potencial vetor do condutor interno(Wb/m)
Azi = 100e-6;

%Potencial vetor do condutor externo(Wb/m)
Aze = 0;

%% ***M�todo das Diferen�as Finitas***

%Dimens�es da matriz de potencias 
n = 11*20+1;
m = 5*20+1;

%Matriz de potenciais
Az = zeros(m,n);

%Determianando o potencial do eletrodo interno (Condi��o de Contorno Dirichlet)
for i = (2*(m-1)/5)+1:(3*(m-1)/5)+1
    for j = (4*(n-1)/11)+1:(8*(n-1)/11)+1
        Az(i,j) = Azi;
    end
end

%Condi��o de parada
STOP_COND = 1e-10;

%Erro
ERRO = 0;

%Erro m�ximo obtido em uma itera��o
MAX_ERRO = 1e-9;

%Numero de itera��es realizadas
N = 0;

%C�lculo dos potenciais por itera��es. A condi��o de parada do algoritmo corresponde
%ao momento em que a diferen�a entre o valor atual do potencial e o calculado na
%itera��o anterior for menor menor que STOP_COND, indicando que os valores
%dos potenciais do reticulado atingiram uma boa estabilidade 
while(MAX_ERRO > STOP_COND)
    MAX_ERRO = 0;
    %Varredura da matriz de potenciais
    for i = 2:(m-1)
        for j = 2:(n-1)
            %Condi�ao necess�ria para impedir altera��es no potencial do
            %eletrodo interno(100V)
            if Az(i,j) ~= 100e-6 
                Azant = Az(i,j);                
                Az(i,j) = (Az(i-1,j) + Az(i+1,j) + Az(i,j-1) + Az(i,j+1))/4;
                ERRO = abs((Az(i,j) - Azant));
                
                %Guarda-se o maior erro obtido na varredura de uma itera��o
                if ERRO > MAX_ERRO
                    MAX_ERRO = ERRO;
                end
            end
        end
    end
    N = N+1;
end

surface(Az);

% %% ***C�lculo da Corrente, Resist�ncia e Capacit�ncia***
% 
% %Soma dos potenciais adjacentes � borda do condutor externo
% soma = 0;
% 
% for i = 2:(m-1)
%     %Soma de potenciais adjacentes �s bordas verticais
%     soma = soma + P(i,n-1) + P(i,2);
% end
% 
% for j = 2:(n-1) 
%     %Soma de potenciais adjacentes �s bordas horizontais
%     soma = soma + P(2,j) + P(m-1,j);
% end
% 
% %C�lculo da corrente total(A)
% I = soma*sigma*L; 
% 
% %C�culo da resist�ncia(Ohms)
% R = Vo/I;
% 
% %C�lculo da capacit�ncia(F)
% C = epsilon/(sigma*R);
% 
%% ***C�lculo da Indut�ncia***

%Dimens�es de uma c�lula do reticulado(Dx = Dy)
Dx = 0.11/(n-1); %(m)
Dy = 0.05/(m-1); %(m)

%Visando o c�lculo da corrente I, escolhemos uma superf�cie S que englobasse
%o maior n�mero de tubos de fluxo magn�tico. Dessa forma, a borda da
%superf�cie escolhida, sobre a qual integramos o vetor campo magn�tico(H),
%� adjacente � borda da superf�cie externa. 

%Componentes horizontal(Bx) e vertical(By) dos vetores de indu��o
%magn�tica. A primeira linha da matriz Bx corresnponde aos valores dos 
%vetores na borda superior da superf�cie S, enquanto a segunda linha corresponde
%aos vetores na borda inferior. De forma an�loga, a primeira linha da matriz By 
%corresponde aos valores dos vetores na borda direita da superf�cie S,
%enquanto a segunda linha corresponde aos vetores da borda esquerda. 
Bx = zeros(2,n-2);
By = zeros(2,m-2);

%Borda superior de S:
for j = 2:n-1
    Bx(1,j-1) = (Az(1,j) - Az(2,j))/Dx;
end

%Borda inferior de S:
for j = 2:n-1
    Bx(2,j-1) = (Az(end-1,j) - Az(end,j))/Dx;
end

%Borda direita de S:
for i = 2:m-1
    By(1,i-1) = (-Az(i,end) + Az(i,end-1))/Dy;
end

%Borda esquerda de S:
for i = 2:m-1
    By(2,i-1) = (-Az(i,2) + Az(i,1))/Dy;
end

%C�lculo da corrente(A)    
I = (1/u)*(Dx*sum(Bx(2,:)) - Dx*sum(Bx(1,:)) + Dy*sum(By(1,:)) - Dy*sum(By(2,:)));

%C�lculo do fluxo magn�tico(Wb)
Fluxo = (Azi - Aze)*e;

%C�lculo da indut�ncia dos condutores(H)
L = Fluxo/I;

%% ***Linhas de Campo Magn�tico***

%Defini��o do dom�nio das curvas equipotenciais
x = linspace(0,0.11,n);
y = linspace(0,0.05,m);

[X,Y] = meshgrid(x,y);

figure
%Gr�fico das curvas equipotenciais(espa�adas em 10V)
E = contour(X,Y,Az,0:10e-6:100e-6);
grid;
title(['Mapa dos Quadrados Curvil�neos (',num2str(m),'x',num2str(n),',\Delta=',num2str(b/(m-1)),')']);
xlabel('X(m)');
ylabel('Y(m)');
clabel(E);
