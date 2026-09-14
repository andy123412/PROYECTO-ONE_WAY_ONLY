class Enemigo {
  PVector pos;
  PVector vel;
  float ancho = 30;
  float alto = 30;
  float vida = 30;
  float velocidad = 1.2;
  int activo = 1;

  Enemigo(float xIni, float yIni) {
    pos = new PVector(xIni, yIni);
    vel = new PVector(0, 0);
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
      fill(0, 150, 0);
      rect(pos.x, pos.y, ancho, alto);
    }
  }
}

class TortugaPerseguidora extends Enemigo {
  int tiempoUltimoGolpe = 0;
  int tiempoEsperaGolpe = 1000;

  TortugaPerseguidora(float xIni, float yIni) {
    super(xIni, yIni);
    velocidad = 1.0;
    vida = 40;
  }

  void actualizar(float jugadorX, Jugador jug, Armamento equip, ArrayList<Bloque> plataformas) {
    if (activo == 0) return;

    if (jugadorX < pos.x) {
      pos.x = pos.x - velocidad;
    } else if (jugadorX > pos.x) {
      pos.x = pos.x + velocidad;
    }

    vel.y = vel.y + 0.4;
    pos.y = pos.y + vel.y;

    for (int i = 0; i < plataformas.size(); i = i + 1) {
      Bloque b = plataformas.get(i);
      
      if (pos.x < b.x + b.tamano && pos.x + ancho > b.x &&
          pos.y < b.y + b.tamano && pos.y + alto > b.y) {
        
        if (vel.y > 0 && pos.y + alto - vel.y <= b.y + 10) {
          pos.y = b.y - alto;
          vel.y = 0;
        }
      }
    }

   boolean colisionando = (jug.pos.x < pos.x + ancho && jug.pos.x + jug.ancho > pos.x &&
                            jug.pos.y < pos.y + alto && jug.pos.y + jug.alto > pos.y);

    if (colisionando) {
      int tiempoActual = millis();
      if (tiempoActual - tiempoUltimoGolpe >= tiempoEsperaGolpe) {
        
        float danoReal = equip.mitigarDano(5);
        
        if (danoReal > 0) {
          jug.vida = jug.vida - danoReal; 
        }

        if (equip.bloqueando) {
          efectosParticulas.add(new SistemaParticulas(15, jug.pos.x + (jug.mirandoIzquierda ? -10 : 20), jug.pos.y + 20, color(255, 220, 50)));
        }

        tiempoUltimoGolpe = tiempoActual;
      }
    }
  }

  void mostrar() {
    if (activo == 1) {
      fill(34, 139, 34);
      stroke(0);
      strokeWeight(1);
      rect(pos.x, pos.y, ancho, alto);
    }
  }
}
