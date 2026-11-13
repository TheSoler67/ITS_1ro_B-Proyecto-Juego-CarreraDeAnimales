// Carrera de animales con apuestas
import java.util.Random;
import java.util.Scanner;

public class CarreraDeAnimales {

    static final int NUM_ANIMALES = 4;
    static final int META = 20;
    static final int TRAMPA = 7;                // regresa 2 casillas
    static final int TURBO = 12;                // avanza 3 casillas
    static final int DINERO_INICIAL = 100;
    static final int RONDAS = 4;
    static final int APUESTA_RIVAL_MIN = 10;    // lo que apuestan otros jugadores a los demas animales
    static final int APUESTA_RIVAL_MAX = 100;
    static final int PAUSA_MS = 700;

    static Scanner sc = new Scanner(System.in);
    static Random random = new Random();

    public static void main(String[] args) {
        String[] nombres = {"Tortuga", "Liebre", "Caballo", "Perro"};
        String[] simbolos = {"T", "L", "C", "P"};
        int[] posiciones = new int[NUM_ANIMALES];
        int[] victorias = new int[NUM_ANIMALES];
        int[] apuestas = new int[NUM_ANIMALES];

        int dinero = DINERO_INICIAL;
        int ronda = 0;
        int ganadas = 0;

        mostrarInstrucciones();

        while (ronda < RONDAS && dinero > 0) {
            ronda++;
            System.out.println("\n--- Carrera " + ronda + " de " + RONDAS + " | Tienes $" + dinero + " ---");
            mostrarAnimales(nombres, victorias);

            int eleccion = leerEntero("Animal", 1, NUM_ANIMALES);
            int apuesta = leerEntero("Apuesta", 1, dinero);
            int elegido = eleccion - 1;     // el arreglo empieza en 0
            dinero -= apuesta;              // tu apuesta sale de tu dinero

            generarApuestas(apuestas, elegido, apuesta);
            mostrarApuestas(nombres, apuestas, elegido);

            correrCarrera(nombres, simbolos, posiciones);
            int mejor = posicionGanadora(posiciones);
            registrarGanadores(nombres, posiciones, victorias, mejor);

            if (posiciones[elegido] == mejor) {
                int premio = calcularPremio(apuestas, posiciones, mejor);
                dinero += apuesta + premio;     // recuperas tu apuesta + el premio
                ganadas++;
                System.out.println("¡Ganaste, eres un crack! Recuperas tus $" + apuesta + " y ganas $" + premio);
            } else {
                System.out.println("Perdiste bot, suerte la próxima. Pierdes tus $" + apuesta);
            }
        }

        mostrarResumen(nombres, victorias, dinero, ronda, ganadas);
    }

    static int leerEntero(String mensaje, int minimo, int maximo) {
        int valor = minimo - 1;
        while (valor < minimo || valor > maximo) {
            System.out.print(mensaje + " (" + minimo + "-" + maximo + "): ");
            try {
                valor = Integer.parseInt(sc.nextLine().trim());
                if (valor < minimo || valor > maximo) {
                    System.out.println("Tiene que ser entre " + minimo + " y " + maximo);
                }
            } catch (NumberFormatException e) {
                System.out.println("Escribe un número");
            }
        }
        return valor;
    }

    static void mostrarInstrucciones() {
        System.out.println("===== CARRERA DE ANIMALES =====");
        System.out.println(RONDAS + " carreras. Empiezas con $" + DINERO_INICIAL + ".");
        System.out.println("Apuesta por un animal; a los otros 3 les apuestan otros jugadores al azar.");
        System.out.println("Si gana tu animal recuperas tu apuesta y te llevas lo de los demás (si hay empate se reparte).");
        System.out.println("Gana el primero en llegar a la casilla " + META + " (si llegan juntos, el que llegó más lejos).");
        System.out.println("x = trampa (regresa 2)   > = turbo (avanza 3)");
    }

    static void mostrarAnimales(String[] nombres, int[] victorias) {
        for (int i = 0; i < NUM_ANIMALES; i++) {
            System.out.printf("%d. %-8s (%d ganadas)%n", i + 1, nombres[i], victorias[i]);
        }
    }

    static void generarApuestas(int[] apuestas, int elegido, int apuesta) {
        for (int i = 0; i < NUM_ANIMALES; i++) {
            if (i == elegido) {
                apuestas[i] = apuesta;
            } else {
                apuestas[i] = random.nextInt(APUESTA_RIVAL_MAX - APUESTA_RIVAL_MIN + 1) + APUESTA_RIVAL_MIN;
            }
        }
    }

    static void mostrarApuestas(String[] nombres, int[] apuestas, int elegido) {
        System.out.println("\nApuestas:");
        int bolsa = 0;
        for (int i = 0; i < NUM_ANIMALES; i++) {
            bolsa += apuestas[i];
            if (i == elegido) {
                System.out.printf("%-8s $%d (tú)%n", nombres[i], apuestas[i]);
            } else {
                System.out.printf("%-8s $%d%n", nombres[i], apuestas[i]);
            }
        }
        System.out.println("Bolsa total: $" + bolsa);
    }

    static void dibujarPista(String[] nombres, String[] simbolos, int[] posiciones) {
        for (int i = 0; i < NUM_ANIMALES; i++) {
            int lugar = posiciones[i];
            if (lugar > META) {         // si ya pasó la meta se dibuja en la meta
                lugar = META;
            }

            String linea = "";
            for (int casilla = 0; casilla <= META; casilla++) {
                if (casilla == lugar) {
                    linea += simbolos[i];
                } else if (casilla == TRAMPA) {
                    linea += "x";
                } else if (casilla == TURBO) {
                    linea += ">";
                } else {
                    linea += "-";
                }
            }
            System.out.printf("%-8s %s| %d%n", nombres[i], linea, posiciones[i]);
        }
    }

    static void correrCarrera(String[] nombres, String[] simbolos, int[] posiciones) {
        for (int i = 0; i < NUM_ANIMALES; i++) {
            posiciones[i] = 0;
        }

        System.out.println("\n¡Arrancan!");
        dibujarPista(nombres, simbolos, posiciones);

        boolean hayGanador = false;
        int turno = 0;
        while (!hayGanador) {
            pausa();
            turno++;
            System.out.println("\nTurno " + turno);

            for (int i = 0; i < NUM_ANIMALES; i++) {
                posiciones[i] += random.nextInt(3) + 1;     // avanza de 1 a 3

                if (posiciones[i] == TRAMPA) {
                    posiciones[i] -= 2;
                    System.out.println(nombres[i] + " cayó en la trampa (-2)");
                } else if (posiciones[i] == TURBO) {
                    posiciones[i] += 3;
                    System.out.println(nombres[i] + " agarró turbo (+3)");
                }

                if (posiciones[i] >= META) {
                    hayGanador = true;
                }
            }

            dibujarPista(nombres, simbolos, posiciones);
        }
    }

    // busca la posición más lejana (el mayor del arreglo)
    static int posicionGanadora(int[] posiciones) {
        int mejor = posiciones[0];
        for (int i = 1; i < NUM_ANIMALES; i++) {
            if (posiciones[i] > mejor) {
                mejor = posiciones[i];
            }
        }
        return mejor;
    }

    static void registrarGanadores(String[] nombres, int[] posiciones, int[] victorias, int mejor) {
        int cantidad = 0;
        for (int i = 0; i < NUM_ANIMALES; i++) {
            if (posiciones[i] == mejor) {
                cantidad++;
            }
        }

        System.out.println();
        if (cantidad > 1) {
            System.out.println("¡Empate! El premio se reparte");
        }

        for (int i = 0; i < NUM_ANIMALES; i++) {
            if (posiciones[i] == mejor) {
                victorias[i]++;
                System.out.println("Ganó " + nombres[i]);
            }
        }
    }

    // lo que apostaron a los animales que perdieron se reparte entre los ganadores
    static int calcularPremio(int[] apuestas, int[] posiciones, int mejor) {
        int pozo = 0;
        int ganadores = 0;
        for (int i = 0; i < NUM_ANIMALES; i++) {
            if (posiciones[i] == mejor) {
                ganadores++;
            } else {
                pozo += apuestas[i];
            }
        }
        return pozo / ganadores;
    }

    static void mostrarResumen(String[] nombres, int[] victorias, int dinero, int jugadas, int ganadas) {
        System.out.println("\n===== FIN =====");
        System.out.println("Carreras: " + jugadas + "   Ganadas: " + ganadas);
        System.out.println("Terminaste con $" + dinero);
        if (dinero <= 0) {
            System.out.println("Te quedaste sin dinero. Perdiste bot, suerte la próxima.");
        } else if (dinero > DINERO_INICIAL) {
            System.out.println("Ganaste $" + (dinero - DINERO_INICIAL) + ", ¡eres un crack!");
        } else if (dinero < DINERO_INICIAL) {
            System.out.println("Perdiste $" + (DINERO_INICIAL - dinero) + ", bot. Suerte la próxima.");
        } else {
            System.out.println("Quedaste igual que al inicio.");
        }
        for (int i = 0; i < NUM_ANIMALES; i++) {
            System.out.printf("%-8s %d victorias%n", nombres[i], victorias[i]);
        }
    }

    static void pausa() {
        try {
            Thread.sleep(PAUSA_MS);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
