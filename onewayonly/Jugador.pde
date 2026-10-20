class Jugador {
  PVector pos;
  PVector vel;
  float ancho = 30;
  float alto = 30;
  float velocidad = 3;
  float fuerzaSalto = -10;
  float gravedad = 0.4;
  int enSuelo = 0;
  float vida = 100;
  boolean invencible = false;
  int tiempoInvencibilidad = 0;

  boolean mirandoIzquierda = false;

  Jugador(float xIni, float yIni) {
    pos = new PVector(xIni, yIni);
    vel = new PVector(0, 0);
  }

  void moverIzquierda() {
    vel.x = -velocidad;
    mirandoIzquierda = true;
  }

  void moverDerecha() {
    vel.x = velocidad;
    mirandoIzquierda = false;
  }

  void detener() {
    vel.x = 0;
  }

  void saltar() {
    if (enSuelo == 1) {
      vel.y = fuerzaSalto;
      enSuelo = 0;
    }
  }

  void actualizarFisicas(ArrayList<Bloque> plataformas) {
    pos.x = pos.x + vel.x;

    for (int i = 0; i < plataformas.size(); i++) {
      Bloque b = plataformas.get(i);

      if (pos.x < b.x + b.tamano && pos.x + ancho > b.x &&
        pos.y < b.y + b.tamano && pos.y + alto > b.y) {

        if (vel.x > 0) {
          pos.x = b.x - ancho;
        } else if (vel.x < 0) {
          pos.x = b.x + b.tamano;
        }
      }
    }

    vel.y = vel.y + gravedad;
    pos.y = pos.y + vel.y;

    enSuelo = 0;

    for (int i = 0; i < plataformas.size(); i++) {
      Bloque b = plataformas.get(i);

      if (pos.x < b.x + b.tamano && pos.x + ancho > b.x &&
        pos.y < b.y + b.tamano && pos.y + alto > b.y) {

        if (vel.y > 0) {
          pos.y = b.y - alto;
          vel.y = 0;
          enSuelo = 1;
        } else if (vel.y < 0) {
          pos.y = b.y + b.tamano;
          vel.y = 0;

          if (b.tipo == 8 && !b.usado) {
            b.usado = true;
            float suerte = random(100);

            if (suerte < 25) {
              vida = 100;
              b.recompensaDada = 1;
            } else if (suerte < 50) {
              equipamiento.durabilidadEspada = 100;
              equipamiento.durabilidadEscudo = 100;
              b.recompensaDada = 2;
            } else if (suerte < 75) {
              equipamiento.poderFuegoActivado = true;
              b.recompensaDada = 3;
            } else {
              invencible = true;
              tiempoInvencibilidad = millis();
              b.recompensaDada = 4;
            }
          }
        }
      }
    }

    if (pos.y > 600) {
      vida = 0;
    }
    if (invencible && millis() - tiempoInvencibilidad > 10000) {
      invencible = false;
    }
  }

  void mostrar() {
    fill(0, 102, 204);
    stroke(0);
    rect(pos.x, pos.y, ancho, alto);
    if (invencible) fill(random(255), random(255), random(255));
    else fill(0, 102, 204);

    stroke(0);
    rect(pos.x, pos.y, ancho, alto);
  }
}
