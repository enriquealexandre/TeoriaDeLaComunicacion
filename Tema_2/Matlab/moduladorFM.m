function [y, xc] = moduladorFM(x, Ac, fc, fd, fs)
%function [y, xc] = moduladorFM(x, Ac, fc, fd, fs)
%
% Modula una señal en FM.
% Entradas:
%   - x: Señal moduladora 
%   - Ac: Amplitud de la portadora (V)
%   - fc: Frecuencia de la portadora (Hz)
%   - fd: Desviación de frecuencia (Hz/V)
%   - fs: Frecuencia de muestreo (Hz)
% Salidas:
%   - y: Señal modulada en FM

Ts = 1/fs;
t = 0:Ts:(Ts*length(x))-Ts; % Genero el vector de tiempos;
xn = x/max(abs(x));         % Normalizo la señal de entrada

xc = Ac*cos(2*pi*fc.*t);    % Genero la Portadora (no vale para nada, pero es para pintarla después)

integral = cumsum(xn*Ts);

y = Ac*cos(2*pi*fc.*t + 2*pi*fd.*integral);