%EP2_4.m

%ITEM 4) (Thévenin equivalente) 

Vg = 14000; %tensâo do gerador (V)
l  = 1000;  %tamanho dos condutores (m)
f  = 60;    %frequência do gerador de tensão (Hz)
w = 2*pi*f;   %frequência angular 
EP2_1_2  %constroi matriz de capacitâncias para caso de cilindros e 
            %placa serem os corpos condutores
C1 = C12;       
C1 = l * C1 ; %capacitâncias por metro

% Impedâncias 
Z10 = 1 / (i*w*C12eq10); 
Z20 = 1 / (i*w*C12eq20);
Z30 = 1 / (i*w*C12eq30);
Z12 = 1 / (i*w*C12eq12);
Z13 = 1 / (i*w*C12eq13); 
Z23 = 1 / (i*w*C12eq23);


% ITEM a): 

% Impedâncias entre o nó 3 e o terra
Zeq1 = (Z10 * Z12)/(Z10 + Z12);  %equivalente de Z10 com Z12  
Zeq3 = (Z23 * Z30)/(Z23 + Z30);  %equivalente de Z23 com Z30  
Z1 = Z13 + Zeq1;              %equivalente de Z13 em série
                                  %com Z10||Z12  
Z3 = (Z1 * Zeq3) / (Z1 + Zeq3);

% Corrente no nó 3
I = Vg / Z3;

% Divisor de corrente para encontrar a corrente que flui nó 1 e o terra
I1 = I * Zeq3 / (Z13 + Zeq1 + Zeq3);

VTh1 = I1 * Zeq1
ZTh1 = (Zeq1 * Z13) / (Zeq1 + Z13)




% ITEM b):

% Impedâncias na transformação estrela - triângulo
Z = Z12*Z23 + Z12*Z20 + Z20*Z23;
Za = Z/Z20;  
Zb = Z/Z23;  
Zc = Z/Z12;  

% Impedância equivalente entre nó 3 e o terra 
Zeqb = (Z10 * Zb) / (Z10 + Zb);
Zeqa = (Z13 * Za) / (Z13 + Za);
Zeqc = (Z30 * Zc) / (Z30 + Zc);
ZeqX = Zeqb + Zeqa;
Zeq30 = (ZeqX * Zeqc) / (ZeqX + Zeqc);

% Corrente no nó 3
I = Vg / Zeq30;

% Divisor de corrente para encontrar a corrente do nó 1 ao terra
I1 = I * Zeqc / (Zeqc + Zeqb + Zeqa);
 
VTh2 = I1 * Zeqb
ZTh2 = (Zeqb * Zeqa) / (Zeqb + Zeqa)



% ITEM c)
EP2_3 %Constroi matriz de capacitancias para o caso dos corpos condutores
       %serem apenas os cilindros
C2 = C3;       
C2 = l * C2 ; %capacitâcias por metro (o que na prática equivale ao próprio
               %C3

% Impedâncias
Z10 = 1 / (i*w*C3eq10);
Z30 = 1 / (i*w*C3eq30);
Z13 = 1 / (i*w*C3eq13);

%Impedância entre nó 3 e terra
Zs = Z13 + Z10;
Zeq30 = (Zs * Z30) / (Zs + Z30);

% Corrente no nó 3
I = Vg / Zeq30;

% Divisor de corrente para encontrar a corrente que flui pelo Nï¿½ 1 em direï¿½ï¿½o ao terra
I1 = I * Z30 / (Z30 + Zs);

VTh3 = I1 * Z10
ZTh3 = (Z10* Z13) / (Z10 + Z13)

% Capacitâncias equivalentes de Thévenin
CTh1 = 1 / (i*w*ZTh1)
CTh2 = 1 / (i*w*ZTh2)
CTh3 = 1 / (i*w*ZTh3)