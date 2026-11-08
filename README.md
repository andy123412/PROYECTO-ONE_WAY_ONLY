# PROYECTO-ONE_WAY_ONLY
Bitácora de Desarrollo: Proyecto "ONE WAY ONLY"
Alumno: Andy Sandoval Ruiz
Período: Agosto 2026 – Noviembre 2026
Entorno / Lenguaje: Processing 4.5.5 (Java), MySQL (DBeaver)

Semana 1 (Principios de Agosto)
Objetivo: Planificación y setup del motor base.

Se aprobó el documento de propuesta del proyecto.

Se estableció la estructura principal del juego basada en el paradigma de Programación Orientada a Objetos (POO).

Se crearon las clases iniciales: sketch.pde (bucle principal) y Jugador.pde.

Implementación de un motor de físicas rudimentario aplicando vectores de velocidad (PVector), gravedad y saltos.

Semana 2 (Mediados de Agosto)
Objetivo: Generación dinámica del mundo.

Se descartó la idea de hacer niveles "harcodeados" para crear un sistema escalable.

Se desarrolló la clase CargadorCSV.pde para parsear matrices de texto y renderizar bloques en pantalla (1: pasto, 2: tierra, 4: roca, 5: castillo).

Implementación de colisiones ortogonales (AABB - Axis-Aligned Bounding Box) entre el jugador y los bloques estructurales del CSV.

Semana 3 (Fines de Agosto)
Objetivo: Cámara y sistema de combate.

Integración del efecto de Side-Scrolling manipulando la matriz de transformación global mediante translate(camaraX, 0).

Creación de la clase Armamento.pde con durabilidad independiente para Espada (100%) y Escudo (100%).

Implementación del HUD superior con barras de texto estadístico, anclando los elementos de la interfaz a la cámara para que no se desplacen con el mapa.

Semana 4 (Principios de Septiembre)
Objetivo: Desarrollo del primer enemigo y sistema de partículas.

Creación de la clase TortugaPerseguidora.pde (Entidad ID 6 en el CSV) con IA básica de patrullaje direccional.

Se programó la lógica de daño mitigado (el escudo reduce el impacto del enemigo a un 20%).

Desarrollo de la clase SistemaParticulas.pde para generar retroalimentación visual (chispas amarillas) cuando el jugador bloquea exitosamente un ataque.

Semana 5 (Mediados de Septiembre)
Objetivo: Entidades complejas y patrón de composición.

Programación del Lucky Block (Bloque ID 8), con sistema RNG para otorgar recompensas aleatorias (Vida, Llave Inglesa, Fuego, Estrella).

Desarrollo de la PlantaCarnivora.pde (Entidad ID 10). Se aplicó un patrón de composición en el CSV: el renderizado dibuja primero el tallo subiendo y bajando con un temporizador millis(), y luego dibuja la textura estática de la tubería para ocultarla.

Corrección de un bug visual donde las plantas se movían junto con el HUD al caminar (se solucionó reordenando la llamada de las plantas debajo del translate de la cámara).

Semana 6 (Fines de Septiembre)
Objetivo: Pulido de físicas y solución de bugs críticos ("Wall Zip").

Se detectó un error grave de Tunneling (los enemigos atravesaban las montañas o se teletransportaban a la cima al chocar entre sí).

Se reescribió por completo el motor de físicas de los enemigos implementando Resolución por Centroides: el código ahora calcula de qué lado de la pared está el centro del enemigo para empujarlo en la dirección correcta.

Se implementó una "separación suave" modificando los vectores de velocidad cuando dos tortugas chocan, evitando que se superpongan violentamente.

Semana 7 (Principios de Octubre)
Objetivo: Diseño del Jefe Final y diseño de nivel avanzado.

Creación de la clase Jefe.pde (Entidad ID 7), con mayor cantidad de vida, hitboxes más grandes y mecánicas de ataque por proximidad.

Construcción del archivo mapa1.csv definitivo: un nivel masivo de 160x15 bloques distribuido en 4 biomas (Pradera, Bosque oscuro con parkour, Cañón Rocoso con precipicios, y el Castillo de la arena final).

Semana 8 (Mediados de Octubre)
Objetivo: Backend y persistencia de datos (MySQL).

Diseño de la base de datos relacional one_way_only_db normalizada en 3FN.

Creación de tablas catálogo (Biomas, Enemigos, Recompensas) y tablas transaccionales (Partidas, Bajas, Ítems obtenidos).

Programación de automatizaciones en SQL: Triggers BEFORE INSERT para evitar puntajes o vidas negativas, y vistas (vw_top10_leaderboard) para agrupar estadísticas mediante INNER JOIN.

Semana 9 (Fines de Octubre)
Objetivo: Conectividad JDBC y resolución de ambigüedades.

Integración del driver mysql-connector-j-8.0.33.jar en la carpeta /code.

Desarrollo de ConexionBD.pde aplicando consultas seguras (PreparedStatement) para insertar los resultados (Victoria/Game Over) a la base de datos local en XAMPP.

Se resolvieron errores de compilación por colisión de nombres (Ambigüedad) forzando el tipado absoluto estricto: processing.data.Table para los mapas CSV y java.sql.Statement para las consultas a la base de datos.

Semana 10 
Objetivo: Sistema de inventario, refinamiento visual.

Desarrollo de un inventario dinámico de 2 slots en el HUD, navegable con las flechas (Izquierda/Derecha) y operable con la tecla ENTER.

Semana 11 (Finales de Octubre - Principios de Noviembre)
Objetivo: Profundidad visual procedimental y entorno dinámico (Estilo Voxel/Terraria).

Se descartó el uso de fondos de colores planos o imágenes estáticas para desarrollar un motor de renderizado de Parallax Scrolling de 4 capas independientes (Montañas nevadas, Bosque oscuro, Colinas y Río).

Implementación de Ruido Perlin (noise()) para la generación matemática y orgánica del terreno, logrando picos, valles y colocación aleatoria de árboles sin patrones repetitivos.

Se desarrolló un algoritmo de "Snapping" basado en funciones de redondeo (floor(camaraX / step) * step) para forzar que el escenario mantenga una forma estrictamente cuadrada (estilo pixel-art) independientemente de los movimientos decimales del jugador.

Resolución de errores de Tearing (desgarro de pantalla o parpadeo de líneas blancas entre columnas) sumando un píxel extra de solapamiento en el renderizado (step + 1).

Se aplicó física independiente al cuerpo de agua frontal, utilizando millis() para que la corriente fluya de manera constante hacia la derecha, independientemente de la posición de la cámara.

Semana 12 
Objetivo: Interfaz de Opciones (UI), navegación de menús y versión candidata (V 1.6).

Integración del sistema de Parallax en la pantalla de título principal, utilizando una cámara autónoma negativa para crear un fondo cinemático en movimiento continuo con un filtro de desenfoque (filter(BLUR)).

Desarrollo del sub-menú "Opciones y Controles" estructurado en una cuadrícula simétrica de 3x3 (Grid) para mostrar de forma limpia los mapeos de teclado (Movimiento, Combate e Inventario).

Creación de un renderizador dinámico de interfaz gráfica para los botones de las teclas que calcula automáticamente su tamaño en base a la longitud de la cadena de texto (textWidth()), permitiendo acomodar palabras completas como "ENTER".

Refactorización y ajuste matemático de los eventos de ratón (mousePressed()) para asegurar que las cajas de colisión (Hitboxes) coincidan perfectamente con el diseño visual del menú principal y el botón "Volver".

Cierre de la compilación de la versión V 1.6 del proyecto.

Programación del estado de victoria cinemático aplicando filtros nativos (filter(BLUR)) sobre el último fotograma del castillo para resaltar el texto de conclusión.

Depuración final del código, empaquetado del archivo ejecutable .exe y redacción de la documentación para la defensa técnica oral.

Semana 13 (Mediados de Noviembre)Objetivo: Sistema de audio profesional, UI de Pausa y persistencia en tiempo real.

Integración de la librería ddf.minim para la gestión de audio. Se desarrolló la clase GestorAudio.pde centralizando la música ambiental y los efectos de sonido (SFX).

Se migraron los archivos de sonido de formato .mp3 a .wav para eliminar por completo la latencia en las colisiones, el error "Metralleta" de superposición de canales (Stacking) y las excepciones nativas por metadatos (ID3 TXXX).

Se diseñó una interfaz gráfica in-game para el Menú de Pausa (Estado 5), capturando un frame activo del juego mediante la función get() y aplicando un filtro gaussiano (filter(BLUR)) para generar un fondo borroso cinemático.

Implementación de un Slider lineal (barra de volumen) deslizable con el mouse en el menú de opciones. Se aplicó mapeo matemático (map()) para convertir la posición horizontal (X) del ratón en valores decibélicos precisos (-40dB a 0dB) para el motor de Minim.

Desarrollo de un sistema de guardado local mediante "Casilleros" (Slots). Se programaron arrays temporales para guardar instantáneamente la posición en el eje X, nivel actual, estadísticas de vida y durabilidad de armas cuando el usuario retorna al menú principal.

Resolución de un bug de "Música Fantasma" y speedrun donde los soundtracks del nivel y del jefe se solapaban al reiniciar casilleros. Se solucionó programando un método de vaciado de buffers (rewind() y pause()) previo a la llamada de cada pista nueva.
