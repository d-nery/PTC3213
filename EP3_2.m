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

potencial_interno = 100; % Potencial do condutor interno

% Dimensoes (m)
a = 11e-2;     
b = 6e-2;      % Leb
c = 3e-2;      % nusp7 = 1
d = b - 3e-2;  % nusp6 = 6
g = 2e-2;      % nusp5 = 0
h = (b-d)/2;

% Delta para divis�o da malha e precis�o
delta = 1e-3;

m = b/delta;          %numero de linhas
n = a/delta;          %numero de colunas
bve = g/delta;        %borda vertical da esquerda do condutor interno
bvd = (g+c)/delta;    %borda vertical da direita do condutor interno
bhs = (b-d-h)/delta;  %borda horizontal superior do condutor interno
bhi = (b-h)/delta;    %borda horizontal inferior do condutor interno

A = zeros(m, n);
A(bhs:bhi, bve:bvd) = 100;

diff = 1;

%% Matriz de potenciais
% Itera ate a diferenca maxima entre dois pontos consecutivos
% ser menor que 0.001
while diff >= 0.001
   diff = 0;
   for l = 2:m-1
       for c = 2:n-1
           % Nao e necessario computar os pontos dentro do condutor interno
           if A(l,c) ~= 100
               ant = A(l,c);
               A(l,c) = (A(l-1,c) + A(l+1, c) + A(l, c - 1) + A(l, c + 1))/4;
               if (abs(A(l,c) - ant) >= diff)
                   diff = abs(A(l,c) - ant);
               end
           end
       end
   end
end

% Calculo do campo magnetico para uma superficie de interesse
B = 0.25*(2*A(1,1) + A(2,1) + 2*A(m,1) + 2*A(m,n) + 2*A(1,n) + A(2,n) - A(2,2) - 2*A(m-1,2) - 2*A(m-1,n-1) - A(2,n-1));

for i = 2:m-2
    B = B + 0.5*(A(i,1) + A(i+1,1) + A(i,n) + A(i+1,n) - A(i,2) - A(i+1,2) - A(i,n-1) - A(i+1,n-1));
end

for j=2:n-2
    B = B + 0.5*(A(m,j) + A(m,j+1) + A(1,j) + A(1,j+1) - A(m-1,j) - A(2,j) - A(m-1,j+1) - A(2,j+1));
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
contour(A, 0:10:100);
% contour(E, 0:tc:100); % Esse intervalo aqui depende dos tubos de corrente la,tem que fazer a conta
axis([-10 280 -10 150]);
axis equal;

% Desenho do condutor externo
rectangle('Position', [0 0 n m]);

