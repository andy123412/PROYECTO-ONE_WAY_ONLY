class Armamento {
  int atacando = 0;
  int tiempoAtaque = 0;
  float rangoAtaque = 50;
  float durabilidad = 100;
  boolean poderFuegoActivado = false;
  boolean bloqueando = false;

  float durabilidadEspada = 100;
  float durabilidadEscudo = 100;

  Armamento() {
  }

  void cubrir() {
    if (durabilidadEscudo > 0) {
      bloqueando = true;
    }
  }

  void soltarCubrir() {
    bloqueando = false;
  }

  void atacar(ArrayList<TortugaPerseguidora> listaEnemigos, Jugador jugador, Jefe jefeFinal) {
    if (atacando == 0 && !bloqueando && durabilidadEspada > 0) {
      atacando = 1;
      tiempoAtaque = millis();

      boolean golpeExitoso = false;

      for (int i = 0; i < listaEnemigos.size(); i++) {
        TortugaPerseguidora e = listaEnemigos.get(i);
        float dist = dist(jugador.pos.x, jugador.pos.y, e.pos.x, e.pos.y);
        if (dist <= rangoAtaque + e.ancho && e.activo == 1) {
          e.recibirDano(20);
          golpeExitoso = true;
        }
      }

      if (jefeFinal.activo == 1) {
        float distJefe = dist(jugador.pos.x, jugador.pos.y, jefeFinal.x, jefeFinal.y);
        if (distJefe <= rangoAtaque + jefeFinal.ancho) {
          jefeFinal.recibirDano(20);
          golpeExitoso = true;
        }
      }

      if (golpeExitoso) {
        durabilidadEspada -= 5;
        if (durabilidadEspada < 0) durabilidadEspada = 0;
      }
    }
  }

  float mitigarDano(float cantidadBase) {
    if (bloqueando && durabilidadEscudo > 0) {
      durabilidadEscudo -= 5;

      if (durabilidadEscudo <= 0) {
        durabilidadEscudo = 0;
        bloqueando = false;
      }

      return cantidadBase * 0.2;
    }
    return cantidadBase;
  }

  void actualizar(float px, float py, boolean mirandoIzq) {
    if (atacando == 1 && millis() - tiempoAtaque > 250) {
      atacando = 0;
    }
    if (atacando == 1 && millis() - tiempoAtaque > 300) {
      atacando = 0;
    }
  }


  void mostrar(Jugador jugador) {
    pushMatrix();
    translate(jugador.pos.x + jugador.ancho / 2, jugador.pos.y + jugador.alto / 2);

    if (bloqueando) {
      fill(70, 130, 180);
      stroke(255);
      strokeWeight(2);
      if (jugador.mirandoIzquierda) {
        rect(-22, -15, 8, 30);
      } else {
        rect(14, -15, 8, 30);
      }
      noStroke();
    } else {
      fill(150, 150, 150);
      rect(-18, -10, 6, 20);
    }

    if (atacando == 1) {
      fill(220, 220, 255);
      if (jugador.mirandoIzquierda) {
        rect(-35, -5, 25, 8);
      } else {
        rect(10, -5, 25, 8);
      }
    } else if (!bloqueando) {
      fill(180, 180, 180);
      if (jugador.mirandoIzquierda) {
        rect(-12, -15, 5, 18);
      } else {
        rect(8, -15, 5, 18);
      }
    }
    popMatrix();
  }
}
