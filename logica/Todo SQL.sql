--585f7f3723df82f91fffd25a5c6900597cd4d1c1
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


CREATE TABLE department(
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	name varchar(100),
	cod_dep varchar(7)

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE province(
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_department int,
	name varchar(100),

	FOREIGN KEY (id_department) REFERENCES department(id) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE municipality(
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_province int,
	name varchar(100),

	FOREIGN KEY (id_province) REFERENCES province(id) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE j_agroambiental(
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_municipality int,
	name varchar(100),
	cod_ja varchar(7),

	FOREIGN KEY (id_municipality) REFERENCES municipality(id) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE user (
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_person int,
	id_jagroambiental int,
	email varchar(100),
	position varchar(100),
	pwd varchar(100),
	type varchar(5),
	cellphone int,
	src varchar(255),
	last_connection datetime,
	registered date,
	cod_dep varchar(7),
	cod_ja varchar(7),
	cod_all varchar(7),
	status varchar(6),

	FOREIGN KEY (id_person) REFERENCES person(id) ON DELETE CASCADE,
	FOREIGN KEY (id_jagroambiental) REFERENCES j_agroambiental(id) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE communicate(
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_use int,
	id_usr int,
	message text,
	fec datetime,
	viewed tinyint(1),

	FOREIGN KEY (id_use) REFERENCES user(id) ON DELETE CASCADE,
	FOREIGN KEY (id_usr) REFERENCES user(id) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE publication(
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_user int,
	title varchar(255),
	description text,
	type varchar(13),
	fec datetime,
	img varchar(255),
	doc varchar(255),
	cod varchar(7),

	FOREIGN KEY (id_user) REFERENCES user(id) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE comment(
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_publication int,
	id_user int,
	description text,
	fec datetime,

	FOREIGN KEY (id_publication) REFERENCES publication(id) ON DELETE CASCADE,
	FOREIGN KEY (id_user) REFERENCES user(id) ON DELETE CASCADE

) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

CREATE TABLE img(
	id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
	title varchar(255),
	description text,
	src varchar(255)
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
			IF EXISTS(SELECT id FROM user WHERE id = us AND status LIKE 'activo') THEN
				SELECT id,type,'not' AS error,'Espere por favor...' AS msj FROM user WHERE id = us;
			ELSE
				SELECT 'yes' error,'Error: Su cuenta a sido desactivada, por favor contactese con el administrador para activar su cuenta.' msj;
			END IF;
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
	IN v_id_jagroambiental int,
	IN v_email varchar(100),
	IN v_position varchar(100),
	IN v_pwd varchar(100),
	IN v_type varchar(5),
	IN v_cellphone int,
	IN v_cod_dep varchar(7),
	IN v_cod_ja varchar(7),
	IN v_cod_all varchar(7)
)
BEGIN
	IF NOT EXISTS(SELECT id FROM user WHERE email LIKE v_email) THEN
		INSERT INTO user VALUES(null,v_id_person,v_id_jagroambiental,v_email,v_position,v_pwd,v_type,v_cellphone,'',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,v_cod_dep,v_cod_ja,v_cod_all,'activo');
		SELECT @@identity AS id,v_type AS tipo,'not' AS error,'Usuario registrado correctamente.' AS msj;
	ELSE
		SELECT 'yes' error,'Error: Correo ya registrado.' msj;
	END IF;
END //

DROP PROCEDURE IF EXISTS pInsertCommunicate;
CREATE PROCEDURE pInsertCommunicate (
	IN v_id_use int,
	IN v_id_usr int,
	IN v_message text
)
BEGIN
	INSERT INTO communicate VALUES(null,v_id_use,v_id_usr,v_message,CURRENT_TIMESTAMP,0);
	SELECT @@identity AS id, 'not' AS error,'Mensaje enviado correctamente.' AS msj;
END //

DROP PROCEDURE IF EXISTS pInsertPublication;
CREATE PROCEDURE pInsertPublication (
	IN v_id_user int,
	IN v_title varchar(255),
	IN v_description text,
	IN v_type varchar(13),
	IN v_img varchar(255),
	IN v_doc varchar(255),
	IN v_cod varchar(7)
)
BEGIN
	INSERT INTO publication VALUES(null,v_id_user,v_title,v_description,v_type,CURRENT_TIMESTAMP,v_img,v_doc,v_cod);
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
	SELECT @@identity AS id,v_description description,CURRENT_TIMESTAMP fec,u.src,per.name,per.last_name,per.sex,v_id_publication idPub, 'not' AS error,'Comentario enviado correctamente.' AS msj FROM comment c,publication p,user u,person per WHERE c.id_publication=p.id AND c.id_user=u.id AND u.id_person=per.id AND c.id_user=v_id_user;
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
	IN v_name varchar(100)
)
BEGIN
	INSERT INTO province VALUES(null,v_id_department,v_name);
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

DROP PROCEDURE IF EXISTS pUpdateUser;
CREATE PROCEDURE pUpdateUser (
	IN v_id int,
	IN v_email varchar(100),
	IN v_cellphone int,
	IN v_pwdA varchar(100),
	IN v_pwdN varchar(100),
	IN v_pwdR varchar(100),
	IN v_src varchar(255)
)
BEGIN
	DECLARE us int(11);
	SET us = (SELECT id FROM user WHERE id=v_id AND pwd LIKE v_pwdA);

	IF ( (v_pwdA NOT LIKE '') AND (v_src NOT LIKE '') ) THEN
		
		IF (us) THEN
			IF (v_pwdN LIKE v_pwdR) THEN
				UPDATE user SET email=v_email,cellphone=v_cellphone,pwd=v_pwdN,src=v_src WHERE id=v_id;
				SELECT v_id AS id, 'not' AS error,'Perfil actualizado.' AS msj;
			ELSE
				SELECT v_id AS id, 'yes' AS error,'Las contraseñas no coinciden, repita bien la nueva contraseña.' AS msj;
			END IF;
		ELSE
			SELECT v_id AS id, 'yes' AS error,'La contraseña antigua no es correcta.' AS msj, (v_pwdA NOT LIKE '') AS res;
		END IF;

	END IF;

	IF ( (v_pwdA LIKE '') AND (v_src LIKE '') ) THEN
		UPDATE user SET email=v_email,cellphone=v_cellphone WHERE id=v_id;
		SELECT v_id AS id, 'not' AS error,'Perfil actualizado.' AS msj;
	ELSE

		IF ( (v_pwdA LIKE '') AND (v_src NOT LIKE '') ) THEN
			UPDATE user SET email=v_email,cellphone=v_cellphone,src=v_src WHERE id=v_id;
			SELECT v_id AS id, 'not' AS error,'Perfil actualizado.' AS msj;
		ELSE
			IF ( (v_src LIKE '') AND (v_pwdA NOT LIKE '') ) THEN
				IF (us) THEN
					IF (v_pwdN LIKE v_pwdR) THEN
						UPDATE user SET email=v_email,cellphone=v_cellphone,pwd=v_pwdN WHERE id=v_id;
						SELECT v_id AS id, 'not' AS error,'Perfil actualizado.' AS msj;
					ELSE
						SELECT v_id AS id, 'yes' AS error,'Las contraseñas no coinciden, repita bien la nueva contraseña.' AS msj;
					END IF;
				ELSE
					SELECT v_id AS id, 'yes' AS error,'La contraseña antigua no es correcta.' AS msj;
				END IF;
			END IF;
		END IF;

	END IF;
END //
--CALL pUpdateUser('','','','','','','');//
--CALL pUpdateUser('1','gary@gmail.com','75799666','','123456','123456','');//
--CALL pUpdateUser('1','gary@gmail.com','75799666','12345','123456','123456','puta marta');//
--CALL pUpdateUser('1','joder@gmail.com','75711666','585f7f3723df82f91fffd25a5c6900597cd4d1c1','123456','123456','re puta');//
--CALL pUpdateUser('1','joder@gmail.com','75711666','','123456','123456','jjoooo');//
--CALL pUpdateUser('1','joder@gmail.com','75711666','585f7f3723df82f91fffd25a5c6900597cd4d1c1','1234567','1234567','');//
--CALL pUpdateUser('1','gary@gmail.com','75799666','','123456','123456','aqui va algo');//
--CALL pUpdateUser('1','gary@gmail.com','75799666','585f7f3723df82f91fffd25a5c6900597cd4d1c1','123456','1234567','');//

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


/*
INSERT INTO `department` (`id`, `name`, `cod_dep`) VALUES
(1, 'La Paz', 'D-0001'),
(2, 'Oruro', 'D-0002'),
(3, 'Potosi', 'D-0003'),
(4, 'Cochabamba', 'D-0004'),
(5, 'Chuquisaca', 'D-0005'),
(6, 'Tarija', 'D-0006'),
(7, 'Pando', 'D-0007'),
(8, 'Beni', 'D-0008'),
(9, 'Santa Cruz', 'D-0009');


INSERT INTO `province` (`id`, `id_department`, `name`) VALUES
(1, 1, 'Murillo'),
(2, 2, 'Cercado'),
(3, 3, 'Tomas Frias'),
(4, 4, 'Cercado'),
(5, 5, 'Oropeza'),
(6, 6, 'Cercado'),
(7, 7, 'Nicolas Suarez'),
(8, 8, 'Cercado'),
(9, 9, 'Andres de Ibañez');

INSERT INTO `municipality` (`id`, `id_province`, `name`) VALUES
(1, 1, 'La Paz'),
(2, 2, 'Oruro'),
(3, 3, 'Potosi'),
(4, 4, 'Cochabamba'),
(5, 5, 'Sucre'),
(6, 6, 'Tarija'),
(7, 7, 'Cobija'),
(8, 8, 'Trinidad'),
(9, 9, 'Santa Cruz de la Sierra');

INSERT INTO `j_agroambiental` (`id`, `id_municipality`, `name`, `cod_ja`) VALUES
(1, 1, 'JA La Paz', 'JA-0001'),
(2, 2, 'JA Oruro', 'JA-0002'),
(3, 3, 'JA Potosi', 'JA-0003'),
(4, 4, 'JA Cochabamba', 'JA-0004'),
(5, 5, 'JA Sucre', 'JA-0005'),
(6, 6, 'JA Tarija', 'JA-0006'),
(7, 7, 'JA Cobija', 'JA-0007'),
(8, 8, 'JA Trinidad', 'JA-0009');


INSERT INTO `publication` (`id`, `id_user`, `title`, `description`, `fec`, `img`, `doc`, `cod`) VALUES
(1, 1, 'La Jurisdiccion Agroambiental', 'Siguiendo la tendencia de algunos países latinoamericanos como Argentina, Brasil, Chile, Costa Rica, Ecuador, México y Perú, que poseen dentro de su ordenamiento jurídico, la jurisdicción agraria y ambiental; Bolivia a través de la Nueva Constitución Política del Estado', '2017-05-11 10:05:25', '', NULL, 'JA-0004'),
(2, 2, 'la equidad de genero en la JA', 'El Programa Equidad de Género Familia y Justicia, viene participando en reuniones i encuentros convocadas por el Viceministerio de Igualdad de Oportunidades dependiente de Ministerio de Justicia y fortaleciendo a las Organizaciones Económicas Campesinas Indígenas y Originarias de Bolivia. Se realizaron dos cumbres de mujeres a Nivel Nacional, la primera el año 2008 (1ra. Cumbre), donde se toco principalmente el tema de la discriminación, En la 2da. Cumbre, se conformo La Alianza de Organizaciones de Mujeres por la Revolución Democrática Cultural y la Unidad en la cual participan 16 organizaciones de diferentes lugares del país', '2017-05-12 18:31:38', '', NULL, 'D-0004'),
(3, 3, 'Nueva justicia en Bolivia. ', 'Con el reto de acabar con la retardación, la corrupción y hacer que la justicia sea más justa para los bolivianos, desde el martes el país contará con un nuevo Órgano Judicial conformado por 56 magistrados electos por el voto popular del pueblo en una histórica elección realizada el 16 de octubre de 2011. Por primera vez, la equidad de género prevalecerá en el nuevo Órgano, toda vez que de la totalidad de autoridades electas para el Tribunal Supremo de Justicia, el Consejo de la Magistratura, el Tribunal Constitucional Plurinacional y el Tribunal Agroambiental son 28 mujeres y 28 varones.', '2017-05-12 18:40:16', '', NULL, 'JA-0002'),
(4, 4, 'Ministro Justicia de Bolivia va a Chile a analizar defensa de 9 funcionarios', '"Vamos a participar en diversas reuniones con el equipo jurídico que defiende a nuestros compatriotas, a los nueve bolivianos injustamente detenidos, retenidos en el Estado chileno", afirmó el ministro, que cuenta con el visado para el viaje a ese país', '2017-05-12 18:43:31', '', NULL, 'D-0002'),
(5, 5, '  Ministro de Justicia boliviano: Dichos del canciller Muñoz son “delirantes”', 'Arce lamentó "profundamente" que las autoridades chilenas hayan negado el visado a los presidentes del Senado boliviano, José Alberto Gonzales, y de la Cámara de Diputados, Gabriela Montaño, quienes tenían la intención de visitar a los nueve detenidos.', '2017-05-12 18:45:01', '', NULL, 'T-0000'),
(6, 6, 'MINISTERIO DE JUSTICIA ENVÍA A LA CÁRCEL A FUNCIONARIO QUE FALSIFICÓ DOCUMENTO UNIVERSITARIO PARA ACCEDER A CARGO PÚBLICO', ' La Paz, 11 de mayo (MJyTI).- El Juez Quinto de Instrucción Cautelar de La Paz determinó la detención preventiva, en la cárcel de San Pedro, del señor Cesar Luis Catunta Alanoca, quien fraguó un documento universitario para ser contratado en el Ministerio de Justicia. Como parte de la política…', '2017-05-12 18:46:30', '', NULL, 'JA-0005');

*/