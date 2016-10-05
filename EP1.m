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
epsilon0 = 0; % TODO Mudar aqui
epsilon = 1.9 * epsilon0;
sigma = 3.2e-3; % S/m
% Dimensoes (m)
a = 11e-2;
b = 6e-2;
c = 3e-2;
d = b - 3e-2;
g = 2e-2;
h = (b-d)/2;

%% Desenho da figura
f1 = figure;
rectangle('Position', [0 0 a b])
rectangle('Position', [g h c d])
axis([-0.01 0.12 -0.01 0.07]);
axis equal;

%%
%delta
delta = 1e-4;
am = floor(a/delta) + 1;
bm = floor(b/delta) + 1;
gm = floor(g/delta) + 1;
gcm = floor((g+c)/delta) + 1;
bhdm = floor((b-d-h)/delta) + 1;
bhm = floor((b-h)/delta) + 1;


M = zeros(bm, am);
for i = gm:gcm
   M(bhdm, i) = 100;
   M(bhm, i) = 100;
end
for i = bhdm:bhm
   M(i, gm) = 100;
   M(i, gcm) = 100;
end

i=0;
while M(2,2) < 1e-10
   for l = 2:bhdm-1
       for c = 2:am-1
           M(l,c) = (M(l-1,c) + M(l+1, c) + M(l, c - 1) + M(l, c + 1))/4;
       end
   end
   for l = bhdm:bhm
       for c = 2:gm-1
           M(l,c) = (M(l-1,c) + M(l+1, c) + M(l, c - 1) + M(l, c + 1))/4;
       end
   end
   for l = bhdm:bhm
       for c = gcm+1:am-1
           M(l,c) = (M(l-1,c) + M(l+1, c) + M(l, c - 1) + M(l, c + 1))/4;
       end
   end
   for l = bhm+1:bm-1
      for c = 2:am-1
          M(l,c) = (M(l-1,c) + M(l+1, c) + M(l, c - 1) + M(l, c + 1))/4;
      end
   end
   i = i+1
end

%%