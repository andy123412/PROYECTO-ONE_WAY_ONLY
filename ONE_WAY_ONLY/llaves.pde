void keyPressed() {
  if (key == 'a' || key == 'A') teclaA = 1;
  if (key == 'd' || key == 'D') teclaD = 1;
  if (key == 'w' || key == 'W' || key == ' ') teclaSalto = 1;

  if (key == 'j' || key == 'J') {
    equipamiento.atacar(enemigos, jugador);
  }
  if (key == 'k' || key == 'K') {
    equipamiento.cubrir();
  }
  
  if (keyCode == ENTER && (estadoJuego == 0 || estadoJuego == 2)) {
    estadoJuego = 1;
    iniciarJuego();
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
