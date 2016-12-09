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

V = zeros(b_matriz, a_matriz);
V(bhd:bh, g_matriz:gc) = 100;

diff = 1;

%% Matriz de potenciais
% Itera ate a diferenca maxima entre dois pontos consecutivos
% ser menor que 0.001
while diff >= 0.001
   diff = 0;
   for l = 2:b_matriz-1
       for c = 2:a_matriz-1
           % Nao e necessario computar os pontos dentro do condutor interno
           if V(l,c) ~= 100
               ant = V(l,c);
               V(l,c) = (V(l-1,c) + V(l+1, c) + V(l, c - 1) + V(l, c + 1))/4;
               if (abs(V(l,c) - ant) >= diff)
                   diff = abs(V(l,c) - ant);
               end
           end
       end
   end
end

%% Campo Magnetico (Dual)
% Matriz para as linhas de campo
B2 = zeros(size(V));
[l, c] = size(B2);
meio = (l+1)/2;

B2(meio, 1:g_matriz) = 100; % Lado "A"
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
B = 0.25*(2*V(1,1) + V(2,1) + 2*V(m,1) + 2*V(m,n) + 2*V(1,n) + V(2,n) - V(2,2) - 2*V(m-1,2) - 2*V(m-1,n-1) - V(2,n-1));

for i = 2:m-2
    B = B + 0.5*(V(i,1) + V(i+1,1) + V(i,n) + V(i+1,n) - V(i,2) - V(i+1,2) - V(i,n-1) - V(i+1,n-1));
end

for j=2:n-2
    B = B + 0.5*(V(m,j) + V(m,j+1) + V(1,j) + V(1,j+1) - V(m-1,j) - V(2,j) - V(m-1,j+1) - V(2,j+1));
end
B=-B;

% Calculo da corrente (ou integral de linha em curva fechada do campo magnetico)
I = 1/mi0 * B;
% Calculo da inutância
L = potencial_interno/I; 

%% Mapa de quadrados curvil�neos (b)
f1 = figure;
f1.Name = 'Potencial Eletrico';
hold on;
colormap cool;
colorbar;
title('Quadrados Curvilineos');

% Cria as linhas equipotenciais espacadas em 10V
contour(V, 0:10:100);
contour(B2, 0:tc:100); % Esse intervalo aqui depende dos tubos de corrente la,tem que fazer a conta
axis([-10 280 -10 150]);
axis equal;

% Desenho do condutor externo
rectangle('Position', [0 0 a_matriz b_matriz]);

