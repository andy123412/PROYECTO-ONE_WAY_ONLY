import java.sql.*;

class ConexionBD {
  Connection conexion;
  
  String url = "jdbc:mysql://localhost:3306/one_way_only_db";
  String usuario = "root";
  String contrasena = ""; 

  ConexionBD() {
  }

  void conectar() {
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      conexion = DriverManager.getConnection(url, usuario, contrasena);
      println("¡Conexion a MySQL EXITOSA!");
    } catch (Exception e) {
      println("Error conectando a la BD: " + e.getMessage());
    }
  }

  // Método para guardar cuando perdés o ganás
  void guardarPartida(int zona, int puntajeFinal, float vidaFinal, float espada, float escudo, boolean derrotoJefe) {
    if (conexion != null) {
      try {
        String query = "INSERT INTO PARTIDAS (id_jugador, id_zona_maxima, puntaje_obtenido, vida_restante, durabilidad_espada_final, durabilidad_escudo_final, tiempo_supervivencia_seg, jefe_derrotado, estado_final) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        PreparedStatement st = conexion.prepareStatement(query);
        
        st.setInt(1, 1);
        st.setInt(2, zona);
        st.setInt(3, puntajeFinal);
        st.setFloat(4, vidaFinal);
        st.setFloat(5, espada);
        st.setFloat(6, escudo);
        st.setInt(7, millis() / 1000);
        st.setBoolean(8, derrotoJefe);
        st.setString(9, derrotoJefe ? "VICTORIA" : "GAME_OVER");

        st.executeUpdate();
        println("¡Partida guardada correctamente en la Base de Datos!");
        
      } catch (Exception e) {
        println("Error guardando la partida: " + e.getMessage());
      }
    } else {
      println("No se pudo guardar: No hay conexion a la base de datos.");
    }
  }
   void cargarTop10() {
    rankingTop10.clear();
    if (conexion != null) {
      try {
        java.sql.Statement st = conexion.createStatement();
        java.sql.ResultSet rs = st.executeQuery("SELECT Jugador, Puntaje, Tiempo_Seg FROM vw_top10_leaderboard LIMIT 10");
        int pos = 1;
        while(rs.next()) {
          rankingTop10.add(pos + ". " + rs.getString("Jugador") + " | Pts: " + rs.getInt("Puntaje") + " | " + rs.getInt("Tiempo_Seg") + "s");
          pos++;
        }
      } catch (Exception e) {
        println("Error cargando Top 10: " + e.getMessage());
      }
    }
  }
}
