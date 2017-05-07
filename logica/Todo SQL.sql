CREATE DATABASE tribunal;
use tribunal;

CREATE TABLE person(
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	ci int,
	ex varchar(3),
	name varchar(50),
	last_name varchar(50),
	fec_nac date,
	sex varchar(10)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE user (
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_person int,
	email varchar(100),
	pwd varchar(100),
	type varchar(5),
	cellphone int,
	last_connection datetime,
	registered date,
	cod_dep varchar(7),
	cod_ja varchar(7),
	cod_all varchar(7),

	FOREIGN KEY (id_person) REFERENCES person(id)

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE communicate(
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_use int,
	id_usr int,
	message text,
	fec datetime,

	FOREIGN KEY (id_use) REFERENCES user(id),
	FOREIGN KEY (id_usr) REFERENCES user(id)

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE publication(
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_user int,
	title varchar(255),
	description text,
	fec datetime,
	img varchar(255),
	cod varchar(7),

	FOREIGN KEY (id_user) REFERENCES user(id)

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE comment(
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_publication int,
	id_user int,
	description text,
	fec datetime,

	FOREIGN KEY (id_publication) REFERENCES publication(id),
	FOREIGN KEY (id_user) REFERENCES user(id)

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE department(
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	name varchar(100),
	cod_dep varchar(7)

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE province(
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_department int,
	name varchar(100),
	cod_dep varchar(7),

	FOREIGN KEY (id_department) REFERENCES department(id)

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE municipality(
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_province int,
	name varchar(100),

	FOREIGN KEY (id_province) REFERENCES province(id)

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE j_agroambiental(
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_municipality int,
	name varchar(100),
	cod_ja varchar(7),

	FOREIGN KEY (id_municipality) REFERENCES municipality(id)

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;










/*Procediminetos Almacenados*/
delimiter //
DROP PROCEDURE IF EXISTS pSession;
CREATE PROCEDURE pSession(
	IN v_email varchar(100),
	IN v_pwd varchar(100)
)
BEGIN
	DECLARE us int(11);
	SET us = (SELECT id FROM user WHERE email LIKE v_email);
	IF(us) THEN
		IF EXISTS(SELECT id FROM user WHERE id = us AND pwd LIKE v_pwd) THEN
			SELECT id,type,'not' AS error,'Bienvenido al sistema, espere por favor.' AS msj FROM user WHERE id = us;
		ELSE
			SELECT 'yes' error,'Error: Contraseña incorrecta.' msj;
		END IF;
	ELSE
		SELECT 'yes' error,'Error: Correo no registrado.' msj;
	END IF;
END //


DROP PROCEDURE IF EXISTS pInsertPerson;
CREATE PROCEDURE pInsertPerson (
	IN v_ci int,
	IN v_ex varchar(3),
	IN v_name varchar(50),
	IN v_last_name varchar(50),
	IN v_fec_nac date,
	IN v_sex varchar(10)
)
BEGIN
	IF NOT EXISTS(SELECT id FROM person WHERE ci LIKE v_ci) THEN
		INSERT INTO person VALUES(null,v_ci,v_ex,v_name,v_last_name,v_fec_nac,v_sex);
		SELECT @@identity AS id,'not' AS error;
	ELSE
		SELECT 'yes' error,'Error: CI ya registrado.' msj;
	END IF;
END //

DROP PROCEDURE IF EXISTS pInsertUser;
CREATE PROCEDURE pInsertUser (
	IN v_id_person int,
	IN v_email varchar(100),
	IN v_pwd varchar(100),
	IN v_type varchar(5),
	IN v_cellphone int,
	IN v_cod_dep varchar(7),
	IN v_cod_ja varchar(7),
	IN v_cod_all varchar(7)
)
BEGIN
	IF NOT EXISTS(SELECT id FROM user WHERE email LIKE v_email) THEN
		INSERT INTO user VALUES(null,v_id_person,v_email,v_pwd,v_type,v_cellphone,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,v_cod_dep,v_cod_ja,v_cod_all);
		SELECT @@identity AS id,v_type AS tipo,'not' AS error,'Usuario registrado correctamente.' AS msj;
	ELSE
		SELECT 'yes' error,'Error: Correo ya registrado.' msj;
	END IF;
END //

DROP PROCEDURE IF EXISTS pInsertCommunicate;
CREATE PROCEDURE pInsertCommunicate (
	IN v_id_use int,
	IN v_id_usr int,
	IN v_message text,
	IN v_fec datetime
)
BEGIN
	INSERT INTO communicate VALUES(null,v_id_use,v_id_usr,v_message,CURRENT_TIMESTAMP);
	SELECT @@identity AS id, 'not' AS error,'Mensaje enviado correctamente.' AS msj;
END //

DROP PROCEDURE IF EXISTS pInsertPublication;
CREATE PROCEDURE pInsertPublication (
	IN v_id_user int,
	IN v_title varchar(255),
	IN v_description text,
	IN v_img varchar(255),
	IN v_cod varchar(7)
)
BEGIN
	INSERT INTO publication VALUES(null,v_id_user,v_title,v_description,CURRENT_TIMESTAMP,v_img,v_cod);
	SELECT @@identity AS id, 'not' AS error,'Publicación registrada correctamente.' AS msj;
END //

DROP PROCEDURE IF EXISTS pInsertComment;
CREATE PROCEDURE pInsertComment (
	IN v_id_publication int,
	IN v_id_user int,
	IN v_description text
)
BEGIN
	INSERT INTO comment VALUES(null,v_id_publication,v_id_user,v_description,CURRENT_TIMESTAMP);
	SELECT @@identity AS id, 'not' AS error,'Comentario enviado correctamente.' AS msj;
END //

DROP PROCEDURE IF EXISTS pInsertDepartment;
CREATE PROCEDURE pInsertDepartment (
	IN v_name varchar(100),
	IN v_cod_dep varchar(7)
)
BEGIN
	INSERT INTO department VALUES(null,v_name,v_cod_dep);
	SELECT @@identity AS id, 'not' AS error,'Departamento registrado correctamente.' AS msj;
END //

DROP PROCEDURE IF EXISTS pInsertProvince;
CREATE PROCEDURE pInsertProvince (
	IN v_id_department int,
	IN v_name varchar(100),
	IN v_cod_dep varchar(7)
)
BEGIN
	INSERT INTO province VALUES(null,v_id_department,v_name,v_cod_dep);
	SELECT @@identity AS id, 'not' AS error,'Provincia registrada correctamente.' AS msj;
END //

DROP PROCEDURE IF EXISTS pInsertMunicipality;
CREATE PROCEDURE pInsertMunicipality (
	IN v_id_province int,
	IN v_name varchar(100)
)
BEGIN
	INSERT INTO municipality VALUES(null,v_id_province,v_name);
	SELECT @@identity AS id, 'not' AS error,'Municipio registrado correctamente.' AS msj;
END //

DROP PROCEDURE IF EXISTS pInsertJAgroambiental;
CREATE PROCEDURE pInsertJAgroambiental (
	IN v_id_municipality int,
	IN v_name varchar(100),
	IN v_cod_ja varchar(7)
)
BEGIN
	INSERT INTO j_agroambiental VALUES(null,v_id_municipality,v_name,v_cod_ja);
	SELECT @@identity AS id, 'not' AS error,'Registro registrado correctamente.' AS msj;
END //










DROP PROCEDURE IF EXISTS pReporte;
CREATE PROCEDURE pReporte (
    IN v_fecha date
)
BEGIN
	IF EXISTS(SELECT id FROM pasaje WHERE SUBSTRING(fecha,1,10) LIKE v_fecha) THEN
		SELECT p.id,p.num_asiento,p.ubicacion,p.precio,p.fecha,v.horario,
			v.origen,v.destino,ch.ci AS ci_chofer,ch.nombre AS nombre_chofer,ch.img AS img_chofer,b.num AS num_bus,
			cli.ci AS ci_cliente,cli.nombre AS nombre_cliente,cli.apellido AS apellido_cliente 
		FROM bus as b,chofer as ch,viaje as v,cliente as cli,pasaje as p 
		WHERE v.id_chofer=ch.id AND v.id_bus=b.id AND p.id_viaje=v.id AND p.id_cliente=cli.id AND 
			p.fecha > CONCAT(v_fecha,' ','00:00:01') AND p.fecha < CONCAT(v_fecha,' ','23:59:59');
	ELSE
		SELECT 'No se encontraron ventas en esa fecha' error;
	END IF;
END //

