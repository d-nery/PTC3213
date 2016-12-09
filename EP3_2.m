%% PTC3213 - Eletromagnetismo
% Exercicio Programa 3
% 14 de outubro de 2016
%
% Alunos
% Beatriz de Oliveira - 9350161
% Daniel Nery Silva de Oliveira - 9349051
% Mateus Almeida Barbosa - 9349072
%
% Turma 3 - Professor Leb

%%
% Limpa o espaco de trabalho e fecha as figuras abertas
%clear;
close all;

%% Constantes
% Propriedades
mi0 = 4*pi*1e-7; % permeabilidade magnetica no vacuo

potencial_interno = 100e-6; % Potencial do condutor interno

% Dimensoes (m)
a = 11e-2;     
b = 6e-2;      % Leb
c = 3e-2;      % nusp7 = 1
d = b - 3e-2;  % nusp6 = 6
g = 2e-2;      % nusp5 = 0
h = (b-d)/2;

% Delta para divisao da malha e precisao
delta = 4e-4;

%% Conversao do retangulo para grade de pontos
% Distancias convertidas para matriz de pontos
a_matriz = round(a/delta) + 1;
b_matriz = round(b/delta) + 1;
c_matriz = round(c/delta) + 1;
d_matriz = round(d/delta) + 1;
g_matriz = round(g/delta) + 1;
h_matriz = round(h/delta) + 1;

% Outras medidas
gc  = round((g+c)/delta) + 1;
bhd = round((b-h-d)/delta) + 1;
bh  = round((b-h)/delta) + 1;

A = zeros(b_matriz, a_matriz);
A(bhd:bh, g_matriz:gc) = 100e-6;

diff = 1;

%% Matriz de potenciais
% Itera ate a diferenca maxima entre dois pontos consecutivos
% ser menor que 0.001
while diff >= 1e-10
   diff = 0;
   for l = 2:(b_matriz-1)
       for c = 2:(a_matriz-1)
           % Nao e necessario computar os pontos dentro do condutor interno
           if A(l,c) ~= 100e-6;
               ant = A(l,c);
               A(l,c) = (A(l-1,c) + A(l+1, c) + A(l, c - 1) + A(l, c + 1))/4;
               if (abs(A(l,c) - ant) > diff)
                   diff = abs(A(l,c) - ant);
               end
           end
       end
   end
end


%% Campo Magnetico (Dual)
% Matriz para as linhas de campo
B2 = zeros(size(A));
[l, c] = size(B2);
meio = (l+1)/2;

B2(meio, 1:g_matriz) = 100e-6; % Lado "A"
B2(meio:bh-1, g_matriz+1:gc-1) = NaN; % Interior do quadrado

diff = 1;
while diff > 0.001;
    diff = 0;
    for i = meio+1:l
        for j = 1:c
            if ~isnan(B2(i,j))
                ant = B2(i,j);
                if j == 1 && i < l
                    B2(i,j) = (2*B2(i,j+1) + B2(i-1,j) + B2(i+1,j))/4;
                elseif i < bh && j == g_matriz
                    B2(i,j) = (2*B2(i,j-1) + B2(i-1,j) + B2(i+1,j))/4;
                elseif i < bh && j == gc
                    B2(i,j) = (2*B2(i,j+1) + B2(i-1,j) + B2(i+1,j))/4;
                elseif i == bh && j > g_matriz && j < gc
                    B2(i,j) = (2*B2(i+1,j) + B2(i, j-1) + B2(i, j+1))/4;
                elseif j == c && i < l
                    B2(i,j) = (2*B2(i,j-1) + B2(i-1,j) + B2(i+1,j))/4;
                % Borda inferior
                elseif i == l
                    if j == 1
                        B2(i,j) = (2*B2(i-1,j) + 2*B2(i,j+1))/4;
                    elseif j == c
                        B2(i,j) = (2*B2(i-1,j) + 2*B2(i,j-1))/4;
                    else
                        B2(i,j) = (2*B2(i-1,j) + B2(i, j-1) +B2(i, j+1))/4;
                    end
                else
                    B2(i,j) = (B2(i+1,j) +B2(i-1,j) + B2(i,j+1) + B2(i,j-1))/4;
                end
                if (abs(B2(i,j) - ant) >= diff)
                   diff = abs(B2(i,j) - ant);
                end
            end
        end
    end
end

% Rebate a matriz
B3 = flipud(B2);
B2(1:meio,:) = B3(1:meio,:);
clear B3;

% Calculo do campo magnetico para uma superficie de interesse
B = 0.25*(2*A(1,1) + A(2,1) + 2*A(b_matriz,1) + 2*A(b_matriz,a_matriz) + 2*A(1,a_matriz) + A(2, a_matriz) - A(2,2) - 2*A(b_matriz-1,2) - 2*A(b_matriz-1,a_matriz-1) - A(2,a_matriz-1));

for i = 2:b_matriz-2
    B = B + 0.5*(A(i,1) + A(i+1,1) + A(i,a_matriz) + A(i+1,a_matriz) - A(i,2) - A(i+1,2) - A(i,a_matriz-1) - A(i+1,a_matriz-1));
end

for j=2:a_matriz-2
    B = B + 0.5*(A(b_matriz,j) + A(b_matriz,j+1) + A(1,j) + A(1,j+1) - A(b_matriz-1,j) - A(2,j) - A(b_matriz-1,j+1) - A(2,j+1));
end
B=-B;

% Calculo da corrente (ou integral de linha em curva fechada do campo magnetico)
I = 1/mi0 * B;
% Calculo da inutÃ¢ncia
L = potencial_interno/I; 

%% Mapa de quadrados curvilï¿½neos (B)

x = linspace(0,a,a_matriz);
y = linspace(0,b,b_matriz);

[X,Y] = meshgrid(x,y);

figure

B = contour(X,Y,A,0:10e-6:100e-6);
%contour(B2, 0:tc:100e-6); % Esse intervalo aqui depende dos tubos de corrente la,tem que fazer a conta
grid;
title(['Linhas de campo magnético']);
xlabel('X(m)');
ylabel('Y(m)');
clabel(B);

%% ***Intesidade da Corrente Superficial na Parede Externa Inferior***

%Dimensão de uma célula no eixo x
xl = a/(a_matriz -1);
for j = 1:a_matriz
    
    Hx(1,j) = ((A(end-1,j) - A(end,j))/xl)/mi0;
end

x = linspace(0,a,a_matriz);
%Construção do gráfico da intensidade de corrente superficial em relação
%ao eixo x
figure;
plot(x,Hx,'-b');
grid;
title('Intesidade da Corrente Superficial');
xlabel('X(m)');
ylabel('Jz(A/m^2)');


