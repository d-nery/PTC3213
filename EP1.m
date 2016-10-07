%% PTC3213 - Eletromagnetismo
% Exercício Programa 1
% 14 de outubro de 2016
%
% Alunos
% Beatriz de Oliveira - 9350161
% Daniel Nery Silva de Oliveira - 9349051
% Mateus Almeida Barbosa - 9349072
% Turma 3 - Professor Leb

%%
% Limpa o espaço de trabalho e fecha as figuras abertas
clear;
close all;

%% Variaveis
% Propriedades
epsilon0 = 8.85418782e-12; % TODO Mudar aqui
epsilon = 1.9 * epsilon0;
sigma = 3.2e-3; % S/m
% Dimensoes (m)
a = 11e-2;
b = 6e-2;
c = 3e-2;
d = b - 3e-2;
g = 2e-2;
h = (b-d)/2;

%% Conversão do retângulo para grade de pontos
% Delta para divisão da malha e precisão
delta = 8e-4;

% Distâncias convertidas para matriz de pontos
am = floor(a/delta) + 1;
bm = floor(b/delta) + 1;
cm = floor(c/delta) + 1;
dm = floor(d/delta) + 1;
gm = floor(g/delta) + 1;
hm = floor(h/delta) + 1;
% Outras medidas
gcm = floor((g+c)/delta) + 1;
bhdm = floor((b-d-h)/delta) + 1;
bhm = floor((b-h)/delta) + 1;

M = zeros(bm, am);
M(bhdm:bhm, gm:gcm) = 100;

i=0;
diff = 1;
%%
f = figure;
colormap spring;
axis equal;
while diff >= 0.0001
   diff = 0;
   for l = 2:bm-1
       for c = 2:am-1
           if (c < gm || c > gcm || l > bhm || l < bhdm)
               ant = M(l,c);
               M(l,c) = (M(l-1,c) + M(l+1, c) + M(l, c - 1) + M(l, c + 1))/4;
               if (abs(M(l,c) - ant) >= diff)
                   diff = abs(M(l,c) - ant);
               end
           end
       end
   end
   %imagesc(M);
   %contour(M, 0:10:100)
   %pause(0.02);
   %i = i+1
end

%% Desenho da figura
f1 = figure;
hold on;
colormap cool;
%imagesc(M);
contour(M, 0:10:100);
axis([-10 150 -10 80]);
axis equal;
rectangle('Position', [0 0 am bm]);
% rectangle('Position', [gm hm cm-1 dm]);


%%