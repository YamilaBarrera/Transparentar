# transparentar
Surgida del Hackaton Agro 2016, transparentar es una aplicación que busca ayudar a la fiscalización y control en la problemática del descarte de pesca de la República Argentina. Los datos utilizados están publicados en http://agrodatos.info/

Problemática:
La pesca le representa al país un volumen de ingreso de divisas mayor que el de la ganadería. Sin embargo, debido a....

Motivación

La idea:
La hipótesis fundamental que subyace en el modelo empleado para analizar y encontrar las anomalías en los partes de pesca consiste en suponer que en cada cuadrante del mar las distintas especies de peces se distribuyen siguiendo una distribución multinormal. Si uno lanza una red al mar reiteradas veces va a pescar un número variable de peces que a su vez serán de diferentes especies con una probabilidad asociada a ese cuadrante en particular.

La información de cuáles son esas probabilidades viene dada fundamentalmente por la proporción de peces de cada especie que allí se encuentran. Si por ejemplo hay 2000 calamares y 1000 langostinos, las probabilidades de, a la hora de pescar al azar con una red, encontrarse con cada especie será de 2/3 y 1/3 respectivamente. Si ampliamos a más especies lo que surge es un modelo multinomial.

Como no se disponía de datos con los que saber de antemano esas proporciones lo que se hizo fue utilizar los mismos partes de pesca para estimarlas, a sabiendas de que los datos eran, por la naturaleza del problema encarado, sesgados. La idea se basa en que nadie sabe mentir estadísticamente bien, de modo que si utilizamos los datos combinados de todos los aprtes de pesca podemos encontrar anomalías mayores dentro de las anomalías globales.

Tomando los datos de las embarcaciones y la cantidad de peces pescada por cada una de ellas en cada cuadrante se promedia por especie las proporciones halladas y así se estima la proporción supuesta esperada por especie para esa región del mar argentino. Luego se buscan declaraciones de pesca cuya proporción de peces en alguna dada especie supere los 2 sigma de desviación respecto a la media encontrada en el análisis grupal. Y esos casos son anotados como anomalías. Sumando por cuadrante obtenemos un proporcional de cuántas anomalías hay en cada sector.

Problemáticas:

El modelo planteado es sencillo y acorde a las posibilidades de una Hackaton, sin embargo, al pensarlo no dejamos de lado la posibilidad de perfeccionar sus capacidades. hay que tener en cunenta varios factores más para que el modelo y por ende la detección de anomalías funcione con mayor precisión.

1) utilizar datos de varios años, de modo que los promedios se puedan estimar por mes. Como en la competencia disponíamos de pocos datos se promediaron lso 6 meses. Sin embargo, esto lleva a errores estadísticos por la propia variabilidad anual del recurso pesquero, las fluctuaciones del número de ejemplares de cada especie.

2) Hay que tener en cuenta la migración de las especies. Un modelo con ecuaciones diferenciales que considere el movimiento particular de cada especie marítima a lo alrgo del año y a través de los distintos cuadrantes mejoraría als estimaciones de los parámetros haciendo más específico y acertado el análisis.

3) La estimación de las proobabilidades o proporciones con las que cada pez puede ser pescado podrían obtenerse de algún sitio más fiable que los partes de pesca, en el sentido de que aquí se infiere a partir de loq ue se pescó sabiendose de antemano que hay sobrepesca no declarada de modo que lso datos en sí ya están sesgados.





