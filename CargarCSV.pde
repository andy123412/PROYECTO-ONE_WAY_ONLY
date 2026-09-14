class CargadorCSV {
  float tamanoTile = 40;
  ArrayList<Bloque> plataformas;
  float anchoTotalMapa = 0;

  CargadorCSV() {
    plataformas = new ArrayList<Bloque>();
  }

  void cargarDesdeCSV(String rutaCSV, Jugador jug, ArrayList<TortugaPerseguidora> listaEnemigos) {
    plataformas.clear();
    listaEnemigos.clear();

    Table tabla = loadTable(rutaCSV);

    if (tabla == null) {
      println("Error: No se encontró el archivo " + rutaCSV + " en la carpeta /data/");
      return;
    }

    int totalFilas = tabla.getRowCount();
    int totalColumnas = tabla.getColumnCount();

    anchoTotalMapa = totalColumnas * tamanoTile;

    for (int fila = 0; fila < totalFilas; fila++) {
      TableRow filaActual = tabla.getRow(fila);

      for (int col = 0; col < totalColumnas; col++) {
        int valor = filaActual.getInt(col);

        float posX = col * tamanoTile;
        float posY = fila * tamanoTile;

        if (valor >= 1 && valor <= 5) {
          plataformas.add(new Bloque(posX, posY, valor));
        } else if (valor == 6) {
          listaEnemigos.add(new TortugaPerseguidora(posX, posY));
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
