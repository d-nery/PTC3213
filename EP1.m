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
axis([-0.01 0.12 -0.01 0.07])
axis equal
