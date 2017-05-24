-- phpMyAdmin SQL Dump
-- version 4.5.2
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 24-05-2017 a las 19:16:15
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
SELECT @@identity AS id, 'not' AS error,'Comentario enviado correctamente.' AS msj;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertCommunicate` (IN `v_id_use` INT, IN `v_id_usr` INT, IN `v_message` TEXT)  BEGIN
INSERT INTO communicate VALUES(null,v_id_use,v_id_usr,v_message,CURRENT_TIMESTAMP);
SELECT @@identity AS id, 'not' AS error,'Mensaje enviado correctamente.' AS msj;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertDepartment` (IN `v_name` VARCHAR(100), IN `v_cod_dep` VARCHAR(7))  BEGIN
INSERT INTO department VALUES(null,v_name,v_cod_dep);
SELECT @@identity AS id, 'not' AS error,'Departamento registrado correctamente.' AS msj;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertPublication` (IN `v_id_user` INT, IN `v_title` VARCHAR(255), IN `v_description` TEXT, IN `v_img` VARCHAR(255), IN `v_doc` VARCHAR(255), IN `v_cod` VARCHAR(7))  BEGIN
INSERT INTO publication VALUES(null,v_id_user,v_title,v_description,CURRENT_TIMESTAMP,v_img,v_doc,v_cod);
SELECT @@identity AS id, 'not' AS error,'Publicación registrada correctamente.' AS msj;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pInsertUser` (IN `v_id_person` INT, IN `v_id_jagroambiental` INT, IN `v_email` VARCHAR(100), IN `v_pwd` VARCHAR(100), IN `v_type` VARCHAR(5), IN `v_cellphone` INT, IN `v_cod_dep` VARCHAR(7), IN `v_cod_ja` VARCHAR(7), IN `v_cod_all` VARCHAR(7))  BEGIN
IF NOT EXISTS(SELECT id FROM user WHERE email LIKE v_email) THEN
INSERT INTO user VALUES(null,v_id_person,v_id_jagroambiental,v_email,v_pwd,v_type,v_cellphone,'',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,v_cod_dep,v_cod_ja,v_cod_all,'activo');
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
SET us = (SELECT id FROM user WHERE pwd LIKE v_pwdA);

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
  `fec` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

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
(1, 'La Paz', 'D-0001'),
(2, 'Oruro', 'D-0002'),
(3, 'Potosi', 'D-0003'),
(4, 'Cochabamba', 'D-0004'),
(5, 'Chuquisaca', 'D-0005'),
(6, 'Tarija', 'D-0006'),
(7, 'Pando', 'D-0007'),
(8, 'Beni', 'D-0008'),
(9, 'Santa Cruz', 'D-0009');

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
(1, 1, 'JA La Paz', 'JA-0001'),
(2, 2, 'JA Oruro', 'JA-0002'),
(3, 3, 'JA Potosi', 'JA-0003'),
(4, 4, 'JA Cochabamba', 'JA-0004'),
(5, 5, 'JA Sucre', 'JA-0005'),
(6, 6, 'JA Tarija', 'JA-0006'),
(7, 7, 'JA Cobija', 'JA-0007'),
(8, 8, 'JA Trinidad', 'JA-0009');

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
(1, 1, 'La Paz'),
(2, 2, 'Oruro'),
(3, 3, 'Potosi'),
(4, 4, 'Cochabamba'),
(5, 5, 'Sucre'),
(6, 6, 'Tarija'),
(7, 7, 'Cobija'),
(8, 8, 'Trinidad'),
(9, 9, 'Santa Cruz de la Sierra');

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
(1, 10524423, 'Lp', 'Juan', 'Perez', '1992-05-05', 'Masculino'),
(2, 201454654, 'Cb', 'Mirian', 'Lopez', '1997-11-10', 'Femenino'),
(3, 789456132, 'Pt', 'Juana', 'Ortiz', '1968-06-03', 'Femenino'),
(4, 63254112, 'Sc', 'Maria Elena', 'Garita Amurrio', '1992-11-08', 'Femenino');

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
(1, 1, 'Murillo'),
(2, 2, 'Cercado'),
(3, 3, 'Tomas Frias'),
(4, 4, 'Cercado'),
(5, 5, 'Oropeza'),
(6, 6, 'Cercado'),
(7, 7, 'Nicolas Suarez'),
(8, 8, 'Cercado'),
(9, 9, 'Andres de Ibañez');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `publication`
--

CREATE TABLE `publication` (
  `id` int(11) NOT NULL,
  `id_user` int(11) DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `description` text COLLATE utf8_spanish2_ci,
  `fec` datetime DEFAULT NULL,
  `img` varchar(255) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `doc` varchar(255) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `cod` varchar(7) COLLATE utf8_spanish2_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `id_person` int(11) DEFAULT NULL,
  `id_jagroambiental` int(11) DEFAULT NULL,
  `email` varchar(100) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `pwd` varchar(100) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `type` varchar(5) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `cellphone` int(11) DEFAULT NULL,
  `src` varchar(255) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `last_connection` datetime DEFAULT NULL,
  `registered` date DEFAULT NULL,
  `cod_dep` varchar(7) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `cod_ja` varchar(7) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `cod_all` varchar(7) COLLATE utf8_spanish2_ci DEFAULT NULL,
  `status` varchar(6) COLLATE utf8_spanish2_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `user`
--

INSERT INTO `user` (`id`, `id_person`, `id_jagroambiental`, `email`, `pwd`, `type`, `cellphone`, `src`, `last_connection`, `registered`, `cod_dep`, `cod_ja`, `cod_all`, `status`) VALUES
(1, 1, 1, 'adrh@gmail.com', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'adrh', 75799666, '1495634239.jpeg', '2017-05-22 08:26:36', '2017-05-22', 'D-0001', 'JA-0001', 'T-0000', 'activo'),
(2, 2, 4, 'adrp@gmail.com', '5047972cf53eea0173128db9541bf97dbf4d015d', 'adrp', 65263447, '', '2017-05-24 11:27:55', '2017-05-24', 'D-0004', 'JA-0004', 'T-0000', 'activo'),
(3, 3, 3, 'adsg@gmail.com', '5047972cf53eea0173128db9541bf97dbf4d015d', 'adsg', 75723664, '1495643409.jpeg', '2017-05-24 11:35:48', '2017-05-24', 'D-0003', 'JA-0003', 'T-0000', 'activo'),
(4, 4, 5, 'supad@gmail.com', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'supad', 75784521, '1495645998.jpeg', '2017-05-24 12:18:11', '2017-05-24', 'D-0005', 'JA-0005', 'T-0000', 'activo');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `department`
--
ALTER TABLE `department`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT de la tabla `img`
--
ALTER TABLE `img`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `j_agroambiental`
--
ALTER TABLE `j_agroambiental`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT de la tabla `municipality`
--
ALTER TABLE `municipality`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT de la tabla `person`
--
ALTER TABLE `person`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT de la tabla `province`
--
ALTER TABLE `province`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT de la tabla `publication`
--
ALTER TABLE `publication`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`id_publication`) REFERENCES `publication` (`id`),
  ADD CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`id_user`) REFERENCES `user` (`id`);

--
-- Filtros para la tabla `communicate`
--
ALTER TABLE `communicate`
  ADD CONSTRAINT `communicate_ibfk_1` FOREIGN KEY (`id_use`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `communicate_ibfk_2` FOREIGN KEY (`id_usr`) REFERENCES `user` (`id`);

--
-- Filtros para la tabla `j_agroambiental`
--
ALTER TABLE `j_agroambiental`
  ADD CONSTRAINT `j_agroambiental_ibfk_1` FOREIGN KEY (`id_municipality`) REFERENCES `municipality` (`id`);

--
-- Filtros para la tabla `municipality`
--
ALTER TABLE `municipality`
  ADD CONSTRAINT `municipality_ibfk_1` FOREIGN KEY (`id_province`) REFERENCES `province` (`id`);

--
-- Filtros para la tabla `province`
--
ALTER TABLE `province`
  ADD CONSTRAINT `province_ibfk_1` FOREIGN KEY (`id_department`) REFERENCES `department` (`id`);

--
-- Filtros para la tabla `publication`
--
ALTER TABLE `publication`
  ADD CONSTRAINT `publication_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id`);

--
-- Filtros para la tabla `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`id_person`) REFERENCES `person` (`id`),
  ADD CONSTRAINT `user_ibfk_2` FOREIGN KEY (`id_jagroambiental`) REFERENCES `j_agroambiental` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
