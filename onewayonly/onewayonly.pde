int estadoJuego = 0; 
Jefe jefeFinal;
Jugador jugador;
CargadorCSV cargador;
Armamento equipamiento;
ArrayList<TortugaPerseguidora> enemigos;
ArrayList<SistemaParticulas> efectosParticulas;
ArrayList<BolaFuego> bolasFuego;

int nivelActual = 1;
int teclaA = 0;
int teclaD = 0;
int teclaSalto = 0;

void setup() {
  size(1200, 600);
  iniciarJuego();
}

void iniciarJuego() {
  jefeFinal = new Jefe(0, 0);
  bolasFuego = new ArrayList<BolaFuego>();
  efectosParticulas = new ArrayList<SistemaParticulas>();
  jugador = new Jugador(100, 100);
  cargador = new CargadorCSV();
  equipamiento = new Armamento();
  enemigos = new ArrayList<TortugaPerseguidora>();
  cargador.cargarDesdeCSV("mapa1.csv", jugador, enemigos, jefeFinal);
}

void draw() {
  if (estadoJuego == 0) {
    dibujarMenu();
  } else if (estadoJuego == 1) {
    actualizarYDibujarJuego();
  } else if (estadoJuego == 2) {
    dibujarGameOver();
  } else if (estadoJuego == 3) {
  dibujarVictoria();
 }
}

void dibujarMenu() {
  background(135, 206, 235);
  
  noStroke();
  fill(255, 220, 50);
  ellipse(width / 2, 200, 150, 150);
  
  fill(100, 120, 150);
  triangle(100, 600, 450, 150, 800, 600);
  triangle(600, 600, 950, 250, 1300, 600);
  triangle(-100, 600, 200, 300, 500, 600);
  
  fill(34, 139, 34);
  ellipse(300, 650, 900, 400);
  ellipse(1000, 600, 800, 300);

  filter(BLUR, 6); 

  fill(0, 0, 0, 120);
  rect(0, 0, width, height);

  textAlign(CENTER, CENTER);
  fill(255, 215, 0); 
  textSize(70);
  text("ONE WAY ONLY", width / 2, 140);
  
  fill(255);
  textSize(16);
  text("V 1.0", width / 2 + 250, 170);

  dibujarBotonesMenu();
}

void dibujarBotonesMenu() {
  int btnX = width / 2 - 180;
  int btnAncho = 360;
  int btnAlto = 55;

  int btnY_Jugar = 280;
  if (mouseX > btnX && mouseX < btnX + btnAncho && mouseY > btnY_Jugar && mouseY < btnY_Jugar + btnAlto) {
    fill(200, 50, 50);
  } else {
    fill(150, 30, 30);
  }
  rect(btnX, btnY_Jugar, btnAncho, btnAlto, 10);
  fill(255); textSize(24);
  text("JUGAR", width / 2, btnY_Jugar + 25);

  int btnY_Sonido = 360;
  fill(50, 50, 50, 200);
  rect(btnX, btnY_Sonido, btnAncho, btnAlto, 10);
  fill(130); textSize(20);
  text("Opciones de Sonido (Proximamente)", width / 2, btnY_Sonido + 25);

  int btnY_Teclas = 440;
  fill(50, 50, 50, 200);
  rect(btnX, btnY_Teclas, btnAncho, btnAlto, 10);
  fill(130); textSize(20);
  text("Configurar Teclas (Proximamente)", width / 2, btnY_Teclas + 25);
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
    e.actualizar(jugador.pos.x, jugador, equipamiento, cargador.plataformas, enemigos);      
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
  jefeFinal.actualizar(jugador, cargador.plataformas);
  jefeFinal.atacarSiEstaCerca(jugador, equipamiento);
  jefeFinal.mostrar();
  if (jefeFinal.vida <= 0) {
    estadoJuego = 3; 
  }
  
  jugador.mostrar();
  equipamiento.mostrar(jugador);
  
  for (int i = bolasFuego.size() - 1; i >= 0; i--) {
    BolaFuego bf = bolasFuego.get(i);
    bf.actualizar(cargador.plataformas, enemigos, jefeFinal);
    bf.mostrar();
    if (!bf.activa) bolasFuego.remove(i);
  }

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
  fill(0, 0, 0, 200); 
  noStroke();
  rect(0, 0, width, 40);

  textSize(13);
  textAlign(CENTER, CENTER);

  fill(255);
  text("VIDA: " + (int)jugador.vida + " HP", 60, 20);

  if (equipamiento.durabilidadEspada > 0) fill(255); else fill(255, 50, 50);
  text("ESPADA: " + (int)equipamiento.durabilidadEspada + "%", 170, 20);

  if (equipamiento.durabilidadEscudo > 0) fill(255); else fill(255, 50, 50);
  text("ESCUDO: " + (int)equipamiento.durabilidadEscudo + "%", 290, 20);

  String estadoFuego = "Bloqueado";
  fill(150);
  if (equipamiento.poderFuegoActivado) {
    int tiempoRestante = 5000 - (millis() - ultimoDisparoFuego);
    if (tiempoRestante <= 0) {
      estadoFuego = "LISTO (L)";
      fill(255, 255, 0);
    } else {
      estadoFuego = "Carga: " + (tiempoRestante / 1000) + "s";
    }
  }
  text("FUEGO: " + estadoFuego, 420, 20);
  
  fill(255);
  text("ZONA: " + nivelActual, 530, 20);

  fill(200);
  text("A/D: Mover | W: Saltar | J: Atacar | K: Bloquear", 860, 20);

  textAlign(LEFT, BASELINE);
}

void dibujarGameOver() {
  background(20, 0, 0);
  textAlign(CENTER, CENTER);
  fill(255, 50, 50);
  textSize(36);
  text("GAME OVER", width / 2, 250);
  fill(255);
  textSize(18);
  text("Presiona ENTER para Reiniciar", width / 2, 340);
  textAlign(LEFT, BASELINE);
}
void dibujarVictoria() {
  background(50, 150, 50);
  textAlign(CENTER, CENTER);
  fill(255, 215, 0); textSize(40);
  text("¡VICTORIA!", width / 2, 250);
  fill(255); textSize(18);
  text("Derrotaste al jefe. Presiona ENTER para jugar de nuevo.", width/2, 340);
}
