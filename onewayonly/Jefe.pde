class Jefe {
  float x, y;
  float ancho = 60, alto = 60;
  float vida = 200, danoAtaque = 10;
  int activo = 1;
  int tiempoUltimoGolpe = 0, tiempoEsperaGolpe = 1000;

  PVector vel;
  float velocidad = 1.5;

  Jefe(float xIni, float yIni) {
    x = xIni;
    y = yIni;
    vel = new PVector(0, 0);
  }

  void actualizar(Jugador jug, ArrayList<Bloque> plataformas) {
    if (activo == 0) return;

    float distancia = abs(jug.pos.x - x);
    if (distancia < 2000) {
      if (jug.pos.x < x) vel.x = -velocidad;
      else vel.x = velocidad;
    } else {
      vel.x = 0;
    }

    float viejaX = x;

    x += vel.x;
    for (int i = 0; i < plataformas.size(); i++) {
      Bloque b = plataformas.get(i);
      if (x < b.x + b.tamano && x + ancho > b.x && y < b.y + b.tamano && y + (alto - 2) > b.y) {
        if (vel.x > 0) x = b.x - ancho;
        else if (vel.x < 0) x = b.x + b.tamano;
      }
    }

    if (x == viejaX && vel.x != 0 && vel.y == 0) {
      vel.y = -10;
    }

    vel.y += 0.4;
    y += vel.y;
    for (int i = 0; i < plataformas.size(); i++) {
      Bloque b = plataformas.get(i);
      if (x < b.x + b.tamano && x + ancho > b.x && y < b.y + b.tamano && y + alto > b.y) {
        if (vel.y > 0) {
          y = b.y - alto;
          vel.y = 0;
        } else if (vel.y < 0) {
          y = b.y + b.tamano;
          vel.y = 0;
        }
      }
    }
  }

  void atacarSiEstaCerca(Jugador jug, Armamento equip) {
    if (activo == 0) return;

    float distancia = abs(jug.pos.x - x);
    if (distancia < 50) {
      int tiempoActual = millis();
      if (tiempoActual - tiempoUltimoGolpe >= tiempoEsperaGolpe) {
        float danoFinal = equip.mitigarDano(danoAtaque);
        if (danoFinal > 0) jug.vida -= danoFinal;

        if (equip.bloqueando) {
          efectosParticulas.add(new SistemaParticulas(25, jug.pos.x + (jug.mirandoIzquierda ? -10 : 20), jug.pos.y + 20, color(255, 220, 50)));
        }

        tiempoUltimoGolpe = tiempoActual;
      }
    }
  }

  void recibirDano(float cantidad) {
    if (activo == 1) {
      vida -= cantidad;
      if (vida <= 0) {
        vida = 0;
        activo = 0;
        puntaje += 100;
      }
    }
  }

  void mostrar() {
    if (activo == 1) {
      fill(204, 0, 0);
      noStroke();
      rect(x, y, ancho, alto);
      fill(100, 0, 0);
      rect(x, y - 15, ancho, 8);
      fill(0, 255, 0);
      float anchoVida = map(vida, 0, 200, 0, ancho);
      rect(x, y - 15, max(0, anchoVida), 8);
    }
  }
}
