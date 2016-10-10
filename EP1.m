%% PTC3213 - Eletromagnetismo
% Exercício Programa 1
% 14 de outubro de 2016
%
% Alunos
% Beatriz de Oliveira - 9350161
% Daniel Nery Silva de Oliveira - 9349051
% Mateus Almeida Barbosa - 9349072
%
% Turma 3 - Professor Leb

%%
% Limpa o espaço de trabalho e fecha as figuras abertas
clear;
close all;

%% Constantes
% Propriedades
epsilon0 = 8.85418782e-12; % permissividade elétrica no vácuo
epsilon = 1.9 * epsilon0;  % permissividade elétrica no meio
sigma = 3.2e-3; % S/m

% Dimensoes (m)
a = 11e-2;
b = 6e-2;
c = 3e-2;
d = b - 3e-2;
g = 2e-2;
h = (b-d)/2;

% Delta para divisão da malha e precisão
delta = 4e-4;

%% Conversão do retângulo para grade de pontos
% Distâncias convertidas para matriz de pontos
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

M = zeros(b_matriz, a_matriz);
M(bhd:bh, g_matriz:gc) = 100;

i=0;
diff = 1;

%% 
% Computa a matriz de potenciais
% Itera ate a diferenca maxima entre dois pontos consecutivos
% ser menor que 0.01
while diff >= 0.001
   diff = 0;
   for l = 2:b_matriz-1
       for c = 2:a_matriz-1
           % Nao e necessario computar os pontos dentro do condutor interno
           if (M(l,c) ~= 100)
               ant = M(l,c);
               M(l,c) = (M(l-1,c) + M(l+1, c) + M(l, c - 1) + M(l, c + 1))/4;
               if (abs(M(l,c) - ant) >= diff)
                   diff = abs(M(l,c) - ant);
               end
           end
       end
   end
end

%% Campo Elétrico (Dual)
%
E = zeros(size(M));
[l, c] = size(E);
meio = (l+1)/2;

E(meio, 1:g_matriz) = 100;
E(meio:bh-1, g_matriz+1:gc-1) = NaN;
%%
k = 0;
diff = 1;
while diff > 0.001;
    diff = 0;
    for i = meio+1:l
        for j = 1:c
            if ~isnan(E(i,j))
                ant = E(i,j);
                if j == 1 && i < l
                    E(i,j) = (2*E(i,j+1) + E(i-1,j) + E(i+1,j))/4;
                elseif i < bh && j == g_matriz
                    E(i,j) = (2*E(i,j-1) + E(i-1,j) + E(i+1,j))/4;
                elseif i < bh && j == gc
                    E(i,j) = (2*E(i,j+1) + E(i-1,j) + E(i+1,j))/4;
                elseif i == bh && j > g_matriz && j < gc
                    E(i,j) = (2*E(i+1,j) + E(i, j-1) + E(i, j+1))/4;
                elseif j == c && i < l
                    E(i,j) = (2*E(i,j-1) + E(i-1,j) + E(i+1,j))/4;
                elseif i == l
                    if j == 1
                        E(i,j) = (2*E(i-1,j) + 2*E(i,j+1))/4;
                    elseif j == c
                        E(i,j) = (2*E(i-1,j) + 2*E(i,j-1))/4;
                    else
                        E(i,j) = (2*E(i-1,j) + E(i, j-1) +E(i, j+1))/4;
                    end
                else
                    E(i,j) = (E(i+1,j) +E(i-1,j) + E(i,j+1) + E(i,j-1))/4;
                end
                if (abs(E(i,j) - ant) >= diff)
                   diff = abs(E(i,j) - ant);
                end
            end
        end
    end
end

E2 = flipud(E);
E(1:meio,:) = E2(1:meio,:);

%% Desenho da figura
f1 = figure;
f1.Name = 'Potencial Eletrico';
hold on;
colormap cool;
colorbar;
title('Quadrados Curvilíneos');
%imagesc(M);

% Cria as linhas equipotenciais espacadas em 10V
contour(M, 0:10:100);
contour(E, 0:2:100); % Esse intervalo aqui depende dos tubos de corrente la,tem que fazer a conta
axis([-10 280 -10 150]);
axis equal;

% Desenho do condutor externo
rectangle('Position', [0 0 a_matriz b_matriz]);

%%