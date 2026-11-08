class Bloque {
  float x, y;
  float tamano = 40;
  float ancho = 40;
  float alto = 40;
  int tipo = 1;
  boolean usado = false;
  int recompensaDada = 0;
  float animacionY = 0;
  Bloque(float xIni, float yIni, int tipoBloque) {
    x = xIni;
    y = yIni;
    tipo = tipoBloque;
  }

  void mostrar(int nivelActual) {
    noStroke();

    if (tipo == 1) {
      fill(110, 65, 30);
      rect(x, y, tamano, tamano);
      fill(50, 205, 50);
      rect(x, y, tamano, 8);
    } else if (tipo == 2) {
      fill(100, 55, 20);
      rect(x, y, tamano, tamano);
    } else if (tipo == 3) {
      fill(80, 50, 25);
      rect(x, y, tamano, tamano);
      fill(20, 100, 25);
      rect(x, y, tamano, 8);
    } else if (tipo == 4) {
      fill(90, 95, 105);
      rect(x, y, tamano, tamano);
      fill(130, 135, 145);
      rect(x, y, tamano, 4);
    } else if (tipo == 5) {
      fill(60, 40, 50);
      rect(x, y, tamano, tamano);
      stroke(120);
      strokeWeight(1);
      line(x, y + 20, x + tamano, y + 20);
      line(x + 20, y, x + 20, y + 20);
      noStroke();
    } else if (tipo == 8) {
      stroke(0);
      strokeWeight(2);
      if (!usado) {
        fill(255, 215, 0);
        rect(x, y, tamano, tamano);
        fill(255);
        textSize(24);
        textAlign(CENTER, CENTER);
        text("?", x + tamano/2, y + tamano/2 - 2);
      } else {
        fill(100, 60, 20);
        rect(x, y, tamano, tamano);
        if (animacionY < 40) {
          animacionY += 1.5;
          float objX = x + tamano / 2;
          float objY = y - animacionY;

          noStroke();
          if (recompensaDada == 1) {
            fill(255, 0, 0);
            ellipse(objX, objY, 15, 15);
          } else if (recompensaDada == 2) {
            fill(180);
            rect(objX-4, objY-10, 8, 20);
          } else if (recompensaDada == 3) {
            fill(255, 100, 0);
            ellipse(objX, objY, 15, 15);
          } else if (recompensaDada == 4) {
            fill(255, 255, 0);
            ellipse(objX, objY, 20, 20);
            fill(0);
            textSize(12);
            text("S", objX, objY - 2);
          }
        }
      }
      noStroke();
      textAlign(LEFT, BASELINE);
    } else if (tipo == 10) {
      stroke(0);
      strokeWeight(2);
      fill(0, 180, 0);
      rect(x, y + 10, tamano, tamano - 10);
      rect(x - 2, y, tamano + 4, 15);
      noStroke();
    }
  }
}
