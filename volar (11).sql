-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 07-08-2019 a las 07:22:45
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
CREATE  PROCEDURE `agregarServiciosReservas` (IN `_reserva` BIGINT, IN `_servicio` INT, IN `_tipo` INT, IN `_cantidad` BIGINT, OUT `respuesta` VARCHAR(50))  BEGIN
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

CREATE  PROCEDURE `asigarPermisosModulos` (IN `_usuario` INT, IN `_modulo` INT, IN `_status` INT, OUT `_respuesta` VARCHAR(20))  BEGIN
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

CREATE  PROCEDURE `eliminarDepartamento` (IN `_depto` INT, OUT `respuesta` VARCHAR(25))  BEGIN
	UPDATE departamentos_volar set status=0 where id_depto=_depto ;
    UPDATE puestos_volar set status=0 where depto_puesto = _depto ;
    update volar_usuarios set depto_usu = null, puesto_usu=null where depto_usu= _depto;
    SET respuesta = 'Eliminado';
END$$

CREATE  PROCEDURE `eliminarPuesto` (IN `_puesto` INT, OUT `respuesta` VARCHAR(10))  BEGIN 
	UPDATE puestos_volar set status=0 where id_puesto = _puesto;
    UPDATE volar_usuarios set puesto_usu=null where puesto_usu = _puesto;
    SET respuesta='Eliminado';
END$$

CREATE  PROCEDURE `eliminarServicio` (IN `_servicio` INT, OUT `respuesta` VARCHAR(20))  BEGIN
	
	UPDATE servicios_volar SET STATUS= 0 WHERE id_servicio=_servicio;
    SET respuesta = 'Eliminado';
END$$

CREATE  PROCEDURE `getReservaData` (IN `_reserva` INT)  BEGIN
	Select id_temp, idusu_temp, IFNULL(clave_temp,"") as clave_temp, IFNULL(nombre_temp,"") as nombre_temp, IFNULL(apellidos_temp,"") as apellidos_temp, IFNULL(mail_temp,"") as mail_temp, IFNULL(telfijo_temp,"") as telfijo_temp, IFNULL(telcelular_temp,"") as telcelular_temp, IFNULL(procedencia_temp,"") as procedencia_temp, IFNULL(pasajerosa_temp,"") as pasajerosa_temp,IFNULL(pasajerosn_temp,"") as pasajerosn_temp, IFNULL(motivo_temp,"") as motivo_temp, IFNULL(tipo_temp,"") as tipo_temp,  IFNULL(fechavuelo_temp,"") as fechavuelo_temp,  IFNULL(tarifa_temp,"") as tarifa_temp, IFNULL(hotel_temp,"") as hotel_temp,  IFNULL(habitacion_temp,"") as habitacion_temp,  IFNULL(checkin_temp,"") as checkin_temp,IFNULL(checkout_temp,"") as checkout_temp,IFNULL(comentario_temp,"") as comentario_temp, IFNULL(otroscar1_temp,"") as otroscar1_temp, IFNULL(otroscar2_temp,"") as otroscar2_temp, IFNULL(precio1_temp,"") as precio1_temp, 
IFNULL(precio2_temp,"") as precio2_temp, IFNULL(tdescuento_temp,"") as tdescuento_temp, IFNULL(cantdescuento_temp,"") as cantdescuento_temp, IFNULL(total_temp,"") as total_temp, IFNULL(piloto_temp,"") as piloto_temp, IFNULL(kg_temp,"") as kg_temp, IFNULL(globo_temp,"") AS globo_temp, IFNULL(hora_temp,"") as hora_temp, register,status
from temp_volar

Where id_temp =_reserva ;
END$$

CREATE  PROCEDURE `getResumenREserva` (IN `_reserva` BIGINT)  BEGIN
SELECT IFNULL((SELECT nombre_extra from extras_volar where id_extra=tv.motivo_temp),'') as motivo,IFNULL(comentario_temp,'') as comentario,ifnull(pasajerosa_temp,0) as pasajerosA , ifnull(pasajerosn_temp,0) as pasajerosN , IFNULL(habitacion_temp,'') as habitacion, tipo_temp, checkin_temp,checkout_temp, IFNULL(precio1_temp,0) as precio1, IFNULL(precio2_temp,0) as precio2, IFNULL(tdescuento_temp,'') as tdescuento, IFNULL(cantdescuento_temp,0) as cantdescuento, IFNULL(otroscar1_temp,'') as otroscar1,IFNULL(otroscar2_temp,'') as otroscar2, 
IFNULL((SELECT IFNULL( nombre_hotel,'') as hotel FROM hoteles_volar where id_hotel=tv.hotel_temp),'') as hotel,
IFNULL((SELECT CONCAT(IFNULL(nombre_habitacion,''),'|', IFNULL(precio_habitacion,0) ,'|', IFNULL(capacidad_habitacion,0)  ,'|', IFNULL(descripcion_habitacion,'')  ) as Habitaciones FROM habitaciones_volar WHERE id_habitacion=tv.habitacion_temp),'') as habitacion,
IFNULL(fechavuelo_temp,'Fecha No Asignada') as fechavuelo, CONCAT(IFNULL(nombre_temp,''),' ', IFNULL(apellidos_temp,'')) as nombre, IFNULL(mail_temp,'') as correo, CONCAT(IFNULL(telfijo_temp,''),' - ', IFNULL(telcelular_temp,'')) as telefonos, CONCAT(nombre_vc,' Niños:',precion_vc,', Adultos:',precioa_vc ) as tipoVuelo, precion_vc as precioN, precioa_vc as precioA

FROM temp_volar tv  INNER JOIN vueloscat_volar vcv on vcv.id_vc = tv.tipo_temp
Where id_temp=_reserva;
END$$

CREATE  PROCEDURE `getServicioInfo` (IN `_servicio` INT)  BEGIN
	Select id_servicio as id, nombre_servicio as nombre, precio_servicio as precio from servicios_volar where id_servicio=_servicio ;
END$$

CREATE  PROCEDURE `getServiciosReservas` (IN `_reserva` BIGINT, IN `_tipo` INT, IN `_servicio` INT)  BEGIN
	Select * from servicios_vuelo_temp where idtemp_sv = _reserva  and tipo_sv = _tipo and idservi_sv = _servicio and cantidad_sv>0 ;
END$$

CREATE  PROCEDURE `getServiciosXVta` (IN `venta` BIGINT, IN `servicio` INT, OUT `respuesta` INT)  BEGIN 
	IF(Select count(id_vsv) as cantidad from ventasserv_volar where idserv_vsv=servicio and idventa_vsv=venta and status<>0 and cantidad_vsv>0)>0 THEN
    	SET respuesta = (Select cantidad_vsv as cantidad from ventasserv_volar where idserv_vsv=servicio and idventa_vsv=venta and status<>0 and cantidad_vsv>0);
    ELSE
     SET respuesta = 0;
    END IF;
END$$

CREATE  PROCEDURE `getUsuarioInfo` (IN `_usuario` INT)  BEGIN
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

CREATE  PROCEDURE `permisosModulos` (IN `_idusu` INT)  BEGIN
Select DISTINCT(nombre_per) as nombre, img_per, ruta_per,id_per
FROM permisos_volar pv
	INNER JOIN subpermisos_volar spv on pv.id_per=spv.permiso_sp
    INNER JOIN permisosusuarios_volar puv on spv.id_sp=puv.idsp_puv
WHERE pv.status<>0 and spv.status<>0 and puv.status<>0 and  idusu_puv =_idusu  ORDER BY nombre ASC;
END$$

CREATE  PROCEDURE `permisosSubModulos` (IN `_idusu` INT, IN `_idmodulo` INT)  BEGIN
Select nombre_sp, nombre_per
FROM subpermisos_volar sp INNER JOIN permisos_volar pv on pv.id_per=sp.permiso_sp INNER JOIN permisosusuarios_volar pus on pus.idsp_puv= sp.id_sp
WHERE pv.status<>0 and sp.status<>0 and pus.status<>0 AND pus.idusu_puv=_idusu and pv.id_per=_idmodulo;
END$$

CREATE  PROCEDURE `registrarPago` (IN `_pago` BIGINT, IN `_reserva` BIGINT, IN `_usuario` INT, IN `_metodo` INT, IN `_banco` INT, IN `_referencia` VARCHAR(200), IN `_cantidad` DOUBLE(10,2), IN `_fechaPago` VARCHAR(30), IN `_usuarioCOncilia` INT, OUT `respuesta` VARCHAR(25))  BEGIN
IF(SELECT COUNT(id_bp) as pagos from bitpagos_volar  where idres_bp=_reserva )>0 THEN
    IF (SELECT (ifnull(sum(cantidad_bp),0)+ _cantidad ) from bitpagos_volar where idres_bp=_reserva )>(Select total_temp FROM temp_volar where id_temp  = _reserva) THEN
        SET respuesta = 'ERROR EN PAGO';
    ELSEIF (_usuarioConcilia=0) THEN
        INSERT INTO bitpagos_volar (idres_bp,idreg_bp,metodo_bp,banco_bp,referencia_bp,cantidad_bp,fecha_bp) VALUES (_reserva,_usuario,_metodo,_banco,_referencia,_cantidad,_fechaPago);
        SET respuesta = CONCAT('Registrado|',LAST_INSERT_ID());
    ELSE
        UPDATE bitpagos_volar SET idconc_bp=_usuarioCOncilia, fechaconc_bp= CURRENT_TIMESTAMP, status = 3 WHERE id_bp = _pago;
        SET respuesta = 'Conciliado';
          IF (SELECT (sum(cantidad_bp)+ _cantidad ) from bitpagos_volar where idres_bp in (SELECT idres_bp from bitpagos_volar where id_bp = _pago) )=(Select total_temp FROM temp_volar where id_temp  in (SELECT idres_bp from bitpagos_volar where id_bp = _pago)) THEN
              UPDATE temp_volar set status = 7 WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp = _pago);
          ELSE
              UPDATE temp_volar set status = 4 WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp = _pago);
          END IF;
    END IF;
    
  ELSEIF(SELECT total_temp from temp_volar where id_temp=_reserva) < _cantidad THEN
    SET respuesta = 'ERROR EN PAGO';
  
  ELSE
    INSERT INTO bitpagos_volar (idres_bp,idreg_bp,metodo_bp,banco_bp,referencia_bp,cantidad_bp,fecha_bp) VALUES (_reserva,_usuario,_metodo,_banco,_referencia,_cantidad,_fechaPago);
    SET respuesta = CONCAT('Registrado|',LAST_INSERT_ID());
  END IF;
    
END$$

CREATE  PROCEDURE `registrarReserva` (IN `_idusu` INT, OUT `lid` BIGINT)  BEGIN
	Insert INTO temp_volar (idusu_temp) VALUES(_idusu);
   	SET lid =  LAST_INSERT_ID();
END$$

CREATE  PROCEDURE `registrarServicioVta` (IN `servicio` INT, IN `venta` BIGINT, IN `cantidad` INT, OUT `respuesta` VARCHAR(20))  BEGIN 
	INSERT INTO ventasserv_volar (idserv_vsv,idventa_vsv,cantidad_vsv) VALUES (servicio,venta,cantidad);
    SET respuesta = 'Venta Registrada';
END$$

CREATE  PROCEDURE `registrarUsuario` (IN `idusu` INT, IN `nombre` VARCHAR(200), IN `apellidop` VARCHAR(200), IN `apellidom` VARCHAR(200), IN `depto` INT, IN `puesto` INT, IN `correo` VARCHAR(250), IN `telefono` VARCHAR(14), IN `contrasena` VARCHAR(200), IN `usuario` VARCHAR(200), OUT `respuesta` VARCHAR(20))  BEGIN
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

CREATE  PROCEDURE `registroVenta` (IN `usuario` INT, IN `comentario` TEXT, IN `otroscar1` VARCHAR(250), IN `precio1` DOUBLE(10,2), IN `otroscar2` VARCHAR(250), IN `precio2` DOUBLE(10,2), IN `tipodesc` INT, IN `cantdesc` DOUBLE(10,2), IN `pagoefectivo` DOUBLE(10,2), IN `pagotarjeta` DOUBLE(10,2), IN `total` DOUBLE(10,2), OUT `LID` INT)  BEGIN
	INSERT INTO ventas_volar (idusu_venta,comentario_venta,otroscar1_venta,precio1_venta,otroscar2_venta,precio2_venta,tipodesc_venta,cantdesc_venta,pagoefectivo_venta,pagotarjeta_venta,total_venta) VALUES (usuario,comentario,otroscar1,precio1,otroscar2,precio2,tipodesc,cantdesc,pagoefectivo,pagotarjeta,total);
	SET lid = LAST_INSERT_ID();
END$$

CREATE  PROCEDURE `remplazarReserva` (IN `_reserva` INT, IN `_idusu` INT, OUT `lid` INT)  BEGIN 
	INSERT INTO temp_volar(
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
      IF(SELECT COUNT(id_bp) from bitpagos_volar where idres_bp = _reserva and status <>0 )>0 THEN
        UPDATE temp_volar set status=4 where id_temp = lid;
        UPDATE bitpagos_volar set idres_bp = lid where idres_bp=_reserva and status <>0;
    
      ELSEIF(SELECT ifnull(total_temp,0) as total from temp_volar where id_temp = lid)>0 THEN
        UPDATE temp_volar set status=3 where id_temp=lid;

    END IF;
    UPDATE temp_volar set clave_temp =_reserva, idusu_temp=_idusu  where id_temp=lid;
    UPDATE temp_volar set status = 6 where id_temp=_reserva;
END$$

CREATE  PROCEDURE `remplazarServiciosReservas` (IN `_reserva` BIGINT, IN `_oldReserva` BIGINT)  BEGIN 
	INSERT INTO servicios_vuelo_temp
		(idservi_sv,tipo_sv,cantidad_sv,status)
		SELECT idservi_sv,tipo_sv,cantidad_sv,status from servicios_vuelo_temp where idtemp_sv =_oldReserva;
        UPDATE servicios_vuelo_temp set idtemp_sv = _reserva where idtemp_sv is null;
END$$

CREATE  PROCEDURE `usuarioLoggeado` (IN `_usuario` VARCHAR(100), IN `_password` VARCHAR(150))  BEGIN
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
  `status` tinyint(4) NOT NULL DEFAULT 4 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Bitácora de Pagos';

--
-- Volcado de datos para la tabla `bitpagos_volar`
--

INSERT INTO `bitpagos_volar` (`id_bp`, `idres_bp`, `idreg_bp`, `metodo_bp`, `banco_bp`, `referencia_bp`, `cantidad_bp`, `fecha_bp`, `idconc_bp`, `fechaconc_bp`, `register`, `status`) VALUES
(1, 1220, 1, 58, 76, '55030|', '55030.00', '1997-12-16', NULL, NULL, '2019-08-01 15:24:40', 4),
(2, 1217, 1, 57, 75, '55', '55.00', '1997-12-16', NULL, NULL, '2019-08-01 18:01:44', 4),
(3, 1217, 1, 58, 76, '153107', '150.00', '1997-12-16', NULL, NULL, '2019-08-01 18:03:51', 4),
(4, 1217, 1, 57, 75, '153107', '150.00', '1997-12-16', NULL, NULL, '2019-08-01 18:04:30', 4),
(5, 1218, 1, 56, 76, '15', '15500.00', '1997-12-16', NULL, NULL, '2019-08-01 18:05:46', 4),
(6, 1227, 1, 58, 76, '15', '500.00', '1997-12-16', NULL, NULL, '2019-08-01 18:39:13', 4),
(7, 1227, 1, 56, 76, '50', '50.00', '1997-12-16', NULL, NULL, '2019-08-01 18:39:53', 4);

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
  `fecha_gasto` date DEFAULT NULL COMMENT 'Fecha de Gasto',
  `tipo_gasto` mediumint(9) DEFAULT NULL COMMENT 'Tipo de Pago',
  `cantidad_gasto` decimal(10,2) DEFAULT NULL COMMENT 'Cantidad',
  `metodo_gasto` tinyint(4) DEFAULT NULL COMMENT 'Metodo',
  `referencia_gasto` varchar(350) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Referencia',
  `comentario_gasto` varchar(350) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Comentario',
  `register` datetime DEFAULT current_timestamp() COMMENT 'Register',
  `status` int(11) DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Tabla de Gastos';

--
-- Volcado de datos para la tabla `gastos_volar`
--

INSERT INTO `gastos_volar` (`id_gasto`, `fecha_gasto`, `tipo_gasto`, `cantidad_gasto`, `metodo_gasto`, `referencia_gasto`, `comentario_gasto`, `register`, `status`) VALUES
(1, '2019-08-08', 66, '2.00', 2, '0', '0', '2019-08-06 23:48:48', 1),
(2, '2019-08-08', 67, '22.00', 1, 'assa', 'prueba', '2019-08-06 23:48:48', 1),
(3, '2019-08-01', 66, '66.00', 3, '3', 'sasa', '2019-08-06 23:48:48', 1);

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
  `imagen_globo` varchar(150) COLLATE utf8_spanish_ci DEFAULT 'noimage.png' COMMENT 'Imagen',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `globos_volar`
--

INSERT INTO `globos_volar` (`id_globo`, `placa_globo`, `nombre_globo`, `peso_globo`, `maxpersonas_globo`, `imagen_globo`, `register`, `status`) VALUES
(1, '9878-LKJH', 'Globo Amarillo', '840.20', 12, 'noimage.png', '2019-05-12 15:06:29', 1),
(2, 'NAP2345', 'Napolitano', '40.00', 10, '20190805004402_globo.png', '2019-06-06 22:16:13', 1),
(3, 'oru4512', 'Prueba', '150.00', 15, '20190805051735_sitio.png', '2019-08-04 22:17:25', 0),
(4, '150', 'prueba3', '150.00', 15, 'noimage.png', '2019-08-04 22:22:53', 0),
(5, '', 'Enrique', '0.00', NULL, 'noimage.png', '2019-08-04 22:23:06', 0),
(6, '150', 'pruebass', '150.00', 127, '20190805052420_newc.png', '2019-08-04 22:24:12', 0);

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
(186, 1, 3, '2019-08-01 22:36:51', 1),
(187, 1, 1, '2019-08-01 22:36:51', 1),
(188, 1, 4, '2019-08-01 22:36:53', 1),
(189, 1, 6, '2019-08-01 22:36:55', 1),
(190, 1, 5, '2019-08-01 22:36:57', 1),
(191, 1, 48, '2019-08-01 22:44:54', 1),
(192, 1, 49, '2019-08-01 22:44:54', 1),
(193, 1, 50, '2019-08-01 22:44:55', 1),
(194, 1, 51, '2019-08-01 22:44:56', 1),
(195, 1, 53, '2019-08-01 22:45:00', 1),
(196, 1, 54, '2019-08-01 22:45:01', 1),
(197, 1, 55, '2019-08-01 22:45:01', 1),
(198, 1, 2, '2019-08-01 22:45:12', 1),
(199, 1, 7, '2019-08-01 22:45:16', 1),
(200, 1, 8, '2019-08-01 22:45:17', 1),
(201, 1, 9, '2019-08-01 22:45:18', 1),
(202, 1, 13, '2019-08-01 22:45:19', 1),
(203, 1, 12, '2019-08-01 22:45:19', 1),
(204, 1, 11, '2019-08-01 22:45:20', 1),
(205, 1, 10, '2019-08-01 22:45:20', 1),
(206, 1, 23, '2019-08-01 22:45:21', 1),
(207, 1, 24, '2019-08-01 22:45:22', 1),
(208, 1, 25, '2019-08-01 22:45:26', 1),
(209, 1, 26, '2019-08-01 22:45:26', 1),
(210, 1, 47, '2019-08-01 22:45:26', 1),
(211, 1, 36, '2019-08-01 22:45:27', 1),
(212, 1, 29, '2019-08-01 22:45:27', 1),
(213, 1, 27, '2019-08-01 22:45:28', 1),
(214, 1, 52, '2019-08-01 22:45:29', 1),
(215, 3, 2, '2019-08-01 22:55:11', 1),
(216, 3, 7, '2019-08-01 22:55:13', 1),
(217, 3, 26, '2019-08-01 22:55:23', 1),
(218, 3, 11, '2019-08-01 22:56:04', 1),
(219, 3, 36, '2019-08-01 22:56:09', 1),
(220, 3, 1, '2019-08-01 22:56:37', 1),
(221, 3, 4, '2019-08-01 22:56:38', 1),
(222, 3, 6, '2019-08-01 22:56:39', 1),
(223, 3, 5, '2019-08-01 22:56:40', 1),
(224, 1, 56, '2019-08-01 23:00:06', 1),
(225, 1, 57, '2019-08-01 23:00:07', 1),
(226, 1, 58, '2019-08-01 23:00:07', 1),
(227, 1, 60, '2019-08-05 07:22:08', 1),
(228, 1, 59, '2019-08-05 07:22:09', 1),
(229, 1, 61, '2019-08-06 21:14:37', 1),
(230, 1, 63, '2019-08-06 22:29:46', 1),
(231, 1, 62, '2019-08-06 22:29:47', 1),
(232, 1, 67, '2019-08-07 00:18:41', 1),
(233, 1, 66, '2019-08-07 00:18:42', 1),
(234, 1, 65, '2019-08-07 00:18:42', 1),
(235, 1, 64, '2019-08-07 00:18:43', 1),
(236, 1, 68, '2019-08-07 00:18:44', 1),
(237, 1, 69, '2019-08-07 00:18:45', 1),
(238, 1, 70, '2019-08-07 00:18:46', 1);

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
(2, 'Reservas', 'newc.png', 'vistas/reservas/', '2019-03-31 10:29:44', 1),
(8, 'Usuarios', 'users.png', 'vistas/usuarios/', '2019-04-09 12:59:39', 1),
(13, 'Departamentos', 'deptos.png', 'vistas/deptos/', '2019-07-30 18:20:58', 1),
(14, 'Globos', 'globo.png', 'vistas/globos/', '2019-08-01 12:47:12', 1),
(15, 'Servicios', 'servicio.png', 'vistas/servicios/', '2019-08-01 13:34:30', 1),
(16, 'Ventas', 'ventas.png', 'vistas/ventas/', '2019-08-05 07:20:13', 1),
(17, 'Gastos', 'pagos.jpg', 'vistas/pagos/', '2019-08-05 07:25:17', 1),
(18, 'Catalogos', 'catalogo.png', 'vistas/catalogos/', '2019-08-07 00:12:05', 1);

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
(2, 'SOPORTE', 1, '2019-07-30 23:11:47', 1),
(3, 'CONTADOR(A)', 3, '2019-07-31 18:35:16', 1),
(4, 'PILOTO', 4, '2019-08-01 00:33:55', 1),
(5, 'REDES', 1, '2019-08-01 12:17:51', 1),
(6, 'EJECUTIVO', 2, '2019-08-01 17:57:28', 1),
(7, 'GERENTE GENERAL', 5, '2019-08-01 18:01:14', 1),
(8, 'JEFE', 2, '2019-08-01 22:47:29', 1),
(9, 'PUBLICO GENERAL', 2, '2019-08-01 22:48:23', 1),
(10, 'AGENCIAS', 2, '2019-08-01 22:48:58', 1),
(11, 'OPERADORES', 2, '2019-08-01 22:49:02', 1),
(12, 'ENCARGADA', 4, '2019-08-01 22:49:19', 1);

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
(5, 'Desayuno', '140.00', 'desayuno.png', 1, 0, '2019-03-31 20:31:16', 1),
(6, 'Cena', '350.00', 'cena.png', 1, 0, '2019-03-31 20:32:08', 1),
(7, 'Fotos', '500.00', 'foto.jpg', 1, 1, '2019-03-31 21:33:58', 1),
(8, 'Video', '500.00', 'video.png', 1, 1, '2019-03-31 21:35:45', 1),
(9, 'Teotihuacan en Bici', '500.00', 'bici.png', 1, 0, '2019-03-31 21:36:20', 1),
(10, 'Spa', '1500.00', 'spa.png', 1, 0, '2019-03-31 21:37:07', 1),
(11, 'Temazcal', '600.00', 'temazcal.jpg', 1, 0, '2019-03-31 21:37:26', 1),
(12, 'Cuatrimotos', '800.00', 'cuatrimotos.png', 1, 0, '2019-03-31 21:37:42', 1),
(13, 'Entremes', '400.00', 'entremes.jpeg', 1, 1, '2019-03-31 21:38:01', 1),
(14, 'Transporte Redondo', '500.00', 'vredondo.jpg', 1, 0, '2019-03-31 21:38:32', 1),
(15, 'Transporte Sencillo', '300.00', 'vsencillo.png', 1, 0, '2019-03-31 21:39:28', 1),
(16, 'Foto Impresa', '200.00', 'fimpresa.png', 1, 1, '2019-03-31 21:39:50', 1),
(17, 'Guia de 1 a 4', '900.00', '3pers.png', 1, 1, '2019-03-31 21:40:15', 1),
(18, 'Guia de 5 a 10', '1500.00', '5pers.jpg', 1, 1, '2019-03-31 21:40:35', 1),
(25, 'nuevo', '50.00', '20190802004605_fondo.png', 1, 0, '2019-08-02 00:42:08', 0);

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
(430, 1004, 2, 1, 1, '2019-07-09 17:18:44', 2),
(431, 1004, 3, 2, 1, '2019-07-09 17:18:48', 2),
(432, 1004, 9, 1, 6, '2019-07-09 17:18:58', 2),
(433, 1004, 7, 1, 1, '2019-07-09 17:19:06', 2),
(441, 1006, 9, 1, 1, '2019-07-09 17:30:26', 2),
(2213, 1213, 13, 1, 5, '2019-07-31 22:49:44', 2),
(2214, 1213, 14, 1, 5, '2019-07-31 22:49:45', 2),
(2215, 1213, 15, 2, 7, '2019-07-31 22:49:46', 2),
(2216, 1213, 1, 2, 1, '2019-07-31 22:51:48', 2),
(2217, 1213, 17, 2, 1, '2019-07-31 22:52:11', 2),
(2218, 1213, 5, 1, 1, '2019-07-31 22:54:16', 2),
(2219, 1213, 6, 1, 1, '2019-07-31 23:01:01', 2),
(2220, 1213, 2, 2, 1, '2019-07-31 23:06:17', 2),
(2221, 1213, 3, 1, 1, '2019-07-31 23:07:16', 2),
(2222, 1213, 4, 1, 1, '2019-07-31 23:09:30', 2),
(2223, 1213, 9, 1, 7, '2019-07-31 23:09:52', 2),
(2224, 1213, 7, 1, 1, '2019-07-31 23:10:20', 2),
(2225, 1213, 8, 1, 1, '2019-07-31 23:10:53', 2),
(2226, 1213, 10, 1, 7, '2019-07-31 23:11:26', 2),
(2227, 1213, 11, 1, 7, '2019-07-31 23:11:29', 2),
(2228, 1213, 12, 1, 7, '2019-07-31 23:12:06', 2),
(2229, 1213, 16, 2, 1, '2019-07-31 23:12:19', 2),
(2230, 1213, 18, 1, 1, '2019-07-31 23:12:47', 2),
(2231, 1216, 13, 1, 5, '2019-07-31 23:24:23', 2),
(2232, 1216, 14, 1, 5, '2019-07-31 23:24:23', 2),
(2233, 1216, 15, 2, 7, '2019-07-31 23:24:23', 2),
(2234, 1216, 1, 2, 1, '2019-07-31 23:24:23', 2),
(2235, 1216, 17, 2, 1, '2019-07-31 23:24:23', 2),
(2236, 1216, 5, 1, 1, '2019-07-31 23:24:23', 2),
(2237, 1216, 6, 1, 1, '2019-07-31 23:24:23', 2),
(2238, 1216, 2, 2, 1, '2019-07-31 23:24:23', 2),
(2239, 1216, 3, 1, 1, '2019-07-31 23:24:23', 2),
(2240, 1216, 4, 1, 1, '2019-07-31 23:24:23', 2),
(2241, 1216, 9, 1, 7, '2019-07-31 23:24:23', 2),
(2242, 1216, 7, 1, 1, '2019-07-31 23:24:23', 2),
(2243, 1216, 8, 1, 1, '2019-07-31 23:24:23', 2),
(2244, 1216, 10, 1, 7, '2019-07-31 23:24:23', 2),
(2245, 1216, 11, 1, 7, '2019-07-31 23:24:23', 2),
(2246, 1216, 12, 1, 7, '2019-07-31 23:24:23', 2),
(2247, 1216, 16, 2, 1, '2019-07-31 23:24:23', 2),
(2248, 1216, 18, 1, 1, '2019-07-31 23:24:23', 2),
(2262, 1217, 13, 1, 5, '2019-07-31 23:28:33', 2),
(2263, 1217, 14, 1, 5, '2019-07-31 23:28:33', 2),
(2264, 1217, 15, 2, 7, '2019-07-31 23:28:33', 2),
(2265, 1217, 1, 2, 1, '2019-07-31 23:28:33', 2),
(2266, 1217, 17, 2, 1, '2019-07-31 23:28:33', 2),
(2267, 1217, 5, 1, 1, '2019-07-31 23:28:33', 2),
(2268, 1217, 6, 1, 1, '2019-07-31 23:28:33', 2),
(2269, 1217, 2, 2, 1, '2019-07-31 23:28:33', 2),
(2270, 1217, 3, 1, 1, '2019-07-31 23:28:33', 2),
(2271, 1217, 4, 1, 1, '2019-07-31 23:28:33', 2),
(2272, 1217, 9, 1, 7, '2019-07-31 23:28:33', 2),
(2273, 1217, 7, 1, 1, '2019-07-31 23:28:33', 2),
(2274, 1217, 8, 1, 1, '2019-07-31 23:28:33', 2),
(2275, 1217, 10, 1, 7, '2019-07-31 23:28:33', 2),
(2276, 1217, 11, 1, 7, '2019-07-31 23:28:33', 2),
(2277, 1217, 12, 1, 7, '2019-07-31 23:28:33', 2),
(2278, 1217, 16, 2, 1, '2019-07-31 23:28:33', 2),
(2279, 1217, 18, 1, 1, '2019-07-31 23:28:33', 2),
(2293, 1218, 13, 1, 5, '2019-07-31 23:30:42', 2),
(2294, 1218, 14, 1, 5, '2019-07-31 23:30:42', 2),
(2295, 1218, 15, 2, 7, '2019-07-31 23:30:42', 2),
(2296, 1218, 1, 2, 1, '2019-07-31 23:30:42', 2),
(2297, 1218, 17, 2, 1, '2019-07-31 23:30:42', 2),
(2298, 1218, 5, 1, 1, '2019-07-31 23:30:42', 2),
(2299, 1218, 6, 1, 1, '2019-07-31 23:30:42', 2),
(2300, 1218, 2, 2, 1, '2019-07-31 23:30:42', 2),
(2301, 1218, 3, 1, 1, '2019-07-31 23:30:42', 2),
(2302, 1218, 4, 1, 1, '2019-07-31 23:30:42', 2),
(2303, 1218, 9, 1, 7, '2019-07-31 23:30:42', 2),
(2304, 1218, 7, 1, 1, '2019-07-31 23:30:42', 2),
(2305, 1218, 8, 1, 1, '2019-07-31 23:30:42', 2),
(2306, 1218, 10, 1, 7, '2019-07-31 23:30:42', 2),
(2307, 1218, 11, 1, 7, '2019-07-31 23:30:42', 2),
(2308, 1218, 12, 1, 7, '2019-07-31 23:30:42', 2),
(2309, 1218, 16, 2, 1, '2019-07-31 23:30:42', 2),
(2310, 1218, 18, 1, 1, '2019-07-31 23:30:42', 2),
(2324, 1219, 13, 1, 5, '2019-08-01 00:30:44', 0),
(2325, 1219, 14, 1, 5, '2019-08-01 00:30:44', 0),
(2326, 1219, 15, 2, 7, '2019-08-01 00:30:44', 0),
(2327, 1219, 1, 2, 1, '2019-08-01 00:30:44', 0),
(2328, 1219, 17, 2, 1, '2019-08-01 00:30:44', 0),
(2329, 1219, 5, 1, 1, '2019-08-01 00:30:44', 0),
(2330, 1219, 6, 1, 1, '2019-08-01 00:30:44', 0),
(2331, 1219, 2, 2, 1, '2019-08-01 00:30:44', 0),
(2332, 1219, 3, 1, 1, '2019-08-01 00:30:44', 0),
(2333, 1219, 4, 1, 1, '2019-08-01 00:30:44', 0),
(2334, 1219, 9, 1, 7, '2019-08-01 00:30:44', 0),
(2335, 1219, 7, 1, 1, '2019-08-01 00:30:44', 0),
(2336, 1219, 8, 1, 1, '2019-08-01 00:30:44', 0),
(2337, 1219, 10, 1, 7, '2019-08-01 00:30:44', 0),
(2338, 1219, 11, 1, 7, '2019-08-01 00:30:44', 0),
(2339, 1219, 12, 1, 7, '2019-08-01 00:30:44', 0),
(2340, 1219, 16, 2, 1, '2019-08-01 00:30:44', 0),
(2341, 1219, 18, 1, 1, '2019-08-01 00:30:44', 0),
(2355, 1220, 13, 1, 5, '2019-08-01 00:31:06', 0),
(2356, 1220, 14, 1, 5, '2019-08-01 00:31:06', 0),
(2357, 1220, 15, 2, 7, '2019-08-01 00:31:06', 0),
(2358, 1220, 1, 2, 1, '2019-08-01 00:31:06', 0),
(2359, 1220, 17, 2, 1, '2019-08-01 00:31:06', 0),
(2360, 1220, 5, 1, 1, '2019-08-01 00:31:06', 0),
(2361, 1220, 6, 1, 1, '2019-08-01 00:31:06', 0),
(2362, 1220, 2, 2, 1, '2019-08-01 00:31:06', 0),
(2363, 1220, 3, 1, 1, '2019-08-01 00:31:06', 0),
(2364, 1220, 4, 1, 1, '2019-08-01 00:31:06', 0),
(2365, 1220, 9, 1, 7, '2019-08-01 00:31:06', 0),
(2366, 1220, 7, 1, 1, '2019-08-01 00:31:06', 0),
(2367, 1220, 8, 1, 1, '2019-08-01 00:31:06', 0),
(2368, 1220, 10, 1, 7, '2019-08-01 00:31:06', 0),
(2369, 1220, 11, 1, 7, '2019-08-01 00:31:06', 0),
(2370, 1220, 12, 1, 7, '2019-08-01 00:31:06', 0),
(2371, 1220, 16, 2, 1, '2019-08-01 00:31:06', 0),
(2372, 1220, 18, 1, 1, '2019-08-01 00:31:06', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subpermisos_volar`
--

CREATE TABLE `subpermisos_volar` (
  `id_sp` int(11) NOT NULL COMMENT 'Llave Primaria',
  `nombre_sp` varchar(50) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Permiso',
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
(23, 'EDITAR GRAL', 2, '2019-04-11 14:34:14', 1),
(24, 'VER GRAL', 2, '2019-04-11 14:34:14', 1),
(25, 'BITACORA GRA', 2, '2019-04-11 14:34:14', 1),
(26, 'GENERAL', 2, '2019-04-11 14:35:42', 1),
(27, 'CAMBIOS', 2, '2019-04-11 20:42:25', 1),
(29, 'ELIMINAR GRL', 2, '2019-04-15 09:19:54', 1),
(36, 'REPORTES', 2, '2019-05-12 15:25:57', 1),
(44, 'NOMINA', 8, '2019-05-19 22:03:04', 1),
(47, 'PILOTOS', 2, '2019-06-06 22:10:36', 1),
(48, 'AGREGAR', 13, '2019-07-30 18:21:55', 1),
(49, 'EDITAR', 13, '2019-07-30 18:21:55', 1),
(50, 'PUESTOS', 13, '2019-07-30 18:21:55', 1),
(51, 'ELIMINAR', 13, '2019-07-30 21:47:28', 1),
(52, 'ASISTENCIA', 2, '2019-07-31 16:21:16', 1),
(53, 'AGREGAR', 15, '2019-08-01 13:36:31', 1),
(54, 'EDITAR', 15, '2019-08-01 13:36:31', 1),
(55, 'ELIMINAR', 15, '2019-08-01 13:36:31', 1),
(56, 'AGREGAR', 14, '2019-08-01 22:59:17', 1),
(57, 'EDITAR', 14, '2019-08-01 22:59:17', 1),
(58, 'ELIMINAR', 14, '2019-08-01 22:59:17', 1),
(59, 'AGREGAR', 16, '2019-08-05 07:21:26', 1),
(60, 'REPORTES', 16, '2019-08-05 07:21:26', 1),
(61, 'VER', 16, '2019-08-06 21:14:33', 1),
(62, 'AGREGAR', 17, '2019-08-06 22:29:40', 1),
(63, 'VER', 17, '2019-08-06 22:29:40', 1),
(64, 'ESTADOS', 18, '2019-08-07 00:18:30', 1),
(65, 'MOTIVOS', 18, '2019-08-07 00:18:30', 1),
(66, 'TIPOS VUELO', 18, '2019-08-07 00:18:30', 1),
(67, 'TARIFAS', 18, '2019-08-07 00:18:30', 1),
(68, 'METODOS PAGO', 18, '2019-08-07 00:18:30', 1),
(69, 'CUENTAS VOLAR', 18, '2019-08-07 00:18:30', 1),
(70, 'TIPOS GASTOS', 18, '2019-08-07 00:18:30', 1);

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
(1221, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-08-01 18:15:59', 0),
(1222, 1, NULL, 'ENRIQUE', 'DAMASCO', 'enriquealducin@outlook.com', NULL, '5529227672', 17, 5, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-08-01 18:18:35', 0),
(1223, 1, NULL, 'ENRIQUE', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-08-01 18:26:13', 0),
(1224, 1, NULL, 'ENRIQUE', 'DAMASCO', 'enriquealducin@outlook.com', NULL, '5529227672', 17, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-08-01 18:27:14', 2),
(1225, 1, NULL, 'ENRIQUE', 'DAMASCO', 'enriquealducin@outlook.com', NULL, '5529227672', 17, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 0, NULL, '2019-08-01 18:28:10', 6),
(1226, 1, NULL, 'ENRIQUE', 'DAMASCO', 'enriquealducin@outlook.com', NULL, '5529227672', 17, 2, 0, 44, 1, '2019-08-07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 0, NULL, '2019-08-01 18:29:26', 6),
(1227, 1, '1226', 'ENRIQUE', 'DAMASCO', 'enriquealducin@outlook.com', NULL, '5529227672', 17, 2, 0, 44, 1, '2019-08-07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 0, NULL, '2019-08-01 18:42:27', 4),
(1228, 1, '1225', 'ENRIQUE', 'DAMASCO', 'enriquealducin@outlook.com', NULL, '5529227672', 13, 5, 0, 40, 3, '2019-08-02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 9750.00, 0, '0.00', 0, NULL, '2019-08-01 18:55:45', 6),
(1229, 1, '1228', 'ENRIQUE', 'DAMASCO', 'enriquealducin@outlook.com', NULL, '5529227672', 13, 5, 0, 40, 3, '2019-08-02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 9750.00, 0, '0.00', 0, NULL, '2019-08-01 18:56:34', 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventasserv_volar`
--

CREATE TABLE `ventasserv_volar` (
  `id_vsv` int(11) NOT NULL COMMENT 'Llave Primaria',
  `idserv_vsv` int(11) DEFAULT NULL COMMENT 'Servicio',
  `idventa_vsv` int(11) DEFAULT NULL COMMENT 'Venta',
  `cantidad_vsv` int(11) DEFAULT NULL COMMENT 'Cantidad',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `ventasserv_volar`
--

INSERT INTO `ventasserv_volar` (`id_vsv`, `idserv_vsv`, `idventa_vsv`, `cantidad_vsv`, `register`, `status`) VALUES
(1, 1, 9, 4, '2019-08-06 21:59:22', 1),
(2, 2, 9, 2, '2019-08-06 21:59:22', 1),
(3, 1, 10, 3, '2019-08-06 22:16:35', 1),
(4, 2, 10, 2, '2019-08-06 22:16:35', 1),
(5, 1, 11, 5, '2019-08-06 22:24:33', 1),
(6, 2, 11, 3, '2019-08-06 22:24:33', 1),
(7, 3, 11, 2, '2019-08-06 22:24:34', 1),
(8, 4, 11, 2, '2019-08-06 22:24:34', 1),
(9, 5, 11, 2, '2019-08-06 22:24:34', 1),
(10, 11, 11, 2, '2019-08-06 22:24:34', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas_volar`
--

CREATE TABLE `ventas_volar` (
  `id_venta` int(11) NOT NULL COMMENT 'Llave Primaria',
  `idusu_venta` int(11) NOT NULL COMMENT 'Usuario',
  `comentario_venta` text COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Comentario',
  `otroscar1_venta` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Otros Cargos',
  `precio1_venta` double(10,2) DEFAULT NULL COMMENT 'Precio',
  `otroscar2_venta` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Otros Cargos',
  `precio2_venta` double(10,2) DEFAULT NULL COMMENT 'Precio',
  `tipodesc_venta` tinyint(4) DEFAULT NULL COMMENT 'Tipo de Descuento',
  `cantdesc_venta` double(10,2) DEFAULT NULL COMMENT 'Cantidad de Descuento',
  `pagoefectivo_venta` double(10,2) DEFAULT NULL COMMENT 'Efectivo',
  `pagotarjeta_venta` double(10,2) DEFAULT NULL COMMENT 'Tarjeta',
  `total_venta` double(10,2) DEFAULT NULL COMMENT 'Total',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Ventas de CItio';

--
-- Volcado de datos para la tabla `ventas_volar`
--

INSERT INTO `ventas_volar` (`id_venta`, `idusu_venta`, `comentario_venta`, `otroscar1_venta`, `precio1_venta`, `otroscar2_venta`, `precio2_venta`, `tipodesc_venta`, `cantdesc_venta`, `pagoefectivo_venta`, `pagotarjeta_venta`, `total_venta`, `register`, `status`) VALUES
(10, 1, 'prueba servicios', NULL, NULL, NULL, NULL, NULL, NULL, 300.00, 3000.00, 3300.00, '2019-08-06 22:16:35', 1),
(11, 1, 'Aqui va un comentario muy grande para poner la descripciÃ³n de la venta qeu se acaba de realiazar desde el sitio por alguien que se encuentre por ahi ', NULL, NULL, NULL, NULL, NULL, NULL, 500.00, 11230.00, 11730.00, '2019-08-06 22:24:33', 1);

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
(3, 'Sonia', 'Alducin', 'Guajardo', 3, 3, 'oficina@volarenglobo.com.mx', '55-2921-2556', '202cb962ac59075b964b07152d234b70', 'sony', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 09:27:49', 1),
(8, 'Ricardo', 'Cruz', 'Rocha', 0, 0, 'ricardo@volarenglobo.com.mx', '55-5106-8115', '202cb962ac59075b964b07152d234b70', 'Ricardo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 16:34:09', 1),
(9, 'Alejandra', 'Ramirez', 'Serrano', 2, 6, 'turismo@volarenglobo.com.mx', '55-3070-4317', '202cb962ac59075b964b07152d234b70', 'Ale', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 16:35:26', 1),
(11, 'Sergio', 'Ramirez', NULL, 2, 6, 'sergio@volarenglobo.com.mx', '55-1234-5678', '202cb962ac59075b964b07152d234b70', 'Sergio', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 07:52:34', 1),
(12, 'Enrique', 'Perez', 'Gomez', 1, 0, 'enriqueperezgomez@gmail.com.mx', '55-2145-6545', 'Enrique', '202cb962ac59075b964b07152d234b70', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 21:15:07', 0),
(13, 'Enrique', 'Damasco', NULL, 3, 0, 'Enrique@algo.com', '55241214', '202cb962ac59075b964b07152d234b70', 'quique', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-07-30 21:15:58', 0);

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
  MODIFY `id_bp` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `cat_servicios_volar`
--
ALTER TABLE `cat_servicios_volar`
  MODIFY `id_cat` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `departamentos_volar`
--
ALTER TABLE `departamentos_volar`
  MODIFY `id_depto` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `extras_volar`
--
ALTER TABLE `extras_volar`
  MODIFY `id_extra` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=79;

--
-- AUTO_INCREMENT de la tabla `gastos_volar`
--
ALTER TABLE `gastos_volar`
  MODIFY `id_gasto` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `globos_volar`
--
ALTER TABLE `globos_volar`
  MODIFY `id_globo` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=7;

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
  MODIFY `id_puv` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=239;

--
-- AUTO_INCREMENT de la tabla `permisos_volar`
--
ALTER TABLE `permisos_volar`
  MODIFY `id_per` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `puestos_volar`
--
ALTER TABLE `puestos_volar`
  MODIFY `id_puesto` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `relacion_permisos`
--
ALTER TABLE `relacion_permisos`
  MODIFY `id_rel` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `rel_catvuelos_volar`
--
ALTER TABLE `rel_catvuelos_volar`
  MODIFY `id_rel` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=79;

--
-- AUTO_INCREMENT de la tabla `servicios_volar`
--
ALTER TABLE `servicios_volar`
  MODIFY `id_servicio` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `servicios_vuelo_temp`
--
ALTER TABLE `servicios_vuelo_temp`
  MODIFY `id_sv` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=2373;

--
-- AUTO_INCREMENT de la tabla `subpermisos_volar`
--
ALTER TABLE `subpermisos_volar`
  MODIFY `id_sp` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT de la tabla `temp_volar`
--
ALTER TABLE `temp_volar`
  MODIFY `id_temp` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=1230;

--
-- AUTO_INCREMENT de la tabla `ventasserv_volar`
--
ALTER TABLE `ventasserv_volar`
  MODIFY `id_vsv` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `ventas_volar`
--
ALTER TABLE `ventas_volar`
  MODIFY `id_venta` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=12;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
