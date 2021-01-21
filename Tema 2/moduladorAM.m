function [y, xc] = moduladorAM(x, Ac, fc, mu, fs)
%function [y, xc] = moduladorAM(x, Ac, fc, mu, fs)
%
% Modula una señal en AM.
% Entradas:
%   - x: Señal moduladora 
%   - Ac: Amplitud de la portadora (V)
%   - fc: Frecuencia de la portadora (Hz)
%   - mu: Índice de modulación
%   - fs: Frecuencia de muestreo (Hz)
% Salidas:
%   - y: Señal modulada en AM
%   - xc: Portadora

Ts = 1/fs;
t = 0:Ts:(Ts*length(x))-Ts; % Genero el vector de tiempos;
xn = x/max(abs(x));         % Normalizo la señal de entrada

xc = Ac*cos(2*pi*fc.*t);    % Portadora
y = (1 + mu*xn).*xc;        % Señal modulada

