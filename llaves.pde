int ultimoDisparoFuego = 0;

void keyPressed() {
  if (key == 'a' || key == 'A') teclaA = 1;
  if (key == 'd' || key == 'D') teclaD = 1;
  if (key == 'w' || key == 'W' || key == ' ') teclaSalto = 1;
  if (key == 'k' || key == 'K') equipamiento.cubrir();
  
  if (key == 'p' || key == 'P' || keyCode == ESC) {
    if (estadoJuego == 1) {
      capturaPausa = get();
      estadoJuego = 5;
      key = 0;
    } else if (estadoJuego == 5) {
      estadoJuego = 1;
      key = 0;
    }
  }
  
  if (key == 'j' || key == 'J') {
    if (equipamiento.atacando == 0) { 
      equipamiento.atacar(enemigos, jugador, jefeFinal);
      audio.sonarEspada();
    }
  }

  if (key == 'l' || key == 'L') {
    if (equipamiento.poderFuegoActivado && estadoJuego == 1) {
      if (millis() - ultimoDisparoFuego >= 5000) {
        bolasFuego.add(new BolaFuego(jugador.pos.x, jugador.pos.y, jugador.mirandoIzquierda));
        ultimoDisparoFuego = millis();
      }
    }
  }

  if (estadoJuego == 1) {
    if (keyCode == LEFT) {
      if (slotSeleccionado > 0) {
        slotSeleccionado--;
        audio.sonarItem();
      }
    }
    if (keyCode == RIGHT) {
      if (slotSeleccionado < 1) {
        slotSeleccionado++;
        audio.sonarItem();
      }
    }
  }

  if (keyCode == ENTER) {
    if (estadoJuego == 2 || estadoJuego == 3) {
      estadoJuego = 6;
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
    
    if (mouseX > btnX && mouseX < btnX + 360 && mouseY > 300 && mouseY < 355) {
      audio.sonarClick();
      estadoJuego = 6;
    }
    
    if (mouseX > btnX && mouseX < btnX + 360 && mouseY > 380 && mouseY < 435) {
      audio.sonarClick(); 
      estadoAnteriorOpciones = 0;
      estadoJuego = 4;
    }
  } 
  
  else if (estadoJuego == 4) {
    if (mouseX > width / 2 - 100 && mouseX < width / 2 + 100 && mouseY > height - 100 && mouseY < height - 50) {
      audio.sonarClick();
      estadoJuego = estadoAnteriorOpciones; 
    }
    
    int sliderAncho = 300;
    int sliderX = width / 2 - sliderAncho / 2;
    int sliderY = 490;
    
    if (mouseY > sliderY - 20 && mouseY < sliderY + 20 && mouseX > sliderX && mouseX < sliderX + sliderAncho) {
      arrastrandoVolumen = true;
    }
  }
  
  else if (estadoJuego == 5) {
    int btnX = width / 2 - 175;
    if (mouseX > btnX && mouseX < btnX + 350) {
      if (mouseY > 230 && mouseY < 285) {
        estadoJuego = 1;
        audio.sonarClick();
      } else if (mouseY > 310 && mouseY < 365) {
        estadoAnteriorOpciones = 5;
        estadoJuego = 4;
        audio.sonarClick();
      } else if (mouseY > 390 && mouseY < 445) {
        guardarProgresoLocal(); 
        estadoJuego = 0;
        audio.detenerTodo();
        audio.sonarClick();
      }
    }
  }
  
  else if (estadoJuego == 6) {
    int cajaAncho = 500;
    int cajaAlto = 100;
    int cajaX = width / 2 - cajaAncho / 2;

    for (int i = 0; i < 3; i++) {
      int cajaY = 180 + (i * 120);

      if (mouseX > cajaX && mouseX < cajaX + cajaAncho && mouseY > cajaY && mouseY < cajaY + cajaAlto) {
        
        if (slotsPartidas[i] == 1 && mouseX > cajaX + cajaAncho - 80) {
          slotsPartidas[i] = 0;
          slotsNivel[i] = 1; 
          slotsPuntaje[i] = 0; 
          slotsVida[i] = 100; 
          slotsEspada[i] = 100; 
          slotsEscudo[i] = 100;
          audio.sonarClick();
        } 
        else {
          slotActivo = i;
          audio.sonarClick();
          
          if (slotsPartidas[i] == 0) {
            slotsPartidas[i] = 1;
            iniciarJuego();
          } else {
            iniciarJuego();
            cargarProgresoLocal(i);
          }
          
          estadoJuego = 1;
          
          if (nivelActual == 4) {
            audio.iniciarMusicaJefe();
          } else {
            audio.iniciarMusicaBosque();
          }
        }
      }
    }
    
    if (mouseX > width / 2 - 100 && mouseX < width / 2 + 100 && mouseY > height - 80 && mouseY < height - 30) {
      estadoJuego = 0;
      audio.sonarClick();
    }
  }
}

void mouseReleased() {
  arrastrandoVolumen = false;
}
