% NUSP: 9350161 TURMA: LEB
% C = 3, D = B - 3, G = 2, H = ( B - D )/2
% Potencial vetor interno: 100 uWb/m� 
% Potencial vetor externo: 0 
% Equipotenciais de 10uWb/m

a = 11;
b = 6;
c = 3;
d = 4;
g = 2;
h = (b-d)/2;
delta = 0.1;
prec = 0.001;
m = b/delta;          %n�mero de linhas
n = a/delta;          %n�mero de colunas
bve = g/delta;        %borda vertical da esquerda do condutor interno
bvd = (g+c)/delta;    %borda vertical da direita do condutor interno
bhs = (b-d-h)/delta;  %borda horizontal superior do condutor interno
bhi = (b-h)/delta;    %borda horizontal inferior do condutor interno
%sigma = 0.0032;        %valor da condut�ncia
%sigma1 = 0.003;       %valor da condut�ncia no problema dual
%epsilon = 1.9*8.854188E-12;
%epsilon1 = 8.854188E-12;
mi0 = 4*pi*1E-7; %permeabilidade mag�tica no v�cuo
potInter = 100;

A = zeros(m,n);

%imp�e os potenciais nas bordas do condutor interno
A(bhs : bhi,bve : bvd) = potInter;

%Realiza as itera�oes ate a maior diferen�a entre duas itera�oes ser menor que prec
erro = 1;
while (erro > prec)
    erro = 0;
    for i = 2 : m - 1
        for j = 2 : n - 1
            if (A(i,j)~= 100)
                valant = A(i,j);
                A(i,j) = (A(i-1,j)+A(i+1,j)+A(i,j-1)+A(i,j+1))/4;
                erro1 = abs(A(i,j)-valant);
                if (erro1 > erro)
                    erro = erro1;
                end
            end
        end
    end
end

%c�lculo do campo magn�tico para uma superf�cie de interesse
B=0.25*(2*A(1,1) + A(2,1) + 2*A(m,1) + 2*A(m,n) + 2*A(1,n) + A(2,n) - A(2,2) - 2*A(m-1,2) - 2*A(m-1,n-1) - A(2,n-1));

for i=2:m-2
    B = B + 0.5*(A(i,1) + A(i+1,1) + A(i,n) + A(i+1,n) - A(i,2) - A(i+1,2) - A(i,n-1) - A(i+1,n-1));
end

for j=2:n-2
    B = B + 0.5*(A(m,j) + A(m,j+1) + A(1,j) + A(1,j+1) - A(m-1,j) - A(2,j) - A(m-1,j+1) - A(2,j+1));
end
B=-B;

%c�lculo da corrente (ou integral de linha em curva fechada do campo
%magn�tico
I = 1/mi0*B;

L = potInter/I;    %c�lculo da indut�ncia

% V2 = zeros(m,n);
% 
% %problema dual - para o tra�ado dos quadrados curvil�neos
% erro=1;
% while (erro>prec)
%     erro=0;
%     for i=1:m
%        for j=1:n
%             valant=V2(i,j);
%             if(i==m/2 && j<=bve)
%                 V2(i,j) = 100;
%             elseif (i==m/2 && j>=bvd)
%                 V2(i,j) = 0;
%             elseif (i<bhi && j>bve && j<bvd && i>bhs)
%                 V2(i,j) = NaN;
% 	        elseif (j==1 && i>1 && i<m)
%                 V2(i,j) = (V2(i-1,j) + V2(i+1,j) + 2*V2(i,j+1))/4;
%             elseif (j==1 && i==m)
%                 V2(i,j) = (2*V2(i-1,j) + 2*V2(i,j+1))/4;
%             elseif (i==m && j>1 && j<n)
%                 V2(i,j) = (2*V2(i-1,j) + V2(i,j-1) + V2(i,j+1))/4;
%             elseif (i==m && j==n)
%                 V2(i,j) = (2*V2(i-1,j) + 2*V2(i,j-1))/4;
%             elseif (i==1 && j==n)
%                 V2(i,j) = (2*V2(i+1,j) + 2*V2(i,j-1))/4;
%             elseif (j==n && i>1 && i<m)
%                 V2(i,j) = (V2(i-1,j) + V2(i+1,j) + 2*V2(i,j-1))/4;
%             elseif (i==1 && j>1 && j<n) 
%                 V2(i,j) = (2*V2(i+1,j) + V2(i,j-1) + V2(i,j+1))/4;
%             elseif (i==1 && j==1)
%                 V2(i,j) = (2*V2(i+1,j) + 2*V2(i,j+1))/4;
%             elseif (j==bvd && i>bhs && i<bhi && i~=m/2)
%                 V2(i,j) = (V2(i-1,j) + V2(i+1,j) + 2*V2(i,j+1))/4;
%             elseif (i==bhi && j>bve && j<bvd)
%                 V2(i,j) = (2*V2(i+1,j) + V2(i,j-1) + V2(i,j+1))/4;
%             elseif (j==bve && i>bhs && i<bhi && i~=m/2)
%                 V2(i,j) = (V2(i-1,j) + V2(i+1,j) + 2*V2(i,j-1))/4;
%             elseif (i==bhs && j>bve && j<bvd)
%                 V2(i,j) = (2*V2(i-1,j) + V2(i,j+1) + V2(i,j-1))/4;
%             else
%                 V2(i,j) = (V2(i-1,j) + V2(i+1,j) + V2(i,j-1) + V2(i,j+1))/4;
%             end
%             if (i>=bhi || j<=bve || j>=bvd)
%                 erro1=abs(V2(i,j)-valant);
%                 if (erro1 > erro)
%                     erro=erro1;
%                 end
%             end
%        end
%     end
% end
% 
% %tra�a os quadrados curvil�neos
% m1 = 10;
% n1 = round((m1/(R*sigma)+1)/2);
% v1 = 0:10:100;
% x= 100/n1;
% v2 = 0:x:100;
% v1(1) = 1e-6;
% v2(1) = 1e-6;
% contour (V,v1), axis equal;
% hold on;
% contour (V2,v2);
% disp(R);
% disp(C);
% disp(R1);