function y = moduladorAM(x, x_c, m)
%function y = moduladorAM(x, Ac, m)
%
% Modula una señal en AM.
% Entradas:
%   - x: Señal moduladora 
%   - xc: Portadora
%   - m: Índice de modulación
% Salidas:
%   - y: Señal modulada en AM

x_n = x/max(abs(x));         % Normalizo la señal de entrada (obligatorio en AM)

y = (1 + m*x_n).*x_c;        % Señal modulada

