int estadoJuego = 0; 

Jugador jugador;
CargadorCSV cargador;
Armamento equipamiento;
ArrayList<TortugaPerseguidora> enemigos;
ArrayList<SistemaParticulas> efectosParticulas;

int nivelActual = 1;
int teclaA = 0;
int teclaD = 0;
int teclaSalto = 0;

void setup() {
  size(1200, 600);
  iniciarJuego();
}

void iniciarJuego() {
  efectosParticulas = new ArrayList<SistemaParticulas>();
  jugador = new Jugador(100, 100);
  cargador = new CargadorCSV();
  equipamiento = new Armamento();
  enemigos = new ArrayList<TortugaPerseguidora>();
  cargador.cargarDesdeCSV("mapa1.csv", jugador, enemigos);
}

void draw() {
  if (estadoJuego == 0) {
    dibujarMenu();
  } else if (estadoJuego == 1) {
    actualizarYDibujarJuego();
  } else if (estadoJuego == 2) {
    dibujarGameOver();
  }
}

void dibujarMenu() {
  background(30, 30, 45);
  textAlign(CENTER, CENTER);
  fill(255, 215, 0);
  textSize(36);
  text("ONE WAY ONLY", width / 2, 180);
  fill(255);
  textSize(18);
  text("Presioná ENTER para Comenzar", width / 2, 300);
  fill(180);
  textSize(14);
  text("A/D: Moverse | W/Espacio: Saltar | J: Espada | K: Escudo", width / 2, 420);
  textAlign(LEFT, BASELINE);
}

void actualizarYDibujarJuego() {
  float tramo = cargador.anchoTotalMapa / 4.0;

  if (jugador.pos.x < tramo) {
    nivelActual = 1; 
    background(170, 215, 255);
  } else if (jugador.pos.x >= tramo && jugador.pos.x < tramo * 2) {
    nivelActual = 2; 
    background(100, 160, 110);
  } else if (jugador.pos.x >= tramo * 2 && jugador.pos.x < tramo * 3) {
    nivelActual = 3; 
    background(140, 160, 180);
  } else {
    nivelActual = 4; 
    background(40, 30, 50);
  }

  if (teclaA == 1 && teclaD == 0) jugador.moverIzquierda();
  else if (teclaD == 1 && teclaA == 0) jugador.moverDerecha();
  else jugador.detener();

  if (teclaSalto == 1) jugador.saltar();

  jugador.actualizarFisicas(cargador.plataformas);

  for (int i = enemigos.size() - 1; i >= 0; i--) {
    TortugaPerseguidora e = enemigos.get(i);
    e.actualizar(jugador.pos.x, jugador, equipamiento, cargador.plataformas);
    if (e.activo == 0) enemigos.remove(i);
  }

  equipamiento.actualizar(jugador.pos.x, jugador.pos.y, jugador.mirandoIzquierda);

  if (jugador.vida <= 0) estadoJuego = 2;

  float camaraX = width / 3 - jugador.pos.x;

  pushMatrix();
  translate(camaraX, 0);

  cargador.mostrar(nivelActual);

  for (int i = 0; i < enemigos.size(); i++) {
    enemigos.get(i).mostrar();
  }

  jugador.mostrar();
  equipamiento.mostrar(jugador);

  for (int i = efectosParticulas.size() - 1; i >= 0; i--) {
    SistemaParticulas sp = efectosParticulas.get(i);
    sp.actualizarYMostrar();
    if (sp.terminado()) {
      efectosParticulas.remove(i);
    }
  }

  popMatrix();

  dibujarHUD();
}

void dibujarHUD() {
  fill(0, 0, 0, 150);
  noStroke();
  rect(20, 20, 230, 120);

  fill(255);
  textSize(13);
  text("Vida: " + (int)jugador.vida + " HP", 20, 30);
  text("Zona: " + nivelActual, 140, 30);
  
  text("CONTROLES:", 20, 55);
  fill(255);
  text("• A / D : Mover Izq / Der", 20, 72);
  text("• W / ESPACIO : Saltar", 20, 87);
  text("• J : Atacar con Espada", 20, 102);
  text("• K : Defender con Escudo", 20, 117);
}

void dibujarGameOver() {
  background(20, 0, 0);
  textAlign(CENTER, CENTER);
  fill(255, 50, 50);
  textSize(36);
  text("GAME OVER", width / 2, 250);
  fill(255);
  textSize(18);
  text("Presioná ENTER para Reiniciar", width / 2, 340);
  textAlign(LEFT, BASELINE);
}
