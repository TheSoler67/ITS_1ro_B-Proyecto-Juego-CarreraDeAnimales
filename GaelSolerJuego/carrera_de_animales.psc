// Carrera de animales con apuestas (perfil Flexible, arreglos desde 1)

Algoritmo CarreraDeAnimales
	Definir NUM_ANIMALES, META, TRAMPA, TURBO Como Entero;
	Definir DINERO_INICIAL, RONDAS, APUESTA_RIVAL_MIN, APUESTA_RIVAL_MAX Como Entero;
	NUM_ANIMALES <- 4;
	META <- 20;
	TRAMPA <- 7;                // regresa 2 casillas
	TURBO <- 12;                // avanza 3 casillas
	DINERO_INICIAL <- 100;
	RONDAS <- 4;
	APUESTA_RIVAL_MIN <- 10;    // lo que apuestan otros jugadores a los demas animales
	APUESTA_RIVAL_MAX <- 100;

	Definir nombres, simbolos Como Caracter;
	Definir posiciones, victorias, apuestas Como Entero;
	Dimension nombres[4], simbolos[4], posiciones[4], victorias[4], apuestas[4];
	nombres[1] <- "Tortuga";   simbolos[1] <- "T";
	nombres[2] <- "Liebre";    simbolos[2] <- "L";
	nombres[3] <- "Caballo";   simbolos[3] <- "C";
	nombres[4] <- "Perro";     simbolos[4] <- "P";

	Definir i Como Entero;
	Para i <- 1 Hasta NUM_ANIMALES Hacer
		posiciones[i] <- 0;
		victorias[i] <- 0;
		apuestas[i] <- 0;
	FinPara

	Definir dinero, ronda, ganadas, eleccion, apuesta, mejor, premio Como Entero;
	dinero <- DINERO_INICIAL;
	ronda <- 0;
	ganadas <- 0;

	MostrarInstrucciones(RONDAS, DINERO_INICIAL, META);

	Mientras ronda < RONDAS Y dinero > 0 Hacer
		ronda <- ronda + 1;
		Escribir "";
		Escribir "--- Carrera ", ronda, " de ", RONDAS, " | Tienes $", dinero, " ---";
		MostrarAnimales(nombres, victorias, NUM_ANIMALES);

		eleccion <- LeerEnteroEnRango("Animal", 1, NUM_ANIMALES);
		apuesta <- LeerEnteroEnRango("Apuesta", 1, dinero);
		dinero <- dinero - apuesta;       // tu apuesta sale de tu dinero

		GenerarApuestas(apuestas, NUM_ANIMALES, eleccion, apuesta, APUESTA_RIVAL_MIN, APUESTA_RIVAL_MAX);
		MostrarApuestas(nombres, apuestas, NUM_ANIMALES, eleccion);

		CorrerCarrera(nombres, simbolos, posiciones, NUM_ANIMALES, META, TRAMPA, TURBO);
		mejor <- PosicionGanadora(posiciones, NUM_ANIMALES);
		RegistrarGanadores(nombres, posiciones, victorias, NUM_ANIMALES, mejor);

		// aquí el arreglo empieza en 1, por eso se usa eleccion directo
		Si posiciones[eleccion] = mejor Entonces
			premio <- CalcularPremio(apuestas, posiciones, NUM_ANIMALES, mejor);
			dinero <- dinero + apuesta + premio;    // recuperas tu apuesta + el premio
			ganadas <- ganadas + 1;
			Escribir "¡Ganaste, eres un crack! Recuperas tus $", apuesta, " y ganas $", premio;
		SiNo
			Escribir "Perdiste bot, suerte la próxima. Pierdes tus $", apuesta;
		FinSi
	FinMientras

	MostrarResumen(nombres, victorias, NUM_ANIMALES, dinero, ronda, ganadas, DINERO_INICIAL);
FinAlgoritmo


Funcion valor <- LeerEnteroEnRango(mensaje, minimo, maximo)
	Definir valor Como Entero;
	valor <- minimo - 1;
	Mientras valor < minimo O valor > maximo Hacer
		Escribir Sin Saltar mensaje, " (", minimo, "-", maximo, "): ";
		Leer valor;
		Si valor < minimo O valor > maximo Entonces
			Escribir "Tiene que ser entre ", minimo, " y ", maximo;
		FinSi
	FinMientras
FinFuncion


// escribe el texto y lo rellena con espacios para que quede alineado
SubProceso EscribirAlineado(texto, ancho)
	Definir k Como Entero;
	Escribir Sin Saltar texto;
	Para k <- Longitud(texto) + 1 Hasta ancho Con Paso 1 Hacer
		Escribir Sin Saltar " ";
	FinPara
FinSubProceso


SubProceso MostrarInstrucciones(rondas, dineroInicial, meta)
	Escribir "===== CARRERA DE ANIMALES =====";
	Escribir rondas, " carreras. Empiezas con $", dineroInicial, ".";
	Escribir "Apuesta por un animal; a los otros 3 les apuestan otros jugadores al azar.";
	Escribir "Si gana tu animal recuperas tu apuesta y te llevas lo de los demás (si hay empate se reparte).";
	Escribir "Gana el primero en llegar a la casilla ", meta, " (si llegan juntos, el que llegó más lejos).";
	Escribir "x = trampa (regresa 2)   > = turbo (avanza 3)";
FinSubProceso


SubProceso MostrarAnimales(nombres, victorias, numAnimales)
	Definir i Como Entero;
	Para i <- 1 Hasta numAnimales Hacer
		Escribir Sin Saltar i, ". ";
		EscribirAlineado(nombres[i], 8);
		Escribir " (", victorias[i], " ganadas)";
	FinPara
FinSubProceso


SubProceso GenerarApuestas(apuestas, numAnimales, eleccion, apuesta, minimo, maximo)
	Definir i Como Entero;
	Para i <- 1 Hasta numAnimales Hacer
		Si i = eleccion Entonces
			apuestas[i] <- apuesta;
		SiNo
			apuestas[i] <- Azar(maximo - minimo + 1) + minimo;
		FinSi
	FinPara
FinSubProceso


SubProceso MostrarApuestas(nombres, apuestas, numAnimales, eleccion)
	Definir i, bolsa Como Entero;
	Escribir "";
	Escribir "Apuestas:";
	bolsa <- 0;
	Para i <- 1 Hasta numAnimales Hacer
		bolsa <- bolsa + apuestas[i];
		EscribirAlineado(nombres[i], 8);
		Si i = eleccion Entonces
			Escribir " $", apuestas[i], " (tú)";
		SiNo
			Escribir " $", apuestas[i];
		FinSi
	FinPara
	Escribir "Bolsa total: $", bolsa;
FinSubProceso


SubProceso DibujarPista(nombres, simbolos, posiciones, numAnimales, meta, trampa, turbo)
	Definir i, casilla, lugar Como Entero;
	Para i <- 1 Hasta numAnimales Hacer
		lugar <- posiciones[i];
		Si lugar > meta Entonces      // si ya pasó la meta se dibuja en la meta
			lugar <- meta;
		FinSi

		EscribirAlineado(nombres[i], 8);
		Escribir Sin Saltar " ";
		Para casilla <- 0 Hasta meta Hacer
			Si casilla = lugar Entonces
				Escribir Sin Saltar simbolos[i];
			SiNo
				Si casilla = trampa Entonces
					Escribir Sin Saltar "x";
				SiNo
					Si casilla = turbo Entonces
						Escribir Sin Saltar ">";
					SiNo
						Escribir Sin Saltar "-";
					FinSi
				FinSi
			FinSi
		FinPara
		Escribir "| ", posiciones[i];
	FinPara
FinSubProceso


SubProceso CorrerCarrera(nombres, simbolos, posiciones, numAnimales, meta, trampa, turbo)
	Definir i, turno Como Entero;
	Definir hayGanador Como Logico;

	Para i <- 1 Hasta numAnimales Hacer
		posiciones[i] <- 0;
	FinPara

	Escribir "";
	Escribir "¡Arrancan!";
	DibujarPista(nombres, simbolos, posiciones, numAnimales, meta, trampa, turbo);

	hayGanador <- Falso;
	turno <- 0;
	Mientras hayGanador = Falso Hacer
		Esperar 700 Milisegundos;
		turno <- turno + 1;
		Escribir "";
		Escribir "Turno ", turno;

		Para i <- 1 Hasta numAnimales Hacer
			posiciones[i] <- posiciones[i] + Azar(3) + 1;   // avanza de 1 a 3

			Si posiciones[i] = trampa Entonces
				posiciones[i] <- posiciones[i] - 2;
				Escribir nombres[i], " cayó en la trampa (-2)";
			SiNo
				Si posiciones[i] = turbo Entonces
					posiciones[i] <- posiciones[i] + 3;
					Escribir nombres[i], " agarró turbo (+3)";
				FinSi
			FinSi

			Si posiciones[i] >= meta Entonces
				hayGanador <- Verdadero;
			FinSi
		FinPara

		DibujarPista(nombres, simbolos, posiciones, numAnimales, meta, trampa, turbo);
	FinMientras
FinSubProceso


// busca la posición más lejana (el mayor del arreglo)
Funcion mejor <- PosicionGanadora(posiciones, numAnimales)
	Definir mejor, i Como Entero;
	mejor <- posiciones[1];
	Para i <- 2 Hasta numAnimales Hacer
		Si posiciones[i] > mejor Entonces
			mejor <- posiciones[i];
		FinSi
	FinPara
FinFuncion


SubProceso RegistrarGanadores(nombres, posiciones, victorias, numAnimales, mejor)
	Definir i, cantidad Como Entero;
	cantidad <- 0;
	Para i <- 1 Hasta numAnimales Hacer
		Si posiciones[i] = mejor Entonces
			cantidad <- cantidad + 1;
		FinSi
	FinPara

	Escribir "";
	Si cantidad > 1 Entonces
		Escribir "¡Empate! El premio se reparte";
	FinSi

	Para i <- 1 Hasta numAnimales Hacer
		Si posiciones[i] = mejor Entonces
			victorias[i] <- victorias[i] + 1;
			Escribir "Ganó ", nombres[i];
		FinSi
	FinPara
FinSubProceso


// lo que apostaron a los animales que perdieron se reparte entre los ganadores
Funcion premio <- CalcularPremio(apuestas, posiciones, numAnimales, mejor)
	Definir premio, pozo, ganadores, i Como Entero;
	pozo <- 0;
	ganadores <- 0;
	Para i <- 1 Hasta numAnimales Hacer
		Si posiciones[i] = mejor Entonces
			ganadores <- ganadores + 1;
		SiNo
			pozo <- pozo + apuestas[i];
		FinSi
	FinPara
	premio <- Trunc(pozo / ganadores);
FinFuncion


SubProceso MostrarResumen(nombres, victorias, numAnimales, dinero, jugadas, ganadas, dineroInicial)
	Definir i Como Entero;
	Escribir "";
	Escribir "===== FIN =====";
	Escribir "Carreras: ", jugadas, "   Ganadas: ", ganadas;
	Escribir "Terminaste con $", dinero;
	Si dinero <= 0 Entonces
		Escribir "Te quedaste sin dinero. Perdiste bot, suerte la próxima.";
	SiNo
		Si dinero > dineroInicial Entonces
			Escribir "Ganaste $", dinero - dineroInicial, ", ¡eres un crack!";
		SiNo
			Si dinero < dineroInicial Entonces
				Escribir "Perdiste $", dineroInicial - dinero, ", bot. Suerte la próxima.";
			SiNo
				Escribir "Quedaste igual que al inicio.";
			FinSi
		FinSi
	FinSi
	Para i <- 1 Hasta numAnimales Hacer
		EscribirAlineado(nombres[i], 8);
		Escribir " ", victorias[i], " victorias";
	FinPara
FinSubProceso
