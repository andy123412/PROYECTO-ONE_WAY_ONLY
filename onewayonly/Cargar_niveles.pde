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
    } 
    else if (tipo == 2) {
      fill(100, 55, 20);
      rect(x, y, tamano, tamano);
    } 
    else if (tipo == 3) {
      fill(80, 50, 25);
      rect(x, y, tamano, tamano);
      fill(20, 100, 25);
      rect(x, y, tamano, 8);
    } 
    else if (tipo == 4) {
      fill(90, 95, 105);
      rect(x, y, tamano, tamano);
      fill(130, 135, 145);
      rect(x, y, tamano, 4);
    } 
    else if (tipo == 5) {
      fill(60, 40, 50);
      rect(x, y, tamano, tamano);
      stroke(120);
      strokeWeight(1);
      line(x, y + 20, x + tamano, y + 20);
      line(x + 20, y, x + 20, y + 20);
      noStroke();
    }
  else if (tipo == 8) {
    if (!usado) {
      fill(255, 215, 0); rect(x, y, tamano, tamano);
      fill(255); textSize(20); text("?", x + 12, y + 28);
    } else {
      fill(100, 60, 20); rect(x, y, tamano, tamano);
      
      if (animacionY < 40) {
        animacionY += 1.5;
        float objX = x + tamano / 2;
        float objY = y - animacionY;
        
        if (recompensaDada == 1) { 
          fill(255, 0, 0);
          ellipse(objX - 5, objY, 12, 12); ellipse(objX + 5, objY, 12, 12);
          triangle(objX - 11, objY + 3, objX + 11, objY + 3, objX, objY + 12);
        } else if (recompensaDada == 2) {
          fill(180);
          rect(objX - 4, objY - 10, 8, 20, 2);
          ellipse(objX, objY - 12, 14, 14);
          fill(170, 215, 255); ellipse(objX, objY - 12, 6, 6);
        } else if (recompensaDada == 3) {
          fill(255, 0, 0);
          ellipse(objX - 5, objY, 10, 10); ellipse(objX + 5, objY, 10, 10);
          ellipse(objX, objY - 5, 10, 10); ellipse(objX, objY + 5, 10, 10);
          fill(255, 255, 0); ellipse(objX, objY, 6, 6);
      }
    }
  }
}
  

  }
 
 }
