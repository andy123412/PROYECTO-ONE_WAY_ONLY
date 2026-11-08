import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

int estadoJuego = 0;
PImage capturaPausa;
float volumenGlobal = 0.8;
boolean arrastrandoVolumen = false;
int estadoAnteriorOpciones = 0;
int[] slotsPartidas = {0, 0, 0};
int[] slotsNivel = {1, 1, 1};
int[] slotsPuntaje = {0, 0, 0};
float[] slotsVida = {100, 100, 100};
float[] slotsEspada = {100, 100, 100};
float[] slotsEscudo = {100, 100, 100};
int slotActivo = -1;
GestorAudio audio;
Jefe jefeFinal;
Jugador jugador;
CargadorCSV cargador;
Armamento equipamiento;
ArrayList<TortugaPerseguidora> enemigos;
ArrayList<SistemaParticulas> efectosParticulas;
ArrayList<BolaFuego> bolasFuego;
int[] inventario = {0, 0};
int slotSeleccionado = 0;
ArrayList<String> rankingTop10 = new ArrayList<String>();
char keyIzq = 'a', keyDer = 'd', keySalto = 'w', keyAtaque = 'j', keyEscudo = 'k';
int nivelActual = 1;
int teclaA = 0;
int teclaD = 0;
int teclaSalto = 0;
int puntaje = 0;
ArrayList<PlantaCarnivora> plantas;

ConexionBD baseDatos;
boolean partidaGuardada = false;

void setup() {
  size(1200, 600);
  PImage icono = loadImage("logo.png");
  surface.setIcon(icono);
  surface.setTitle("ONE WAY ONLY");
  audio = new GestorAudio(this);
  iniciarJuego();
}

void iniciarJuego() {
  jefeFinal = new Jefe(0, 0);
  bolasFuego = new ArrayList<BolaFuego>();
  plantas = new ArrayList<PlantaCarnivora>();
  efectosParticulas = new ArrayList<SistemaParticulas>();
  jugador = new Jugador(100, 100);
  cargador = new CargadorCSV();
  equipamiento = new Armamento();
  enemigos = new ArrayList<TortugaPerseguidora>();
  
  cargador.cargarDesdeCSV("mapa1.csv", jugador, enemigos, jefeFinal);
  
  puntaje = 0;
  nivelActual = 1;
  inventario[0] = 0;
  inventario[1] = 0;
  slotSeleccionado = 0;
  
  teclaA = 0; teclaD = 0; teclaSalto = 0; 
  
  baseDatos = new ConexionBD();
  baseDatos.conectar();
  partidaGuardada = false;
  
  volumenGlobal = 0.5;
  audio.actualizarVolumen(volumenGlobal);
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
  else if (estadoJuego == 4) {
  dibujarMenuOpciones();
  }
    else if (estadoJuego == 5) {
    dibujarMenuPausa();
  }
  else if (estadoJuego == 6) {
    dibujarMenuPartidas();
  }
}

void dibujarMenu() {
  float camaraFalsaMenu = -millis() * 0.15; 
  
  dibujarEscenario(camaraFalsaMenu, 1);

  filter(BLUR, 6);

  fill(0, 0, 0, 120);
  rect(0, 0, width, height);

  textAlign(CENTER, CENTER);
  fill(255, 215, 0);
  textSize(70);
  text("ONE WAY ONLY", width / 2, 140);

  fill(255);
  textSize(16);
  text("V 2.1", width / 2 + 250, 170);

  dibujarBotonesMenu();
}

void dibujarBotonesMenu() {
  int btnX = width / 2 - 180;
  int btnAncho = 360;
  int btnAlto = 55;

  int btnY_Jugar = 300;
  if (mouseX > btnX && mouseX < btnX + btnAncho && mouseY > btnY_Jugar && mouseY < btnY_Jugar + btnAlto) {
    fill(200, 50, 50);
  } else {
    fill(150, 30, 30);
  }
  rect(btnX, btnY_Jugar, btnAncho, btnAlto, 10);
  fill(255);
  textSize(24);
  text("JUGAR", width / 2, btnY_Jugar + 25);

  int btnY_Teclas = 380;
  if (mouseX > btnX && mouseX < btnX + btnAncho && mouseY > btnY_Teclas && mouseY < btnY_Teclas + btnAlto) {
    fill(180, 140, 20);
  } else {
    fill(140, 100, 15);
  }
  rect(btnX, btnY_Teclas, btnAncho, btnAlto, 10);
  fill(255);
  textSize(22);
  text("OPCIONES Y TECLAS", width / 2, btnY_Teclas + 25);
}

void actualizarYDibujarJuego() {
  float tramo = cargador.anchoTotalMapa / 4.0;

   if (jugador.pos.x < tramo) {
    nivelActual = 1;
  } else if (jugador.pos.x >= tramo && jugador.pos.x < tramo * 2) {
    nivelActual = 2;
  } else if (jugador.pos.x >= tramo * 2 && jugador.pos.x < tramo * 3) {
    nivelActual = 3;
  } else {
    if (nivelActual != 4) { 
      audio.iniciarMusicaJefe();
    }
    nivelActual = 4;
  }
  
  if (teclaA == 1 && teclaD == 0) jugador.moverIzquierda();
  else if (teclaD == 1 && teclaA == 0) jugador.moverDerecha();
  else jugador.detener();

  if (teclaSalto == 1) jugador.saltar();
  jugador.actualizarFisicas(cargador.plataformas);

  for (int i = enemigos.size() - 1; i >= 0; i--) {
    TortugaPerseguidora e = enemigos.get(i);
    e.actualizar(jugador, equipamiento, cargador.plataformas, enemigos);      
    if (e.activo == 0) enemigos.remove(i);
  }
  
  equipamiento.actualizar(jugador.pos.x, jugador.pos.y, jugador.mirandoIzquierda);

  float camaraX = width / 3 - jugador.pos.x;
  dibujarEscenario(camaraX, nivelActual);

  pushMatrix();
  translate(camaraX, 0);
  
  for (int i = plantas.size() - 1; i >= 0; i--) {
    PlantaCarnivora p = plantas.get(i);
    p.actualizar(jugador);
    p.mostrar();
    if (p.activo == 0) plantas.remove(i);
  }
  
  cargador.mostrar(nivelActual);

  for (int i = 0; i < enemigos.size(); i++) {
    enemigos.get(i).mostrar();
  }
  
  jefeFinal.actualizar(jugador, cargador.plataformas);
  jefeFinal.atacarSiEstaCerca(jugador, equipamiento, efectosParticulas);
  jefeFinal.mostrar();
  
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

  if (jugador.vida <= 0) {
    estadoJuego = 2;
    if (!partidaGuardada) {
      baseDatos.guardarPartida(nivelActual, puntaje, 0, equipamiento.durabilidadEspada, equipamiento.durabilidadEscudo, false);
      partidaGuardada = true;
    }
  }

  if (jefeFinal.vida <= 0) {
    estadoJuego = 3;
    if (!partidaGuardada) {
      baseDatos.guardarPartida(4, puntaje, jugador.vida, equipamiento.durabilidadEspada, equipamiento.durabilidadEscudo, true);
      partidaGuardada = true;
    }
  }

  dibujarHUD();
}

void dibujarEscenario(float camaraX, int nivel) {
  if (nivel == 4) background(30, 20, 40); 
  else background(95, 150, 230); 

  noStroke();
  if (nivel < 4) {
    fill(255, 255, 255, 80); ellipse(width - 200, 150, 120, 120);
    fill(255, 255, 220); ellipse(width - 200, 150, 80, 80);
  } else {
    fill(200, 200, 230, 100); ellipse(width - 200, 150, 100, 100);
    fill(220, 220, 255); ellipse(width - 200, 150, 70, 70);
  }

  int step = 4; 

  float pMontanas = floor((camaraX * 0.1) / step) * step;
  for (float x = 0; x <= width + step; x += step) {
    float worldX = x - pMontanas;
    float altura = 300 + noise(worldX * 0.003) * 300; 
    altura = floor(altura / step) * step; 
    if (nivel == 4) fill(50, 40, 60); else fill(160, 175, 195);
    rect(x, height - altura, step + 1, altura);
    if (nivel < 4 && altura > 450) {
      fill(245, 250, 255); 
      float nieveH = floor(((altura - 420) + noise(worldX * 0.05) * 30) / step) * step;
      rect(x, height - altura, step + 1, nieveH);
    }
  }

  float pBosque = floor((camaraX * 0.3) / step) * step;
  for (float x = 0; x <= width + step; x += step) {
    float worldX = x - pBosque;
    float altura = 250 + noise(worldX * 0.008) * 120;
    altura = floor(altura / step) * step;
    if (nivel == 4) fill(25, 15, 35); else fill(45, 100, 70);
    rect(x, height - altura, step + 1, altura);
  }

  float pColinas = floor((camaraX * 0.5) / step) * step;
  pushMatrix();
  translate(pColinas, 0);
  float inicio3 = floor(-pColinas / step) * step;
  
  for (float x = inicio3; x <= inicio3 + width + step * 2; x += step) {
    float altura = 180 + noise(x * 0.005) * 80;
    altura = floor(altura / step) * step;
    if (nivel == 4) fill(15, 10, 25); else fill(80, 160, 60);
    rect(x, height - altura, step + 1, altura);

    if (x < 4000 && noise(x * 0.15) > 0.75 && !(x > 100 && x < 400)) { 
      fill(100, 70, 40); 
      rect(x, height - altura - 20, step + 1, 20);
      if (x < 2000) fill(60, 150, 50); else fill(30, 90, 40); 
      rect(x - step, height - altura - 28, (step * 3) + 1, 12);
      rect(x, height - altura - 36, step + 1, 8);
    }
  }

  popMatrix();

  if (nivel < 4) {
    fill(70, 170, 180, 210);
    rect(0, height - 100, width, 100);
    fill(255, 255, 255, 90);
    float pAgua = floor((camaraX * 0.6 + millis() * 0.04) / step) * step; 
    for (int i = 0; i < 20; i++) {
      float posBaseX = noise(i * 15) * 5000;
      float aguaX = (posBaseX + pAgua) % width;
      if (aguaX < 0) aguaX += width; 
      float aguaY = height - 90 + noise(i * 5) * 70;
      float drawX = floor(aguaX / step) * step;
      float drawY = floor(aguaY / step) * step;
      rect(drawX, drawY, step * (4 + (int)(noise(i) * 3)) + 1, step + 1);
    }
  }
}
void dibujarMenuOpciones() {
  float camaraFalsaMenu = -millis() * 0.15; 
  dibujarEscenario(camaraFalsaMenu, 1);
  filter(BLUR, 6);

  fill(0, 0, 0, 180);
  rect(0, 0, width, height);

  textAlign(CENTER, CENTER);
  fill(255, 215, 0);
  textSize(45);
  text("OPCIONES Y CONTROLES", width / 2, 70);

  int col1 = width / 2 - 380;
  int col2 = width / 2 - 100;
  int col3 = width / 2 + 180;
  
  int fila1 = 200;
  int fila2 = 280;
  int fila3 = 360;

  dibujarBotonTecla("Izquierda", keyIzq + "", col1, fila1);
  dibujarBotonTecla("Derecha", keyDer + "", col2, fila1);
  dibujarBotonTecla("Saltar", keySalto + "", col3, fila1);

  dibujarBotonTecla("Atacar", keyAtaque + "", col1, fila2);
  dibujarBotonTecla("Bloquear", keyEscudo + "", col2, fila2);
  dibujarBotonTecla("Fuego", "L", col3, fila2);

  dibujarBotonTecla("Inv Izq", "<-", col1, fila3);
  dibujarBotonTecla("Usar Item", "ENTER", col2, fila3); 
  dibujarBotonTecla("Inv Der", "->", col3, fila3);

  int btnVolverX = width / 2 - 100;
  int btnVolverY = height - 100;
  
  if (mouseX > btnVolverX && mouseX < btnVolverX + 200 && mouseY > btnVolverY && mouseY < btnVolverY + 50) {
    fill(200, 50, 50);
  } else {
    fill(160, 40, 40);
  }
  
  rect(btnVolverX, btnVolverY, 200, 50, 10);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("VOLVER", width / 2, btnVolverY + 22);
  fill(255);
  textSize(24);
  text("VOLUMEN GENERAL", width / 2, 450);

  int sliderAncho = 300;
  int sliderX = width / 2 - sliderAncho / 2;
  int sliderY = 490;

  stroke(255);
  strokeWeight(4);
  line(sliderX, sliderY, sliderX + sliderAncho, sliderY);
  noStroke();

  if (arrastrandoVolumen) {
    volumenGlobal = map(mouseX, sliderX, sliderX + sliderAncho, 0, 1);
    volumenGlobal = constrain(volumenGlobal, 0, 1); // Que no pase de 0 o 1
    audio.actualizarVolumen(volumenGlobal);
  }

  float rueditaX = sliderX + (volumenGlobal * sliderAncho);
  fill(255, 215, 0);
  ellipse(rueditaX, sliderY, 20, 20);
}

void dibujarBotonTecla(String accion, String tecla, int x, int y) {
  textAlign(LEFT, CENTER);
  fill(255);
  textSize(18);
  text(accion, x, y);

  int boxX = x + 110; 
  int boxWidth = max(50, (int)textWidth(tecla) + 20);

  fill(180, 140, 20); 
  stroke(255, 215, 0); 
  strokeWeight(2);
  rect(boxX, y - 20, boxWidth, 40, 5);

  fill(20);
  noStroke();
  rect(boxX + 5, y - 12, boxWidth - 10, 28, 3);
  fill(40);
  rect(boxX + 5, y - 12, boxWidth - 10, 15, 3); 

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(16);
  text(tecla.toUpperCase(), boxX + boxWidth / 2, y + 2);
}

void dibujarHUD() {
  fill(0, 0, 0, 200);
  noStroke();
  rect(0, 0, width, 40);

  textSize(13);

  textAlign(LEFT, CENTER);
  
  fill(255);
  text("VIDA: " + (int)jugador.vida + " HP", 20, 20);

  if (equipamiento.durabilidadEspada > 0) fill(255); else fill(255, 50, 50);
  text("ESPADA: " + (int)equipamiento.durabilidadEspada + "%", 110, 20);

  if (equipamiento.durabilidadEscudo > 0) fill(255); else fill(255, 50, 50);
  text("ESCUDO: " + (int)equipamiento.durabilidadEscudo + "%", 210, 20);

  String estadoFuego = "Bloqueado";
  fill(150);
  if (equipamiento.poderFuegoActivado) {
    int tiempoRestante = 5000 - (millis() - ultimoDisparoFuego);
    if (tiempoRestante <= 0) {
      estadoFuego = "LISTO (L)";
      fill(255, 255, 0);
    } else {
      estadoFuego = "Carga: " + (tiempoRestante / 1000) + "s";
      fill(200, 150, 0);
    }
  }
  text("FUEGO: " + estadoFuego, 320, 20);

  fill(255);
  text("ZONA: " + nivelActual, 450, 20);

  fill(255);
  text("INV:", 530, 20);
  
  for (int i = 0; i < 2; i++) {
    int posX = 570 + (i * 40);
    
    if (i == slotSeleccionado) { stroke(255, 255, 0); strokeWeight(2); } 
    else { stroke(100); strokeWeight(1); }
    
    fill(0, 0, 0, 150);
    rect(posX, 5, 30, 30, 4);
    noStroke();
    
    if (inventario[i] == 1) { 
      fill(255, 0, 0); 
      ellipse(posX + 15, 20, 15, 15); 
    } else if (inventario[i] == 2) { 
      fill(180); 
      rect(posX + 11, 10, 8, 20); 
    } else if (inventario[i] == 4) { 
      fill(255, 255, 0); 
      ellipse(posX + 15, 20, 20, 20); 
      fill(0); 
      textAlign(CENTER, CENTER);
      textSize(10); 
      text("S", posX + 15, 19); 
      textSize(13); 
      textAlign(LEFT, CENTER);
    }
  }

  textAlign(RIGHT, CENTER);
  fill(255, 215, 0);
  text("PUNTAJE: " + puntaje, width - 20, 20);

  textAlign(CENTER, CENTER);
  fill(180);
  text("A/D: Mover | W: Saltar | J: Atacar | K: Cubrir | ENTER: Usar", (660 + (width - 150)) / 2, 20);

  textAlign(LEFT, BASELINE);
}
void usarItem(int slot) {
  int item = inventario[slot];
  if (item == 1) {
    jugador.vida = 100;
    inventario[slot] = 0;
  } else if (item == 2) {
    equipamiento.durabilidadEspada = 100;
    equipamiento.durabilidadEscudo = 100;
    inventario[slot] = 0;
  } else if (item == 4) {
    jugador.invencible = true;
    jugador.tiempoInvencibilidad = millis();
    inventario[slot] = 0;
  }
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
  float camaraX = width / 3 - jugador.pos.x;
  pushMatrix();
  translate(camaraX, 0);
  cargador.mostrar(nivelActual);
  jugador.mostrar();
  popMatrix();

  filter(BLUR, 5);
  fill(0, 0, 0, 170);
  noStroke();
  rect(0, 0, width, height);

  textAlign(CENTER, CENTER);
  
  fill(255, 215, 0);
  textSize(70);
  text("¡VICTORIA!", width / 2, height / 2 - 60);

  fill(255);
  textSize(22);
  text("Has conquistado el castillo y derrotado al jefe final.", width / 2, height / 2 + 20);
  
  fill(200);
  textSize(16);
  text("Presiona ENTER para jugar de nuevo.", width / 2, height / 2 + 70);
  
  textAlign(LEFT, BASELINE); 
}
void dibujarMenuPausa() {
  if (capturaPausa != null) {
    image(capturaPausa, 0, 0);
  }
  filter(BLUR, 6);
  fill(0, 0, 0, 160);
  rect(0, 0, width, height);

  textAlign(CENTER, CENTER);
  fill(255, 215, 0);
  textSize(60);
  text("JUEGO PAUSADO", width / 2, 120);

  int btnX = width / 2 - 175;
  int[] btnY = {230, 310, 390};
  String[] textos = {"Continuar", "Opciones de Sonido/Teclado", "Salir al Menu Principal"};

  for (int i = 0; i < 3; i++) {
    if (mouseX > btnX && mouseX < btnX + 350 && mouseY > btnY[i] && mouseY < btnY[i] + 55) {
      fill(200, 50, 50);
    } else {
      fill(150, 30, 30);
    }
    rect(btnX, btnY[i], 350, 55, 10);
    fill(255);
    textSize(22);
    text(textos[i], width / 2, btnY[i] + 25);
  }
}
void dibujarMenuPartidas() {
  float camaraFalsaMenu = -millis() * 0.15; 
  dibujarEscenario(camaraFalsaMenu, 1);
  filter(BLUR, 6);
  fill(0, 0, 0, 180);
  rect(0, 0, width, height);

  textAlign(CENTER, CENTER);
  fill(255, 215, 0);
  textSize(50);
  text("SELECCIONA UNA PARTIDA", width / 2, 80);

  int cajaAncho = 500;
  int cajaAlto = 100;
  int cajaX = width / 2 - cajaAncho / 2;

  for (int i = 0; i < 3; i++) {
    int cajaY = 180 + (i * 120);

    if (mouseX > cajaX && mouseX < cajaX + cajaAncho && mouseY > cajaY && mouseY < cajaY + cajaAlto) {
      fill(60, 60, 100);
    } else {
      fill(40, 40, 80);
    }
    stroke(255, 215, 0);
    strokeWeight(2);
    rect(cajaX, cajaY, cajaAncho, cajaAlto, 10);

    fill(255);
    textSize(28);
    textAlign(LEFT, CENTER);
    text("Casillero " + (i + 1), cajaX + 30, cajaY + cajaAlto / 2);

    if (slotsPartidas[i] == 0) {
      fill(150, 255, 150);
      textAlign(RIGHT, CENTER);
      text("NUEVA PARTIDA", cajaX + cajaAncho - 30, cajaY + cajaAlto / 2);
    } else {
      fill(255, 215, 0);
      textAlign(RIGHT, CENTER);
      text("CONTINUAR", cajaX + cajaAncho - 120, cajaY + cajaAlto / 2);
      
      fill(200, 50, 50);
      noStroke();
      rect(cajaX + cajaAncho - 80, cajaY + 25, 50, 50, 5);
      fill(255);
      textAlign(CENTER, CENTER);
      text("X", cajaX + cajaAncho - 55, cajaY + 47);
    }
  }

  fill(150, 30, 30);
  rect(width / 2 - 100, height - 80, 200, 50, 10);
  fill(255);
  textAlign(CENTER, CENTER);
  text("VOLVER", width / 2, height - 55);
}
void guardarProgresoLocal() {
  if (slotActivo >= 0 && slotActivo < 3) {
    slotsPartidas[slotActivo] = 1;
    slotsNivel[slotActivo] = nivelActual;
    slotsPuntaje[slotActivo] = puntaje;
    slotsVida[slotActivo] = jugador.vida;
    slotsEspada[slotActivo] = equipamiento.durabilidadEspada;
    slotsEscudo[slotActivo] = equipamiento.durabilidadEscudo;
  }
}

void cargarProgresoLocal(int indice) {
  nivelActual = slotsNivel[indice];
  puntaje = slotsPuntaje[indice];
  jugador.vida = slotsVida[indice];
  equipamiento.durabilidadEspada = slotsEspada[indice];
  equipamiento.durabilidadEscudo = slotsEscudo[indice];
  
  float tramo = cargador.anchoTotalMapa / 4.0;
  jugador.pos.x = (nivelActual - 1) * tramo + 150; 
  jugador.pos.y = 100;
}
