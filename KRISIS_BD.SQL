-- ============================================================
-- 0. ELIMINACIÓN DE TABLAS (DROP)
-- ============================================================
DROP TABLE stream_log CASCADE CONSTRAINTS;
DROP TABLE inventario_usuario CASCADE CONSTRAINTS;
DROP TABLE transaccion_pago CASCADE CONSTRAINTS;
DROP TABLE metodo_pago CASCADE CONSTRAINTS;
DROP TABLE beneficio_usuario CASCADE CONSTRAINTS;
DROP TABLE playlist_cancion CASCADE CONSTRAINTS;
DROP TABLE usuario_playlist CASCADE CONSTRAINTS;
DROP TABLE playlist CASCADE CONSTRAINTS;
DROP TABLE cancion_genero CASCADE CONSTRAINTS;
DROP TABLE genero CASCADE CONSTRAINTS;
DROP TABLE cancion_artista CASCADE CONSTRAINTS;
DROP TABLE cancion CASCADE CONSTRAINTS;
DROP TABLE album_artista CASCADE CONSTRAINTS;
DROP TABLE album CASCADE CONSTRAINTS;
DROP TABLE artista CASCADE CONSTRAINTS;
DROP TABLE discografica CASCADE CONSTRAINTS;
DROP TABLE usuario CASCADE CONSTRAINTS;
DROP TABLE cosmetico CASCADE CONSTRAINTS;
DROP TABLE tipo_cosmetico CASCADE CONSTRAINTS;
DROP TABLE pais CASCADE CONSTRAINTS;

-- ============================================================
-- 1. CREACIÓN DE TABLAS (DDL)
-- ============================================================

CREATE TABLE pais (
    id_pais NUMBER CONSTRAINT pais_pk PRIMARY KEY,
    codigo_iso VARCHAR2(3) NOT NULL,
    nombre VARCHAR2(100) NOT NULL
);

CREATE TABLE tipo_cosmetico (
    id_tipo_cosmetico NUMBER CONSTRAINT tipo_cosmetico_pk PRIMARY KEY,
    nombre VARCHAR2(20) NOT NULL
);

CREATE TABLE cosmetico (
    id NUMBER CONSTRAINT cosmetico_pk PRIMARY KEY,
    nombre VARCHAR2(20) NOT NULL,
    valor_hex_url VARCHAR2(7),
    es_premium CHAR(1),
    id_tipo_cosmetico NUMBER NOT NULL,
    CONSTRAINT cosmetico_tipo_cosmetico_fk FOREIGN KEY (id_tipo_cosmetico) REFERENCES tipo_cosmetico(id_tipo_cosmetico)
);

CREATE TABLE usuario (
    id_usuario NUMBER CONSTRAINT usuario_pk PRIMARY KEY,
    nombre_usuario VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL CONSTRAINT usuario_un UNIQUE,
    password VARCHAR2(100) NOT NULL,
    fecha_nacimiento DATE,
    fecha_registro TIMESTAMP,
    pais_id_pais NUMBER NOT NULL,
    es_premium CHAR(1),
    cosmetico_id NUMBER,
    CONSTRAINT usuario_pais_fk FOREIGN KEY (pais_id_pais) REFERENCES pais(id_pais),
    CONSTRAINT usuario_cosmetico_fk FOREIGN KEY (cosmetico_id) REFERENCES cosmetico(id)
);

CREATE TABLE discografica (
    id_discografica NUMBER CONSTRAINT discografica_pk PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    pais_id_pais NUMBER NOT NULL,
    CONSTRAINT discografica_pais_fk FOREIGN KEY (pais_id_pais) REFERENCES pais(id_pais)
);

CREATE TABLE artista (
    id_artista NUMBER CONSTRAINT artista_pk PRIMARY KEY,
    nombre_artistico VARCHAR2(100) NOT NULL,
    biografia VARCHAR2(250),
    verificado CHAR(1)
);

CREATE TABLE album (
    id_album NUMBER CONSTRAINT album_pk PRIMARY KEY,
    titulo VARCHAR2(100) NOT NULL,
    fecha_lanzamiento DATE,
    id_discografica NUMBER NOT NULL,
    CONSTRAINT album_discografica_fk FOREIGN KEY (id_discografica) REFERENCES discografica(id_discografica)
);

CREATE TABLE album_artista (
    artista_id_artista NUMBER NOT NULL,
    album_id_album NUMBER NOT NULL,
    CONSTRAINT relation_24_pk PRIMARY KEY (artista_id_artista, album_id_album),
    CONSTRAINT relation_24_artista_fk FOREIGN KEY (artista_id_artista) REFERENCES artista(id_artista),
    CONSTRAINT relation_24_album_fk FOREIGN KEY (album_id_album) REFERENCES album(id_album)
);

CREATE TABLE cancion (
    id_cancion NUMBER CONSTRAINT cancion_pk PRIMARY KEY,
    titulo VARCHAR2(100) NOT NULL,
    duracion_segundos NUMBER,
    es_explicita CHAR(1),
    id_album NUMBER NOT NULL,
    fecha_lanzamiento_oficial DATE,
    en_acceso_anticipado CHAR(1),
    CONSTRAINT cancion_album_fk FOREIGN KEY (id_album) REFERENCES album(id_album)
);

CREATE TABLE cancion_artista (
    cancion_id_cancion NUMBER NOT NULL,
    artista_id_artista NUMBER NOT NULL,
    CONSTRAINT cancion_artista_pk PRIMARY KEY (cancion_id_cancion, artista_id_artista),
    CONSTRAINT cancion_artista_cancion_fk FOREIGN KEY (cancion_id_cancion) REFERENCES cancion(id_cancion),
    CONSTRAINT cancion_artista_artista_fk FOREIGN KEY (artista_id_artista) REFERENCES artista(id_artista)
);

CREATE TABLE genero (
    id_genero NUMBER CONSTRAINT genero_pk PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL
);

CREATE TABLE cancion_genero (
    cancion_id_cancion NUMBER NOT NULL,
    genero_id_genero NUMBER NOT NULL,
    CONSTRAINT cancion_genero_pk PRIMARY KEY (cancion_id_cancion, genero_id_genero),
    CONSTRAINT cancion_genero_cancion_fk FOREIGN KEY (cancion_id_cancion) REFERENCES cancion(id_cancion),
    CONSTRAINT cancion_genero_genero_fk FOREIGN KEY (genero_id_genero) REFERENCES genero(id_genero)
);

CREATE TABLE playlist (
    id_playlist NUMBER CONSTRAINT playlist_pk PRIMARY KEY,
    titulo VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(250),
    es_publica CHAR(1),
    es_colaborativa CHAR(1),
    fecha_creacion TIMESTAMP
);

CREATE TABLE usuario_playlist (
    usuario_id_usuario NUMBER NOT NULL,
    playlist_id_playlist NUMBER NOT NULL,
    CONSTRAINT relation_27_pk PRIMARY KEY (usuario_id_usuario, playlist_id_playlist),
    CONSTRAINT relation_27_usuario_fk FOREIGN KEY (usuario_id_usuario) REFERENCES usuario(id_usuario),
    CONSTRAINT relation_27_playlist_fk FOREIGN KEY (playlist_id_playlist) REFERENCES playlist(id_playlist)
);

CREATE TABLE playlist_cancion (
    playlist_id_playlist NUMBER NOT NULL,
    cancion_id_cancion NUMBER NOT NULL,
    CONSTRAINT playlist_cancion_pk PRIMARY KEY (playlist_id_playlist, cancion_id_cancion),
    CONSTRAINT playlist_cancion_playlist_fk FOREIGN KEY (playlist_id_playlist) REFERENCES playlist(id_playlist),
    CONSTRAINT playlist_cancion_cancion_fk FOREIGN KEY (cancion_id_cancion) REFERENCES cancion(id_cancion)
);

CREATE TABLE beneficio_usuario (
    id_beneficio NUMBER CONSTRAINT beneficio_usuario_pk PRIMARY KEY,
    usuario_id_usuario NUMBER NOT NULL,
    artista_id_artista NUMBER NOT NULL,
    tipo_beneficio VARCHAR2(100),
    fecha_otorgado TIMESTAMP,
    fecha_expiracion DATE,
    CONSTRAINT beneficio_usuario_usuario_fk FOREIGN KEY (usuario_id_usuario) REFERENCES usuario(id_usuario),
    CONSTRAINT beneficio_usuario_artista_fk FOREIGN KEY (artista_id_artista) REFERENCES artista(id_artista)
);

CREATE TABLE metodo_pago (
    id_metodo_pago NUMBER CONSTRAINT metodo_pago_pk PRIMARY KEY,
    tipo_metodo VARCHAR2(100),
    proveedor_token VARCHAR2(250),
    usuario_id_usuario NUMBER NOT NULL,
    CONSTRAINT metodo_pago_usuario_fk FOREIGN KEY (usuario_id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE transaccion_pago (
    id_pago NUMBER CONSTRAINT transaccion_pago_pk PRIMARY KEY,
    monto NUMBER(10,2),
    moneda VARCHAR2(3),
    fecha_pago TIMESTAMP,
    estado_pago VARCHAR2(50),
    id_metodo_pago NUMBER NOT NULL,
    CONSTRAINT transaccion_pago_metodo_pago_fk FOREIGN KEY (id_metodo_pago) REFERENCES metodo_pago(id_metodo_pago)
);

CREATE TABLE inventario_usuario (
    id NUMBER CONSTRAINT inventario_usuario_pk PRIMARY KEY,
    fecha_adquisicion TIMESTAMP WITH TIME ZONE,
    usuario_id_usuario NUMBER NOT NULL,
    cosmetico_id NUMBER NOT NULL,
    id_pago NUMBER,
    CONSTRAINT inventario_usuario_usuario_fk FOREIGN KEY (usuario_id_usuario) REFERENCES usuario(id_usuario),
    CONSTRAINT inventario_usuario_cosmetico_fk FOREIGN KEY (cosmetico_id) REFERENCES cosmetico(id),
    CONSTRAINT inventario_usuario_transaccion_pago_fk FOREIGN KEY (id_pago) REFERENCES transaccion_pago(id_pago)
);

CREATE TABLE stream_log (
    id_log NUMBER CONSTRAINT stream_log_pk PRIMARY KEY,
    id_usuario NUMBER NOT NULL,
    id_cancion NUMBER NOT NULL,
    fecha_hora TIMESTAMP,
    segundos_reproducidos NUMBER,
    id_pais NUMBER NOT NULL,
    CONSTRAINT stream_log_usuario_fk FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    CONSTRAINT stream_log_cancion_fk FOREIGN KEY (id_cancion) REFERENCES cancion(id_cancion),
    CONSTRAINT stream_log_pais_fk FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
);


-- ============================================================
-- 2. INSERCIÓN DE DATOS DE PRUEBA (DML)
-- ============================================================

-- Paises
INSERT INTO pais (id_pais, codigo_iso, nombre) VALUES (1, 'CHL', 'Chile');
INSERT INTO pais (id_pais, codigo_iso, nombre) VALUES (2, 'ARG', 'Argentina');
INSERT INTO pais (id_pais, codigo_iso, nombre) VALUES (3, 'MEX', 'México');
INSERT INTO pais (id_pais, codigo_iso, nombre) VALUES (4, 'COL', 'Colombia');
INSERT INTO pais (id_pais, codigo_iso, nombre) VALUES (5, 'ESP', 'España');

-- Tipo Cosmetico
INSERT INTO tipo_cosmetico (id_tipo_cosmetico, nombre) VALUES (1, 'Marco Perfil');
INSERT INTO tipo_cosmetico (id_tipo_cosmetico, nombre) VALUES (2, 'Insignia');
INSERT INTO tipo_cosmetico (id_tipo_cosmetico, nombre) VALUES (3, 'Fondo Perfil');

-- Cosmetico
INSERT INTO cosmetico (id, nombre, valor_hex_url, es_premium, id_tipo_cosmetico) VALUES (100, 'Marco Dorado', '#FFD700', '1', 1);
INSERT INTO cosmetico (id, nombre, valor_hex_url, es_premium, id_tipo_cosmetico) VALUES (101, 'Insignia VIP', '#0000FF', '0', 2);
INSERT INTO cosmetico (id, nombre, valor_hex_url, es_premium, id_tipo_cosmetico) VALUES (102, 'Fondo Neón', '#39FF14', '1', 3);
INSERT INTO cosmetico (id, nombre, valor_hex_url, es_premium, id_tipo_cosmetico) VALUES (103, 'Insignia Fundador', '#C0C0C0', '1', 2);

-- Usuario
INSERT INTO usuario (id_usuario, nombre_usuario, email, password, fecha_nacimiento, fecha_registro, pais_id_pais, es_premium, cosmetico_id) 
VALUES (1, 'jdoe', 'jdoe@example.com', 'hashed_pass_123', TO_DATE('1995-05-15', 'YYYY-MM-DD'), SYSTIMESTAMP, 1, '1', 100);
INSERT INTO usuario (id_usuario, nombre_usuario, email, password, fecha_nacimiento, fecha_registro, pais_id_pais, es_premium, cosmetico_id) 
VALUES (2, 'mrossi', 'mrossi@example.com', 'hashed_pass_456', TO_DATE('1998-10-20', 'YYYY-MM-DD'), SYSTIMESTAMP, 2, '0', NULL);
INSERT INTO usuario (id_usuario, nombre_usuario, email, password, fecha_nacimiento, fecha_registro, pais_id_pais, es_premium, cosmetico_id) 
VALUES (3, 'agarcia', 'agarcia@example.com', 'hashed_pass_789', TO_DATE('2001-02-10', 'YYYY-MM-DD'), SYSTIMESTAMP, 3, '1', 102);
INSERT INTO usuario (id_usuario, nombre_usuario, email, password, fecha_nacimiento, fecha_registro, pais_id_pais, es_premium, cosmetico_id) 
VALUES (4, 'llopez', 'llopez@example.com', 'hashed_pass_321', TO_DATE('1990-12-05', 'YYYY-MM-DD'), SYSTIMESTAMP, 5, '1', 103);

-- Discografica
INSERT INTO discografica (id_discografica, nombre, pais_id_pais) VALUES (1, 'Sony Music', 3);
INSERT INTO discografica (id_discografica, nombre, pais_id_pais) VALUES (2, 'Universal Music', 1);
INSERT INTO discografica (id_discografica, nombre, pais_id_pais) VALUES (3, 'Warner Music', 5);
INSERT INTO discografica (id_discografica, nombre, pais_id_pais) VALUES (4, 'EMI Records', 2);

-- Artista
INSERT INTO artista (id_artista, nombre_artistico, biografia, verificado) VALUES (1, 'Los Prisioneros', 'Banda chilena de rock/pop rock.', '1');
INSERT INTO artista (id_artista, nombre_artistico, biografia, verificado) VALUES (2, 'Soda Stereo', 'Banda argentina de rock alternativo.', '1');
INSERT INTO artista (id_artista, nombre_artistico, biografia, verificado) VALUES (3, 'Rosalía', 'Cantante y compositora española.', '1');
INSERT INTO artista (id_artista, nombre_artistico, biografia, verificado) VALUES (4, 'Charly García', 'Músico, cantautor y productor argentino.', '1');

-- Album
INSERT INTO album (id_album, titulo, fecha_lanzamiento, id_discografica) VALUES (1, 'Corazones', TO_DATE('1990-05-20', 'YYYY-MM-DD'), 2);
INSERT INTO album (id_album, titulo, fecha_lanzamiento, id_discografica) VALUES (2, 'Canción Animal', TO_DATE('1990-08-07', 'YYYY-MM-DD'), 1);
INSERT INTO album (id_album, titulo, fecha_lanzamiento, id_discografica) VALUES (3, 'El Mal Querer', TO_DATE('2018-11-02', 'YYYY-MM-DD'), 1);
INSERT INTO album (id_album, titulo, fecha_lanzamiento, id_discografica) VALUES (4, 'Clics Modernos', TO_DATE('1983-11-05', 'YYYY-MM-DD'), 4);

-- Album Artista
INSERT INTO album_artista (artista_id_artista, album_id_album) VALUES (1, 1);
INSERT INTO album_artista (artista_id_artista, album_id_album) VALUES (2, 2);
INSERT INTO album_artista (artista_id_artista, album_id_album) VALUES (3, 3);
INSERT INTO album_artista (artista_id_artista, album_id_album) VALUES (4, 4);

-- Cancion
INSERT INTO cancion (id_cancion, titulo, duracion_segundos, es_explicita, id_album, fecha_lanzamiento_oficial, en_acceso_anticipado) 
VALUES (10, 'Tren al Sur', 336, '0', 1, TO_DATE('1990-05-20', 'YYYY-MM-DD'), '0');
INSERT INTO cancion (id_cancion, titulo, duracion_segundos, es_explicita, id_album, fecha_lanzamiento_oficial, en_acceso_anticipado) 
VALUES (20, 'De Música Ligera', 212, '0', 2, TO_DATE('1990-08-07', 'YYYY-MM-DD'), '0');
INSERT INTO cancion (id_cancion, titulo, duracion_segundos, es_explicita, id_album, fecha_lanzamiento_oficial, en_acceso_anticipado) 
VALUES (30, 'Malamente', 150, '1', 3, TO_DATE('2018-05-30', 'YYYY-MM-DD'), '0');
INSERT INTO cancion (id_cancion, titulo, duracion_segundos, es_explicita, id_album, fecha_lanzamiento_oficial, en_acceso_anticipado) 
VALUES (40, 'Nos Siguen Pegando Abajo', 208, '0', 4, TO_DATE('1983-11-05', 'YYYY-MM-DD'), '0');

-- Cancion Artista
INSERT INTO cancion_artista (cancion_id_cancion, artista_id_artista) VALUES (10, 1);
INSERT INTO cancion_artista (cancion_id_cancion, artista_id_artista) VALUES (20, 2);
INSERT INTO cancion_artista (cancion_id_cancion, artista_id_artista) VALUES (30, 3);
INSERT INTO cancion_artista (cancion_id_cancion, artista_id_artista) VALUES (40, 4);

-- Genero
INSERT INTO genero (id_genero, nombre) VALUES (1, 'Rock en Español');
INSERT INTO genero (id_genero, nombre) VALUES (2, 'Synthpop');
INSERT INTO genero (id_genero, nombre) VALUES (3, 'Nuevo Flamenco');
INSERT INTO genero (id_genero, nombre) VALUES (4, 'New Wave');

-- Cancion Genero
INSERT INTO cancion_genero (cancion_id_cancion, genero_id_genero) VALUES (10, 2);
INSERT INTO cancion_genero (cancion_id_cancion, genero_id_genero) VALUES (20, 1);
INSERT INTO cancion_genero (cancion_id_cancion, genero_id_genero) VALUES (30, 3);
INSERT INTO cancion_genero (cancion_id_cancion, genero_id_genero) VALUES (40, 4);

-- Playlist
INSERT INTO playlist (id_playlist, titulo, descripcion, es_publica, es_colaborativa, fecha_creacion) 
VALUES (500, 'Lo mejor del Rock 90s', 'Canciones destacadas de la década.', '1', '0', SYSTIMESTAMP);
INSERT INTO playlist (id_playlist, titulo, descripcion, es_publica, es_colaborativa, fecha_creacion) 
VALUES (501, 'Clásicos Iberoamericanos', 'Joyas musicales en español.', '1', '1', SYSTIMESTAMP);
INSERT INTO playlist (id_playlist, titulo, descripcion, es_publica, es_colaborativa, fecha_creacion) 
VALUES (502, 'Vibes Privadas', 'Solo para mí.', '0', '0', SYSTIMESTAMP);

-- Usuario Playlist
INSERT INTO usuario_playlist (usuario_id_usuario, playlist_id_playlist) VALUES (1, 500);
INSERT INTO usuario_playlist (usuario_id_usuario, playlist_id_playlist) VALUES (3, 501);
INSERT INTO usuario_playlist (usuario_id_usuario, playlist_id_playlist) VALUES (4, 502);

-- Playlist Cancion
INSERT INTO playlist_cancion (playlist_id_playlist, cancion_id_cancion) VALUES (500, 10);
INSERT INTO playlist_cancion (playlist_id_playlist, cancion_id_cancion) VALUES (500, 20);
INSERT INTO playlist_cancion (playlist_id_playlist, cancion_id_cancion) VALUES (501, 10);
INSERT INTO playlist_cancion (playlist_id_playlist, cancion_id_cancion) VALUES (501, 30);
INSERT INTO playlist_cancion (playlist_id_playlist, cancion_id_cancion) VALUES (501, 40);
INSERT INTO playlist_cancion (playlist_id_playlist, cancion_id_cancion) VALUES (502, 30);

-- Beneficio Usuario
INSERT INTO beneficio_usuario (id_beneficio, usuario_id_usuario, artista_id_artista, tipo_beneficio, fecha_otorgado, fecha_expiracion) 
VALUES (1, 1, 1, 'Pase de Fan Destacado', SYSTIMESTAMP, TO_DATE('2026-12-31', 'YYYY-MM-DD'));
INSERT INTO beneficio_usuario (id_beneficio, usuario_id_usuario, artista_id_artista, tipo_beneficio, fecha_otorgado, fecha_expiracion) 
VALUES (2, 3, 3, 'Pre-venta Exclusiva', SYSTIMESTAMP, TO_DATE('2026-10-01', 'YYYY-MM-DD'));

-- Metodo Pago
INSERT INTO metodo_pago (id_metodo_pago, tipo_metodo, proveedor_token, usuario_id_usuario) 
VALUES (1, 'Tarjeta de Crédito', 'tok_visa_abc123', 1);
INSERT INTO metodo_pago (id_metodo_pago, tipo_metodo, proveedor_token, usuario_id_usuario) 
VALUES (2, 'PayPal', 'tok_paypal_xyz987', 3);
INSERT INTO metodo_pago (id_metodo_pago, tipo_metodo, proveedor_token, usuario_id_usuario) 
VALUES (3, 'Tarjeta de Débito', 'tok_mc_def456', 4);

-- Transaccion Pago
INSERT INTO transaccion_pago (id_pago, monto, moneda, fecha_pago, estado_pago, id_metodo_pago) 
VALUES (1, 9.99, 'USD', SYSTIMESTAMP, 'COMPLETED', 1);
INSERT INTO transaccion_pago (id_pago, monto, moneda, fecha_pago, estado_pago, id_metodo_pago) 
VALUES (2, 14.99, 'EUR', SYSTIMESTAMP, 'COMPLETED', 2);
INSERT INTO transaccion_pago (id_pago, monto, moneda, fecha_pago, estado_pago, id_metodo_pago) 
VALUES (3, 9.99, 'USD', SYSTIMESTAMP, 'PENDING', 3);

-- Inventario Usuario
INSERT INTO inventario_usuario (id, fecha_adquisicion, usuario_id_usuario, cosmetico_id, id_pago) 
VALUES (1, CURRENT_TIMESTAMP, 1, 100, 1);
INSERT INTO inventario_usuario (id, fecha_adquisicion, usuario_id_usuario, cosmetico_id, id_pago) 
VALUES (2, CURRENT_TIMESTAMP, 3, 102, 2);
INSERT INTO inventario_usuario (id, fecha_adquisicion, usuario_id_usuario, cosmetico_id, id_pago) 
VALUES (3, CURRENT_TIMESTAMP, 4, 103, NULL);

-- Stream Log
INSERT INTO stream_log (id_log, id_usuario, id_cancion, fecha_hora, segundos_reproducidos, id_pais) 
VALUES (1, 1, 10, SYSTIMESTAMP, 336, 1);
INSERT INTO stream_log (id_log, id_usuario, id_cancion, fecha_hora, segundos_reproducidos, id_pais) 
VALUES (2, 2, 20, SYSTIMESTAMP, 100, 2);
INSERT INTO stream_log (id_log, id_usuario, id_cancion, fecha_hora, segundos_reproducidos, id_pais) 
VALUES (3, 3, 30, SYSTIMESTAMP, 150, 5);
INSERT INTO stream_log (id_log, id_usuario, id_cancion, fecha_hora, segundos_reproducidos, id_pais) 
VALUES (4, 4, 40, SYSTIMESTAMP, 200, 3);
INSERT INTO stream_log (id_log, id_usuario, id_cancion, fecha_hora, segundos_reproducidos, id_pais) 
VALUES (5, 1, 20, SYSTIMESTAMP, 212, 1);

COMMIT;