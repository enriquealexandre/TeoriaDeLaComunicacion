function [y, xc] = moduladorDBL(x, Ac, fc, fs)
%function [y, xc] = moduladorAM(x, Ac, fc, fs)
%
% Modula una señal en DBL.
% Entradas:
%   - x: Señal moduladora 
%   - Ac: Amplitud de la portadora (V)
%   - fc: Frecuencia de la portadora (Hz)
%   - fs: Frecuencia de muestreo (Hz)
% Salidas:
%   - y: Señal modulada en DBL
%   - xc: Portadora

Ts = 1/fs;
t = 0:Ts:(Ts*length(x))-Ts; % Genero el vector de tiempos;

xc = Ac*cos(2*pi*fc.*t);    % Portadora
y = x.*xc;                  % Señal modulada