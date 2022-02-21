# Tema 2 - Modulaciones analógicas

Aquí hay algunos ejemplos relacionados con las modulaciones analógicas vistas en clase.

*************************
EJEMPLOS EN CÓDIGO MATLAB
*************************

[detectorEnvolvente.m](detectorEnvolvente.m)

    Función que implementa un detector de envolvente.
    Incluye filtro pasobanda de sintonía, filtro paso bajo y supresión de continua.
    
[detectorFM.m](detectorFM.m)

    Función que implementa un detector de FM utilizando el mismo esquema que el mostrado en el problema 2.5 del boletín.

[detectorSincrono.m](detectorSincrono.m)

    Función que implementa un detector síncrono. 
    Incluye filtro pasobanda de sintonía, filtro paso bajo y supresión de continua.
    Se puede introducir un error tanto en la frecuencia como en la fase del oscilador local para ver sus efectos. 

[EjemploAM.m](EjemploAM.m)

    Script con un ejemplo completo de modulación AM. Se genera una señal moduladora, se modula en AM y se detecta tanto con un detector de envolvente como con uno síncrono. Se pueden visualizar todas las señales en el dominio del tiempo y de la frecuencia, y se pueden modificar todos los parámetros del sistema.

[EjemploDBL.m](EjemploDBL.m)

    Script con un ejemplo completo de modulación DBL. Se genera una señal moduladora, se modula en AM y se detecta con un detector síncrono. 
    Se pueden visualizar todas las señales en el dominio del tiempo y de la frecuencia, y se pueden modificar todos los parámetros del sistema.

[EjemploFM.m](EjemploFM.m)

    Script con un ejemplo completo de modulación FM. Se genera una señal moduladora, se modula en AM y se detecta con un detector de FM.
    Se pueden visualizar todas las señales en el dominio del tiempo y de la frecuencia, y se pueden modificar todos los parámetros del sistema.

[moduladorAM.m](moduladorAM.m)

[moduladorDBL.m](moduladorDBL.m)

[moduladorFM.m](moduladorFM.m)

    Moduladores para las tres modulaciones vistas en clase: AM, DBL y FM.


********************
EJEMPLOS EN SIMULINK
********************

Adicionalmente a los ejemplos realizados directamente en código Matlab, aquí hay algunos ejemplos realizados con Simulink. 
Todos han sido probados utilizando la versión R2021b de Matlab. 

[Simulink_AM.slx](Simulink_AM.slx)

    Aquí se muestra un ejemplo de modulación AM utilizando tanto un detector síncrono como uno de envolvente. 

[Simulink_DBL.slx](Simulink_DBL.slx)

    Lo mismo que para el caso de AM. Se muestra una modulación DBL, y la recepción se realiza tanto con un detector síncrono como con uno de envolvente, para ver qué sucede en este último caso. 

[Simulink_FM.slx](Simulink_FM.slx)

    Lo mismo, en este caso para una modulación FM. 

[Simulink_Audio.slx](Simulink_Audio.slx)

    Sistema con dos moduladores lineales (AM y DBL) en el que la señal de entrada es un archivo de audio. Se puede escuchar la señal recibida para distintas combinaciones de modulador/detector. 

[Simulink_Interferencia.slx](Simulink_Interferencia.slx)

    Ejemplo de receptor de FM con una interferencia sinusoidal. Se puede ver el resultado sin y con filtros de preénfasis y deénfasis.

[Simulink_Problema2_2.slx](Simulink_Problema2_2.slx)

    Ejemplo parecido al del problema 2.2 del boletín (los valores de las frecuencias son distintos para facilitar la visualización, pero la idea es la misma). Se trata de una señal AM a la que se le quita la banda lateral inferior, y se comprueba cómo se detecta con un detector de envolvente y con uno síncrono.
