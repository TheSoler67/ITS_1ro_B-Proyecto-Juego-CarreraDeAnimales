# Carrera de animales con apuestas
import random
import time

NUM_ANIMALES = 4
META = 20
TRAMPA = 7              # regresa 2 casillas
TURBO = 12              # avanza 3 casillas
DINERO_INICIAL = 100
RONDAS = 4
APUESTA_RIVAL_MIN = 10  # lo que apuestan otros jugadores a los demas animales
APUESTA_RIVAL_MAX = 100
PAUSA = 0.7


def leer_entero(mensaje, minimo, maximo):
    valor = minimo - 1
    while valor < minimo or valor > maximo:
        try:
            valor = int(input(f"{mensaje} ({minimo}-{maximo}): "))
            if valor < minimo or valor > maximo:
                print(f"Tiene que ser entre {minimo} y {maximo}")
        except ValueError:
            print("Escribe un número")
    return valor


def mostrar_instrucciones():
    print("===== CARRERA DE ANIMALES =====")
    print(f"{RONDAS} carreras. Empiezas con ${DINERO_INICIAL}.")
    print("Apuesta por un animal; a los otros 3 les apuestan otros jugadores al azar.")
    print("Si gana tu animal recuperas tu apuesta y te llevas lo de los demás (si hay empate se reparte).")
    print(f"Gana el primero en llegar a la casilla {META} (si llegan juntos, el que llegó más lejos).")
    print("x = trampa (regresa 2)   > = turbo (avanza 3)")


def mostrar_animales(nombres, victorias):
    for i in range(NUM_ANIMALES):
        print(f"{i + 1}. {nombres[i]:<8} ({victorias[i]} ganadas)")


def generar_apuestas(apuestas, elegido, apuesta):
    for i in range(NUM_ANIMALES):
        if i == elegido:
            apuestas[i] = apuesta
        else:
            apuestas[i] = random.randint(APUESTA_RIVAL_MIN, APUESTA_RIVAL_MAX)


def mostrar_apuestas(nombres, apuestas, elegido):
    print("\nApuestas:")
    bolsa = 0
    for i in range(NUM_ANIMALES):
        bolsa += apuestas[i]
        if i == elegido:
            print(f"{nombres[i]:<8} ${apuestas[i]} (tú)")
        else:
            print(f"{nombres[i]:<8} ${apuestas[i]}")
    print(f"Bolsa total: ${bolsa}")


def dibujar_pista(nombres, simbolos, posiciones):
    for i in range(NUM_ANIMALES):
        lugar = posiciones[i]
        if lugar > META:        # si ya pasó la meta se dibuja en la meta
            lugar = META

        linea = ""
        for casilla in range(META + 1):
            if casilla == lugar:
                linea += simbolos[i]
            elif casilla == TRAMPA:
                linea += "x"
            elif casilla == TURBO:
                linea += ">"
            else:
                linea += "-"
        print(f"{nombres[i]:<8} {linea}| {posiciones[i]}")


def correr_carrera(nombres, simbolos, posiciones):
    for i in range(NUM_ANIMALES):
        posiciones[i] = 0

    print("\n¡Arrancan!")
    dibujar_pista(nombres, simbolos, posiciones)

    hay_ganador = False
    turno = 0
    while not hay_ganador:
        time.sleep(PAUSA)
        turno += 1
        print(f"\nTurno {turno}")

        for i in range(NUM_ANIMALES):
            posiciones[i] += random.randint(1, 3)

            if posiciones[i] == TRAMPA:
                posiciones[i] -= 2
                print(f"{nombres[i]} cayó en la trampa (-2)")
            elif posiciones[i] == TURBO:
                posiciones[i] += 3
                print(f"{nombres[i]} agarró turbo (+3)")

            if posiciones[i] >= META:
                hay_ganador = True

        dibujar_pista(nombres, simbolos, posiciones)


# busca la posición más lejana (el mayor del arreglo)
def posicion_ganadora(posiciones):
    mejor = posiciones[0]
    for i in range(1, NUM_ANIMALES):
        if posiciones[i] > mejor:
            mejor = posiciones[i]
    return mejor


def registrar_ganadores(nombres, posiciones, victorias, mejor):
    cantidad = 0
    for i in range(NUM_ANIMALES):
        if posiciones[i] == mejor:
            cantidad += 1

    print()
    if cantidad > 1:
        print("¡Empate! El premio se reparte")

    for i in range(NUM_ANIMALES):
        if posiciones[i] == mejor:
            victorias[i] += 1
            print(f"Ganó {nombres[i]}")


# lo que apostaron a los animales que perdieron se reparte entre los ganadores
def calcular_premio(apuestas, posiciones, mejor):
    pozo = 0
    ganadores = 0
    for i in range(NUM_ANIMALES):
        if posiciones[i] == mejor:
            ganadores += 1
        else:
            pozo += apuestas[i]
    return pozo // ganadores


def mostrar_resumen(nombres, victorias, dinero, jugadas, ganadas):
    print("\n===== FIN =====")
    print(f"Carreras: {jugadas}   Ganadas: {ganadas}")
    print(f"Terminaste con ${dinero}")
    if dinero <= 0:
        print("Te quedaste sin dinero. Perdiste bot, suerte la próxima.")
    elif dinero > DINERO_INICIAL:
        print(f"Ganaste ${dinero - DINERO_INICIAL}, ¡eres un crack!")
    elif dinero < DINERO_INICIAL:
        print(f"Perdiste ${DINERO_INICIAL - dinero}, bot. Suerte la próxima.")
    else:
        print("Quedaste igual que al inicio.")
    for i in range(NUM_ANIMALES):
        print(f"{nombres[i]:<8} {victorias[i]} victorias")


def main():
    nombres = ["Tortuga", "Liebre", "Caballo", "Perro"]
    simbolos = ["T", "L", "C", "P"]
    posiciones = [0] * NUM_ANIMALES
    victorias = [0] * NUM_ANIMALES
    apuestas = [0] * NUM_ANIMALES

    dinero = DINERO_INICIAL
    ronda = 0
    ganadas = 0

    mostrar_instrucciones()

    while ronda < RONDAS and dinero > 0:
        ronda += 1
        print(f"\n--- Carrera {ronda} de {RONDAS} | Tienes ${dinero} ---")
        mostrar_animales(nombres, victorias)

        eleccion = leer_entero("Animal", 1, NUM_ANIMALES)
        apuesta = leer_entero("Apuesta", 1, dinero)
        elegido = eleccion - 1      # la lista empieza en 0
        dinero -= apuesta           # tu apuesta sale de tu dinero

        generar_apuestas(apuestas, elegido, apuesta)
        mostrar_apuestas(nombres, apuestas, elegido)

        correr_carrera(nombres, simbolos, posiciones)
        mejor = posicion_ganadora(posiciones)
        registrar_ganadores(nombres, posiciones, victorias, mejor)

        if posiciones[elegido] == mejor:
            premio = calcular_premio(apuestas, posiciones, mejor)
            dinero += apuesta + premio      # recuperas tu apuesta + el premio
            ganadas += 1
            print(f"¡Ganaste, eres un crack! Recuperas tus ${apuesta} y ganas ${premio}")
        else:
            print(f"Perdiste bot, suerte la próxima. Pierdes tus ${apuesta}")

    mostrar_resumen(nombres, victorias, dinero, ronda, ganadas)


main()
