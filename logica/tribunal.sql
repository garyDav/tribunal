-- phpMyAdmin SQL Dump
-- version 4.5.2
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 14-05-2017 a las 18:28:19
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
INSERT INTO user VALUES(null,v_id_person,v_id_jagroambiental,v_email,v_pwd,v_type,v_cellphone,'',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,v_cod_dep,v_cod_ja,v_cod_all);
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
SELECT id,type,'not' AS error,'Espere por favor...' AS msj FROM user WHERE id = us;
ELSE
SELECT 'yes' error,'Error: Contraseña incorrecta.' msj;
END IF;
ELSE
SELECT 'yes' error,'Error: Correo no registrado.' msj;
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

--
-- Volcado de datos para la tabla `communicate`
--

INSERT INTO `communicate` (`id`, `id_use`, `id_usr`, `message`, `fec`) VALUES
(1, 2, 5, 'hola como estas', '2017-05-11 09:41:44'),
(2, 5, 2, 'bien y tu', '2017-05-11 09:42:32'),
(3, 1, 2, 'que problema hay', '2017-05-11 09:43:04'),
(4, 1, 5, 'parangaricutirimicuaro', '2017-05-11 09:43:30'),
(5, 5, 3, 'esta es el dato que necesitabamos', '2017-05-11 09:44:00');

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
(1, 20152126, 'Or', 'Juan', 'Perez', '1992-05-05', 'Masculino'),
(2, 7476460, 'chu', 'nelson', 'mamani burgos', '1988-11-14', 'masculino'),
(3, 111222, 'coc', 'roberto', 'molina', '1990-10-12', 'masculino'),
(4, 111333, 'la ', 'claudia', 'zambrana', '1991-08-02', 'femenino'),
(5, 111444, 'ben', 'sandra', 'aparicio', '1987-03-05', 'femenino'),
(6, 222333, 'tar', 'pedro', 'montes', '1985-12-10', 'masculino'),
(7, 222444, 'san', 'samuel', 'limon', '1995-09-25', 'masculino'),
(8, 444555, 'pot', 'patricia', 'aguilar', '1992-02-20', 'femenino'),
(9, 15987452, 'Pt', 'Angel', 'Cornejo', '1990-12-12', 'masculino'),
(10, 48521598, 'SC', 'Adolfo', 'Sandoval', '1989-10-16', 'masculino'),
(12, 45678925, 'Cbj', 'Jorge', 'Medrano', '2000-01-02', 'masculino'),
(13, 15948625, 'Cbb', 'Daniela', 'Mazano', '0000-00-00', 'femenino');

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

--
-- Volcado de datos para la tabla `publication`
--

INSERT INTO `publication` (`id`, `id_user`, `title`, `description`, `fec`, `img`, `doc`, `cod`) VALUES
(1, 5, 'La Jurisdiccion Agroambiental', 'Siguiendo la tendencia de algunos países latinoamericanos como Argentina, Brasil, Chile, Costa Rica, Ecuador, México y Perú, que poseen dentro de su ordenamiento jurídico, la jurisdicción agraria y ambiental; Bolivia a través de la Nueva Constitución Política del Estado', '2017-05-11 10:05:25', '', NULL, 'JA-0004'),
(2, 3, 'la equidad de genero en la JA', 'El Programa Equidad de Género Familia y Justicia, viene participando en reuniones i encuentros convocadas por el Viceministerio de Igualdad de Oportunidades dependiente de Ministerio de Justicia y fortaleciendo a las Organizaciones Económicas Campesinas Indígenas y Originarias de Bolivia. Se realizaron dos cumbres de mujeres a Nivel Nacional, la primera el año 2008 (1ra. Cumbre), donde se toco principalmente el tema de la discriminación, En la 2da. Cumbre, se conformo La Alianza de Organizaciones de Mujeres por la Revolución Democrática Cultural y la Unidad en la cual participan 16 organizaciones de diferentes lugares del país', '2017-05-12 18:31:38', '', NULL, 'D-0004'),
(3, 5, 'Nueva justicia en Bolivia. ', 'Con el reto de acabar con la retardación, la corrupción y hacer que la justicia sea más justa para los bolivianos, desde el martes el país contará con un nuevo Órgano Judicial conformado por 56 magistrados electos por el voto popular del pueblo en una histórica elección realizada el 16 de octubre de 2011. Por primera vez, la equidad de género prevalecerá en el nuevo Órgano, toda vez que de la totalidad de autoridades electas para el Tribunal Supremo de Justicia, el Consejo de la Magistratura, el Tribunal Constitucional Plurinacional y el Tribunal Agroambiental son 28 mujeres y 28 varones.', '2017-05-12 18:40:16', '', NULL, 'JA-0002'),
(4, 6, 'Ministro Justicia de Bolivia va a Chile a analizar defensa de 9 funcionarios', '"Vamos a participar en diversas reuniones con el equipo jurídico que defiende a nuestros compatriotas, a los nueve bolivianos injustamente detenidos, retenidos en el Estado chileno", afirmó el ministro, que cuenta con el visado para el viaje a ese país', '2017-05-12 18:43:31', '', NULL, 'D-0002'),
(5, 7, '  Ministro de Justicia boliviano: Dichos del canciller Muñoz son “delirantes”', 'Arce lamentó "profundamente" que las autoridades chilenas hayan negado el visado a los presidentes del Senado boliviano, José Alberto Gonzales, y de la Cámara de Diputados, Gabriela Montaño, quienes tenían la intención de visitar a los nueve detenidos.', '2017-05-12 18:45:01', '', NULL, 'T-0000'),
(6, 3, 'MINISTERIO DE JUSTICIA ENVÍA A LA CÁRCEL A FUNCIONARIO QUE FALSIFICÓ DOCUMENTO UNIVERSITARIO PARA ACCEDER A CARGO PÚBLICO', ' La Paz, 11 de mayo (MJyTI).- El Juez Quinto de Instrucción Cautelar de La Paz determinó la detención preventiva, en la cárcel de San Pedro, del señor Cesar Luis Catunta Alanoca, quien fraguó un documento universitario para ser contratado en el Ministerio de Justicia. Como parte de la política…', '2017-05-12 18:46:30', '', NULL, 'JA-0005');

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
  `cod_all` varchar(7) COLLATE utf8_spanish2_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish2_ci;

--
-- Volcado de datos para la tabla `user`
--

INSERT INTO `user` (`id`, `id_person`, `id_jagroambiental`, `email`, `pwd`, `type`, `cellphone`, `src`, `last_connection`, `registered`, `cod_dep`, `cod_ja`, `cod_all`) VALUES
(1, 1, NULL, 'juan@gmail.com', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'supad', 88888888, NULL, '2017-05-07 00:38:31', '2017-05-07', 'D-0001', 'JA-0005', 'T-0000'),
(2, 2, NULL, 'leo@hotmail.com', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 72869852, NULL, '2017-05-11 09:17:28', '2017-05-11', 'D-0009', 'JA-0009', 'T-0000'),
(3, 8, NULL, 'jt@hotmail.com', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 11111111, NULL, '2017-05-11 09:27:34', '2017-05-11', 'D-0002', 'JA-0004', 'T-0000'),
(5, 6, NULL, 'adrh@gmail.com', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'adrh', 74895632, NULL, '2017-05-11 09:31:56', '2017-05-11', 'D-0004', 'JA-0005', 'T-0000'),
(6, 7, NULL, 'adrp@gmail.com', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'adrp', 74859632, NULL, '2017-05-11 09:54:26', '2017-05-11', 'D-0006', 'JA-0003', 'T-0000'),
(7, 13, NULL, 'adsg@gmail.com', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'adsg', 74965823, NULL, '2017-05-11 09:56:08', '2017-05-11', 'D-0002', 'JA-0004', 'T-0000'),
(8, 3, NULL, 'lp@gmail.com', '585f7f3723df82f91fffd25a5c6900597cd4d1c1', 'user', 4579562, NULL, '2017-05-12 11:46:42', '2017-05-12', 'D-0003', 'JA-0001', 'T-0000');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT de la tabla `province`
--
ALTER TABLE `province`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT de la tabla `publication`
--
ALTER TABLE `publication`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT de la tabla `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
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
