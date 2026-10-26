int ultimoDisparoFuego = 0;

void keyPressed() {
  if (key == 'a' || key == 'A') teclaA = 1;
  if (key == 'd' || key == 'D') teclaD = 1;
  if (key == 'w' || key == 'W' || key == ' ') teclaSalto = 1;
  if (key == 'k' || key == 'K') equipamiento.cubrir();
  if (key == 'j' || key == 'J') equipamiento.atacar(enemigos, jugador, jefeFinal);

  if (key == 'l' || key == 'L') {
    if (equipamiento.poderFuegoActivado && estadoJuego == 1) {
      if (millis() - ultimoDisparoFuego >= 5000) {
        bolasFuego.add(new BolaFuego(jugador.pos.x, jugador.pos.y, jugador.mirandoIzquierda));
        ultimoDisparoFuego = millis();
      }
    }
  }

    if (estadoJuego == 1) {
    if (keyCode == LEFT) slotSeleccionado = 0;
    if (keyCode == RIGHT) slotSeleccionado = 1;
  }

  if (keyCode == ENTER) {
    if (estadoJuego == 0 || estadoJuego == 2 || estadoJuego == 3) {
      iniciarJuego();
      estadoJuego = 1;
    } else if (estadoJuego == 1) {
      usarItem(slotSeleccionado);
    }
  }
}

void keyReleased() {
  if (key == 'a' || key == 'A') teclaA = 0;
  if (key == 'd' || key == 'D') teclaD = 0;
  if (key == 'w' || key == 'W' || key == ' ') teclaSalto = 0;
  if (key == 'k' || key == 'K') {
    equipamiento.soltarCubrir();
  }
}
void mousePressed() {
  if (estadoJuego == 0) {
    int btnX = width / 2 - 180;
    int btnY_Jugar = 280;

    if (mouseX > btnX && mouseX < btnX + 360 && mouseY > btnY_Jugar && mouseY < btnY_Jugar + 55) {
      iniciarJuego();
      estadoJuego = 1;
    }
  }
}
