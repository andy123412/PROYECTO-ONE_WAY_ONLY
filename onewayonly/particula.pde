class Particula {
  PVector pos;
  PVector vel;
  float vida;
  color col;

  Particula(float xIni, float yIni, color c) {
    pos = new PVector(xIni, yIni);
    vel = new PVector(random(-3, 3), random(-4, -1));
    vida = 255;
    col = c;
  }

  void actualizar() {
    pos.add(vel);
    vida = vida - 8;
  }

  void mostrar() {
    if (vida > 0) {
      noStroke();
      fill(col, vida);
      ellipse(pos.x, pos.y, 6, 6);
    }
  }
}

class SistemaParticulas {
  Particula[] arregloParticulas;

  SistemaParticulas(int cantidad, float xIni, float yIni, color c) {
    arregloParticulas = new Particula[cantidad];
    for (int i = 0; i < cantidad; i++) {
      arregloParticulas[i] = new Particula(xIni, yIni, c);
    }
  }

  void actualizarYMostrar() {
    for (int i = 0; i < arregloParticulas.length; i++) {
      if (arregloParticulas[i] != null) {
        arregloParticulas[i].actualizar();
        arregloParticulas[i].mostrar();
      }
    }
  }

  boolean terminado() {
    for (int i = 0; i < arregloParticulas.length; i++) {
      if (arregloParticulas[i] != null && arregloParticulas[i].vida > 0) {
        return false;
      }
    }
    return true;
}
}
