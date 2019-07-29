-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 29-07-2019 a las 07:37:17
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
-- Base de datos: `volarenglobo`
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `getReservaData` (IN `_reserva` INT)  BEGIN
	Select id_temp, idusu_temp, IFNULL(clave_temp,"") as clave_temp, IFNULL(nombre_temp,"") as nombre_temp, IFNULL(apellidos_temp,"") as apellidos_temp, IFNULL(mail_temp,"") as mail_temp, IFNULL(telfijo_temp,"") as telfijo_temp, IFNULL(telcelular_temp,"") as telcelular_temp, IFNULL(procedencia_temp,"") as procedencia_temp, IFNULL(pasajerosa_temp,"") as pasajerosa_temp,IFNULL(pasajerosn_temp,"") as pasajerosn_temp, IFNULL(motivo_temp,"") as motivo_temp, IFNULL(tipo_temp,"") as tipo_temp,  IFNULL(fechavuelo_temp,"") as fechavuelo_temp,  IFNULL(tarifa_temp,"") as tarifa_temp, IFNULL(hotel_temp,"") as hotel_temp,  IFNULL(habitacion_temp,"") as habitacion_temp,  IFNULL(checkin_temp,"") as checkin_temp,IFNULL(checkout_temp,"") as checkout_temp,IFNULL(comentario_temp,"") as comentario_temp, IFNULL(otroscar1_temp,"") as otroscar1_temp, IFNULL(otroscar2_temp,"") as otroscar2_temp, IFNULL(precio1_temp,"") as precio1_temp, 
IFNULL(precio2_temp,"") as precio2_temp, IFNULL(tdescuento_temp,"") as tdescuento_temp, IFNULL(cantdescuento_temp,"") as cantdescuento_temp, IFNULL(total_temp,"") as total_temp, IFNULL(piloto_temp,"") as piloto_temp, IFNULL(kg_temp,"") as kg_temp, IFNULL(globo_temp,"") AS globo_temp, IFNULL(hora_temp,"") as hora_temp, register,status
from temp_volar

Where id_temp =_reserva ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getServiciosReservas` (IN `_reserva` BIGINT, IN `_tipo` INT, IN `_servicio` INT)  BEGIN
	Select * from servicios_vuelo_temp where idtemp_sv = _reserva  and tipo_sv = _tipo and idservi_sv = _servicio ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `permisosModulos` (IN `_idusu` INT)  BEGIN
Select DISTINCT(nombre_per) as nombre, img_per, ruta_per,id_per
FROM permisos_volar pv
	INNER JOIN subpermisos_volar spv on pv.id_per=spv.permiso_sp
    INNER JOIN permisosusuarios_volar puv on spv.id_sp=puv.idsp_puv
WHERE pv.status<>0 and spv.status<>0 and puv.status<>0 and  idusu_puv = _idusu;
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
        hora_temp,
        status
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
        hora_temp,
        status
       FROM temp_volar
       where id_temp = _reserva  ;
	SET lid = LAST_INSERT_ID();
    UPDATE temp_volar set clave_temp = _reserva where id_temp=lid;
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
(8, 'Cuádruple', 1, '1650.00', 4, 'Habitación Cuádruple', '2019-06-05 23:12:35', 1),
(9, 'Suite', 1, '1850.00', 5, 'Habitación Suite', '2019-06-05 23:15:16', 1),
(10, 'Doble', 6, '650.00', 2, 'Habitación Doble', '2019-06-05 23:20:14', 1),
(11, 'Sencilla', 6, '250.00', 1, 'Habitación Sencilla', '2019-06-06 22:37:25', 1),
(12, 'hh', 6, '567.00', 567, 'bn', '2019-06-09 16:54:03', 1),
(13, 'jghjgh', 5, '546789.00', 656, 'gvbnnb', '2019-06-09 16:54:49', 0),
(14, 'Sencilla', 5, '1150.00', 2, 'Habitaci', '2019-06-09 16:58:29', 1),
(15, 'Doble', 5, '1350.00', 3, 'Habitaci', '2019-06-09 16:59:04', 1),
(16, 'Suite ', 5, '1800.00', 5, 'Habitaci', '2019-06-09 17:00:31', 1),
(17, 'Cuádruple', 5, '1600.00', 4, 'Habitación Cuádruple', '2019-06-09 17:03:18', 1),
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
(32, 2, 1, '2019-04-10 18:11:22', 1),
(33, 1, 1, '2019-04-10 18:12:12', 1),
(34, 1, 3, '2019-04-10 18:12:46', 1),
(35, 1, 4, '2019-04-10 18:12:47', 1),
(36, 1, 6, '2019-04-10 18:13:31', 1),
(37, 1, 5, '2019-04-10 18:13:45', 1),
(38, 2, 3, '2019-04-10 18:14:05', 1),
(39, 2, 4, '2019-04-10 18:14:06', 1),
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
(53, 2, 2, '2019-04-17 21:09:27', 1),
(54, 2, 23, '2019-04-17 21:09:59', 1),
(55, 2, 9, '2019-04-17 21:10:02', 0),
(56, 2, 26, '2019-04-17 21:10:17', 1),
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
(163, 3, 13, '2019-06-25 07:57:12', 0),
(164, 3, 25, '2019-06-25 07:57:15', 1),
(165, 3, 26, '2019-06-25 07:57:30', 1);

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
(8, 'Usuarios', 'users.png', 'usuarios_volar/', '2019-04-09 12:59:39', 1),
(9, 'Hoteles', 'hotel.png', 'registro_hoteles/', '2019-04-14 14:00:31', 1),
(10, 'Globos', 'globo.png', 'globos/', '2019-05-12 14:37:06', 1),
(11, 'Catalogos', 'catalogo.png', 'catalogos/', '2019-05-16 20:44:27', 1),
(12, 'Sitio', 'sitio.png', 'sitio/', '2019-05-18 19:47:03', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `puestos_volar`
--

CREATE TABLE `puestos_volar` (
  `id_puesto` int(11) NOT NULL COMMENT 'Llave Primaria',
  `nombre_puesto` varchar(50) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Puesto',
  `depto_puesto` int(11) NOT NULL COMMENT 'Departamento',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `puestos_volar`
--

INSERT INTO `puestos_volar` (`id_puesto`, `nombre_puesto`, `depto_puesto`, `register`, `status`) VALUES
(1, 'Desarrollador', 54, '2019-04-09 14:45:21', 1),
(2, 'PILOTO', 62, '2019-04-17 17:59:11', 1),
(3, 'CONTADOR(A)', 63, '2019-04-17 19:51:44', 1),
(4, 'Director General', 74, '2019-06-25 07:17:44', 1),
(5, 'Jefe de Ventas', 52, '2019-06-25 07:18:42', 1),
(6, 'Ejecutivo', 52, '2019-06-25 07:19:03', 1);

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
(9, 2, 6, '2019-04-09 22:32:29', 1),
(10, 2, 1, '2019-04-09 22:34:17', 0),
(11, 2, 1, '2019-04-09 22:35:16', 0),
(12, 2, 5, '2019-04-09 22:35:16', 1),
(13, 2, 2, '2019-04-09 22:35:16', 1),
(14, 2, 7, '2019-04-09 22:35:16', 1),
(15, 2, 8, '2019-04-09 22:35:16', 1),
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
(754, 1081, 17, 1, 1, '2019-07-29 00:22:03', 2);

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
(47, 'PILOTOS', 2, '2019-06-06 22:10:36', 1);

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
(1001, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-09 17:06:41', 6),
(1002, 1, NULL, 'SONIA', 'GUAJARDO', 'ANGEL-SONY@HOTMAIL.COM', NULL, '5568577013', 18, NULL, 2, 43, 1, '2019-07-30', 48, 1, 5, '2019-07-29', '2019-07-30', NULL, NULL, '0.00', NULL, NULL, NULL, '0.00', 3400.00, 0, '0.00', 0, NULL, '2019-07-09 17:12:30', 3),
(1003, 1, NULL, 'ENRIQUE', 'DAMASCO', 'enriquedamasco58@gmail.com', '0', '5529227672', NULL, 5, 0, NULL, 5, '2019-07-25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 15000.00, 0, '0.00', 0, NULL, '2019-07-09 17:13:16', 3),
(1004, 1, NULL, 'DIEGO', 'ALDUCIN', 'oficina@volarenglobo.com.mx', NULL, '5529227672', 11, 4, 2, 40, 4, '2019-07-25', 49, NULL, NULL, NULL, NULL, 'PAGARAN EN DOLARES', NULL, NULL, NULL, NULL, NULL, '0.00', 22250.00, 0, '0.00', 0, NULL, '2019-07-09 17:16:47', 4),
(1005, 1, NULL, 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-09 17:19:49', 6),
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
(1018, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 15:56:02', 4),
(1019, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 15:57:46', 4),
(1020, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 15:59:28', 4),
(1021, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 16:00:03', 4),
(1022, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 17:40:26', 4),
(1023, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 17:43:00', 4),
(1024, 1, NULL, 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 17:44:06', 4),
(1025, 1, '1001', 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 17:50:16', 4),
(1026, 1, '1001', 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 17:53:59', 6),
(1027, 1, '1001', 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 17:54:46', 6),
(1028, 1, '1001', 'FRANCISCA', 'GUAJARDO', 'alducin.asesori@outlook.com', '5529212556', '015529212556', 30, 1, 1, 38, 1, '2019-07-15', NULL, NULL, NULL, NULL, NULL, 'LLEGAN A SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 4140.00, 0, '0.00', 0, NULL, '2019-07-28 18:03:26', 4),
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
(1081, 1, '1080', 'JACIEL ', 'HERNANDEZ', 'enriquealducin@outlook.com', NULL, '5516567885', 10, 250, 2, 40, 1, '2019-07-15', 48, 1, 5, '2019-07-30', '2019-08-01', 'Ningun comentario por el momento', '500', '500.00', NULL, NULL, 2, '550.00', 787750.00, 0, '0.00', 0, NULL, '2019-07-29 00:22:03', 4);

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
(1, 'Enrique', 'Damasco', 'Alducin', 54, 1, 'enriquealducin@siswebs.com.mx', '55-2922-7672', 'c4ca4238a0b923820dcc509a6f75849b', 'Quique', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-29 23:20:06', 1),
(2, 'Verenice', 'Gomez', 'Martinez', 54, 1, 'verenicegm@gmail.com', '55-2463-8183', '11734c05689ef09acd4ff2ccb12853ee', 'vere', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-09 14:55:40', 0),
(3, 'Sonia', 'Alducin', 'Guajardo', 63, 3, 'oficina@volarenglobo.com.mx', '55-2921-2556', 'f1c1592588411002af340cbaedd6fc33', 'Sonia', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 09:27:49', 1),
(5, 'Victor', 'Vazquez', 'Velazquez', 54, 1, 'vvv-nas@outlook.com', '55-2654-5234', '81dc9bdb52d04dc20036dbd8313ed055', 'victor', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-18 11:07:42', 0),
(6, 'Fernanda', 'Ordoñes', NULL, 54, 1, 'alguncorre@hotmail.com', '55-2928-2822', '202cb962ac59075b964b07152d234b70', 'fer', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-17 23:12:27', 0),
(7, 'Martin', 'Garcia', NULL, 54, 1, 'ingmartingc@outlook.com', '55-6369-7567', '202cb962ac59075b964b07152d234b70', 'martin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-17 23:13:56', 0),
(8, 'Ricardo', 'Cruz', 'Rocha', 52, 6, 'ricardo@volarenglobo.com.mx', '55-5106-8115', '202cb962ac59075b964b07152d234b70', 'Ricardo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 16:34:09', 1),
(9, 'Alejandra', 'Ramirez', 'Serrano', 52, 5, 'turismo@volarenglobo.com.mx', '55-3070-4317', '202cb962ac59075b964b07152d234b70', 'Ale', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 16:35:26', 1),
(10, 'Isabel', 'Lopez', NULL, 54, 1, 'fg@hot.com', '55-1234-5678', '202cb962ac59075b964b07152d234b70', 'isabel', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-21 17:04:37', 0),
(11, 'Sergio', 'Ramirez', NULL, 74, 4, 'sergio@volarenglobo.com.mx', '55-1234-5678', '202cb962ac59075b964b07152d234b70', 'Sergio', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 07:52:34', 1);

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
  ADD PRIMARY KEY (`id_puesto`),
  ADD KEY `depto_puesto` (`depto_puesto`);

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
  MODIFY `id_puv` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=166;

--
-- AUTO_INCREMENT de la tabla `permisos_volar`
--
ALTER TABLE `permisos_volar`
  MODIFY `id_per` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `puestos_volar`
--
ALTER TABLE `puestos_volar`
  MODIFY `id_puesto` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=7;

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
  MODIFY `id_sv` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=755;

--
-- AUTO_INCREMENT de la tabla `subpermisos_volar`
--
ALTER TABLE `subpermisos_volar`
  MODIFY `id_sp` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT de la tabla `temp_volar`
--
ALTER TABLE `temp_volar`
  MODIFY `id_temp` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=1082;

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
  MODIFY `id_usu` int(4) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=12;

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
-- Filtros para la tabla `puestos_volar`
--
ALTER TABLE `puestos_volar`
  ADD CONSTRAINT `puestos_volar_ibfk_1` FOREIGN KEY (`depto_puesto`) REFERENCES `extras_volar` (`id_extra`);

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
