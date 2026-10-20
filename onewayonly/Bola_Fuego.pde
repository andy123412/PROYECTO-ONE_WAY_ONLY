class BolaFuego {
  PVector pos, vel;
  float tamano = 15;
  int tiempoCreacion;
  boolean activa = true;

  BolaFuego(float x, float y, boolean mirandoIzq) {
    pos = new PVector(x, y);
    vel = new PVector(mirandoIzq ? -6 : 6, -3);
    tiempoCreacion = millis();
  }

  void actualizar(ArrayList<Bloque> plataformas, ArrayList<TortugaPerseguidora> enemigos, Jefe jefe) {
    if (!activa) return;

    if (millis() - tiempoCreacion > 2500) {
      activa = false;
      return;
    }

    pos.x += vel.x;
    for (int i = 0; i < plataformas.size(); i++) {
      Bloque b = plataformas.get(i);
      if (pos.x < b.x + b.tamano && pos.x + tamano > b.x && pos.y < b.y + b.tamano && pos.y + tamano > b.y) {
        activa = false;
      }
    }

    if (!activa) return;

    vel.y += 0.4;
    pos.y += vel.y;
    for (int i = 0; i < plataformas.size(); i++) {
      Bloque b = plataformas.get(i);
      if (pos.x < b.x + b.tamano && pos.x + tamano > b.x && pos.y < b.y + b.tamano && pos.y + tamano > b.y) {
        if (vel.y > 0) {
          pos.y = b.y - tamano;
          vel.y = -5.5;
        } else if (vel.y < 0) {
          pos.y = b.y + b.tamano;
          vel.y = 0;
        }
      }
    }

    for (int i = 0; i < enemigos.size(); i++) {
      TortugaPerseguidora e = enemigos.get(i);
      if (e.activo == 1 && pos.x < e.pos.x + e.ancho && pos.x + tamano > e.pos.x && pos.y < e.pos.y + e.alto && pos.y + tamano > e.pos.y) {
        e.recibirDano(50);
        activa = false;
      }
    }

    if (jefe.activo == 1 && pos.x < jefe.x + jefe.ancho && pos.x + tamano > jefe.x && pos.y < jefe.y + jefe.alto && pos.y + tamano > jefe.y) {
      jefe.recibirDano(20);
      activa = false;
    }
  }

  void mostrar() {
    if (activa) {
      fill(255, 100, 0);
      ellipse(pos.x + tamano/2, pos.y + tamano/2, tamano, tamano);
    }
  }
}
