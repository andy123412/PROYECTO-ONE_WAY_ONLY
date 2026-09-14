/*class MundoContinuo {
  float pisoY = 480;

  MundoContinuo() {
  }

  String obtenerNombreZona(float jugadorX) {
    if (jugadorX < 2000) return "ZONA 1: JARDIN";
    if (jugadorX < 4000) return "ZONA 2: BOSQUE OSCURO";
    if (jugadorX < 6000) return "ZONA 3: ISLAS CELESTES";
    return "ZONA 4: CASTILLO DEL JEFE";
  }

    void mostrarSueloYEntorno(float jugadorX) {
    // Bioma 1: Jardín [0 a 2000px]
    fill(50, 205, 50);
    rect(0, pisoY, 2000, 120);

    // Bioma 2: Bosque [2000 a 4000px]
    fill(19, 100, 25);
    rect(2000, pisoY, 2000, 120);

    // Bioma 3: Islas / Agua Celeste [4000 a 6000px]
    fill(30, 144, 255);
    rect(4000, pisoY, 2000, 120);

    // Bioma 4: Castillo [6000 a 8000px]
    fill(100, 100, 100);
    rect(6000, pisoY, 2000, 120);

    // Carteles
    dibujarCartel(100, "BIENVENIDO AL JARDIN");
    dibujarCartel(2050, "ENTRANDO AL BOSQUE OSCURO");
    dibujarCartel(4050, "ENTRANDO A LAS ISLAS CELESTES");
    dibujarCartel(6050, "ENTRANDO AL CASTILLO DEL JEFE");

    // Bandera Final
    dibujarBandera(7800, pisoY);
  }

  void dibujarCartel(float x, String texto) {
    fill(101, 67, 33);
    rect(x + 40, pisoY - 50, 10, 50);

    fill(160, 82, 45);
    stroke(0);
    strokeWeight(2);
    rect(x, pisoY - 90, 210, 40);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(11);
    text(texto, x + 105, pisoY - 70);
    textAlign(LEFT, BASELINE);
    noStroke();
  }

  void dibujarBandera(float x, float y) {
    fill(200);
    stroke(0);
    strokeWeight(2);
    rect(x, y - 150, 8, 150);

    fill(255, 0, 0);
    triangle(x + 8, y - 150, x + 60, y - 130, x + 8, y - 110);
    noStroke();
  }
} */
