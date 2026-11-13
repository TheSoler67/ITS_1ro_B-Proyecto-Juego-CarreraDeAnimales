// ==========================================================================
//   CARRERA DE ANIMALES  -  EDICIÓN APUESTAS LOCAS
//   Hecho con mucho estres, poco de sueño y cero dinero real apostado. espero le guste maestro chuc :)

//
//   CÓMO SE JUEGA (versión rápida, porque nadie lee las instrucciones):
//    1. Pon tu nombre y en el menú escoge "Jugar torneo".
//    2. Son 5 carreras y arrancas con $100. Antes de cada carrera ves el
//       clima, la pista y las cuotas: entre menos probable que gane un
//       animal, más paga. Las cuotas salen de simular 300 carreras fantasma.
//    3. Apuesta a Ganador, a Podio (que quede en el top 3) o a Exacta
//       (adivinar 1º y 2º en orden). La Exacta paga una barbaridad.
//    4. Si un señor de gabardina te ofrece una zanahoria ilegal... tú sabrás.
//       Tu animal corre más, pero si el juez te cacha, adiós apuesta.
//    5. Si ganas, puedes arriesgar la ganancia en un volado de doble o nada.
//    6. Si te quedas en $0, Don Tiburón te presta. Con intereses de tiburón.
//    7. En la pista: x trampa, > turbo, ~ lodo, ? caja sorpresa (puede salir
//       un cohete, un rayo o un teletransporte, no me hago responsable).
//    8. Cada animal tiene su maña: la Liebre se duerme, el Perro persigue
//       gatos, la Gallina vuela y el Caracol tiene MODO NITRO. En serio.
//   Tip: maximiza la ventana de ejecución o los animales no caben.
//   Perfil Flexible, arreglos desde 1. Ningún animal salió lastimado.
// ==========================================================================

Algoritmo CarreraDeAnimales
	Definir NUM_ANIMALES, META, RONDAS, DINERO_INICIAL, SIMULACIONES, menu Como Entero;
	Definir nombres, simbolos, especialidades, jugador Como Caracter;
	Dimension nombres[6], simbolos[6], especialidades[6];
	NUM_ANIMALES <- 6;
	META <- 40;
	RONDAS <- 5;
	DINERO_INICIAL <- 100;
	SIMULACIONES <- 300;
	CargarAnimales(nombres, simbolos, especialidades);
	PantallaTitulo(simbolos, NUM_ANIMALES);
	jugador <- PedirNombre();
	Repetir
		menu <- MenuPrincipal(jugador);
		Segun menu Hacer
			1:
				JugarTorneo(jugador, nombres, simbolos, especialidades, NUM_ANIMALES, META, RONDAS, DINERO_INICIAL, SIMULACIONES);
			2:
				PantallaInstrucciones(RONDAS, DINERO_INICIAL, SIMULACIONES);
			3:
				PantallaCorredores(nombres, NUM_ANIMALES);
		FinSegun
	Hasta Que menu = 4
	PantallaDespedida(jugador, simbolos, NUM_ANIMALES);
FinAlgoritmo

SubProceso CargarAnimales(nombres, simbolos, especialidades)
	nombres[1] <- "Tortuga";   simbolos[1] <- "T";   especialidades[1] <- "Las trampas no le hacen nada";
	nombres[2] <- "Liebre";    simbolos[2] <- "L";   especialidades[2] <- "Rapidísima... si no se duerme";
	nombres[3] <- "Caballo";   simbolos[3] <- "C";   especialidades[3] <- "Fuerte y constante";
	nombres[4] <- "Perro";     simbolos[4] <- "P";   especialidades[4] <- "Se distrae con los gatos";
	nombres[5] <- "Gallina";   simbolos[5] <- "G";   especialidades[5] <- "A veces sale volando";
	nombres[6] <- "Caracol";   simbolos[6] <- "@";   especialidades[6] <- "Lento, pero tiene MODO NITRO";
FinSubProceso

SubProceso JugarTorneo(jugador, nombres, simbolos, especialidades, n, meta, rondas, dineroInicial, sims)
	Definir victorias, pista, orden, posiciones, cuotaGan, cuotaPod, exacta Como Entero;
	Dimension victorias[6], pista[40], orden[6], posiciones[6], cuotaGan[6], cuotaPod[6], exacta[6,6];
	Definir logros, seguir, acierto, todoAdentro, cachado Como Logico;
	Dimension logros[8];
	Definir dinero, deuda, ronda, jugadas, ganadas, racha, mayorPremio, clima, tipo, eleccion, eleccion2, apuesta, cuota, pago, ganancia, dopado, dineroAntes, i Como Entero;
	Definir info, descripcion, pregunta Como Caracter;
	Para i <- 1 Hasta 8 Hacer
		logros[i] <- Falso;
		Si i <= n Entonces victorias[i] <- 0; FinSi
	FinPara
	dinero <- dineroInicial; deuda <- 0; ronda <- 0; jugadas <- 0; ganadas <- 0; racha <- 0; mayorPremio <- 0;
	seguir <- Verdadero;
	Mientras ronda < rondas & seguir Hacer
		Si dinero <= 0 Entonces
			Si deuda = 0 Entonces
				seguir <- OfrecerPrestamo(jugador);
				Si seguir Entonces
					dinero <- 60; deuda <- 120; logros[6] <- Verdadero;
				FinSi
			SiNo
				Borrar Pantalla;
				EscribirLento("   Otra vez en $0 y Don Tiburón ya no te presta. Seguridad te saca del hipódromo.", 25);
				PresionaTecla();
				seguir <- Falso;
			FinSi
		FinSi
		Si seguir Entonces
			ronda <- ronda + 1;
			clima <- Azar(5);
			GenerarPista(pista, meta, clima);
			Borrar Pantalla;
			Escribir Tira("=", 78);
			Escribir Centrar("CARRERA " + ConvertirATexto(ronda) + " DE " + ConvertirATexto(rondas), 78);
			Escribir Tira("=", 78);
			EscribirLento("   Clima de hoy: " + NombreClima(clima), 20);
			EscribirLento("   Los expertos simulan " + ConvertirATexto(sims) + " carreras con esta pista para sacar las cuotas...", 12);
			CalcularCuotas(nombres, simbolos, pista, n, meta, clima, sims, cuotaGan, cuotaPod, exacta);
			Esperar 500 Milisegundos;
			TablaCuotas(ronda, rondas, jugador, dinero, deuda, clima, pista, meta, nombres, especialidades, cuotaGan, cuotaPod, victorias, n);
			Escribir "   APUESTAS:  [1] Ganador    [2] Podio (que quede top 3)    [3] Exacta (1º y 2º)";
			tipo <- LeerEntero("¿Qué apuesta haces?", 1, 3);
			pregunta <- "¿A qué animal le vas?";
			Si tipo = 3 Entonces pregunta <- "¿Quién llega en 1º lugar?"; FinSi
			eleccion <- LeerEntero(pregunta, 1, n);
			eleccion2 <- 0;
			Segun tipo Hacer
				1: cuota <- cuotaGan[eleccion];
				2: cuota <- cuotaPod[eleccion];
				De Otro Modo:
					Repetir
						eleccion2 <- LeerEntero("¿Y quién llega en 2º lugar?", 1, n);
						Si eleccion2 = eleccion Entonces Escribir "   No puede llegar 1º y 2º a la vez, crack."; FinSi
					Hasta Que eleccion2 <> eleccion
					cuota <- CuotaDesdeConteo(exacta[eleccion, eleccion2], sims, 8, 15, 990);
					Escribir "   Cuota de tu exacta: ", TxtCuota(cuota);
			FinSegun
			dineroAntes <- dinero;
			apuesta <- LeerEntero("¿Cuánto le metes? Tienes " + Plata(dinero), 1, dinero);
			todoAdentro <- apuesta = dinero;
			dinero <- dinero - apuesta;
			dopado <- 0;
			Si dinero >= 15 Entonces
				Escribir "";
				Escribir "   Psst... un tipo de gabardina te ofrece una ZANAHORIA ILEGAL por $15.";
				Escribir "   Tu animal avanza +1 extra cada turno... pero hay 25% de que el juez te cache.";
				Si LeerSiNo("¿Se la das a escondidas?") Entonces
					dinero <- dinero - 15;
					dopado <- eleccion;
				FinSi
			FinSi
			descripcion <- DescribirApuesta(tipo, eleccion, eleccion2, nombres, apuesta, cuota);
			info <- "CARRERA " + ConvertirATexto(ronda) + "/" + ConvertirATexto(rondas) + " | " + NombreClima(clima) + " | " + descripcion;
			CuentaRegresiva(info);
			CorrerCarrera(nombres, simbolos, posiciones, pista, orden, n, meta, clima, dopado, eleccion, info, Verdadero);
			jugadas <- jugadas + 1;
			Si posiciones[orden[1]] = posiciones[orden[2]] Entonces
				FotoFinish(nombres, simbolos, orden);
				logros[8] <- Verdadero;
			FinSi
			victorias[orden[1]] <- victorias[orden[1]] + 1;
			Podio(nombres, orden);
			Segun tipo Hacer
				1: acierto <- orden[1] = eleccion;
				2: acierto <- orden[1] = eleccion | orden[2] = eleccion | orden[3] = eleccion;
				De Otro Modo: acierto <- orden[1] = eleccion & orden[2] = eleccion2;
			FinSegun
			cachado <- Falso;
			Si dopado > 0 Entonces
				cachado <- RevisionJuez(nombres[dopado]);
				Si cachado Entonces acierto <- Falso; SiNo logros[5] <- Verdadero; FinSi
			FinSi
			Si acierto Entonces
				pago <- Trunc(apuesta * cuota / 10);
				ganancia <- pago - apuesta;
				ganadas <- ganadas + 1;
				racha <- racha + 1;
				PantallaResultado(Verdadero, descripcion, Llegada(nombres, orden), pago, ganancia);
				Si ganancia > 0 Entonces
					Si LeerSiNo("¿Te juegas tus " + Plata(ganancia) + " de ganancia a DOBLE O NADA?") Entonces
						Si DobleONada(ganancia) Entonces
							pago <- pago + ganancia;
							logros[7] <- Verdadero;
						SiNo
							pago <- pago - ganancia;
						FinSi
					FinSi
				FinSi
				dinero <- dinero + pago;
				Si pago > mayorPremio Entonces mayorPremio <- pago; FinSi
				Si todoAdentro Entonces logros[1] <- Verdadero; FinSi
				Si cuota >= 80 Entonces logros[2] <- Verdadero; FinSi
				Si tipo = 3 Entonces logros[3] <- Verdadero; FinSi
				Si racha >= 3 Entonces logros[4] <- Verdadero; FinSi
			SiNo
				racha <- 0;
				Si cachado Entonces
					PantallaResultado(Falso, descripcion, "Te cacharon con la zanahoria: apuesta anulada.", apuesta, 0);
				SiNo
					PantallaResultado(Falso, descripcion, Llegada(nombres, orden), apuesta, 0);
				FinSi
			FinSi
			AnimarDinero(dineroAntes, dinero, deuda);
			PresionaTecla();
		FinSi
	FinMientras
	PantallaFinal(jugador, nombres, victorias, n, dinero, deuda, jugadas, ganadas, mayorPremio, dineroInicial);
	PantallaLogros(logros);
FinSubProceso

SubProceso GenerarPista(pista, meta, clima)
	Definir cantidades, i, tipo, puestas, lugar Como Entero;
	Dimension cantidades[4];
	cantidades[1] <- 3; cantidades[2] <- 2; cantidades[3] <- 2; cantidades[4] <- 3;
	Si clima = 1 Entonces cantidades[3] <- 5; FinSi
	Para i <- 1 Hasta meta Hacer
		pista[i] <- 0;
	FinPara
	Para tipo <- 1 Hasta 4 Hacer
		puestas <- 0;
		Mientras puestas < cantidades[tipo] Hacer
			lugar <- Azar(meta - 7) + 4;
			Si pista[lugar] = 0 Entonces
				pista[lugar] <- tipo;
				puestas <- puestas + 1;
			FinSi
		FinMientras
	FinPara
FinSubProceso

SubProceso CorrerCarrera(nombres, simbolos, posiciones, pista, orden, n, meta, clima, dopado, eleccion, info, visible)
	Definir dormido, i, turno, lider, liderAnterior Como Entero;
	Definir etiquetas, logs Como Caracter;
	Dimension dormido[6], etiquetas[6], logs[3];
	Definir hayGanador Como Logico;
	Para i <- 1 Hasta n Hacer
		posiciones[i] <- 0; dormido[i] <- 0; etiquetas[i] <- "";
		Si i <= 3 Entonces logs[i] <- ""; FinSi
	FinPara
	turno <- 0; liderAnterior <- 0; hayGanador <- Falso;
	Si visible Entonces
		Narrar(logs, "¡Y ARRANCAN! Se abren las puertas...");
		DibujarCarrera(nombres, simbolos, posiciones, etiquetas, pista, logs, n, meta, info, turno, eleccion);
		Esperar 600 Milisegundos;
	FinSi
	Mientras hayGanador = Falso Hacer
		turno <- turno + 1;
		JugarTurno(nombres, simbolos, posiciones, dormido, etiquetas, pista, logs, n, meta, clima, turno, dopado, eleccion, info, visible);
		Para i <- 1 Hasta n Hacer
			Si posiciones[i] >= meta Entonces hayGanador <- Verdadero; FinSi
		FinPara
		Si visible Entonces
			lider <- 1;
			Para i <- 2 Hasta n Hacer
				Si posiciones[i] > posiciones[lider] Entonces lider <- i; FinSi
			FinPara
			Si liderAnterior > 0 Entonces
				Si posiciones[liderAnterior] = posiciones[lider] Entonces lider <- liderAnterior; FinSi
			FinSi
			Si lider <> liderAnterior & turno > 1 & hayGanador = Falso Entonces
				Narrar(logs, "¡" + Mayusculas(nombres[lider]) + " SE PONE EN PRIMER LUGAR!");
			FinSi
			liderAnterior <- lider;
			DibujarCarrera(nombres, simbolos, posiciones, etiquetas, pista, logs, n, meta, info, turno, eleccion);
			Esperar 230 Milisegundos;
		FinSi
	FinMientras
	OrdenarPorPosicion(posiciones, n, orden, Verdadero);
	Si visible Entonces
		Si posiciones[orden[1]] = posiciones[orden[2]] Entonces
			Narrar(logs, "¡¡LLEGADA CERRADÍSIMA!! Nadie sabe quién ganó...");
		SiNo
			Narrar(logs, "¡¡" + Mayusculas(nombres[orden[1]]) + " CRUZA LA META!!");
		FinSi
		DibujarCarrera(nombres, simbolos, posiciones, etiquetas, pista, logs, n, meta, info, turno, eleccion);
		Esperar 1500 Milisegundos;
	FinSi
FinSubProceso

SubProceso JugarTurno(nombres, simbolos, posiciones, dormido, etiquetas, pista, logs, n, meta, clima, turno, dopado, eleccion, info, visible)
	Definir avance, objetivo, i, r, pasos, victima Como Entero;
	Dimension avance[6], objetivo[6];
	Para i <- 1 Hasta n Hacer
		pasos <- 0;
		Si dormido[i] > 0 Entonces
			dormido[i] <- dormido[i] - 1;
		SiNo
			etiquetas[i] <- "";
			r <- Azar(100);
			Segun i Hacer
				1:
					pasos <- Azar(2) + 1;
					Si r < 35 Entonces pasos <- pasos + 1; FinSi
				2:
					Si r < 12 | (clima = 2 & r < 25) Entonces
						dormido[i] <- 2;
						Evento(etiquetas, logs, i, "zZz", "La Liebre se echó una siestita... zZz");
					SiNo
						pasos <- Azar(3) + 2;
					FinSi
				3:
					Si r < 6 Entonces
						Evento(etiquetas, logs, i, "¡se paró!", "¡El Caballo se encabritó y no avanza!");
					SiNo
						pasos <- Azar(2) + 2;
					FinSi
				4:
					Si r < 12 Entonces
						dormido[i] <- 1;
						Evento(etiquetas, logs, i, "¡un gato!", "¡El Perro vio un gato y se fue a perseguirlo!");
					SiNo
						pasos <- Azar(3) + 1;
						Si r < 24 Entonces
							pasos <- pasos + 3;
							Evento(etiquetas, logs, i, "¡emoción!", "El Perro se emocionó y corre moviendo la cola");
						FinSi
					FinSi
				5:
					Si r < 10 Entonces
						pasos <- 6;
						Evento(etiquetas, logs, i, "¡VUELA!", "¡¿LA GALLINA ESTÁ VOLANDO?! ¡Eso no se ve todos los días!");
					SiNo
						pasos <- Azar(4);
						Si pasos = 0 Entonces etiquetas[i] <- "picotea"; FinSi
					FinSi
				De Otro Modo:
					pasos <- 1;
					Si r < 6 Entonces
						pasos <- 9;
						Evento(etiquetas, logs, i, "¡NITRO!", "¡¡MODO NITRO!! El Caracol rompió la barrera del sonido");
					FinSi
			FinSegun
			Si pasos > 0 & clima = 4 & turno % 2 = 1 Entonces pasos <- pasos + 1; FinSi
			Si pasos > 0 & i = dopado Entonces pasos <- pasos + 1; FinSi
		FinSi
		avance[i] <- pasos;
		objetivo[i] <- posiciones[i] + pasos;
	FinPara
	AnimarMovimiento(nombres, simbolos, posiciones, objetivo, etiquetas, pista, logs, n, meta, info, turno, eleccion, visible, 55);
	Para i <- 1 Hasta n Hacer
		objetivo[i] <- posiciones[i];
	FinPara
	Para i <- 1 Hasta n Hacer
		Si avance[i] > 0 & posiciones[i] >= 1 & posiciones[i] < meta Entonces
			Segun pista[posiciones[i]] Hacer
				1:
					Si i = 1 Entonces
						Evento(etiquetas, logs, i, "caparazón", "La Tortuga se metió a su caparazón: ¡la trampa ni le hizo cosquillas!");
					SiNo
						objetivo[i] <- objetivo[i] - 3;
						Evento(etiquetas, logs, i, "TRAMPA -3", nombres[i] + " cayó en una trampa (-3)");
					FinSi
				2:
					objetivo[i] <- objetivo[i] + 3;
					Evento(etiquetas, logs, i, "TURBO +3", nombres[i] + " agarró TURBO (+3)");
				3:
					Si i = 6 Entonces
						Evento(etiquetas, logs, i, "se desliza", "El Caracol se desliza en el lodo como si nada");
					SiNo
						dormido[i] <- 1;
						Evento(etiquetas, logs, i, "atascado", nombres[i] + " se atascó en el lodo y pierde un turno");
					FinSi
				4:
					AbrirCaja(i, nombres, posiciones, objetivo, etiquetas, logs, n, meta);
			FinSegun
		FinSi
	FinPara
	Si clima = 3 & Azar(100) < 10 Entonces
		victima <- Azar(n) + 1;
		Si posiciones[victima] < meta Entonces
			objetivo[victima] <- objetivo[victima] - 5;
			Evento(etiquetas, logs, victima, "¡RAYO! -5", "¡KABOOM! Un rayo le cayó a " + nombres[victima] + " (-5)");
		SiNo
			Narrar(logs, "¡KABOOM! Cayó un rayo en la pista... y no le dio a nadie");
		FinSi
	FinSi
	Para i <- 1 Hasta n Hacer
		Si objetivo[i] < 0 Entonces objetivo[i] <- 0; FinSi
	FinPara
	AnimarMovimiento(nombres, simbolos, posiciones, objetivo, etiquetas, pista, logs, n, meta, info, turno, eleccion, visible, 70);
FinSubProceso

SubProceso AbrirCaja(i, nombres, posiciones, objetivo, etiquetas, logs, n, meta)
	Definir lider, aux, k Como Entero;
	lider <- i;
	Para k <- 1 Hasta n Hacer
		Si posiciones[k] < meta & objetivo[k] > objetivo[lider] Entonces lider <- k; FinSi
	FinPara
	Segun Azar(5) Hacer
		0:
			objetivo[i] <- objetivo[i] + 5;
			Evento(etiquetas, logs, i, "ZANAHORIA", nombres[i] + " abrió la caja: ¡ZANAHORIA DORADA! (+5)");
		1:
			objetivo[i] <- objetivo[i] - 4;
			Evento(etiquetas, logs, i, "PLÁTANO -4", nombres[i] + " abrió la caja... cáscara de plátano (-4)");
		2:
			Si lider <> i Entonces
				aux <- objetivo[i];
				objetivo[i] <- objetivo[lider];
				objetivo[lider] <- aux;
				etiquetas[lider] <- "¡TELEPORT!";
				Evento(etiquetas, logs, i, "¡TELEPORT!", "¡TELETRANSPORTE! " + nombres[i] + " cambió de lugar con " + nombres[lider]);
			SiNo
				Evento(etiquetas, logs, i, "nada", nombres[i] + " sacó un teletransporte... pero ya iba primero");
			FinSi
		3:
			objetivo[lider] <- objetivo[lider] - 6;
			Si lider = i Entonces
				Evento(etiquetas, logs, lider, "¡RAYO! -6", nombres[i] + " invocó un rayo contra el líder... ¡y el líder era él!");
			SiNo
				Evento(etiquetas, logs, lider, "¡RAYO! -6", nombres[i] + " le mandó un RAYO al líder: " + nombres[lider] + " (-6)");
			FinSi
		De Otro Modo:
			objetivo[i] <- objetivo[i] + 8;
			Evento(etiquetas, logs, i, "¡COHETE!", "¡" + nombres[i] + " encontró un COHETE en la caja! (+8)");
	FinSegun
FinSubProceso

SubProceso AnimarMovimiento(nombres, simbolos, posiciones, objetivo, etiquetas, pista, logs, n, meta, info, turno, eleccion, visible, retardo)
	Definir i Como Entero;
	Definir falta Como Logico;
	falta <- Verdadero;
	Mientras falta Hacer
		falta <- Falso;
		Para i <- 1 Hasta n Hacer
			Si visible = Falso Entonces posiciones[i] <- objetivo[i]; FinSi
			Si posiciones[i] < objetivo[i] Entonces posiciones[i] <- posiciones[i] + 1; falta <- Verdadero; FinSi
			Si posiciones[i] > objetivo[i] Entonces posiciones[i] <- posiciones[i] - 1; falta <- Verdadero; FinSi
		FinPara
		Si falta Entonces
			DibujarCarrera(nombres, simbolos, posiciones, etiquetas, pista, logs, n, meta, info, turno, eleccion);
			Esperar retardo Milisegundos;
		FinSi
	FinMientras
FinSubProceso

SubProceso Evento(etiquetas, logs, i, etiqueta, msg)
	etiquetas[i] <- etiqueta;
	Narrar(logs, msg);
FinSubProceso

SubProceso Narrar(logs, msg)
	logs[3] <- logs[2];
	logs[2] <- logs[1];
	logs[1] <- msg;
FinSubProceso

SubProceso OrdenarPorPosicion(posiciones, n, orden, desempateAlAzar)
	Definir clave, i, j, aux Como Entero;
	Dimension clave[6];
	Para i <- 1 Hasta n Hacer
		orden[i] <- i;
		clave[i] <- posiciones[i] * 1000 + (100 - i);
		Si desempateAlAzar Entonces clave[i] <- posiciones[i] * 1000 + Azar(1000); FinSi
	FinPara
	Para i <- 1 Hasta n - 1 Hacer
		Para j <- i + 1 Hasta n Hacer
			Si clave[orden[j]] > clave[orden[i]] Entonces
				aux <- orden[i];
				orden[i] <- orden[j];
				orden[j] <- aux;
			FinSi
		FinPara
	FinPara
FinSubProceso

SubProceso CalcularCuotas(nombres, simbolos, pista, n, meta, clima, sims, cuotaGan, cuotaPod, exacta)
	Definir posiciones, orden, ganadas, podios, s, i, j Como Entero;
	Dimension posiciones[6], orden[6], ganadas[6], podios[6];
	Para i <- 1 Hasta n Hacer
		ganadas[i] <- 0;
		podios[i] <- 0;
		Para j <- 1 Hasta n Hacer
			exacta[i, j] <- 0;
		FinPara
	FinPara
	Escribir "";
	Escribir Sin Saltar "   [";
	Para s <- 1 Hasta sims Hacer
		CorrerCarrera(nombres, simbolos, posiciones, pista, orden, n, meta, clima, 0, 0, "", Falso);
		ganadas[orden[1]] <- ganadas[orden[1]] + 1;
		Para j <- 1 Hasta 3 Hacer
			podios[orden[j]] <- podios[orden[j]] + 1;
		FinPara
		exacta[orden[1], orden[2]] <- exacta[orden[1], orden[2]] + 1;
		Si s % (Trunc(sims / 40) + 1) = 0 Entonces Escribir Sin Saltar "#"; FinSi
	FinPara
	Escribir "] ¡listo!";
	Para i <- 1 Hasta n Hacer
		cuotaGan[i] <- CuotaDesdeConteo(ganadas[i], sims, 9, 11, 500);
		cuotaPod[i] <- CuotaDesdeConteo(podios[i], sims, 9, 11, 150);
	FinPara
FinSubProceso

Funcion cuota <- CuotaDesdeConteo(conteo, sims, margen, minimo, maximo)
	Definir cuota Como Entero;
	cuota <- maximo;
	Si conteo > 0 Entonces cuota <- Trunc(margen * sims / conteo); FinSi
	Si cuota < minimo Entonces cuota <- minimo; FinSi
	Si cuota > maximo Entonces cuota <- maximo; FinSi
FinFuncion

Funcion r <- TxtCuota(c10)
	Definir r Como Caracter;
	r <- "x" + ConvertirATexto(Trunc(c10 / 10)) + "." + ConvertirATexto(c10 % 10);
FinFuncion

Funcion r <- Llegada(nombres, orden)
	Definir r Como Caracter;
	r <- "Llegada:  1º " + nombres[orden[1]] + "   2º " + nombres[orden[2]] + "   3º " + nombres[orden[3]];
FinFuncion

Funcion r <- DescribirApuesta(tipo, eleccion, eleccion2, nombres, apuesta, cuota)
	Definir r Como Caracter;
	Segun tipo Hacer
		1: r <- Plata(apuesta) + " a " + nombres[eleccion] + " GANADOR ";
		2: r <- Plata(apuesta) + " a " + nombres[eleccion] + " PODIO ";
		De Otro Modo: r <- Plata(apuesta) + " EXACTA " + nombres[eleccion] + "-" + nombres[eleccion2] + " ";
	FinSegun
	r <- r + TxtCuota(cuota);
FinFuncion

Funcion r <- PistaTexto(pista, meta)
	Definir r Como Caracter;
	Definir c Como Entero;
	r <- "";
	Para c <- 1 Hasta meta - 1 Hacer
		r <- r + Subcadena("-x>~?", pista[c] + 1, pista[c] + 1);
	FinPara
FinFuncion

SubProceso DibujarCarrera(nombres, simbolos, posiciones, etiquetas, pista, logs, n, meta, info, turno, eleccion)
	Definir orden, i, c, lugar Como Entero;
	Dimension orden[6];
	Definir linea, celda, base Como Caracter;
	base <- "-" + PistaTexto(pista, meta) + "#";
	Borrar Pantalla;
	linea <- ConvertirATexto(turno);
	Si turno < 10 Entonces linea <- "0" + linea; FinSi
	Escribir " ", Rellenar(info, 66), "TURNO ", linea;
	Escribir Tira("=", 78);
	linea <- Tira(" ", 12);
	Para c <- 0 Hasta meta Con Paso 10 Hacer
		linea <- linea + Rellenar(ConvertirATexto(c), 10);
	FinPara
	Escribir linea;
	Para i <- 1 Hasta n Hacer
		lugar <- posiciones[i];
		Si lugar > meta Entonces lugar <- meta; FinSi
		linea <- "   ";
		Si i = eleccion Entonces linea <- " ->"; FinSi
		linea <- linea + Rellenar(nombres[i], 8) + "|";
		Para c <- 0 Hasta meta Hacer
			celda <- Subcadena(base, c + 1, c + 1);
			Si c < lugar & celda = "-" Entonces celda <- "."; FinSi
			Si c = lugar Entonces celda <- simbolos[i]; FinSi
			linea <- linea + celda;
		FinPara
		Escribir linea, " ", RellenarIzq(ConvertirATexto(posiciones[i]), 2), "  ", etiquetas[i];
	FinPara
	Escribir Tira("=", 78);
	OrdenarPorPosicion(posiciones, n, orden, Falso);
	linea <- " ";
	Para i <- 1 Hasta n Hacer
		celda <- nombres[orden[i]];
		Si orden[i] = eleccion Entonces celda <- Mayusculas(celda); FinSi
		linea <- linea + ConvertirATexto(i) + "º " + Rellenar(celda, 10);
	FinPara
	Escribir linea;
	Escribir Tira("-", 78);
	Escribir "  >> ", logs[1];
	Escribir "     ", logs[2];
	Escribir "     ", logs[3];
FinSubProceso

Funcion r <- NombreClima(clima)
	Definir r Como Caracter;
	Segun clima Hacer
		0: r <- "SOLEADO";
		1: r <- "LLUVIA";
		2: r <- "NOCHE";
		3: r <- "TORMENTA";
		De Otro Modo: r <- "VIENTO A FAVOR";
	FinSegun
FinFuncion

SubProceso TablaCuotas(ronda, rondas, jugador, dinero, deuda, clima, pista, meta, nombres, especialidades, cuotaGan, cuotaPod, victorias, n)
	Definir i Como Entero;
	Borrar Pantalla;
	Escribir Tira("=", 78);
	Escribir Rellenar("  CARRERA " + ConvertirATexto(ronda) + " DE " + ConvertirATexto(rondas), 40), RellenarIzq(jugador + ": " + Plata(dinero), 36);
	Si deuda > 0 Entonces Escribir RellenarIzq("(le debes " + Plata(deuda) + " a Don Tiburón)", 76); FinSi
	Escribir Tira("=", 78);
	Escribir "  CLIMA: ", NombreClima(clima);
	Segun clima Hacer
		0: Escribir "  Día perfecto para correr. Nada raro... por ahora.";
		1: Escribir "  Está lloviendo: la pista tiene mucho más lodo (~).";
		2: Escribir "  Es de noche: la Liebre se duerme el doble de seguido.";
		3: Escribir "  Tormenta eléctrica: en cualquier turno puede caerle un rayo a alguien (-5).";
		De Otro Modo: Escribir "  Viento a favor: todos avanzan +1 en los turnos impares.";
	FinSegun
	Escribir "";
	Escribir "  PISTA:  SALIDA ", PistaTexto(pista, meta), " META";
	Escribir "          x trampa (-3)   > turbo (+3)   ~ lodo (pierde turno)   ? sorpresa";
	Escribir Tira("-", 78);
	Escribir "   #   CORREDOR    GANADOR    PODIO    VICT.  ESPECIALIDAD";
	Escribir Tira("-", 78);
	Para i <- 1 Hasta n Hacer
		Escribir "   ", i, "   ", Rellenar(nombres[i], 12), Rellenar(TxtCuota(cuotaGan[i]), 11), Rellenar(TxtCuota(cuotaPod[i]), 9), Rellenar(ConvertirATexto(victorias[i]), 7), especialidades[i];
	FinPara
	Escribir Tira("-", 78);
FinSubProceso

SubProceso PantallaTitulo(simbolos, n)
	Definir lineas Como Caracter;
	Dimension lineas[11];
	Definir f, k Como Entero;
	Para f <- 1 Hasta 4 Hacer
		lineas[f] <- Centrar(FilaGrande("CARRERA", f), 78);
		lineas[f + 5] <- Centrar(FilaGrande("DE ANIMALES", f), 78);
	FinPara
	lineas[5] <- "";
	lineas[10] <- "";
	lineas[11] <- Centrar("~ ~ ~   E D I C I Ó N   A P U E S T A S   L O C A S   ~ ~ ~", 78);
	Para k <- 3 Hasta 78 Con Paso 3 Hacer
		Borrar Pantalla;
		Escribir "";
		Para f <- 1 Hasta 9 Hacer
			Escribir Subcadena(lineas[f], 1, k);
		FinPara
		Esperar 25 Milisegundos;
	FinPara
	Desfile(lineas, 11, simbolos, n, 24, "P R E S I O N A   C U A L Q U I E R   T E C L A");
	Esperar Tecla;
FinSubProceso

SubProceso Desfile(lineas, cantLineas, simbolos, n, cuadros, mensaje)
	Definir pos, i, f Como Entero;
	Dimension pos[6];
	Para i <- 1 Hasta n Hacer
		pos[i] <- 0;
	FinPara
	Para f <- 1 Hasta cuadros + 7 Hacer
		Borrar Pantalla;
		Escribir "";
		Para i <- 1 Hasta cantLineas Hacer
			Escribir lineas[i];
		FinPara
		Escribir "";
		Para i <- 1 Hasta n Hacer
			Si f <= cuadros Entonces pos[i] <- pos[i] + Azar(4) + 1; FinSi
			Si pos[i] > 64 Entonces pos[i] <- 64; FinSi
			Escribir "      ", Tira(".", pos[i]), simbolos[i];
		FinPara
		Escribir "";
		Si f > cuadros & (f % 2 = 0 | f = cuadros + 7) Entonces
			Escribir Centrar(mensaje, 78);
			Esperar 250 Milisegundos;
		SiNo
			Escribir "";
			Esperar 70 Milisegundos;
		FinSi
	FinPara
FinSubProceso

Funcion nombre <- PedirNombre
	Definir nombre Como Caracter;
	Borrar Pantalla;
	Escribir "";
	Escribir "";
	EscribirLento("   Bienvenido al Gran Hipódromo Animal.", 20);
	EscribirLento("   Aquí corren tortugas, liebres, gallinas... y un caracol con turbo.", 20);
	Escribir "";
	Escribir Sin Saltar "   ¿Cómo te llamas, apostador? > ";
	Leer nombre;
	Si Longitud(nombre) = 0 Entonces nombre <- "Apostador Misterioso"; FinSi
	Si Longitud(nombre) > 16 Entonces nombre <- Subcadena(nombre, 1, 16); FinSi
FinFuncion

Funcion menu <- MenuPrincipal(jugador)
	Definir menu Como Entero;
	Borrar Pantalla;
	Escribir "";
	TextoGrande("CARRERA");
	Escribir Centrar("D E    A N I M A L E S", 78);
	Escribir "";
	Escribir "              +------------------------------------------------+";
	Escribir "              | ", Rellenar("¡Qué onda, " + jugador + "!", 46), " |";
	Escribir "              |                                                |";
	Escribir "              |    [1]  Jugar torneo                           |";
	Escribir "              |    [2]  Cómo se juega                          |";
	Escribir "              |    [3]  Conoce a los corredores                |";
	Escribir "              |    [4]  Salir                                  |";
	Escribir "              +------------------------------------------------+";
	Escribir "";
	menu <- LeerEntero("Elige una opción", 1, 4);
FinFuncion

SubProceso PantallaInstrucciones(rondas, dineroInicial, sims)
	Borrar Pantalla;
	TextoGrande("COMO SE JUEGA");
	Escribir Tira("-", 78);
	Escribir "  1. Son ", rondas, " carreras y empiezas con ", Plata(dineroInicial), ". Gana el que llegue a la META (#).";
	Escribir "  2. Antes de cada carrera ves el clima, la pista y las CUOTAS. Las cuotas";
	Escribir "     salen de simular ", sims, " carreras: entre menos probable, más paga.";
	Escribir "     Ejemplo: apuestas $10 a cuota x3.5 y si le atinas te regresan $35.";
	Escribir "  3. Tipos de apuesta:";
	Escribir "       [1] Ganador -> tu animal llega en 1º lugar.";
	Escribir "       [2] Podio   -> tu animal queda entre los 3 primeros (paga menos).";
	Escribir "       [3] Exacta  -> adivinas el 1º y el 2º en orden (¡paga muchísimo!).";
	Escribir "  4. Casillas:  x trampa (-3)   > turbo (+3)   ~ lodo (pierdes un turno)";
	Escribir "                ? caja sorpresa: zanahoria, plátano, teletransporte,";
	Escribir "                  rayo al líder o... un cohete.";
	Escribir "  5. Si ganas, puedes jugarte la ganancia a DOBLE O NADA con un volado.";
	Escribir "  6. Si te quedas en $0, Don Tiburón te presta $60... y le debes $120.";
	Escribir "  7. Si llegan empatados, se decide por FOTO FINISH.";
	Escribir "  8. Hay 8 logros secretos. ¿Los sacarás todos?";
	PresionaTecla();
FinSubProceso

SubProceso PantallaCorredores(nombres, n)
	Definir dibujo, desc1, desc2 Como Caracter;
	Dimension dibujo[6];
	Definir i, j, sangria, vel, cons, loc Como Entero;
	Para i <- 1 Hasta n Hacer
		CargarDibujo(i, dibujo);
		Segun i Hacer
			1:
				vel <- 2; cons <- 5; loc <- 1;
				desc1 <- "Avanza 1 a 3 casillas por turno y jamás se duerme.";
				desc2 <- "Las trampas no le hacen nada: se mete a su caparazón.";
			2:
				vel <- 5; cons <- 1; loc <- 3;
				desc1 <- "La más rápida: avanza 2 a 4 casillas por turno.";
				desc2 <- "Pero a veces se echa una siesta de 3 turnos (de noche, más).";
			3:
				vel <- 4; cons <- 4; loc <- 1;
				desc1 <- "Avanza 2 o 3 casillas, muy parejo. El favorito de siempre.";
				desc2 <- "De vez en cuando se encabrita y no se mueve.";
			4:
				vel <- 3; cons <- 2; loc <- 4;
				desc1 <- "Avanza 1 a 3 casillas. Si se emociona, hasta 6.";
				desc2 <- "Si ve un gato se va a perseguirlo y pierde 2 turnos.";
			5:
				vel <- 2; cons <- 1; loc <- 5;
				desc1 <- "Avanza 0 a 3 casillas. Nadie sabe qué va a hacer.";
				desc2 <- "A veces SALE VOLANDO 6 casillas. Sí, las gallinas vuelan.";
			De Otro Modo:
				vel <- 1; cons <- 3; loc <- 5;
				desc1 <- "Avanza 1 casilla por turno... y el lodo no lo frena.";
				desc2 <- "Pero a veces activa el MODO NITRO y avanza 9 de golpe.";
		FinSegun
		Para sangria <- 40 Hasta 8 Con Paso -8 Hacer
			Borrar Pantalla;
			TextoGrande("CORREDORES");
			Escribir "";
			Escribir "   ", i, " de ", n, ":  ", Mayusculas(nombres[i]);
			Para j <- 1 Hasta 6 Hacer
				Escribir Tira(" ", sangria), dibujo[j];
			FinPara
			Esperar 45 Milisegundos;
		FinPara
		Escribir "";
		Escribir "   Velocidad   ", Barra(vel);
		Escribir "   Constancia  ", Barra(cons);
		Escribir "   Locura      ", Barra(loc);
		Escribir "";
		Escribir "   ", desc1;
		Escribir "   ", desc2;
		PresionaTecla();
	FinPara
FinSubProceso

Funcion r <- Barra(valor)
	Definir r Como Caracter;
	r <- "[" + Tira("#", valor * 2) + Tira("-", 10 - valor * 2) + "]";
FinFuncion

SubProceso CuentaRegresiva(info)
	Definir k, i Como Entero;
	Definir focos, tapas Como Caracter;
	Para k <- 3 Hasta 0 Con Paso -1 Hacer
		Borrar Pantalla;
		Escribir " ", info;
		Escribir Tira("=", 78);
		Escribir "";
		tapas <- Tira(" ", 25);
		focos <- Tira(" ", 25);
		Para i <- 1 Hasta 3 Hacer
			tapas <- tapas + "+-----+   ";
			Si k > 0 & i <= 4 - k Entonces focos <- focos + "|#####|   "; SiNo focos <- focos + "|     |   "; FinSi
		FinPara
		Escribir tapas;
		Escribir focos;
		Escribir focos;
		Escribir tapas;
		Escribir "";
		Escribir "";
		Si k > 0 Entonces
			TextoGrande(ConvertirATexto(k));
			Esperar 650 Milisegundos;
		SiNo
			TextoGrande("YA!");
			Esperar 500 Milisegundos;
		FinSi
	FinPara
FinSubProceso

SubProceso FotoFinish(nombres, simbolos, orden)
	Definir k, j Como Entero;
	Definir pre, borde Como Caracter;
	Para k <- 1 Hasta 3 Hacer
		Borrar Pantalla;
		Para j <- 1 Hasta 12 Hacer
			Escribir Tira(" *  ", 19);
		FinPara
		Esperar 90 Milisegundos;
		Borrar Pantalla;
		Esperar 140 Milisegundos;
	FinPara
	Escribir "";
	TextoGrande("FOTO FINISH");
	Escribir "";
	EscribirLento("   ¡" + nombres[orden[1]] + " y " + nombres[orden[2]] + " llegaron JUNTITOS!", 25);
	Escribir Sin Saltar "   Los jueces revisan la foto";
	Para k <- 1 Hasta 6 Hacer
		Esperar 300 Milisegundos;
		Escribir Sin Saltar " .";
	FinPara
	Escribir "";
	Escribir "";
	pre <- "        |   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~";
	borde <- "        |" + Tira(" ", 36) + "|" + Tira(" ", 13) + "|";
	Escribir "        +------------------ FOTO OFICIAL -------------------+";
	Escribir borde;
	Escribir pre, " [", simbolos[orden[1]], "]>             |";
	Escribir pre, "[", simbolos[orden[2]], "]>|             |";
	Escribir borde;
	Escribir "        +---------------------------------------------------+";
	Escribir "";
	EscribirLento("   La foto no miente: ¡" + nombres[orden[1]] + " gana por una nariz!", 25);
	PresionaTecla();
FinSubProceso

SubProceso Podio(nombres, orden)
	Definir f, j, k Como Entero;
	Definir n1, n2, n3, caja, vacia, sp, confeti Como Caracter;
	n1 <- Rellenar(Centrar("1º " + Mayusculas(nombres[orden[1]]), 15), 15);
	n2 <- Rellenar(Centrar("2º " + nombres[orden[2]], 15), 15);
	n3 <- Rellenar(Centrar("3º " + nombres[orden[3]], 15), 15);
	caja <- "+-------------+";
	vacia <- "|             |";
	sp <- Tira(" ", 11);
	Para f <- 1 Hasta 14 Hacer
		Borrar Pantalla;
		Escribir "";
		Para j <- 1 Hasta 5 Hacer
			confeti <- "";
			Para k <- 1 Hasta 78 Hacer
				Si Azar(100) < 12 Entonces confeti <- confeti + Subcadena("*+o.~^", (k % 6) + 1, (k % 6) + 1); SiNo confeti <- confeti + " "; FinSi
			FinPara
			Escribir confeti;
		FinPara
		Escribir sp, Tira(" ", 16), n1;
		Escribir sp, Tira(" ", 16), caja;
		Escribir sp, n2, " ", vacia, " ", n3;
		Escribir sp, caja, " |      1      | ", caja;
		Escribir sp, "|      2      | ", vacia, " |      3      |";
		Escribir sp, vacia, " ", vacia, " ", vacia;
		Escribir "      =====+=============+=+=============+=+=============+=====";
		Escribir "";
		Si f > 5 Entonces Escribir Centrar("¡¡ G A N Ó   " + Mayusculas(nombres[orden[1]]) + " !!", 78); FinSi
		Esperar 120 Milisegundos;
	FinPara
	PresionaTecla();
FinSubProceso

Funcion cachado <- RevisionJuez(nombreAnimal)
	Definir cachado Como Logico;
	Definir k Como Entero;
	Borrar Pantalla;
	Escribir "";
	Escribir "";
	EscribirLento("   El juez se acerca a " + nombreAnimal + " con cara de sospecha...", 25);
	Escribir Sin Saltar "   Revisando el antidoping";
	Para k <- 1 Hasta 6 Hacer
		Esperar 300 Milisegundos;
		Escribir Sin Saltar " .";
	FinPara
	Escribir "";
	Escribir "";
	cachado <- Azar(100) < 25;
	Si cachado Entonces
		TextoGrande("TE CACHARON!");
		Escribir "";
		Escribir "   Encontraron restos de ZANAHORIA ILEGAL. Tu apuesta queda anulada.";
	SiNo
		EscribirLento("   ...todo en orden. El juez no vio nada. (guiño, guiño)", 25);
	FinSi
	PresionaTecla();
FinFuncion

SubProceso PantallaResultado(gano, descripcion, detalle, monto, ganancia)
	Borrar Pantalla;
	Escribir "";
	Si gano Entonces TextoGrande("GANASTE!"); SiNo TextoGrande("PERDISTE"); FinSi
	Escribir "";
	Escribir Centrar("Tu apuesta: " + descripcion, 78);
	Escribir Centrar(detalle, 78);
	Escribir "";
	Si gano Entonces
		Escribir Centrar("¡Le atinaste, eres un crack!", 78);
		Escribir Centrar("Cobras " + Plata(monto) + "  (ganancia de " + Plata(ganancia) + ")", 78);
	SiNo
		Escribir Centrar("Pierdes " + Plata(monto) + ". Perdiste bot, suerte la próxima.", 78);
	FinSi
	Escribir "";
FinSubProceso

Funcion gano <- DobleONada(ganancia)
	Definir gano Como Logico;
	Definir eleccion, resultado, f, pausa Como Entero;
	Borrar Pantalla;
	TextoGrande("DOBLE O NADA");
	Escribir "";
	Escribir "   Te juegas tus ", Plata(ganancia), " de ganancia a un volado.";
	Escribir "   Si le atinas se DUPLICAN. Si no, solo recuperas lo que apostaste.";
	Escribir "";
	eleccion <- LeerEntero("[1] Cara   [2] Cruz", 1, 2);
	resultado <- Azar(2) + 1;
	pausa <- 40;
	Para f <- 1 Hasta 17 Hacer
		Borrar Pantalla;
		TextoGrande("DOBLE O NADA");
		Escribir "";
		Si f < 17 Entonces
			Escribir Centrar("La moneda gira...", 78);
			Escribir "";
			DibujarMoneda(ConvertirANumero(Subcadena("1232", f % 4 + 1, f % 4 + 1)));
		SiNo
			Si resultado = 1 Entonces Escribir Centrar("¡Salió CARA!", 78); SiNo Escribir Centrar("¡Salió CRUZ!", 78); FinSi
			Escribir "";
			DibujarMoneda(resultado * 3 - 2);
		FinSi
		Esperar pausa Milisegundos;
		pausa <- pausa + 12;
	FinPara
	Escribir "";
	gano <- resultado = eleccion;
	Si gano Entonces
		Escribir Centrar("¡LE ATINASTE! Tu ganancia se duplica.", 78);
	SiNo
		Escribir Centrar("Fallaste... te quedas solo con lo que apostaste.", 78);
	FinSi
	PresionaTecla();
FinFuncion

SubProceso DibujarMoneda(cara)
	Definir m Como Caracter;
	Dimension m[6];
	Definir f Como Entero;
	m[1] <- "   _________        _____            _          _________   ";
	m[2] <- "  /         \      /     \          | |        /    |    \  ";
	m[3] <- " |   O   O   |    |       |         | |       |     |     | ";
	m[4] <- " |     ^     |    |       |         | |       |  ---+---  | ";
	m[5] <- " |   \___/   |    |       |         | |       |     |     | ";
	m[6] <- "  \_________/      \_____/          |_|        \____|____/  ";
	Para f <- 1 Hasta 6 Hacer
		Escribir Tira(" ", 31), Subcadena(m[f], (cara - 1) * 15 + 1, cara * 15);
	FinPara
FinSubProceso

SubProceso AnimarDinero(antes, despues, deuda)
	Definir k, valor Como Entero;
	Para k <- 0 Hasta 16 Hacer
		valor <- antes + Trunc((despues - antes) * k / 16);
		Borrar Pantalla;
		Escribir "";
		Escribir "";
		Escribir Centrar("+--------------------------------+", 78);
		Escribir Centrar("|          TU CARTERA            |", 78);
		Escribir Centrar("+--------------------------------+", 78);
		Escribir "";
		TextoGrande("$" + ConvertirATexto(valor));
		Escribir "";
		Esperar 45 Milisegundos;
	FinPara
	Si despues >= antes Entonces
		Escribir Centrar("+" + Plata(despues - antes), 78);
	SiNo
		Escribir Centrar("-" + Plata(antes - despues), 78);
	FinSi
	Si deuda > 0 Entonces Escribir Centrar("(Don Tiburón te recuerda que le debes " + Plata(deuda) + ")", 78); FinSi
FinSubProceso

Funcion acepta <- OfrecerPrestamo(jugador)
	Definir acepta Como Logico;
	Definir p Como Entero;
	Para p <- 60 Hasta 20 Con Paso -5 Hacer
		Borrar Pantalla;
		Escribir "";
		Escribir "";
		Escribir Tira(" ", p), "   |\";
		Escribir Tira(" ", p), "   | \";
		Escribir Tira(" ", p), "   |  \";
		Escribir Tira("~", p), "~~~|___\", Tira("~", 67 - p);
		Esperar 120 Milisegundos;
	FinPara
	Escribir "";
	TextoGrande("DON TIBURON");
	Escribir "";
	EscribirLento("   Vaya, vaya... " + jugador + ", te quedaste sin un peso.", 25);
	EscribirLento("   Te presto $60 ahorita mismo... y al final me regresas $120.", 25);
	EscribirLento("   No te preocupes, soy muy comprensivo. Casi siempre.", 25);
	Escribir "";
	acepta <- LeerSiNo("¿Aceptas el trato?");
	Si acepta Entonces
		EscribirLento("   Excelente. Aquí tienes. Nos vemos al final del torneo...", 25);
	SiNo
		EscribirLento("   Tú te lo pierdes. Sin dinero no hay apuestas.", 25);
	FinSi
	Esperar 800 Milisegundos;
FinFuncion

SubProceso PantallaFinal(jugador, nombres, victorias, n, dinero, deuda, jugadas, ganadas, mayorPremio, dineroInicial)
	Definir i, total Como Entero;
	Definir rango Como Caracter;
	total <- dinero - deuda;
	Borrar Pantalla;
	TextoGrande("FIN DEL TORNEO");
	Escribir Tira("=", 78);
	Escribir "   Apostador: ", jugador;
	Escribir "   Carreras: ", jugadas, "     Apuestas ganadas: ", ganadas, "     Mayor cobro: ", Plata(mayorPremio);
	Escribir "   Dinero en la bolsa: ", Plata(dinero);
	Si deuda > 0 Entonces Escribir "   Don Tiburón cobra su préstamo: -", Plata(deuda); FinSi
	Escribir "   RESULTADO FINAL: ", Plata(total);
	Escribir "";
	rango <- "LEYENDA DEL HIPÓDROMO. Los animales te hacen reverencia.";
	Si total < dineroInicial * 4 Entonces rango <- "TIBURÓN DE LAS APUESTAS. ¡Eres un crack!"; FinSi
	Si total < dineroInicial * 2 Entonces rango <- "Apostador con suerte. No está nada mal."; FinSi
	Si total < dineroInicial Entonces rango <- "Apostador novato. Perdiste " + Plata(dineroInicial - total) + "."; FinSi
	Si total <= 0 Entonces rango <- "BANCARROTA TOTAL. Perdiste bot, suerte la próxima."; FinSi
	Escribir Sin Saltar "   Tu rango: ";
	EscribirLento(rango, 30);
	Escribir "";
	Escribir "   VICTORIAS EN EL TORNEO";
	Para i <- 1 Hasta n Hacer
		Escribir "     ", Rellenar(nombres[i], 9), Rellenar(Tira("#", victorias[i] * 4), 22), victorias[i];
	FinPara
	PresionaTecla();
FinSubProceso

SubProceso PantallaLogros(logros)
	Definir titulos, descripciones Como Caracter;
	Dimension titulos[8], descripciones[8];
	Definir i, total Como Entero;
	titulos[1] <- "Todo o nada";            descripciones[1] <- "Apostaste TODO tu dinero y ganaste";
	titulos[2] <- "Batacazo";               descripciones[2] <- "Ganaste con una cuota de x8.0 o más";
	titulos[3] <- "Francotirador";          descripciones[3] <- "Le atinaste a una apuesta Exacta";
	titulos[4] <- "En racha";               descripciones[4] <- "Ganaste 3 apuestas seguidas";
	titulos[5] <- "Pillo";                  descripciones[5] <- "Usaste la zanahoria ilegal y no te cacharon";
	titulos[6] <- "Cliente de Don Tiburón"; descripciones[6] <- "Pediste un préstamo";
	titulos[7] <- "Doble o nada";           descripciones[7] <- "Ganaste un volado de doble o nada";
	titulos[8] <- "Foto finish";            descripciones[8] <- "Viste una llegada por foto finish";
	Borrar Pantalla;
	TextoGrande("LOGROS");
	Escribir Tira("-", 78);
	total <- 0;
	Para i <- 1 Hasta 8 Hacer
		Esperar 250 Milisegundos;
		Si logros[i] Entonces
			total <- total + 1;
			Escribir "   [X] ", Rellenar(titulos[i], 24), descripciones[i];
		SiNo
			Escribir "   [ ] ", Rellenar("? ? ?", 24), "(sigue intentando)";
		FinSi
	FinPara
	Escribir Tira("-", 78);
	Escribir "   Desbloqueaste ", total, " de 8 logros.";
	Si total = 8 Entonces EscribirLento("   ¡¡LOS SACASTE TODOS!! Eres oficialmente una leyenda.", 30); FinSi
	PresionaTecla();
FinSubProceso

SubProceso PantallaDespedida(jugador, simbolos, n)
	Definir lineas Como Caracter;
	Dimension lineas[6];
	Definir f Como Entero;
	Para f <- 1 Hasta 4 Hacer
		lineas[f] <- Centrar(FilaGrande("GRACIAS!", f), 78);
	FinPara
	lineas[5] <- "";
	lineas[6] <- Centrar("Gracias por jugar, " + jugador + ". ¡Vuelve pronto al hipódromo!", 78);
	Desfile(lineas, 6, simbolos, n, 22, "~ ~ ~   F I N   ~ ~ ~");
FinSubProceso

Funcion r <- Tira(c, k)
	Definir r Como Caracter;
	Definir i Como Entero;
	r <- "";
	Para i <- 1 Hasta k Con Paso 1 Hacer
		r <- r + c;
	FinPara
FinFuncion

Funcion r <- Rellenar(s, ancho)
	Definir r Como Caracter;
	r <- Subcadena(s + Tira(" ", ancho), 1, ancho);
FinFuncion

Funcion r <- RellenarIzq(s, ancho)
	Definir r Como Caracter;
	r <- s;
	Si Longitud(s) < ancho Entonces r <- Tira(" ", ancho - Longitud(s)) + s; FinSi
FinFuncion

Funcion r <- Centrar(s, ancho)
	Definir r Como Caracter;
	r <- s;
	Si Longitud(s) < ancho Entonces r <- Tira(" ", Trunc((ancho - Longitud(s)) / 2)) + s; FinSi
FinFuncion

Funcion r <- Plata(cantidad)
	Definir r Como Caracter;
	r <- "$" + ConvertirATexto(cantidad);
	Si cantidad < 0 Entonces r <- "-$" + ConvertirATexto(-cantidad); FinSi
FinFuncion

SubProceso EscribirLento(msg, ms)
	Definir i Como Entero;
	Para i <- 1 Hasta Longitud(msg) Con Paso 1 Hacer
		Escribir Sin Saltar Subcadena(msg, i, i);
		Si Subcadena(msg, i, i) <> " " Entonces Esperar ms Milisegundos; FinSi
	FinPara
	Escribir "";
FinSubProceso

SubProceso PresionaTecla
	Escribir "";
	Escribir Sin Saltar Centrar(">> Presiona cualquier tecla para continuar <<", 78);
	Esperar Tecla;
	Escribir "";
FinSubProceso

Funcion valor <- LeerEntero(mensaje, minimo, maximo)
	Definir valor, i Como Entero;
	Definir entrada, ch Como Caracter;
	Definir valido Como Logico;
	valido <- Falso;
	valor <- minimo;
	Mientras valido = Falso Hacer
		Escribir Sin Saltar "   ", mensaje, " (", minimo, "-", maximo, "): ";
		Leer entrada;
		valido <- Longitud(entrada) > 0 & Longitud(entrada) <= 6;
		Para i <- 1 Hasta Longitud(entrada) Con Paso 1 Hacer
			ch <- Subcadena(entrada, i, i);
			Si ch < "0" | ch > "9" Entonces valido <- Falso; FinSi
		FinPara
		Si valido Entonces
			valor <- ConvertirANumero(entrada);
			Si valor < minimo | valor > maximo Entonces valido <- Falso; FinSi
		FinSi
		Si valido = Falso Entonces Escribir "   Eso no se vale. Tiene que ser un número entre ", minimo, " y ", maximo, "."; FinSi
	FinMientras
FinFuncion

Funcion r <- LeerSiNo(mensaje)
	Definir r, listo Como Logico;
	Definir entrada Como Caracter;
	r <- Falso;
	listo <- Falso;
	Mientras listo = Falso Hacer
		Escribir Sin Saltar "   ", mensaje, " (S/N): ";
		Leer entrada;
		entrada <- Mayusculas(entrada);
		r <- entrada = "S" | entrada = "SI" | entrada = "SÍ";
		listo <- r | entrada = "N" | entrada = "NO";
		Si listo = Falso Entonces Escribir "   Contesta con S o N."; FinSi
	FinMientras
FinFuncion

Funcion r <- FilaGrande(msg, fila)
	Definir r, letras, anchos Como Caracter;
	Definir fuente Como Caracter;
	Dimension fuente[4];
	Definir i, k, ini Como Entero;
	letras <- "ABCDEFGHIJLMNOPQRSTUVXYZ0123456789!?-.$ ";
	anchos <- "7566556656686757557776756355655655355353";
	fuente[1] <- "   _    ___   ___  ___   ___  ___   ___  _  _  ___     _  _     __  __  _  _   ___   ___   ___   ___  ___  _____  _   _ __   ____  ____   __ ____  __   _  ___  ____ _ _   ___   __  ____  ___  ___  _  ___          _|_    ";
	fuente[2] <- "  /_\  | _ ) / __||   \ | __|| __| / __|| || ||_ _| _ | || |   |  \/  || \| | / _ \ | _ \ / _ \ | _ \/ __||_   _|| | | |\ \ / /\ \/ /\ \ / /|_  / /  \ / ||_  )|__ /| | | | __| / / |__  |( _ )/ _ \| ||__ \ ___    / __|   ";
	fuente[3] <- " / _ \ | _ \| (__ | |) || _| | _| | (_ || __ | | | | || || |__ | |\/| || .` || (_) ||  _/| (_) ||   /\__ \  | |  | |_| | \ V /  >  <  \ V /  / / | () || | / /  |_ \|_  _||__ \/ _ \  / / / _ \\_, /|_|  /_/|___| _ \__ \   ";
	fuente[4] <- "/_/ \_\|___/ \___||___/ |___||_|   \___||_||_||___| \__/ |____||_|  |_||_|\_| \___/ |_|   \__\_\|_|_\|___/  |_|   \___/   \_/  /_/\_\  |_|  /___| \__/ |_|/___||___/  |_| |___/\___/ /_/  \___/ /_/ (_) (_)      (_)|_|_/   ";
	r <- "";
	msg <- Mayusculas(msg);
	Para i <- 1 Hasta Longitud(msg) Hacer
		k <- 1;
		ini <- 1;
		Mientras k < Longitud(letras) & Subcadena(letras, k, k) <> Subcadena(msg, i, i) Hacer
			ini <- ini + ConvertirANumero(Subcadena(anchos, k, k));
			k <- k + 1;
		FinMientras
		r <- r + Subcadena(fuente[fila], ini, ini + ConvertirANumero(Subcadena(anchos, k, k)) - 1);
	FinPara
FinFuncion

SubProceso TextoGrande(msg)
	Definir f Como Entero;
	Para f <- 1 Hasta 4 Hacer
		Escribir Centrar(FilaGrande(msg, f), 78);
	FinPara
FinSubProceso

SubProceso CargarDibujo(animal, dibujo)
	Segun animal Hacer
		1:
			dibujo[1] <- "             _________";
			dibujo[2] <- "           _/_|_|_|_|_\_    ___";
			dibujo[3] <- "          /_|_|_|_|_|_|_\__/ o \";
			dibujo[4] <- "          \_____________/ _____/";
			dibujo[5] <- "            |_|      |_|";
			dibujo[6] <- "";
		2:
			dibujo[1] <- "                 _   _";
			dibujo[2] <- "                ( \ / )";
			dibujo[3] <- "         ______  \ V /__";
			dibujo[4] <- "        /            o \";
			dibujo[5] <- "       (    ___      __/";
			dibujo[6] <- "        \__/   \____/";
		3:
			dibujo[1] <- "                     ,/|";
			dibujo[2] <- "          __________/ o |";
			dibujo[3] <- "         /|           __|";
			dibujo[4] <- "        / |  _______ |";
			dibujo[5] <- "          | |       | |";
			dibujo[6] <- "          |_|       |_|";
		4:
			dibujo[1] <- "                         _";
			dibujo[2] <- "        |\______________/ \__";
			dibujo[3] <- "        |               o   _)";
			dibujo[4] <- "         \   ________   |--";
			dibujo[5] <- "          |_|        |_|";
			dibujo[6] <- "";
		5:
			dibujo[1] <- "                ,~.";
			dibujo[2] <- "               ( o )>";
			dibujo[3] <- "         ___   /   \";
			dibujo[4] <- "        (   \_/     |";
			dibujo[5] <- "         \_________/";
			dibujo[6] <- "            |   |";
		6:
			dibujo[1] <- "                    \  /";
			dibujo[2] <- "           ______    o  o";
			dibujo[3] <- "         /  ___  \   |  |";
			dibujo[4] <- "        |  ( @ )  |_/   |";
			dibujo[5] <- "     ~~~~\_______/______/";
			dibujo[6] <- "";
	FinSegun
FinSubProceso
