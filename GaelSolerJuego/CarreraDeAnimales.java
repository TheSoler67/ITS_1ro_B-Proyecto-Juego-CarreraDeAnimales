// ==========================================================================
//   CARRERA DE ANIMALES  -  EDICIÓN APUESTAS LOCAS  (versión Java)
//   Primero fue PSeInt, luego vino Java. Mismo caos, ahora con llaves { }.
//
//   CÓMO CORRERLO:
//    - Desde una terminal (la de VS Code o Windows Terminal se ven mejor):
//         javac CarreraDeAnimales.java
//         java CarreraDeAnimales
//    - Si tu consola no borra la pantalla y salen cosas raras tipo [H[2J,
//      cambia LIMPIAR_CON_ANSI a false (la animación se verá con scroll).
//
//   CÓMO SE JUEGA (versión rápida, porque nadie lee las instrucciones):
//    1. Pon tu nombre y en el menú escoge "Jugar torneo".
//    2. Son 5 carreras y arrancas con $100. Antes de cada carrera ves el
//       clima, la pista y las cuotas: entre menos probable que gane un
//       animal, más paga. Las cuotas salen de simular 300 carreras fantasma.
//    3. Apuesta a Ganador, a Podio (top 3) o a Exacta (1º y 2º en orden).
//    4. Si un señor de gabardina te ofrece una zanahoria ilegal... tú sabrás.
//    5. Si ganas, puedes arriesgar la ganancia en un volado de doble o nada.
//    6. Si te quedas en $0, Don Tiburón te presta. Con intereses de tiburón.
//    7. En la pista: x trampa, > turbo, ~ lodo, ? caja sorpresa.
//    8. La Liebre se duerme, el Perro persigue gatos, la Gallina vuela y el
//       Caracol tiene MODO NITRO. En serio. Ningún animal salió lastimado.
// ==========================================================================

import java.util.Random;
import java.util.Scanner;

public class CarreraDeAnimales {

    static final boolean LIMPIAR_CON_ANSI = true;

    static final int NUM_ANIMALES = 6;
    static final int META = 40;
    static final int RONDAS = 5;
    static final int DINERO_INICIAL = 100;
    static final int SIMULACIONES = 300;

    static final int TORTUGA = 0, LIEBRE = 1, CABALLO = 2, PERRO = 3, GALLINA = 4, CARACOL = 5;
    static final int TRAMPA = 1, TURBO = 2, LODO = 3, CAJA = 4;
    static final int SOLEADO = 0, LLUVIA = 1, NOCHE = 2, TORMENTA = 3, VIENTO = 4;

    static final String[] NOMBRES = {"Tortuga", "Liebre", "Caballo", "Perro", "Gallina", "Caracol"};
    static final String[] SIMBOLOS = {"T", "L", "C", "P", "G", "@"};
    static final String[] ESPECIALIDADES = {
        "Las trampas no le hacen nada", "Rapidísima... si no se duerme", "Fuerte y constante",
        "Se distrae con los gatos", "A veces sale volando", "Lento, pero tiene MODO NITRO"
    };

    static final String LETRAS = "ABCDEFGHIJLMNOPQRSTUVXYZ0123456789!?-.$ ";
    static final String ANCHOS = "7566556656686757557776756355655655355353";
    static final String[] FUENTE = {
        "   _    ___   ___  ___   ___  ___   ___  _  _  ___     _  _     __  __  _  _   ___   ___   ___   ___  ___  _____  _   _ __   ____  ____   __ ____  __   _  ___  ____ _ _   ___   __  ____  ___  ___  _  ___          _|_    ",
        "  /_\\  | _ ) / __||   \\ | __|| __| / __|| || ||_ _| _ | || |   |  \\/  || \\| | / _ \\ | _ \\ / _ \\ | _ \\/ __||_   _|| | | |\\ \\ / /\\ \\/ /\\ \\ / /|_  / /  \\ / ||_  )|__ /| | | | __| / / |__  |( _ )/ _ \\| ||__ \\ ___    / __|   ",
        " / _ \\ | _ \\| (__ | |) || _| | _| | (_ || __ | | | | || || |__ | |\\/| || .` || (_) ||  _/| (_) ||   /\\__ \\  | |  | |_| | \\ V /  >  <  \\ V /  / / | () || | / /  |_ \\|_  _||__ \\/ _ \\  / / / _ \\\\_, /|_|  /_/|___| _ \\__ \\   ",
        "/_/ \\_\\|___/ \\___||___/ |___||_|   \\___||_||_||___| \\__/ |____||_|  |_||_|\\_| \\___/ |_|   \\__\\_\\|_|_\\|___/  |_|   \\___/   \\_/  /_/\\_\\  |_|  /___| \\__/ |_|/___||___/  |_| |___/\\___/ /_/  \\___/ /_/ (_) (_)      (_)|_|_/   "
    };

    static final String[] MONEDA = {
        "   _________        _____            _          _________   ",
        "  /         \\      /     \\          | |        /    |    \\  ",
        " |   O   O   |    |       |         | |       |     |     | ",
        " |     ^     |    |       |         | |       |  ---+---  | ",
        " |   \\___/   |    |       |         | |       |     |     | ",
        "  \\_________/      \\_____/          |_|        \\____|____/  "
    };

    static final String[][] DIBUJOS = {
        {
            "             _________",
            "           _/_|_|_|_|_\\_    ___",
            "          /_|_|_|_|_|_|_\\__/ o \\",
            "          \\_____________/ _____/",
            "            |_|      |_|",
            ""
        },
        {
            "                 _   _",
            "                ( \\ / )",
            "         ______  \\ V /__",
            "        /            o \\",
            "       (    ___      __/",
            "        \\__/   \\____/"
        },
        {
            "                     ,/|",
            "          __________/ o |",
            "         /|           __|",
            "        / |  _______ |",
            "          | |       | |",
            "          |_|       |_|"
        },
        {
            "                         _",
            "        |\\______________/ \\__",
            "        |               o   _)",
            "         \\   ________   |--",
            "          |_|        |_|",
            ""
        },
        {
            "                ,~.",
            "               ( o )>",
            "         ___   /   \\",
            "        (   \\_/     |",
            "         \\_________/",
            "            |   |"
        },
        {
            "                    \\  /",
            "           ______    o  o",
            "         /  ___  \\   |  |",
            "        |  ( @ )  |_/   |",
            "     ~~~~\\_______/______/",
            ""
        }
    };

    static Scanner sc = new Scanner(System.in);
    static Random rnd = new Random();

    public static void main(String[] args) {
        pantallaTitulo();
        String jugador = pedirNombre();
        int menu;
        do {
            menu = menuPrincipal(jugador);
            switch (menu) {
                case 1:
                    jugarTorneo(jugador);
                    break;
                case 2:
                    pantallaInstrucciones();
                    break;
                case 3:
                    pantallaCorredores();
                    break;
            }
        } while (menu != 4);
        pantallaDespedida(jugador);
    }

    static void jugarTorneo(String jugador) {
        int n = NUM_ANIMALES;
        int[] victorias = new int[n];
        int[] pista = new int[META + 1];
        int[] orden = new int[n];
        int[] posiciones = new int[n];
        int[] cuotaGan = new int[n];
        int[] cuotaPod = new int[n];
        int[][] exacta = new int[n][n];
        boolean[] logros = new boolean[8];
        int dinero = DINERO_INICIAL, deuda = 0, ronda = 0, jugadas = 0, ganadas = 0, racha = 0, mayorPremio = 0;
        boolean seguir = true;

        while (ronda < RONDAS && seguir) {
            if (dinero <= 0) {
                if (deuda == 0) {
                    seguir = ofrecerPrestamo(jugador);
                    if (seguir) {
                        dinero = 60;
                        deuda = 120;
                        logros[5] = true;
                    }
                } else {
                    limpiar();
                    escribirLento("   Otra vez en $0 y Don Tiburón ya no te presta. Seguridad te saca del hipódromo.", 25);
                    presionaTecla();
                    seguir = false;
                }
            }
            if (seguir) {
                ronda++;
                int clima = azar(5);
                generarPista(pista, clima);
                limpiar();
                System.out.println(tira("=", 78));
                System.out.println(centrar("CARRERA " + ronda + " DE " + RONDAS, 78));
                System.out.println(tira("=", 78));
                escribirLento("   Clima de hoy: " + nombreClima(clima), 20);
                escribirLento("   Los expertos simulan " + SIMULACIONES + " carreras con esta pista para sacar las cuotas...", 12);
                calcularCuotas(pista, clima, cuotaGan, cuotaPod, exacta);
                esperar(500);

                tablaCuotas(ronda, jugador, dinero, deuda, clima, pista, cuotaGan, cuotaPod, victorias);
                System.out.println("   APUESTAS:  [1] Ganador    [2] Podio (que quede top 3)    [3] Exacta (1º y 2º)");
                int tipo = leerEntero("¿Qué apuesta haces?", 1, 3);
                String pregunta = "¿A qué animal le vas?";
                if (tipo == 3) pregunta = "¿Quién llega en 1º lugar?";
                int eleccion = leerEntero(pregunta, 1, n) - 1;
                int eleccion2 = -1;
                int cuota;
                if (tipo == 1) {
                    cuota = cuotaGan[eleccion];
                } else if (tipo == 2) {
                    cuota = cuotaPod[eleccion];
                } else {
                    do {
                        eleccion2 = leerEntero("¿Y quién llega en 2º lugar?", 1, n) - 1;
                        if (eleccion2 == eleccion) System.out.println("   No puede llegar 1º y 2º a la vez, crack.");
                    } while (eleccion2 == eleccion);
                    cuota = cuotaDesdeConteo(exacta[eleccion][eleccion2], SIMULACIONES, 8, 15, 990);
                    System.out.println("   Cuota de tu exacta: " + txtCuota(cuota));
                }
                int dineroAntes = dinero;
                int apuesta = leerEntero("¿Cuánto le metes? Tienes " + plata(dinero), 1, dinero);
                boolean todoAdentro = apuesta == dinero;
                dinero -= apuesta;

                int dopado = -1;
                if (dinero >= 15) {
                    System.out.println();
                    System.out.println("   Psst... un tipo de gabardina te ofrece una ZANAHORIA ILEGAL por $15.");
                    System.out.println("   Tu animal avanza +1 extra cada turno... pero hay 25% de que el juez te cache.");
                    if (leerSiNo("¿Se la das a escondidas?")) {
                        dinero -= 15;
                        dopado = eleccion;
                    }
                }

                String descripcion = describirApuesta(tipo, eleccion, eleccion2, apuesta, cuota);
                String info = "CARRERA " + ronda + "/" + RONDAS + " | " + nombreClima(clima) + " | " + descripcion;
                cuentaRegresiva(info);
                correrCarrera(posiciones, pista, orden, clima, dopado, eleccion, info, true);
                jugadas++;
                if (posiciones[orden[0]] == posiciones[orden[1]]) {
                    fotoFinish(orden);
                    logros[7] = true;
                }
                victorias[orden[0]]++;
                podio(orden);

                boolean acierto;
                if (tipo == 1) {
                    acierto = orden[0] == eleccion;
                } else if (tipo == 2) {
                    acierto = orden[0] == eleccion || orden[1] == eleccion || orden[2] == eleccion;
                } else {
                    acierto = orden[0] == eleccion && orden[1] == eleccion2;
                }
                boolean cachado = false;
                if (dopado >= 0) {
                    cachado = revisionJuez(NOMBRES[dopado]);
                    if (cachado) acierto = false; else logros[4] = true;
                }

                if (acierto) {
                    int pago = apuesta * cuota / 10;
                    int ganancia = pago - apuesta;
                    ganadas++;
                    racha++;
                    pantallaResultado(true, descripcion, llegada(orden), pago, ganancia);
                    if (ganancia > 0 && leerSiNo("¿Te juegas tus " + plata(ganancia) + " de ganancia a DOBLE O NADA?")) {
                        if (dobleONada(ganancia)) {
                            pago += ganancia;
                            logros[6] = true;
                        } else {
                            pago -= ganancia;
                        }
                    }
                    dinero += pago;
                    if (pago > mayorPremio) mayorPremio = pago;
                    if (todoAdentro) logros[0] = true;
                    if (cuota >= 80) logros[1] = true;
                    if (tipo == 3) logros[2] = true;
                    if (racha >= 3) logros[3] = true;
                } else {
                    racha = 0;
                    if (cachado) {
                        pantallaResultado(false, descripcion, "Te cacharon con la zanahoria: apuesta anulada.", apuesta, 0);
                    } else {
                        pantallaResultado(false, descripcion, llegada(orden), apuesta, 0);
                    }
                }
                animarDinero(dineroAntes, dinero, deuda);
                presionaTecla();
            }
        }
        pantallaFinal(jugador, victorias, dinero, deuda, jugadas, ganadas, mayorPremio);
        pantallaLogros(logros);
    }

    static void generarPista(int[] pista, int clima) {
        int[] cantidades = {0, 3, 2, 2, 3};
        if (clima == LLUVIA) cantidades[LODO] = 5;
        for (int i = 0; i <= META; i++) {
            pista[i] = 0;
        }
        for (int tipo = TRAMPA; tipo <= CAJA; tipo++) {
            int puestas = 0;
            while (puestas < cantidades[tipo]) {
                int lugar = azar(META - 7) + 4;
                if (pista[lugar] == 0) {
                    pista[lugar] = tipo;
                    puestas++;
                }
            }
        }
    }

    static void correrCarrera(int[] posiciones, int[] pista, int[] orden, int clima, int dopado, int eleccion, String info, boolean visible) {
        int n = NUM_ANIMALES;
        int[] dormido = new int[n];
        String[] etiquetas = new String[n];
        String[] logs = {"", "", ""};
        for (int i = 0; i < n; i++) {
            posiciones[i] = 0;
            dormido[i] = 0;
            etiquetas[i] = "";
        }
        int turno = 0, liderAnterior = -1;
        boolean hayGanador = false;
        if (visible) {
            narrar(logs, "¡Y ARRANCAN! Se abren las puertas...");
            dibujarCarrera(posiciones, etiquetas, pista, logs, info, turno, eleccion);
            esperar(600);
        }
        while (!hayGanador) {
            turno++;
            jugarTurno(posiciones, dormido, etiquetas, pista, logs, clima, turno, dopado, eleccion, info, visible);
            for (int i = 0; i < n; i++) {
                if (posiciones[i] >= META) hayGanador = true;
            }
            if (visible) {
                int lider = 0;
                for (int i = 1; i < n; i++) {
                    if (posiciones[i] > posiciones[lider]) lider = i;
                }
                if (liderAnterior >= 0 && posiciones[liderAnterior] == posiciones[lider]) lider = liderAnterior;
                if (lider != liderAnterior && turno > 1 && !hayGanador) {
                    narrar(logs, "¡" + NOMBRES[lider].toUpperCase() + " SE PONE EN PRIMER LUGAR!");
                }
                liderAnterior = lider;
                dibujarCarrera(posiciones, etiquetas, pista, logs, info, turno, eleccion);
                esperar(230);
            }
        }
        ordenarPorPosicion(posiciones, orden, true);
        if (visible) {
            if (posiciones[orden[0]] == posiciones[orden[1]]) {
                narrar(logs, "¡¡LLEGADA CERRADÍSIMA!! Nadie sabe quién ganó...");
            } else {
                narrar(logs, "¡¡" + NOMBRES[orden[0]].toUpperCase() + " CRUZA LA META!!");
            }
            dibujarCarrera(posiciones, etiquetas, pista, logs, info, turno, eleccion);
            esperar(1500);
        }
    }

    static void jugarTurno(int[] posiciones, int[] dormido, String[] etiquetas, int[] pista, String[] logs,
                           int clima, int turno, int dopado, int eleccion, String info, boolean visible) {
        int n = NUM_ANIMALES;
        int[] avance = new int[n];
        int[] objetivo = new int[n];
        for (int i = 0; i < n; i++) {
            int pasos = 0;
            if (dormido[i] > 0) {
                dormido[i]--;
            } else {
                etiquetas[i] = "";
                int r = azar(100);
                switch (i) {
                    case TORTUGA:
                        pasos = azar(2) + 1;
                        if (r < 35) pasos++;
                        break;
                    case LIEBRE:
                        if (r < 12 || (clima == NOCHE && r < 25)) {
                            dormido[i] = 2;
                            evento(etiquetas, logs, i, "zZz", "La Liebre se echó una siestita... zZz");
                        } else {
                            pasos = azar(3) + 2;
                        }
                        break;
                    case CABALLO:
                        if (r < 6) {
                            evento(etiquetas, logs, i, "¡se paró!", "¡El Caballo se encabritó y no avanza!");
                        } else {
                            pasos = azar(2) + 2;
                        }
                        break;
                    case PERRO:
                        if (r < 12) {
                            dormido[i] = 1;
                            evento(etiquetas, logs, i, "¡un gato!", "¡El Perro vio un gato y se fue a perseguirlo!");
                        } else {
                            pasos = azar(3) + 1;
                            if (r < 24) {
                                pasos += 3;
                                evento(etiquetas, logs, i, "¡emoción!", "El Perro se emocionó y corre moviendo la cola");
                            }
                        }
                        break;
                    case GALLINA:
                        if (r < 10) {
                            pasos = 6;
                            evento(etiquetas, logs, i, "¡VUELA!", "¡¿LA GALLINA ESTÁ VOLANDO?! ¡Eso no se ve todos los días!");
                        } else {
                            pasos = azar(4);
                            if (pasos == 0) etiquetas[i] = "picotea";
                        }
                        break;
                    default:
                        pasos = 1;
                        if (r < 6) {
                            pasos = 9;
                            evento(etiquetas, logs, i, "¡NITRO!", "¡¡MODO NITRO!! El Caracol rompió la barrera del sonido");
                        }
                }
                if (pasos > 0 && clima == VIENTO && turno % 2 == 1) pasos++;
                if (pasos > 0 && i == dopado) pasos++;
            }
            avance[i] = pasos;
            objetivo[i] = posiciones[i] + pasos;
        }
        animarMovimiento(posiciones, objetivo, etiquetas, pista, logs, info, turno, eleccion, visible, 55);

        for (int i = 0; i < n; i++) {
            objetivo[i] = posiciones[i];
        }
        for (int i = 0; i < n; i++) {
            if (avance[i] > 0 && posiciones[i] >= 1 && posiciones[i] < META) {
                switch (pista[posiciones[i]]) {
                    case TRAMPA:
                        if (i == TORTUGA) {
                            evento(etiquetas, logs, i, "caparazón", "La Tortuga se metió a su caparazón: ¡la trampa ni le hizo cosquillas!");
                        } else {
                            objetivo[i] -= 3;
                            evento(etiquetas, logs, i, "TRAMPA -3", NOMBRES[i] + " cayó en una trampa (-3)");
                        }
                        break;
                    case TURBO:
                        objetivo[i] += 3;
                        evento(etiquetas, logs, i, "TURBO +3", NOMBRES[i] + " agarró TURBO (+3)");
                        break;
                    case LODO:
                        if (i == CARACOL) {
                            evento(etiquetas, logs, i, "se desliza", "El Caracol se desliza en el lodo como si nada");
                        } else {
                            dormido[i] = 1;
                            evento(etiquetas, logs, i, "atascado", NOMBRES[i] + " se atascó en el lodo y pierde un turno");
                        }
                        break;
                    case CAJA:
                        abrirCaja(i, posiciones, objetivo, etiquetas, logs);
                        break;
                }
            }
        }
        if (clima == TORMENTA && azar(100) < 10) {
            int victima = azar(n);
            if (posiciones[victima] < META) {
                objetivo[victima] -= 5;
                evento(etiquetas, logs, victima, "¡RAYO! -5", "¡KABOOM! Un rayo le cayó a " + NOMBRES[victima] + " (-5)");
            } else {
                narrar(logs, "¡KABOOM! Cayó un rayo en la pista... y no le dio a nadie");
            }
        }
        for (int i = 0; i < n; i++) {
            if (objetivo[i] < 0) objetivo[i] = 0;
        }
        animarMovimiento(posiciones, objetivo, etiquetas, pista, logs, info, turno, eleccion, visible, 70);
    }

    static void abrirCaja(int i, int[] posiciones, int[] objetivo, String[] etiquetas, String[] logs) {
        int lider = i;
        for (int k = 0; k < NUM_ANIMALES; k++) {
            if (posiciones[k] < META && objetivo[k] > objetivo[lider]) lider = k;
        }
        switch (azar(5)) {
            case 0:
                objetivo[i] += 5;
                evento(etiquetas, logs, i, "ZANAHORIA", NOMBRES[i] + " abrió la caja: ¡ZANAHORIA DORADA! (+5)");
                break;
            case 1:
                objetivo[i] -= 4;
                evento(etiquetas, logs, i, "PLÁTANO -4", NOMBRES[i] + " abrió la caja... cáscara de plátano (-4)");
                break;
            case 2:
                if (lider != i) {
                    int aux = objetivo[i];
                    objetivo[i] = objetivo[lider];
                    objetivo[lider] = aux;
                    etiquetas[lider] = "¡TELEPORT!";
                    evento(etiquetas, logs, i, "¡TELEPORT!", "¡TELETRANSPORTE! " + NOMBRES[i] + " cambió de lugar con " + NOMBRES[lider]);
                } else {
                    evento(etiquetas, logs, i, "nada", NOMBRES[i] + " sacó un teletransporte... pero ya iba primero");
                }
                break;
            case 3:
                objetivo[lider] -= 6;
                if (lider == i) {
                    evento(etiquetas, logs, lider, "¡RAYO! -6", NOMBRES[i] + " invocó un rayo contra el líder... ¡y el líder era él!");
                } else {
                    evento(etiquetas, logs, lider, "¡RAYO! -6", NOMBRES[i] + " le mandó un RAYO al líder: " + NOMBRES[lider] + " (-6)");
                }
                break;
            default:
                objetivo[i] += 8;
                evento(etiquetas, logs, i, "¡COHETE!", "¡" + NOMBRES[i] + " encontró un COHETE en la caja! (+8)");
        }
    }

    static void animarMovimiento(int[] posiciones, int[] objetivo, String[] etiquetas, int[] pista, String[] logs,
                                 String info, int turno, int eleccion, boolean visible, int retardo) {
        boolean falta = true;
        while (falta) {
            falta = false;
            for (int i = 0; i < NUM_ANIMALES; i++) {
                if (!visible) posiciones[i] = objetivo[i];
                if (posiciones[i] < objetivo[i]) {
                    posiciones[i]++;
                    falta = true;
                }
                if (posiciones[i] > objetivo[i]) {
                    posiciones[i]--;
                    falta = true;
                }
            }
            if (falta) {
                dibujarCarrera(posiciones, etiquetas, pista, logs, info, turno, eleccion);
                esperar(retardo);
            }
        }
    }

    static void evento(String[] etiquetas, String[] logs, int i, String etiqueta, String msg) {
        etiquetas[i] = etiqueta;
        narrar(logs, msg);
    }

    static void narrar(String[] logs, String msg) {
        logs[2] = logs[1];
        logs[1] = logs[0];
        logs[0] = msg;
    }

    static void ordenarPorPosicion(int[] posiciones, int[] orden, boolean desempateAlAzar) {
        int n = NUM_ANIMALES;
        int[] clave = new int[n];
        for (int i = 0; i < n; i++) {
            orden[i] = i;
            clave[i] = posiciones[i] * 1000 + (100 - i);
            if (desempateAlAzar) clave[i] = posiciones[i] * 1000 + azar(1000);
        }
        for (int i = 0; i < n - 1; i++) {
            for (int j = i + 1; j < n; j++) {
                if (clave[orden[j]] > clave[orden[i]]) {
                    int aux = orden[i];
                    orden[i] = orden[j];
                    orden[j] = aux;
                }
            }
        }
    }

    static void calcularCuotas(int[] pista, int clima, int[] cuotaGan, int[] cuotaPod, int[][] exacta) {
        int n = NUM_ANIMALES;
        int[] posiciones = new int[n];
        int[] orden = new int[n];
        int[] ganadas = new int[n];
        int[] podios = new int[n];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                exacta[i][j] = 0;
            }
        }
        System.out.println();
        System.out.print("   [");
        for (int s = 1; s <= SIMULACIONES; s++) {
            correrCarrera(posiciones, pista, orden, clima, -1, -1, "", false);
            ganadas[orden[0]]++;
            for (int j = 0; j < 3; j++) {
                podios[orden[j]]++;
            }
            exacta[orden[0]][orden[1]]++;
            if (s % (SIMULACIONES / 40 + 1) == 0) {
                System.out.print("#");
                System.out.flush();
            }
        }
        System.out.println("] ¡listo!");
        for (int i = 0; i < n; i++) {
            cuotaGan[i] = cuotaDesdeConteo(ganadas[i], SIMULACIONES, 9, 11, 500);
            cuotaPod[i] = cuotaDesdeConteo(podios[i], SIMULACIONES, 9, 11, 150);
        }
    }

    static int cuotaDesdeConteo(int conteo, int sims, int margen, int minimo, int maximo) {
        int cuota = maximo;
        if (conteo > 0) cuota = margen * sims / conteo;
        if (cuota < minimo) cuota = minimo;
        if (cuota > maximo) cuota = maximo;
        return cuota;
    }

    static String txtCuota(int c10) {
        return "x" + (c10 / 10) + "." + (c10 % 10);
    }

    static String llegada(int[] orden) {
        return "Llegada:  1º " + NOMBRES[orden[0]] + "   2º " + NOMBRES[orden[1]] + "   3º " + NOMBRES[orden[2]];
    }

    static String describirApuesta(int tipo, int eleccion, int eleccion2, int apuesta, int cuota) {
        String r;
        if (tipo == 1) {
            r = plata(apuesta) + " a " + NOMBRES[eleccion] + " GANADOR ";
        } else if (tipo == 2) {
            r = plata(apuesta) + " a " + NOMBRES[eleccion] + " PODIO ";
        } else {
            r = plata(apuesta) + " EXACTA " + NOMBRES[eleccion] + "-" + NOMBRES[eleccion2] + " ";
        }
        return r + txtCuota(cuota);
    }

    static String pistaTexto(int[] pista) {
        String r = "";
        for (int c = 1; c < META; c++) {
            r += "-x>~?".charAt(pista[c]);
        }
        return r;
    }

    static void dibujarCarrera(int[] posiciones, String[] etiquetas, int[] pista, String[] logs, String info, int turno, int eleccion) {
        int[] orden = new int[NUM_ANIMALES];
        String base = "-" + pistaTexto(pista) + "#";
        String pantalla = "";
        String num = "" + turno;
        if (turno < 10) num = "0" + num;
        pantalla += " " + rellenar(info, 66) + "TURNO " + num + "\n";
        pantalla += tira("=", 78) + "\n";
        String linea = tira(" ", 12);
        for (int c = 0; c <= META; c += 10) {
            linea += rellenar("" + c, 10);
        }
        pantalla += linea + "\n";
        for (int i = 0; i < NUM_ANIMALES; i++) {
            int lugar = Math.min(posiciones[i], META);
            linea = (i == eleccion) ? " ->" : "   ";
            linea += rellenar(NOMBRES[i], 8) + "|";
            for (int c = 0; c <= META; c++) {
                char celda = base.charAt(c);
                if (c < lugar && celda == '-') celda = '.';
                if (c == lugar) celda = SIMBOLOS[i].charAt(0);
                linea += celda;
            }
            pantalla += linea + " " + rellenarIzq("" + posiciones[i], 2) + "  " + etiquetas[i] + "\n";
        }
        pantalla += tira("=", 78) + "\n";
        ordenarPorPosicion(posiciones, orden, false);
        linea = " ";
        for (int i = 0; i < NUM_ANIMALES; i++) {
            String nombre = NOMBRES[orden[i]];
            if (orden[i] == eleccion) nombre = nombre.toUpperCase();
            linea += (i + 1) + "º " + rellenar(nombre, 10);
        }
        pantalla += linea + "\n";
        pantalla += tira("-", 78) + "\n";
        pantalla += "  >> " + logs[0] + "\n";
        pantalla += "     " + logs[1] + "\n";
        pantalla += "     " + logs[2] + "\n";
        limpiar();
        System.out.print(pantalla);
        System.out.flush();
    }

    static String nombreClima(int clima) {
        switch (clima) {
            case SOLEADO: return "SOLEADO";
            case LLUVIA: return "LLUVIA";
            case NOCHE: return "NOCHE";
            case TORMENTA: return "TORMENTA";
            default: return "VIENTO A FAVOR";
        }
    }

    static void tablaCuotas(int ronda, String jugador, int dinero, int deuda, int clima, int[] pista,
                            int[] cuotaGan, int[] cuotaPod, int[] victorias) {
        limpiar();
        System.out.println(tira("=", 78));
        System.out.println(rellenar("  CARRERA " + ronda + " DE " + RONDAS, 40) + rellenarIzq(jugador + ": " + plata(dinero), 36));
        if (deuda > 0) System.out.println(rellenarIzq("(le debes " + plata(deuda) + " a Don Tiburón)", 76));
        System.out.println(tira("=", 78));
        System.out.println("  CLIMA: " + nombreClima(clima));
        switch (clima) {
            case SOLEADO: System.out.println("  Día perfecto para correr. Nada raro... por ahora."); break;
            case LLUVIA: System.out.println("  Está lloviendo: la pista tiene mucho más lodo (~)."); break;
            case NOCHE: System.out.println("  Es de noche: la Liebre se duerme el doble de seguido."); break;
            case TORMENTA: System.out.println("  Tormenta eléctrica: en cualquier turno puede caerle un rayo a alguien (-5)."); break;
            default: System.out.println("  Viento a favor: todos avanzan +1 en los turnos impares.");
        }
        System.out.println();
        System.out.println("  PISTA:  SALIDA " + pistaTexto(pista) + " META");
        System.out.println("          x trampa (-3)   > turbo (+3)   ~ lodo (pierde turno)   ? sorpresa");
        System.out.println(tira("-", 78));
        System.out.println("   #   CORREDOR    GANADOR    PODIO    VICT.  ESPECIALIDAD");
        System.out.println(tira("-", 78));
        for (int i = 0; i < NUM_ANIMALES; i++) {
            System.out.println("   " + (i + 1) + "   " + rellenar(NOMBRES[i], 12) + rellenar(txtCuota(cuotaGan[i]), 11)
                    + rellenar(txtCuota(cuotaPod[i]), 9) + rellenar("" + victorias[i], 7) + ESPECIALIDADES[i]);
        }
        System.out.println(tira("-", 78));
    }

    static void pantallaTitulo() {
        String[] lineas = new String[11];
        for (int f = 0; f < 4; f++) {
            lineas[f] = centrar(filaGrande("CARRERA", f), 78);
            lineas[f + 5] = centrar(filaGrande("DE ANIMALES", f), 78);
        }
        lineas[4] = "";
        lineas[9] = "";
        lineas[10] = centrar("~ ~ ~   E D I C I Ó N   A P U E S T A S   L O C A S   ~ ~ ~", 78);
        for (int k = 3; k <= 78; k += 3) {
            limpiar();
            System.out.println();
            for (int f = 0; f < 9; f++) {
                System.out.println(lineas[f].substring(0, Math.min(k, lineas[f].length())));
            }
            esperar(25);
        }
        desfile(lineas, 24, "P R E S I O N A   E N T E R");
        sc.nextLine();
    }

    static void desfile(String[] lineas, int cuadros, String mensaje) {
        int[] pos = new int[NUM_ANIMALES];
        for (int f = 1; f <= cuadros + 7; f++) {
            limpiar();
            System.out.println();
            for (String l : lineas) {
                System.out.println(l);
            }
            System.out.println();
            for (int i = 0; i < NUM_ANIMALES; i++) {
                if (f <= cuadros) pos[i] += azar(4) + 1;
                if (pos[i] > 64) pos[i] = 64;
                System.out.println("      " + tira(".", pos[i]) + SIMBOLOS[i]);
            }
            System.out.println();
            if (f > cuadros && (f % 2 == 0 || f == cuadros + 7)) {
                System.out.println(centrar(mensaje, 78));
                esperar(250);
            } else {
                System.out.println();
                esperar(70);
            }
        }
    }

    static String pedirNombre() {
        limpiar();
        System.out.println();
        System.out.println();
        escribirLento("   Bienvenido al Gran Hipódromo Animal.", 20);
        escribirLento("   Aquí corren tortugas, liebres, gallinas... y un caracol con turbo.", 20);
        System.out.println();
        System.out.print("   ¿Cómo te llamas, apostador? > ");
        String nombre = sc.nextLine().trim();
        if (nombre.length() == 0) nombre = "Apostador Misterioso";
        if (nombre.length() > 16) nombre = nombre.substring(0, 16);
        return nombre;
    }

    static int menuPrincipal(String jugador) {
        limpiar();
        System.out.println();
        textoGrande("CARRERA");
        System.out.println(centrar("D E    A N I M A L E S", 78));
        System.out.println();
        System.out.println("              +------------------------------------------------+");
        System.out.println("              | " + rellenar("¡Qué onda, " + jugador + "!", 46) + " |");
        System.out.println("              |                                                |");
        System.out.println("              |    [1]  Jugar torneo                           |");
        System.out.println("              |    [2]  Cómo se juega                          |");
        System.out.println("              |    [3]  Conoce a los corredores                |");
        System.out.println("              |    [4]  Salir                                  |");
        System.out.println("              +------------------------------------------------+");
        System.out.println();
        return leerEntero("Elige una opción", 1, 4);
    }

    static void pantallaInstrucciones() {
        limpiar();
        textoGrande("COMO SE JUEGA");
        System.out.println(tira("-", 78));
        System.out.println("  1. Son " + RONDAS + " carreras y empiezas con " + plata(DINERO_INICIAL) + ". Gana el que llegue a la META (#).");
        System.out.println("  2. Antes de cada carrera ves el clima, la pista y las CUOTAS. Las cuotas");
        System.out.println("     salen de simular " + SIMULACIONES + " carreras: entre menos probable, más paga.");
        System.out.println("     Ejemplo: apuestas $10 a cuota x3.5 y si le atinas te regresan $35.");
        System.out.println("  3. Tipos de apuesta:");
        System.out.println("       [1] Ganador -> tu animal llega en 1º lugar.");
        System.out.println("       [2] Podio   -> tu animal queda entre los 3 primeros (paga menos).");
        System.out.println("       [3] Exacta  -> adivinas el 1º y el 2º en orden (¡paga muchísimo!).");
        System.out.println("  4. Casillas:  x trampa (-3)   > turbo (+3)   ~ lodo (pierdes un turno)");
        System.out.println("                ? caja sorpresa: zanahoria, plátano, teletransporte,");
        System.out.println("                  rayo al líder o... un cohete.");
        System.out.println("  5. Si ganas, puedes jugarte la ganancia a DOBLE O NADA con un volado.");
        System.out.println("  6. Si te quedas en $0, Don Tiburón te presta $60... y le debes $120.");
        System.out.println("  7. Si llegan empatados, se decide por FOTO FINISH.");
        System.out.println("  8. Hay 8 logros secretos. ¿Los sacarás todos?");
        presionaTecla();
    }

    static void pantallaCorredores() {
        int[] vel = {2, 5, 4, 3, 2, 1};
        int[] cons = {5, 1, 4, 2, 1, 3};
        int[] loc = {1, 3, 1, 4, 5, 5};
        String[] desc1 = {
            "Avanza 1 a 3 casillas por turno y jamás se duerme.",
            "La más rápida: avanza 2 a 4 casillas por turno.",
            "Avanza 2 o 3 casillas, muy parejo. El favorito de siempre.",
            "Avanza 1 a 3 casillas. Si se emociona, hasta 6.",
            "Avanza 0 a 3 casillas. Nadie sabe qué va a hacer.",
            "Avanza 1 casilla por turno... y el lodo no lo frena."
        };
        String[] desc2 = {
            "Las trampas no le hacen nada: se mete a su caparazón.",
            "Pero a veces se echa una siesta de 3 turnos (de noche, más).",
            "De vez en cuando se encabrita y no se mueve.",
            "Si ve un gato se va a perseguirlo y pierde 2 turnos.",
            "A veces SALE VOLANDO 6 casillas. Sí, las gallinas vuelan.",
            "Pero a veces activa el MODO NITRO y avanza 9 de golpe."
        };
        for (int i = 0; i < NUM_ANIMALES; i++) {
            for (int sangria = 40; sangria >= 8; sangria -= 8) {
                limpiar();
                textoGrande("CORREDORES");
                System.out.println();
                System.out.println("   " + (i + 1) + " de " + NUM_ANIMALES + ":  " + NOMBRES[i].toUpperCase());
                for (String renglon : DIBUJOS[i]) {
                    System.out.println(tira(" ", sangria) + renglon);
                }
                esperar(45);
            }
            System.out.println();
            System.out.println("   Velocidad   " + barra(vel[i]));
            System.out.println("   Constancia  " + barra(cons[i]));
            System.out.println("   Locura      " + barra(loc[i]));
            System.out.println();
            System.out.println("   " + desc1[i]);
            System.out.println("   " + desc2[i]);
            presionaTecla();
        }
    }

    static String barra(int valor) {
        return "[" + tira("#", valor * 2) + tira("-", 10 - valor * 2) + "]";
    }

    static void cuentaRegresiva(String info) {
        for (int k = 3; k >= 0; k--) {
            limpiar();
            System.out.println(" " + info);
            System.out.println(tira("=", 78));
            System.out.println();
            String tapas = tira(" ", 25);
            String focos = tira(" ", 25);
            for (int i = 1; i <= 3; i++) {
                tapas += "+-----+   ";
                if (k > 0 && i <= 4 - k) focos += "|#####|   "; else focos += "|     |   ";
            }
            System.out.println(tapas);
            System.out.println(focos);
            System.out.println(focos);
            System.out.println(tapas);
            System.out.println();
            System.out.println();
            if (k > 0) {
                textoGrande("" + k);
                esperar(650);
            } else {
                textoGrande("YA!");
                esperar(500);
            }
        }
    }

    static void fotoFinish(int[] orden) {
        for (int k = 1; k <= 3; k++) {
            limpiar();
            for (int j = 1; j <= 12; j++) {
                System.out.println(tira(" *  ", 19));
            }
            esperar(90);
            limpiar();
            esperar(140);
        }
        System.out.println();
        textoGrande("FOTO FINISH");
        System.out.println();
        escribirLento("   ¡" + NOMBRES[orden[0]] + " y " + NOMBRES[orden[1]] + " llegaron JUNTITOS!", 25);
        System.out.print("   Los jueces revisan la foto");
        for (int k = 1; k <= 6; k++) {
            esperar(300);
            System.out.print(" .");
        }
        System.out.println();
        System.out.println();
        String pre = "        |   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~";
        String borde = "        |" + tira(" ", 36) + "|" + tira(" ", 13) + "|";
        System.out.println("        +------------------ FOTO OFICIAL -------------------+");
        System.out.println(borde);
        System.out.println(pre + " [" + SIMBOLOS[orden[0]] + "]>             |");
        System.out.println(pre + "[" + SIMBOLOS[orden[1]] + "]>|             |");
        System.out.println(borde);
        System.out.println("        +---------------------------------------------------+");
        System.out.println();
        escribirLento("   La foto no miente: ¡" + NOMBRES[orden[0]] + " gana por una nariz!", 25);
        presionaTecla();
    }

    static void podio(int[] orden) {
        String n1 = rellenar(centrar("1º " + NOMBRES[orden[0]].toUpperCase(), 15), 15);
        String n2 = rellenar(centrar("2º " + NOMBRES[orden[1]], 15), 15);
        String n3 = rellenar(centrar("3º " + NOMBRES[orden[2]], 15), 15);
        String caja = "+-------------+";
        String vacia = "|             |";
        String sp = tira(" ", 11);
        for (int f = 1; f <= 14; f++) {
            limpiar();
            System.out.println();
            for (int j = 1; j <= 5; j++) {
                String confeti = "";
                for (int k = 0; k < 78; k++) {
                    if (azar(100) < 12) confeti += "*+o.~^".charAt(k % 6); else confeti += " ";
                }
                System.out.println(confeti);
            }
            System.out.println(sp + tira(" ", 16) + n1);
            System.out.println(sp + tira(" ", 16) + caja);
            System.out.println(sp + n2 + " " + vacia + " " + n3);
            System.out.println(sp + caja + " |      1      | " + caja);
            System.out.println(sp + "|      2      | " + vacia + " |      3      |");
            System.out.println(sp + vacia + " " + vacia + " " + vacia);
            System.out.println("      =====+=============+=+=============+=+=============+=====");
            System.out.println();
            if (f > 5) System.out.println(centrar("¡¡ G A N Ó   " + NOMBRES[orden[0]].toUpperCase() + " !!", 78));
            esperar(120);
        }
        presionaTecla();
    }

    static boolean revisionJuez(String nombreAnimal) {
        limpiar();
        System.out.println();
        System.out.println();
        escribirLento("   El juez se acerca a " + nombreAnimal + " con cara de sospecha...", 25);
        System.out.print("   Revisando el antidoping");
        for (int k = 1; k <= 6; k++) {
            esperar(300);
            System.out.print(" .");
        }
        System.out.println();
        System.out.println();
        boolean cachado = azar(100) < 25;
        if (cachado) {
            textoGrande("TE CACHARON!");
            System.out.println();
            System.out.println("   Encontraron restos de ZANAHORIA ILEGAL. Tu apuesta queda anulada.");
        } else {
            escribirLento("   ...todo en orden. El juez no vio nada. (guiño, guiño)", 25);
        }
        presionaTecla();
        return cachado;
    }

    static void pantallaResultado(boolean gano, String descripcion, String detalle, int monto, int ganancia) {
        limpiar();
        System.out.println();
        textoGrande(gano ? "GANASTE!" : "PERDISTE");
        System.out.println();
        System.out.println(centrar("Tu apuesta: " + descripcion, 78));
        System.out.println(centrar(detalle, 78));
        System.out.println();
        if (gano) {
            System.out.println(centrar("¡Le atinaste, eres un crack!", 78));
            System.out.println(centrar("Cobras " + plata(monto) + "  (ganancia de " + plata(ganancia) + ")", 78));
        } else {
            System.out.println(centrar("Pierdes " + plata(monto) + ". Perdiste bot, suerte la próxima.", 78));
        }
        System.out.println();
    }

    static boolean dobleONada(int ganancia) {
        limpiar();
        textoGrande("DOBLE O NADA");
        System.out.println();
        System.out.println("   Te juegas tus " + plata(ganancia) + " de ganancia a un volado.");
        System.out.println("   Si le atinas se DUPLICAN. Si no, solo recuperas lo que apostaste.");
        System.out.println();
        int eleccion = leerEntero("[1] Cara   [2] Cruz", 1, 2);
        int resultado = azar(2) + 1;
        int pausa = 40;
        int[] giro = {1, 2, 3, 2};
        for (int f = 1; f <= 17; f++) {
            limpiar();
            textoGrande("DOBLE O NADA");
            System.out.println();
            if (f < 17) {
                System.out.println(centrar("La moneda gira...", 78));
                System.out.println();
                dibujarMoneda(giro[f % 4]);
            } else {
                System.out.println(centrar(resultado == 1 ? "¡Salió CARA!" : "¡Salió CRUZ!", 78));
                System.out.println();
                dibujarMoneda(resultado * 3 - 2);
            }
            esperar(pausa);
            pausa += 12;
        }
        System.out.println();
        boolean gano = resultado == eleccion;
        if (gano) {
            System.out.println(centrar("¡LE ATINASTE! Tu ganancia se duplica.", 78));
        } else {
            System.out.println(centrar("Fallaste... te quedas solo con lo que apostaste.", 78));
        }
        presionaTecla();
        return gano;
    }

    static void dibujarMoneda(int cara) {
        for (String renglon : MONEDA) {
            System.out.println(tira(" ", 31) + renglon.substring((cara - 1) * 15, cara * 15));
        }
    }

    static void animarDinero(int antes, int despues, int deuda) {
        for (int k = 0; k <= 16; k++) {
            int valor = antes + (despues - antes) * k / 16;
            limpiar();
            System.out.println();
            System.out.println();
            System.out.println(centrar("+--------------------------------+", 78));
            System.out.println(centrar("|          TU CARTERA            |", 78));
            System.out.println(centrar("+--------------------------------+", 78));
            System.out.println();
            textoGrande("$" + valor);
            System.out.println();
            esperar(45);
        }
        if (despues >= antes) {
            System.out.println(centrar("+" + plata(despues - antes), 78));
        } else {
            System.out.println(centrar("-" + plata(antes - despues), 78));
        }
        if (deuda > 0) System.out.println(centrar("(Don Tiburón te recuerda que le debes " + plata(deuda) + ")", 78));
    }

    static boolean ofrecerPrestamo(String jugador) {
        for (int p = 60; p >= 20; p -= 5) {
            limpiar();
            System.out.println();
            System.out.println();
            System.out.println(tira(" ", p) + "   |\\");
            System.out.println(tira(" ", p) + "   | \\");
            System.out.println(tira(" ", p) + "   |  \\");
            System.out.println(tira("~", p) + "~~~|___\\" + tira("~", 67 - p));
            esperar(120);
        }
        System.out.println();
        textoGrande("DON TIBURON");
        System.out.println();
        escribirLento("   Vaya, vaya... " + jugador + ", te quedaste sin un peso.", 25);
        escribirLento("   Te presto $60 ahorita mismo... y al final me regresas $120.", 25);
        escribirLento("   No te preocupes, soy muy comprensivo. Casi siempre.", 25);
        System.out.println();
        boolean acepta = leerSiNo("¿Aceptas el trato?");
        if (acepta) {
            escribirLento("   Excelente. Aquí tienes. Nos vemos al final del torneo...", 25);
        } else {
            escribirLento("   Tú te lo pierdes. Sin dinero no hay apuestas.", 25);
        }
        esperar(800);
        return acepta;
    }

    static void pantallaFinal(String jugador, int[] victorias, int dinero, int deuda, int jugadas, int ganadas, int mayorPremio) {
        int total = dinero - deuda;
        limpiar();
        textoGrande("FIN DEL TORNEO");
        System.out.println(tira("=", 78));
        System.out.println("   Apostador: " + jugador);
        System.out.println("   Carreras: " + jugadas + "     Apuestas ganadas: " + ganadas + "     Mayor cobro: " + plata(mayorPremio));
        System.out.println("   Dinero en la bolsa: " + plata(dinero));
        if (deuda > 0) System.out.println("   Don Tiburón cobra su préstamo: -" + plata(deuda));
        System.out.println("   RESULTADO FINAL: " + plata(total));
        System.out.println();
        String rango = "LEYENDA DEL HIPÓDROMO. Los animales te hacen reverencia.";
        if (total < DINERO_INICIAL * 4) rango = "TIBURÓN DE LAS APUESTAS. ¡Eres un crack!";
        if (total < DINERO_INICIAL * 2) rango = "Apostador con suerte. No está nada mal.";
        if (total < DINERO_INICIAL) rango = "Apostador novato. Perdiste " + plata(DINERO_INICIAL - total) + ".";
        if (total <= 0) rango = "BANCARROTA TOTAL. Perdiste bot, suerte la próxima.";
        System.out.print("   Tu rango: ");
        escribirLento(rango, 30);
        System.out.println();
        System.out.println("   VICTORIAS EN EL TORNEO");
        for (int i = 0; i < NUM_ANIMALES; i++) {
            System.out.println("     " + rellenar(NOMBRES[i], 9) + rellenar(tira("#", victorias[i] * 4), 22) + victorias[i]);
        }
        presionaTecla();
    }

    static void pantallaLogros(boolean[] logros) {
        String[] titulos = {"Todo o nada", "Batacazo", "Francotirador", "En racha", "Pillo",
                            "Cliente de Don Tiburón", "Doble o nada", "Foto finish"};
        String[] descripciones = {
            "Apostaste TODO tu dinero y ganaste", "Ganaste con una cuota de x8.0 o más",
            "Le atinaste a una apuesta Exacta", "Ganaste 3 apuestas seguidas",
            "Usaste la zanahoria ilegal y no te cacharon", "Pediste un préstamo",
            "Ganaste un volado de doble o nada", "Viste una llegada por foto finish"
        };
        limpiar();
        textoGrande("LOGROS");
        System.out.println(tira("-", 78));
        int total = 0;
        for (int i = 0; i < 8; i++) {
            esperar(250);
            if (logros[i]) {
                total++;
                System.out.println("   [X] " + rellenar(titulos[i], 24) + descripciones[i]);
            } else {
                System.out.println("   [ ] " + rellenar("? ? ?", 24) + "(sigue intentando)");
            }
        }
        System.out.println(tira("-", 78));
        System.out.println("   Desbloqueaste " + total + " de 8 logros.");
        if (total == 8) escribirLento("   ¡¡LOS SACASTE TODOS!! Eres oficialmente una leyenda.", 30);
        presionaTecla();
    }

    static void pantallaDespedida(String jugador) {
        String[] lineas = new String[6];
        for (int f = 0; f < 4; f++) {
            lineas[f] = centrar(filaGrande("GRACIAS!", f), 78);
        }
        lineas[4] = "";
        lineas[5] = centrar("Gracias por jugar, " + jugador + ". ¡Vuelve pronto al hipódromo!", 78);
        desfile(lineas, 22, "~ ~ ~   F I N   ~ ~ ~");
    }

    static String tira(String c, int k) {
        String r = "";
        for (int i = 0; i < k; i++) {
            r += c;
        }
        return r;
    }

    static String rellenar(String s, int ancho) {
        return (s + tira(" ", ancho)).substring(0, ancho);
    }

    static String rellenarIzq(String s, int ancho) {
        if (s.length() < ancho) return tira(" ", ancho - s.length()) + s;
        return s;
    }

    static String centrar(String s, int ancho) {
        if (s.length() < ancho) return tira(" ", (ancho - s.length()) / 2) + s;
        return s;
    }

    static String plata(int cantidad) {
        if (cantidad < 0) return "-$" + (-cantidad);
        return "$" + cantidad;
    }

    static int azar(int n) {
        return rnd.nextInt(n);
    }

    static void esperar(int ms) {
        System.out.flush();
        try {
            Thread.sleep(ms);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    static void limpiar() {
        if (LIMPIAR_CON_ANSI) {
            System.out.print("\033[H\033[2J");
        } else {
            System.out.print(tira("\n", 50));
        }
        System.out.flush();
    }

    static void escribirLento(String msg, int ms) {
        for (int i = 0; i < msg.length(); i++) {
            System.out.print(msg.charAt(i));
            if (msg.charAt(i) != ' ') esperar(ms);
        }
        System.out.println();
    }

    static void presionaTecla() {
        System.out.println();
        System.out.print(centrar(">> Presiona ENTER para continuar <<", 78));
        sc.nextLine();
    }

    static int leerEntero(String mensaje, int minimo, int maximo) {
        int valor = minimo;
        boolean valido = false;
        while (!valido) {
            System.out.print("   " + mensaje + " (" + minimo + "-" + maximo + "): ");
            String entrada = sc.nextLine().trim();
            valido = entrada.length() > 0 && entrada.length() <= 6;
            for (int i = 0; i < entrada.length(); i++) {
                char ch = entrada.charAt(i);
                if (ch < '0' || ch > '9') valido = false;
            }
            if (valido) {
                valor = Integer.parseInt(entrada);
                if (valor < minimo || valor > maximo) valido = false;
            }
            if (!valido) System.out.println("   Eso no se vale. Tiene que ser un número entre " + minimo + " y " + maximo + ".");
        }
        return valor;
    }

    static boolean leerSiNo(String mensaje) {
        while (true) {
            System.out.print("   " + mensaje + " (S/N): ");
            String entrada = sc.nextLine().trim().toUpperCase();
            if (entrada.equals("S") || entrada.equals("SI") || entrada.equals("SÍ")) return true;
            if (entrada.equals("N") || entrada.equals("NO")) return false;
            System.out.println("   Contesta con S o N.");
        }
    }

    static String filaGrande(String msg, int fila) {
        String r = "";
        msg = msg.toUpperCase();
        for (int i = 0; i < msg.length(); i++) {
            int k = 0, ini = 0;
            while (k < LETRAS.length() - 1 && LETRAS.charAt(k) != msg.charAt(i)) {
                ini += ANCHOS.charAt(k) - '0';
                k++;
            }
            r += FUENTE[fila].substring(ini, ini + (ANCHOS.charAt(k) - '0'));
        }
        return r;
    }

    static void textoGrande(String msg) {
        for (int f = 0; f < 4; f++) {
            System.out.println(centrar(filaGrande(msg, f), 78));
        }
    }
}
