-- =====================================================================
-- BASE DE DATOS: ONE WAY ONLY
-- Cumple rúbrica AGBA: 3FN, CHECK, UNIQUE, INDEX, Triggers, Vistas y SP
-- =====================================================================

DROP DATABASE IF EXISTS one_way_only_db;
CREATE DATABASE one_way_only_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE one_way_only_db;

-- 1. TABLAS CATÁLOGO (Garantizan la 3FN)
CREATE TABLE ZONAS_BIOMAS (
    id_zona INT PRIMARY KEY,
    nombre_bioma VARCHAR(50) NOT NULL UNIQUE, -- Requisito AGBA: UNIQUE
    archivo_csv VARCHAR(50) NOT NULL,
    rango_columnas VARCHAR(30) NOT NULL
);

CREATE TABLE CATALOGO_RECOMPENSAS (
    id_recompensa INT PRIMARY KEY,
    nombre_recompensa VARCHAR(60) NOT NULL UNIQUE,
    efecto_mecanico VARCHAR(150) NOT NULL
);

CREATE TABLE CATALOGO_ENEMIGOS (
    id_enemigo INT AUTO_INCREMENT PRIMARY KEY,
    nombre_enemigo VARCHAR(50) NOT NULL UNIQUE,
    vida_base FLOAT NOT NULL CHECK (vida_base > 0), -- Requisito AGBA: CHECK
    dano_base FLOAT NOT NULL CHECK (dano_base >= 0),
    puntos_otorgados INT NOT NULL CHECK (puntos_otorgados >= 0)
);

-- 2. TABLAS PRINCIPALES
CREATE TABLE JUGADORES (
    id_jugador INT AUTO_INCREMENT PRIMARY KEY,
    nickname VARCHAR(30) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE PARTIDAS (
    id_partida INT AUTO_INCREMENT PRIMARY KEY,
    id_jugador INT NOT NULL,
    id_zona_maxima INT NOT NULL,
    puntaje_obtenido INT NOT NULL DEFAULT 0 CHECK (puntaje_obtenido >= 0),
    vida_restante FLOAT NOT NULL DEFAULT 0 CHECK (vida_restante >= 0 AND vida_restante <= 100),
    durabilidad_espada_final FLOAT NOT NULL DEFAULT 100 CHECK (durabilidad_espada_final >= 0),
    durabilidad_escudo_final FLOAT NOT NULL DEFAULT 100 CHECK (durabilidad_escudo_final >= 0),
    tiempo_supervivencia_seg INT NOT NULL CHECK (tiempo_supervivencia_seg >= 0),
    jefe_derrotado BOOLEAN NOT NULL DEFAULT FALSE,
    estado_final ENUM('VICTORIA', 'GAME_OVER') NOT NULL,
    fecha_partida DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_partida_jugador FOREIGN KEY (id_jugador) REFERENCES JUGADORES(id_jugador) ON DELETE CASCADE,
    CONSTRAINT fk_partida_zona FOREIGN KEY (id_zona_maxima) REFERENCES ZONAS_BIOMAS(id_zona)
);

-- Requisito AGBA: Índices para optimizar búsquedas
CREATE INDEX idx_partidas_jugador ON PARTIDAS(id_jugador);
CREATE INDEX idx_partidas_puntaje ON PARTIDAS(puntaje_obtenido DESC);

-- 3. TABLAS TRANSACCIONALES (Rompen Muchos a Muchos)
CREATE TABLE RECOMPENSAS_OBTENIDAS (
    id_registro_recompensa INT AUTO_INCREMENT PRIMARY KEY,
    id_partida INT NOT NULL,
    id_recompensa INT NOT NULL,
    minuto_obtencion_seg INT NOT NULL CHECK (minuto_obtencion_seg >= 0),
    CONSTRAINT fk_rec_partida FOREIGN KEY (id_partida) REFERENCES PARTIDAS(id_partida) ON DELETE CASCADE,
    CONSTRAINT fk_rec_catalogo FOREIGN KEY (id_recompensa) REFERENCES CATALOGO_RECOMPENSAS(id_recompensa)
);

CREATE TABLE BAJAS_POR_PARTIDA (
    id_partida INT NOT NULL,
    id_enemigo INT NOT NULL,
    cantidad_eliminados INT NOT NULL DEFAULT 1 CHECK (cantidad_eliminados > 0),
    PRIMARY KEY (id_partida, id_enemigo),
    CONSTRAINT fk_baja_partida FOREIGN KEY (id_partida) REFERENCES PARTIDAS(id_partida) ON DELETE CASCADE,
    CONSTRAINT fk_baja_enemigo FOREIGN KEY (id_enemigo) REFERENCES CATALOGO_ENEMIGOS(id_enemigo)
);

-- Tabla de Auditoría
CREATE TABLE AUDITORIA_PUNTAJES (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_partida INT NOT NULL,
    id_jugador INT NOT NULL,
    puntaje_anterior INT NOT NULL,
    puntaje_nuevo INT NOT NULL,
    vida_anterior FLOAT NOT NULL,
    vida_nueva FLOAT NOT NULL,
    usuario_bd VARCHAR(80) NOT NULL,
    fecha_modificacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 4. PROGRAMABILIDAD (Triggers y Procedures)
DELIMITER //

CREATE TRIGGER trg_validar_partida_before_insert
BEFORE INSERT ON PARTIDAS
FOR EACH ROW
BEGIN
    IF NEW.vida_restante < 0 THEN SET NEW.vida_restante = 0; END IF;
    IF NEW.vida_restante > 100 THEN SET NEW.vida_restante = 100; END IF;
    IF NEW.puntaje_obtenido < 0 THEN SET NEW.puntaje_obtenido = 0; END IF;
    IF NEW.durabilidad_espada_final < 0 THEN SET NEW.durabilidad_espada_final = 0; END IF;
    IF NEW.durabilidad_escudo_final < 0 THEN SET NEW.durabilidad_escudo_final = 0; END IF;
    
    IF NEW.jefe_derrotado = TRUE THEN
        SET NEW.estado_final = 'VICTORIA';
        SET NEW.id_zona_maxima = 4;
    ELSEIF NEW.vida_restante = 0 THEN
        SET NEW.estado_final = 'GAME_OVER';
    END IF;
END //

CREATE TRIGGER trg_auditar_modificacion_puntaje
AFTER UPDATE ON PARTIDAS
FOR EACH ROW
BEGIN
    IF OLD.puntaje_obtenido <> NEW.puntaje_obtenido OR OLD.vida_restante <> NEW.vida_restante THEN
        INSERT INTO AUDITORIA_PUNTAJES (id_partida, id_jugador, puntaje_anterior, puntaje_nuevo, vida_anterior, vida_nueva, usuario_bd)
        VALUES (OLD.id_partida, OLD.id_jugador, OLD.puntaje_obtenido, NEW.puntaje_obtenido, OLD.vida_restante, NEW.vida_restante, CURRENT_USER());
    END IF;
END //

-- Requisito AGBA: Procedimiento Almacenado de Reporte
CREATE PROCEDURE sp_reporte_jugador(IN p_nickname VARCHAR(30))
BEGIN
    SELECT 
        p.id_partida,
        z.nombre_bioma AS Llego_Hasta,
        p.puntaje_obtenido AS Puntaje,
        p.estado_final AS Estado,
        IFNULL(SUM(b.cantidad_eliminados), 0) AS Total_Enemigos_Derrotados
    FROM PARTIDAS p
    INNER JOIN JUGADORES j ON p.id_jugador = j.id_jugador
    INNER JOIN ZONAS_BIOMAS z ON p.id_zona_maxima = z.id_zona
    LEFT JOIN BAJAS_POR_PARTIDA b ON p.id_partida = b.id_partida
    WHERE j.nickname = p_nickname
    GROUP BY p.id_partida, z.nombre_bioma, p.puntaje_obtenido, p.estado_final;
END //

DELIMITER ;

-- 5. VISTAS REQUERIDAS
CREATE VIEW vw_top10_leaderboard AS
SELECT 
    j.nickname AS Jugador, p.puntaje_obtenido AS Puntaje, z.nombre_bioma AS Zona_Alcanzada,
    p.vida_restante AS HP_Final, p.tiempo_supervivencia_seg AS Tiempo_Seg, p.estado_final AS Resultado,
    DATE_FORMAT(p.fecha_partida, '%d/%m/%Y %H:%i') AS Fecha
FROM PARTIDAS p
INNER JOIN JUGADORES j ON p.id_jugador = j.id_jugador
INNER JOIN ZONAS_BIOMAS z ON p.id_zona_maxima = z.id_zona
ORDER BY p.puntaje_obtenido DESC, p.tiempo_supervivencia_seg ASC LIMIT 10;

CREATE VIEW vw_estadisticas_jugadores AS
SELECT 
    j.nickname AS Jugador, COUNT(p.id_partida) AS Partidas_Jugadas,
    SUM(CASE WHEN p.estado_final = 'VICTORIA' THEN 1 ELSE 0 END) AS Victorias_Totales,
    MAX(p.puntaje_obtenido) AS Record_Personal,
    ROUND(AVG(p.durabilidad_espada_final), 1) AS Promedio_Integridad_Espada,
    ROUND(AVG(p.durabilidad_escudo_final), 1) AS Promedio_Integridad_Escudo
FROM JUGADORES j LEFT JOIN PARTIDAS p ON j.id_jugador = p.id_jugador GROUP BY j.id_jugador, j.nickname;

CREATE VIEW vw_uso_recompensas AS
SELECT 
    cr.nombre_recompensa AS Poder_Lucky_Block, cr.efecto_mecanico AS Efecto,
    COUNT(ro.id_registro_recompensa) AS Veces_Desbloqueado
FROM CATALOGO_RECOMPENSAS cr LEFT JOIN RECOMPENSAS_OBTENIDAS ro ON cr.id_recompensa = ro.id_recompensa
GROUP BY cr.id_recompensa, cr.nombre_recompensa, cr.efecto_mecanico ORDER BY Veces_Desbloqueado DESC;

-- 6. INSERCIÓN DE DATOS (DML)
INSERT INTO ZONAS_BIOMAS VALUES
(1, 'Jardín / Pradera', 'mapa1.csv', 'Columnas 0 a 39'),
(2, 'Bosque Oscuro', 'mapa1.csv', 'Columnas 40 a 79'),
(3, 'Zona Rocosa / Cañón', 'mapa1.csv', 'Columnas 80 a 119'),
(4, 'Castillo Final', 'mapa1.csv', 'Columnas 120 a 159');

INSERT INTO CATALOGO_RECOMPENSAS VALUES
(1, 'Corazón de Vida', 'Restaura la vida del jugador al 100% (100 HP)'),
(2, 'Llave Inglesa', 'Repara durabilidadEspada y durabilidadEscudo al 100%'),
(3, 'Flor de Fuego', 'Desbloquea BolaFuego en tecla L con cooldown de 5s y TTL de 2.5s'),
(4, 'Estrella de Invulnerabilidad', 'Inmunidad total e insta-kill al contacto durante 10 segundos');

INSERT INTO CATALOGO_ENEMIGOS (nombre_enemigo, vida_base, dano_base, puntos_otorgados) VALUES
('Tortuga Perseguidora (ID 6)', 40.0, 5.0, 20),
('Planta Carnívora de Tubería (ID 10)', 40.0, 15.0, 30),
('Jefe Final del Castillo (ID 7)', 200.0, 10.0, 100);

INSERT INTO JUGADORES (nickname, email) VALUES
('Andy_Dev', 'andy.sandoval@escuela.edu.ar'),
('ShadowRunner', 'shadow@mail.com'),
('MarioMaster99', 'mario99@mail.com'),
('PixelKnight', 'knight@mail.com');

INSERT INTO PARTIDAS (id_jugador, id_zona_maxima, puntaje_obtenido, vida_restante, durabilidad_espada_final, durabilidad_escudo_final, tiempo_supervivencia_seg, jefe_derrotado, estado_final) VALUES
(1, 4, 380, 65.0, 45.0, 60.0, 142, TRUE, 'VICTORIA'),
(2, 3, 190, 0.0, 20.0, 0.0, 98, FALSE, 'GAME_OVER'),
(3, 4, 340, 20.0, 15.0, 10.0, 165, TRUE, 'VICTORIA'),
(4, 2, 80, 0.0, 75.0, 40.0, 54, FALSE, 'GAME_OVER'),
(1, 4, 420, 100.0, 80.0, 85.0, 118, TRUE, 'VICTORIA');

INSERT INTO RECOMPENSAS_OBTENIDAS (id_partida, id_recompensa, minuto_obtencion_seg) VALUES
(1, 3, 18), (1, 2, 75), (1, 4, 125), (2, 1, 25), (2, 3, 60),
(3, 2, 40), (3, 1, 110), (5, 3, 12), (5, 4, 95), (5, 2, 105);

INSERT INTO BAJAS_POR_PARTIDA VALUES
(1, 1, 9), (1, 2, 4), (1, 3, 1), (2, 1, 5), (2, 2, 3), (5, 1, 10), (5, 2, 4), (5, 3, 1);

-- Fuerza el Trigger de Auditoría
UPDATE PARTIDAS SET puntaje_obtenido = 999 WHERE id_partida = 4;