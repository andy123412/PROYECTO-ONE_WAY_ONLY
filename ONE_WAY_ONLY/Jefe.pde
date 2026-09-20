class Jefe {
  float x, y;
  float ancho = 60;
  float alto = 60;

  float vida = 200;
  float danoAtaque = 10;
  int activo = 1;

  int tiempoUltimoGolpe = 0;
  int tiempoEsperaGolpe = 1000;

  Jefe(float xIni, float yIni) {
    x = xIni;
    y = yIni;
  }

  void atacarSiEstaCerca(Jugador jug, Armamento equip) {
    if (activo == 0) return;

    float distancia = abs((jug.pos.x + jug.ancho) - x);
    if (distancia < 20) {
      int tiempoActual = millis();
      if (tiempoActual - tiempoUltimoGolpe >= tiempoEsperaGolpe) {
        
        float danoFinal = equip.mitigarDano(danoAtaque);
        
        if (danoFinal > 0) {
          jug.vida = jug.vida - danoFinal;
        }

        tiempoUltimoGolpe = tiempoActual;
      }
    }
  }

  void recibirDano(float cantidad) {
    if (activo == 1) {
      vida = vida - cantidad;
      if (vida <= 0) {
        vida = 0;
        activo = 0;
      }
    }
  }

  void mostrar() {
    if (activo == 1) {
      fill(204, 0, 0);
      noStroke();
      rect(x, y, ancho, alto);
    }
  }
}
