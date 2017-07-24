-- phpMyAdmin SQL Dump
-- version 4.5.2
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 24-07-2017 a las 10:33:34
-- Versión del servidor: 10.1.13-MariaDB
-- Versión de PHP: 7.0.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `tribunal`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertComment` (IN `v_id_publication` INT, IN `v_id_user` INT, IN `v_description` TEXT)  BEGIN
INSERT INTO comment VALUES(null,v_id_publication,v_id_user,v_description,CURRENT_TIMESTAMP);
SELECT @@identity AS id,v_description description,CURRENT_TIMESTAMP fec,u.src,per.name,per.last_name,per.sex,v_id_publication idPub, 'not' AS error,'Comentario enviado correctamente.' AS msj FROM comment c,publication p,user u,person per WHERE c.id_publication=p.id AND c.id_user=u.id AND u.id_person=per.id AND c.id_user=v_id_user;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertCommunicate` (IN `v_id_use` INT, IN `v_id_usr` INT, IN `v_message` TEXT, IN `v_viewed` TINYINT(1))  BEGIN
INSERT INTO communicate VALUES(null,v_id_use,v_id_usr,v_message,CURRENT_TIMESTAMP,v_viewed);
SELECT @@identity AS id, 'not' AS error,'Mensaje enviado correctamente.' AS msj;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertDepartment` (IN `v_name` VARCHAR(100), IN `v_cod_dep` VARCHAR(7))  BEGIN
INSERT INTO department VALUES(null,v_name,v_cod_dep);
SELECT @@identity AS id, 'not' AS error,'Departamento registrado correctamente.' AS msj;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertImg` (IN `v_title` VARCHAR(255), IN `v_description` TEXT, IN `v_src` VARCHAR(255))  BEGIN
INSERT INTO img VALUES(null,v_title,v_description,v_src);
SELECT @@identity AS id, 'not' AS error,'guardada correctamente.' AS msj;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertJAgroambiental` (IN `v_id_municipality` INT, IN `v_name` VARCHAR(100), IN `v_cod_ja` VARCHAR(7))  BEGIN
INSERT INTO j_agroambiental VALUES(null,v_id_municipality,v_name,v_cod_ja);
SELECT @@identity AS id, 'not' AS error,'Registro registrado correctamente.' AS msj;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertMunicipality` (IN `v_id_province` INT, IN `v_name` VARCHAR(100))  BEGIN
INSERT INTO municipality VALUES(null,v_id_province,v_name);
SELECT @@identity AS id, 'not' AS error,'Municipio registrado correctamente.' AS msj;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertPerson` (IN `v_ci` INT, IN `v_ex` VARCHAR(3), IN `v_name` VARCHAR(50), IN `v_last_name` VARCHAR(50), IN `v_fec_nac` DATE, IN `v_sex` VARCHAR(10))  BEGIN
IF NOT EXISTS(SELECT id FROM person WHERE ci LIKE v_ci) THEN
INSERT INTO person VALUES(null,v_ci,v_ex,v_name,v_last_name,v_fec_nac,v_sex);
SELECT @@identity AS id,'not' AS error;
ELSE
SELECT 'yes' error,'Error: CI ya registrado.' msj;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertProvince` (IN `v_id_department` INT, IN `v_name` VARCHAR(100))  BEGIN
INSERT INTO province VALUES(null,v_id_department,v_name);
SELECT @@identity AS id, 'not' AS error,'Provincia registrada correctamente.' AS msj;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertPublication` (IN `v_id_user` INT, IN `v_title` VARCHAR(255), IN `v_description` TEXT, IN `v_type` VARCHAR(13), IN `v_img` VARCHAR(255), IN `v_doc` VARCHAR(255), IN `v_cod` VARCHAR(7))  BEGIN
INSERT INTO publication VALUES(null,v_id_user,v_title,v_description,v_type,CURRENT_TIMESTAMP,v_img,v_doc,v_cod);
SELECT @@identity AS id, 'not' AS error,'Publicación registrada correctamente.' AS msj;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertUser` (IN `v_id_person` INT, IN `v_id_jagroambiental` INT, IN `v_email` VARCHAR(100), IN `v_position` VARCHAR(100), IN `v_pwd` VARCHAR(100), IN `v_type` VARCHAR(5), IN `v_cellphone` INT, IN `v_cod_dep` VARCHAR(7), IN `v_cod_ja` VARCHAR(7), IN `v_cod_all` VARCHAR(7))  BEGIN
IF NOT EXISTS(SELECT id FROM user WHERE email LIKE v_email) THEN
INSERT INTO user VALUES(null,v_id_person,v_id_jagroambiental,v_email,v_position,v_pwd,v_type,v_cellphone,'',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,v_cod_dep,v_cod_ja,v_cod_all,'activo');
SELECT @@identity AS id,v_type AS tipo,'not' AS error,'Usuario registrado correctamente.' AS msj;
ELSE
SELECT 'yes' error,'Error: Correo ya registrado.' msj;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pReporte` (IN `v_fecha` DATE)  BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pSession` (IN `v_email` VARCHAR(100), IN `v_pwd` VARCHAR(100))  BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pUpdateUser` (IN `v_id` INT, IN `v_email` VARCHAR(100), IN `v_cellphone` INT, IN `v_pwdA` VARCHAR(100), IN `v_pwdN` VARCHAR(100), IN `v_pwdR` VARCHAR(100), IN `v_src` VARCHAR(255))  BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tSelectCumple` (IN `v_anio` VARCHAR(4), IN `v_mes` VARCHAR(2), IN `v_dia` VARCHAR(2), IN `v_tipo` VARCHAR(5))  BEGIN
DECLARE fecha_ahora varchar(10);

DECLARE error int DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
BEGIN
SET error=1;
SELECT "yes" error,"Transaccion no completada: tInsertPayment" msj;
END;

START TRANSACTION;
SET fecha_ahora = (SELECT CONCAT(v_anio,'-',v_mes,'-',v_dia));

IF (v_tipo = 'sem') THEN
SELECT u.id,p.name,p.last_name,p.fec_nac,u.position,j.name j_name,CONCAT(v_anio,'-',SUBSTRING(p.fec_nac,6,5)) fec_birthday,DATEDIFF(CONCAT(v_anio,'-',SUBSTRING(p.fec_nac,6,5)),fecha_ahora) day_birthday FROM person p,user u,j_agroambiental j WHERE u.id_person=p.id AND u.cod_ja=j.cod_ja AND u.status LIKE 'activo' AND (DATEDIFF(CONCAT(v_anio,'-',SUBSTRING(p.fec_nac,6,5)),fecha_ahora) > -1 AND DATEDIFF(CONCAT(v_anio,'-',SUBSTRING(p.fec_nac,6,5)),fecha_ahora) < 8);
ELSE
IF (v_tipo = 'mes') THEN
SELECT u.id,p.name,p.last_name,p.fec_nac,u.position,j.name j_name,CONCAT(v_anio,'-',SUBSTRING(p.fec_nac,6,5)) fec_birthday,DATEDIFF(CONCAT(v_anio,'-',SUBSTRING(p.fec_nac,6,5)),fecha_ahora) day_birthday FROM person p,user u,j_agroambiental j WHERE u.id_person=p.id AND u.cod_ja=j.cod_ja AND u.status LIKE 'activo' AND SUBSTRING(p.fec_nac,6,2)=v_mes AND DATEDIFF(CONCAT(v_anio,'-',SUBSTRING(p.fec_nac,6,5)),fecha_ahora) > -1;
END IF;
END IF;

IF (error = 1) THEN
ROLLBACK;
ELSE
COMMIT;
END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comment`
--

CREATE TABLE `comment` (
  `id` int(11) NOT NULL,
  `id_publication` int(11) DEFAULT NULL,
  `id_user` int(11) DEFAULT NULL,
  `description` text COLLATE utf8_spanish2_ci,
  `fec` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `communicate`
--

CREATE TABLE `communicate` (
  `id` int(11) NOT NULL,
  `id_use` int(11) DEFAULT NULL,
  `id_usr` int(11) DEFAULT NULL,
  `message` text COLLATE utf8_spanish2_ci,
  `fec` datetime DEFAULT NULL,
  `viewed` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `communicate`
--

INSERT INTO `communicate` (`id`, `id_use`, `id_usr`, `message`, `fec`, `viewed`) VALUES
(1, 3, 1, 'Hola como estas', '2017-07-07 10:25:32', 1),
(2, 9, 1, 'Hola necesito tu numero', '2017-07-07 06:16:18', 1),
(3, 1, 3, 'Estoy bien y tu?', '2017-07-07 17:31:28', 1),
(4, 3, 1, 'Yo bien perro?', '2017-07-07 17:34:48', 1),
(5, 1, 5, 'hola que tal', '2017-07-13 11:03:49', 0),
(6, 1, 8, 'hola mensaje de prueba', '2017-07-13 11:06:19', 0),
(7, 1, 17, 'ohhh siiiii', '2017-07-13 11:08:09', 0),
(8, 1, 22, 'Hola ratón sin cola', '2017-07-13 11:09:44', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `department`
--

CREATE TABLE `department` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `cod_dep` varchar(7) COLLATE utf8_spanish2_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `department`
--

INSERT INTO `department` (`id`, `name`, `cod_dep`) VALUES
(1, 'Chuquisaca', 'D-0001'),
(2, 'La Paz', 'D-0002'),
(3, 'Cochabamba', 'D-0003'),
(4, 'Oruro', 'D-0004'),
(5, 'Potosi', 'D-0005'),
(6, 'Tarija', 'D-0006'),
(7, 'Santa Cruz', 'D-0007'),
(8, 'Beni', 'D-0008'),
(9, 'Pando', 'D-0009');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `img`
--

CREATE TABLE `img` (
  `id` int(11) NOT NULL,
  `title` varchar(255) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `description` text COLLATE utf8_spanish2_ci,
  `src` varchar(255) COLLATE utf8_spanish2_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `img`
--

INSERT INTO `img` (`id`, `title`, `description`, `src`) VALUES
(1, '', 'prueba5', '1500899006.jpeg'),
(2, '', 'Joder', '1500902051.jpeg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `j_agroambiental`
--

CREATE TABLE `j_agroambiental` (
  `id` int(11) NOT NULL,
  `id_municipality` int(11) DEFAULT NULL,
  `name` varchar(100) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `cod_ja` varchar(7) COLLATE utf8_spanish2_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `j_agroambiental`
--

INSERT INTO `j_agroambiental` (`id`, `id_municipality`, `name`, `cod_ja`) VALUES
(100, 10101, 'Tribunal Agroambiental', 'TA-0001'),
(101, 10101, 'Juzgado Agroambiental de Sucre', 'JA-0001'),
(102, 10201, 'Juzgado Agroambiental de Azurduy', 'JA-0002'),
(103, 10401, 'Juzgado Agroambiental de Padilla', 'JA-0003'),
(104, 10501, 'Juzgado Agroambiental de Monteagudo', 'JA-0004'),
(105, 10701, 'Juzgado Agroambiental de Camargo', 'JA-0005'),
(106, 11001, 'Juzgado Agroambiental de Muyupampa', 'JA-0006'),
(107, 11003, 'Juzgado Agroambiental de Macharetí', 'JA-0007'),
(201, 20101, 'Juzgado Agroambiental de La Paz', 'JA-0008'),
(202, 20105, 'Juzgado Agroambiental de El Alto', 'JA-0009'),
(203, 20701, 'Juzgado Agroambiental de Apolo', 'JA-0010'),
(204, 20801, 'Juzgado Agroambiental de Viacha', 'JA-0011'),
(205, 21001, 'Juzgado Agroambiental de Inquisivi', 'JA-0012'),
(206, 21201, 'Juzgado Agroambiental de Pucarani', 'JA-0013'),
(207, 21301, 'Juzgado Agroambiental de Sica Sica', 'JA-0014'),
(208, 22001, 'Juzgado Agroambiental de Caranavi', 'JA-0015'),
(301, 30101, 'Juzgado Agroambiental de Cochabamba', 'JA-0016'),
(302, 30201, 'Juzgado Agroambiental de Aiquile', 'JA-0017'),
(303, 30901, 'Juzgado Agroambiental de Quillacollo', 'JA-0018'),
(304, 31001, 'Juzgado Agroambiental de Sacaba', 'JA-0019'),
(305, 31003, 'Juzgado Agroambiental de Villa Tunari', 'JA-0020'),
(306, 31205, 'Juzgado Agroambiental de Ivirgazama', 'JA-0021'),
(307, 31206, 'Juzgado Agroambiental de Entre Rios', 'JA-0022'),
(308, 31401, 'Juzgado Agroambiental de Punata', 'JA-0023'),
(401, 40101, 'Juzgado Agroambiental de Oruro', 'JA-0024'),
(402, 40201, 'Juzgado Agroambiental de Challapata', 'JA-0025'),
(403, 40301, 'Juzgado Agroambiental de Corque', 'JA-0026'),
(404, 40401, 'Juzgado Agroambiental de Curahuara de Carangas', 'JA-0027'),
(405, 40501, 'Juzgado Agroambiental de Huachacalla', 'JA-0028'),
(501, 50101, 'Juzgado Agroambiental de Potosí', 'JA-0029'),
(502, 50201, 'Juzgado Agroambiental de Uncia', 'JA-0030'),
(503, 50401, 'Juzgado Agroambiental de Colquechaca', 'JA-0031'),
(504, 50501, 'Juzgado Agroambiental de San Pedro de Buena Vista', 'JA-0032'),
(505, 50601, 'Juzgado Agroambiental de Cotagaita', 'JA-0033'),
(601, 60101, 'Juzgado Agroambiental de Tarija', 'JA-0034'),
(602, 60202, 'Juzgado Agroambiental de Bermejo', 'JA-0035'),
(603, 60301, 'Juzgado Agroambiental de Yacuiba', 'JA-0036'),
(604, 60303, 'Juzgado Agroambiental de Villamontes', 'JA-0037'),
(605, 60501, 'Juzgado Agroambiental de San Lorenzo', 'JA-0038'),
(606, 60601, 'Juzgado Agroambiental de Entre Rios', 'JA-0039'),
(701, 70101, 'Juzgado Agroambiental de Santa Cruz', 'JA-0040'),
(702, 70101, 'Juzgado Agroambiental de Santa Cruz II', 'JA-0041'),
(703, 70301, 'Juzgado Agroambiental de San Ignacio de Velasco', 'JA-0042'),
(704, 70403, 'Juzgado Agroambiental de Yapacaní', 'JA-0043'),
(705, 70502, 'Juzgado Agroambiental de Pailón', 'JA-0044'),
(706, 70706, 'Juzgado Agroambiental de Camiri', 'JA-0045'),
(707, 70801, 'Juzgado Agroambiental de Vallegrande', 'JA-0046'),
(708, 70901, 'Juzgado Agroambiental de Samaipata', 'JA-0047'),
(709, 71001, 'Juzgado Agroambiental de Montero', 'JA-0048'),
(710, 71101, 'Juzgado Agroambiental de Concepción', 'JA-0049'),
(801, 80101, 'Juzgado Agroambiental de Trinidad', 'JA-0050'),
(802, 80201, 'Juzgado Agroambiental de Riberalta', 'JA-0051'),
(803, 80302, 'Juzgado Agroambiental de San Borja', 'JA-0052'),
(804, 80401, 'Juzgado Agroambiental de Santa Ana de Yacuma', 'JA-0053'),
(805, 80501, 'Juzgado Agroambiental de San Ignacio de Moxos', 'JA-0054'),
(806, 80701, 'Juzgado Agroambiental de San Joaquin', 'JA-0055'),
(807, 80801, 'Juzgado Agroambiental de Magadalena', 'JA-0056'),
(901, 90101, 'Juzgado Agroambiental de Cobija', 'JA-0057');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `municipality`
--

CREATE TABLE `municipality` (
  `id` int(11) NOT NULL,
  `id_province` int(11) DEFAULT NULL,
  `name` varchar(100) COLLATE utf8_spanish2_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `municipality`
--

INSERT INTO `municipality` (`id`, `id_province`, `name`) VALUES
(10101, 101, 'Sucre'),
(10102, 101, 'Yotala'),
(10103, 101, 'Poroma'),
(10201, 102, 'Azurduy'),
(10202, 102, 'Tarvita'),
(10301, 103, 'Zudañez'),
(10302, 103, 'Presto'),
(10303, 103, 'Mojocoya'),
(10304, 103, 'Icla'),
(10401, 104, 'Padilla'),
(10402, 104, 'Tomina'),
(10403, 104, 'Sopachuy'),
(10404, 104, 'Villa Alcalá'),
(10405, 104, 'El Villar'),
(10501, 105, 'Monteagudo'),
(10502, 105, 'Huacareta'),
(10601, 106, 'Tarabuco'),
(10602, 106, 'Yamparáez'),
(10701, 107, 'Camargo'),
(10702, 107, 'San Lucas'),
(10703, 107, 'Incahuasi'),
(10801, 108, 'Villa Serrano'),
(10901, 109, 'Villa Abecia'),
(10902, 109, 'Culpina'),
(10903, 109, 'Las Carreras'),
(11001, 110, 'Muyupampa'),
(11002, 110, 'Huacaya'),
(11003, 110, 'Macharetí'),
(20101, 201, 'La Paz'),
(20102, 201, 'Palca'),
(20103, 201, 'Mecapaca'),
(20104, 201, 'Achocalla'),
(20105, 201, 'El Alto'),
(20201, 202, 'Achacachi'),
(20202, 202, 'Ancoraimes'),
(20301, 203, 'Coro Coro'),
(20302, 203, 'Caquiaviri'),
(20303, 203, 'Calacoto'),
(20304, 203, 'Comanche'),
(20305, 203, 'Charaña'),
(20306, 203, 'Waldo Ballivian'),
(20307, 203, 'Nazacara de Pacajes'),
(20308, 203, 'Callapa'),
(20401, 204, 'Puerto Acosta'),
(20402, 204, 'Mocomoco'),
(20403, 204, 'Pto. Carabuco'),
(20501, 205, 'Chuma'),
(20502, 205, 'Ayata'),
(20503, 205, 'Aucapata'),
(20601, 206, 'Sorata'),
(20602, 206, 'Guanay'),
(20603, 206, 'Tacacoma'),
(20604, 206, 'Quiabaya'),
(20605, 206, 'Combaya'),
(20606, 206, 'ipuani'),
(20607, 206, 'Mapiri'),
(20608, 206, 'Teoponte'),
(20701, 207, 'Apolo'),
(20702, 207, 'Pelechuco'),
(20801, 208, 'Viacha'),
(20802, 208, 'Guaqui'),
(20803, 208, 'Tiahuanacu'),
(20804, 208, 'Desaguadero'),
(20805, 208, 'San Andrés de Machaca'),
(20806, 208, 'Jesús de Machaca'),
(20807, 208, 'Taraco'),
(20901, 209, 'Luribay'),
(20902, 209, 'Sapahaqui'),
(20903, 209, 'Yaco'),
(20904, 209, 'Malla'),
(20905, 209, 'Cairoma'),
(21001, 210, 'Inquisivi'),
(21002, 210, 'Quime'),
(21003, 210, 'Cajuata'),
(21004, 210, 'Colquiri'),
(21005, 210, 'Ichoca'),
(21006, 210, 'Villa Libertad Licoma'),
(21101, 211, 'Chulumani'),
(21102, 211, 'Irupana'),
(21103, 211, 'Yanacachi'),
(21104, 211, 'Palos Blancos'),
(21105, 211, 'La Asunta'),
(21201, 212, 'Pucarani'),
(21202, 212, 'Laja'),
(21203, 212, 'Batallas'),
(21204, 212, 'Puerto Pérez'),
(21301, 213, 'Sica Sica'),
(21302, 213, 'Umala'),
(21303, 213, 'Ayo Ayo'),
(21304, 213, 'Calamarca'),
(21305, 213, 'Patacamaya'),
(21306, 213, 'Colquencha'),
(21307, 213, 'Collana'),
(21401, 214, 'Coroico'),
(21402, 214, 'Coripata'),
(21501, 215, 'Ixiamas'),
(21502, 215, 'San Buenaventura'),
(21601, 216, 'Charazani'),
(21602, 216, 'Curva'),
(21701, 217, 'Copacabana'),
(21702, 217, 'San Pedro de Tiquina'),
(21703, 217, 'Tito Yupanqui'),
(21801, 218, 'San Pedro Cuarahuara'),
(21802, 218, 'Papel Pampa'),
(21803, 218, 'Chacarilla'),
(21901, 219, 'Santiago de Machaca'),
(21902, 219, 'Catacora'),
(22001, 220, 'Caranavi'),
(30101, 301, 'Cochabamba'),
(30201, 302, 'Aiquile'),
(30202, 302, 'Pasorapa'),
(30203, 302, 'Omereque'),
(30301, 303, 'Ayopaya (Villa de Independencia)'),
(30302, 303, 'Morochata'),
(30401, 304, 'Tarata'),
(30402, 304, 'Anzaldo'),
(30403, 304, 'Arbieto'),
(30404, 304, 'Sacabamba'),
(30501, 305, 'Arani'),
(30502, 305, 'Vacas'),
(30601, 306, 'Arque'),
(30602, 306, 'Tacopaya'),
(30701, 307, 'Capinota'),
(30702, 307, 'Santiváñez'),
(30703, 307, 'Sicaya'),
(30801, 308, 'Cliza'),
(30802, 308, 'Toco'),
(30803, 308, 'Tolata'),
(30901, 309, 'Quillacollo'),
(30902, 309, 'Sipe Sipe'),
(30903, 309, 'Tiquipaya'),
(30904, 309, 'Vinto'),
(30905, 309, 'Colcapirhua'),
(31001, 310, 'Sacaba'),
(31002, 310, 'Colomi'),
(31003, 310, 'Villa Tunari'),
(31101, 311, 'Tapacarí'),
(31201, 312, 'Totora'),
(31202, 312, 'Pojo'),
(31203, 312, 'Pocona'),
(31204, 312, 'Chimoré'),
(31205, 312, 'Puerto Villarroel'),
(31206, 312, 'Entre Rios'),
(31301, 313, 'Mizque'),
(31302, 313, 'Vila Vila'),
(31303, 313, 'Alalay'),
(31401, 314, 'Punata'),
(31402, 314, 'Villa Rivero'),
(31403, 314, 'San Benito'),
(31404, 314, 'Tacachi'),
(31405, 314, 'Cuchumuela'),
(31501, 315, 'Bolívar'),
(31601, 316, 'Tiraque'),
(40101, 401, 'Oruro'),
(40102, 401, 'Caracollo'),
(40103, 401, 'El Choro'),
(40104, 401, 'Soracachi'),
(40201, 402, 'Challapata'),
(40202, 402, 'Santuario de Quillacas'),
(40301, 403, 'Corque'),
(40302, 403, 'Choque Cota'),
(40401, 404, 'Curahuara de Carangas'),
(40402, 404, 'Turco'),
(40501, 405, 'Huachacalla'),
(40502, 405, 'Escara'),
(40503, 405, 'Cruz de Machacamarca'),
(40504, 405, 'Yunguyo de Litoral'),
(40505, 405, 'Esmeralda'),
(40601, 406, 'Poopó'),
(40602, 406, 'Pazña'),
(40603, 406, 'Antequera'),
(40701, 407, 'Huanuni'),
(40702, 407, 'Machacamarca'),
(40801, 408, 'Salinas de Garcí Mendoza'),
(40802, 408, 'Pampa Aullagas'),
(40901, 409, 'Sabaya'),
(40902, 409, 'Coipasa'),
(40903, 409, 'Chipaya'),
(41001, 410, 'Toledo'),
(41101, 411, 'Eucaliptus'),
(41201, 412, 'Santiago de Andamarca'),
(41202, 412, 'Belén de Andamarca'),
(41301, 413, 'Totora'),
(41401, 414, 'Santiago de Huari'),
(41501, 415, 'La Rivera'),
(41502, 415, 'Todos Santos'),
(41503, 415, 'Carangas'),
(41601, 416, 'Huayllamarca'),
(50101, 501, 'Potosí'),
(50102, 501, 'Tinguipaya'),
(50103, 501, 'Yocalla'),
(50104, 501, 'Urmiri'),
(50201, 502, 'Uncía'),
(50202, 502, 'Chayanta'),
(50203, 502, 'Llallagua'),
(50301, 503, 'Betanzos'),
(50302, 503, 'Chaquí'),
(50303, 503, 'Tacobamba'),
(50401, 504, 'Colquechaca'),
(50402, 504, 'Ravelo'),
(50403, 504, 'Pocoata'),
(50404, 504, 'Ocurí'),
(50501, 505, 'San Pedro de Buena Vista'),
(50502, 505, 'Toro Toro'),
(50601, 506, 'Cotagaita'),
(50602, 506, 'Vitichi'),
(50701, 507, 'Sacaca (Villa de Sacaca)'),
(50702, 507, 'Caripuyo'),
(50801, 508, 'Tupiza'),
(50802, 508, 'Atocha'),
(50901, 509, '"Colcha K"" (Villa Martín)"""'),
(50902, 509, 'San Pedro de Quemes'),
(51001, 510, 'San Pablo de Lípez'),
(51002, 510, 'Mojinete'),
(51003, 510, 'San Antonio de Esmoruco'),
(51101, 511, 'Puna (Villa Talavera)'),
(51102, 511, '"Caiza D"" """'),
(51201, 512, 'Uyuni'),
(51202, 512, 'Tomave'),
(51203, 512, 'Porco'),
(51301, 513, 'Arampampa'),
(51302, 513, 'Acasio'),
(51401, 514, 'Llica'),
(51402, 514, 'Tahua'),
(51501, 515, 'Villazón'),
(51601, 516, 'San Agustín'),
(60101, 601, 'Tarija'),
(60201, 602, 'Padcaya'),
(60202, 602, 'Bermejo'),
(60301, 603, 'Yacuiba'),
(60302, 603, 'Caraparí'),
(60303, 603, 'Villamontes'),
(60401, 604, 'Uriondo'),
(60402, 604, 'Yunchará'),
(60501, 605, 'Villa San Lorenzo'),
(60502, 605, 'El Puente'),
(60601, 606, 'Entre Ríos'),
(70101, 701, 'Santa Cruz de la Sierra'),
(70102, 701, 'Cotoca'),
(70103, 701, 'Ayacucho (Porongo)'),
(70104, 701, 'La Guardia'),
(70105, 701, 'El Torno'),
(70201, 702, 'Warnes'),
(70202, 702, 'Okinawa Uno'),
(70301, 703, 'San Ignacio de Velasco'),
(70302, 703, 'San Miguel de Velasco'),
(70303, 703, 'San Rafael'),
(70401, 704, 'Buena Vista'),
(70402, 704, 'San Carlos'),
(70403, 704, 'Yapacaní'),
(70404, 704, 'San Juan'),
(70501, 705, 'San José de Chiquitos'),
(70502, 705, 'Pailón'),
(70503, 705, 'Roboré'),
(70601, 706, 'Portachuelo'),
(70602, 706, 'Santa Rosa del Sara'),
(70603, 706, 'Colpa Bélgica'),
(70701, 707, 'Lagunillas'),
(70702, 707, 'Charagua'),
(70703, 707, 'Cabezas'),
(70704, 707, 'Cuevo'),
(70705, 707, 'Gutiérrez'),
(70706, 707, 'Camiri'),
(70707, 707, 'Boyuibe'),
(70801, 708, 'Vallegrande'),
(70802, 708, 'Trigal'),
(70803, 708, 'MoroMoro'),
(70804, 708, 'Postrer Valle'),
(70805, 708, 'Pucara'),
(70901, 709, 'Samaipata'),
(70902, 709, 'Pampa Grande'),
(70903, 709, 'Mairana'),
(70904, 709, 'Quirusillas'),
(71001, 710, 'Montero'),
(71002, 710, 'Agustín Saavedra'),
(71003, 710, 'Mineros'),
(71004, 710, 'Fernández Alonso'),
(71005, 710, 'San Pedro'),
(71101, 711, 'Concepción'),
(71102, 711, 'San Javier'),
(71103, 711, 'San Ramón'),
(71104, 711, 'San Julián'),
(71105, 711, 'San Antonio de Lomerío'),
(71106, 711, 'Cuatro Cañadas'),
(71201, 712, 'San Matías'),
(71301, 713, 'Comarapa'),
(71302, 713, 'Saipina'),
(71401, 714, 'Puerto Suárez'),
(71402, 714, 'Puerto Quijarro'),
(71403, 714, 'Carmen Rivero Torrez'),
(71501, 715, 'Ascensión de Guarayos'),
(71502, 715, 'Urubichá'),
(71503, 715, 'El Puente'),
(80101, 801, 'Trinidad'),
(80102, 801, 'San Javier'),
(80201, 802, 'Riberalta'),
(80202, 802, 'Guayaramerín'),
(80301, 803, 'Reyes'),
(80302, 803, 'San Borja'),
(80303, 803, 'Santa Rosa'),
(80304, 803, 'Rurrenabaque'),
(80401, 804, 'Santa Ana del Yacuma'),
(80402, 804, 'Exaltación'),
(80501, 805, 'San Ignacio'),
(80601, 806, 'Loreto'),
(80602, 806, 'San Andrés'),
(80701, 807, 'San Joaquín'),
(80702, 807, 'San Ramón'),
(80703, 807, 'Puerto Siles'),
(80801, 808, 'Magdalena'),
(80802, 808, 'Baures'),
(80803, 808, 'Huacaraje'),
(90101, 901, 'Cobija'),
(90102, 901, 'Porvenir'),
(90103, 901, 'Bolpebra'),
(90104, 901, 'Bella Flor'),
(90201, 902, 'Puerto Rico'),
(90202, 902, 'San Pedro'),
(90203, 902, 'Filadelfia'),
(90301, 903, 'Puerto Gonzalo Moreno'),
(90302, 903, 'San Lorenzo'),
(90303, 903, 'Sena'),
(90401, 904, 'Santa Rosa del Abuná'),
(90402, 904, 'Ingavi (Humaita)'),
(90501, 905, 'Nueva Esperanza'),
(90502, 905, 'Villa Nueva (Loma Alta)'),
(90503, 905, 'Santos Mercado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `person`
--

CREATE TABLE `person` (
  `id` int(11) NOT NULL,
  `ci` int(11) DEFAULT NULL,
  `ex` varchar(3) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `name` varchar(50) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `last_name` varchar(50) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `fec_nac` date DEFAULT NULL,
  `sex` varchar(10) COLLATE utf8_spanish2_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `person`
--

INSERT INTO `person` (`id`, `ci`, `ex`, `name`, `last_name`, `fec_nac`, `sex`) VALUES
(1, 10524423, 'Lp', 'Juan', 'Perez', '1992-06-05', 'Masculino'),
(2, 201454654, 'Cb', 'Mirian', 'Lopez', '1997-11-10', 'Femenino'),
(3, 789456132, 'Pt', 'Juana', 'Ortiz', '1968-06-03', 'Femenino'),
(4, 63254112, 'Sc', 'Maria Elena', 'Garita Amurrio', '1992-11-08', 'Femenino'),
(5, 15915654, 'Lp', 'Miguel', 'Enriquez Lopez', '1993-11-12', 'Masculino'),
(6, 45789685, 'Pt', 'Ronald', 'Ramos Murillo', '1998-06-05', 'Masculino'),
(7, 12568497, 'Pa', 'Jimena', 'Jimenez', '1995-04-01', 'Femenino'),
(8, 145975632, 'Bn', 'Zulema', 'Taboada', '1975-12-09', 'Femenino'),
(9, 19564871, 'Tj', 'Leonel', 'Barrios', '1991-11-14', 'Masculino'),
(10, 5896412, 'Pt', 'Valeria', 'Zurita', '1978-09-04', 'Femenino'),
(11, 45678912, 'Cb', 'Bacilio', 'Gutierrez', '1964-07-27', 'Masculino'),
(12, 15948267, 'Sc', 'Leandro', 'Carmona', '1985-01-01', 'Masculino'),
(13, 45897465, 'Sc', 'Lucia', 'Benavides', '1982-04-15', 'Femenino'),
(14, 36985214, 'Or', 'Pablo', 'Palacios', '1990-02-01', 'Masculino'),
(15, 45879623, 'Or', 'Gisel', 'Mendez', '1986-07-26', 'Femenino'),
(16, 1489562, 'Pt', 'Manuel', 'Medrano', '1987-07-29', 'Masculino'),
(17, 4589647, 'Tj', 'Rodrigo', 'Velasquez', '1980-07-30', 'Masculino'),
(18, 7481953, 'Lp', 'Alberto', 'Arancibia', '1968-12-05', 'Masculino'),
(19, 59846271, 'Pa', 'Jaime', 'Bellido', '1960-08-01', 'Masculino'),
(20, 4568710, 'Or', 'Asdf', 'Asdf', '1952-03-03', 'Femenino'),
(21, 15987456, 'Or', 'Timoteo', 'Carranza', '1996-07-29', 'Masculino'),
(22, 1111, 'Lp', 'Joselito', 'Vaca', '1987-07-02', 'Masculino');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `province`
--

CREATE TABLE `province` (
  `id` int(11) NOT NULL,
  `id_department` int(11) DEFAULT NULL,
  `name` varchar(100) COLLATE utf8_spanish2_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `province`
--

INSERT INTO `province` (`id`, `id_department`, `name`) VALUES
(101, 1, 'Oropeza'),
(102, 1, 'Azurduy'),
(103, 1, 'Zudañez'),
(104, 1, 'Tomina'),
(105, 1, 'Hernando Siles'),
(106, 1, 'Yamparaez'),
(107, 1, 'Nor Cinti'),
(108, 1, 'Belisario BOeto'),
(109, 1, 'Sud Cinti'),
(110, 1, 'Luis Calvo'),
(201, 2, 'Murillo'),
(202, 2, 'Omasuyos'),
(203, 2, 'Pacajes'),
(204, 2, 'Camacho'),
(205, 2, 'Muñecas'),
(206, 2, 'Larecaja'),
(207, 2, 'Franz Tamayo'),
(208, 2, 'Ingavi'),
(209, 2, 'Loayza'),
(210, 2, 'Inquisivi'),
(211, 2, 'Sud Yungas'),
(212, 2, 'Los Andes'),
(213, 2, 'Aroma'),
(214, 2, 'Nor Yungas'),
(215, 2, 'Abel Iturralde'),
(216, 2, 'Bautista Saavedra'),
(217, 2, 'Manco Kapac'),
(218, 2, 'Gualberto Villarroel'),
(219, 2, 'Jose Manuel Pando'),
(220, 2, 'Caranavi'),
(301, 3, 'Cercado'),
(302, 3, 'Campero'),
(303, 3, 'Ayopaya'),
(304, 3, 'Esteban Arce'),
(305, 3, 'Arani'),
(306, 3, 'Arque'),
(307, 3, 'Capinota'),
(308, 3, 'German Jordan '),
(309, 3, 'Quillacollo'),
(310, 3, 'Chapare'),
(311, 3, 'Tapacari'),
(312, 3, 'Carradco'),
(313, 3, 'Mizque'),
(314, 3, 'Punata'),
(315, 3, 'Bolívar'),
(316, 3, 'Tiraque'),
(401, 4, 'Cercado'),
(402, 4, 'Eduardo Avaroa'),
(403, 4, 'Carangas'),
(404, 4, 'Sajama'),
(405, 4, 'Litoral de Atacama'),
(406, 4, 'Poopo'),
(407, 4, 'Pantaleon Dalence'),
(408, 4, 'Ladislao Cabrera'),
(409, 4, 'Atahuallpa'),
(410, 4, 'Saucari'),
(411, 4, 'Tomas Barron'),
(412, 4, 'Sud Carangas'),
(413, 4, 'San Pedro de Totora'),
(414, 4, 'Sebastian Pagador'),
(415, 4, 'Puerto de Mejillones'),
(416, 4, 'Nor Carangas'),
(501, 5, 'Tomas Frias'),
(502, 5, 'Rafael Bustillo'),
(503, 5, 'Cornelio Saavedra'),
(504, 5, 'Chayanta'),
(505, 5, 'Charcas'),
(506, 5, 'Nor Chichas'),
(507, 5, 'Alonso de Ibañez'),
(508, 5, 'Sur Chichas'),
(509, 5, 'Nor Lipez'),
(510, 5, 'Sur Lipez'),
(511, 5, 'Jose Maria Linares'),
(512, 5, 'Antonio Quijarro'),
(513, 5, 'Bernardino Bilbao Rioja'),
(514, 5, 'Daniel Campos'),
(515, 5, 'Modesto Omiste'),
(516, 5, 'Enrique Baldivieso'),
(601, 6, 'Cercado'),
(602, 6, 'Aniceto Arce'),
(603, 6, 'Gran Chaco'),
(604, 6, 'Aviles'),
(605, 6, 'Mendez'),
(606, 6, 'Burnet O´Oconnor'),
(701, 7, 'Andres Ibañez'),
(702, 7, 'Warnes'),
(703, 7, 'Velasco'),
(704, 7, 'Ichilo'),
(705, 7, 'Chiquitos'),
(706, 7, 'Sara'),
(707, 7, 'Cordillera'),
(708, 7, 'Vallegrande'),
(709, 7, 'Florida'),
(710, 7, 'Obispo Santiestevan'),
(711, 7, 'Ñuflo de Chavez'),
(712, 7, 'Angel Sandoval'),
(713, 7, 'Manuel María Caballero'),
(714, 7, 'German Bush'),
(715, 7, 'Guarayos'),
(801, 8, 'Cercado'),
(802, 8, 'Vaca Diez'),
(803, 8, 'Jose Ballivian'),
(804, 8, 'Yacuma'),
(805, 8, 'Moxos'),
(806, 8, 'Marban'),
(807, 8, 'Mamore'),
(808, 8, 'Itenez'),
(901, 9, 'Nicolas Suarez'),
(902, 9, 'Manuripi'),
(903, 9, 'Madre de Dios'),
(904, 9, 'Abuna'),
(905, 9, 'Federico Roman');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `publication`
--

CREATE TABLE `publication` (
  `id` int(11) NOT NULL,
  `id_user` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `description` text COLLATE utf8_spanish2_ci,
  `type` varchar(13) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `fec` datetime DEFAULT NULL,
  `img` varchar(255) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `doc` varchar(255) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `cod` varchar(7) COLLATE utf8_spanish2_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `publication`
--

INSERT INTO `publication` (`id`, `id_user`, `title`, `description`, `type`, `fec`, `img`, `doc`, `cod`) VALUES
(1, 1, 'Prueba aviso 1', 'Esta es una prueba', 'instructivo', '2017-07-07 16:06:48', '1499458008.jpeg', '', 'D-0001'),
(2, 1, 'Prueba aviso 2', 'Esta es una prueba', 'circular', '2017-07-07 16:12:50', '1499458370.jpeg', '', 'T-0000'),
(3, 1, 'Prueba aviso 3', 'Esta es una prueba', 'comunicado', '2017-07-07 16:13:29', '1499458409.jpeg', '', 'T-0000'),
(4, 1, 'Pueba reglamento 1', 'Esta es una prueba', 'reglamento', '2017-07-07 16:17:14', '', 'mozilla12-pdf.pdf-634.pdf', 'T-0000'),
(5, 1, 'Prueba normativa 1', 'Esta es una prueba', 'normativas', '2017-07-07 16:18:06', '', 'aprende java como si estuvieras en 1.pdf-686.pdf', 'T-0000'),
(6, 2, 'Prueba noticia 1', 'Esto es una prueba', 'noticia', '2017-07-07 16:19:55', '1499458795.jpeg', '', 'T-0000'),
(7, 2, 'Prueba efemeride 1', 'Esto es una prueba', 'efemerides', '2017-07-07 16:20:26', '1499458826.jpeg', '', 'T-0000');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `id_person` int(11) DEFAULT NULL,
  `id_jagroambiental` int(11) DEFAULT NULL,
  `email` varchar(100) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `position` varchar(100) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `pwd` varchar(100) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `type` varchar(5) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `cellphone` int(11) DEFAULT NULL,
  `src` varchar(255) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `last_connection` datetime DEFAULT NULL,
  `registered` date DEFAULT NULL,
  `cod_dep` varchar(7) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `cod_ja` varchar(7) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `cod_all` varchar(7) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `status` varchar(6) COLLATE utf8_spanish2_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `user`
--

INSERT INTO `user` (`id`, `id_person`, `id_jagroambiental`, `email`, `position`, `pwd`, `type`, `cellphone`, `src`, `last_connection`, `registered`, `cod_dep`, `cod_ja`, `cod_all`, `status`) VALUES
(1, 1, 100, 'adrh@gmail.com', 'Recursos Humanos', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'adrh', 75799666, '1495920830.jpeg', '2017-05-22 08:26:36', '2017-05-22', 'D-0001', 'TA-0001', 'T-0000', 'activo'),
(2, 2, 100, 'adrp@gmail.com', 'Relacionador Publico', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'adrp', 65263447, '1495920882.jpeg', '2017-05-24 11:27:55', '2017-05-24', 'D-0001', 'TA-0001', 'T-0000', 'activo'),
(3, 3, 100, 'adsg@gmail.com', '', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'adsg', 75723664, '1495920857.jpeg', '2017-05-24 11:35:48', '2017-05-24', 'D-0001', 'TA-0001', 'T-0000', 'activo'),
(4, 4, 100, 'supad@gmail.com', '', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'supad', 75784521, '', '2017-05-24 12:18:11', '2017-05-24', 'D-0001', 'TA-0001', 'T-0000', 'activo'),
(5, 5, 104, 'miguel@gmail.com', '', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 65884913, '', '2017-05-24 16:32:40', '2017-05-24', 'D-0001', 'JA-0004', 'T-0000', 'activo'),
(6, 6, 501, 'ronald@gmail.com', '', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 74859612, '', '2017-05-24 16:43:09', '2017-05-24', 'D-0005', 'JA-0029', 'T-0000', 'activo'),
(7, 7, 803, 'jime@gmail.com', '', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 74529681, '', '2017-05-24 16:49:39', '2017-05-24', 'D-0008', 'JA-0052', 'T-0000', 'activo'),
(8, 8, 704, 'zule@gmail.com', '', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 71596324, '', '2017-05-24 16:51:13', '2017-05-24', 'D-0007', 'JA-0043', 'T-0000', 'activo'),
(9, 9, 202, 'leo@gmail.com', '', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 74698521, '', '2017-05-24 16:52:27', '2017-05-24', 'D-0002', 'JA-0009', 'T-0000', 'activo'),
(10, 10, 304, 'vale@gmail.com', '', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 74185296, '', '2017-05-24 16:53:33', '2017-05-24', 'D-0003', 'JA-0019', 'T-0000', 'activo'),
(11, 11, 505, 'bacilio@gmail.com', 'juez', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 79485632, '', '2017-05-24 16:55:14', '2017-05-24', 'D-0005', 'JA-0033', 'T-0000', 'activo'),
(12, 12, 401, 'leandro@gmail.com', '', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 74985632, '', '2017-05-24 16:56:39', '2017-05-24', 'D-0004', 'JA-0024', 'T-0000', 'activo'),
(13, 13, 102, 'lucia@gmail.com', '', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 74845691, '', '2017-05-24 16:58:45', '2017-05-24', 'D-0001', 'JA-0002', 'T-0000', 'activo'),
(14, 14, 603, 'pablo@gmail.com', '', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 74985632, '', '2017-05-24 17:01:25', '2017-05-24', 'D-0006', 'JA-0036', 'T-0000', 'activo'),
(15, 15, 201, 'gisel@gmail.com', 'algo', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 74985178, '', '2017-05-24 17:03:57', '2017-05-24', 'D-0002', 'JA-0008', 'T-0000', 'activo'),
(16, 16, 504, 'manuel@gmail.com', '', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 74965824, '', '2017-05-24 17:05:52', '2017-05-24', 'D-0005', 'JA-0032', 'T-0000', 'activo'),
(17, 17, 303, 'rodrigo@gmail.com', '', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 74859741, '', '2017-05-24 17:06:59', '2017-05-24', 'D-0003', 'JA-0018', 'T-0000', 'activo'),
(18, 18, 402, 'alberto@gmail.com', '', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 71935281, '', '2017-05-24 17:08:14', '2017-05-24', 'D-0004', 'JA-0025', 'T-0000', 'activo'),
(19, 19, 806, 'jaime@gmail.com', '', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 76548912, '', '2017-05-24 17:09:49', '2017-05-24', 'D-0008', 'JA-0055', 'T-0000', 'activo'),
(20, 20, 901, 'fasdf@adsfas', 'este es el cargo', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 75772133, '', '2017-06-01 19:08:51', '2017-06-01', 'D-0009', 'JA-0057', 'T-0000', 'activo'),
(21, 21, 100, 'timo@gmail.com', 'Juez', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 74185236, '', '2017-06-08 20:50:09', '2017-06-08', 'D-0001', 'TA-0001', 'T-0000', 'activo'),
(22, 22, 802, 'joselito@gmail.com', 'descgraciado', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 75784255, '', '2017-07-13 10:12:38', '2017-07-13', 'D-0008', 'JA-0051', 'T-0000', 'activo');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_publication` (`id_publication`),
  ADD KEY `id_user` (`id_user`);

--
-- Indices de la tabla `communicate`
--
ALTER TABLE `communicate`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_use` (`id_use`),
  ADD KEY `id_usr` (`id_usr`);

--
-- Indices de la tabla `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `img`
--
ALTER TABLE `img`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `j_agroambiental`
--
ALTER TABLE `j_agroambiental`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_municipality` (`id_municipality`);

--
-- Indices de la tabla `municipality`
--
ALTER TABLE `municipality`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_province` (`id_province`);

--
-- Indices de la tabla `person`
--
ALTER TABLE `person`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `province`
--
ALTER TABLE `province`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_department` (`id_department`);

--
-- Indices de la tabla `publication`
--
ALTER TABLE `publication`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_user` (`id_user`);

--
-- Indices de la tabla `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_person` (`id_person`),
  ADD KEY `id_jagroambiental` (`id_jagroambiental`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `comment`
--
ALTER TABLE `comment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `communicate`
--
ALTER TABLE `communicate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;
--
-- AUTO_INCREMENT de la tabla `department`
--
ALTER TABLE `department`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT de la tabla `img`
--
ALTER TABLE `img`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `j_agroambiental`
--
ALTER TABLE `j_agroambiental`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=902;
--
-- AUTO_INCREMENT de la tabla `municipality`
--
ALTER TABLE `municipality`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90504;
--
-- AUTO_INCREMENT de la tabla `person`
--
ALTER TABLE `person`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;
--
-- AUTO_INCREMENT de la tabla `province`
--
ALTER TABLE `province`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=906;
--
-- AUTO_INCREMENT de la tabla `publication`
--
ALTER TABLE `publication`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT de la tabla `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;
--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`id_publication`) REFERENCES `publication` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`id_user`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `communicate`
--
ALTER TABLE `communicate`
  ADD CONSTRAINT `communicate_ibfk_1` FOREIGN KEY (`id_use`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `communicate_ibfk_2` FOREIGN KEY (`id_usr`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `j_agroambiental`
--
ALTER TABLE `j_agroambiental`
  ADD CONSTRAINT `j_agroambiental_ibfk_1` FOREIGN KEY (`id_municipality`) REFERENCES `municipality` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `municipality`
--
ALTER TABLE `municipality`
  ADD CONSTRAINT `municipality_ibfk_1` FOREIGN KEY (`id_province`) REFERENCES `province` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `province`
--
ALTER TABLE `province`
  ADD CONSTRAINT `province_ibfk_1` FOREIGN KEY (`id_department`) REFERENCES `department` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `publication`
--
ALTER TABLE `publication`
  ADD CONSTRAINT `publication_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`id_person`) REFERENCES `person` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_ibfk_2` FOREIGN KEY (`id_jagroambiental`) REFERENCES `j_agroambiental` (`id`) ON DELETE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
