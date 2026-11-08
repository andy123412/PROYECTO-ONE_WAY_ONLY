class PlantaCarnivora {
  float x, y, yAnim;
  float ancho = 30, alto = 38;
  int estado = 0;
  int timer = 0;
  float vida = 40;
  int activo = 1;
  int ultimoAtaqueJugador = 0;

  PlantaCarnivora(float xIni, float yIni) {
    x = xIni;
    y = yIni;
    yAnim = y + 2;
    timer = millis() - (int)random(0, 2000);
  }

  void actualizar(Jugador jug) {
    if (activo == 0) return;

    int ahora = millis();

    if (estado == 0 && ahora - timer > 2200) {
      estado = 1;
    } else if (estado == 1) {
      yAnim -= 1.5;
      if (yAnim <= y - alto) {
        yAnim = y - alto;
        estado = 2;
        timer = ahora;
      }
    } else if (estado == 2 && ahora - timer > 1800) {
      estado = 3;
    } else if (estado == 3) {
      yAnim += 1.5;
      if (yAnim >= y + 2) {
        yAnim = y + 2;
        estado = 0;
        timer = ahora;
      }
    }

    if (estado != 0) {
      boolean colision = (jug.pos.x < x + ancho && jug.pos.x + jug.ancho > x && jug.pos.y < yAnim + alto && jug.pos.y + jug.alto > yAnim);
      if (colision) {
        if (jug.invencible) {
          recibirDano(100);
        } else {
          if (ahora - ultimoAtaqueJugador > 1000) {
            jug.vida -= 15;
            ultimoAtaqueJugador = ahora;
          }
        }
      }
    }
  }

  void recibirDano(float cant) {
    if (activo == 1) {
      vida -= cant;
      if (vida <= 0) {
        activo = 0;
        puntaje += 30;
      }
    }
  }

  void mostrar() {
    if (activo == 1 && estado != 0) {
      if (yAnim + alto < y + 10) {
        fill(0, 140, 0);
        noStroke();
        rect(x + 10, yAnim + alto, 10, (y + 10) - (yAnim + alto));
      }

      fill(220, 20, 20);
      stroke(0);
      strokeWeight(1);
      rect(x, yAnim, ancho, alto, 15, 15, 0, 0);

      fill(255);
      noStroke();
      ellipse(x + 9, yAnim + 12, 6, 6);
      ellipse(x + 21, yAnim + 20, 7, 7);
      ellipse(x + 10, yAnim + 28, 5, 5);
      
      fill(255);
      rect(x + 6, yAnim, ancho - 12, 4);
    }
  }
}
