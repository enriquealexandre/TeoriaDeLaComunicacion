function y = moduladorDBL(x, x_c)
%function y = moduladorAM(x, x_c)
%
% Modula una señal en DBL.
% Entradas:
%   - x: Señal moduladora 
%   - x_c: Portadora
% Salidas:
%   - y: Señal modulada en DBL

y = x.*x_c;                  