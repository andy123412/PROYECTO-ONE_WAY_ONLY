class CargadorCSV {
  float tamanoTile = 40;
  ArrayList<Bloque> plataformas;
  float anchoTotalMapa = 0;

  CargadorCSV() {
    plataformas = new ArrayList<Bloque>();
  }

  void cargarDesdeCSV(String rutaCSV, Jugador jug, ArrayList<TortugaPerseguidora> listaEnemigos, Jefe jefeGlobal) {
    plataformas.clear();
    listaEnemigos.clear();
    plantas.clear();
    processing.data.Table tabla = loadTable(rutaCSV);
    if (tabla == null) {
      println("Error: no se encontro el archivo ");
      return;
    }

    int totalFilas = tabla.getRowCount();
    int totalColumnas = tabla.getColumnCount();

    anchoTotalMapa = totalColumnas * tamanoTile;

    for (int fila = 0; fila < totalFilas; fila++) {
      processing.data.TableRow filaActual = tabla.getRow(fila);

      for (int col = 0; col < totalColumnas; col++) {
        int valor = filaActual.getInt(col);

        float posX = col * tamanoTile;
        float posY = fila * tamanoTile;

        if ((valor >= 1 && valor <= 5) || valor == 8 || valor == 10) {
          plataformas.add(new Bloque(posX, posY, valor));
          if (valor == 10) {
            plantas.add(new PlantaCarnivora(posX + 5, posY));
          }
        } else if (valor == 6) {
          listaEnemigos.add(new TortugaPerseguidora(posX, posY));
        } else if (valor == 7) {
          jefeGlobal.x = posX;
          jefeGlobal.y = posY;
          jefeGlobal.activo = 1;
          jefeGlobal.vida = 200;
        } else if (valor == 9) {
          jug.pos.x = posX;
          jug.pos.y = posY;
        }
      }
    }
  }

  void mostrar(int nivelActual) {
    for (int i = 0; i < plataformas.size(); i++) {
      plataformas.get(i).mostrar(nivelActual);
    }
  }
}
