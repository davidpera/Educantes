------------------------------
-- Archivo de base de datos --
------------------------------

DROP TABLE IF EXISTS uniformes CASCADE;

CREATE TABLE uniformes
(
    id          bigserial       PRIMARY KEY
  , codigo      varchar(255)    NOT NULL
  , descripcion varchar(255)    NOT NULL
  , talla       varchar(255)    NOT NULL
  , precio      numeric(5,2)    NOT NULL
  , iva         numeric(3)      NOT NULL
  , ubicacion   varchar(255)
  , cantidad    numeric(10)     NOT NULL
  , underSS     bool            DEFAULT false
  , colegio_id  bigint          NOT NULL REFERENCES colegios (id)
                                ON DELETE NO ACTION ON UPDATE CASCADE
);

DROP TABLE IF EXISTS secstocks CASCADE;

CREATE TABLE secstocks
(
    id          bigserial       PRIMARY KEY
  , CD          numeric(10)     NOT NULL --consumo diario
  , PE          numeric(10)     NOT NULL --numero de dias que tarda en llegar del proveedor
  , SS          numeric(10)     NOT NULL --Security Stock, determinado por el usuario
  , MP          numeric(10)     NOT NULL --Momento de pedido, calculado de los datos anteriores
  , uniforme_id bigint          NOT NULL REFERENCES uniformes (id)
                                ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS colegios CASCADE;

CREATE TABLE colegios
(
    id          bigserial       PRIMARY KEY
  , cif         char(9)         NOT NULL UNIQUE
  , nombre      varchar(255)    NOT NULL UNIQUE
  , email       varchar(255)    NOT NULL UNIQUE
  , cod_postal  numeric(5)      NOT NULL
  , direccion   varchar(255)    NOT NULL
);

DROP TABLE IF EXISTS libros CASCADE;

CREATE TABLE libros
(
    id          bigserial       PRIMARY KEY
  , isbn        numeric(13)     NOT NULL
  , titulo      varchar(255)    NOT NULL
  , curso       varchar(255)    NOT NULL
  , precio      numeric(5,2)    NOT NULL
  , colegio_id  bigint          NOT NULL REFERENCES colegios (id)
                                ON DELETE NO ACTION ON UPDATE CASCADE
);

DROP TABLE IF EXISTS tutores CASCADE;

CREATE TABLE tutores
(
    id          bigserial       PRIMARY KEY
  , nif         char(9)         NOT NULL
  , nombre      varchar(255)    NOT NULL
  , apellidos   varchar(255)    NOT NULL
  , direccion   varchar(255)    NOT NULL
  , telefono    numeric(9)      NOT NULL
  , email       varchar(255)    NOT NULL
  , colegio_id  bigint          NOT NULL REFERENCES colegios (id)
                                ON DELETE NO ACTION ON UPDATE CASCADE
);

DROP TABLE IF EXISTS alumnos CASCADE;

CREATE TABLE alumnos
(
    id                          bigserial       PRIMARY KEY
  , codigo                      numeric(8)      NOT NULL UNIQUE
  , unidad                      varchar(255)
  , nombre                      varchar(255)    NOT NULL
  , primer_apellido             varchar(255)    NOT NULL
  , segundo_apellido            varchar(255)
  , fecha_de_nacimiento         date            NOT NULL
  , dni_primer_tutor            char(9)         NOT NULL UNIQUE
  , dni_segundo_tutor           char(9)         UNIQUE
  , colegio_id                  bigint          NOT NULL REFERENCES colegios (id)
                                                ON DELETE NO ACTION ON UPDATE CASCADE
);

DROP TABLE IF EXISTS usuarios CASCADE;

CREATE TABLE usuarios
(
    id          bigserial       PRIMARY KEY
  , nom_usuario varchar(255)    UNIQUE
  , password    varchar(255)
  , nombre      varchar(255)    DEFAULT NULL
  , apellidos   varchar(255)    DEFAULT NULL
  , nif         char(9)         UNIQUE DEFAULT NULL
  , direccion   varchar(255)    DEFAULT NULL
  , email       varchar(255)    UNIQUE DEFAULT NULL
  , tel_movil   numeric(9)      UNIQUE DEFAULT NULL
  , rol         char(1)         NOT NULL
  , token_val   varchar(255)    UNIQUE
  , colegio_id  bigint          REFERENCES colegios (id)
                                ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS carros CASCADE;

CREATE TABLE carros
(
    id          bigserial       PRIMARY KEY
  , usuario_id  bigint          NOT NULL REFERENCES usuarios (id)
                                ON DELETE CASCADE ON UPDATE CASCADE
  , productos   numeric(5)      NOT NULL DEFAULT 0
);

DROP TABLE IF EXISTS productosCarro CASCADE;

CREATE TABLE productosCarro
(
    id              bigserial       PRIMARY KEY
  , carro_id        bigint          NOT NULL REFERENCES carros (id)
                                    ON DELETE CASCADE ON UPDATE CASCADE
  , uniforme_id     bigint          NOT NULL REFERENCES uniformes (id)
                                    ON DELETE NO ACTION ON UPDATE CASCADE
  , cantidad        numeric(5)      NOT NULL
  , realizado       bool            NOT NULL DEFAULT false
  , fecha_pedido    timestamp(0)
  , aceptado        bool            NOT NULL DEFAULT false
);

DROP TABLE IF EXISTS sms CASCADE;

CREATE TABLE sms
(
    id          bigserial       PRIMARY KEY
  , emisario_id bigint          NOT NULL REFERENCES colegios (id)
                                ON DELETE CASCADE ON UPDATE CASCADE
  , receptor_id bigint          NOT NULL REFERENCES usuarios (id)
                                ON DELETE CASCADE ON UPDATE CASCADE
  , mensaje     varchar(255)    NOT NULL
);

INSERT INTO colegios (cif, nombre, email, cod_postal, direccion)
        VALUES  ('A12345678','Educantes Sanlucar','educantes.sanlucar@educantes.es',11540,'C/Urano nº 6')
        , ('B12345678','Educantes Jerez','educantes.jerez@educantes.es',11540,'C/falsa nº 6');

INSERT INTO usuarios (nom_usuario, password, rol, colegio_id)
        VALUES  ('pepe', crypt('pepe', gen_salt('bf', 13)), 'A', null),
                ('juan', crypt('j', gen_salt('bf', 13)), 'C', 1),
                ('maria', crypt('m', gen_salt('bf', 13)), 'C', 2);

INSERT INTO usuarios (nom_usuario, password, email, tel_movil, rol, colegio_id)
        VALUES  ('pedro', crypt('p', gen_salt('bf', 13)),'david.pe.ra.1996@gmail.com',697691185, 'V', 1),
                ('ana', crypt('a', gen_salt('bf', 13)),'falso@falso.es',123123123, 'V', 2);
