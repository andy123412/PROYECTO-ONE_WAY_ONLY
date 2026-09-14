class Bloque {
  float x, y;
  float tamano = 40;
  float ancho = 40;
  float alto = 40;
  int tipo = 1;

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
      fill(19, 100, 25);
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
  }
}
