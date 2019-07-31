-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 31-07-2019 a las 06:42:10
-- Versión del servidor: 10.3.16-MariaDB
-- Versión de PHP: 7.3.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `volar`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `agregarServiciosReservas` (IN `_reserva` BIGINT, IN `_servicio` INT, IN `_tipo` INT, IN `_cantidad` BIGINT, OUT `respuesta` VARCHAR(50))  BEGIN
     IF (SELECT count(*)  FROM servicios_vuelo_temp  WHERE idtemp_sv =  _reserva and idservi_sv =_servicio)>0 THEN
        BEGIN
       		UPDATE servicios_vuelo_temp set cantidad_sv = _cantidad, tipo_sv= _tipo  WHERE idtemp_sv = _reserva and idservi_sv = _servicio;
            SET respuesta ="Actualizado";
        END;
        ELSE 
        BEGIN
        	INSERT INTO servicios_vuelo_temp (idtemp_sv,idservi_sv,tipo_sv,cantidad_sv) VALUES(_reserva,_servicio ,_tipo ,_cantidad);
			SET respuesta ="Agregado" ;
        END;
        END IF;	



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `asigarPermisosModulos` (IN `_usuario` INT, IN `_modulo` INT, IN `_status` INT, OUT `_respuesta` VARCHAR(20))  BEGIN
     IF (SELECT count(*)  FROM permisosusuarios_volar  WHERE idusu_puv = _usuario  and idsp_puv =_modulo )>0 THEN
        BEGIN
       		UPDATE permisosusuarios_volar set status = _status  WHERE idusu_puv =_usuario   and idsp_puv = _modulo;
            SET _respuesta ="Actualizado";
        END;
      ELSE 
        BEGIN
        	INSERT INTO permisosusuarios_volar (idusu_puv,idsp_puv,status) VALUES(_usuario,_modulo,_status);
			SET _respuesta ="Agregado" ;
        END;
      END IF;	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminarDepartamento` (IN `_depto` INT, OUT `respuesta` VARCHAR(25))  BEGIN
	UPDATE departamentos_volar set status=0 where id_depto=_depto ;
    UPDATE puestos_volar set status=0 where depto_puesto = _depto ;
    SET respuesta = 'Eliminado';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getReservaData` (IN `_reserva` INT)  BEGIN
	Select id_temp, idusu_temp, IFNULL(clave_temp,"") as clave_temp, IFNULL(nombre_temp,"") as nombre_temp, IFNULL(apellidos_temp,"") as apellidos_temp, IFNULL(mail_temp,"") as mail_temp, IFNULL(telfijo_temp,"") as telfijo_temp, IFNULL(telcelular_temp,"") as telcelular_temp, IFNULL(procedencia_temp,"") as procedencia_temp, IFNULL(pasajerosa_temp,"") as pasajerosa_temp,IFNULL(pasajerosn_temp,"") as pasajerosn_temp, IFNULL(motivo_temp,"") as motivo_temp, IFNULL(tipo_temp,"") as tipo_temp,  IFNULL(fechavuelo_temp,"") as fechavuelo_temp,  IFNULL(tarifa_temp,"") as tarifa_temp, IFNULL(hotel_temp,"") as hotel_temp,  IFNULL(habitacion_temp,"") as habitacion_temp,  IFNULL(checkin_temp,"") as checkin_temp,IFNULL(checkout_temp,"") as checkout_temp,IFNULL(comentario_temp,"") as comentario_temp, IFNULL(otroscar1_temp,"") as otroscar1_temp, IFNULL(otroscar2_temp,"") as otroscar2_temp, IFNULL(precio1_temp,"") as precio1_temp, 
IFNULL(precio2_temp,"") as precio2_temp, IFNULL(tdescuento_temp,"") as tdescuento_temp, IFNULL(cantdescuento_temp,"") as cantdescuento_temp, IFNULL(total_temp,"") as total_temp, IFNULL(piloto_temp,"") as piloto_temp, IFNULL(kg_temp,"") as kg_temp, IFNULL(globo_temp,"") AS globo_temp, IFNULL(hora_temp,"") as hora_temp, register,status
from temp_volar

Where id_temp =_reserva ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getResumenREserva` (IN `_reserva` BIGINT)  BEGIN
SELECT ifnull(pasajerosa_temp,0) as pasajerosA , ifnull(pasajerosn_temp,0) as pasajerosN , IFNULL(habitacion_temp,'') as habitacion, tipo_temp, checkin_temp,checkout_temp, IFNULL(precio1_temp,0) as precio1, IFNULL(precio2_temp,0) as precio2, IFNULL(tdescuento_temp,'') as tdescuento, IFNULL(cantdescuento_temp,0) as cantdescuento, IFNULL(otroscar1_temp,'') as otroscar1,IFNULL(otroscar2_temp,'') as otroscar2,IFNULL( nombre_hotel,'') as hotel, IFNULL(nombre_habitacion,'') as habitacion, IFNULL(precio_habitacion,0) as precioHabitacion, IFNULL(capacidad_habitacion,0) as capacidadHabitacion, IFNULL(descripcion_habitacion,'') AS  descripcionHabitacion,
IFNULL(fechavuelo_temp,'Fecha No Asignada') as fechavuelo, CONCAT(IFNULL(nombre_temp,''),' ', IFNULL(apellidos_temp,'')) as nombre, IFNULL(mail_temp,'') as correo, CONCAT(IFNULL(telfijo_temp,''),' - ', IFNULL(telcelular_temp,'')) as telefonos, CONCAT(nombre_vc,' Niños:',precion_vc,', Adultos:',precioa_vc ) as tipoVuelo, precion_vc as precioN, precioa_vc as precioA

FROM temp_volar tv INNER JOIN hoteles_volar hov on tv.hotel_temp = hov.id_hotel INNER JOIN habitaciones_volar hav on hav.id_habitacion=tv.habitacion_temp INNER JOIN vueloscat_volar vcv on vcv.id_vc = tv.tipo_temp
Where id_temp=_reserva;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getServiciosReservas` (IN `_reserva` BIGINT, IN `_tipo` INT, IN `_servicio` INT)  BEGIN
	Select * from servicios_vuelo_temp where idtemp_sv = _reserva  and tipo_sv = _tipo and idservi_sv = _servicio and cantidad_sv>0 ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUsuarioInfo` (IN `_usuario` INT)  BEGIN
Select IFNULL(id_usu,"") as id_usu,
IFNULL(nombre_usu,"") as nombre_usu,
IFNULL(apellidop_usu,"") as apellidop_usu,
IFNULL(apellidom_usu,"") as apellidom_usu,
IFNULL(depto_usu,"") as depto_usu,
IFNULL(puesto_usu,"") as puesto_usu,
IFNULL(correo_usu,"") as correo_usu,
IFNULL(telefono_usu,"") as telefono_usu,
IFNULL(contrasena_usu,"") as contrasena_usu,
IFNULL(usuario_usu,"") as usuario_usu,
IFNULL(nss_usu,"") as nss_usu,
IFNULL(sd_usu,"") as sd_usu,
IFNULL(sdi_usu,"") as sdi_usu,
IFNULL(fiscal_usu,"") as fiscal_usu,
IFNULL(isr_usu,"") as isr_usu,
IFNULL(imss_usu,"") as imss_usu,
IFNULL(infonavit_usu,"") as infonavit_usu,
IFNULL(subsidio_usu,"") as subsidio_usu,
IFNULL(quincenal_usu,"") as quincenal_usu,
IFNULL(complemento_usu,"") as complemento_usu,
IFNULL(falta_usu,"") as falta_usu,
IFNULL(banco_usu,"") as banco_usu,
IFNULL(cuenta_usu,"") as cuenta_usu,
IFNULL(register,"") as register,
IFNULL(status,"") as status
from volar_usuarios Where id_usu= _usuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `permisosModulos` (IN `_idusu` INT)  BEGIN
Select DISTINCT(nombre_per) as nombre, img_per, ruta_per,id_per
FROM permisos_volar pv
	INNER JOIN subpermisos_volar spv on pv.id_per=spv.permiso_sp
    INNER JOIN permisosusuarios_volar puv on spv.id_sp=puv.idsp_puv
WHERE pv.status<>0 and spv.status<>0 and puv.status<>0 and  idusu_puv =_idusu  ORDER BY nombre ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `permisosSubModulos` (IN `_idusu` INT, IN `_idmodulo` INT)  BEGIN
Select nombre_sp, nombre_per
FROM subpermisos_volar sp INNER JOIN permisos_volar pv on pv.id_per=sp.permiso_sp INNER JOIN permisosusuarios_volar pus on pus.idsp_puv= sp.id_sp
WHERE pv.status<>0 and sp.status<>0 and pus.status<>0 AND pus.idusu_puv=_idusu and pv.id_per=_idmodulo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrarReserva` (IN `_idusu` INT, OUT `lid` BIGINT)  BEGIN
	Insert INTO temp_volar (idusu_temp) VALUES(_idusu);
   	SET lid =  LAST_INSERT_ID();
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrarUsuario` (IN `idusu` INT, IN `nombre` VARCHAR(200), IN `apellidop` VARCHAR(200), IN `apellidom` VARCHAR(200), IN `depto` INT, IN `puesto` INT, IN `correo` VARCHAR(250), IN `telefono` VARCHAR(14), IN `contrasena` VARCHAR(200), IN `usuario` VARCHAR(200), OUT `respuesta` VARCHAR(20))  BEGIN
	IF(SELECT COUNT(id_usu) from volar_usuarios where usuario_usu=usuario and status<>0 and id_usu<> idusu)>0 THEN
    SET respuesta='Ya existe el usuario';
	ELSEIF (idusu='') THEN
    	INSERT INTO volar_usuarios (nombre_usu,apellidop_usu,apellidom_usu,depto_usu,puesto_usu,correo_usu,telefono_usu,contrasena_usu,usuario_usu)
        VALUES (nombre,apellidop,apellidom,depto,puesto,correo,telefono,contrasena,usuario);
        SET respuesta ='Agregado';
    ELSEIF(contrasena='') THEN
    	UPDATE volar_usuarios set nombre_usu=nombre, apellidop_usu=apellidop, apellidom_usu = apellidom, depto_usu=depto, puesto_usu = puesto, correo_usu=correo, telefono_usu=telefono,usuario_usu=usuario 		WHERE id_usu = idusu;
   
        SET respuesta ='Actualizado';
   ELSE
    	UPDATE volar_usuarios set nombre_usu=nombre, apellidop_usu=apellidop, apellidom_usu = apellidom, depto_usu=depto, puesto_usu = puesto, correo_usu=correo, 					telefono_usu=telefono,contrasena_usu=contrasena,usuario_usu=usuario WHERE id_usu = idusu;
        SET respuesta ='Actualizado';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `remplazarReserva` (IN `_reserva` INT, OUT `lid` INT)  BEGIN 
	INSERT INTO temp_volar(
        idusu_temp,
        nombre_temp,
        apellidos_temp,
        mail_temp,
        telfijo_temp,
        telcelular_temp,
        procedencia_temp,
        pasajerosa_temp,
        pasajerosn_temp,
        motivo_temp,
        tipo_temp,
        fechavuelo_temp,
        tarifa_temp,
        hotel_temp,
        habitacion_temp,
        checkin_temp,
        checkout_temp,
        comentario_temp,
        otroscar1_temp,
        precio1_temp,
        otroscar2_temp,
        precio2_temp,
        tdescuento_temp,
        cantdescuento_temp,
        total_temp,
        piloto_temp,
        kg_temp,
        globo_temp,
        hora_temp
       )
       SELECT 
       	idusu_temp,
        nombre_temp,
        apellidos_temp,
        mail_temp,
        telfijo_temp,
        telcelular_temp,
        procedencia_temp,
        pasajerosa_temp,
        pasajerosn_temp,
        motivo_temp,
        tipo_temp,
        fechavuelo_temp,
        tarifa_temp,
        hotel_temp,
        habitacion_temp,
        checkin_temp,
        checkout_temp,
        comentario_temp,
        otroscar1_temp,
        precio1_temp,
        otroscar2_temp,
        precio2_temp,
        tdescuento_temp,
        cantdescuento_temp,
        total_temp,
        piloto_temp,
        kg_temp,
        globo_temp,
        hora_temp
       FROM temp_volar
       where id_temp =  _reserva ;
	SET lid = LAST_INSERT_ID();
    UPDATE temp_volar set clave_temp =lid  where id_temp=lid;
    UPDATE temp_volar set status = 6 where id_temp=_reserva;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `remplazarServiciosReservas` (IN `_reserva` BIGINT, IN `_oldReserva` BIGINT)  BEGIN 
	INSERT INTO servicios_vuelo_temp
		(idservi_sv,tipo_sv,cantidad_sv,status)
		SELECT idservi_sv,tipo_sv,cantidad_sv,status from servicios_vuelo_temp where idtemp_sv =_oldReserva;
        UPDATE servicios_vuelo_temp set idtemp_sv = _reserva where idtemp_sv is null;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usuarioLoggeado` (IN `_usuario` VARCHAR(100), IN `_password` VARCHAR(150))  BEGIN
 SELECT * 
 FROM volar_usuarios
 WHERE usuario_usu=_usuario and contrasena_usu=_password;
 END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bitacora_actualizaciones_volar`
--

CREATE TABLE `bitacora_actualizaciones_volar` (
  `id_bit` int(11) NOT NULL COMMENT 'Llave Primaria',
  `idres_bit` int(11) DEFAULT NULL COMMENT 'Id Rserva',
  `idusu_bit` int(11) DEFAULT NULL COMMENT 'Solicita:',
  `idvalid_bit` int(11) DEFAULT NULL COMMENT 'Valida:',
  `campo_bit` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Campo',
  `valor_bit` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Valor',
  `tipo_bit` tinyint(4) DEFAULT NULL COMMENT 'Tipo de Movimiento',
  `confirmacion_bit` tinyint(4) DEFAULT NULL COMMENT 'Confirmación',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Reistro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `bitacora_actualizaciones_volar`
--

INSERT INTO `bitacora_actualizaciones_volar` (`id_bit`, `idres_bit`, `idusu_bit`, `idvalid_bit`, `campo_bit`, `valor_bit`, `tipo_bit`, `confirmacion_bit`, `register`, `status`) VALUES
(1, 29, 1, NULL, 'pasajerosa_temp', '8', NULL, NULL, '2019-05-21 17:40:25', 1),
(2, 29, 1, NULL, 'checkin_temp', NULL, NULL, NULL, '2019-05-21 17:40:26', 1),
(3, 29, 1, NULL, 'habitacion_temp', '3', NULL, NULL, '2019-05-21 17:40:28', 1),
(4, 29, 1, NULL, 'habitacion_temp', NULL, NULL, NULL, '2019-05-21 17:41:15', 1),
(5, 29, 1, NULL, 'pasajerosa_temp', '9', NULL, NULL, '2019-05-21 17:42:07', 1),
(6, 44, 1, NULL, 'mail_temp', 'oficina@volarenglobo.com.mx', NULL, NULL, '2019-06-25 10:41:34', 1),
(7, 1005, 1, NULL, 'telcelular_temp', '5516567685', NULL, NULL, '2019-07-09 17:22:08', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bitpagos_volar`
--

CREATE TABLE `bitpagos_volar` (
  `id_bp` int(11) NOT NULL COMMENT 'Llave Primaria',
  `idres_bp` int(11) NOT NULL COMMENT 'No. Reserva',
  `idreg_bp` int(11) NOT NULL COMMENT 'Usuario que registra',
  `metodo_bp` tinyint(4) NOT NULL COMMENT 'Método de Pago',
  `banco_bp` int(11) NOT NULL COMMENT 'Banco',
  `referencia_bp` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT '# Referencia',
  `cantidad_bp` decimal(10,2) NOT NULL COMMENT 'Monto',
  `fecha_bp` date NOT NULL COMMENT 'Fecha de Pago',
  `idconc_bp` int(11) DEFAULT NULL COMMENT 'Usuario que Coincilia',
  `fechaconc_bp` datetime DEFAULT NULL COMMENT 'Fecha de Conciliación',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Register',
  `status` tinyint(4) NOT NULL DEFAULT 2 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Bitácora de Pagos';

--
-- Volcado de datos para la tabla `bitpagos_volar`
--

INSERT INTO `bitpagos_volar` (`id_bp`, `idres_bp`, `idreg_bp`, `metodo_bp`, `banco_bp`, `referencia_bp`, `cantidad_bp`, `fecha_bp`, `idconc_bp`, `fechaconc_bp`, `register`, `status`) VALUES
(1, 1005, 1, 57, 64, '070707', '135000.00', '2019-07-06', 1, '2019-07-09 17:48:51', '2019-07-09 17:39:42', 1),
(2, 1001, 1, 60, 64, '1568463', '450.00', '2019-07-07', 1, '2019-07-09 17:48:06', '2019-07-09 17:45:29', 1),
(3, 1006, 1, 59, 77, '454864', '1200.00', '2019-07-10', 1, '2019-07-09 17:54:15', '2019-07-09 17:51:09', 3),
(4, 1004, 1, 61, 78, '344649', '27950.00', '2019-07-06', 1, '2019-07-09 18:21:08', '2019-07-09 18:17:18', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cat_servicios_volar`
--

CREATE TABLE `cat_servicios_volar` (
  `id_cat` int(11) NOT NULL COMMENT 'Llave Primaria',
  `nombre_cat` varchar(200) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Nombre del Servicio',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `cat_servicios_volar`
--

INSERT INTO `cat_servicios_volar` (`id_cat`, `nombre_cat`, `register`, `status`) VALUES
(1, 'Vuelo en globo compartido de 45 a 60 min', '2019-04-08 23:01:49', 1),
(2, 'Brindis con vino espumoso Freixenet', '2019-04-09 04:20:41', 1),
(3, 'Certificado de vuelo personalizado', '2019-04-09 04:32:39', 1),
(4, 'Transportación local', '2019-04-09 04:33:04', 1),
(5, 'Seguro viajero', '2019-04-09 04:34:29', 1),
(6, 'Coffee Break', '2019-04-09 04:34:53', 1),
(7, 'Desayuno tipo Buffet', '2019-04-09 04:35:40', 1),
(8, 'Despliegue de lona', '2019-04-09 04:36:25', 1),
(9, 'Pagan 7 y el cumpleañero gratis', '2019-04-09 04:37:03', 1),
(10, 'Transportación local durante la actividad', '2019-04-09 04:38:21', 1),
(11, 'Despliegue de lona Feliz Cumpleaños', '2019-04-09 04:38:42', 1),
(12, 'Foto Impresa', '2019-04-09 04:40:02', 1),
(13, 'Brindis con Champagne Moët durante el vuelo', '2019-04-09 04:44:02', 1),
(14, 'Paquete de fotos de vuelo', '2019-04-09 04:44:22', 1),
(15, 'Souvenir', '2019-04-09 04:44:40', 1),
(16, '', '2019-04-10 20:46:52', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamentos_volar`
--

CREATE TABLE `departamentos_volar` (
  `id_depto` int(11) NOT NULL COMMENT 'Llave Primaria',
  `nombre_depto` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Nombre',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `departamentos_volar`
--

INSERT INTO `departamentos_volar` (`id_depto`, `nombre_depto`, `register`, `status`) VALUES
(1, 'SISTEMAS', '2019-07-30 15:10:37', 1),
(2, 'VENTAS', '2019-07-30 15:10:37', 1),
(3, 'FINANZAS', '2019-07-30 15:10:37', 1),
(4, 'SITIO', '2019-07-30 15:10:37', 1),
(5, 'GERENCIA', '2019-07-30 15:11:05', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `extras_volar`
--

CREATE TABLE `extras_volar` (
  `id_extra` int(11) NOT NULL COMMENT 'Llave Primaria',
  `abrev_extra` char(5) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Abreviación',
  `nombre_extra` varchar(50) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Nombre',
  `clasificacion_extra` varchar(15) COLLATE utf8_spanish_ci NOT NULL DEFAULT 'estados' COMMENT 'Clasificación',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `extras_volar`
--

INSERT INTO `extras_volar` (`id_extra`, `abrev_extra`, `nombre_extra`, `clasificacion_extra`, `register`, `status`) VALUES
(1, 'Ags', 'Aguascalientes', 'estados', '2019-03-31 17:30:30', 0),
(2, 'Ags', 'Aguascalientes', 'estados', '2019-03-31 17:30:30', 1),
(3, 'BCN', 'Baja California	', 'estados', '2019-03-31 17:30:30', 1),
(4, 'BCS.', 'Baja California Sur	', 'estados', '2019-03-31 17:30:30', 1),
(5, 'Camp.', 'Campeche', 'estados', '2019-03-31 17:30:30', 1),
(6, 'Chis', 'Chiapas', 'estados', '2019-03-31 17:30:30', 1),
(7, 'Chih.', 'Chihuahua', 'estados', '2019-03-31 17:30:30', 1),
(8, 'Coah', 'Coahuila', 'estados', '2019-03-31 17:30:30', 1),
(9, 'Coah', 'Coahuila', 'estados', '2019-03-31 17:30:30', 1),
(10, 'Col', 'Colima', 'estados', '2019-03-31 17:30:25', 1),
(11, 'D.F.', 'Distrito Federal	', 'estados', '2019-03-31 17:30:33', 1),
(12, 'Dgo', 'Durango	', 'estados', '2019-03-31 17:30:55', 1),
(13, 'Gto.', 'Guanajuato	', 'estados', '2019-03-31 17:31:24', 1),
(14, 'Gro.', 'Guerrero	', 'estados', '2019-03-31 17:32:26', 1),
(15, 'Hgo.', 'Hidalgo	', 'estados', '2019-03-31 17:33:09', 1),
(16, 'Jal.', 'Jalisco	', 'estados', '2019-03-31 17:33:33', 1),
(17, 'Edo.', 'México	', 'estados', '2019-03-31 17:34:04', 1),
(18, 'Mich.', 'Michoacan', 'estados', '2019-03-31 17:34:28', 1),
(19, 'Mor.', 'Morelos	', 'estados', '2019-03-31 17:34:52', 1),
(20, 'Nay.', 'Nayarit	', 'estados', '2019-03-31 17:39:19', 1),
(21, 'NLL.', 'Nuevo León	', 'estados', '2019-03-31 17:40:02', 1),
(22, 'Oax.', 'Oaxaca	', 'estados', '2019-03-31 17:41:08', 1),
(23, 'Pue.', 'Puebla	', 'estados', '2019-03-31 17:41:29', 1),
(24, 'Roo.', 'Quintana Roo	', 'estados', '2019-03-31 17:42:09', 0),
(25, 'Roo.', 'Quintana Roo	', 'estados', '2019-03-31 17:43:26', 1),
(26, 'SLP.', 'San Luis Potosí', 'estados', '2019-03-31 17:43:55', 1),
(27, 'Sin.', 'Sinaloa	', 'estados', '2019-03-31 17:44:49', 1),
(28, 'Son.	', 'Sonora	', 'estados', '2019-03-31 17:46:04', 1),
(29, 'Tab.', 'Tabasco	', 'estados', '2019-03-31 17:46:32', 1),
(30, 'Tamps', 'Tamaulipas', 'estados', '2019-03-31 17:47:34', 1),
(31, 'Tlx.', 'Tlaxcala	', 'estados', '2019-03-31 17:48:03', 1),
(32, 'Ver.', 'Veracruz	', 'estados', '2019-03-31 17:48:36', 1),
(33, 'Yuc.', 'Yucatan', 'estados', '2019-03-31 17:48:58', 1),
(34, 'Zac.', 'Zacatecas	', 'estados', '2019-03-31 17:49:21', 1),
(35, 'Ext.', 'Extranjero', 'estados', '2019-03-31 17:50:37', 1),
(36, '', 'Experiencia', 'motivos', '2019-03-31 19:22:54', 1),
(37, '', 'Aniversario', 'motivos', '2019-03-31 19:24:02', 1),
(38, '', 'Cumpleaños', 'motivos', '2019-03-31 19:24:27', 1),
(39, '', 'Entrega de Anillo de Compromiso ', 'motivos', '2019-03-31 19:25:19', 1),
(40, '', 'Grupo', 'motivos', '2019-03-31 19:25:43', 1),
(41, '', 'Otros', 'motivos', '2019-03-31 19:25:57', 0),
(42, '', 'Otro', 'motivos', '2019-03-31 19:26:42', 1),
(43, '', 'Feliz Vuelo', 'motivos', '2019-03-31 19:33:23', 1),
(44, '', 'Quieres Ser Mi Novi@', 'motivos', '2019-03-31 19:34:25', 1),
(45, '', 'Te Amo', 'motivos', '2019-03-31 19:34:44', 1),
(46, 'Priv.', 'Privado', 'tiposv', '2019-03-31 19:40:57', 1),
(47, 'Comp.', 'Compartido', 'tiposv', '2019-03-31 19:41:23', 1),
(48, 'Descr', 'Normal', 'tarifas', '2019-03-31 19:45:02', 1),
(49, 'Prom.', 'Promoción 1', 'tarifas', '2019-03-31 19:45:44', 1),
(50, 'Prom', 'Promoción 2', 'tarifas', '2019-03-31 19:46:19', 1),
(51, 'MIX', 'Mixto', 'tiposv', '2019-04-07 20:34:45', 1),
(52, NULL, 'Ventas', 'deptousu', '2019-04-09 14:19:43', 1),
(53, NULL, 'Compras', 'deptousu', '2019-04-09 14:19:43', 1),
(54, NULL, 'Sistemas', 'deptousu', '2019-04-09 14:20:03', 1),
(55, NULL, 'PAYPAL', 'metodopago', '2019-04-11 21:22:01', 1),
(56, NULL, 'Oxxo', 'metodopago', '2019-04-11 21:22:01', 1),
(57, NULL, 'Transferencia', 'metodopago', '2019-04-11 21:22:01', 1),
(58, NULL, 'Cheque', 'metodopago', '2019-04-11 21:22:01', 1),
(59, NULL, 'Deposito en Ventanilla', 'metodopago', '2019-04-11 21:22:01', 1),
(60, NULL, 'Efectivo', 'metodopago', '2019-04-11 21:22:01', 1),
(61, NULL, 'Deposito en Linea', 'metodopago', '2019-04-11 21:22:01', 1),
(62, NULL, 'SITIO', 'deptousu', '2019-04-17 17:53:44', 1),
(63, NULL, 'FINANZAS', 'deptousu', '2019-04-17 18:28:21', 1),
(64, NULL, 'BBVA VGAP', 'cuentasvolar', '2019-04-17 20:46:06', 1),
(65, NULL, 'Prueba', 'estados', '2019-05-18 13:50:31', 0),
(66, NULL, 'PILOTOS', 'tipogastos', '2019-05-19 16:05:52', 1),
(67, NULL, 'TRIPULACIONES', 'tipogastos', '2019-05-19 16:05:52', 1),
(68, NULL, 'COMISIONES', 'tipogastos', '2019-05-19 16:06:41', 1),
(69, NULL, 'RETORNO DE EFECTIVO', 'tipogastos', '2019-05-19 16:07:18', 1),
(70, NULL, 'I Love You', 'motivos', '2019-05-21 17:11:10', 1),
(71, NULL, 'Kaytrip', 'motivos', '2019-05-21 17:11:22', 1),
(72, NULL, 'HIS', 'motivos', '2019-05-21 17:11:34', 1),
(73, NULL, 'Experiencia Ingles', 'motivos', '2019-05-21 17:11:53', 1),
(74, NULL, 'DIRECCIÓN', 'deptousu', '2019-06-25 07:16:27', 1),
(75, NULL, 'PAYPAL', 'cuentasvolar', '2019-07-09 17:49:45', 1),
(76, NULL, 'Oxxo', 'cuentasvolar', '2019-07-09 17:50:01', 1),
(77, NULL, 'Tarjeta de Credito', 'cuentasvolar', '2019-07-09 17:50:11', 1),
(78, NULL, 'CONEKTA', 'cuentasvolar', '2019-07-09 18:16:26', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `gastos_volar`
--

CREATE TABLE `gastos_volar` (
  `id_gasto` int(11) NOT NULL COMMENT 'Llave Primaria',
  `fecha_gasto` datetime DEFAULT NULL COMMENT 'Fecha de Gasto',
  `tipo_gasto` mediumint(9) DEFAULT NULL COMMENT 'Tipo de Pago',
  `cantidad_gasto` decimal(10,2) DEFAULT NULL COMMENT 'Cantidad',
  `metodo_pago` mediumint(9) DEFAULT NULL COMMENT 'Metodo',
  `referencia_gasto` int(11) DEFAULT NULL COMMENT 'Referencia',
  `comentario_gasto` int(11) DEFAULT NULL COMMENT 'Comentario',
  `register` datetime DEFAULT NULL COMMENT 'Register',
  `status` int(11) DEFAULT NULL COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Tabla de Gastos';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `globos_volar`
--

CREATE TABLE `globos_volar` (
  `id_globo` int(11) NOT NULL COMMENT 'Llave Primaria',
  `placa_globo` char(15) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Placa',
  `nombre_globo` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Nombre',
  `peso_globo` decimal(10,2) DEFAULT NULL COMMENT 'Peso Maximo(Kg)',
  `maxpersonas_globo` tinyint(4) DEFAULT NULL COMMENT 'Personas Máximas',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `globos_volar`
--

INSERT INTO `globos_volar` (`id_globo`, `placa_globo`, `nombre_globo`, `peso_globo`, `maxpersonas_globo`, `register`, `status`) VALUES
(1, '9878-LKJH', 'Globo Amarillo', '840.20', 12, '2019-05-12 15:06:29', 0),
(2, 'AMA2345', 'Globo Amarillo', '40.00', 10, '2019-06-06 22:16:13', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `habitaciones_volar`
--

CREATE TABLE `habitaciones_volar` (
  `id_habitacion` int(11) NOT NULL COMMENT 'Llave Primaria',
  `nombre_habitacion` varchar(100) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Nombre de la Habitación',
  `idhotel_habitacion` int(11) NOT NULL COMMENT 'Hotel',
  `precio_habitacion` decimal(8,2) NOT NULL COMMENT 'Precio/Noche',
  `capacidad_habitacion` mediumint(9) DEFAULT NULL COMMENT 'Personas',
  `descripcion_habitacion` varchar(250) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Descripción',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Habitaciones por Hotel';

--
-- Volcado de datos para la tabla `habitaciones_volar`
--

INSERT INTO `habitaciones_volar` (`id_habitacion`, `nombre_habitacion`, `idhotel_habitacion`, `precio_habitacion`, `capacidad_habitacion`, `descripcion_habitacion`, `register`, `status`) VALUES
(5, 'Sencilla', 1, '950.00', 1, 'Habitación Sencilla', '2019-06-05 23:09:16', 1),
(6, 'Doble', 1, '1300.00', 2, 'Habitación Doble', '2019-06-05 23:09:46', 1),
(7, 'Triple', 1, '1450.00', 3, 'Habitación Triple', '2019-06-05 23:11:06', 1),
(8, 'Cuadruple', 1, '1650.00', 4, 'Habitación Cuádruple', '2019-06-05 23:12:35', 1),
(9, 'Suite', 1, '1850.00', 5, 'Habitación Suite', '2019-06-05 23:15:16', 1),
(10, 'Doble', 6, '650.00', 2, 'Habitación Doble', '2019-06-05 23:20:14', 1),
(11, 'Sencilla', 6, '250.00', 1, 'Habitación Sencilla', '2019-06-06 22:37:25', 1),
(12, 'hh', 6, '567.00', 567, 'bn', '2019-06-09 16:54:03', 1),
(13, 'jghjgh', 5, '546789.00', 656, 'gvbnnb', '2019-06-09 16:54:49', 0),
(14, 'Sencilla', 5, '1150.00', 2, 'Habitaci', '2019-06-09 16:58:29', 1),
(15, 'Doble', 5, '1350.00', 3, 'Habitaci', '2019-06-09 16:59:04', 1),
(16, 'Suite ', 5, '1800.00', 5, 'Habitaci', '2019-06-09 17:00:31', 1),
(17, 'Cuadruple', 5, '1600.00', 4, 'Habitación Cuádruple', '2019-06-09 17:03:18', 1),
(18, 'Triple', 5, '1380.00', 3, 'Habitacion Triple', '2019-06-09 17:05:07', 1),
(19, 'Prúeba', 5, '152.00', 122, 'Prúeba con Acentos', '2019-06-11 10:20:22', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `hoteles_volar`
--

CREATE TABLE `hoteles_volar` (
  `id_hotel` int(11) NOT NULL COMMENT 'Llave Primaria',
  `nombre_hotel` varchar(150) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Nombre del Hotel',
  `calle_hotel` varchar(50) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Calle del Hotel',
  `noint_hotel` varchar(7) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'No. Interior',
  `noext_hotel` varchar(5) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'No. Ext/Mz.',
  `colonia_hotel` varchar(75) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Colonia',
  `municipio_hotel` varchar(85) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Municipio',
  `estado_hotel` int(11) DEFAULT NULL COMMENT 'Estado',
  `cp_hotel` mediumint(9) DEFAULT NULL COMMENT 'Código Postal',
  `telefono_hotel` varchar(12) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Teléfono',
  `telefono2_hotel` varchar(12) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Teléfono opc.',
  `correo_hotel` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Correo',
  `img_hotel` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Imagen',
  `pagina_hotel` varchar(40) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Pagina Web',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Tabla de Hoteles';

--
-- Volcado de datos para la tabla `hoteles_volar`
--

INSERT INTO `hoteles_volar` (`id_hotel`, `nombre_hotel`, `calle_hotel`, `noint_hotel`, `noext_hotel`, `colonia_hotel`, `municipio_hotel`, `estado_hotel`, `cp_hotel`, `telefono_hotel`, `telefono2_hotel`, `correo_hotel`, `img_hotel`, `pagina_hotel`, `register`, `status`) VALUES
(1, 'Quinto Sol', 'Ninguna', '24', NULL, 'Teotihuacan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 18:12:51', 1),
(5, 'Villas Arqueólogicas', 'A', NULL, NULL, 'V', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-05 19:41:39', 1),
(6, 'Posada Jade', 'Calle Cuernavaca', '1', NULL, 'San Sebastián Xolalpa', 'Teotihuacan', 17, NULL, '59-4101-6112', NULL, NULL, NULL, NULL, '2019-06-05 23:19:56', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `imghoteles_volar`
--

CREATE TABLE `imghoteles_volar` (
  `id_img` int(11) NOT NULL COMMENT 'Llave Primaria',
  `idref_img` int(11) NOT NULL COMMENT 'Referencia',
  `tipo_img` tinyint(4) NOT NULL COMMENT 'Hotel/Habitación',
  `ruta_img` varchar(100) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Imagen',
  `register` datetime NOT NULL COMMENT 'Registro',
  `status` tinyint(4) NOT NULL COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Imagenes';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisosusuarios_volar`
--

CREATE TABLE `permisosusuarios_volar` (
  `id_puv` int(11) NOT NULL COMMENT 'Llave Primaria',
  `idusu_puv` int(11) NOT NULL COMMENT 'Usuario',
  `idsp_puv` int(11) NOT NULL COMMENT 'Sub Permiso',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `permisosusuarios_volar`
--

INSERT INTO `permisosusuarios_volar` (`id_puv`, `idusu_puv`, `idsp_puv`, `register`, `status`) VALUES
(33, 1, 1, '2019-04-10 18:12:12', 1),
(34, 1, 3, '2019-04-10 18:12:46', 1),
(35, 1, 4, '2019-04-10 18:12:47', 1),
(36, 1, 6, '2019-04-10 18:13:31', 1),
(37, 1, 5, '2019-04-10 18:13:45', 1),
(40, 1, 2, '2019-04-10 20:44:52', 1),
(41, 1, 7, '2019-04-10 21:05:58', 1),
(42, 1, 8, '2019-04-10 21:26:30', 0),
(43, 1, 9, '2019-04-10 21:26:32', 0),
(44, 1, 11, '2019-04-10 22:32:03', 1),
(45, 1, 12, '2019-04-11 11:03:16', 1),
(46, 1, 13, '2019-04-11 11:41:39', 1),
(47, 1, 26, '2019-04-11 14:37:28', 1),
(48, 1, 10, '2019-04-14 10:32:03', 0),
(49, 1, 28, '2019-04-14 15:06:41', 1),
(50, 1, 27, '2019-04-15 11:34:03', 1),
(51, 1, 18, '2019-04-16 11:19:09', 1),
(52, 1, 23, '2019-04-16 16:53:29', 1),
(57, 1, 30, '2019-04-18 12:44:54', 1),
(58, 1, 32, '2019-04-18 12:44:58', 1),
(59, 1, 16, '2019-04-18 12:45:08', 0),
(60, 1, 17, '2019-04-18 12:45:09', 0),
(61, 1, 15, '2019-04-18 12:45:11', 0),
(62, 1, 14, '2019-04-18 12:45:13', 1),
(63, 1, 31, '2019-04-18 12:45:18', 1),
(64, 1, 33, '2019-05-12 14:37:42', 1),
(65, 1, 34, '2019-05-12 15:07:31', 1),
(66, 1, 35, '2019-05-12 15:07:32', 1),
(67, 1, 36, '2019-05-12 15:26:05', 1),
(68, 1, 37, '2019-05-12 18:13:26', 1),
(69, 1, 38, '2019-05-12 18:14:24', 1),
(70, 1, 39, '2019-05-12 18:14:25', 1),
(71, 1, 40, '2019-05-16 20:47:45', 1),
(72, 1, 41, '2019-05-16 20:47:47', 1),
(73, 1, 42, '2019-05-16 20:47:48', 1),
(74, 1, 43, '2019-05-18 20:48:41', 1),
(75, 1, 44, '2019-05-19 22:03:23', 1),
(76, 9, 7, '2019-05-21 16:36:24', 1),
(77, 9, 11, '2019-05-21 16:36:31', 1),
(78, 9, 12, '2019-05-21 16:36:34', 0),
(79, 9, 13, '2019-05-21 16:36:37', 1),
(80, 9, 9, '2019-05-21 16:36:38', 0),
(81, 9, 8, '2019-05-21 16:36:39', 0),
(82, 9, 36, '2019-05-21 16:36:50', 1),
(83, 9, 29, '2019-05-21 16:36:57', 0),
(84, 9, 10, '2019-05-21 16:44:24', 1),
(85, 1, 24, '2019-05-21 16:45:36', 1),
(86, 8, 7, '2019-05-21 16:53:12', 1),
(87, 8, 8, '2019-05-21 16:53:15', 1),
(88, 8, 9, '2019-05-21 16:53:16', 1),
(89, 8, 10, '2019-05-21 16:53:23', 1),
(90, 8, 11, '2019-05-21 16:53:26', 1),
(91, 8, 12, '2019-05-21 16:53:35', 0),
(92, 8, 2, '2019-05-21 16:59:59', 0),
(93, 8, 24, '2019-05-21 17:00:54', 0),
(94, 8, 26, '2019-05-21 17:00:58', 0),
(95, 9, 40, '2019-05-21 17:10:00', 1),
(96, 9, 41, '2019-05-21 17:10:02', 1),
(97, 9, 42, '2019-05-21 17:10:03', 1),
(98, 1, 45, '2019-06-02 14:21:54', 1),
(99, 1, 46, '2019-06-02 14:21:56', 1),
(100, 1, 25, '2019-06-05 19:28:10', 1),
(101, 1, 29, '2019-06-05 19:29:05', 1),
(102, 9, 2, '2019-06-06 16:03:35', 0),
(103, 9, 25, '2019-06-06 16:03:41', 1),
(104, 9, 26, '2019-06-06 16:03:48', 1),
(105, 9, 24, '2019-06-06 16:03:52', 1),
(106, 9, 27, '2019-06-06 16:04:36', 0),
(107, 1, 47, '2019-06-06 22:10:43', 1),
(108, 9, 23, '2019-06-25 07:22:01', 1),
(109, 9, 47, '2019-06-25 07:22:28', 1),
(110, 9, 32, '2019-06-25 07:22:56', 1),
(111, 9, 46, '2019-06-25 07:22:57', 1),
(112, 9, 45, '2019-06-25 07:22:58', 1),
(113, 9, 14, '2019-06-25 07:23:05', 1),
(114, 9, 15, '2019-06-25 07:23:06', 1),
(115, 9, 16, '2019-06-25 07:23:06', 1),
(116, 9, 17, '2019-06-25 07:23:08', 1),
(117, 9, 28, '2019-06-25 07:23:12', 1),
(118, 9, 37, '2019-06-25 07:23:13', 1),
(119, 9, 39, '2019-06-25 07:23:15', 1),
(120, 9, 38, '2019-06-25 07:23:16', 1),
(121, 9, 33, '2019-06-25 07:23:21', 1),
(122, 9, 34, '2019-06-25 07:24:39', 1),
(123, 9, 35, '2019-06-25 07:24:40', 1),
(124, 8, 13, '2019-06-25 07:51:14', 1),
(125, 11, 2, '2019-06-25 07:53:08', 1),
(126, 11, 7, '2019-06-25 07:53:10', 1),
(127, 11, 8, '2019-06-25 07:53:12', 0),
(128, 11, 23, '2019-06-25 07:53:17', 1),
(129, 11, 24, '2019-06-25 07:53:19', 1),
(130, 11, 25, '2019-06-25 07:53:20', 1),
(131, 11, 26, '2019-06-25 07:53:21', 1),
(132, 11, 29, '2019-06-25 07:53:27', 1),
(133, 11, 36, '2019-06-25 07:53:29', 1),
(134, 11, 47, '2019-06-25 07:53:30', 1),
(135, 11, 11, '2019-06-25 07:53:34', 1),
(136, 11, 32, '2019-06-25 07:53:44', 1),
(137, 11, 46, '2019-06-25 07:53:45', 1),
(138, 11, 45, '2019-06-25 07:53:46', 1),
(139, 11, 14, '2019-06-25 07:53:49', 1),
(140, 11, 15, '2019-06-25 07:53:50', 1),
(141, 11, 16, '2019-06-25 07:53:51', 1),
(142, 11, 17, '2019-06-25 07:53:52', 1),
(143, 11, 1, '2019-06-25 07:53:59', 1),
(144, 11, 6, '2019-06-25 07:54:01', 1),
(145, 11, 3, '2019-06-25 07:54:01', 1),
(146, 11, 4, '2019-06-25 07:54:02', 1),
(147, 11, 5, '2019-06-25 07:54:03', 1),
(148, 11, 28, '2019-06-25 07:54:06', 1),
(149, 11, 38, '2019-06-25 07:54:07', 1),
(150, 11, 37, '2019-06-25 07:54:08', 1),
(151, 11, 39, '2019-06-25 07:54:09', 1),
(152, 11, 33, '2019-06-25 07:54:13', 1),
(153, 11, 34, '2019-06-25 07:54:14', 1),
(154, 11, 35, '2019-06-25 07:54:15', 1),
(155, 11, 40, '2019-06-25 07:54:18', 1),
(156, 11, 41, '2019-06-25 07:54:18', 1),
(157, 11, 42, '2019-06-25 07:54:19', 1),
(158, 11, 43, '2019-06-25 07:55:35', 1),
(159, 11, 18, '2019-06-25 07:56:26', 0),
(160, 3, 2, '2019-06-25 07:56:47', 1),
(161, 3, 8, '2019-06-25 07:56:59', 1),
(162, 3, 11, '2019-06-25 07:57:02', 1),
(163, 3, 13, '2019-06-25 07:57:12', 1),
(164, 3, 25, '2019-06-25 07:57:15', 1),
(165, 3, 26, '2019-06-25 07:57:30', 0),
(166, 1, 48, '2019-07-30 18:22:52', 1),
(167, 1, 49, '2019-07-30 18:22:52', 1),
(168, 1, 50, '2019-07-30 18:22:52', 1),
(169, 3, 47, '2019-07-30 20:13:20', 1),
(170, 3, 36, '2019-07-30 20:14:42', 1),
(171, 3, 48, '2019-07-30 20:26:00', 1),
(172, 3, 49, '2019-07-30 20:26:01', 1),
(173, 3, 50, '2019-07-30 20:26:02', 1),
(174, 3, 29, '2019-07-30 20:26:14', 1),
(175, 3, 27, '2019-07-30 20:26:15', 1),
(176, 3, 23, '2019-07-30 20:26:15', 1),
(177, 3, 24, '2019-07-30 20:26:16', 1),
(178, 3, 12, '2019-07-30 20:26:22', 1),
(179, 3, 7, '2019-07-30 20:26:24', 1),
(180, 3, 10, '2019-07-30 20:26:25', 1),
(181, 1, 51, '2019-07-30 21:47:35', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos_volar`
--

CREATE TABLE `permisos_volar` (
  `id_per` int(11) NOT NULL COMMENT 'Llave Primaria',
  `nombre_per` varchar(100) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Nombre del Permiso',
  `img_per` varchar(150) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Imagen',
  `ruta_per` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Ruta delarchivo',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` int(11) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `permisos_volar`
--

INSERT INTO `permisos_volar` (`id_per`, `nombre_per`, `img_per`, `ruta_per`, `register`, `status`) VALUES
(1, 'Captura Diaria', 'captura.png', 'vistas/reservas', '2019-03-30 22:56:21', 0),
(2, 'Reservas', 'newc.png', 'vistas/reservas/', '2019-03-31 10:29:44', 1),
(3, 'Conciliar Pagos', 'conciliar.jpg', 'conciliar_pago/', '2019-03-31 14:19:37', 0),
(4, 'Registrar Estados', 'registro.png', 'estados/', '2019-03-31 17:05:13', 0),
(5, 'Servicios', 'servicio.png', 'agregar_servicio/', '2019-03-31 20:14:55', 1),
(6, 'Vuelos', 'globo.png', 'registro_cat_vuelos/', '2019-04-05 13:37:32', 1),
(7, 'Servicios', 'catalogo.png', 'catalogo_servicios/', '2019-04-08 22:42:53', 1),
(8, 'Usuarios', 'users.png', 'vistas/usuarios/', '2019-04-09 12:59:39', 1),
(9, 'Hoteles', 'hotel.png', 'registro_hoteles/', '2019-04-14 14:00:31', 1),
(10, 'Globos', 'globo.png', 'globos/', '2019-05-12 14:37:06', 1),
(11, 'Catalogos', 'catalogo.png', 'catalogos/', '2019-05-16 20:44:27', 1),
(12, 'Sitio', 'sitio.png', 'sitio/', '2019-05-18 19:47:03', 1),
(13, 'Departamentos', 'deptos.png', 'vistas/deptos/', '2019-07-30 18:20:58', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `puestos_volar`
--

CREATE TABLE `puestos_volar` (
  `id_puesto` int(11) NOT NULL COMMENT 'Llave Primaria',
  `nombre_puesto` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Puesto',
  `depto_puesto` int(11) DEFAULT NULL COMMENT 'Departamento',
  `register` datetime DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `puestos_volar`
--

INSERT INTO `puestos_volar` (`id_puesto`, `nombre_puesto`, `depto_puesto`, `register`, `status`) VALUES
(1, 'DESARROLLADOR', 1, '2019-07-30 23:11:47', 1),
(2, 'SOPORTE', 1, '2019-07-30 23:11:47', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `relacion_permisos`
--

CREATE TABLE `relacion_permisos` (
  `id_rel` int(11) NOT NULL COMMENT 'Llave Primaria',
  `idusu_rel` int(11) NOT NULL COMMENT 'Usuario',
  `idper_rel` int(11) NOT NULL COMMENT 'Permiso',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` smallint(6) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `relacion_permisos`
--

INSERT INTO `relacion_permisos` (`id_rel`, `idusu_rel`, `idper_rel`, `register`, `status`) VALUES
(1, 1, 1, '2019-03-30 23:03:31', 1),
(2, 1, 2, '2019-03-31 10:49:33', 1),
(3, 1, 3, '2019-03-31 14:19:50', 1),
(4, 1, 4, '2019-03-31 17:05:21', 1),
(5, 1, 5, '2019-03-31 20:15:24', 1),
(6, 1, 6, '2019-04-05 13:37:56', 1),
(7, 1, 7, '2019-04-08 22:43:07', 1),
(8, 1, 8, '2019-04-09 12:59:57', 1),
(16, 1, 9, '2019-04-14 15:06:04', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rel_catvuelos_volar`
--

CREATE TABLE `rel_catvuelos_volar` (
  `id_rel` int(11) NOT NULL COMMENT 'Llave Primaria',
  `idvc_rel` int(11) NOT NULL COMMENT 'Categoría de Vuelo',
  `idcat_rel` int(11) NOT NULL COMMENT 'Servicio',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Servicios por tipo de vuelo';

--
-- Volcado de datos para la tabla `rel_catvuelos_volar`
--

INSERT INTO `rel_catvuelos_volar` (`id_rel`, `idvc_rel`, `idcat_rel`, `register`, `status`) VALUES
(14, 1, 1, '2019-04-09 12:56:22', 0),
(15, 1, 6, '2019-04-09 12:56:35', 0),
(16, 1, 7, '2019-04-09 13:08:01', 0),
(17, 1, 1, '2019-04-09 22:22:43', 0),
(18, 1, 1, '2019-04-09 22:34:38', 0),
(19, 1, 2, '2019-04-09 22:34:53', 0),
(20, 1, 3, '2019-04-09 22:35:08', 0),
(21, 1, 4, '2019-04-09 22:38:30', 0),
(22, 1, 5, '2019-04-09 22:38:43', 0),
(23, 1, 6, '2019-04-09 22:39:12', 0),
(24, 2, 1, '2019-04-09 22:40:21', 1),
(25, 2, 2, '2019-04-09 22:40:30', 1),
(26, 2, 3, '2019-04-09 22:40:48', 0),
(27, 2, 7, '2019-04-09 22:41:08', 0),
(28, 2, 4, '2019-04-09 22:41:29', 0),
(29, 2, 8, '2019-04-09 22:41:55', 0),
(30, 2, 4, '2019-04-09 22:44:42', 0),
(31, 2, 7, '2019-04-09 22:45:57', 0),
(32, 2, 4, '2019-04-09 22:47:29', 0),
(33, 2, 8, '2019-04-09 22:47:46', 0),
(34, 2, 5, '2019-04-09 22:48:12', 0),
(35, 2, 6, '2019-04-09 22:48:30', 0),
(36, 2, 12, '2019-04-09 22:49:45', 0),
(37, 2, 3, '2019-04-09 22:50:04', 0),
(38, 2, 3, '2019-04-09 22:51:15', 0),
(39, 3, 9, '2019-04-09 23:00:29', 1),
(40, 3, 1, '2019-04-09 23:00:43', 1),
(41, 3, 2, '2019-04-09 23:01:04', 1),
(42, 3, 3, '2019-04-09 23:01:16', 1),
(43, 3, 7, '2019-04-09 23:01:57', 1),
(44, 3, 10, '2019-04-09 23:02:16', 1),
(45, 3, 11, '2019-04-09 23:02:31', 1),
(46, 3, 5, '2019-04-09 23:02:47', 1),
(47, 3, 6, '2019-04-09 23:02:57', 1),
(48, 4, 1, '2019-04-09 23:07:08', 1),
(49, 4, 2, '2019-04-09 23:07:19', 1),
(50, 4, 3, '2019-04-09 23:08:32', 1),
(51, 4, 7, '2019-04-09 23:09:46', 1),
(52, 4, 4, '2019-04-09 23:09:59', 1),
(53, 4, 8, '2019-04-09 23:10:11', 1),
(54, 4, 12, '2019-04-09 23:10:32', 1),
(55, 4, 5, '2019-04-09 23:10:47', 1),
(56, 4, 6, '2019-04-09 23:10:55', 1),
(57, 2, 3, '2019-04-10 21:35:01', 1),
(58, 2, 7, '2019-04-10 21:35:14', 1),
(59, 2, 4, '2019-04-10 21:35:26', 1),
(60, 2, 8, '2019-04-10 21:35:40', 1),
(61, 2, 5, '2019-04-10 21:35:52', 1),
(62, 2, 6, '2019-04-10 21:36:05', 1),
(63, 5, 1, '2019-04-10 21:41:11', 1),
(64, 5, 13, '2019-04-10 21:42:07', 1),
(65, 5, 3, '2019-04-10 21:42:22', 1),
(66, 5, 7, '2019-04-10 21:42:36', 1),
(67, 5, 4, '2019-04-10 21:43:24', 1),
(68, 5, 8, '2019-04-10 21:43:47', 1),
(69, 5, 14, '2019-04-10 21:44:01', 1),
(70, 5, 15, '2019-04-10 21:44:14', 1),
(71, 5, 5, '2019-04-10 21:44:23', 1),
(72, 5, 6, '2019-04-10 21:44:31', 1),
(73, 1, 1, '2019-04-10 21:47:55', 1),
(74, 1, 2, '2019-04-10 21:51:10', 1),
(75, 1, 3, '2019-04-10 21:51:43', 1),
(76, 1, 4, '2019-04-10 21:51:50', 1),
(77, 1, 5, '2019-04-10 21:51:58', 1),
(78, 1, 6, '2019-04-10 21:52:12', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicios_volar`
--

CREATE TABLE `servicios_volar` (
  `id_servicio` int(11) NOT NULL COMMENT 'Llave Primaria',
  `nombre_servicio` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Nombre',
  `precio_servicio` decimal(10,2) DEFAULT NULL COMMENT 'Precio',
  `img_servicio` varchar(100) COLLATE utf8_spanish_ci NOT NULL DEFAULT '../../img/image-not-found.gif' COMMENT 'Imagen',
  `cortesia_servicio` tinyint(4) DEFAULT 1 COMMENT 'Con Cortesia',
  `cantmax_servicio` tinyint(4) DEFAULT NULL COMMENT 'Cantidad',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `servicios_volar`
--

INSERT INTO `servicios_volar` (`id_servicio`, `nombre_servicio`, `precio_servicio`, `img_servicio`, `cortesia_servicio`, `cantmax_servicio`, `register`, `status`) VALUES
(1, 'Rosas', '200.00', 'flores.png', 1, 1, '2019-03-31 20:21:40', 1),
(2, 'Champagne', '1350.00', 'vino.png', 1, 1, '2019-03-31 20:22:30', 1),
(3, 'Lona Personalizada', '600.00', 'lona_personalizada.png', 1, 1, '2019-03-31 20:25:04', 1),
(4, 'Trio', '2000.00', 'trio.jpg', 1, 1, '2019-03-31 20:29:58', 1),
(5, 'Desayuno', '140.00', 'desayuno.png', 1, 1, '2019-03-31 20:31:16', 1),
(6, 'Cena', '350.00', 'cena.png', 1, 1, '2019-03-31 20:32:08', 1),
(7, 'Fotos', '500.00', 'foto.jpg', 1, 1, '2019-03-31 21:33:58', 1),
(8, 'Video', '500.00', 'video.png', 1, 1, '2019-03-31 21:35:45', 1),
(9, 'Teotihuacan en Bici', '500.00', 'bici.png', 1, 0, '2019-03-31 21:36:20', 1),
(10, 'Spa', '1500.00', 'spa.png', 1, 0, '2019-03-31 21:37:07', 1),
(11, 'Temazcal', '600.00', 'temazcal.jpg', 1, 0, '2019-03-31 21:37:26', 1),
(12, 'Cuatrimotos', '800.00', 'cuatrimotos.png', 1, 0, '2019-03-31 21:37:42', 1),
(13, 'Entremes', '400.00', 'entremes.jpeg', 1, 0, '2019-03-31 21:38:01', 1),
(14, 'Transporte Redondo', '500.00', 'vredondo.jpg', 1, 0, '2019-03-31 21:38:32', 1),
(15, 'Transporte Sencillo', '300.00', 'vsencillo.png', 1, 0, '2019-03-31 21:39:28', 1),
(16, 'Foto Impresa', '200.00', 'fimpresa.png', 1, 1, '2019-03-31 21:39:50', 1),
(17, 'Guia de 1 a 4', '900.00', '3pers.png', 1, 1, '2019-03-31 21:40:15', 1),
(18, 'Guia de 5 a 10', '1500.00', '5pers.jpg', 1, 1, '2019-03-31 21:40:35', 1),
(19, 'Servcio', '200.00', 'newc.png', 1, NULL, '2019-04-01 08:26:22', 0),
(20, 'prueba2', '100.00', 'newc.png', 1, NULL, '2019-04-01 10:47:38', 0),
(21, 'Prueba', '500.00', 'newc.png', 0, NULL, '2019-04-02 20:44:23', 0),
(22, 'otro', '1250.00', 'new.png', 1, NULL, '2019-04-08 22:38:29', 0),
(23, 'sa', '32.00', 'newc.png', 1, NULL, '2019-04-08 22:40:12', 0),
(24, 'Prueba', '502.00', 'globo.png', 1, 1, '2019-05-20 20:18:26', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicios_vuelo_temp`
--

CREATE TABLE `servicios_vuelo_temp` (
  `id_sv` int(11) NOT NULL COMMENT 'Llave Primaria',
  `idtemp_sv` int(11) DEFAULT NULL COMMENT 'Reserva',
  `idservi_sv` int(11) NOT NULL COMMENT 'Servicio',
  `tipo_sv` tinyint(4) DEFAULT 0 COMMENT 'Tipo',
  `cantidad_sv` mediumint(9) NOT NULL DEFAULT 0 COMMENT 'Cantidad',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 2 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `servicios_vuelo_temp`
--

INSERT INTO `servicios_vuelo_temp` (`id_sv`, `idtemp_sv`, `idservi_sv`, `tipo_sv`, `cantidad_sv`, `register`, `status`) VALUES
(421, 44, 8, 1, 1, '2019-06-25 10:42:13', 2),
(422, 46, 3, 1, 1, '2019-07-08 20:02:36', 2),
(423, 46, 5, 1, 4, '2019-07-08 20:02:44', 2),
(424, 1, 3, 1, 1, '2019-07-09 17:09:08', 2),
(425, 1, 5, 1, 1, '2019-07-09 17:09:23', 2),
(426, 1, 12, 1, 2, '2019-07-09 17:09:25', 2),
(427, 1001, 3, 2, 1, '2019-07-09 17:14:14', 2),
(428, 1001, 12, 1, 0, '2019-07-09 17:14:16', 2),
(429, 1001, 5, 1, 1, '2019-07-09 17:15:38', 2),
(430, 1004, 2, 1, 1, '2019-07-09 17:18:44', 2),
(431, 1004, 3, 2, 1, '2019-07-09 17:18:48', 2),
(432, 1004, 9, 1, 6, '2019-07-09 17:18:58', 2),
(433, 1004, 7, 1, 1, '2019-07-09 17:19:06', 2),
(434, 1005, 5, 2, 1, '2019-07-09 17:21:11', 2),
(435, 1005, 12, 1, 260, '2019-07-09 17:21:16', 2),
(436, 1005, 7, 2, 260, '2019-07-09 17:21:19', 2),
(437, 1005, 2, 1, 1, '2019-07-09 17:22:18', 2),
(438, 1002, 2, 1, 0, '2019-07-09 17:27:52', 2),
(439, 1002, 1, 1, 0, '2019-07-09 17:27:54', 2),
(440, 1002, 11, 1, 0, '2019-07-09 17:27:59', 2),
(441, 1006, 9, 1, 1, '2019-07-09 17:30:26', 2),
(451, 1028, 3, 2, 1, '2019-07-28 19:29:36', 2),
(452, 1028, 12, 1, 0, '2019-07-28 19:29:36', 2),
(453, 1028, 5, 1, 1, '2019-07-28 19:29:36', 2),
(454, 1038, 5, 2, 1, '2019-07-28 19:33:08', 2),
(455, 1038, 12, 1, 260, '2019-07-28 19:33:08', 2),
(456, 1038, 7, 2, 260, '2019-07-28 19:33:08', 2),
(457, 1038, 2, 1, 1, '2019-07-28 19:33:08', 2),
(461, 1039, 5, 2, 1, '2019-07-28 19:34:47', 2),
(462, 1039, 12, 1, 260, '2019-07-28 19:34:47', 2),
(463, 1039, 7, 2, 260, '2019-07-28 19:34:47', 2),
(464, 1039, 2, 1, 1, '2019-07-28 19:34:47', 2),
(468, 1040, 5, 2, 1, '2019-07-28 19:37:13', 2),
(469, 1040, 12, 1, 260, '2019-07-28 19:37:13', 2),
(470, 1040, 7, 2, 260, '2019-07-28 19:37:13', 2),
(471, 1040, 2, 1, 1, '2019-07-28 19:37:13', 2),
(475, 1041, 5, 2, 1, '2019-07-28 19:41:11', 2),
(476, 1041, 12, 1, 260, '2019-07-28 19:41:11', 2),
(477, 1041, 7, 2, 260, '2019-07-28 19:41:11', 2),
(478, 1041, 2, 1, 1, '2019-07-28 19:41:11', 2),
(482, 1042, 5, 2, 1, '2019-07-28 19:43:09', 2),
(483, 1042, 12, 1, 260, '2019-07-28 19:43:09', 2),
(484, 1042, 7, 2, 260, '2019-07-28 19:43:09', 2),
(485, 1042, 2, 1, 1, '2019-07-28 19:43:09', 2),
(489, 1043, 5, 2, 1, '2019-07-28 19:43:42', 2),
(490, 1043, 12, 1, 260, '2019-07-28 19:43:42', 2),
(491, 1043, 7, 2, 260, '2019-07-28 19:43:42', 2),
(492, 1043, 2, 1, 1, '2019-07-28 19:43:42', 2),
(496, 1044, 5, 2, 1, '2019-07-28 19:50:18', 2),
(497, 1044, 12, 1, 260, '2019-07-28 19:50:18', 2),
(498, 1044, 7, 2, 260, '2019-07-28 19:50:18', 2),
(499, 1044, 2, 1, 1, '2019-07-28 19:50:18', 2),
(503, 1045, 5, 2, 1, '2019-07-28 19:50:29', 2),
(504, 1045, 12, 1, 260, '2019-07-28 19:50:29', 2),
(505, 1045, 7, 2, 260, '2019-07-28 19:50:29', 2),
(506, 1045, 2, 1, 1, '2019-07-28 19:50:29', 2),
(510, 1046, 5, 2, 1, '2019-07-28 19:50:40', 2),
(511, 1046, 12, 1, 260, '2019-07-28 19:50:40', 2),
(512, 1046, 7, 2, 260, '2019-07-28 19:50:40', 2),
(513, 1046, 2, 1, 1, '2019-07-28 19:50:40', 2),
(517, 1047, 5, 2, 1, '2019-07-28 19:51:38', 2),
(518, 1047, 12, 1, 260, '2019-07-28 19:51:38', 2),
(519, 1047, 7, 2, 5, '2019-07-28 19:51:38', 2),
(520, 1047, 2, 1, 1, '2019-07-28 19:51:38', 2),
(524, 1048, 5, 2, 1, '2019-07-28 21:50:28', 2),
(525, 1048, 12, 1, 260, '2019-07-28 21:50:28', 2),
(526, 1048, 7, 2, 5, '2019-07-28 21:50:28', 2),
(527, 1048, 2, 1, 1, '2019-07-28 21:50:28', 2),
(531, 1049, 5, 2, 1, '2019-07-28 21:51:04', 2),
(532, 1049, 12, 1, 260, '2019-07-28 21:51:04', 2),
(533, 1049, 7, 2, 5, '2019-07-28 21:51:04', 2),
(534, 1049, 2, 1, 1, '2019-07-28 21:51:04', 2),
(538, 1050, 5, 2, 1, '2019-07-28 21:51:24', 2),
(539, 1050, 12, 1, 260, '2019-07-28 21:51:24', 2),
(540, 1050, 7, 2, 5, '2019-07-28 21:51:24', 2),
(541, 1050, 2, 1, 1, '2019-07-28 21:51:24', 2),
(545, 1051, 5, 2, 1, '2019-07-28 21:51:31', 2),
(546, 1051, 12, 1, 260, '2019-07-28 21:51:31', 2),
(547, 1051, 7, 2, 5, '2019-07-28 21:51:31', 2),
(548, 1051, 2, 1, 1, '2019-07-28 21:51:31', 2),
(552, 1052, 5, 2, 1, '2019-07-28 21:52:02', 2),
(553, 1052, 12, 1, 260, '2019-07-28 21:52:02', 2),
(554, 1052, 7, 2, 5, '2019-07-28 21:52:02', 2),
(555, 1052, 2, 1, 1, '2019-07-28 21:52:02', 2),
(559, 1053, 5, 2, 1, '2019-07-28 21:52:37', 2),
(560, 1053, 12, 1, 260, '2019-07-28 21:52:37', 2),
(561, 1053, 7, 2, 5, '2019-07-28 21:52:37', 2),
(562, 1053, 2, 1, 1, '2019-07-28 21:52:37', 2),
(566, 1053, 4, 1, 1, '2019-07-28 21:56:14', 2),
(567, 1054, 5, 2, 1, '2019-07-28 21:57:22', 2),
(568, 1054, 12, 1, 260, '2019-07-28 21:57:22', 2),
(569, 1054, 7, 2, 5, '2019-07-28 21:57:22', 2),
(570, 1054, 2, 1, 1, '2019-07-28 21:57:22', 2),
(571, 1054, 4, 1, 1, '2019-07-28 21:57:22', 2),
(574, 1055, 5, 2, 1, '2019-07-28 21:57:58', 2),
(575, 1055, 12, 1, 260, '2019-07-28 21:57:58', 2),
(576, 1055, 7, 2, 5, '2019-07-28 21:57:58', 2),
(577, 1055, 2, 1, 1, '2019-07-28 21:57:58', 2),
(578, 1055, 4, 1, 1, '2019-07-28 21:57:58', 2),
(588, 1057, 2, 1, 1, '2019-07-28 22:00:30', 2),
(589, 1057, 3, 1, 1, '2019-07-28 22:00:31', 2),
(590, 1058, 2, 1, 1, '2019-07-28 22:00:34', 2),
(591, 1058, 3, 1, 1, '2019-07-28 22:00:34', 2),
(593, 1059, 2, 1, 1, '2019-07-28 22:01:50', 2),
(594, 1059, 3, 1, 1, '2019-07-28 22:01:50', 2),
(596, 1059, 4, 2, 1, '2019-07-28 22:01:52', 2),
(597, 1059, 10, 1, 252, '2019-07-28 22:01:54', 2),
(598, 1060, 2, 1, 1, '2019-07-28 22:01:59', 2),
(599, 1060, 3, 1, 1, '2019-07-28 22:01:59', 2),
(600, 1060, 4, 2, 1, '2019-07-28 22:01:59', 2),
(601, 1060, 10, 1, 252, '2019-07-28 22:01:59', 2),
(605, 1061, 2, 1, 1, '2019-07-28 22:02:04', 2),
(606, 1061, 3, 1, 1, '2019-07-28 22:02:04', 2),
(607, 1061, 4, 2, 1, '2019-07-28 22:02:04', 2),
(608, 1061, 10, 1, 252, '2019-07-28 22:02:04', 2),
(612, 1062, 2, 1, 1, '2019-07-28 22:02:10', 2),
(613, 1062, 3, 2, 1, '2019-07-28 22:02:10', 2),
(614, 1062, 4, 1, 1, '2019-07-28 22:02:10', 2),
(615, 1062, 10, 1, 252, '2019-07-28 22:02:10', 2),
(619, 1062, 9, 1, 252, '2019-07-28 22:04:01', 2),
(620, 1063, 2, 1, 1, '2019-07-28 22:09:25', 2),
(621, 1063, 3, 2, 1, '2019-07-28 22:09:25', 2),
(622, 1063, 4, 2, 1, '2019-07-28 22:09:25', 2),
(623, 1063, 10, 1, 252, '2019-07-28 22:09:25', 2),
(624, 1063, 9, 1, 252, '2019-07-28 22:09:25', 2),
(627, 1064, 2, 2, 1, '2019-07-28 22:09:33', 2),
(628, 1064, 3, 2, 1, '2019-07-28 22:09:33', 2),
(629, 1064, 4, 2, 1, '2019-07-28 22:09:33', 2),
(630, 1064, 10, 1, 252, '2019-07-28 22:09:33', 2),
(631, 1064, 9, 2, 252, '2019-07-28 22:09:33', 2),
(634, 1065, 2, 2, 1, '2019-07-28 22:09:40', 2),
(635, 1065, 3, 2, 1, '2019-07-28 22:09:40', 2),
(636, 1065, 4, 2, 1, '2019-07-28 22:09:40', 2),
(637, 1065, 10, 1, 252, '2019-07-28 22:09:40', 2),
(638, 1065, 9, 2, 252, '2019-07-28 22:09:40', 2),
(641, 1065, 12, 1, 252, '2019-07-28 22:10:39', 2),
(642, 1065, 17, 1, 1, '2019-07-28 22:10:49', 2),
(643, 1066, 2, 2, 1, '2019-07-28 22:10:56', 2),
(644, 1066, 3, 2, 1, '2019-07-28 22:10:56', 2),
(645, 1066, 4, 2, 1, '2019-07-28 22:10:56', 2),
(646, 1066, 10, 2, 252, '2019-07-28 22:10:56', 2),
(647, 1066, 9, 2, 252, '2019-07-28 22:10:56', 2),
(648, 1066, 12, 2, 252, '2019-07-28 22:10:56', 2),
(649, 1066, 17, 1, 1, '2019-07-28 22:10:56', 2),
(650, 1067, 2, 2, 1, '2019-07-28 22:11:05', 2),
(651, 1067, 3, 2, 1, '2019-07-28 22:11:05', 2),
(652, 1067, 4, 2, 1, '2019-07-28 22:11:05', 2),
(653, 1067, 10, 2, 252, '2019-07-28 22:11:05', 2),
(654, 1067, 9, 2, 252, '2019-07-28 22:11:05', 2),
(655, 1067, 12, 2, 252, '2019-07-28 22:11:05', 2),
(656, 1067, 17, 1, 1, '2019-07-28 22:11:05', 2),
(657, 1068, 2, 2, 1, '2019-07-28 22:11:21', 2),
(658, 1068, 3, 2, 1, '2019-07-28 22:11:21', 2),
(659, 1068, 4, 2, 1, '2019-07-28 22:11:21', 2),
(660, 1068, 10, 2, 252, '2019-07-28 22:11:21', 2),
(661, 1068, 9, 2, 252, '2019-07-28 22:11:21', 2),
(662, 1068, 12, 2, 252, '2019-07-28 22:11:21', 2),
(663, 1068, 17, 1, 1, '2019-07-28 22:11:21', 2),
(664, 1069, 2, 2, 1, '2019-07-28 22:11:36', 2),
(665, 1069, 3, 2, 1, '2019-07-28 22:11:36', 2),
(666, 1069, 4, 2, 1, '2019-07-28 22:11:36', 2),
(667, 1069, 10, 2, 252, '2019-07-28 22:11:36', 2),
(668, 1069, 9, 2, 252, '2019-07-28 22:11:36', 2),
(669, 1069, 12, 2, 252, '2019-07-28 22:11:36', 2),
(670, 1069, 17, 1, 1, '2019-07-28 22:11:36', 2),
(671, 1070, 2, 2, 1, '2019-07-28 22:11:45', 2),
(672, 1070, 3, 2, 1, '2019-07-28 22:11:45', 2),
(673, 1070, 4, 2, 1, '2019-07-28 22:11:45', 2),
(674, 1070, 10, 2, 252, '2019-07-28 22:11:45', 2),
(675, 1070, 9, 2, 252, '2019-07-28 22:11:45', 2),
(676, 1070, 12, 2, 252, '2019-07-28 22:11:45', 2),
(677, 1070, 17, 1, 1, '2019-07-28 22:11:45', 2),
(678, 1071, 2, 2, 1, '2019-07-28 22:11:57', 2),
(679, 1071, 3, 2, 1, '2019-07-28 22:11:57', 2),
(680, 1071, 4, 2, 1, '2019-07-28 22:11:57', 2),
(681, 1071, 10, 2, 252, '2019-07-28 22:11:57', 2),
(682, 1071, 9, 2, 252, '2019-07-28 22:11:57', 2),
(683, 1071, 12, 2, 252, '2019-07-28 22:11:57', 2),
(684, 1071, 17, 1, 1, '2019-07-28 22:11:57', 2),
(685, 1072, 2, 2, 1, '2019-07-28 22:12:07', 2),
(686, 1072, 3, 2, 1, '2019-07-28 22:12:07', 2),
(687, 1072, 4, 2, 1, '2019-07-28 22:12:07', 2),
(688, 1072, 10, 2, 252, '2019-07-28 22:12:07', 2),
(689, 1072, 9, 2, 252, '2019-07-28 22:12:07', 2),
(690, 1072, 12, 2, 252, '2019-07-28 22:12:07', 2),
(691, 1072, 17, 1, 1, '2019-07-28 22:12:07', 2),
(692, 1073, 2, 2, 1, '2019-07-28 22:22:30', 2),
(693, 1073, 3, 2, 1, '2019-07-28 22:22:30', 2),
(694, 1073, 4, 2, 1, '2019-07-28 22:22:30', 2),
(695, 1073, 10, 2, 252, '2019-07-28 22:22:30', 2),
(696, 1073, 9, 2, 252, '2019-07-28 22:22:30', 2),
(697, 1073, 12, 2, 252, '2019-07-28 22:22:30', 2),
(698, 1073, 17, 1, 1, '2019-07-28 22:22:30', 2),
(699, 1074, 2, 2, 1, '2019-07-28 22:32:54', 2),
(700, 1074, 3, 2, 1, '2019-07-28 22:32:54', 2),
(701, 1074, 4, 2, 1, '2019-07-28 22:32:54', 2),
(702, 1074, 10, 2, 252, '2019-07-28 22:32:54', 2),
(703, 1074, 9, 1, 252, '2019-07-28 22:32:54', 2),
(704, 1074, 12, 2, 252, '2019-07-28 22:32:54', 2),
(705, 1074, 17, 1, 1, '2019-07-28 22:32:54', 2),
(706, 1075, 2, 2, 1, '2019-07-28 23:28:50', 2),
(707, 1075, 3, 2, 1, '2019-07-28 23:28:50', 2),
(708, 1075, 4, 2, 1, '2019-07-28 23:28:50', 2),
(709, 1075, 10, 2, 252, '2019-07-28 23:28:50', 2),
(710, 1075, 9, 1, 252, '2019-07-28 23:28:50', 2),
(711, 1075, 12, 2, 252, '2019-07-28 23:28:50', 2),
(712, 1075, 17, 1, 1, '2019-07-28 23:28:50', 2),
(713, 1076, 2, 2, 1, '2019-07-28 23:29:18', 2),
(714, 1076, 3, 2, 1, '2019-07-28 23:29:18', 2),
(715, 1076, 4, 2, 1, '2019-07-28 23:29:18', 2),
(716, 1076, 10, 2, 252, '2019-07-28 23:29:18', 2),
(717, 1076, 9, 1, 252, '2019-07-28 23:29:18', 2),
(718, 1076, 12, 2, 252, '2019-07-28 23:29:18', 2),
(719, 1076, 17, 1, 1, '2019-07-28 23:29:18', 2),
(720, 1077, 2, 2, 1, '2019-07-28 23:30:31', 2),
(721, 1077, 3, 2, 1, '2019-07-28 23:30:31', 2),
(722, 1077, 4, 2, 1, '2019-07-28 23:30:31', 2),
(723, 1077, 10, 2, 252, '2019-07-28 23:30:31', 2),
(724, 1077, 9, 1, 252, '2019-07-28 23:30:31', 2),
(725, 1077, 12, 2, 252, '2019-07-28 23:30:31', 2),
(726, 1077, 17, 1, 1, '2019-07-28 23:30:31', 2),
(727, 1078, 2, 2, 1, '2019-07-29 00:16:13', 2),
(728, 1078, 3, 2, 1, '2019-07-29 00:16:13', 2),
(729, 1078, 4, 2, 1, '2019-07-29 00:16:13', 2),
(730, 1078, 10, 2, 252, '2019-07-29 00:16:13', 2),
(731, 1078, 9, 1, 252, '2019-07-29 00:16:13', 2),
(732, 1078, 12, 2, 252, '2019-07-29 00:16:13', 2),
(733, 1078, 17, 1, 1, '2019-07-29 00:16:13', 2),
(734, 1079, 2, 2, 1, '2019-07-29 00:20:55', 2),
(735, 1079, 3, 2, 1, '2019-07-29 00:20:55', 2),
(736, 1079, 4, 2, 1, '2019-07-29 00:20:55', 2),
(737, 1079, 10, 2, 252, '2019-07-29 00:20:55', 2),
(738, 1079, 9, 1, 252, '2019-07-29 00:20:55', 2),
(739, 1079, 12, 2, 252, '2019-07-29 00:20:55', 2),
(740, 1079, 17, 1, 1, '2019-07-29 00:20:55', 2),
(741, 1080, 2, 2, 1, '2019-07-29 00:21:45', 2),
(742, 1080, 3, 2, 1, '2019-07-29 00:21:45', 2),
(743, 1080, 4, 2, 1, '2019-07-29 00:21:45', 2),
(744, 1080, 10, 2, 252, '2019-07-29 00:21:45', 2),
(745, 1080, 9, 1, 252, '2019-07-29 00:21:45', 2),
(746, 1080, 12, 2, 252, '2019-07-29 00:21:45', 2),
(747, 1080, 17, 1, 1, '2019-07-29 00:21:45', 2),
(748, 1081, 2, 2, 1, '2019-07-29 00:22:03', 2),
(749, 1081, 3, 2, 1, '2019-07-29 00:22:03', 2),
(750, 1081, 4, 2, 1, '2019-07-29 00:22:03', 2),
(751, 1081, 10, 2, 252, '2019-07-29 00:22:03', 2),
(752, 1081, 9, 1, 252, '2019-07-29 00:22:03', 2),
(753, 1081, 12, 2, 252, '2019-07-29 00:22:03', 2),
(754, 1081, 17, 1, 1, '2019-07-29 00:22:03', 2),
(755, 1082, 2, 2, 1, '2019-07-29 08:26:13', 2),
(756, 1082, 3, 2, 1, '2019-07-29 08:26:13', 2),
(757, 1082, 4, 2, 1, '2019-07-29 08:26:13', 2),
(758, 1082, 10, 2, 252, '2019-07-29 08:26:13', 2),
(759, 1082, 9, 1, 252, '2019-07-29 08:26:13', 2),
(760, 1082, 12, 2, 252, '2019-07-29 08:26:13', 2),
(761, 1082, 17, 1, 1, '2019-07-29 08:26:13', 2),
(762, 1083, 2, 2, 0, '2019-07-29 08:39:00', 2),
(763, 1083, 3, 2, 1, '2019-07-29 08:39:00', 2),
(764, 1083, 4, 2, 1, '2019-07-29 08:39:00', 2),
(765, 1083, 10, 2, 252, '2019-07-29 08:39:00', 2),
(766, 1083, 9, 1, 252, '2019-07-29 08:39:00', 2),
(767, 1083, 12, 2, 252, '2019-07-29 08:39:00', 2),
(768, 1083, 17, 1, 1, '2019-07-29 08:39:00', 2),
(769, 1084, 2, 2, 0, '2019-07-29 08:59:01', 2),
(770, 1084, 3, 2, 1, '2019-07-29 08:59:01', 2),
(771, 1084, 4, 2, 1, '2019-07-29 08:59:01', 2),
(772, 1084, 10, 2, 252, '2019-07-29 08:59:01', 2),
(773, 1084, 9, 1, 0, '2019-07-29 08:59:01', 2),
(774, 1084, 12, 2, 252, '2019-07-29 08:59:01', 2),
(775, 1084, 17, 1, 1, '2019-07-29 08:59:01', 2),
(776, 1085, 2, 2, 0, '2019-07-29 08:59:14', 2),
(777, 1085, 3, 2, 1, '2019-07-29 08:59:14', 2),
(778, 1085, 4, 2, 1, '2019-07-29 08:59:14', 2),
(779, 1085, 10, 2, 252, '2019-07-29 08:59:14', 2),
(780, 1085, 9, 1, 0, '2019-07-29 08:59:14', 2),
(781, 1085, 12, 2, 252, '2019-07-29 08:59:14', 2),
(782, 1085, 17, 1, 1, '2019-07-29 08:59:14', 2),
(783, 1086, 2, 2, 0, '2019-07-29 09:02:18', 2),
(784, 1086, 3, 2, 1, '2019-07-29 09:02:18', 2),
(785, 1086, 4, 2, 1, '2019-07-29 09:02:18', 2),
(786, 1086, 10, 2, 252, '2019-07-29 09:02:18', 2),
(787, 1086, 9, 1, 0, '2019-07-29 09:02:18', 2),
(788, 1086, 12, 2, 252, '2019-07-29 09:02:18', 2),
(789, 1086, 17, 1, 1, '2019-07-29 09:02:18', 2),
(790, 1087, 2, 2, 0, '2019-07-29 09:02:47', 2),
(791, 1087, 3, 2, 1, '2019-07-29 09:02:47', 2),
(792, 1087, 4, 2, 1, '2019-07-29 09:02:47', 2),
(793, 1087, 10, 2, 252, '2019-07-29 09:02:47', 2),
(794, 1087, 9, 1, 252, '2019-07-29 09:02:47', 2),
(795, 1087, 12, 2, 252, '2019-07-29 09:02:47', 2),
(796, 1087, 17, 1, 1, '2019-07-29 09:02:47', 2),
(797, 1088, 2, 2, 0, '2019-07-29 09:02:55', 2),
(798, 1088, 3, 2, 0, '2019-07-29 09:02:55', 2),
(799, 1088, 4, 2, 1, '2019-07-29 09:02:55', 2),
(800, 1088, 10, 2, 252, '2019-07-29 09:02:55', 2),
(801, 1088, 9, 1, 252, '2019-07-29 09:02:55', 2),
(802, 1088, 12, 2, 252, '2019-07-29 09:02:55', 2),
(803, 1088, 17, 1, 1, '2019-07-29 09:02:55', 2),
(804, 1089, 2, 2, 0, '2019-07-29 09:03:00', 2),
(805, 1089, 3, 2, 0, '2019-07-29 09:03:00', 2),
(806, 1089, 4, 2, 0, '2019-07-29 09:03:00', 2),
(807, 1089, 10, 2, 0, '2019-07-29 09:03:00', 2),
(808, 1089, 9, 1, 252, '2019-07-29 09:03:00', 2),
(809, 1089, 12, 2, 252, '2019-07-29 09:03:00', 2),
(810, 1089, 17, 1, 1, '2019-07-29 09:03:00', 2),
(811, 1090, 2, 2, 0, '2019-07-29 09:03:06', 2),
(812, 1090, 3, 2, 0, '2019-07-29 09:03:06', 2),
(813, 1090, 4, 2, 0, '2019-07-29 09:03:06', 2),
(814, 1090, 10, 2, 0, '2019-07-29 09:03:06', 2),
(815, 1090, 9, 1, 252, '2019-07-29 09:03:06', 2),
(816, 1090, 12, 2, 252, '2019-07-29 09:03:06', 2),
(817, 1090, 17, 1, 1, '2019-07-29 09:03:06', 2),
(818, 1090, 15, 1, 252, '2019-07-29 09:04:23', 2),
(819, 1091, 2, 2, 0, '2019-07-29 09:36:36', 2),
(820, 1091, 3, 2, 0, '2019-07-29 09:36:36', 2),
(821, 1091, 4, 2, 0, '2019-07-29 09:36:36', 2),
(822, 1091, 10, 2, 0, '2019-07-29 09:36:36', 2),
(823, 1091, 9, 1, 252, '2019-07-29 09:36:36', 2),
(824, 1091, 12, 2, 252, '2019-07-29 09:36:36', 2),
(825, 1091, 17, 1, 1, '2019-07-29 09:36:36', 2),
(826, 1091, 15, 1, 252, '2019-07-29 09:36:36', 2),
(834, 1092, 2, 2, 0, '2019-07-29 09:37:12', 2),
(835, 1092, 3, 2, 0, '2019-07-29 09:37:12', 2),
(836, 1092, 4, 2, 0, '2019-07-29 09:37:12', 2),
(837, 1092, 10, 2, 0, '2019-07-29 09:37:12', 2),
(838, 1092, 9, 1, 252, '2019-07-29 09:37:12', 2),
(839, 1092, 12, 2, 252, '2019-07-29 09:37:12', 2),
(840, 1092, 17, 1, 1, '2019-07-29 09:37:12', 2),
(841, 1092, 15, 1, 252, '2019-07-29 09:37:12', 2),
(849, 1093, 2, 2, 0, '2019-07-29 09:39:34', 2),
(850, 1093, 3, 2, 0, '2019-07-29 09:39:34', 2),
(851, 1093, 4, 2, 0, '2019-07-29 09:39:34', 2),
(852, 1093, 10, 2, 0, '2019-07-29 09:39:34', 2),
(853, 1093, 9, 1, 252, '2019-07-29 09:39:34', 2),
(854, 1093, 12, 2, 252, '2019-07-29 09:39:34', 2),
(855, 1093, 17, 1, 1, '2019-07-29 09:39:34', 2),
(856, 1093, 15, 1, 252, '2019-07-29 09:39:34', 2),
(864, 1094, 2, 2, 0, '2019-07-29 09:39:50', 2),
(865, 1094, 3, 2, 0, '2019-07-29 09:39:50', 2),
(866, 1094, 4, 2, 0, '2019-07-29 09:39:50', 2),
(867, 1094, 10, 2, 0, '2019-07-29 09:39:50', 2),
(868, 1094, 9, 1, 252, '2019-07-29 09:39:50', 2),
(869, 1094, 12, 2, 252, '2019-07-29 09:39:50', 2),
(870, 1094, 17, 1, 1, '2019-07-29 09:39:50', 2),
(871, 1094, 15, 1, 252, '2019-07-29 09:39:50', 2),
(879, 1095, 2, 2, 0, '2019-07-29 09:41:14', 2),
(880, 1095, 3, 2, 0, '2019-07-29 09:41:14', 2),
(881, 1095, 4, 2, 0, '2019-07-29 09:41:14', 2),
(882, 1095, 10, 2, 0, '2019-07-29 09:41:14', 2),
(883, 1095, 9, 1, 252, '2019-07-29 09:41:14', 2),
(884, 1095, 12, 2, 252, '2019-07-29 09:41:14', 2),
(885, 1095, 17, 1, 1, '2019-07-29 09:41:14', 2),
(886, 1095, 15, 1, 252, '2019-07-29 09:41:14', 2),
(894, 1096, 2, 2, 0, '2019-07-29 09:42:04', 2),
(895, 1096, 3, 2, 0, '2019-07-29 09:42:04', 2),
(896, 1096, 4, 2, 0, '2019-07-29 09:42:04', 2),
(897, 1096, 10, 2, 0, '2019-07-29 09:42:04', 2),
(898, 1096, 9, 1, 252, '2019-07-29 09:42:04', 2),
(899, 1096, 12, 2, 252, '2019-07-29 09:42:04', 2),
(900, 1096, 17, 1, 1, '2019-07-29 09:42:04', 2),
(901, 1096, 15, 1, 252, '2019-07-29 09:42:04', 2),
(909, 1097, 2, 2, 0, '2019-07-29 09:42:26', 2),
(910, 1097, 3, 2, 0, '2019-07-29 09:42:26', 2),
(911, 1097, 4, 2, 0, '2019-07-29 09:42:26', 2),
(912, 1097, 10, 2, 0, '2019-07-29 09:42:26', 2),
(913, 1097, 9, 1, 252, '2019-07-29 09:42:26', 2),
(914, 1097, 12, 2, 252, '2019-07-29 09:42:26', 2),
(915, 1097, 17, 1, 1, '2019-07-29 09:42:26', 2),
(916, 1097, 15, 1, 252, '2019-07-29 09:42:26', 2),
(924, 1098, 2, 2, 0, '2019-07-29 09:44:31', 2),
(925, 1098, 3, 2, 0, '2019-07-29 09:44:31', 2),
(926, 1098, 4, 2, 0, '2019-07-29 09:44:31', 2),
(927, 1098, 10, 2, 0, '2019-07-29 09:44:31', 2),
(928, 1098, 9, 1, 252, '2019-07-29 09:44:31', 2),
(929, 1098, 12, 2, 252, '2019-07-29 09:44:31', 2),
(930, 1098, 17, 1, 1, '2019-07-29 09:44:31', 2),
(931, 1098, 15, 1, 252, '2019-07-29 09:44:31', 2),
(939, 1099, 2, 2, 0, '2019-07-29 09:45:04', 2),
(940, 1099, 3, 2, 0, '2019-07-29 09:45:04', 2),
(941, 1099, 4, 2, 0, '2019-07-29 09:45:04', 2),
(942, 1099, 10, 2, 0, '2019-07-29 09:45:04', 2),
(943, 1099, 9, 1, 252, '2019-07-29 09:45:04', 2),
(944, 1099, 12, 2, 252, '2019-07-29 09:45:04', 2),
(945, 1099, 17, 1, 1, '2019-07-29 09:45:04', 2),
(946, 1099, 15, 1, 252, '2019-07-29 09:45:04', 2),
(954, 1100, 2, 2, 0, '2019-07-29 09:45:30', 2),
(955, 1100, 3, 2, 0, '2019-07-29 09:45:30', 2),
(956, 1100, 4, 2, 0, '2019-07-29 09:45:30', 2),
(957, 1100, 10, 2, 0, '2019-07-29 09:45:30', 2),
(958, 1100, 9, 1, 252, '2019-07-29 09:45:30', 2),
(959, 1100, 12, 2, 252, '2019-07-29 09:45:30', 2),
(960, 1100, 17, 1, 1, '2019-07-29 09:45:30', 2),
(961, 1100, 15, 1, 252, '2019-07-29 09:45:30', 2),
(969, 1101, 2, 2, 0, '2019-07-29 09:46:20', 2),
(970, 1101, 3, 2, 0, '2019-07-29 09:46:20', 2),
(971, 1101, 4, 2, 0, '2019-07-29 09:46:20', 2),
(972, 1101, 10, 2, 0, '2019-07-29 09:46:20', 2),
(973, 1101, 9, 1, 252, '2019-07-29 09:46:20', 2),
(974, 1101, 12, 2, 252, '2019-07-29 09:46:20', 2),
(975, 1101, 17, 1, 1, '2019-07-29 09:46:20', 2),
(976, 1101, 15, 1, 252, '2019-07-29 09:46:20', 2),
(984, 1102, 2, 2, 0, '2019-07-29 09:48:02', 2),
(985, 1102, 3, 2, 0, '2019-07-29 09:48:02', 2),
(986, 1102, 4, 2, 0, '2019-07-29 09:48:02', 2),
(987, 1102, 10, 2, 0, '2019-07-29 09:48:02', 2),
(988, 1102, 9, 1, 252, '2019-07-29 09:48:02', 2),
(989, 1102, 12, 2, 252, '2019-07-29 09:48:02', 2),
(990, 1102, 17, 1, 1, '2019-07-29 09:48:02', 2),
(991, 1102, 15, 1, 252, '2019-07-29 09:48:02', 2),
(999, 1103, 2, 2, 0, '2019-07-29 09:50:21', 2),
(1000, 1103, 3, 2, 0, '2019-07-29 09:50:21', 2),
(1001, 1103, 4, 2, 0, '2019-07-29 09:50:21', 2),
(1002, 1103, 10, 2, 0, '2019-07-29 09:50:21', 2),
(1003, 1103, 9, 1, 252, '2019-07-29 09:50:21', 2),
(1004, 1103, 12, 2, 252, '2019-07-29 09:50:21', 2),
(1005, 1103, 17, 1, 1, '2019-07-29 09:50:21', 2),
(1006, 1103, 15, 1, 252, '2019-07-29 09:50:21', 2),
(1014, 1104, 2, 2, 0, '2019-07-29 09:51:32', 2),
(1015, 1104, 3, 2, 0, '2019-07-29 09:51:32', 2),
(1016, 1104, 4, 2, 0, '2019-07-29 09:51:32', 2),
(1017, 1104, 10, 2, 0, '2019-07-29 09:51:32', 2),
(1018, 1104, 9, 1, 252, '2019-07-29 09:51:32', 2),
(1019, 1104, 12, 2, 252, '2019-07-29 09:51:32', 2),
(1020, 1104, 17, 1, 1, '2019-07-29 09:51:32', 2),
(1021, 1104, 15, 1, 252, '2019-07-29 09:51:32', 2),
(1029, 1105, 2, 2, 0, '2019-07-29 09:52:57', 2),
(1030, 1105, 3, 2, 0, '2019-07-29 09:52:57', 2),
(1031, 1105, 4, 2, 0, '2019-07-29 09:52:57', 2),
(1032, 1105, 10, 2, 0, '2019-07-29 09:52:57', 2),
(1033, 1105, 9, 1, 252, '2019-07-29 09:52:57', 2),
(1034, 1105, 12, 2, 252, '2019-07-29 09:52:57', 2),
(1035, 1105, 17, 1, 1, '2019-07-29 09:52:57', 2),
(1036, 1105, 15, 1, 252, '2019-07-29 09:52:57', 2),
(1044, 1106, 2, 2, 0, '2019-07-29 09:56:46', 2),
(1045, 1106, 3, 2, 0, '2019-07-29 09:56:46', 2),
(1046, 1106, 4, 2, 0, '2019-07-29 09:56:46', 2),
(1047, 1106, 10, 2, 0, '2019-07-29 09:56:46', 2),
(1048, 1106, 9, 1, 252, '2019-07-29 09:56:46', 2),
(1049, 1106, 12, 2, 252, '2019-07-29 09:56:46', 2),
(1050, 1106, 17, 1, 1, '2019-07-29 09:56:46', 2),
(1051, 1106, 15, 1, 252, '2019-07-29 09:56:46', 2),
(1059, 1107, 2, 2, 0, '2019-07-29 09:57:24', 2),
(1060, 1107, 3, 2, 0, '2019-07-29 09:57:24', 2),
(1061, 1107, 4, 2, 0, '2019-07-29 09:57:24', 2),
(1062, 1107, 10, 2, 0, '2019-07-29 09:57:24', 2),
(1063, 1107, 9, 1, 252, '2019-07-29 09:57:24', 2),
(1064, 1107, 12, 2, 252, '2019-07-29 09:57:24', 2),
(1065, 1107, 17, 1, 1, '2019-07-29 09:57:24', 2),
(1066, 1107, 15, 1, 252, '2019-07-29 09:57:24', 2),
(1074, 1108, 2, 2, 0, '2019-07-29 10:06:20', 2),
(1075, 1108, 3, 2, 0, '2019-07-29 10:06:20', 2),
(1076, 1108, 4, 2, 0, '2019-07-29 10:06:20', 2),
(1077, 1108, 10, 2, 0, '2019-07-29 10:06:20', 2),
(1078, 1108, 9, 1, 252, '2019-07-29 10:06:20', 2),
(1079, 1108, 12, 2, 252, '2019-07-29 10:06:20', 2),
(1080, 1108, 17, 1, 1, '2019-07-29 10:06:20', 2),
(1081, 1108, 15, 1, 252, '2019-07-29 10:06:20', 2),
(1089, 1109, 2, 2, 0, '2019-07-29 10:06:51', 2),
(1090, 1109, 3, 2, 0, '2019-07-29 10:06:51', 2),
(1091, 1109, 4, 2, 0, '2019-07-29 10:06:51', 2),
(1092, 1109, 10, 2, 0, '2019-07-29 10:06:51', 2),
(1093, 1109, 9, 1, 252, '2019-07-29 10:06:51', 2),
(1094, 1109, 12, 2, 252, '2019-07-29 10:06:51', 2),
(1095, 1109, 17, 1, 1, '2019-07-29 10:06:51', 2),
(1096, 1109, 15, 1, 252, '2019-07-29 10:06:51', 2),
(1104, 1110, 2, 2, 0, '2019-07-29 10:07:45', 2),
(1105, 1110, 3, 2, 0, '2019-07-29 10:07:45', 2),
(1106, 1110, 4, 2, 0, '2019-07-29 10:07:45', 2),
(1107, 1110, 10, 2, 0, '2019-07-29 10:07:45', 2),
(1108, 1110, 9, 1, 252, '2019-07-29 10:07:45', 2),
(1109, 1110, 12, 2, 252, '2019-07-29 10:07:45', 2),
(1110, 1110, 17, 1, 1, '2019-07-29 10:07:45', 2),
(1111, 1110, 15, 1, 252, '2019-07-29 10:07:45', 2),
(1119, 1111, 2, 2, 0, '2019-07-29 10:09:07', 2),
(1120, 1111, 3, 2, 0, '2019-07-29 10:09:07', 2),
(1121, 1111, 4, 2, 0, '2019-07-29 10:09:07', 2),
(1122, 1111, 10, 2, 0, '2019-07-29 10:09:07', 2),
(1123, 1111, 9, 1, 252, '2019-07-29 10:09:07', 2),
(1124, 1111, 12, 2, 252, '2019-07-29 10:09:07', 2),
(1125, 1111, 17, 1, 1, '2019-07-29 10:09:07', 2),
(1126, 1111, 15, 1, 252, '2019-07-29 10:09:07', 2),
(1134, 1112, 2, 2, 0, '2019-07-29 10:10:14', 2),
(1135, 1112, 3, 2, 0, '2019-07-29 10:10:14', 2),
(1136, 1112, 4, 2, 0, '2019-07-29 10:10:14', 2),
(1137, 1112, 10, 2, 0, '2019-07-29 10:10:14', 2),
(1138, 1112, 9, 1, 252, '2019-07-29 10:10:14', 2),
(1139, 1112, 12, 2, 252, '2019-07-29 10:10:14', 2),
(1140, 1112, 17, 1, 1, '2019-07-29 10:10:14', 2),
(1141, 1112, 15, 1, 252, '2019-07-29 10:10:14', 2),
(1149, 1113, 2, 2, 0, '2019-07-29 10:11:52', 2),
(1150, 1113, 3, 2, 0, '2019-07-29 10:11:52', 2),
(1151, 1113, 4, 2, 0, '2019-07-29 10:11:52', 2),
(1152, 1113, 10, 2, 0, '2019-07-29 10:11:52', 2),
(1153, 1113, 9, 1, 252, '2019-07-29 10:11:52', 2),
(1154, 1113, 12, 2, 252, '2019-07-29 10:11:52', 2),
(1155, 1113, 17, 1, 1, '2019-07-29 10:11:52', 2),
(1156, 1113, 15, 1, 252, '2019-07-29 10:11:52', 2),
(1164, 1114, 2, 2, 0, '2019-07-29 10:18:05', 2),
(1165, 1114, 3, 2, 0, '2019-07-29 10:18:05', 2),
(1166, 1114, 4, 2, 0, '2019-07-29 10:18:05', 2),
(1167, 1114, 10, 2, 0, '2019-07-29 10:18:05', 2),
(1168, 1114, 9, 1, 252, '2019-07-29 10:18:05', 2),
(1169, 1114, 12, 2, 252, '2019-07-29 10:18:05', 2),
(1170, 1114, 17, 1, 1, '2019-07-29 10:18:05', 2),
(1171, 1114, 15, 1, 252, '2019-07-29 10:18:05', 2),
(1179, 1115, 2, 2, 0, '2019-07-29 10:18:33', 2),
(1180, 1115, 3, 2, 0, '2019-07-29 10:18:33', 2),
(1181, 1115, 4, 2, 0, '2019-07-29 10:18:33', 2),
(1182, 1115, 10, 2, 0, '2019-07-29 10:18:33', 2),
(1183, 1115, 9, 1, 252, '2019-07-29 10:18:33', 2),
(1184, 1115, 12, 2, 252, '2019-07-29 10:18:33', 2),
(1185, 1115, 17, 1, 1, '2019-07-29 10:18:33', 2),
(1186, 1115, 15, 1, 252, '2019-07-29 10:18:33', 2),
(1194, 1116, 2, 2, 0, '2019-07-29 10:19:05', 2),
(1195, 1116, 3, 2, 0, '2019-07-29 10:19:05', 2),
(1196, 1116, 4, 2, 0, '2019-07-29 10:19:05', 2),
(1197, 1116, 10, 2, 0, '2019-07-29 10:19:05', 2),
(1198, 1116, 9, 1, 252, '2019-07-29 10:19:05', 2),
(1199, 1116, 12, 2, 252, '2019-07-29 10:19:05', 2),
(1200, 1116, 17, 1, 1, '2019-07-29 10:19:05', 2),
(1201, 1116, 15, 1, 252, '2019-07-29 10:19:05', 2),
(1209, 1117, 2, 2, 0, '2019-07-29 10:21:45', 2),
(1210, 1117, 3, 2, 0, '2019-07-29 10:21:45', 2),
(1211, 1117, 4, 2, 0, '2019-07-29 10:21:45', 2),
(1212, 1117, 10, 2, 0, '2019-07-29 10:21:45', 2),
(1213, 1117, 9, 1, 252, '2019-07-29 10:21:45', 2),
(1214, 1117, 12, 2, 252, '2019-07-29 10:21:45', 2),
(1215, 1117, 17, 1, 1, '2019-07-29 10:21:45', 2),
(1216, 1117, 15, 1, 252, '2019-07-29 10:21:45', 2),
(1224, 1118, 2, 2, 0, '2019-07-29 10:43:26', 2),
(1225, 1118, 3, 2, 0, '2019-07-29 10:43:26', 2),
(1226, 1118, 4, 2, 0, '2019-07-29 10:43:26', 2),
(1227, 1118, 10, 2, 0, '2019-07-29 10:43:26', 2),
(1228, 1118, 9, 1, 252, '2019-07-29 10:43:26', 2),
(1229, 1118, 12, 2, 252, '2019-07-29 10:43:26', 2),
(1230, 1118, 17, 1, 1, '2019-07-29 10:43:26', 2),
(1231, 1118, 15, 1, 252, '2019-07-29 10:43:26', 2),
(1239, 1119, 2, 2, 0, '2019-07-29 11:34:42', 2),
(1240, 1119, 3, 2, 0, '2019-07-29 11:34:42', 2),
(1241, 1119, 4, 2, 0, '2019-07-29 11:34:42', 2),
(1242, 1119, 10, 2, 0, '2019-07-29 11:34:42', 2),
(1243, 1119, 9, 1, 252, '2019-07-29 11:34:42', 2),
(1244, 1119, 12, 2, 252, '2019-07-29 11:34:42', 2),
(1245, 1119, 17, 1, 1, '2019-07-29 11:34:42', 2),
(1246, 1119, 15, 1, 252, '2019-07-29 11:34:42', 2),
(1254, 1120, 2, 2, 0, '2019-07-29 11:49:23', 2),
(1255, 1120, 3, 2, 0, '2019-07-29 11:49:23', 2),
(1256, 1120, 4, 2, 0, '2019-07-29 11:49:23', 2),
(1257, 1120, 10, 2, 0, '2019-07-29 11:49:23', 2),
(1258, 1120, 9, 1, 252, '2019-07-29 11:49:23', 2),
(1259, 1120, 12, 2, 252, '2019-07-29 11:49:23', 2),
(1260, 1120, 17, 1, 1, '2019-07-29 11:49:23', 2),
(1261, 1120, 15, 1, 252, '2019-07-29 11:49:23', 2),
(1269, 1121, 2, 2, 0, '2019-07-29 11:50:56', 2),
(1270, 1121, 3, 2, 0, '2019-07-29 11:50:56', 2),
(1271, 1121, 4, 2, 0, '2019-07-29 11:50:56', 2),
(1272, 1121, 10, 2, 0, '2019-07-29 11:50:56', 2),
(1273, 1121, 9, 1, 252, '2019-07-29 11:50:56', 2),
(1274, 1121, 12, 2, 252, '2019-07-29 11:50:56', 2),
(1275, 1121, 17, 1, 1, '2019-07-29 11:50:56', 2),
(1276, 1121, 15, 1, 252, '2019-07-29 11:50:56', 2),
(1284, 1122, 2, 2, 0, '2019-07-29 12:13:27', 2),
(1285, 1122, 3, 2, 0, '2019-07-29 12:13:27', 2),
(1286, 1122, 4, 2, 0, '2019-07-29 12:13:27', 2),
(1287, 1122, 10, 2, 0, '2019-07-29 12:13:27', 2),
(1288, 1122, 9, 1, 252, '2019-07-29 12:13:27', 2),
(1289, 1122, 12, 2, 252, '2019-07-29 12:13:27', 2),
(1290, 1122, 17, 1, 1, '2019-07-29 12:13:27', 2),
(1291, 1122, 15, 1, 252, '2019-07-29 12:13:27', 2),
(1299, 1123, 2, 2, 0, '2019-07-29 12:13:48', 2),
(1300, 1123, 3, 2, 0, '2019-07-29 12:13:48', 2),
(1301, 1123, 4, 2, 0, '2019-07-29 12:13:48', 2),
(1302, 1123, 10, 2, 0, '2019-07-29 12:13:48', 2),
(1303, 1123, 9, 1, 252, '2019-07-29 12:13:48', 2),
(1304, 1123, 12, 2, 252, '2019-07-29 12:13:48', 2),
(1305, 1123, 17, 1, 1, '2019-07-29 12:13:48', 2),
(1306, 1123, 15, 1, 252, '2019-07-29 12:13:48', 2),
(1314, 1124, 2, 2, 0, '2019-07-29 12:14:18', 2),
(1315, 1124, 3, 2, 0, '2019-07-29 12:14:18', 2),
(1316, 1124, 4, 2, 0, '2019-07-29 12:14:18', 2),
(1317, 1124, 10, 2, 0, '2019-07-29 12:14:18', 2),
(1318, 1124, 9, 1, 252, '2019-07-29 12:14:18', 2),
(1319, 1124, 12, 2, 252, '2019-07-29 12:14:18', 2),
(1320, 1124, 17, 1, 1, '2019-07-29 12:14:18', 2),
(1321, 1124, 15, 1, 252, '2019-07-29 12:14:18', 2),
(1329, 1125, 2, 2, 0, '2019-07-29 12:14:29', 2),
(1330, 1125, 3, 1, 1, '2019-07-29 12:14:29', 2),
(1331, 1125, 4, 2, 0, '2019-07-29 12:14:29', 2),
(1332, 1125, 10, 1, 252, '2019-07-29 12:14:29', 2),
(1333, 1125, 9, 1, 252, '2019-07-29 12:14:29', 2),
(1334, 1125, 12, 1, 252, '2019-07-29 12:14:29', 2),
(1335, 1125, 17, 1, 1, '2019-07-29 12:14:29', 2),
(1336, 1125, 15, 1, 252, '2019-07-29 12:14:29', 2),
(1344, 1126, 2, 2, 0, '2019-07-29 12:53:50', 2),
(1345, 1126, 3, 1, 0, '2019-07-29 12:53:50', 2),
(1346, 1126, 4, 2, 0, '2019-07-29 12:53:50', 2),
(1347, 1126, 10, 1, 252, '2019-07-29 12:53:50', 2),
(1348, 1126, 9, 1, 252, '2019-07-29 12:53:50', 2),
(1349, 1126, 12, 1, 252, '2019-07-29 12:53:50', 2),
(1350, 1126, 17, 1, 1, '2019-07-29 12:53:50', 2),
(1351, 1126, 15, 1, 252, '2019-07-29 12:53:50', 2),
(1359, 1127, 2, 2, 0, '2019-07-29 13:02:10', 2),
(1360, 1127, 3, 1, 1, '2019-07-29 13:02:10', 2),
(1361, 1127, 4, 2, 0, '2019-07-29 13:02:10', 2),
(1362, 1127, 10, 1, 252, '2019-07-29 13:02:10', 2),
(1363, 1127, 9, 1, 252, '2019-07-29 13:02:10', 2),
(1364, 1127, 12, 1, 252, '2019-07-29 13:02:10', 2),
(1365, 1127, 17, 1, 1, '2019-07-29 13:02:10', 2),
(1366, 1127, 15, 1, 4, '2019-07-29 13:02:10', 2),
(1374, 1128, 2, 2, 0, '2019-07-29 13:05:04', 2),
(1375, 1128, 3, 1, 1, '2019-07-29 13:05:04', 2),
(1376, 1128, 4, 2, 0, '2019-07-29 13:05:04', 2),
(1377, 1128, 10, 1, 252, '2019-07-29 13:05:04', 2),
(1378, 1128, 9, 1, 252, '2019-07-29 13:05:04', 2),
(1379, 1128, 12, 1, 252, '2019-07-29 13:05:04', 2),
(1380, 1128, 17, 1, 1, '2019-07-29 13:05:04', 2),
(1381, 1128, 15, 1, 4, '2019-07-29 13:05:04', 2),
(1389, 1129, 2, 2, 0, '2019-07-29 13:05:27', 2),
(1390, 1129, 3, 1, 1, '2019-07-29 13:05:27', 2),
(1391, 1129, 4, 2, 0, '2019-07-29 13:05:27', 2),
(1392, 1129, 10, 1, 252, '2019-07-29 13:05:27', 2),
(1393, 1129, 9, 1, 252, '2019-07-29 13:05:27', 2),
(1394, 1129, 12, 1, 252, '2019-07-29 13:05:27', 2),
(1395, 1129, 17, 1, 1, '2019-07-29 13:05:27', 2),
(1396, 1129, 15, 1, 4, '2019-07-29 13:05:27', 2),
(1404, 1130, 2, 2, 0, '2019-07-29 13:06:28', 2),
(1405, 1130, 3, 1, 1, '2019-07-29 13:06:28', 2),
(1406, 1130, 4, 2, 0, '2019-07-29 13:06:28', 2),
(1407, 1130, 10, 1, 252, '2019-07-29 13:06:28', 2),
(1408, 1130, 9, 1, 252, '2019-07-29 13:06:28', 2),
(1409, 1130, 12, 1, 252, '2019-07-29 13:06:28', 2),
(1410, 1130, 17, 1, 1, '2019-07-29 13:06:28', 2),
(1411, 1130, 15, 1, 4, '2019-07-29 13:06:28', 2),
(1419, 1131, 2, 2, 0, '2019-07-29 13:06:30', 2),
(1420, 1131, 3, 1, 1, '2019-07-29 13:06:30', 2),
(1421, 1131, 4, 2, 0, '2019-07-29 13:06:30', 2),
(1422, 1131, 10, 1, 252, '2019-07-29 13:06:30', 2),
(1423, 1131, 9, 1, 252, '2019-07-29 13:06:30', 2),
(1424, 1131, 12, 1, 252, '2019-07-29 13:06:30', 2),
(1425, 1131, 17, 1, 1, '2019-07-29 13:06:30', 2),
(1426, 1131, 15, 1, 4, '2019-07-29 13:06:30', 2),
(1434, 1130, 5, 1, 1, '2019-07-29 13:06:30', 2),
(1435, 1131, 5, 1, 1, '2019-07-29 13:06:31', 2),
(1436, 1132, 2, 2, 0, '2019-07-29 13:16:07', 2),
(1437, 1132, 3, 1, 1, '2019-07-29 13:16:07', 2),
(1438, 1132, 4, 2, 0, '2019-07-29 13:16:07', 2),
(1439, 1132, 10, 1, 252, '2019-07-29 13:16:07', 2),
(1440, 1132, 9, 1, 252, '2019-07-29 13:16:07', 2),
(1441, 1132, 12, 1, 252, '2019-07-29 13:16:07', 2),
(1442, 1132, 17, 1, 1, '2019-07-29 13:16:07', 2),
(1443, 1132, 15, 1, 4, '2019-07-29 13:16:07', 2),
(1444, 1132, 5, 1, 1, '2019-07-29 13:16:07', 2),
(1451, 1133, 2, 2, 0, '2019-07-29 13:38:44', 2),
(1452, 1133, 3, 1, 1, '2019-07-29 13:38:44', 2),
(1453, 1133, 4, 2, 0, '2019-07-29 13:38:44', 2),
(1454, 1133, 10, 1, 252, '2019-07-29 13:38:44', 2),
(1455, 1133, 9, 1, 252, '2019-07-29 13:38:44', 2),
(1456, 1133, 12, 1, 252, '2019-07-29 13:38:44', 2),
(1457, 1133, 17, 1, 1, '2019-07-29 13:38:44', 2),
(1458, 1133, 15, 1, 4, '2019-07-29 13:38:44', 2),
(1459, 1133, 5, 1, 1, '2019-07-29 13:38:44', 2),
(1466, 1134, 2, 2, 0, '2019-07-29 13:46:52', 2),
(1467, 1134, 3, 1, 1, '2019-07-29 13:46:52', 2),
(1468, 1134, 4, 2, 0, '2019-07-29 13:46:52', 2),
(1469, 1134, 10, 1, 252, '2019-07-29 13:46:52', 2),
(1470, 1134, 9, 1, 252, '2019-07-29 13:46:52', 2),
(1471, 1134, 12, 1, 252, '2019-07-29 13:46:52', 2),
(1472, 1134, 17, 1, 1, '2019-07-29 13:46:52', 2),
(1473, 1134, 15, 1, 4, '2019-07-29 13:46:52', 2),
(1474, 1134, 5, 1, 1, '2019-07-29 13:46:52', 2),
(1481, 1135, 2, 2, 0, '2019-07-29 13:47:13', 2),
(1482, 1135, 3, 1, 1, '2019-07-29 13:47:13', 2),
(1483, 1135, 4, 2, 0, '2019-07-29 13:47:13', 2),
(1484, 1135, 10, 1, 252, '2019-07-29 13:47:13', 2),
(1485, 1135, 9, 1, 252, '2019-07-29 13:47:13', 2),
(1486, 1135, 12, 1, 252, '2019-07-29 13:47:13', 2),
(1487, 1135, 17, 1, 1, '2019-07-29 13:47:13', 2),
(1488, 1135, 15, 1, 4, '2019-07-29 13:47:13', 2),
(1489, 1135, 5, 1, 1, '2019-07-29 13:47:13', 2),
(1496, 1136, 2, 2, 0, '2019-07-29 13:47:36', 2),
(1497, 1136, 3, 1, 1, '2019-07-29 13:47:36', 2),
(1498, 1136, 4, 2, 0, '2019-07-29 13:47:36', 2),
(1499, 1136, 10, 1, 252, '2019-07-29 13:47:36', 2),
(1500, 1136, 9, 1, 252, '2019-07-29 13:47:36', 2),
(1501, 1136, 12, 1, 252, '2019-07-29 13:47:36', 2),
(1502, 1136, 17, 1, 1, '2019-07-29 13:47:36', 2),
(1503, 1136, 15, 1, 4, '2019-07-29 13:47:36', 2),
(1504, 1136, 5, 1, 1, '2019-07-29 13:47:36', 2),
(1511, 1137, 2, 2, 0, '2019-07-29 13:51:20', 2),
(1512, 1137, 3, 1, 1, '2019-07-29 13:51:20', 2),
(1513, 1137, 4, 2, 0, '2019-07-29 13:51:20', 2),
(1514, 1137, 10, 1, 252, '2019-07-29 13:51:20', 2),
(1515, 1137, 9, 1, 252, '2019-07-29 13:51:20', 2),
(1516, 1137, 12, 1, 252, '2019-07-29 13:51:20', 2),
(1517, 1137, 17, 1, 1, '2019-07-29 13:51:20', 2),
(1518, 1137, 15, 1, 4, '2019-07-29 13:51:20', 2),
(1519, 1137, 5, 1, 1, '2019-07-29 13:51:20', 2),
(1526, 1138, 2, 2, 0, '2019-07-29 13:52:49', 2),
(1527, 1138, 3, 1, 1, '2019-07-29 13:52:49', 2),
(1528, 1138, 4, 2, 0, '2019-07-29 13:52:49', 2),
(1529, 1138, 10, 1, 252, '2019-07-29 13:52:49', 2),
(1530, 1138, 9, 1, 252, '2019-07-29 13:52:49', 2),
(1531, 1138, 12, 1, 252, '2019-07-29 13:52:49', 2),
(1532, 1138, 17, 1, 1, '2019-07-29 13:52:49', 2),
(1533, 1138, 15, 1, 4, '2019-07-29 13:52:49', 2),
(1534, 1138, 5, 1, 1, '2019-07-29 13:52:49', 2),
(1541, 1139, 2, 2, 0, '2019-07-29 13:53:19', 2),
(1542, 1139, 3, 1, 1, '2019-07-29 13:53:19', 2),
(1543, 1139, 4, 2, 0, '2019-07-29 13:53:19', 2),
(1544, 1139, 10, 1, 252, '2019-07-29 13:53:19', 2),
(1545, 1139, 9, 1, 252, '2019-07-29 13:53:19', 2),
(1546, 1139, 12, 1, 252, '2019-07-29 13:53:19', 2),
(1547, 1139, 17, 1, 1, '2019-07-29 13:53:19', 2),
(1548, 1139, 15, 1, 4, '2019-07-29 13:53:19', 2),
(1549, 1139, 5, 1, 1, '2019-07-29 13:53:19', 2),
(1556, 1140, 2, 2, 0, '2019-07-29 13:53:38', 2),
(1557, 1140, 3, 1, 1, '2019-07-29 13:53:38', 2),
(1558, 1140, 4, 2, 0, '2019-07-29 13:53:38', 2),
(1559, 1140, 10, 1, 252, '2019-07-29 13:53:38', 2),
(1560, 1140, 9, 1, 252, '2019-07-29 13:53:38', 2),
(1561, 1140, 12, 1, 252, '2019-07-29 13:53:38', 2),
(1562, 1140, 17, 1, 1, '2019-07-29 13:53:38', 2),
(1563, 1140, 15, 1, 4, '2019-07-29 13:53:38', 2),
(1564, 1140, 5, 1, 1, '2019-07-29 13:53:38', 2),
(1571, 1141, 2, 2, 0, '2019-07-29 13:54:34', 2),
(1572, 1141, 3, 1, 1, '2019-07-29 13:54:34', 2),
(1573, 1141, 4, 2, 0, '2019-07-29 13:54:34', 2),
(1574, 1141, 10, 1, 252, '2019-07-29 13:54:34', 2),
(1575, 1141, 9, 1, 252, '2019-07-29 13:54:34', 2),
(1576, 1141, 12, 1, 252, '2019-07-29 13:54:34', 2),
(1577, 1141, 17, 1, 1, '2019-07-29 13:54:34', 2),
(1578, 1141, 15, 1, 4, '2019-07-29 13:54:34', 2),
(1579, 1141, 5, 1, 1, '2019-07-29 13:54:34', 2),
(1586, 1142, 2, 2, 0, '2019-07-29 13:55:13', 2),
(1587, 1142, 3, 1, 1, '2019-07-29 13:55:13', 2),
(1588, 1142, 4, 2, 0, '2019-07-29 13:55:13', 2),
(1589, 1142, 10, 1, 252, '2019-07-29 13:55:13', 2),
(1590, 1142, 9, 1, 252, '2019-07-29 13:55:13', 2),
(1591, 1142, 12, 1, 252, '2019-07-29 13:55:13', 2),
(1592, 1142, 17, 1, 1, '2019-07-29 13:55:13', 2),
(1593, 1142, 15, 1, 4, '2019-07-29 13:55:13', 2),
(1594, 1142, 5, 1, 1, '2019-07-29 13:55:13', 2),
(1601, 1143, 2, 2, 0, '2019-07-29 13:55:53', 2),
(1602, 1143, 3, 1, 1, '2019-07-29 13:55:53', 2),
(1603, 1143, 4, 2, 0, '2019-07-29 13:55:53', 2),
(1604, 1143, 10, 1, 252, '2019-07-29 13:55:53', 2),
(1605, 1143, 9, 1, 252, '2019-07-29 13:55:53', 2),
(1606, 1143, 12, 1, 252, '2019-07-29 13:55:53', 2),
(1607, 1143, 17, 1, 1, '2019-07-29 13:55:53', 2),
(1608, 1143, 15, 1, 4, '2019-07-29 13:55:53', 2),
(1609, 1143, 5, 1, 1, '2019-07-29 13:55:53', 2),
(1616, 1144, 2, 2, 0, '2019-07-29 13:56:12', 2),
(1617, 1144, 3, 1, 1, '2019-07-29 13:56:12', 2),
(1618, 1144, 4, 2, 0, '2019-07-29 13:56:12', 2),
(1619, 1144, 10, 1, 252, '2019-07-29 13:56:12', 2),
(1620, 1144, 9, 1, 252, '2019-07-29 13:56:12', 2),
(1621, 1144, 12, 1, 252, '2019-07-29 13:56:12', 2),
(1622, 1144, 17, 1, 1, '2019-07-29 13:56:12', 2),
(1623, 1144, 15, 1, 4, '2019-07-29 13:56:12', 2),
(1624, 1144, 5, 1, 1, '2019-07-29 13:56:12', 2),
(1631, 1145, 2, 2, 0, '2019-07-29 14:52:57', 2),
(1632, 1145, 3, 1, 1, '2019-07-29 14:52:57', 2),
(1633, 1145, 4, 2, 0, '2019-07-29 14:52:57', 2),
(1634, 1145, 10, 1, 252, '2019-07-29 14:52:57', 2),
(1635, 1145, 9, 1, 252, '2019-07-29 14:52:57', 2),
(1636, 1145, 12, 1, 252, '2019-07-29 14:52:57', 2),
(1637, 1145, 17, 1, 1, '2019-07-29 14:52:57', 2),
(1638, 1145, 15, 1, 4, '2019-07-29 14:52:57', 2),
(1639, 1145, 5, 1, 1, '2019-07-29 14:52:57', 2),
(1646, 1146, 2, 2, 0, '2019-07-29 14:55:58', 2),
(1647, 1146, 3, 1, 1, '2019-07-29 14:55:58', 2),
(1648, 1146, 4, 2, 0, '2019-07-29 14:55:58', 2),
(1649, 1146, 10, 1, 252, '2019-07-29 14:55:58', 2),
(1650, 1146, 9, 1, 252, '2019-07-29 14:55:58', 2),
(1651, 1146, 12, 1, 252, '2019-07-29 14:55:58', 2),
(1652, 1146, 17, 1, 1, '2019-07-29 14:55:58', 2),
(1653, 1146, 15, 1, 4, '2019-07-29 14:55:58', 2),
(1654, 1146, 5, 1, 1, '2019-07-29 14:55:58', 2),
(1661, 1147, 2, 2, 0, '2019-07-29 18:56:23', 2),
(1662, 1147, 3, 2, 0, '2019-07-29 18:56:23', 2),
(1663, 1147, 4, 2, 0, '2019-07-29 18:56:23', 2),
(1664, 1147, 10, 2, 0, '2019-07-29 18:56:23', 2),
(1665, 1147, 9, 1, 252, '2019-07-29 18:56:23', 2),
(1666, 1147, 12, 2, 252, '2019-07-29 18:56:23', 2),
(1667, 1147, 17, 1, 1, '2019-07-29 18:56:23', 2),
(1668, 1147, 15, 1, 252, '2019-07-29 18:56:23', 2),
(1676, 1148, 2, 2, 0, '2019-07-29 18:56:41', 2),
(1677, 1148, 3, 2, 0, '2019-07-29 18:56:41', 2),
(1678, 1148, 4, 2, 0, '2019-07-29 18:56:41', 2),
(1679, 1148, 10, 2, 0, '2019-07-29 18:56:41', 2),
(1680, 1148, 9, 1, 252, '2019-07-29 18:56:41', 2),
(1681, 1148, 12, 2, 252, '2019-07-29 18:56:41', 2),
(1682, 1148, 17, 1, 1, '2019-07-29 18:56:41', 2),
(1683, 1148, 15, 1, 252, '2019-07-29 18:56:41', 2),
(1691, 1149, 2, 2, 0, '2019-07-29 18:57:56', 2),
(1692, 1149, 3, 2, 0, '2019-07-29 18:57:56', 2),
(1693, 1149, 4, 2, 0, '2019-07-29 18:57:56', 2),
(1694, 1149, 10, 2, 0, '2019-07-29 18:57:56', 2),
(1695, 1149, 9, 1, 252, '2019-07-29 18:57:56', 2),
(1696, 1149, 12, 2, 252, '2019-07-29 18:57:56', 2),
(1697, 1149, 17, 1, 1, '2019-07-29 18:57:56', 2),
(1698, 1149, 15, 1, 252, '2019-07-29 18:57:56', 2),
(1706, 1150, 2, 2, 0, '2019-07-29 18:59:18', 2),
(1707, 1150, 3, 2, 0, '2019-07-29 18:59:18', 2),
(1708, 1150, 4, 2, 0, '2019-07-29 18:59:18', 2),
(1709, 1150, 10, 2, 0, '2019-07-29 18:59:18', 2),
(1710, 1150, 9, 1, 252, '2019-07-29 18:59:18', 2),
(1711, 1150, 12, 2, 252, '2019-07-29 18:59:18', 2),
(1712, 1150, 17, 1, 1, '2019-07-29 18:59:18', 2),
(1713, 1150, 15, 1, 252, '2019-07-29 18:59:18', 2),
(1721, 1151, 2, 2, 0, '2019-07-29 18:59:29', 2),
(1722, 1151, 3, 2, 0, '2019-07-29 18:59:29', 2),
(1723, 1151, 4, 2, 0, '2019-07-29 18:59:29', 2),
(1724, 1151, 10, 2, 0, '2019-07-29 18:59:29', 2),
(1725, 1151, 9, 1, 252, '2019-07-29 18:59:29', 2),
(1726, 1151, 12, 2, 252, '2019-07-29 18:59:29', 2),
(1727, 1151, 17, 1, 1, '2019-07-29 18:59:29', 2),
(1728, 1151, 15, 1, 252, '2019-07-29 18:59:29', 2),
(1736, 1152, 2, 2, 0, '2019-07-29 19:00:01', 2),
(1737, 1152, 3, 2, 0, '2019-07-29 19:00:01', 2),
(1738, 1152, 4, 2, 0, '2019-07-29 19:00:01', 2),
(1739, 1152, 10, 2, 0, '2019-07-29 19:00:01', 2),
(1740, 1152, 9, 1, 252, '2019-07-29 19:00:01', 2),
(1741, 1152, 12, 2, 252, '2019-07-29 19:00:01', 2),
(1742, 1152, 17, 1, 1, '2019-07-29 19:00:01', 2),
(1743, 1152, 15, 1, 252, '2019-07-29 19:00:01', 2),
(1751, 1153, 2, 2, 0, '2019-07-29 19:00:12', 2),
(1752, 1153, 3, 2, 0, '2019-07-29 19:00:12', 2),
(1753, 1153, 4, 2, 0, '2019-07-29 19:00:12', 2),
(1754, 1153, 10, 2, 0, '2019-07-29 19:00:12', 2),
(1755, 1153, 9, 1, 252, '2019-07-29 19:00:12', 2),
(1756, 1153, 12, 2, 252, '2019-07-29 19:00:12', 2),
(1757, 1153, 17, 1, 1, '2019-07-29 19:00:12', 2),
(1758, 1153, 15, 1, 252, '2019-07-29 19:00:12', 2),
(1766, 1154, 2, 2, 0, '2019-07-29 19:00:27', 2),
(1767, 1154, 3, 2, 0, '2019-07-29 19:00:27', 2),
(1768, 1154, 4, 2, 0, '2019-07-29 19:00:27', 2),
(1769, 1154, 10, 2, 0, '2019-07-29 19:00:27', 2),
(1770, 1154, 9, 1, 252, '2019-07-29 19:00:27', 2),
(1771, 1154, 12, 2, 252, '2019-07-29 19:00:27', 2),
(1772, 1154, 17, 1, 1, '2019-07-29 19:00:27', 2),
(1773, 1154, 15, 1, 252, '2019-07-29 19:00:27', 2),
(1781, 1155, 2, 2, 0, '2019-07-29 19:00:48', 2),
(1782, 1155, 3, 2, 0, '2019-07-29 19:00:48', 2),
(1783, 1155, 4, 2, 0, '2019-07-29 19:00:48', 2),
(1784, 1155, 10, 2, 0, '2019-07-29 19:00:48', 2),
(1785, 1155, 9, 1, 252, '2019-07-29 19:00:48', 2),
(1786, 1155, 12, 2, 252, '2019-07-29 19:00:48', 2),
(1787, 1155, 17, 1, 1, '2019-07-29 19:00:48', 2),
(1788, 1155, 15, 1, 252, '2019-07-29 19:00:48', 2),
(1796, 1156, 2, 2, 0, '2019-07-29 19:02:04', 2),
(1797, 1156, 3, 2, 0, '2019-07-29 19:02:04', 2),
(1798, 1156, 4, 2, 0, '2019-07-29 19:02:04', 2),
(1799, 1156, 10, 2, 0, '2019-07-29 19:02:04', 2),
(1800, 1156, 9, 1, 252, '2019-07-29 19:02:04', 2),
(1801, 1156, 12, 2, 0, '2019-07-29 19:02:04', 2),
(1802, 1156, 17, 1, 1, '2019-07-29 19:02:04', 2),
(1803, 1156, 15, 1, 252, '2019-07-29 19:02:04', 2),
(1811, 1157, 2, 2, 0, '2019-07-29 19:03:01', 2),
(1812, 1157, 3, 2, 0, '2019-07-29 19:03:01', 2),
(1813, 1157, 4, 2, 0, '2019-07-29 19:03:01', 2),
(1814, 1157, 10, 2, 0, '2019-07-29 19:03:01', 2),
(1815, 1157, 9, 1, 252, '2019-07-29 19:03:01', 2),
(1816, 1157, 12, 2, 0, '2019-07-29 19:03:01', 2),
(1817, 1157, 17, 1, 1, '2019-07-29 19:03:01', 2),
(1818, 1157, 15, 1, 252, '2019-07-29 19:03:01', 2),
(1826, 1158, 2, 2, 0, '2019-07-29 19:03:18', 2),
(1827, 1158, 3, 2, 0, '2019-07-29 19:03:18', 2),
(1828, 1158, 4, 2, 0, '2019-07-29 19:03:18', 2),
(1829, 1158, 10, 2, 0, '2019-07-29 19:03:18', 2),
(1830, 1158, 9, 1, 252, '2019-07-29 19:03:18', 2),
(1831, 1158, 12, 2, 0, '2019-07-29 19:03:18', 2),
(1832, 1158, 17, 1, 1, '2019-07-29 19:03:18', 2),
(1833, 1158, 15, 1, 252, '2019-07-29 19:03:18', 2),
(1841, 1158, 5, 2, 1, '2019-07-29 19:03:20', 2),
(1842, 1159, 2, 2, 0, '2019-07-29 19:04:14', 2),
(1843, 1159, 3, 2, 0, '2019-07-29 19:04:14', 2),
(1844, 1159, 4, 2, 0, '2019-07-29 19:04:14', 2),
(1845, 1159, 10, 2, 0, '2019-07-29 19:04:14', 2),
(1846, 1159, 9, 1, 252, '2019-07-29 19:04:14', 2),
(1847, 1159, 12, 2, 0, '2019-07-29 19:04:14', 2),
(1848, 1159, 17, 1, 1, '2019-07-29 19:04:14', 2),
(1849, 1159, 15, 1, 252, '2019-07-29 19:04:14', 2),
(1850, 1159, 5, 2, 1, '2019-07-29 19:04:14', 2),
(1857, 1160, 2, 2, 0, '2019-07-29 19:04:29', 2),
(1858, 1160, 3, 2, 0, '2019-07-29 19:04:29', 2),
(1859, 1160, 4, 2, 0, '2019-07-29 19:04:29', 2),
(1860, 1160, 10, 2, 0, '2019-07-29 19:04:29', 2),
(1861, 1160, 9, 1, 252, '2019-07-29 19:04:29', 2),
(1862, 1160, 12, 2, 0, '2019-07-29 19:04:29', 2),
(1863, 1160, 17, 1, 1, '2019-07-29 19:04:29', 2),
(1864, 1160, 15, 1, 252, '2019-07-29 19:04:29', 2),
(1865, 1160, 5, 2, 1, '2019-07-29 19:04:29', 2),
(1872, 1161, 2, 2, 0, '2019-07-29 19:04:43', 2),
(1873, 1161, 3, 2, 0, '2019-07-29 19:04:43', 2),
(1874, 1161, 4, 2, 0, '2019-07-29 19:04:43', 2),
(1875, 1161, 10, 2, 0, '2019-07-29 19:04:43', 2),
(1876, 1161, 9, 1, 252, '2019-07-29 19:04:43', 2),
(1877, 1161, 12, 2, 0, '2019-07-29 19:04:43', 2),
(1878, 1161, 17, 1, 1, '2019-07-29 19:04:43', 2),
(1879, 1161, 15, 1, 252, '2019-07-29 19:04:43', 2),
(1880, 1161, 5, 2, 1, '2019-07-29 19:04:43', 2),
(1887, 1162, 2, 2, 0, '2019-07-29 19:04:54', 2),
(1888, 1162, 3, 2, 0, '2019-07-29 19:04:54', 2),
(1889, 1162, 4, 2, 0, '2019-07-29 19:04:54', 2),
(1890, 1162, 10, 2, 0, '2019-07-29 19:04:54', 2),
(1891, 1162, 9, 1, 252, '2019-07-29 19:04:54', 2),
(1892, 1162, 12, 2, 0, '2019-07-29 19:04:54', 2),
(1893, 1162, 17, 1, 1, '2019-07-29 19:04:54', 2),
(1894, 1162, 15, 1, 252, '2019-07-29 19:04:54', 2),
(1895, 1162, 5, 2, 1, '2019-07-29 19:04:54', 2),
(1902, 1163, 2, 2, 0, '2019-07-29 19:05:28', 2),
(1903, 1163, 3, 2, 0, '2019-07-29 19:05:28', 2),
(1904, 1163, 4, 2, 0, '2019-07-29 19:05:28', 2),
(1905, 1163, 10, 2, 0, '2019-07-29 19:05:28', 2),
(1906, 1163, 9, 1, 252, '2019-07-29 19:05:28', 2),
(1907, 1163, 12, 2, 0, '2019-07-29 19:05:28', 2),
(1908, 1163, 17, 1, 1, '2019-07-29 19:05:28', 2),
(1909, 1163, 15, 1, 252, '2019-07-29 19:05:28', 2),
(1910, 1163, 5, 2, 1, '2019-07-29 19:05:28', 2),
(1917, 1164, 2, 2, 0, '2019-07-29 19:05:45', 2),
(1918, 1164, 3, 2, 0, '2019-07-29 19:05:45', 2),
(1919, 1164, 4, 2, 0, '2019-07-29 19:05:45', 2),
(1920, 1164, 10, 2, 0, '2019-07-29 19:05:45', 2),
(1921, 1164, 9, 1, 252, '2019-07-29 19:05:45', 2),
(1922, 1164, 12, 2, 0, '2019-07-29 19:05:45', 2),
(1923, 1164, 17, 1, 1, '2019-07-29 19:05:45', 2),
(1924, 1164, 15, 1, 252, '2019-07-29 19:05:45', 2),
(1925, 1164, 5, 2, 1, '2019-07-29 19:05:45', 2),
(1932, 1165, 2, 2, 0, '2019-07-29 19:06:28', 2),
(1933, 1165, 3, 2, 0, '2019-07-29 19:06:28', 2),
(1934, 1165, 4, 2, 0, '2019-07-29 19:06:28', 2),
(1935, 1165, 10, 2, 0, '2019-07-29 19:06:28', 2),
(1936, 1165, 9, 1, 252, '2019-07-29 19:06:28', 2),
(1937, 1165, 12, 2, 0, '2019-07-29 19:06:28', 2),
(1938, 1165, 17, 1, 1, '2019-07-29 19:06:28', 2),
(1939, 1165, 15, 1, 252, '2019-07-29 19:06:28', 2),
(1940, 1165, 5, 2, 1, '2019-07-29 19:06:28', 2),
(1947, 1166, 2, 2, 0, '2019-07-29 19:06:54', 2),
(1948, 1166, 3, 2, 0, '2019-07-29 19:06:54', 2),
(1949, 1166, 4, 2, 0, '2019-07-29 19:06:54', 2),
(1950, 1166, 10, 2, 0, '2019-07-29 19:06:54', 2),
(1951, 1166, 9, 1, 252, '2019-07-29 19:06:54', 2),
(1952, 1166, 12, 2, 0, '2019-07-29 19:06:54', 2),
(1953, 1166, 17, 1, 1, '2019-07-29 19:06:54', 2),
(1954, 1166, 15, 1, 252, '2019-07-29 19:06:54', 2),
(1955, 1166, 5, 2, 1, '2019-07-29 19:06:54', 2),
(1962, 1167, 2, 2, 0, '2019-07-29 19:07:09', 2),
(1963, 1167, 3, 2, 0, '2019-07-29 19:07:09', 2),
(1964, 1167, 4, 2, 0, '2019-07-29 19:07:09', 2),
(1965, 1167, 10, 2, 0, '2019-07-29 19:07:09', 2),
(1966, 1167, 9, 1, 252, '2019-07-29 19:07:09', 2),
(1967, 1167, 12, 2, 0, '2019-07-29 19:07:09', 2),
(1968, 1167, 17, 1, 1, '2019-07-29 19:07:09', 2),
(1969, 1167, 15, 1, 252, '2019-07-29 19:07:09', 2),
(1970, 1167, 5, 2, 1, '2019-07-29 19:07:09', 2),
(1977, 1168, 2, 2, 0, '2019-07-29 19:07:53', 2),
(1978, 1168, 3, 2, 0, '2019-07-29 19:07:53', 2),
(1979, 1168, 4, 2, 0, '2019-07-29 19:07:53', 2),
(1980, 1168, 10, 2, 0, '2019-07-29 19:07:53', 2),
(1981, 1168, 9, 1, 252, '2019-07-29 19:07:53', 2),
(1982, 1168, 12, 2, 0, '2019-07-29 19:07:53', 2),
(1983, 1168, 17, 1, 1, '2019-07-29 19:07:53', 2),
(1984, 1168, 15, 1, 252, '2019-07-29 19:07:53', 2),
(1985, 1168, 5, 2, 1, '2019-07-29 19:07:53', 2),
(1992, 1169, 2, 2, 0, '2019-07-29 19:08:40', 2),
(1993, 1169, 3, 2, 0, '2019-07-29 19:08:40', 2),
(1994, 1169, 4, 2, 0, '2019-07-29 19:08:40', 2),
(1995, 1169, 10, 2, 0, '2019-07-29 19:08:40', 2),
(1996, 1169, 9, 1, 252, '2019-07-29 19:08:40', 2),
(1997, 1169, 12, 2, 0, '2019-07-29 19:08:40', 2),
(1998, 1169, 17, 1, 1, '2019-07-29 19:08:40', 2),
(1999, 1169, 15, 1, 252, '2019-07-29 19:08:40', 2),
(2000, 1169, 5, 2, 1, '2019-07-29 19:08:40', 2),
(2007, 1170, 2, 2, 0, '2019-07-29 19:08:52', 2),
(2008, 1170, 3, 2, 0, '2019-07-29 19:08:52', 2),
(2009, 1170, 4, 2, 0, '2019-07-29 19:08:52', 2),
(2010, 1170, 10, 2, 0, '2019-07-29 19:08:52', 2),
(2011, 1170, 9, 1, 252, '2019-07-29 19:08:52', 2),
(2012, 1170, 12, 2, 0, '2019-07-29 19:08:52', 2),
(2013, 1170, 17, 1, 1, '2019-07-29 19:08:52', 2),
(2014, 1170, 15, 1, 252, '2019-07-29 19:08:52', 2),
(2015, 1170, 5, 2, 1, '2019-07-29 19:08:52', 2),
(2022, 1171, 2, 2, 0, '2019-07-29 19:09:10', 2),
(2023, 1171, 3, 2, 0, '2019-07-29 19:09:10', 2),
(2024, 1171, 4, 2, 0, '2019-07-29 19:09:10', 2),
(2025, 1171, 10, 2, 0, '2019-07-29 19:09:10', 2),
(2026, 1171, 9, 1, 252, '2019-07-29 19:09:10', 2),
(2027, 1171, 12, 2, 0, '2019-07-29 19:09:10', 2),
(2028, 1171, 17, 1, 1, '2019-07-29 19:09:10', 2),
(2029, 1171, 15, 1, 252, '2019-07-29 19:09:10', 2),
(2030, 1171, 5, 2, 1, '2019-07-29 19:09:10', 2),
(2037, 1171, 16, 2, 1, '2019-07-29 19:09:17', 2),
(2038, 1172, 2, 2, 0, '2019-07-29 19:09:28', 2),
(2039, 1172, 3, 2, 0, '2019-07-29 19:09:28', 2),
(2040, 1172, 4, 2, 0, '2019-07-29 19:09:28', 2),
(2041, 1172, 10, 2, 0, '2019-07-29 19:09:28', 2),
(2042, 1172, 9, 1, 252, '2019-07-29 19:09:28', 2),
(2043, 1172, 12, 2, 0, '2019-07-29 19:09:28', 2),
(2044, 1172, 17, 1, 1, '2019-07-29 19:09:28', 2),
(2045, 1172, 15, 1, 252, '2019-07-29 19:09:28', 2),
(2046, 1172, 5, 2, 1, '2019-07-29 19:09:28', 2),
(2047, 1172, 16, 2, 1, '2019-07-29 19:09:28', 2),
(2053, 1173, 2, 2, 0, '2019-07-29 20:06:24', 2),
(2054, 1173, 3, 2, 0, '2019-07-29 20:06:24', 2),
(2055, 1173, 4, 2, 0, '2019-07-29 20:06:24', 2),
(2056, 1173, 10, 2, 0, '2019-07-29 20:06:24', 2),
(2057, 1173, 9, 1, 252, '2019-07-29 20:06:24', 2),
(2058, 1173, 12, 2, 0, '2019-07-29 20:06:24', 2),
(2059, 1173, 17, 1, 1, '2019-07-29 20:06:24', 2),
(2060, 1173, 15, 1, 252, '2019-07-29 20:06:24', 2),
(2061, 1173, 5, 2, 1, '2019-07-29 20:06:24', 2),
(2062, 1173, 16, 2, 1, '2019-07-29 20:06:24', 2),
(2068, 1174, 2, 2, 0, '2019-07-29 20:08:47', 2),
(2069, 1174, 3, 1, 1, '2019-07-29 20:08:47', 2),
(2070, 1174, 4, 2, 0, '2019-07-29 20:08:47', 2),
(2071, 1174, 10, 1, 252, '2019-07-29 20:08:47', 2),
(2072, 1174, 9, 1, 252, '2019-07-29 20:08:47', 2),
(2073, 1174, 12, 2, 0, '2019-07-29 20:08:47', 2),
(2074, 1174, 17, 1, 1, '2019-07-29 20:08:47', 2),
(2075, 1174, 15, 1, 252, '2019-07-29 20:08:47', 2),
(2076, 1174, 5, 2, 1, '2019-07-29 20:08:47', 2),
(2077, 1174, 16, 2, 1, '2019-07-29 20:08:47', 2),
(2078, 1175, 2, 2, 0, '2019-07-29 22:09:15', 2),
(2079, 1175, 3, 2, 0, '2019-07-29 22:09:15', 2),
(2080, 1175, 4, 2, 0, '2019-07-29 22:09:15', 2),
(2081, 1175, 10, 2, 0, '2019-07-29 22:09:15', 2),
(2082, 1175, 9, 1, 252, '2019-07-29 22:09:15', 2),
(2083, 1175, 12, 2, 0, '2019-07-29 22:09:15', 2),
(2084, 1175, 17, 1, 1, '2019-07-29 22:09:15', 2),
(2085, 1175, 15, 1, 252, '2019-07-29 22:09:15', 2),
(2086, 1175, 5, 2, 1, '2019-07-29 22:09:15', 2),
(2087, 1175, 16, 2, 1, '2019-07-29 22:09:15', 2),
(2093, 1176, 2, 2, 0, '2019-07-29 22:10:02', 2),
(2094, 1176, 3, 2, 0, '2019-07-29 22:10:02', 2),
(2095, 1176, 4, 2, 0, '2019-07-29 22:10:02', 2),
(2096, 1176, 10, 2, 0, '2019-07-29 22:10:02', 2),
(2097, 1176, 9, 1, 252, '2019-07-29 22:10:02', 2),
(2098, 1176, 12, 2, 0, '2019-07-29 22:10:02', 2),
(2099, 1176, 17, 1, 1, '2019-07-29 22:10:02', 2),
(2100, 1176, 15, 1, 252, '2019-07-29 22:10:02', 2),
(2101, 1176, 5, 2, 1, '2019-07-29 22:10:02', 2),
(2102, 1176, 16, 2, 1, '2019-07-29 22:10:02', 2),
(2108, 1177, 2, 2, 0, '2019-07-29 22:10:25', 2),
(2109, 1177, 3, 2, 0, '2019-07-29 22:10:25', 2);
INSERT INTO `servicios_vuelo_temp` (`id_sv`, `idtemp_sv`, `idservi_sv`, `tipo_sv`, `cantidad_sv`, `register`, `status`) VALUES
(2110, 1177, 4, 2, 0, '2019-07-29 22:10:25', 2),
(2111, 1177, 10, 2, 0, '2019-07-29 22:10:25', 2),
(2112, 1177, 9, 1, 252, '2019-07-29 22:10:25', 2),
(2113, 1177, 12, 2, 0, '2019-07-29 22:10:25', 2),
(2114, 1177, 17, 1, 1, '2019-07-29 22:10:25', 2),
(2115, 1177, 15, 1, 252, '2019-07-29 22:10:25', 2),
(2116, 1177, 5, 2, 1, '2019-07-29 22:10:25', 2),
(2117, 1177, 16, 2, 1, '2019-07-29 22:10:25', 2),
(2123, 1178, 2, 2, 0, '2019-07-29 22:17:01', 2),
(2124, 1178, 3, 2, 0, '2019-07-29 22:17:01', 2),
(2125, 1178, 4, 2, 0, '2019-07-29 22:17:01', 2),
(2126, 1178, 10, 2, 0, '2019-07-29 22:17:01', 2),
(2127, 1178, 9, 1, 252, '2019-07-29 22:17:01', 2),
(2128, 1178, 12, 2, 0, '2019-07-29 22:17:01', 2),
(2129, 1178, 17, 1, 1, '2019-07-29 22:17:01', 2),
(2130, 1178, 15, 1, 252, '2019-07-29 22:17:01', 2),
(2131, 1178, 5, 2, 1, '2019-07-29 22:17:01', 2),
(2132, 1178, 16, 2, 1, '2019-07-29 22:17:01', 2),
(2138, 1179, 2, 2, 0, '2019-07-29 22:22:54', 2),
(2139, 1179, 3, 2, 0, '2019-07-29 22:22:54', 2),
(2140, 1179, 4, 2, 0, '2019-07-29 22:22:54', 2),
(2141, 1179, 10, 2, 0, '2019-07-29 22:22:54', 2),
(2142, 1179, 9, 1, 252, '2019-07-29 22:22:54', 2),
(2143, 1179, 12, 2, 0, '2019-07-29 22:22:54', 2),
(2144, 1179, 17, 1, 1, '2019-07-29 22:22:54', 2),
(2145, 1179, 15, 1, 252, '2019-07-29 22:22:54', 2),
(2146, 1179, 5, 2, 1, '2019-07-29 22:22:54', 2),
(2147, 1179, 16, 2, 1, '2019-07-29 22:22:54', 2),
(2153, 1180, 2, 2, 0, '2019-07-29 22:54:57', 2),
(2154, 1180, 3, 2, 0, '2019-07-29 22:54:57', 2),
(2155, 1180, 4, 2, 0, '2019-07-29 22:54:57', 2),
(2156, 1180, 10, 2, 0, '2019-07-29 22:54:57', 2),
(2157, 1180, 9, 1, 252, '2019-07-29 22:54:57', 2),
(2158, 1180, 12, 2, 0, '2019-07-29 22:54:57', 2),
(2159, 1180, 17, 1, 1, '2019-07-29 22:54:57', 2),
(2160, 1180, 15, 1, 252, '2019-07-29 22:54:57', 2),
(2161, 1180, 5, 2, 1, '2019-07-29 22:54:57', 2),
(2162, 1180, 16, 2, 1, '2019-07-29 22:54:57', 2),
(2168, 1181, 2, 2, 0, '2019-07-29 22:55:11', 2),
(2169, 1181, 3, 2, 0, '2019-07-29 22:55:11', 2),
(2170, 1181, 4, 2, 0, '2019-07-29 22:55:11', 2),
(2171, 1181, 10, 2, 0, '2019-07-29 22:55:11', 2),
(2172, 1181, 9, 1, 252, '2019-07-29 22:55:11', 2),
(2173, 1181, 12, 2, 0, '2019-07-29 22:55:11', 2),
(2174, 1181, 17, 1, 1, '2019-07-29 22:55:11', 2),
(2175, 1181, 15, 1, 252, '2019-07-29 22:55:11', 2),
(2176, 1181, 5, 2, 1, '2019-07-29 22:55:11', 2),
(2177, 1181, 16, 2, 1, '2019-07-29 22:55:11', 2),
(2183, 1182, 2, 2, 0, '2019-07-29 22:55:37', 2),
(2184, 1182, 3, 2, 0, '2019-07-29 22:55:37', 2),
(2185, 1182, 4, 2, 0, '2019-07-29 22:55:37', 2),
(2186, 1182, 10, 2, 0, '2019-07-29 22:55:37', 2),
(2187, 1182, 9, 1, 252, '2019-07-29 22:55:37', 2),
(2188, 1182, 12, 2, 0, '2019-07-29 22:55:37', 2),
(2189, 1182, 17, 1, 1, '2019-07-29 22:55:37', 2),
(2190, 1182, 15, 1, 252, '2019-07-29 22:55:37', 2),
(2191, 1182, 5, 2, 1, '2019-07-29 22:55:37', 2),
(2192, 1182, 16, 2, 1, '2019-07-29 22:55:37', 2),
(2198, 1183, 2, 2, 0, '2019-07-29 22:57:11', 2),
(2199, 1183, 3, 2, 0, '2019-07-29 22:57:11', 2),
(2200, 1183, 4, 2, 0, '2019-07-29 22:57:11', 2),
(2201, 1183, 10, 2, 0, '2019-07-29 22:57:11', 2),
(2202, 1183, 9, 1, 252, '2019-07-29 22:57:11', 2),
(2203, 1183, 12, 2, 0, '2019-07-29 22:57:11', 2),
(2204, 1183, 17, 1, 1, '2019-07-29 22:57:11', 2),
(2205, 1183, 15, 1, 252, '2019-07-29 22:57:11', 2),
(2206, 1183, 5, 2, 1, '2019-07-29 22:57:11', 2),
(2207, 1183, 16, 2, 1, '2019-07-29 22:57:11', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subpermisos_volar`
--

CREATE TABLE `subpermisos_volar` (
  `id_sp` int(11) NOT NULL COMMENT 'Llave Primaria',
  `nombre_sp` varchar(12) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Permiso',
  `permiso_sp` int(11) NOT NULL COMMENT 'Modulo',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `subpermisos_volar`
--

INSERT INTO `subpermisos_volar` (`id_sp`, `nombre_sp`, `permiso_sp`, `register`, `status`) VALUES
(1, 'AGREGAR', 8, '2019-04-10 15:37:07', 1),
(2, 'CONCILIAR', 2, '2019-04-10 15:47:56', 1),
(3, 'PERMISOS', 8, '2019-04-10 16:36:49', 1),
(4, 'VER', 8, '2019-04-10 16:36:49', 1),
(5, 'ELIMINAR', 8, '2019-04-10 16:36:49', 1),
(6, 'EDITAR', 8, '2019-04-10 16:36:49', 1),
(7, 'AGREGAR', 2, '2019-04-10 21:05:45', 1),
(8, 'VER', 2, '2019-04-10 21:26:10', 1),
(9, 'EDITAR', 2, '2019-04-10 21:26:10', 1),
(10, 'ELIMINAR', 2, '2019-04-10 22:11:05', 1),
(11, 'COTIZACION', 2, '2019-04-10 22:11:05', 1),
(12, 'AGREGAR PAGO', 2, '2019-04-10 22:11:05', 1),
(13, 'BITACORA', 2, '2019-04-10 22:11:05', 1),
(14, 'EDITAR', 6, '2019-04-10 22:14:02', 1),
(15, 'ELIMINAR ', 6, '2019-04-10 22:14:02', 1),
(16, 'VER', 6, '2019-04-10 22:14:02', 1),
(17, 'SERVICIOS', 6, '2019-04-10 22:14:02', 1),
(18, 'EDITAR', 7, '2019-04-10 22:18:47', 1),
(19, 'ELIMINAR ', 7, '2019-04-10 22:18:47', 1),
(23, 'EDITAR GRAL', 2, '2019-04-11 14:34:14', 1),
(24, 'VER GRAL', 2, '2019-04-11 14:34:14', 1),
(25, 'BITACORA GRA', 2, '2019-04-11 14:34:14', 1),
(26, 'GENERAL', 2, '2019-04-11 14:35:42', 1),
(27, 'CAMBIOS', 2, '2019-04-11 20:42:25', 1),
(28, 'AGREGAR', 9, '2019-04-14 15:06:33', 1),
(29, 'ELIMINAR GRL', 2, '2019-04-15 09:19:54', 1),
(30, 'AGREGAR', 4, '2019-04-18 12:44:10', 1),
(31, 'AGREGAR', 7, '2019-04-18 12:44:24', 1),
(32, 'AGREGAR', 5, '2019-04-18 12:44:45', 1),
(33, 'AGREGAR', 10, '2019-05-12 14:37:22', 1),
(34, 'EDITAR', 10, '2019-05-12 15:07:22', 1),
(35, 'ELIMINAR', 10, '2019-05-12 15:07:22', 1),
(36, 'REPORTES', 2, '2019-05-12 15:25:57', 1),
(37, 'EDITAR', 9, '2019-05-12 18:13:23', 1),
(38, 'ELIMINAR', 9, '2019-05-12 18:14:18', 1),
(39, 'HABITACIONES', 9, '2019-05-12 18:14:18', 1),
(40, 'AGREGAR', 11, '2019-05-16 20:45:11', 1),
(41, 'EDITAR', 11, '2019-05-16 20:45:11', 1),
(42, 'ELIMINAR', 11, '2019-05-16 20:45:11', 1),
(43, 'GASTOS', 12, '2019-05-18 20:45:26', 1),
(44, 'NOMINA', 8, '2019-05-19 22:03:04', 1),
(45, 'ELIMINAR', 5, '2019-06-02 14:21:41', 1),
(46, 'EDITAR', 5, '2019-06-02 14:21:41', 1),
(47, 'PILOTOS', 2, '2019-06-06 22:10:36', 1),
(48, 'AGREGAR', 13, '2019-07-30 18:21:55', 1),
(49, 'EDITAR', 13, '2019-07-30 18:21:55', 1),
(50, 'PUESTOS', 13, '2019-07-30 18:21:55', 1),
(51, 'ELIMINAR', 13, '2019-07-30 21:47:28', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `temp_volar`
--

CREATE TABLE `temp_volar` (
  `id_temp` int(11) NOT NULL COMMENT 'Llave Primaria',
  `idusu_temp` int(11) NOT NULL COMMENT 'Usuario',
  `clave_temp` varchar(15) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Clave',
  `nombre_temp` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Nombre',
  `apellidos_temp` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Apellidos',
  `mail_temp` varchar(70) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'E-mail',
  `telfijo_temp` varchar(15) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Telefono FIjo',
  `telcelular_temp` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Telefono Celular',
  `procedencia_temp` tinyint(4) DEFAULT NULL COMMENT 'Procedencia',
  `pasajerosa_temp` int(11) DEFAULT NULL COMMENT 'Pasajeros Adultos',
  `pasajerosn_temp` int(11) DEFAULT 0 COMMENT 'Pasajeros Niños',
  `motivo_temp` tinyint(4) DEFAULT NULL COMMENT 'Motivo',
  `tipo_temp` tinyint(4) DEFAULT NULL COMMENT 'Tipo',
  `fechavuelo_temp` date DEFAULT NULL COMMENT 'Fecha de Vuelo',
  `tarifa_temp` tinyint(4) DEFAULT NULL COMMENT 'Tipo de Tarifa',
  `hotel_temp` tinyint(4) DEFAULT NULL COMMENT 'Hotel',
  `habitacion_temp` tinyint(4) DEFAULT NULL COMMENT 'Habitación',
  `checkin_temp` date DEFAULT NULL COMMENT 'Check In',
  `checkout_temp` date DEFAULT NULL COMMENT 'Check Out',
  `comentario_temp` tinytext COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Comentarios',
  `otroscar1_temp` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Otros Cargos',
  `precio1_temp` decimal(11,2) DEFAULT NULL COMMENT 'Precio',
  `otroscar2_temp` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Otros CArgos',
  `precio2_temp` decimal(11,2) DEFAULT NULL COMMENT 'Precio',
  `tdescuento_temp` tinyint(4) DEFAULT NULL COMMENT 'Tipo de Descuento',
  `cantdescuento_temp` decimal(8,2) NOT NULL DEFAULT 0.00 COMMENT 'Cantidad de Desuento',
  `total_temp` double(10,2) DEFAULT 0.00 COMMENT 'Total',
  `piloto_temp` int(11) DEFAULT 0 COMMENT 'Piloto',
  `kg_temp` decimal(10,2) DEFAULT 0.00 COMMENT 'Peso',
  `globo_temp` int(11) DEFAULT 0 COMMENT 'Globo',
  `hora_temp` time DEFAULT NULL COMMENT 'Hora de Vuelo',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 2 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Tabla Temporal';

--
-- Volcado de datos para la tabla `temp_volar`
--

INSERT INTO `temp_volar` (`id_temp`, `idusu_temp`, `clave_temp`, `nombre_temp`, `apellidos_temp`, `mail_temp`, `telfijo_temp`, `telcelular_temp`, `procedencia_temp`, `pasajerosa_temp`, `pasajerosn_temp`, `motivo_temp`, `tipo_temp`, `fechavuelo_temp`, `tarifa_temp`, `hotel_temp`, `habitacion_temp`, `checkin_temp`, `checkout_temp`, `comentario_temp`, `otroscar1_temp`, `precio1_temp`, `otroscar2_temp`, `precio2_temp`, `tdescuento_temp`, `cantdescuento_temp`, `total_temp`, `piloto_temp`, `kg_temp`, `globo_temp`, `hora_temp`, `register`, `status`) VALUES
(1001, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-09 17:06:41', 0),
(1002, 1, NULL, 'SONIA', 'GUAJARDO', 'ANGEL-SONY@HOTMAIL.COM', NULL, '5568577013', 18, NULL, 2, 43, 1, '2019-07-30', 48, 1, 5, '2019-07-29', '2019-07-30', NULL, NULL, '0.00', NULL, NULL, NULL, '0.00', 3400.00, 0, '0.00', 0, NULL, '2019-07-09 17:12:30', 0),
(1003, 1, NULL, 'ENRIQUE', 'DAMASCO', 'enriquedamasco58@gmail.com', '0', '5529227672', NULL, 5, 0, NULL, 5, '2019-07-25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 15000.00, 0, '0.00', 0, NULL, '2019-07-09 17:13:16', 0),
(1004, 1, NULL, 'DIEGO', 'ALDUCIN', 'oficina@volarenglobo.com.mx', NULL, '5529227672', 11, 4, 2, 40, 4, '2019-07-25', 49, NULL, NULL, NULL, NULL, 'PAGARAN EN DOLARES', NULL, NULL, NULL, NULL, NULL, '0.00', 22250.00, 0, '0.00', 0, NULL, '2019-07-09 17:16:47', 4),
(1005, 1, NULL, 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-09 17:19:49', 0),
(1006, 1, NULL, 'VICENTE', 'MENDOZA', 'alducin.asesori@hotmail.com', NULL, '5516567285', 17, 1, 0, 42, 16, '2019-07-15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 3250.00, 0, '0.00', 0, NULL, '2019-07-09 17:28:46', 4),
(1007, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-07-24 21:20:00', 2),
(1008, 1, NULL, 'FRANCISCA', 'GUAJARDO', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-07-28 14:21:21', 2),
(1009, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-09 17:06:41', 4),
(1010, 1, NULL, 'SONIA', 'GUAJARDO', 'ANGEL-SONY@HOTMAIL.COM', NULL, '5568577013', 18, NULL, 2, 43, 1, '2019-07-30', 48, 1, 5, '2019-07-29', '2019-07-30', NULL, NULL, '0.00', NULL, NULL, NULL, '0.00', 3400.00, 0, '0.00', 0, NULL, '2019-07-09 17:12:30', 3),
(1011, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-07-28 14:36:22', 2),
(1012, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-07-28 14:38:02', 2),
(1013, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 14:55:57', 4),
(1014, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-07-28 15:02:45', 2),
(1015, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 15:02:49', 4),
(1016, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 15:54:27', 4),
(1017, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 15:54:37', 4),
(1018, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 15:56:02', 0),
(1019, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 15:57:46', 0),
(1020, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 15:59:28', 0),
(1021, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 16:00:03', 0),
(1022, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 17:40:26', 0),
(1023, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 17:43:00', 0),
(1024, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 17:44:06', 0),
(1025, 1, '1001', 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 17:50:16', 0),
(1026, 1, '1001', 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 17:53:59', 6),
(1027, 1, '1001', 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 17:54:46', 6),
(1028, 1, '1001', 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 18:03:26', 0),
(1029, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-07-28 18:10:02', 6),
(1030, 1, '1029', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-07-28 18:45:12', 6),
(1031, 1, '1030', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-07-28 18:46:27', 2),
(1032, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-07-28 18:46:42', 2),
(1033, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-07-28 18:51:25', 6),
(1034, 1, '1033', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-07-28 18:55:53', 6),
(1035, 1, '1034', 'ENRIQUE', 'DAMASCO', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-07-28 18:57:56', 6),
(1036, 1, '1035', 'ENRIQUE', 'DAMASCO', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-07-28 18:58:51', 6),
(1037, 1, '1036', 'ENRIQUE', 'DAMASCO', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-07-28 19:16:49', 2),
(1038, 1, '1005', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 19:33:08', 6),
(1039, 1, '1038', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 19:34:47', 6),
(1040, 1, '1039', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 19:37:13', 6),
(1041, 1, '1040', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 19:41:10', 6),
(1042, 1, '1041', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 19:43:09', 6),
(1043, 1, '1042', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 19:43:42', 6),
(1044, 1, '1043', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 19:50:18', 6),
(1045, 1, '1044', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 19:50:29', 6),
(1046, 1, '1045', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 19:50:40', 6),
(1047, 1, '1046', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 19:51:38', 6),
(1048, 1, '1047', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 21:50:28', 6),
(1049, 1, '1048', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 21:51:04', 6),
(1050, 1, '1049', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 21:51:24', 6),
(1051, 1, '1050', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 21:51:30', 6),
(1052, 1, '1051', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 21:52:02', 6),
(1053, 1, '1052', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 21:52:37', 6),
(1054, 1, '1053', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 21:57:22', 6),
(1055, 1, '1054', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 21:57:58', 6),
(1056, 1, '1055', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 21:58:11', 6),
(1057, 1, '1056', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 22:00:28', 6),
(1058, 1, '1057', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 22:00:34', 6),
(1059, 1, '1058', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 22:01:50', 6),
(1060, 1, '1059', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 22:01:58', 6),
(1061, 1, '1060', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 22:02:04', 6),
(1062, 1, '1061', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 22:02:10', 6),
(1063, 1, '1062', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 22:09:25', 6),
(1064, 1, '1063', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 22:09:33', 6),
(1065, 1, '1064', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 22:09:40', 6),
(1066, 1, '1065', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 22:10:55', 6),
(1067, 1, '1066', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, '500', '500.00', NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 22:11:05', 6),
(1068, 1, '1067', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, '500', '500.00', NULL, NULL, 1, '500.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 22:11:21', 6),
(1069, 1, '1068', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, '500', '500.00', NULL, NULL, 2, '500.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 22:11:36', 6),
(1070, 1, '1069', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, '500', '500.00', NULL, NULL, 2, '500.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 22:11:45', 6),
(1071, 1, '1070', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, '500', '500.00', NULL, NULL, 2, '500.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 22:11:57', 6),
(1072, 1, '1071', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', NULL, '500', '500.00', NULL, NULL, 2, '500.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 22:12:06', 6),
(1073, 1, '1072', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '500.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 22:22:30', 6),
(1074, 1, '1073', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '500.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 22:32:54', 6),
(1075, 1, '1074', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '500.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 23:28:50', 6),
(1076, 1, '1075', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, '2019-07-30', '2019-07-31', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '500.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 23:29:18', 6),
(1077, 1, '1076', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, 5, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '50.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-28 23:30:31', 6),
(1078, 1, '1077', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, 5, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 00:16:12', 6),
(1079, 1, '1078', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, 5, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 00:20:55', 6),
(1080, 1, '1079', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, 5, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 00:21:45', 6),
(1081, 1, '1080', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, 5, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 00:22:03', 6),
(1082, 1, '1081', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, 5, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 08:26:13', 6),
(1083, 1, '1082', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, 5, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 08:39:00', 6),
(1084, 1, '1083', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, 5, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 08:59:01', 6),
(1085, 1, '1084', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, 5, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 08:59:14', 6),
(1086, 1, '1085', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, 5, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:02:18', 6),
(1087, 1, '1086', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, 5, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:02:47', 6),
(1088, 1, '1087', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, 5, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:02:55', 6),
(1089, 1, '1088', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, 5, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:03:00', 6),
(1090, 1, '1089', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, 5, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:03:06', 6),
(1091, 1, '1090', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, 5, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:36:36', 6),
(1092, 1, '1091', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, 5, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:37:12', 6),
(1093, 1, '1092', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, 5, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:39:33', 6),
(1094, 1, '1093', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 5, NULL, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:39:50', 6),
(1095, 1, '1094', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 5, NULL, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:41:12', 6),
(1096, 1, '1095', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 5, NULL, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:42:04', 6),
(1097, 1, '1096', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 5, NULL, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:42:26', 6),
(1098, 1, '1097', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, NULL, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:44:31', 6),
(1099, 1, '1098', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 5, NULL, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:45:04', 6),
(1100, 1, '1099', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 5, NULL, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:45:30', 6),
(1101, 1, '1100', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, NULL, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:46:20', 6),
(1102, 1, '1101', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, NULL, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:48:01', 6),
(1103, 1, '1102', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 5, 0, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:50:21', 6),
(1104, 1, '1103', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 5, 0, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:51:32', 6),
(1105, 1, '1104', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 6, NULL, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:52:57', 6),
(1106, 1, '1105', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 5, 16, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:56:46', 6),
(1107, 1, '1106', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 6, NULL, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 09:57:23', 6),
(1108, 1, '1107', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, NULL, 10, 250, 2, 40, 1, '2019-07-15', 48, 6, NULL, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 10:06:19', 6),
(1109, 1, '1108', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, NULL, 10, 250, 2, 40, 1, '2019-07-15', 48, 6, NULL, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 10:06:51', 6),
(1110, 1, '1109', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, NULL, 10, 250, 2, 40, 1, '2019-07-15', 48, 6, NULL, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 10:07:45', 6),
(1111, 1, '1110', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, NULL, 10, 250, 2, 40, 1, '2019-07-15', 48, 6, NULL, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 10:09:07', 6),
(1112, 1, '1111', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, NULL, 10, 250, 2, 40, 1, '2019-07-15', 48, 6, NULL, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 10:10:14', 6),
(1113, 1, '1112', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, NULL, 10, 250, 2, 40, 1, '2019-07-15', 48, 6, NULL, NULL, '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 10:11:52', 6),
(1114, 1, '1113', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, NULL, 10, 250, 2, 40, 1, '2019-07-15', 48, 6, NULL, NULL, '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 10:18:05', 6),
(1115, 1, '1114', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, NULL, 10, 250, 2, 40, 1, '2019-07-15', 48, 6, NULL, NULL, '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 10:18:33', 6),
(1116, 1, '1115', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-15', 48, 6, NULL, NULL, '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 10:19:04', 6),
(1117, 1, '1116', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, 9, '2019-07-31', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 10:21:45', 6),
(1118, 1, '1117', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 10:43:26', 6),
(1119, 1, '1118', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 11:34:41', 6),
(1120, 1, '1119', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 11:49:22', 6),
(1121, 1, '1120', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 11:50:56', 6),
(1122, 1, '1121', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 12:13:27', 0),
(1123, 1, '1122', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 12:13:48', 0),
(1124, 1, '1123', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 12:14:18', 0),
(1125, 1, '1124', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 12:14:29', 0),
(1126, 1, '1125', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 12:53:49', 0),
(1127, 1, '1126', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 13:02:10', 0),
(1128, 1, '1127', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 13:05:04', 0),
(1129, 1, '1128', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 13:05:27', 0),
(1130, 1, '1129', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 13:06:25', 0),
(1131, 1, '1129', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 13:06:28', 0),
(1132, 1, '1131', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 13:16:06', 0),
(1133, 1, '1132', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-31', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 25023.00, 0, '0.00', 0, NULL, '2019-07-29 13:38:43', 0),
(1134, 1, '1133', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-31', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 25023.00, 0, '0.00', 0, NULL, '2019-07-29 13:46:51', 0),
(1135, 1, '1134', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-31', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 25023.00, 0, '0.00', 0, NULL, '2019-07-29 13:47:13', 0),
(1136, 1, '1135', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-31', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 25023.00, 0, '0.00', 0, NULL, '2019-07-29 13:47:36', 0),
(1137, 1, '1136', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-31', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 25023.00, 0, '0.00', 0, NULL, '2019-07-29 13:51:20', 0),
(1138, 1, '1137', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-31', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 25023.00, 0, '0.00', 0, NULL, '2019-07-29 13:52:49', 0),
(1139, 1, '1138', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-31', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 25023.00, 0, '0.00', 0, NULL, '2019-07-29 13:53:19', 0),
(1140, 1, '1139', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-02', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 25023.00, 0, '0.00', 0, NULL, '2019-07-29 13:53:38', 0),
(1141, 1, '1140', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-03', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 25023.00, 0, '0.00', 0, NULL, '2019-07-29 13:54:33', 0),
(1142, 1, '1141', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-05', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 25023.00, 0, '0.00', 0, NULL, '2019-07-29 13:55:13', 0),
(1143, 1, '1142', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-07', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 25023.00, 0, '0.00', 0, NULL, '2019-07-29 13:55:53', 0),
(1144, 1, '1143', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-10', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 60173.00, 0, '0.00', 0, NULL, '2019-07-29 13:56:12', 0),
(1145, 1, '1144', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-10', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 60173.00, 0, '0.00', 0, NULL, '2019-07-29 14:52:57', 0),
(1146, 1, '1146', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 2, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-10', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '5.00', 60173.00, 0, '0.00', 0, NULL, '2019-07-29 14:55:58', 0),
(1147, 1, '1147', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 18:56:23', 6),
(1148, 1, '1148', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 18:56:41', 6),
(1149, 1, '1149', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 18:57:55', 6),
(1150, 1, '1150', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 18:59:18', 6),
(1151, 1, '1151', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 18:59:29', 6),
(1152, 1, '1152', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:00:01', 6),
(1153, 1, '1153', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:00:12', 6),
(1154, 1, '1154', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:00:26', 6),
(1155, 1, '1155', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:00:47', 6),
(1156, 1, '1156', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:02:03', 6),
(1157, 1, '1157', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:03:01', 6),
(1158, 1, '1158', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:03:18', 6),
(1159, 1, '1159', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:04:14', 6),
(1160, 1, '1160', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:04:29', 6),
(1161, 1, '1161', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:04:43', 6),
(1162, 1, '1162', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:04:54', 6),
(1163, 1, '1163', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:05:28', 6),
(1164, 1, '1164', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:05:45', 6),
(1165, 1, '1165', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:06:28', 6),
(1166, 1, '1166', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:06:54', 6),
(1167, 1, '1167', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:07:09', 6),
(1168, 1, '1168', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:07:53', 6),
(1169, 1, '1169', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:08:40', 6),
(1170, 1, '1170', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:08:52', 6),
(1171, 1, '1171', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 19:09:10', 6),
(1172, 1, '1172', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 785200.00, 0, '0.00', 0, NULL, '2019-07-29 19:09:28', 6),
(1173, 1, '1173', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 785200.00, 0, '0.00', 0, NULL, '2019-07-29 20:06:24', 6),
(1174, 1, '1174', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 785200.00, 0, '0.00', 0, NULL, '2019-07-29 20:08:47', 0),
(1175, 1, '1175', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 785200.00, 0, '0.00', 0, NULL, '2019-07-29 22:09:15', 6);
INSERT INTO `temp_volar` (`id_temp`, `idusu_temp`, `clave_temp`, `nombre_temp`, `apellidos_temp`, `mail_temp`, `telfijo_temp`, `telcelular_temp`, `procedencia_temp`, `pasajerosa_temp`, `pasajerosn_temp`, `motivo_temp`, `tipo_temp`, `fechavuelo_temp`, `tarifa_temp`, `hotel_temp`, `habitacion_temp`, `checkin_temp`, `checkout_temp`, `comentario_temp`, `otroscar1_temp`, `precio1_temp`, `otroscar2_temp`, `precio2_temp`, `tdescuento_temp`, `cantdescuento_temp`, `total_temp`, `piloto_temp`, `kg_temp`, `globo_temp`, `hora_temp`, `register`, `status`) VALUES
(1176, 1, '1176', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 785200.00, 0, '0.00', 0, NULL, '2019-07-29 22:10:01', 6),
(1177, 1, '1177', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 785200.00, 0, '0.00', 0, NULL, '2019-07-29 22:10:25', 6),
(1178, 1, '1178', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 785200.00, 0, '0.00', 0, NULL, '2019-07-29 22:17:01', 6),
(1179, 1, '1179', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 250, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 785200.00, 0, '0.00', 0, NULL, '2019-07-29 22:22:54', 6),
(1180, 1, '1180', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 10, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 41200.00, 0, '0.00', 0, NULL, '2019-07-29 22:54:57', 6),
(1181, 1, '1181', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 10, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 41200.00, 0, '0.00', 0, NULL, '2019-07-29 22:55:11', 6),
(1182, 1, '1182', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 10, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 41200.00, 0, '0.00', 0, NULL, '2019-07-29 22:55:37', 6),
(1183, 1, '1183', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5529227672', 10, 10, 2, 40, 1, '2019-07-31', 48, 1, 9, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', 'ALGO', '500.00', 'OTRO', '100.00', 1, '0.00', 41200.00, 0, '0.00', 0, NULL, '2019-07-29 22:57:11', 2),
(1184, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-07-30 18:06:26', 2),
(1185, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 5, 17, '2019-08-31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-07-30 23:04:56', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventasserv_volar`
--

CREATE TABLE `ventasserv_volar` (
  `id_vsv` int(11) NOT NULL COMMENT 'Llave Primaria',
  `idserv_vsv` int(11) DEFAULT NULL COMMENT 'Servicio',
  `idventa_vsv` int(11) DEFAULT NULL COMMENT 'Venta',
  `idusu_vsv` int(11) DEFAULT NULL COMMENT 'Usuario que Registra',
  `cantidad_vsv` int(11) DEFAULT NULL COMMENT 'Cantidad',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas_volar`
--

CREATE TABLE `ventas_volar` (
  `id_venta` int(11) NOT NULL COMMENT 'Llave Primaria',
  `comentario_venta` text COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Comentario',
  `otroscar1_venta` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Otros Cargos',
  `precio1_venta` double(10,2) DEFAULT NULL COMMENT 'Precio',
  `otroscar2_venta` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Otros Cargos',
  `precio2_venta` double(10,2) DEFAULT NULL COMMENT 'Precio',
  `tipodesc_venta` tinyint(4) DEFAULT NULL COMMENT 'Tipo de Descuento',
  `cantdesc_venta` double(10,2) DEFAULT NULL COMMENT 'Cantidad de Descuento',
  `pagoefectivo_venta` double(10,2) DEFAULT NULL COMMENT 'Efectivo',
  `pagotarjeta_venta` double(10,2) DEFAULT NULL COMMENT 'Tarjeta',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Ventas de CItio';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `volar_usuarios`
--

CREATE TABLE `volar_usuarios` (
  `id_usu` int(4) NOT NULL COMMENT 'Llave Primaria',
  `nombre_usu` varchar(50) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Nombre',
  `apellidop_usu` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish2_ci NOT NULL COMMENT 'Apellido Paterno',
  `apellidom_usu` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Apellido Materno',
  `depto_usu` tinyint(50) NOT NULL COMMENT 'Departamento',
  `puesto_usu` tinyint(4) NOT NULL COMMENT 'Puesto',
  `correo_usu` varchar(150) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Correo',
  `telefono_usu` varchar(13) COLLATE utf8_spanish_ci NOT NULL DEFAULT '0' COMMENT 'Teléfono',
  `contrasena_usu` varchar(150) COLLATE utf8_spanish_ci NOT NULL DEFAULT '202cb962ac59075b964b07152d234b70' COMMENT 'Contraseña',
  `usuario_usu` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Usuario',
  `nss_usu` bigint(20) DEFAULT NULL COMMENT 'Número de Seguro Social',
  `sd_usu` decimal(10,2) DEFAULT NULL COMMENT 'Sueldo Diario',
  `sdi_usu` decimal(10,2) DEFAULT NULL COMMENT 'Sueldo Diario Integrado',
  `fiscal_usu` decimal(10,2) DEFAULT NULL COMMENT 'Salario Quincenal Fiscal',
  `isr_usu` decimal(10,2) DEFAULT NULL COMMENT 'ISR',
  `imss_usu` decimal(10,2) DEFAULT NULL COMMENT 'IMSS',
  `infonavit_usu` decimal(10,2) DEFAULT NULL COMMENT 'INFONAVIT',
  `subsidio_usu` decimal(10,2) DEFAULT NULL COMMENT 'Subsidio',
  `quincenal_usu` decimal(10,2) DEFAULT NULL COMMENT 'Quincenal',
  `complemento_usu` decimal(10,2) DEFAULT NULL COMMENT 'Complemento',
  `falta_usu` decimal(10,2) DEFAULT NULL COMMENT 'Descuento por Falta',
  `banco_usu` int(11) DEFAULT NULL COMMENT 'Banco',
  `cuenta_usu` bigint(20) DEFAULT NULL COMMENT 'Num. Cuenta',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `volar_usuarios`
--

INSERT INTO `volar_usuarios` (`id_usu`, `nombre_usu`, `apellidop_usu`, `apellidom_usu`, `depto_usu`, `puesto_usu`, `correo_usu`, `telefono_usu`, `contrasena_usu`, `usuario_usu`, `nss_usu`, `sd_usu`, `sdi_usu`, `fiscal_usu`, `isr_usu`, `imss_usu`, `infonavit_usu`, `subsidio_usu`, `quincenal_usu`, `complemento_usu`, `falta_usu`, `banco_usu`, `cuenta_usu`, `register`, `status`) VALUES
(1, 'Enrique', 'Damasco', 'Alducin', 1, 1, 'enriquealducin@siswebs.com.mx', '55-2922-7672', 'c4ca4238a0b923820dcc509a6f75849b', 'Quique', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-29 23:20:06', 1),
(3, 'Sonia', 'Alducin', 'Guajardo', 3, 1, 'oficina@volarenglobo.com.mx', '55-2921-2556', '202cb962ac59075b964b07152d234b70', 'Sonia', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 09:27:49', 1),
(8, 'Ricardo', 'Cruz', 'Rocha', 2, 2, 'ricardo@volarenglobo.com.mx', '55-5106-8115', '202cb962ac59075b964b07152d234b70', 'Ricardo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 16:34:09', 1),
(9, 'Alejandra', 'Ramirez', 'Serrano', 4, 4, 'turismo@volarenglobo.com.mx', '55-3070-4317', '202cb962ac59075b964b07152d234b70', 'Ale', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 16:35:26', 1),
(11, 'Sergio', 'Ramirez', NULL, 5, 5, 'sergio@volarenglobo.com.mx', '55-1234-5678', '202cb962ac59075b964b07152d234b70', 'Sergio', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 07:52:34', 1),
(12, 'Enrique', 'Perez', 'Gomez', 1, 1, 'enriqueperezgomez@gmail.com.mx', '55-2145-6545', 'Enrique', '202cb962ac59075b964b07152d234b70', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 21:15:07', 0),
(13, 'Enrique', 'Damasco', NULL, 3, 1, 'Enrique@algo.com', '55241214', '202cb962ac59075b964b07152d234b70', 'quique', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 21:15:58', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vueloscat_volar`
--

CREATE TABLE `vueloscat_volar` (
  `id_vc` int(11) NOT NULL COMMENT 'Llave Primaria',
  `nombre_vc` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Nombre',
  `tipo_vc` tinyint(4) DEFAULT NULL COMMENT 'TIpo de Vuelo',
  `precioa_vc` decimal(10,2) NOT NULL COMMENT 'Precio de Adultos',
  `precion_vc` decimal(10,2) DEFAULT NULL COMMENT 'Precio de Niños',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `vueloscat_volar`
--

INSERT INTO `vueloscat_volar` (`id_vc`, `nombre_vc`, `tipo_vc`, `precioa_vc`, `precion_vc`, `register`, `status`) VALUES
(1, 'Compartido Normal', 47, '2300.00', '1700.00', '2019-04-05 11:03:46', 1),
(2, 'Compartido Promo 1', 47, '2100.00', '1600.00', '2019-04-05 11:03:46', 1),
(3, 'Compartido Promo 2', 47, '1950.00', '1500.00', '2019-04-05 11:04:31', 1),
(4, 'Privado Normal', 46, '3500.00', '1700.00', '2019-04-05 11:28:14', 1),
(5, 'Privado Promo 1', 46, '3000.00', '1600.00', '2019-04-05 11:28:53', 1),
(14, ' preuba', 47, '43.00', '22.00', '2019-04-09 12:52:38', 0),
(15, ' prueba35', 47, '3.00', '2.00', '2019-04-09 12:56:06', 0),
(16, ' Privado Promo 2', 46, '2750.00', '1500.00', '2019-06-05 23:06:53', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `bitacora_actualizaciones_volar`
--
ALTER TABLE `bitacora_actualizaciones_volar`
  ADD PRIMARY KEY (`id_bit`);

--
-- Indices de la tabla `bitpagos_volar`
--
ALTER TABLE `bitpagos_volar`
  ADD PRIMARY KEY (`id_bp`);

--
-- Indices de la tabla `cat_servicios_volar`
--
ALTER TABLE `cat_servicios_volar`
  ADD PRIMARY KEY (`id_cat`);

--
-- Indices de la tabla `departamentos_volar`
--
ALTER TABLE `departamentos_volar`
  ADD PRIMARY KEY (`id_depto`);

--
-- Indices de la tabla `extras_volar`
--
ALTER TABLE `extras_volar`
  ADD PRIMARY KEY (`id_extra`);

--
-- Indices de la tabla `gastos_volar`
--
ALTER TABLE `gastos_volar`
  ADD PRIMARY KEY (`id_gasto`);

--
-- Indices de la tabla `globos_volar`
--
ALTER TABLE `globos_volar`
  ADD PRIMARY KEY (`id_globo`);

--
-- Indices de la tabla `habitaciones_volar`
--
ALTER TABLE `habitaciones_volar`
  ADD PRIMARY KEY (`id_habitacion`);

--
-- Indices de la tabla `hoteles_volar`
--
ALTER TABLE `hoteles_volar`
  ADD PRIMARY KEY (`id_hotel`);

--
-- Indices de la tabla `imghoteles_volar`
--
ALTER TABLE `imghoteles_volar`
  ADD PRIMARY KEY (`id_img`);

--
-- Indices de la tabla `permisosusuarios_volar`
--
ALTER TABLE `permisosusuarios_volar`
  ADD PRIMARY KEY (`id_puv`),
  ADD KEY `idusu_puv` (`idusu_puv`),
  ADD KEY `idsp_puv` (`idsp_puv`);

--
-- Indices de la tabla `permisos_volar`
--
ALTER TABLE `permisos_volar`
  ADD PRIMARY KEY (`id_per`);

--
-- Indices de la tabla `puestos_volar`
--
ALTER TABLE `puestos_volar`
  ADD PRIMARY KEY (`id_puesto`);

--
-- Indices de la tabla `relacion_permisos`
--
ALTER TABLE `relacion_permisos`
  ADD PRIMARY KEY (`id_rel`),
  ADD KEY `idusu_rel` (`idusu_rel`),
  ADD KEY `idper_rel` (`idper_rel`);

--
-- Indices de la tabla `rel_catvuelos_volar`
--
ALTER TABLE `rel_catvuelos_volar`
  ADD PRIMARY KEY (`id_rel`);

--
-- Indices de la tabla `servicios_volar`
--
ALTER TABLE `servicios_volar`
  ADD PRIMARY KEY (`id_servicio`);

--
-- Indices de la tabla `servicios_vuelo_temp`
--
ALTER TABLE `servicios_vuelo_temp`
  ADD PRIMARY KEY (`id_sv`);

--
-- Indices de la tabla `subpermisos_volar`
--
ALTER TABLE `subpermisos_volar`
  ADD PRIMARY KEY (`id_sp`),
  ADD KEY `permiso_sp` (`permiso_sp`);

--
-- Indices de la tabla `temp_volar`
--
ALTER TABLE `temp_volar`
  ADD PRIMARY KEY (`id_temp`);

--
-- Indices de la tabla `ventasserv_volar`
--
ALTER TABLE `ventasserv_volar`
  ADD PRIMARY KEY (`id_vsv`);

--
-- Indices de la tabla `ventas_volar`
--
ALTER TABLE `ventas_volar`
  ADD PRIMARY KEY (`id_venta`);

--
-- Indices de la tabla `volar_usuarios`
--
ALTER TABLE `volar_usuarios`
  ADD PRIMARY KEY (`id_usu`);

--
-- Indices de la tabla `vueloscat_volar`
--
ALTER TABLE `vueloscat_volar`
  ADD PRIMARY KEY (`id_vc`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `bitacora_actualizaciones_volar`
--
ALTER TABLE `bitacora_actualizaciones_volar`
  MODIFY `id_bit` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `bitpagos_volar`
--
ALTER TABLE `bitpagos_volar`
  MODIFY `id_bp` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `cat_servicios_volar`
--
ALTER TABLE `cat_servicios_volar`
  MODIFY `id_cat` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `departamentos_volar`
--
ALTER TABLE `departamentos_volar`
  MODIFY `id_depto` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `extras_volar`
--
ALTER TABLE `extras_volar`
  MODIFY `id_extra` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=79;

--
-- AUTO_INCREMENT de la tabla `gastos_volar`
--
ALTER TABLE `gastos_volar`
  MODIFY `id_gasto` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria';

--
-- AUTO_INCREMENT de la tabla `globos_volar`
--
ALTER TABLE `globos_volar`
  MODIFY `id_globo` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `habitaciones_volar`
--
ALTER TABLE `habitaciones_volar`
  MODIFY `id_habitacion` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `hoteles_volar`
--
ALTER TABLE `hoteles_volar`
  MODIFY `id_hotel` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `imghoteles_volar`
--
ALTER TABLE `imghoteles_volar`
  MODIFY `id_img` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria';

--
-- AUTO_INCREMENT de la tabla `permisosusuarios_volar`
--
ALTER TABLE `permisosusuarios_volar`
  MODIFY `id_puv` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=182;

--
-- AUTO_INCREMENT de la tabla `permisos_volar`
--
ALTER TABLE `permisos_volar`
  MODIFY `id_per` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `puestos_volar`
--
ALTER TABLE `puestos_volar`
  MODIFY `id_puesto` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `relacion_permisos`
--
ALTER TABLE `relacion_permisos`
  MODIFY `id_rel` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `rel_catvuelos_volar`
--
ALTER TABLE `rel_catvuelos_volar`
  MODIFY `id_rel` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=94;

--
-- AUTO_INCREMENT de la tabla `servicios_volar`
--
ALTER TABLE `servicios_volar`
  MODIFY `id_servicio` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de la tabla `servicios_vuelo_temp`
--
ALTER TABLE `servicios_vuelo_temp`
  MODIFY `id_sv` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=2213;

--
-- AUTO_INCREMENT de la tabla `subpermisos_volar`
--
ALTER TABLE `subpermisos_volar`
  MODIFY `id_sp` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT de la tabla `temp_volar`
--
ALTER TABLE `temp_volar`
  MODIFY `id_temp` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=1186;

--
-- AUTO_INCREMENT de la tabla `ventasserv_volar`
--
ALTER TABLE `ventasserv_volar`
  MODIFY `id_vsv` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria';

--
-- AUTO_INCREMENT de la tabla `ventas_volar`
--
ALTER TABLE `ventas_volar`
  MODIFY `id_venta` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria';

--
-- AUTO_INCREMENT de la tabla `volar_usuarios`
--
ALTER TABLE `volar_usuarios`
  MODIFY `id_usu` int(4) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `vueloscat_volar`
--
ALTER TABLE `vueloscat_volar`
  MODIFY `id_vc` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=17;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `permisosusuarios_volar`
--
ALTER TABLE `permisosusuarios_volar`
  ADD CONSTRAINT `permisosusuarios_volar_ibfk_1` FOREIGN KEY (`idusu_puv`) REFERENCES `volar_usuarios` (`id_usu`),
  ADD CONSTRAINT `permisosusuarios_volar_ibfk_2` FOREIGN KEY (`idsp_puv`) REFERENCES `subpermisos_volar` (`id_sp`);

--
-- Filtros para la tabla `relacion_permisos`
--
ALTER TABLE `relacion_permisos`
  ADD CONSTRAINT `relacion_permisos_ibfk_1` FOREIGN KEY (`idusu_rel`) REFERENCES `volar_usuarios` (`id_usu`),
  ADD CONSTRAINT `relacion_permisos_ibfk_2` FOREIGN KEY (`idper_rel`) REFERENCES `permisos_volar` (`id_per`);

--
-- Filtros para la tabla `subpermisos_volar`
--
ALTER TABLE `subpermisos_volar`
  ADD CONSTRAINT `subpermisos_volar_ibfk_1` FOREIGN KEY (`permiso_sp`) REFERENCES `permisos_volar` (`id_per`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
