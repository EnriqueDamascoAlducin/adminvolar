-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 04-10-2019 a las 21:09:26
-- Versión del servidor: 10.1.39-MariaDB
-- Versión de PHP: 7.3.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `afraqujt_volar`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE PROCEDURE `actualizarDireccionesRestaurantes` (IN `_hotel` INT, IN `_nombre` VARCHAR(150), IN `_precion` DECIMAL(10,2), IN `_precioa` DECIMAL(10,2), IN `_restaurant` INT, OUT `respuesta` VARCHAR(15))  BEGIN
	SET respuesta ='';
IF (_restaurant=0) THEN
	UPDATE  restaurantes_volar res,hoteles_volar ho
	SET     res.calle_restaurant = ho.calle_hotel,
			 res.noint_restaurant = ho.noint_hotel,
			 res.noext_restaurant = ho.noext_hotel,
			 res.colonia_restaurant = ho.colonia_hotel,
			 res.municipio_restaurant = ho.municipio_hotel,
			 res.estado_restaurant = ho.estado_hotel,
			 res.cp_restaurant = ho.cp_hotel,
			 res.telefono_restaurant = ho.telefono_hotel,
			 res.telefono2_restaurant = ho.telefono2_hotel,
			 res.correo_restaurant = ho.correo_hotel,
			 res.img_restaurant = ho.img_hotel,
			 res.pagina_restaurant = ho.pagina_hotel
	WHERE   res.hotel_restaurant = ho.id_hotel and ho.id_hotel=_hotel;
	SET respuesta ='Actualizado';
ELSE
	UPDATE  restaurantes_volar res,hoteles_volar ho
	SET      res.nombre_restaurant = _nombre,
			 res.precion_restaurant = _precion,
			 res.precioa_restaurant = _precioa,
			 res.calle_restaurant = ho.calle_hotel,
			 res.noint_restaurant = ho.noint_hotel,
			 res.noext_restaurant = ho.noext_hotel,
			 res.colonia_restaurant = ho.colonia_hotel,
			 res.municipio_restaurant = ho.municipio_hotel,
			 res.estado_restaurant = ho.estado_hotel,
			 res.cp_restaurant = ho.cp_hotel,
			 res.telefono_restaurant = ho.telefono_hotel,
			 res.telefono2_restaurant = ho.telefono2_hotel,
			 res.correo_restaurant = ho.correo_hotel,
			 res.img_restaurant = ho.img_hotel,
			 res.pagina_restaurant = ho.pagina_hotel,
			 res.hotel_restaurant=_hotel
	WHERE     ho.id_hotel=_hotel and res.id_restaurant=_restaurant ;
	SET respuesta ='Actualizado';
END IF;
END$$

CREATE PROCEDURE `agregarServiciosReservas` (IN `_reserva` BIGINT, IN `_servicio` INT, IN `_tipo` INT, IN `_cantidad` BIGINT, OUT `respuesta` VARCHAR(50))  BEGIN
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

CREATE PROCEDURE `asigarPermisosModulos` (IN `_usuario` INT, IN `_modulo` INT, IN `_status` INT, OUT `_respuesta` VARCHAR(20))  BEGIN
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

CREATE PROCEDURE `eliminarDepartamento` (IN `_depto` INT, OUT `respuesta` VARCHAR(25))  BEGIN
	UPDATE departamentos_volar set status=0 where id_depto=_depto ;
    UPDATE puestos_volar set status=0 where depto_puesto = _depto ;
    update volar_usuarios set depto_usu = null, puesto_usu=null where depto_usu= _depto;
    SET respuesta = 'Eliminado';
END$$

CREATE PROCEDURE `eliminarPuesto` (IN `_puesto` INT, OUT `respuesta` VARCHAR(10))  BEGIN
	UPDATE puestos_volar set status=0 where id_puesto = _puesto;
    UPDATE volar_usuarios set puesto_usu=null where puesto_usu = _puesto;
    SET respuesta='Eliminado';
END$$

CREATE PROCEDURE `eliminarServicio` (IN `_servicio` INT, OUT `respuesta` VARCHAR(20))  BEGIN
	UPDATE servicios_volar SET STATUS= 0 WHERE id_servicio=_servicio;
    SET respuesta = 'Eliminado';
END$$

CREATE PROCEDURE `getReservaData` (IN `_reserva` INT)  BEGIN
	Select id_temp, idusu_temp, IFNULL(clave_temp,"") as clave_temp, IFNULL(nombre_temp,"") as nombre_temp, IFNULL(apellidos_temp,"") as apellidos_temp, IFNULL(mail_temp,"") as mail_temp, IFNULL(telfijo_temp,"") as telfijo_temp, IFNULL(telcelular_temp,"") as telcelular_temp, IFNULL(procedencia_temp,"") as procedencia_temp, IFNULL(pasajerosa_temp,"") as pasajerosa_temp,IFNULL(pasajerosn_temp,"") as pasajerosn_temp, IFNULL(motivo_temp,"") as motivo_temp, IFNULL(tipo_temp,"") as tipo_temp,  IFNULL(fechavuelo_temp,"") as fechavuelo_temp,  IFNULL(tarifa_temp,"") as tarifa_temp, IFNULL(hotel_temp,"") as hotel_temp,  IFNULL(habitacion_temp,"") as habitacion_temp,  IFNULL(checkin_temp,"") as checkin_temp,IFNULL(checkout_temp,"") as checkout_temp,IFNULL(comentario_temp,"") as comentario_temp, IFNULL(otroscar1_temp,"") as otroscar1_temp, IFNULL(otroscar2_temp,"") as otroscar2_temp, IFNULL(precio1_temp,"") as precio1_temp,
IFNULL(precio2_temp,"") as precio2_temp, IFNULL(tdescuento_temp,"") as tdescuento_temp, IFNULL(cantdescuento_temp,"") as cantdescuento_temp, IFNULL(total_temp,"") as total_temp, IFNULL(piloto_temp,"") as piloto_temp, IFNULL(kg_temp,"") as kg_temp, IFNULL(globo_temp,"") AS globo_temp, IFNULL(hora_temp,"") as hora_temp,idioma_temp,tipopeso_temp,ifnull(comentarioint_temp,'') as comentarioint_temp, register,status
from temp_volar
Where id_temp =_reserva ;
END$$

CREATE PROCEDURE `getResumenREserva` (IN `_reserva` BIGINT)  BEGIN
SELECT IFNULL((SELECT nombre_extra from extras_volar where id_extra=tv.motivo_temp),'') as motivo,IFNULL(comentario_temp,'') as comentario,ifnull(pasajerosa_temp,0) as pasajerosA , ifnull(pasajerosn_temp,0) as pasajerosN , IFNULL(habitacion_temp,'') as habitacion, tipo_temp, checkin_temp,checkout_temp, IFNULL(precio1_temp,0) as precio1, IFNULL(precio2_temp,0) as precio2, IFNULL(tdescuento_temp,'') as tdescuento, IFNULL(cantdescuento_temp,0) as cantdescuento, IFNULL(otroscar1_temp,'') as otroscar1,IFNULL(otroscar2_temp,'') as otroscar2,
IFNULL((SELECT IFNULL( nombre_hotel,'') as hotel FROM hoteles_volar where id_hotel=tv.hotel_temp),'') as hotel,
IFNULL((SELECT CONCAT(IFNULL(nombre_habitacion,''),'|', IFNULL(precio_habitacion,0) ,'|', IFNULL(capacidad_habitacion,0)  ,'|', IFNULL(descripcion_habitacion,'')  ) as Habitaciones FROM habitaciones_volar WHERE id_habitacion=tv.habitacion_temp),'') as habitacion,
IFNULL(fechavuelo_temp,'Fecha No Asignada') as fechavuelo, CONCAT(IFNULL(nombre_temp,''),' ', IFNULL(apellidos_temp,'')) as nombre, IFNULL(mail_temp,'') as correo, CONCAT(IFNULL(telfijo_temp,''),' <br> ', IFNULL(telcelular_temp,'')) as telefonos, nombre_vc as tipoVuelo, precion_vc as precioN, precioa_vc as precioA,idioma_temp,tipopeso_temp
FROM temp_volar tv  INNER JOIN vueloscat_volar vcv on vcv.id_vc = tv.tipo_temp
Where id_temp=_reserva;
END$$

CREATE PROCEDURE `getServicioInfo` (IN `_servicio` INT)  BEGIN
	Select id_servicio as id, nombre_servicio as nombre, precio_servicio as precio from servicios_volar where id_servicio=_servicio ;
END$$

CREATE PROCEDURE `getServiciosReservas` (IN `_reserva` BIGINT, IN `_tipo` INT, IN `_servicio` INT)  BEGIN
	Select * from servicios_vuelo_temp where idtemp_sv = _reserva  and tipo_sv = _tipo and idservi_sv = _servicio and cantidad_sv>0 ;
END$$

CREATE PROCEDURE `getServiciosXVta` (IN `venta` BIGINT, IN `servicio` INT, OUT `respuesta` INT)  BEGIN
	IF(Select count(id_vsv) as cantidad from ventasserv_volar where idserv_vsv=servicio and idventa_vsv=venta and status<>0 and cantidad_vsv>0)>0 THEN
    	SET respuesta = (Select cantidad_vsv as cantidad from ventasserv_volar where idserv_vsv=servicio and idventa_vsv=venta and status<>0 and cantidad_vsv>0);
    ELSE
     SET respuesta = 0;
    END IF;
END$$

CREATE PROCEDURE `getUsuarioInfo` (IN `_usuario` INT)  BEGIN
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

CREATE PROCEDURE `permisosModulos` (IN `_idusu` INT)  BEGIN
Select DISTINCT(nombre_per) as nombre, img_per, ruta_per,id_per
FROM permisos_volar pv
	INNER JOIN subpermisos_volar spv on pv.id_per=spv.permiso_sp
    INNER JOIN permisosusuarios_volar puv on spv.id_sp=puv.idsp_puv
WHERE pv.status<>0 and spv.status<>0 and puv.status<>0 and  idusu_puv =_idusu  ORDER BY nombre ASC;
END$$

CREATE PROCEDURE `permisosSubModulos` (IN `_idusu` INT, IN `_idmodulo` INT)  BEGIN
Select nombre_sp, nombre_per
FROM subpermisos_volar sp INNER JOIN permisos_volar pv on pv.id_per=sp.permiso_sp INNER JOIN permisosusuarios_volar pus on pus.idsp_puv= sp.id_sp
WHERE pv.status<>0 and sp.status<>0 and pus.status<>0 AND pus.idusu_puv=_idusu and pv.id_per=_idmodulo;
END$$

CREATE PROCEDURE `registrarComentario` (IN `_comentario` TEXT, IN `_idusu` INT, IN `_reserva` INT, OUT `respuesta` VARCHAR(15))  BEGIN
	UPDATE bitcomentarios_volar set status = 2 where idtemp_bc = _reserva;
    INSERT INTO bitcomentarios_volar(idusu_bc,idtemp_bc,comentariop_bc,comentarion_bc)
    SELECT _idusu, _reserva, comentarioint_temp,_comentario from temp_volar where id_temp = _reserva;
    UPDATE temp_volar set comentarioint_temp = _comentario where id_temp = _reserva;
    set respuesta = 'Actualizado';
END$$

CREATE PROCEDURE `registrarHabitacionHotel` (IN `_hotel` INT, IN `_nombre` VARCHAR(150), IN `_precion` DECIMAL(10,2), IN `_precioa` DECIMAL(10,2), OUT `lid` VARCHAR(15))  BEGIN
	INSERT INTO restaurantes_volar (
		nombre_restaurant,
		hotel_restaurant,
		calle_restaurant,
		noint_restaurant,
		noext_restaurant,
		colonia_restaurant,
		municipio_restaurant,
		estado_restaurant,
		cp_restaurant,
		telefono_restaurant,
		telefono2_restaurant,
		precioa_restaurant,
		precion_restaurant
	)
	SELECT _nombre,
		_hotel,
		calle_hotel,
		noint_hotel,
		noext_hotel,
		colonia_hotel,
		municipio_hotel,
		estado_hotel,
		cp_hotel,
		telefono_hotel,
		telefono2_hotel,
		_precioa,
		_precion
From hoteles_volar
	where id_hotel=_hotel;
	     SET lid = LAST_INSERT_ID();
END$$

CREATE PROCEDURE `registrarPago` (IN `_pago` BIGINT, IN `_reserva` BIGINT, IN `_usuario` INT, IN `_metodo` INT, IN `_banco` INT, IN `_referencia` VARCHAR(200), IN `_cantidad` DOUBLE(10,2), IN `_fechaPago` VARCHAR(30), IN `_usuarioCOncilia` INT, OUT `respuesta` VARCHAR(25))  BEGIN
IF(SELECT COUNT(id_bp) as pagos from bitpagos_volar  where idres_bp=_reserva )>0 THEN
    IF (SELECT (ifnull(sum(cantidad_bp),0)+ _cantidad ) from bitpagos_volar where idres_bp=_reserva )>(Select total_temp FROM temp_volar where id_temp  = _reserva) THEN
        SET respuesta = 'ERROR EN PAGO';
    ELSEIF (_usuarioConcilia=0) THEN
        INSERT INTO bitpagos_volar (idres_bp,idreg_bp,metodo_bp,banco_bp,referencia_bp,cantidad_bp,fecha_bp) VALUES (_reserva,_usuario,_metodo,_banco,_referencia,_cantidad,_fechaPago);
        SET respuesta = CONCAT('Registrado|',LAST_INSERT_ID());
        IF(_banco=83) THEN
            UPDATE bitpagos_volar set status = 2 WHERE id_bp = LAST_INSERT_ID();
              IF (SELECT (sum(cantidad_bp) ) from bitpagos_volar where idres_bp in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID()) )=(Select total_temp FROM temp_volar where id_temp  in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID())) THEN
                  UPDATE temp_volar set status = 7 WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID());
              ELSE
                  UPDATE temp_volar set status = 8 WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID());
              END IF;
        END IF;
    ELSE
        UPDATE bitpagos_volar SET idconc_bp=_usuarioCOncilia, fechaconc_bp= CURRENT_TIMESTAMP, status = 3 WHERE id_bp = _pago;
        SET respuesta = 'Conciliado';
          IF (SELECT (sum(cantidad_bp)+ _cantidad ) from bitpagos_volar where idres_bp in (SELECT idres_bp from bitpagos_volar where id_bp = _pago) )=(Select total_temp FROM temp_volar where id_temp  in (SELECT idres_bp from bitpagos_volar where id_bp = _pago)) THEN
              UPDATE temp_volar set status = 7 WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp =  _pago);
          ELSE
              UPDATE temp_volar set status = 4 WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp =  _pago);
          END IF;
    END IF;

  ELSEIF(SELECT total_temp from temp_volar where id_temp=_reserva) < _cantidad THEN
    SET respuesta = 'ERROR EN PAGO';

  ELSE
    INSERT INTO bitpagos_volar (idres_bp,idreg_bp,metodo_bp,banco_bp,referencia_bp,cantidad_bp,fecha_bp) VALUES (_reserva,_usuario,_metodo,_banco,_referencia,_cantidad,_fechaPago);
    SET respuesta = CONCAT('Registrado|',LAST_INSERT_ID());

    IF(_banco=83) THEN
        UPDATE bitpagos_volar set status = 2 WHERE id_bp = LAST_INSERT_ID();
          IF (SELECT (sum(cantidad_bp) ) from bitpagos_volar where idres_bp in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID()) )=(Select total_temp FROM temp_volar where id_temp  in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID())) THEN
              UPDATE temp_volar set status = 7 WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID());
          ELSE
              UPDATE temp_volar set status = 8 WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID());
          END IF;
    END IF;
  END IF;
END$$

CREATE PROCEDURE `registrarReserva` (IN `_idusu` INT, OUT `lid` BIGINT)  BEGIN
	Insert INTO temp_volar (idusu_temp) VALUES(_idusu);
   	SET lid =  LAST_INSERT_ID();
END$$

CREATE PROCEDURE `registrarRestaurantHotel` (IN `_hotel` INT, IN `_nombre` VARCHAR(250), IN `_precion` DECIMAL(10,2), IN `_precioa` DECIMAL(10,2), OUT `LID` INT)  BEGIN
	INSERT INTO restaurantes_volar (
	nombre_restaurant,
	calle_restaurant,
	noint_restaurant,
	noext_restaurant,
	colonia_restaurant,
	municipio_restaurant,
	estado_restaurant,
	cp_restaurant,
	telefono_restaurant,
	telefono2_restaurant,
	correo_restaurant,
	img_restaurant,
	pagina_restaurant,
	precion_restaurant,
	precioa_restaurant
	) select _nombre,
			calle_hotel,
			noint_hotel,
			noext_hotel,
			colonia_hotel,
			municipio_hotel,
			estado_hotel,
			cp_hotel,
			telefono_hotel,
			telefono2_hotel,
			correo_hotel,
			img_hotel,
			pagina_hotel,
			_precion,
			_precioa
		from hoteles_volar
		where id_hotel=_hotel;
       SET LID = LAST_INSERT_ID();
END$$

CREATE PROCEDURE `registrarServicioVta` (IN `servicio` INT, IN `venta` BIGINT, IN `cantidad` INT, OUT `respuesta` VARCHAR(20))  BEGIN
	INSERT INTO ventasserv_volar (idserv_vsv,idventa_vsv,cantidad_vsv) VALUES (servicio,venta,cantidad);
    SET respuesta = 'Venta Registrada';
END$$

CREATE PROCEDURE `registrarUsuario` (IN `idusu` INT, IN `nombre` VARCHAR(200), IN `apellidop` VARCHAR(200), IN `apellidom` VARCHAR(200), IN `depto` INT, IN `puesto` INT, IN `correo` VARCHAR(250), IN `telefono` VARCHAR(14), IN `contrasena` VARCHAR(200), IN `usuario` VARCHAR(200), OUT `respuesta` VARCHAR(20))  BEGIN
IF(SELECT COUNT(id_usu) from volar_usuarios vu where vu.usuario_usu=usuario and vu.status<>0 and id_usu<> idusu)>0 THEN
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

CREATE PROCEDURE `registroVenta` (IN `usuario` INT, IN `comentario` TEXT, IN `otroscar1` VARCHAR(250), IN `precio1` DOUBLE(10,2), IN `otroscar2` VARCHAR(250), IN `precio2` DOUBLE(10,2), IN `tipodesc` INT, IN `cantdesc` DOUBLE(10,2), IN `pagoefectivo` DOUBLE(10,2), IN `pagotarjeta` DOUBLE(10,2), IN `total` DOUBLE(10,2), OUT `LID` INT)  BEGIN
	INSERT INTO ventas_volar (idusu_venta,comentario_venta,otroscar1_venta,precio1_venta,otroscar2_venta,precio2_venta,tipodesc_venta,cantdesc_venta,pagoefectivo_venta,pagotarjeta_venta,total_venta) VALUES (usuario,comentario,otroscar1,precio1,otroscar2,precio2,tipodesc,cantdesc,pagoefectivo,pagotarjeta,total);
	SET lid = LAST_INSERT_ID();
END$$

CREATE PROCEDURE `remplazarReserva` (IN `_reserva` INT, IN `_idusu` INT, OUT `lid` INT)  BEGIN
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
		tipopeso_temp,
        globo_temp,
        hora_temp,
		idioma_temp,
        comentarioint_temp
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
		tipopeso_temp,
        globo_temp,
        hora_temp,
		idioma_temp,
        comentarioint_temp
       FROM temp_volar
       where id_temp =  _reserva ;
	     SET lid = LAST_INSERT_ID();
      IF(SELECT COUNT(id_bp) from bitpagos_volar where idres_bp = _reserva and status <>0 )>0 THEN
        UPDATE temp_volar set status=4 where id_temp = lid;
        UPDATE bitpagos_volar set idres_bp = lid,status=3 where idres_bp=_reserva and status <>0;
      ELSEIF(SELECT ifnull(total_temp,0) as total from temp_volar where id_temp = lid)>0 THEN
        UPDATE temp_volar set status=3 where id_temp=lid;
    END IF;
    UPDATE temp_volar set clave_temp =_reserva, idusu_temp=_idusu  where id_temp=lid;
    UPDATE temp_volar set status = 6 where id_temp=_reserva;
END$$

CREATE PROCEDURE `remplazarServiciosReservas` (IN `_reserva` BIGINT, IN `_oldReserva` BIGINT)  BEGIN
	INSERT INTO servicios_vuelo_temp
		(idservi_sv,tipo_sv,cantidad_sv,status)
		SELECT idservi_sv,tipo_sv,cantidad_sv,status from servicios_vuelo_temp where idtemp_sv =_oldReserva;
        UPDATE servicios_vuelo_temp set idtemp_sv = _reserva where idtemp_sv is null;
END$$

CREATE PROCEDURE `reprogramarReserva` (IN `_reserva` BIGINT, IN `_idusu` INT, IN `_fechan` DATE, IN `_comentario` TEXT, IN `_motivo` TINYINT, IN `_cargo` TINYINT, OUT `_respuesta` VARCHAR(15))  BEGIN
	UPDATE reprogramaciones_volar set status = 2 where idtemp_rep = _reserva;
	INSERT INTO reprogramaciones_volar
(idtemp_rep,idusu_rep,fechaa_rep,fechan_rep,comentario_rep,motivo_rep,cargo_rep)
		SELECT _reserva, _idusu,fechavuelo_temp,_fechan,_comentario, _motivo, _cargo FROM temp_volar where id_temp=_reserva;
	UPDATE temp_volar set fechavuelo_temp =_fechan where id_temp = _reserva;
    SET _respuesta = 'Reprogramado';
END$$

CREATE PROCEDURE `usuarioLoggeado` (IN `_usuario` VARCHAR(100), IN `_password` VARCHAR(150))  BEGIN
 SELECT *
 FROM volar_usuarios vu
 WHERE vu.usuario_usu=_usuario and vu.contrasena_usu=_password;
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
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Reistro',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Status'
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
-- Estructura de tabla para la tabla `bitcomentarios_volar`
--

CREATE TABLE `bitcomentarios_volar` (
  `id_bc` int(11) NOT NULL COMMENT 'Llave Primaria',
  `idusu_bc` int(11) NOT NULL COMMENT 'Usuario',
  `idtemp_bc` bigint(20) NOT NULL COMMENT 'Reserva',
  `comentariop_bc` text NOT NULL COMMENT 'Comentario Pasado',
  `comentarion_bc` text NOT NULL COMMENT 'Comentario Nuevo',
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Register',
  `status` tinyint(4) NOT NULL DEFAULT '4' COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Bitácora de Pagos';

--
-- Volcado de datos para la tabla `bitpagos_volar`
--

INSERT INTO `bitpagos_volar` (`id_bp`, `idres_bp`, `idreg_bp`, `metodo_bp`, `banco_bp`, `referencia_bp`, `cantidad_bp`, `fecha_bp`, `idconc_bp`, `fechaconc_bp`, `register`, `status`) VALUES
(9, 0, 0, 0, 0, '', '0.00', '0000-00-00', NULL, NULL, '2019-08-08 15:21:04', 4),
(22, 1001, 16, 89, 64, '13066Y', '2000.00', '2019-09-06', 17, '2019-09-06 12:34:27', '2019-09-06 12:31:48', 1),
(23, 1003, 16, 61, 64, 'PEDIDO 3952', '8817.00', '2019-09-06', 17, '2019-09-06 13:34:20', '2019-09-06 13:31:04', 2),
(24, 1011, 11, 60, 83, 'CHECO002', '1.00', '2019-09-10', 17, '2019-09-10 17:43:48', '2019-09-10 17:41:57', 1),
(25, 1015, 16, 57, 64, '0056969008', '2000.00', '2019-09-11', 17, '2019-09-11 12:57:45', '2019-09-11 12:54:11', 1),
(26, 1012, 14, 55, 64, '23564', '2000.00', '2019-09-11', 17, '2019-09-11 16:45:50', '2019-09-11 13:16:06', 2),
(27, 1019, 16, 61, 64, 'PEDIDO 3993', '8600.00', '2019-09-11', 17, '2019-09-11 15:01:33', '2019-09-11 14:58:20', 2),
(28, 1027, 16, 89, 64, 'APROB: 510011', '2000.00', '2019-09-12', 17, '2019-09-12 13:05:29', '2019-09-12 13:00:37', 1),
(29, 1029, 16, 89, 64, 'APROB: 648421', '2000.00', '2019-09-12', 17, '2019-09-12 13:32:40', '2019-09-12 13:29:17', 1),
(30, 1031, 16, 61, 64, 'PEDIDO3996', '5018.00', '2019-09-12', 17, '2019-09-12 14:39:16', '2019-09-12 14:37:38', 2),
(31, 1025, 14, 55, 64, '23589', '2000.00', '2019-09-12', 17, '2019-09-12 17:26:41', '2019-09-12 17:22:54', 1),
(32, 1032, 14, 59, 64, '23596', '7197.00', '2019-09-12', 17, '2019-09-12 17:27:20', '2019-09-12 17:25:18', 2),
(33, 1034, 16, 57, 64, 'SPEI 59279', '2000.00', '2019-09-13', 17, '2019-09-13 14:47:31', '2019-09-13 14:45:45', 1),
(34, 1044, 16, 57, 64, '0000554008', '2000.00', '2019-09-14', 17, '2019-09-14 12:49:13', '2019-09-14 12:21:10', 1),
(35, 1039, 11, 87, 76, 'Aut 69473', '3600.00', '2019-09-14', 17, '2019-09-14 22:45:45', '2019-09-14 22:17:39', 3),
(36, 1038, 14, 55, 64, '23610', '2000.00', '2019-09-14', 17, '2019-09-17 12:43:31', '2019-09-17 12:29:41', 2),
(37, 1052, 16, 57, 64, 'folio 0044193011', '2000.00', '2019-09-17', 17, '2019-09-17 13:36:11', '2019-09-17 13:32:37', 1),
(38, 1051, 14, 55, 64, '1051', '2000.00', '2019-09-13', 17, '2019-09-17 13:37:28', '2019-09-17 13:33:43', 2),
(39, 1057, 14, 55, 64, '1057', '2000.00', '2019-09-17', 17, '2019-09-17 14:33:58', '2019-09-17 14:32:38', 2),
(40, 1088, 14, 59, 64, 'FOL 5332 AUT 984314', '2000.00', '2019-09-17', 17, '2019-09-17 15:01:07', '2019-09-17 14:59:34', 1),
(41, 1002, 16, 55, 64, 'FORMATO 0095', '2000.00', '2019-09-17', 17, '2019-09-18 15:03:21', '2019-09-18 11:46:47', 1),
(42, 1076, 16, 61, 64, '4003', '5598.00', '2019-09-18', 17, '2019-09-18 15:05:03', '2019-09-18 15:02:47', 2),
(43, 1082, 11, 94, 64, 'BESTDAY ID 73529389-1', '0.00', '2019-09-18', 17, '2019-09-18 17:58:11', '2019-09-18 17:26:02', 3),
(44, 1090, 16, 57, 64, '0004503013', '2000.00', '2019-09-18', 17, '2019-09-18 18:28:29', '2019-09-18 18:26:35', 2),
(45, 1059, 16, 57, 64, '21864', '2000.00', '2019-09-18', 17, '2019-09-18 20:02:50', '2019-09-18 19:52:50', 1),
(46, 1086, 14, 55, 64, '1086', '2000.00', '2019-09-18', 17, '2019-09-19 10:56:53', '2019-09-19 10:35:10', 2),
(47, 1089, 14, 57, 64, 'ref 6704517', '4000.00', '2019-09-18', 17, '2019-09-19 10:59:14', '2019-09-19 10:36:53', 2),
(48, 1093, 16, 56, 77, 'AUT 281843 FOLIO 1228642', '1800.00', '2019-09-19', 17, '2019-09-19 11:21:56', '2019-09-19 11:18:15', 1),
(49, 1096, 14, 57, 64, 'FOL 0036138011', '2000.00', '2019-09-19', 17, '2019-09-19 13:08:21', '2019-09-19 13:06:37', 1),
(50, 1097, 9, 94, 64, 'CXC EXPEDIA', '0.00', '2019-09-19', 17, '2019-09-19 14:18:27', '2019-09-19 14:14:11', 3),
(51, 1098, 9, 94, 64, 'CXC BESTDAY ID 73666355-1', '0.00', '2019-09-19', 17, '2019-09-19 14:28:47', '2019-09-19 14:27:20', 3),
(52, 1099, 9, 94, 64, 'CXC PRICE TRAVEL LOCATOR 12707825-1', '0.00', '2019-09-19', 17, '2019-09-19 15:05:12', '2019-09-19 14:51:12', 3),
(53, 1146, 16, 57, 64, '281877', '3000.00', '2019-09-19', 17, '2019-09-19 15:18:15', '2019-09-19 15:13:26', 3),
(54, 1101, 9, 94, 64, 'CXC EXPEDIA', '0.00', '2019-09-19', 17, '2019-09-19 15:36:58', '2019-09-19 15:29:19', 3),
(55, 1102, 9, 94, 64, 'CXC EXPEDIA', '0.00', '2019-09-19', 17, '2019-09-19 15:52:01', '2019-09-19 15:50:09', 3),
(56, 1106, 9, 94, 64, 'CXC EXPLORA Y DESCUBRE', '0.00', '2019-09-19', 17, '2019-09-19 18:46:13', '2019-09-19 18:43:45', 3),
(57, 1107, 9, 94, 64, 'CXC BOOKING', '0.00', '2019-09-19', 17, '2019-09-19 18:52:25', '2019-09-19 18:50:45', 3),
(58, 1095, 14, 55, 64, '0100', '2000.00', '2019-09-19', 17, '2019-09-20 11:32:12', '2019-09-20 11:28:20', 2),
(59, 1110, 9, 94, 64, 'CXC HIS', '0.00', '2019-09-20', 17, '2019-09-20 12:21:29', '2019-09-20 12:19:28', 3),
(60, 1111, 9, 94, 64, 'CXC PRICE TRAVEL LOCATOR 12209035-1', '0.00', '2019-09-20', 17, '2019-09-20 12:36:42', '2019-09-20 12:34:48', 3),
(61, 1116, 14, 89, 64, '151648', '2000.00', '2019-09-20', 17, '2019-09-20 15:20:11', '2019-09-20 15:14:36', 1),
(62, 1117, 9, 94, 64, 'CXC 014 MEDIA', '0.00', '2019-09-20', 17, '2019-09-20 15:27:28', '2019-09-20 15:25:52', 3),
(63, 1117, 9, 94, 64, 'CXC 014 MEDIA', '0.00', '2019-09-20', NULL, NULL, '2019-09-20 15:25:54', 0),
(64, 1121, 9, 94, 64, 'CXC BOOKING', '0.00', '2019-09-20', 17, '2019-09-20 16:57:42', '2019-09-20 16:56:07', 3),
(65, 1122, 9, 94, 64, 'CXC BOOKING', '0.00', '2019-09-20', 17, '2019-09-20 17:07:57', '2019-09-20 17:06:28', 3),
(66, 1119, 16, 55, 64, 'PAYPAL FORMATO 0102', '2000.00', '2019-09-20', 17, '2019-09-20 18:05:33', '2019-09-20 18:02:31', 2),
(67, 1125, 9, 94, 64, 'CXC PRICE TRAVEL LOCATOR 12965767-1', '0.00', '2019-09-20', 17, '2019-09-20 18:29:49', '2019-09-20 18:28:04', 3),
(68, 1126, 9, 94, 64, 'cxc bestday id 73839672-5', '0.00', '2019-09-20', 17, '2019-09-20 18:50:19', '2019-09-20 18:47:19', 3),
(69, 1213, 9, 89, 64, 'APROB 005345', '2000.00', '2019-09-20', 17, '2019-09-20 18:51:41', '2019-09-20 18:50:25', 3),
(70, 1127, 9, 94, 64, 'CXC BOOKING', '0.00', '2019-09-21', 17, '2019-09-21 12:21:13', '2019-09-21 12:15:36', 3),
(71, 1128, 9, 94, 64, 'cxc expedia', '0.00', '2019-09-21', 3, '2019-09-21 12:23:31', '2019-09-21 12:22:04', 3),
(72, 1129, 9, 94, 64, 'cxc booking', '0.00', '2019-09-21', 17, '2019-09-21 12:31:01', '2019-09-21 12:29:37', 3),
(73, 1130, 9, 94, 64, 'CXC BESTDAY ID 73865987-1', '0.00', '2019-09-21', 17, '2019-09-21 12:45:46', '2019-09-21 12:35:55', 3),
(74, 1131, 9, 94, 64, 'CXC WAYAK', '0.00', '2019-09-21', 3, '2019-09-21 13:27:47', '2019-09-21 13:26:01', 3),
(75, 1075, 9, 59, 64, 'aut 025468', '1000.00', '2019-09-21', 17, '2019-09-21 14:43:52', '2019-09-21 14:20:04', 2),
(76, 1064, 14, 57, 64, '8070909637', '2000.00', '2019-09-21', 17, '2019-09-21 18:21:52', '2019-09-21 18:18:31', 1),
(77, 1132, 14, 61, 64, 'CONEKTA PED 4028', '4198.00', '2019-09-23', 17, '2019-09-23 12:26:27', '2019-09-23 12:25:07', 2),
(78, 1134, 9, 94, 64, 'CXC BESTDAY ID 73929099-1', '0.00', '2019-09-23', 17, '2019-09-23 13:24:21', '2019-09-23 13:22:32', 3),
(79, 1061, 14, 55, 64, 'FACT 0104', '2000.00', '2019-09-21', 17, '2019-09-23 13:34:16', '2019-09-23 13:30:49', 2),
(80, 1135, 9, 94, 64, 'CXC BESTDAY ID 73929685-1', '0.00', '2019-09-23', NULL, NULL, '2019-09-23 13:31:04', 4),
(81, 1072, 14, 61, 64, 'CONEKTA PED 4010', '7000.00', '2019-09-20', 3, '2019-09-23 13:51:33', '2019-09-23 13:38:05', 2),
(82, 1136, 9, 94, 64, 'CXC TURISKY', '0.00', '2019-09-23', 3, '2019-09-23 13:57:39', '2019-09-23 13:56:20', 3),
(83, 1133, 16, 59, 64, 'mov 25265', '2000.00', '2019-09-23', 3, '2019-09-23 15:34:46', '2019-09-23 15:25:09', 1),
(84, 1137, 14, 55, 64, 'paypal', '2000.00', '2019-09-23', 17, '2019-09-23 16:48:54', '2019-09-23 16:34:26', 1),
(85, 1146, 16, 57, 64, '281877', '3000.00', '2019-09-19', 17, '2019-09-24 12:36:30', '2019-09-24 12:15:37', 1),
(86, 1148, 9, 94, 64, 'CXC BESTDAY ID 73933847-1', '0.00', '2019-09-24', NULL, NULL, '2019-09-24 12:49:06', 4),
(87, 1149, 9, 94, 64, 'CXC EXPEDIA', '0.00', '2019-09-24', 17, '2019-09-24 12:54:47', '2019-09-24 12:53:19', 3),
(88, 1146, 16, 57, 64, '281877', '-3000.00', '2019-09-19', 3, '2019-09-24 13:14:50', '2019-09-24 13:13:46', 2),
(89, 1145, 14, 57, 64, '0070926008', '2000.00', '2019-09-24', 17, '2019-09-24 15:26:19', '2019-09-24 15:24:31', 1),
(90, 1154, 9, 94, 64, 'CXC TU EXPERIENCIA', '0.00', '2019-09-24', 17, '2019-09-24 17:53:04', '2019-09-24 17:39:00', 3),
(91, 1155, 9, 94, 64, 'CXC GALLEGOS TOURS', '0.00', '2019-09-23', 17, '2019-09-24 17:55:55', '2019-09-24 17:55:42', 3),
(92, 1151, 14, 57, 64, '2701116', '10598.00', '2019-09-24', 17, '2019-09-24 18:06:56', '2019-09-24 18:05:33', 2),
(93, 1156, 16, 59, 64, '25282', '2500.00', '2019-09-24', 17, '2019-09-24 18:30:30', '2019-09-24 18:23:45', 1),
(94, 1153, 16, 60, 75, '675103', '2000.00', '2019-09-24', 3, '2019-09-24 22:47:41', '2019-09-24 22:28:56', 1),
(95, 1158, 14, 61, 64, 'CONEKTA PED 4070', '7500.00', '2019-09-25', 17, '2019-09-25 13:06:51', '2019-09-25 13:05:12', 2),
(96, 1159, 14, 61, 64, 'CONEKTA PED 4073', '8697.00', '2019-09-25', 17, '2019-09-25 13:12:50', '2019-09-25 13:09:32', 3),
(97, 1162, 16, 57, 64, '0064728007', '2000.00', '2019-09-25', 17, '2019-09-25 15:21:34', '2019-09-25 15:10:55', 1),
(98, 1163, 16, 57, 64, '08590277483032689', '2000.00', '2019-09-25', 17, '2019-09-25 15:33:11', '2019-09-25 15:30:40', 2),
(99, 1161, 11, 89, 64, '778068', '2000.00', '2019-09-25', 17, '2019-09-25 17:14:49', '2019-09-25 17:12:37', 1),
(100, 1166, 16, 57, 64, '0019762006', '2000.00', '2019-09-25', 17, '2019-09-25 17:34:02', '2019-09-25 17:28:42', 1),
(101, 1165, 16, 57, 64, '0054096012', '2000.00', '2019-09-25', 17, '2019-09-25 18:18:32', '2019-09-25 18:15:48', 1),
(102, 1169, 14, 55, 64, '0115', '2000.00', '2019-09-25', 17, '2019-09-25 18:39:55', '2019-09-25 18:24:54', 1),
(103, 1164, 16, 89, 64, '571879', '2000.00', '2019-09-25', 17, '2019-09-25 19:05:11', '2019-09-25 19:03:40', 2),
(104, 1170, 16, 57, 64, '0083426007', '2000.00', '2019-09-25', 3, '2019-09-25 21:00:47', '2019-09-25 20:12:08', 2),
(106, 1176, 18, 55, 64, '5H503078D9755090S', '2000.00', '2019-09-25', 3, '2019-09-26 12:56:50', '2019-09-26 12:53:00', 1),
(107, 1051, 18, 60, 83, 'Pago en Sitio', '4848.00', '2019-09-26', NULL, NULL, '2019-09-26 13:16:15', 2),
(108, 1175, 16, 55, 64, 'PAYPAL FORMATO 0117', '2000.00', '2019-09-26', 3, '2019-09-26 13:22:27', '2019-09-26 13:16:44', 2),
(109, 1179, 9, 94, 64, 'CXC BOOKING', '0.00', '2019-09-26', 3, '2019-09-26 15:28:50', '2019-09-26 15:23:26', 3),
(110, 1181, 9, 94, 64, 'CXC BOOKING', '0.00', '2019-09-26', 3, '2019-09-26 16:59:50', '2019-09-26 16:52:18', 3),
(111, 1182, 9, 94, 64, 'CXC UNIVERSE TRAVEL', '0.00', '2019-09-26', 3, '2019-09-26 17:02:45', '2019-09-26 16:59:47', 3),
(112, 1183, 9, 90, 64, 'CXC BOOKING', '0.00', '2019-09-26', 3, '2019-09-26 17:24:01', '2019-09-26 17:20:52', 3),
(113, 1184, 9, 90, 64, 'CXC BOOKING', '0.00', '2019-09-26', 17, '2019-09-26 17:29:56', '2019-09-26 17:27:40', 3),
(114, 1185, 9, 94, 64, 'CXC BOOKING', '0.00', '2019-09-26', 3, '2019-09-26 23:51:51', '2019-09-26 17:34:34', 3),
(115, 1186, 9, 94, 64, 'CXC BESTDAY ID 73946246-1', '0.00', '2019-09-26', 3, '2019-09-26 23:49:38', '2019-09-26 17:39:58', 3),
(116, 1187, 14, 57, 64, 'FOL 0055754014', '4798.00', '2019-09-26', 3, '2019-09-26 19:39:54', '2019-09-26 18:21:01', 3),
(117, 1005, 16, 60, 64, 'AUT 427375 FOLIO 6216', '7000.00', '2019-09-23', 3, '2019-09-26 18:52:04', '2019-09-26 18:36:05', 2),
(118, 1190, 16, 55, 64, 'FORMATO 0090', '2000.00', '2019-09-11', 17, '2019-09-26 18:51:17', '2019-09-26 18:45:16', 1),
(119, 1191, 9, 56, 76, 'AUT 037475 FOLIO 2020853', '1000.00', '2019-09-26', 3, '2019-09-26 23:50:15', '2019-09-26 19:04:15', 3),
(120, 1196, 14, 55, 64, 'PAYPAL', '2000.00', '2019-09-03', 3, '2019-09-26 19:42:35', '2019-09-26 19:07:26', 2),
(121, 1197, 16, 57, 64, '0053542008', '2000.00', '2019-09-27', 17, '2019-09-27 11:07:46', '2019-09-27 11:02:46', 1),
(122, 1198, 16, 55, 64, 'FORMATO 0120', '2000.00', '2019-09-27', 17, '2019-09-27 11:15:39', '2019-09-27 11:10:31', 2),
(123, 1199, 16, 57, 64, '25335', '2000.00', '2019-09-27', 17, '2019-09-27 12:07:27', '2019-09-27 12:04:10', 1),
(124, 1212, 14, 57, 64, '0062996006', '1000.00', '2019-09-26', 17, '2019-09-27 12:07:50', '2019-09-27 12:04:54', 1),
(125, 1204, 14, 55, 64, '0118', '2000.00', '2019-09-26', 17, '2019-09-27 12:22:23', '2019-09-27 12:18:02', 1),
(126, 1205, 14, 55, 64, '0114', '2000.00', '2019-09-25', 17, '2019-09-27 12:35:26', '2019-09-27 12:33:53', 1),
(127, 1206, 14, 61, 64, 'conekta ped 4082', '8000.00', '2019-09-26', 3, '2019-09-27 12:48:30', '2019-09-27 12:40:48', 2),
(128, 1196, 18, 60, 83, 'Pago en Sitio', '17920.00', '2019-09-27', NULL, NULL, '2019-09-27 12:46:31', 2),
(129, 1005, 18, 60, 83, 'Pago en Sitio', '0.00', '2019-09-27', NULL, NULL, '2019-09-27 12:48:41', 2),
(130, 1211, 16, 60, 64, 'aut 231226 folio 2357', '2000.00', '2019-09-27', 3, '2019-09-27 15:01:58', '2019-09-27 14:59:12', 1),
(131, 1182, 9, 57, 64, 'CLAVE RASTREO 085904766080326998', '2350.00', '2019-09-27', 17, '2019-09-27 16:20:27', '2019-09-27 16:19:03', 3),
(132, 1227, 9, 94, 64, 'cxc booking', '0.00', '2019-09-27', 17, '2019-09-27 18:28:44', '2019-09-27 18:26:05', 3),
(133, 1215, 9, 94, 64, 'CXC TU EXPERIENCIA', '0.00', '2019-09-27', 3, '2019-09-27 18:55:09', '2019-09-27 18:53:14', 3),
(134, 1216, 9, 94, 64, 'CXC TU EXPERIENCIA', '0.00', '2019-09-27', 17, '2019-09-27 18:57:47', '2019-09-27 18:56:46', 3),
(135, 1217, 9, 94, 64, 'CXC BOOKING', '0.00', '2019-09-27', 3, '2019-09-27 19:15:03', '2019-09-27 19:01:30', 3),
(136, 1218, 16, 55, 64, 'STEPHANNIE GUTIERREZ', '4798.00', '2019-09-27', 17, '2019-09-27 19:13:17', '2019-09-27 19:07:01', 2),
(137, 1164, 18, 90, 83, 'Pago en Sitio', '3798.00', '2019-09-28', NULL, NULL, '2019-09-28 16:59:32', 2),
(138, 1163, 18, 60, 83, 'Pago en Sitio', '2000.00', '2019-09-28', NULL, NULL, '2019-09-28 16:59:59', 2),
(139, 1178, 16, 59, 64, '106883', '2000.00', '2019-09-28', 3, '2019-09-28 19:30:12', '2019-09-28 19:25:58', 2),
(140, 1219, 11, 57, 75, '39428014', '2300.00', '2019-09-29', 3, '2019-09-29 20:31:08', '2019-09-29 20:28:55', 2),
(141, 1221, 14, 59, 64, 'FOL 2900 AUT 248049', '2000.00', '2019-09-28', 17, '2019-09-30 13:02:24', '2019-09-30 12:58:02', 3),
(142, 1220, 14, 55, 64, '0128', '2000.00', '2019-09-30', 17, '2019-10-01 14:38:00', '2019-09-30 13:35:27', 1),
(143, 1224, 14, 57, 64, '00025383', '3000.00', '2019-09-30', 17, '2019-09-30 17:58:15', '2019-09-30 17:57:17', 1),
(144, 1230, 9, 94, 64, 'CXC TURISKY', '0.00', '2019-09-30', 17, '2019-09-30 18:45:34', '2019-09-30 18:44:17', 3),
(145, 1232, 9, 94, 64, 'CXC TURISKY', '0.00', '2019-09-30', 17, '2019-09-30 19:10:06', '2019-09-30 18:48:09', 3),
(146, 1170, 18, 57, 83, 'Pago en Sitio', '4500.00', '2019-10-01', NULL, NULL, '2019-10-01 10:34:36', 2),
(147, 1036, 14, 55, 64, 'paypal', '2000.00', '2019-10-01', 17, '2019-10-01 14:50:37', '2019-10-01 12:00:37', 1),
(148, 1234, 16, 55, 64, 'PAYPAL FORMATO 0129', '1000.00', '2019-10-01', 3, '2019-10-01 13:35:30', '2019-10-01 13:24:53', 3),
(149, 1234, 16, 55, 64, 'PAYPAL FORMATO 0129', '1000.00', '2019-10-01', 17, '2019-10-01 14:23:44', '2019-10-01 14:18:08', 3),
(150, 1234, 16, 55, 64, 'PAYPAL FORMATO 0129', '-1000.00', '2019-10-01', 17, '2019-10-01 14:27:10', '2019-10-01 14:26:08', 3),
(151, 1235, 14, 59, 64, 'FOL 4222 AUT 184828', '2000.00', '2019-10-01', 17, '2019-10-01 14:32:40', '2019-10-01 14:30:25', 1),
(152, 1234, 16, 55, 64, 'PAYPAL FORMATO 0129', '1000.00', '2019-10-01', 3, '2019-10-01 14:32:30', '2019-10-01 14:32:00', 1),
(153, 1234, 16, 55, 64, 'PAYPAL FORMATO 0129', '-1000.00', '2019-10-01', 3, '2019-10-01 14:37:42', '2019-10-01 14:37:13', 3),
(154, 1236, 16, 59, 64, 'mov 25421', '13800.00', '2019-10-02', 17, '2019-10-02 13:18:12', '2019-10-02 13:15:34', 2),
(155, 1243, 16, 55, 64, 'formato 0135', '2000.00', '2019-10-02', 17, '2019-10-02 18:25:35', '2019-10-02 18:23:04', 3),
(156, 1245, 9, 94, 64, 'CXC BESTDAY ID 73915099-1', '0.00', '2019-10-02', 3, '2019-10-02 18:40:31', '2019-10-02 18:38:11', 3),
(157, 1246, 9, 94, 64, 'CXC PRICETRAVEL LOCATOR 12976634-1', '0.00', '2019-10-02', 17, '2019-10-02 18:54:17', '2019-10-02 18:52:47', 3),
(158, 1240, 16, 56, 77, 'Aut 822297', '1000.00', '2019-10-02', 3, '2019-10-02 21:51:05', '2019-10-02 21:43:13', 2),
(159, 1249, 14, 59, 64, 'aut 886556', '1000.00', '2019-10-02', 17, '2019-10-03 11:36:16', '2019-10-03 11:30:29', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cat_servicios_volar`
--

CREATE TABLE `cat_servicios_volar` (
  `id_cat` int(11) NOT NULL COMMENT 'Llave Primaria',
  `nombre_cat` varchar(200) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Nombre del Servicio',
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Status'
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
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `departamentos_volar`
--

INSERT INTO `departamentos_volar` (`id_depto`, `nombre_depto`, `register`, `status`) VALUES
(1, 'SISTEMAS', '2019-07-30 15:10:37', 1),
(2, 'VENTAS', '2019-07-30 15:10:37', 1),
(3, 'FINANZAS', '2019-07-30 15:10:37', 1),
(4, 'SITIO', '2019-07-30 15:10:37', 1),
(5, 'GERENCIA', '2019-07-30 15:11:05', 1),
(6, 'VENDEDORES EXTERNOS', '2019-08-16 12:05:43', 1),
(7, 'LOGISTICA', '2019-08-16 15:01:52', 1),
(8, 'CALL CENTER', '2019-08-16 15:03:10', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `extras_volar`
--

CREATE TABLE `extras_volar` (
  `id_extra` int(11) NOT NULL COMMENT 'Llave Primaria',
  `abrev_extra` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Abreviación',
  `nombre_extra` varchar(50) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Nombre',
  `clasificacion_extra` varchar(15) COLLATE utf8_spanish_ci NOT NULL DEFAULT 'estados' COMMENT 'Clasificación',
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Status'
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
(11, 'CDMX', 'Ciudad de México', 'estados', '2019-03-31 17:30:33', 1),
(12, 'Dgo', 'Durango	', 'estados', '2019-03-31 17:30:55', 1),
(13, 'Gto.', 'Guanajuato	', 'estados', '2019-03-31 17:31:24', 1),
(14, 'Gro.', 'Guerrero	', 'estados', '2019-03-31 17:32:26', 1),
(15, 'Hgo.', 'Hidalgo	', 'estados', '2019-03-31 17:33:09', 1),
(16, 'Jal.', 'Jalisco	', 'estados', '2019-03-31 17:33:33', 1),
(17, 'EdoMe', 'México	', 'estados', '2019-03-31 17:34:04', 1),
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
(36, 'EXP', 'EXPERIENCIA', 'motivos', '2019-03-31 19:22:54', 1),
(37, 'ANV', 'ANIVERSARIO', 'motivos', '2019-03-31 19:24:02', 1),
(38, 'CUMPL', 'CUMPLEAÃ‘OS', 'motivos', '2019-03-31 19:24:27', 1),
(39, 'ANILL', 'ANILLO DE COMPROMISO', 'motivos', '2019-03-31 19:25:19', 1),
(40, 'GRUP', 'GRUPO', 'motivos', '2019-03-31 19:25:43', 1),
(41, '', 'Otros', 'motivos', '2019-03-31 19:25:57', 0),
(42, 'OTRO', 'OTRO', 'motivos', '2019-03-31 19:26:42', 1),
(43, 'FV', 'FELIZ VUELO', 'motivos', '2019-03-31 19:33:23', 1),
(44, 'QSMN', 'QUIERES SER MI NOVI@', 'motivos', '2019-03-31 19:34:25', 1),
(45, 'TA', 'TE AMO', 'motivos', '2019-03-31 19:34:44', 1),
(46, 'PRV', 'PRIVADO', 'tiposv', '2019-03-31 19:40:57', 1),
(47, 'COMP', 'COMPARTIDO', 'tiposv', '2019-03-31 19:41:23', 1),
(48, 'Descr', 'Normal', 'tarifas', '2019-03-31 19:45:02', 0),
(49, 'Prom.', 'Promoción 1', 'tarifas', '2019-03-31 19:45:44', 0),
(50, 'Prom', 'Promoción 2', 'tarifas', '2019-03-31 19:46:19', 0),
(51, 'COMP+', 'COMPARTIDO PLUS', 'tiposv', '2019-04-07 20:34:45', 0),
(55, 'S/C', 'PAYPAL', 'metodopago', '2019-04-11 21:22:01', 1),
(56, NULL, 'OXXO', 'metodopago', '2019-04-11 21:22:01', 1),
(57, NULL, 'TRANSFERENCIA ELECTRONICA', 'metodopago', '2019-04-11 21:22:01', 1),
(58, NULL, 'CHEQUE', 'metodopago', '2019-04-11 21:22:01', 1),
(59, NULL, 'DEPOSITO VENTANILLA', 'metodopago', '2019-04-11 21:22:01', 1),
(60, 'EFECTIVO', 'EFECTIVO', 'metodopago', '2019-04-11 21:22:01', 1),
(61, '0191809393', 'CONEKTA', 'metodopago', '2019-04-11 21:22:01', 1),
(64, '0191809393', 'BBVA VGAP', 'cuentasvolar', '2019-04-17 20:46:06', 1),
(65, NULL, 'Prueba', 'estados', '2019-05-18 13:50:31', 0),
(66, NULL, 'PILOTOS', 'tipogastos', '2019-05-19 16:05:52', 1),
(67, NULL, 'TRIPULACIONES', 'tipogastos', '2019-05-19 16:05:52', 1),
(68, NULL, 'COMISIONES VENDEDOR EXTERNO', 'tipogastos', '2019-05-19 16:06:41', 1),
(69, NULL, 'RETORNO DE EFECTIVO', 'tipogastos', '2019-05-19 16:07:18', 1),
(70, 'ILY', 'I LOVE YOU', 'motivos', '2019-05-21 17:11:10', 1),
(71, 'KTRIP', 'KAYTRIP', 'motivos', '2019-05-21 17:11:22', 1),
(72, 'HIS', 'HIS', 'motivos', '2019-05-21 17:11:34', 1),
(73, 'EXP01', 'EXPERIENCE', 'motivos', '2019-05-21 17:11:53', 1),
(75, '012180001637576254', 'BBVA SRG', 'cuentasvolar', '2019-07-09 17:49:45', 1),
(76, '70004861378', 'BNMX SRG', 'cuentasvolar', '2019-07-09 17:50:01', 1),
(77, '4555 1330 0115 1059', 'OXXO BBVA VGAP 1059', 'cuentasvolar', '2019-07-09 17:50:11', 1),
(78, ' 0111652184', 'BBVA VGAP DOLLAR 2184', 'cuentasvolar', '2019-07-09 18:16:26', 1),
(79, NULL, 'DSA111', 'estados', '2019-08-08 13:35:01', 0),
(80, NULL, 'dsa2', 'estados', '2019-08-08 13:36:02', 0),
(81, NULL, 'Sitio', 'metodopago', '2019-08-08 13:58:56', 0),
(82, NULL, 'Sitio2', 'metodopago', '2019-08-08 13:59:54', 0),
(83, 'STO', 'SITIO', 'cuentasvolar', '2019-08-08 14:01:31', 1),
(84, 'PRV V', 'PRIVADO VIP', 'tiposv', '2019-08-12 17:22:55', 0),
(85, 'COMPC', 'COMPARTIDO CUMPLE', 'tiposv', '2019-08-12 17:25:31', 0),
(86, '4152 3131 3885 3036', 'OXXO SRG BANCOMER', 'metodopago', '2019-08-16 18:55:28', 0),
(87, '5204 1672 4767 6299', 'OXXO BANAMEX SRG', 'metodopago', '2019-08-16 18:58:20', 0),
(88, '0010 7525 124', 'SCOTIABANK ARS', 'cuentasvolar', '2019-08-16 19:03:06', 1),
(89, '04020310', 'TERMINAL OFICINA', 'metodopago', '2019-08-19 13:02:52', 1),
(90, '04020311', 'TERMINAL SITIO', 'metodopago', '2019-08-19 13:03:36', 1),
(91, '012180001637576254', 'TRANS SRG BANCOMER', 'metodopago', '2019-08-19 13:12:08', 0),
(92, 'FINANZAS OFICINA', 'EFECTIVO OFICINA', 'metodopago', '2019-09-10 18:40:20', 0),
(93, 'FINANZAS', 'OFICINA', 'cuentasvolar', '2019-09-10 18:42:43', 1),
(94, 'S/C', 'CXC OPERADOR', 'metodopago', '2019-09-18 17:00:00', 1),
(95, '00107525124', 'SCOTIABANK', 'metodopago', '2019-09-18 17:01:45', 0),
(96, '4152 3131 3885 3036', 'OXXO BBVA SRG 3036', 'cuentasvolar', '2019-09-18 17:13:46', 1),
(97, '5204 1672 4767 6299', 'OXXO BNMX SRG 6299', 'cuentasvolar', '2019-09-18 17:15:00', 1);

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
  `register` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Register',
  `status` int(11) DEFAULT '1' COMMENT 'Status'
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
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `globos_volar`
--

INSERT INTO `globos_volar` (`id_globo`, `placa_globo`, `nombre_globo`, `peso_globo`, `maxpersonas_globo`, `imagen_globo`, `register`, `status`) VALUES
(1, 'XB-NQG', 'DAISY', '140.00', 2, 'noimage.png', '2019-05-12 15:06:29', 1),
(2, 'XB-NLM', 'NAPOLITANO', '450.00', 6, '20190812144915_20190805004402_globo.png', '2019-06-06 22:16:13', 1),
(3, 'oru4512', 'Prueba', '150.00', 15, '20190805051735_sitio.png', '2019-08-04 22:17:25', 0),
(4, '150', 'prueba3', '150.00', 15, 'noimage.png', '2019-08-04 22:22:53', 0),
(5, '', 'Enrique', '0.00', NULL, 'noimage.png', '2019-08-04 22:23:06', 0),
(6, '150', 'pruebass', '150.00', 127, '20190805052420_newc.png', '2019-08-04 22:24:12', 0),
(7, 'XB-NFX', 'ANGEL', '180.00', 3, 'noimage.png', '2019-08-12 16:18:24', 1),
(8, 'XB-NVA', 'QUETZAL', '210.00', 4, 'noimage.png', '2019-08-12 16:20:06', 1),
(9, 'XB-OUC', 'NEPTUNO', '310.00', 5, 'noimage.png', '2019-08-12 16:21:36', 1),
(10, 'XB-OBZ', 'APOLO', '6.00', 127, 'noimage.png', '2019-08-12 16:25:07', 1),
(11, 'XB-OGP', 'VULCANO', '520.00', 8, 'noimage.png', '2019-08-12 16:28:24', 1),
(12, 'XB-NZB', 'ZEUS', '620.00', 10, 'noimage.png', '2019-08-12 16:29:34', 1),
(13, 'XB-PDW', 'MAXIMUS', '850.00', 12, 'noimage.png', '2019-08-12 16:30:47', 1),
(14, 'XB-PFD', 'DRAGO', '240.00', 4, 'noimage.png', '2019-08-12 16:31:14', 1),
(15, 'XB-PLP', 'COSMO', '240.00', 4, 'noimage.png', '2019-08-12 16:31:37', 1),
(16, 'XB-PPK', 'ALEBRIJE', '620.00', 10, 'noimage.png', '2019-08-12 16:32:02', 1),
(17, 'XB-PPN', 'PANDORA', '480.00', 7, 'noimage.png', '2019-08-12 16:32:26', 1),
(18, 'XB-OOF', 'RACER', '110.00', 2, 'noimage.png', '2019-08-12 16:34:09', 1),
(19, 'XB-NVW', 'GERMANIA', '150.00', 2, 'noimage.png', '2019-08-12 16:34:35', 1),
(20, 'XB-PPM', 'ONIX', '150.00', 2, 'noimage.png', '2019-08-22 18:08:53', 1);

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
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Habitaciones por Hotel';

--
-- Volcado de datos para la tabla `habitaciones_volar`
--

INSERT INTO `habitaciones_volar` (`id_habitacion`, `nombre_habitacion`, `idhotel_habitacion`, `precio_habitacion`, `capacidad_habitacion`, `descripcion_habitacion`, `register`, `status`) VALUES
(5, 'Sencilla', 1, '950.00', 1, 'Habitación Sencilla', '2019-06-05 23:09:16', 0),
(6, 'Doble', 1, '1300.00', 2, 'Habitación Doble', '2019-06-05 23:09:46', 0),
(7, 'Triple', 1, '1450.00', 3, 'Habitación Triple', '2019-06-05 23:11:06', 0),
(8, 'Cuadruple', 1, '1650.00', 4, 'Habitación Cuádruple', '2019-06-05 23:12:35', 0),
(9, 'Suite', 1, '1850.00', 5, 'Habitación Suite', '2019-06-05 23:15:16', 0),
(10, 'Doble', 6, '650.00', 2, 'Habitación Doble', '2019-06-05 23:20:14', 1),
(11, 'Sencilla', 6, '250.00', 1, 'Habitación Sencilla', '2019-06-06 22:37:25', 1),
(12, 'hh', 6, '567.00', 567, 'bn', '2019-06-09 16:54:03', 1),
(13, 'jghjgh', 5, '546789.00', 656, 'gvbnnb', '2019-06-09 16:54:49', 0),
(14, 'Sencilla', 5, '1150.00', 2, 'Habitaci', '2019-06-09 16:58:29', 0),
(15, 'Doble', 5, '1350.00', 3, 'Habitaci', '2019-06-09 16:59:04', 0),
(16, 'Suite ', 5, '1800.00', 5, 'Habitaci', '2019-06-09 17:00:31', 0),
(17, 'Cuadruple', 5, '1600.00', 4, 'Habitación Cuádruple', '2019-06-09 17:03:18', 0),
(18, 'Triple', 5, '1380.00', 3, 'Habitacion Triple', '2019-06-09 17:05:07', 0),
(19, 'Prúeba', 5, '152.00', 122, 'Prúeba con Acentos', '2019-06-11 10:20:22', 0),
(20, 'CuÃ¡druple', 1, '1650.00', 4, 'HabitaciÃ³n CuÃ¡druple', '2019-09-02 23:08:12', 1),
(21, 'Suite', 1, '1950.00', 5, 'HabitaciÃ³n Suite', '2019-09-02 23:08:42', 1),
(22, 'Triple', 1, '1450.00', 3, 'HabitaciÃ³n Triple', '2019-09-02 23:09:15', 1),
(23, 'CuÃ¡druple', 7, '1750.00', 4, 'HabitaciÃ³n CuÃ¡druple', '2019-09-02 23:17:40', 1),
(24, 'Doble', 7, '1450.00', 2, 'HabitaciÃ³n Doble', '2019-09-02 23:17:56', 1);

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
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Tabla de Hoteles';

--
-- Volcado de datos para la tabla `hoteles_volar`
--

INSERT INTO `hoteles_volar` (`id_hotel`, `nombre_hotel`, `calle_hotel`, `noint_hotel`, `noext_hotel`, `colonia_hotel`, `municipio_hotel`, `estado_hotel`, `cp_hotel`, `telefono_hotel`, `telefono2_hotel`, `correo_hotel`, `img_hotel`, `pagina_hotel`, `register`, `status`) VALUES
(1, 'Quinto Sol', 'Ninguna', '24', NULL, 'Teotihuacan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-12 18:12:51', 1),
(5, 'Villas ArqueÃ³logicas', 'A', '', '', 'V', '', 5, 1, '55', '', NULL, NULL, NULL, '2019-06-05 19:41:39', 1),
(6, 'Posada Jade', 'Calle Cuernavaca', '1', '', 'San SebastiÃ³n Xolalpa', 'Teotihuacan', 17, NULL, '45', '', NULL, NULL, NULL, '2019-06-05 23:19:56', 0),
(7, 'Jaguar', 'na', '1', '1', '1', '1', 11, 0, '0', '1', NULL, NULL, NULL, '2019-09-02 23:17:09', 1);

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
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Status'
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
(216, 3, 7, '2019-08-01 22:55:13', 0),
(217, 3, 26, '2019-08-01 22:55:23', 1),
(218, 3, 11, '2019-08-01 22:56:04', 0),
(219, 3, 36, '2019-08-01 22:56:09', 1),
(220, 3, 1, '2019-08-01 22:56:37', 0),
(221, 3, 4, '2019-08-01 22:56:38', 0),
(222, 3, 6, '2019-08-01 22:56:39', 0),
(223, 3, 5, '2019-08-01 22:56:40', 0),
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
(235, 1, 64, '2019-08-07 00:18:43', 0),
(236, 1, 68, '2019-08-07 00:18:44', 1),
(237, 1, 69, '2019-08-07 00:18:45', 1),
(238, 1, 70, '2019-08-07 00:18:46', 1),
(239, 1, 71, '2019-08-08 11:33:54', 1),
(240, 1, 72, '2019-08-08 11:33:55', 1),
(241, 1, 73, '2019-08-08 13:51:13', 1),
(242, 11, 64, '2019-08-12 14:53:23', 1),
(243, 11, 65, '2019-08-12 14:53:23', 1),
(244, 11, 66, '2019-08-12 14:53:25', 1),
(245, 11, 68, '2019-08-12 14:53:29', 1),
(246, 11, 69, '2019-08-12 14:53:29', 1),
(247, 11, 70, '2019-08-12 14:53:30', 1),
(248, 11, 71, '2019-08-12 14:53:31', 1),
(249, 11, 72, '2019-08-12 14:53:39', 1),
(250, 11, 48, '2019-08-12 14:53:43', 1),
(251, 11, 49, '2019-08-12 14:53:43', 1),
(252, 11, 50, '2019-08-12 14:53:43', 1),
(253, 11, 51, '2019-08-12 14:53:44', 1),
(254, 11, 56, '2019-08-12 14:53:50', 1),
(255, 11, 57, '2019-08-12 14:53:50', 1),
(256, 11, 58, '2019-08-12 14:53:51', 1),
(257, 11, 1, '2019-08-12 14:53:55', 1),
(258, 11, 3, '2019-08-12 14:53:57', 1),
(259, 11, 6, '2019-08-12 14:54:00', 1),
(260, 11, 5, '2019-08-12 14:54:07', 1),
(261, 11, 53, '2019-08-12 14:54:51', 1),
(262, 11, 54, '2019-08-12 14:54:52', 1),
(263, 11, 55, '2019-08-12 14:54:52', 1),
(264, 3, 3, '2019-08-12 15:30:07', 0),
(265, 3, 12, '2019-08-12 15:30:27', 0),
(266, 3, 23, '2019-08-12 15:30:30', 0),
(267, 3, 73, '2019-08-12 15:30:34', 1),
(268, 3, 52, '2019-08-12 15:30:34', 1),
(269, 3, 29, '2019-08-12 15:30:35', 0),
(270, 3, 27, '2019-08-12 15:30:36', 1),
(271, 3, 24, '2019-08-12 15:30:53', 1),
(272, 3, 9, '2019-08-12 15:31:00', 0),
(273, 3, 56, '2019-08-12 15:31:40', 0),
(274, 3, 57, '2019-08-12 15:31:41', 0),
(275, 3, 58, '2019-08-12 15:31:45', 0),
(276, 3, 64, '2019-08-12 15:31:52', 0),
(277, 3, 65, '2019-08-12 15:31:56', 0),
(278, 3, 68, '2019-08-12 15:31:58', 0),
(279, 3, 69, '2019-08-12 15:32:02', 0),
(280, 3, 66, '2019-08-12 15:32:05', 0),
(281, 3, 71, '2019-08-12 15:32:07', 1),
(282, 3, 70, '2019-08-12 15:32:07', 1),
(283, 3, 72, '2019-08-12 15:32:10', 1),
(284, 11, 7, '2019-08-12 15:43:29', 1),
(285, 11, 2, '2019-08-12 15:43:30', 1),
(286, 11, 23, '2019-08-12 15:43:43', 0),
(287, 11, 11, '2019-08-12 15:43:45', 1),
(288, 11, 29, '2019-08-12 15:43:47', 0),
(289, 11, 52, '2019-08-12 15:43:53', 1),
(290, 11, 24, '2019-08-12 15:44:02', 1),
(291, 11, 12, '2019-08-12 15:44:06', 1),
(292, 11, 8, '2019-08-12 15:44:11', 1),
(293, 11, 36, '2019-08-12 15:44:41', 1),
(294, 11, 73, '2019-08-12 15:44:55', 1),
(295, 11, 62, '2019-08-22 17:45:02', 1),
(296, 11, 63, '2019-08-22 17:45:02', 1),
(297, 11, 59, '2019-08-22 17:45:22', 1),
(298, 11, 61, '2019-08-22 17:45:22', 1),
(299, 14, 7, '2019-08-22 18:15:31', 1),
(300, 14, 8, '2019-08-22 18:16:01', 1),
(301, 14, 9, '2019-08-22 18:17:44', 1),
(302, 14, 11, '2019-08-22 18:17:48', 1),
(303, 14, 12, '2019-08-22 18:17:51', 1),
(304, 14, 24, '2019-08-22 18:18:05', 1),
(305, 14, 13, '2019-08-22 18:18:20', 1),
(306, 14, 27, '2019-08-22 18:18:48', 0),
(307, 14, 36, '2019-08-22 18:18:54', 1),
(308, 14, 52, '2019-08-22 18:19:29', 0),
(309, 9, 65, '2019-08-22 18:33:15', 1),
(310, 9, 66, '2019-08-22 18:33:17', 1),
(311, 9, 67, '2019-08-22 18:33:21', 1),
(312, 9, 68, '2019-08-22 18:33:32', 1),
(313, 9, 69, '2019-08-22 18:33:34', 1),
(314, 9, 70, '2019-08-22 18:33:36', 1),
(315, 9, 71, '2019-08-22 18:33:40', 1),
(316, 9, 72, '2019-08-22 18:33:41', 1),
(317, 9, 48, '2019-08-22 18:35:22', 1),
(318, 9, 49, '2019-08-22 18:35:23', 1),
(319, 9, 50, '2019-08-22 18:35:24', 1),
(320, 9, 51, '2019-08-22 18:35:25', 1),
(321, 9, 63, '2019-08-22 18:35:35', 1),
(322, 9, 56, '2019-08-22 18:35:55', 1),
(323, 9, 57, '2019-08-22 18:35:56', 1),
(324, 9, 58, '2019-08-22 18:35:57', 1),
(325, 9, 7, '2019-08-22 18:36:09', 1),
(326, 9, 8, '2019-08-22 18:36:11', 1),
(327, 9, 9, '2019-08-22 18:36:12', 1),
(328, 9, 10, '2019-08-22 18:36:13', 1),
(329, 9, 11, '2019-08-22 18:36:26', 1),
(330, 9, 12, '2019-08-22 18:36:27', 1),
(331, 9, 13, '2019-08-22 18:36:29', 1),
(332, 9, 23, '2019-08-22 18:36:30', 0),
(333, 9, 24, '2019-08-22 18:36:34', 1),
(334, 9, 25, '2019-08-22 18:36:39', 1),
(335, 9, 26, '2019-08-22 18:36:45', 1),
(336, 9, 36, '2019-08-22 18:36:55', 1),
(337, 9, 47, '2019-08-22 18:36:57', 0),
(338, 9, 52, '2019-08-22 18:37:05', 1),
(339, 9, 73, '2019-08-22 18:37:19', 1),
(340, 9, 53, '2019-08-22 18:37:56', 1),
(341, 9, 54, '2019-08-22 18:37:57', 1),
(342, 9, 55, '2019-08-22 18:37:58', 1),
(343, 9, 1, '2019-08-22 18:38:05', 0),
(344, 9, 3, '2019-08-22 18:38:06', 1),
(345, 9, 4, '2019-08-22 18:38:08', 1),
(346, 9, 5, '2019-08-22 18:38:09', 0),
(347, 9, 6, '2019-08-22 18:38:10', 1),
(348, 9, 44, '2019-08-22 18:38:21', 1),
(349, 9, 59, '2019-08-22 18:38:32', 1),
(350, 9, 60, '2019-08-22 18:38:33', 1),
(351, 9, 61, '2019-08-22 18:38:35', 1),
(352, 8, 56, '2019-08-22 18:41:55', 1),
(353, 8, 57, '2019-08-22 18:41:56', 1),
(354, 8, 7, '2019-08-22 18:43:56', 1),
(355, 8, 8, '2019-08-22 18:43:57', 1),
(356, 8, 9, '2019-08-22 18:44:02', 1),
(357, 8, 11, '2019-08-22 18:44:05', 1),
(358, 8, 12, '2019-08-22 18:44:06', 1),
(359, 8, 13, '2019-08-22 18:44:08', 1),
(360, 8, 24, '2019-08-22 18:44:11', 1),
(361, 8, 25, '2019-08-22 18:44:16', 1),
(362, 8, 36, '2019-08-22 18:44:32', 1),
(363, 8, 47, '2019-08-22 18:44:34', 1),
(364, 8, 52, '2019-08-22 18:44:37', 1),
(365, 8, 73, '2019-08-22 18:44:41', 0),
(366, 11, 67, '2019-08-22 18:45:24', 1),
(367, 11, 9, '2019-08-22 18:45:43', 1),
(368, 11, 13, '2019-08-22 18:45:57', 1),
(369, 11, 25, '2019-08-22 18:46:02', 1),
(370, 11, 26, '2019-08-22 18:46:21', 1),
(371, 11, 4, '2019-08-22 18:46:37', 1),
(372, 11, 60, '2019-08-22 18:46:51', 1),
(373, 3, 63, '2019-08-22 18:48:35', 1),
(374, 3, 8, '2019-08-22 18:48:59', 1),
(375, 3, 25, '2019-08-22 18:49:31', 1),
(376, 3, 44, '2019-08-22 18:50:58', 1),
(377, 3, 61, '2019-08-22 18:51:05', 1),
(378, 3, 60, '2019-08-22 18:51:09', 1),
(379, 1, 74, '2019-08-28 01:11:02', 1),
(380, 1, 75, '2019-08-28 01:11:03', 1),
(381, 1, 76, '2019-08-28 01:11:04', 1),
(382, 11, 74, '2019-08-28 01:11:36', 1),
(383, 11, 75, '2019-08-28 01:11:37', 1),
(384, 11, 76, '2019-08-28 01:11:37', 1),
(385, 16, 7, '2019-09-02 14:40:09', 1),
(386, 16, 8, '2019-09-02 14:40:12', 1),
(387, 16, 12, '2019-09-02 14:40:19', 1),
(388, 16, 13, '2019-09-02 14:40:31', 1),
(389, 16, 24, '2019-09-02 14:40:41', 1),
(390, 16, 36, '2019-09-02 14:40:46', 1),
(391, 16, 9, '2019-09-02 14:55:57', 1),
(392, 16, 11, '2019-09-02 14:55:58', 1),
(393, 9, 77, '2019-09-02 15:19:50', 1),
(394, 9, 80, '2019-09-02 15:19:54', 1),
(395, 9, 78, '2019-09-02 15:19:55', 1),
(396, 9, 74, '2019-09-02 15:20:56', 1),
(397, 9, 75, '2019-09-02 15:20:58', 1),
(398, 9, 76, '2019-09-02 15:20:59', 1),
(399, 14, 59, '2019-09-02 15:24:35', 1),
(400, 1, 77, '2019-09-02 22:58:44', 1),
(401, 1, 78, '2019-09-02 22:58:45', 1),
(402, 1, 79, '2019-09-02 22:58:46', 1),
(403, 1, 80, '2019-09-02 22:58:47', 1),
(404, 1, 81, '2019-09-03 13:08:29', 1),
(405, 1, 82, '2019-09-03 13:08:29', 1),
(406, 1, 83, '2019-09-03 13:08:30', 1),
(407, 11, 81, '2019-09-03 17:17:44', 1),
(408, 11, 82, '2019-09-03 17:17:45', 1),
(409, 11, 83, '2019-09-03 17:17:45', 1),
(410, 11, 77, '2019-09-03 17:17:53', 1),
(411, 11, 78, '2019-09-03 17:17:54', 1),
(412, 11, 79, '2019-09-03 17:17:54', 1),
(413, 11, 80, '2019-09-03 17:17:55', 1),
(414, 14, 26, '2019-09-03 18:30:44', 1),
(415, 16, 26, '2019-09-03 18:32:32', 1),
(416, 17, 63, '2019-09-04 12:34:30', 1),
(417, 17, 2, '2019-09-04 12:34:49', 1),
(418, 17, 8, '2019-09-04 12:34:50', 1),
(419, 17, 24, '2019-09-04 12:34:56', 1),
(420, 17, 25, '2019-09-04 12:34:57', 1),
(421, 17, 26, '2019-09-04 12:34:58', 1),
(422, 17, 27, '2019-09-04 12:35:00', 1),
(423, 17, 36, '2019-09-04 12:35:01', 1),
(424, 17, 52, '2019-09-04 12:35:04', 1),
(425, 17, 73, '2019-09-04 12:35:05', 1),
(426, 11, 10, '2019-09-04 15:47:42', 0),
(427, 18, 7, '2019-09-18 19:02:51', 1),
(428, 18, 8, '2019-09-18 19:02:53', 1),
(429, 18, 9, '2019-09-18 19:02:54', 1),
(430, 18, 10, '2019-09-18 19:02:57', 1),
(431, 18, 11, '2019-09-18 19:03:06', 1),
(432, 18, 12, '2019-09-18 19:03:08', 1),
(433, 18, 13, '2019-09-18 19:03:11', 1),
(434, 18, 24, '2019-09-18 19:03:16', 1),
(435, 18, 26, '2019-09-18 19:03:27', 1),
(436, 18, 36, '2019-09-18 19:03:33', 1),
(437, 18, 73, '2019-09-18 19:03:38', 1),
(438, 18, 52, '2019-09-18 19:03:50', 1),
(439, 18, 59, '2019-09-18 19:04:04', 1),
(440, 18, 60, '2019-09-18 19:04:05', 1),
(441, 18, 61, '2019-09-18 19:04:07', 1),
(442, 18, 62, '2019-09-18 19:04:16', 1),
(443, 18, 63, '2019-09-18 19:04:16', 1),
(444, 1, 86, '2019-10-04 08:56:34', 1),
(445, 1, 87, '2019-10-04 11:07:42', 1),
(446, 1, 84, '2019-10-04 11:07:43', 1),
(447, 1, 85, '2019-10-04 11:07:43', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos_volar`
--

CREATE TABLE `permisos_volar` (
  `id_per` int(11) NOT NULL COMMENT 'Llave Primaria',
  `nombre_per` varchar(100) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Nombre del Permiso',
  `img_per` varchar(150) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Imagen',
  `ruta_per` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Ruta delarchivo',
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT 'Status'
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
(18, 'Catalogos', 'catalogo.png', 'vistas/catalogos/', '2019-08-07 00:12:05', 1),
(19, 'Vuelos', 'vuelos.png', 'vistas/vuelos/', '2019-08-28 01:09:54', 1),
(20, 'Hoteles', 'hotel.png', 'vistas/hoteles/', '2019-08-28 01:13:52', 1),
(21, 'Restaurantes', 'restaurante.png', 'vistas/restaurantes/', '2019-09-03 12:38:03', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `puestos_volar`
--

CREATE TABLE `puestos_volar` (
  `id_puesto` int(11) NOT NULL COMMENT 'Llave Primaria',
  `nombre_puesto` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Puesto',
  `depto_puesto` int(11) DEFAULT NULL COMMENT 'Departamento',
  `register` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` tinyint(4) DEFAULT '1' COMMENT 'Status'
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
(7, 'DIRECTOR GENERAL', 5, '2019-08-01 18:01:14', 1),
(8, 'JEFE', 2, '2019-08-01 22:47:29', 1),
(9, 'PUBLICO GENERAL', 2, '2019-08-01 22:48:23', 1),
(10, 'AGENCIAS', 2, '2019-08-01 22:48:58', 1),
(11, 'OPERADORES', 2, '2019-08-01 22:49:02', 1),
(12, 'ENCARGADA', 4, '2019-08-01 22:49:19', 1),
(13, 'VENDEDOR MINORISTA', 8, '2019-08-22 18:11:48', 1),
(14, 'VENDEDOR MAYORISTA', 8, '2019-08-22 18:12:10', 1),
(15, 'GERENTE ADMINISTRATIVO', 5, '2019-08-22 18:22:00', 1),
(16, 'GERENTE OPERACION', 5, '2019-08-22 18:22:12', 1),
(17, 'LOGISTICA 01', 7, '2019-08-22 18:29:06', 1),
(21, 'AUXILIAR', 3, '2019-09-04 12:32:24', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `relacion_permisos`
--

CREATE TABLE `relacion_permisos` (
  `id_rel` int(11) NOT NULL COMMENT 'Llave Primaria',
  `idusu_rel` int(11) NOT NULL COMMENT 'Usuario',
  `idper_rel` int(11) NOT NULL COMMENT 'Permiso',
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` smallint(6) NOT NULL DEFAULT '1' COMMENT 'Status'
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
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Status'
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
-- Estructura de tabla para la tabla `reprogramaciones_volar`
--

CREATE TABLE `reprogramaciones_volar` (
  `id_rep` int(11) NOT NULL COMMENT 'Llave Primaria',
  `idtemp_rep` int(11) NOT NULL COMMENT 'Reserva',
  `idusu_rep` int(11) NOT NULL COMMENT 'Usuario',
  `fechaa_rep` date NOT NULL COMMENT 'Fecha anterior',
  `fechan_rep` date NOT NULL COMMENT 'Fecha Nueva',
  `comentario_rep` text NOT NULL COMMENT 'Comentario',
  `motivo_rep` tinyint(4) DEFAULT NULL COMMENT 'Motivo',
  `cargo_rep` tinyint(4) NOT NULL COMMENT 'Cargo',
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Regsitro',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `reprogramaciones_volar`
--

INSERT INTO `reprogramaciones_volar` (`id_rep`, `idtemp_rep`, `idusu_rep`, `fechaa_rep`, `fechan_rep`, `comentario_rep`, `motivo_rep`, `cargo_rep`, `register`, `status`) VALUES
(1, 1250, 1, '2019-09-30', '2019-10-03', 'Algun comentario exrta alv', NULL, 0, '2019-10-04 09:05:24', 1),
(2, 1250, 1, '2019-09-30', '2019-05-09', 'Otro comentario', NULL, 0, '2019-10-04 09:23:25', 1),
(3, 1250, 1, '2019-05-09', '2019-10-02', 'sss', 1, 0, '2019-10-04 09:48:32', 1),
(4, 1250, 1, '2019-10-02', '2019-10-11', 'aaaa', 1, 0, '2019-10-04 09:51:57', 1),
(5, 1250, 1, '2019-10-11', '2019-10-17', 'asasasa', 2, 10, '2019-10-04 09:57:56', 1),
(6, 1250, 1, '2019-10-17', '2019-10-17', 'hjjjh', 1, 25, '2019-10-04 09:58:19', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `restaurantes_volar`
--

CREATE TABLE `restaurantes_volar` (
  `id_restaurant` int(11) NOT NULL COMMENT 'Llave Primaria',
  `nombre_restaurant` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Nombre',
  `hotel_restaurant` int(11) NOT NULL DEFAULT '1' COMMENT 'Hotel',
  `calle_restaurant` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Calle',
  `noint_restaurant` varchar(10) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Interior',
  `noext_restaurant` varchar(10) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'NO. Exterior',
  `colonia_restaurant` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Colonia',
  `municipio_restaurant` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Municipio',
  `estado_restaurant` int(11) NOT NULL COMMENT 'Estado',
  `cp_restaurant` int(11) NOT NULL COMMENT 'Código Postal',
  `telefono_restaurant` varchar(14) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Teléfono',
  `telefono2_restaurant` varchar(14) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Teléfono 2',
  `correo_restaurant` varchar(250) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Correo',
  `img_restaurant` varchar(250) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Imagen',
  `pagina_restaurant` varchar(250) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Pagina',
  `precion_restaurant` double(10,2) DEFAULT '0.00' COMMENT 'Precio de Niños',
  `precioa_restaurant` double(10,2) NOT NULL DEFAULT '0.00' COMMENT 'Precio de Adultos',
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Estatus'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `restaurantes_volar`
--

INSERT INTO `restaurantes_volar` (`id_restaurant`, `nombre_restaurant`, `hotel_restaurant`, `calle_restaurant`, `noint_restaurant`, `noext_restaurant`, `colonia_restaurant`, `municipio_restaurant`, `estado_restaurant`, `cp_restaurant`, `telefono_restaurant`, `telefono2_restaurant`, `correo_restaurant`, `img_restaurant`, `pagina_restaurant`, `precion_restaurant`, `precioa_restaurant`, `register`, `status`) VALUES
(3, 'Enrique', 0, 'Valentin', '1', '2', 'ANahuac', 'Izcalli', 3, 54960, '15222', '15', NULL, NULL, NULL, 22.00, 20.00, '2019-09-02 13:52:49', 0),
(4, 'aa11', 5, 'A', NULL, NULL, 'V', NULL, 17, 54800, NULL, NULL, NULL, NULL, NULL, 1.00, 2.00, '2019-09-02 13:53:42', 0),
(5, 'asa', 0, 'aa', '11', '11', '1', '1', 17, 11, '1', '1', NULL, NULL, NULL, 1.00, 1.00, '2019-09-02 13:55:26', 0),
(6, 'Enrique', 0, '1', '2', '3', '4', '5', 13, 6, '7', '8', NULL, NULL, NULL, 9.00, 0.00, '2019-09-02 13:59:21', 0),
(7, 'Prueba', 7, 'na', '', '', '', '', 11, 0, '0', '', NULL, NULL, NULL, 3.00, 3.00, '2019-09-03 09:48:11', 0),
(8, '1', 0, '', '', '', '1', '', 18, 0, '', '', NULL, NULL, NULL, 1.00, 1.00, '2019-09-03 13:18:01', 0),
(9, '150', 1, 'Ninguna', '24', NULL, 'Teotihuacan', NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, 11.00, 11.00, '2019-09-03 17:15:45', 0),
(10, 'GRAN TEOCALLI', 0, 'AUTOPISTA MEX-PIRAMIDES KM 21.5', '', '', 'SAN JUAN TEOTIHUACAN', 'SAN JUAN TEOTIHUACAN', 17, 55800, '5949563267', '', NULL, NULL, NULL, 140.00, 140.00, '2019-09-03 17:23:41', 1),
(11, 'RANCHO AZTECA', 0, 'CIRCUITO ZONA ARQUEROLOGICA ENTRE PUERTA 1 Y 2', '', '', 'PURIFICACION', 'SAN JUAN TEOTIHUACAN', 17, 55800, '5949560472', '', NULL, NULL, NULL, 140.00, 140.00, '2019-09-03 17:25:29', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicios_volar`
--

CREATE TABLE `servicios_volar` (
  `id_servicio` int(11) NOT NULL COMMENT 'Llave Primaria',
  `nombre_servicio` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Nombre',
  `precio_servicio` decimal(10,2) DEFAULT NULL COMMENT 'Precio',
  `img_servicio` varchar(100) COLLATE utf8_spanish_ci NOT NULL DEFAULT '../../img/image-not-found.gif' COMMENT 'Imagen',
  `cortesia_servicio` tinyint(4) DEFAULT '1' COMMENT 'Con Cortesia',
  `cantmax_servicio` tinyint(4) DEFAULT NULL COMMENT 'Cantidad',
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `servicios_volar`
--

INSERT INTO `servicios_volar` (`id_servicio`, `nombre_servicio`, `precio_servicio`, `img_servicio`, `cortesia_servicio`, `cantmax_servicio`, `register`, `status`) VALUES
(1, 'ROSAS (12)', '300.00', 'flores.png', 0, 0, '2019-03-31 20:21:40', 1),
(2, 'CHAMPAGNE', '1500.00', 'vino.png', 0, 0, '2019-03-31 20:22:30', 1),
(3, 'LONA PERSONALIZADA', '600.00', 'lona_personalizada.png', 0, 0, '2019-03-31 20:25:04', 1),
(4, 'Trio', '2000.00', 'trio.jpg', 1, 1, '2019-03-31 20:29:58', 0),
(5, 'DESAYUNO', '140.00', 'desayuno.png', 1, 1, '2019-03-31 20:31:16', 1),
(6, 'CENA', '350.00', 'cena.png', 1, 1, '2019-03-31 20:32:08', 1),
(7, 'FOTOS', '500.00', 'foto.jpg', 1, 0, '2019-03-31 21:33:58', 1),
(8, 'VIDEO', '500.00', 'video.png', 1, 0, '2019-03-31 21:35:45', 1),
(9, 'TEOTIHUACAN EN BICICLETA', '500.00', 'bici.png', 0, 1, '2019-03-31 21:36:20', 1),
(10, 'SPA', '1500.00', 'spa.png', 0, 1, '2019-03-31 21:37:07', 0),
(11, 'TEMAZCAL', '800.00', 'temazcal.jpg', 0, 1, '2019-03-31 21:37:26', 1),
(12, 'CUATRIMOTOS', '800.00', 'cuatrimotos.png', 0, 1, '2019-03-31 21:37:42', 1),
(13, 'ENTREMES', '450.00', 'entremes.jpeg', 0, 0, '2019-03-31 21:38:01', 1),
(14, 'TRANSPORTE REDONDO CDMX', '500.00', 'vredondo.jpg', 0, 1, '2019-03-31 21:38:32', 1),
(15, 'TRANSPORTE SENCILLO CDMX', '300.00', 'vsencillo.png', 0, 1, '2019-03-31 21:39:28', 1),
(16, 'FOTO IMPRESA', '200.00', 'fimpresa.png', 1, 0, '2019-03-31 21:39:50', 1),
(17, 'GUÃA 1 A 4', '900.00', '3pers.png', 0, 0, '2019-03-31 21:40:15', 1),
(18, 'GUÃA 5 A 20', '1500.00', '5pers.jpg', 0, 0, '2019-03-31 21:40:35', 1),
(25, 'nuevo', '50.00', '20190802004605_fondo.png', 1, 0, '2019-08-02 00:42:08', 0),
(26, 'ENTRADA ZONA ARQUEOLOGICA', '75.00', 'noimage.png', 0, 1, '2019-08-16 14:48:38', 1),
(27, 'ENTRADA ZONA ARQUEOLOGICA', '75.00', 'noimage.png', 0, 1, '2019-08-16 14:48:52', 0),
(28, 'QUITO SOL DOBLE', '1300.00', 'noimage.png', 0, 0, '2019-08-16 14:54:58', 1),
(29, 'HAB TRIPLE QTO SOL', '1450.00', 'noimage.png', 0, 0, '2019-08-16 14:55:53', 0),
(30, 'QUINTO SOL CUADRUPLE', '1650.00', 'noimage.png', 0, 0, '2019-08-16 14:56:53', 1),
(31, 'HAB CUADRUPLE QTO SOL', '1650.00', 'noimage.png', 0, 0, '2019-08-16 14:57:04', 0),
(32, 'QUINTO SOL SUITE', '1950.00', 'noimage.png', 0, 0, '2019-08-16 14:57:38', 1),
(33, 'JAGUAR DOBLE', '1450.00', 'noimage.png', 0, 0, '2019-08-16 14:59:19', 1),
(34, 'HAB TRIP BOU JAGUAR', '0.00', 'noimage.png', 0, 0, '2019-08-16 14:59:45', 0),
(35, 'JAGUAR CUADRUPLE', '1750.00', 'noimage.png', 0, 0, '2019-08-16 15:00:12', 1),
(36, 'HAB QUINTUPLE JAGUAR', '0.00', 'noimage.png', 0, 0, '2019-08-16 15:00:34', 0),
(37, 'QUINTO SOL TRIPLE', '1450.00', 'noimage.png', 0, 0, '2019-08-22 18:00:04', 1),
(38, 'VARIOS', '500.00', 'noimage.png', 0, 1, '2019-08-22 18:07:42', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicios_vuelo_temp`
--

CREATE TABLE `servicios_vuelo_temp` (
  `id_sv` int(11) NOT NULL COMMENT 'Llave Primaria',
  `idtemp_sv` int(11) DEFAULT NULL COMMENT 'Reserva',
  `idservi_sv` int(11) NOT NULL COMMENT 'Servicio',
  `tipo_sv` tinyint(4) DEFAULT '0' COMMENT 'Tipo',
  `cantidad_sv` mediumint(9) NOT NULL DEFAULT '0' COMMENT 'Cantidad',
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT '2' COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `servicios_vuelo_temp`
--

INSERT INTO `servicios_vuelo_temp` (`id_sv`, `idtemp_sv`, `idservi_sv`, `tipo_sv`, `cantidad_sv`, `register`, `status`) VALUES
(430, 1004, 2, 1, 1, '2019-07-09 17:18:44', 2),
(431, 1004, 3, 2, 1, '2019-07-09 17:18:48', 2),
(432, 1004, 9, 1, 6, '2019-07-09 17:18:58', 2),
(433, 1004, 7, 1, 1, '2019-07-09 17:19:06', 2),
(441, 1006, 9, 1, 0, '2019-07-09 17:30:26', 2),
(2476, 1002, 14, 1, 1, '2019-09-06 13:06:02', 2),
(2477, 1003, 14, 1, 1, '2019-09-06 13:19:54', 2),
(2478, 1003, 5, 1, 1, '2019-09-06 13:20:43', 2),
(2479, 1009, 3, 1, 0, '2019-09-10 16:36:27', 2),
(2480, 1009, 5, 2, 1, '2019-09-10 16:36:34', 2),
(2481, 1009, 16, 2, 2, '2019-09-10 16:37:03', 2),
(2482, 1010, 14, 1, 1, '2019-09-10 17:32:02', 0),
(2483, 1011, 14, 1, 1, '2019-09-10 18:36:07', 0),
(2484, 1012, 14, 1, 1, '2019-09-11 10:33:54', 2),
(2485, 1013, 14, 1, 1, '2019-09-11 11:19:04', 2),
(2486, 1015, 14, 1, 1, '2019-09-11 12:46:56', 2),
(2487, 1018, 12, 1, 1, '2019-09-11 14:56:53', 2),
(2488, 1019, 12, 1, 1, '2019-09-11 14:57:27', 2),
(2489, 1020, 14, 1, 1, '2019-09-11 15:38:26', 2),
(2490, 1021, 5, 1, 1, '2019-09-12 11:23:41', 2),
(2491, 1024, 5, 1, 1, '2019-09-12 12:34:28', 2),
(2492, 1024, 26, 1, 1, '2019-09-12 12:36:16', 2),
(2493, 1024, 18, 1, 15, '2019-09-12 12:36:24', 2),
(2494, 1025, 14, 1, 1, '2019-09-12 12:39:05', 2),
(2495, 1025, 5, 1, 1, '2019-09-12 12:39:16', 2),
(2496, 1026, 5, 2, 1, '2019-09-12 12:43:23', 2),
(2497, 1026, 16, 2, 2, '2019-09-12 12:43:32', 2),
(2498, 1027, 5, 1, 1, '2019-09-12 12:46:01', 2),
(2499, 1027, 14, 1, 1, '2019-09-12 12:46:04', 2),
(2500, 1029, 14, 1, 1, '2019-09-12 13:10:48', 2),
(2501, 1029, 5, 1, 0, '2019-09-12 13:11:16', 2),
(2502, 1036, 14, 1, 1, '2019-09-13 15:19:55', 2),
(2503, 1037, 5, 2, 1, '2019-09-13 15:37:16', 2),
(2504, 1037, 16, 2, 2, '2019-09-13 15:37:33', 2),
(2505, 1038, 5, 1, 1, '2019-09-13 17:07:42', 2),
(2506, 1039, 37, 2, 2, '2019-09-13 23:18:33', 2),
(2507, 1041, 1, 1, 2, '2019-09-14 11:47:14', 2),
(2508, 1042, 1, 1, 2, '2019-09-14 12:20:06', 2),
(2509, 1043, 1, 1, 2, '2019-09-14 12:38:37', 2),
(2510, 1044, 1, 1, 2, '2019-09-14 12:40:52', 2),
(2511, 1043, 7, 1, 0, '2019-09-14 12:51:39', 2),
(2512, 1048, 14, 1, 1, '2019-09-17 12:55:19', 2),
(2513, 1050, 14, 1, 1, '2019-09-17 13:27:03', 2),
(2514, 1050, 26, 1, 1, '2019-09-17 13:27:10', 2),
(2515, 1050, 17, 1, 2, '2019-09-17 13:27:27', 2),
(2516, 1051, 14, 1, 1, '2019-09-17 13:30:13', 2),
(2517, 1051, 26, 1, 1, '2019-09-17 13:30:13', 2),
(2518, 1051, 17, 1, 2, '2019-09-17 13:30:13', 2),
(2519, 1053, 5, 2, 1, '2019-09-17 13:46:45', 2),
(2520, 1053, 7, 1, 2, '2019-09-17 13:47:02', 2),
(2521, 1053, 2, 1, 2, '2019-09-17 13:47:12', 2),
(2522, 1053, 37, 1, 0, '2019-09-17 13:48:21', 2),
(2523, 1053, 28, 1, 2, '2019-09-17 13:48:27', 2),
(2524, 1054, 14, 1, 1, '2019-09-17 13:54:00', 2),
(2525, 1054, 5, 1, 1, '2019-09-17 13:55:32', 2),
(2526, 1056, 5, 1, 1, '2019-09-17 14:24:16', 2),
(2527, 1058, 5, 1, 1, '2019-09-17 14:54:48', 2),
(2528, 1058, 14, 1, 1, '2019-09-17 14:55:34', 2),
(2529, 1059, 5, 1, 1, '2019-09-17 15:00:14', 2),
(2530, 1061, 14, 1, 1, '2019-09-17 15:07:39', 2),
(2531, 1061, 5, 1, 1, '2019-09-17 15:07:39', 2),
(2533, 1063, 12, 1, 1, '2019-09-17 15:33:53', 2),
(2534, 1066, 5, 1, 1, '2019-09-17 18:31:46', 2),
(2535, 1070, 5, 1, 1, '2019-09-17 18:42:24', 2),
(2536, 1070, 14, 1, 1, '2019-09-17 18:42:28', 2),
(2537, 1071, 5, 1, 1, '2019-09-17 18:51:14', 2),
(2538, 1071, 14, 1, 1, '2019-09-17 18:51:21', 2),
(2539, 1072, 5, 2, 1, '2019-09-17 18:53:14', 2),
(2540, 1072, 7, 1, 0, '2019-09-17 18:53:14', 2),
(2541, 1072, 2, 1, 0, '2019-09-17 18:53:14', 2),
(2542, 1072, 37, 1, 0, '2019-09-17 18:53:14', 2),
(2543, 1072, 28, 1, 2, '2019-09-17 18:53:14', 2),
(2546, 1075, 5, 1, 1, '2019-09-18 11:53:06', 2),
(2547, 1076, 14, 1, 1, '2019-09-18 14:59:44', 2),
(2548, 1079, 5, 2, 1, '2019-09-18 16:35:31', 0),
(2549, 1081, 5, 1, 1, '2019-09-18 16:39:36', 2),
(2550, 1082, 5, 2, 1, '2019-09-18 16:43:13', 2),
(2551, 1083, 14, 1, 1, '2019-09-18 17:06:46', 2),
(2552, 1084, 5, 2, 1, '2019-09-18 17:09:39', 2),
(2553, 1084, 16, 2, 2, '2019-09-18 17:09:48', 2),
(2554, 1086, 14, 1, 1, '2019-09-18 17:14:54', 2),
(2555, 1087, 5, 1, 1, '2019-09-18 17:16:36', 2),
(2556, 1087, 14, 1, 0, '2019-09-18 17:16:36', 2),
(2558, 1088, 5, 1, 1, '2019-09-18 17:20:57', 2),
(2559, 1088, 14, 1, 0, '2019-09-18 17:20:57', 2),
(2561, 1080, 5, 1, 0, '2019-09-18 17:33:42', 2),
(2562, 1089, 5, 2, 1, '2019-09-18 18:01:58', 2),
(2563, 1089, 16, 2, 2, '2019-09-18 18:02:10', 2),
(2564, 1090, 5, 1, 1, '2019-09-18 18:24:00', 2),
(2565, 1092, 5, 1, 1, '2019-09-18 18:55:46', 2),
(2566, 1092, 14, 1, 1, '2019-09-18 18:55:48', 2),
(2567, 1094, 14, 1, 1, '2019-09-19 12:56:50', 2),
(2568, 1094, 5, 1, 1, '2019-09-19 12:57:15', 2),
(2569, 1095, 14, 1, 1, '2019-09-19 12:59:04', 2),
(2570, 1095, 5, 1, 1, '2019-09-19 12:59:04', 2),
(2572, 1096, 5, 1, 1, '2019-09-19 13:03:58', 2),
(2573, 1097, 14, 1, 1, '2019-09-19 13:48:54', 2),
(2574, 1101, 14, 1, 1, '2019-09-19 15:26:19', 2),
(2575, 1102, 14, 1, 1, '2019-09-19 15:47:52', 2),
(2576, 1103, 14, 1, 1, '2019-09-19 16:07:52', 2),
(2577, 1104, 14, 1, 1, '2019-09-19 18:01:35', 0),
(2578, 1107, 14, 1, 1, '2019-09-19 18:48:22', 2),
(2579, 1112, 5, 2, 1, '2019-09-20 11:05:16', 2),
(2580, 1110, 14, 1, 1, '2019-09-20 12:14:27', 2),
(2581, 1110, 5, 1, 1, '2019-09-20 12:14:35', 2),
(2582, 1112, 16, 2, 2, '2019-09-20 12:40:43', 2),
(2583, 1115, 5, 1, 1, '2019-09-20 12:48:55', 2),
(2584, 1116, 14, 1, 1, '2019-09-20 14:53:27', 2),
(2585, 1117, 5, 2, 1, '2019-09-20 15:24:03', 2),
(2586, 1121, 14, 1, 1, '2019-09-20 16:52:21', 2),
(2587, 1122, 14, 1, 1, '2019-09-20 17:00:38', 2),
(2588, 1122, 5, 1, 1, '2019-09-20 17:00:42', 2),
(2589, 1122, 17, 1, 8, '2019-09-20 17:00:51', 2),
(2590, 1122, 26, 1, 1, '2019-09-20 17:01:06', 2),
(2591, 1124, 5, 2, 1, '2019-09-20 18:09:43', 2),
(2592, 1124, 16, 2, 2, '2019-09-20 18:09:53', 2),
(2593, 1127, 14, 1, 1, '2019-09-21 12:11:26', 2),
(2594, 1127, 5, 1, 1, '2019-09-21 12:11:31', 2),
(2595, 1127, 26, 1, 1, '2019-09-21 12:11:35', 2),
(2596, 1127, 17, 1, 4, '2019-09-21 12:11:39', 2),
(2597, 1128, 14, 1, 1, '2019-09-21 12:19:50', 2),
(2598, 1129, 14, 1, 1, '2019-09-21 12:27:21', 2),
(2599, 1136, 14, 1, 1, '2019-09-23 13:52:52', 2),
(2600, 1137, 5, 1, 1, '2019-09-23 13:58:30', 2),
(2601, 1137, 14, 1, 1, '2019-09-23 13:59:16', 2),
(2602, 1138, 5, 1, 1, '2019-09-23 14:21:03', 2),
(2603, 1138, 14, 1, 1, '2019-09-23 14:21:12', 2),
(2604, 1140, 5, 2, 1, '2019-09-23 18:15:11', 2),
(2605, 1140, 16, 2, 2, '2019-09-23 18:15:20', 2),
(2606, 1140, 17, 1, 2, '2019-09-23 18:15:44', 2),
(2607, 1140, 14, 1, 1, '2019-09-23 18:15:47', 2),
(2608, 1141, 14, 1, 1, '2019-09-23 18:18:12', 2),
(2609, 1141, 17, 1, 2, '2019-09-23 18:36:15', 2),
(2610, 1141, 26, 1, 1, '2019-09-23 18:36:47', 2),
(2611, 1142, 14, 1, 1, '2019-09-23 18:38:48', 2),
(2612, 1142, 17, 1, 2, '2019-09-23 18:38:48', 2),
(2613, 1142, 26, 1, 1, '2019-09-23 18:38:48', 2),
(2614, 1147, 5, 2, 1, '2019-09-24 12:38:25', 2),
(2615, 1147, 16, 2, 2, '2019-09-24 12:38:39', 2),
(2616, 1147, 1, 1, 2, '2019-09-24 12:38:49', 2),
(2617, 1148, 5, 2, 1, '2019-09-24 12:42:23', 2),
(2618, 1149, 14, 1, 1, '2019-09-24 12:51:26', 2),
(2619, 1151, 5, 2, 1, '2019-09-24 13:22:06', 2),
(2620, 1151, 16, 2, 4, '2019-09-24 13:22:13', 2),
(2621, 1154, 14, 1, 1, '2019-09-24 17:24:53', 2),
(2622, 1155, 5, 1, 1, '2019-09-24 17:42:46', 2),
(2623, 1156, 5, 1, 1, '2019-09-24 18:21:48', 2),
(2624, 1157, 5, 2, 1, '2019-09-24 18:29:32', 2),
(2625, 1157, 28, 1, 2, '2019-09-24 18:29:39', 2),
(2626, 1157, 16, 2, 2, '2019-09-24 18:29:42', 2),
(2627, 1157, 1, 1, 2, '2019-09-24 18:29:51', 2),
(2628, 1157, 2, 1, 2, '2019-09-24 18:29:52', 2),
(2629, 1158, 5, 2, 1, '2019-09-25 13:00:53', 2),
(2630, 1158, 16, 2, 2, '2019-09-25 13:01:00', 2),
(2631, 1158, 7, 1, 2, '2019-09-25 13:03:10', 2),
(2632, 1159, 14, 1, 1, '2019-09-25 13:07:03', 2),
(2633, 1160, 5, 1, 1, '2019-09-25 14:02:30', 2),
(2634, 1161, 14, 1, 1, '2019-09-25 14:37:41', 2),
(2635, 1162, 5, 1, 1, '2019-09-25 15:08:12', 2),
(2636, 1164, 5, 1, 1, '2019-09-25 15:58:46', 2),
(2637, 1164, 14, 1, 1, '2019-09-25 15:58:56', 2),
(2638, 1173, 17, 1, 0, '2019-09-26 01:35:11', 2),
(2639, 1173, 11, 1, 0, '2019-09-26 01:35:12', 2),
(2640, 1173, 9, 1, 0, '2019-09-26 01:35:13', 2),
(2641, 1174, 17, 1, 0, '2019-09-26 01:38:12', 2),
(2642, 1174, 11, 1, 0, '2019-09-26 01:38:12', 2),
(2643, 1174, 9, 1, 0, '2019-09-26 01:38:12', 2),
(2644, 1175, 17, 1, 0, '2019-09-26 01:38:33', 2),
(2645, 1175, 11, 1, 0, '2019-09-26 01:38:33', 2),
(2646, 1175, 9, 1, 0, '2019-09-26 01:38:33', 2),
(2647, 1171, 14, 1, 1, '2019-09-26 11:33:41', 2),
(2648, 1172, 16, 1, 8, '2019-09-26 12:31:35', 2),
(2649, 1175, 17, 1, 0, '2019-09-26 12:46:26', 2),
(2650, 1175, 11, 1, 0, '2019-09-26 12:46:26', 2),
(2651, 1175, 9, 1, 0, '2019-09-26 12:46:26', 2),
(2652, 1176, 16, 1, 8, '2019-09-26 12:48:27', 2),
(2653, 1177, 17, 1, 0, '2019-09-26 12:58:54', 2),
(2654, 1177, 11, 1, 0, '2019-09-26 12:58:54', 2),
(2655, 1177, 9, 1, 0, '2019-09-26 12:58:54', 2),
(2656, 1178, 17, 1, 0, '2019-09-26 14:03:11', 2),
(2657, 1178, 11, 1, 0, '2019-09-26 14:03:11', 2),
(2658, 1178, 9, 1, 0, '2019-09-26 14:03:11', 2),
(2659, 1179, 14, 1, 1, '2019-09-26 15:15:37', 2),
(2660, 1179, 26, 1, 1, '2019-09-26 15:15:40', 2),
(2661, 1179, 17, 1, 7, '2019-09-26 15:15:44', 2),
(2662, 1179, 5, 1, 1, '2019-09-26 15:15:48', 2),
(2663, 1181, 5, 1, 1, '2019-09-26 16:46:29', 2),
(2664, 1181, 14, 1, 1, '2019-09-26 16:46:34', 2),
(2665, 1181, 18, 1, 0, '2019-09-26 16:46:37', 2),
(2666, 1181, 17, 1, 4, '2019-09-26 16:46:40', 2),
(2667, 1181, 26, 1, 1, '2019-09-26 16:46:43', 2),
(2668, 1182, 14, 1, 1, '2019-09-26 16:56:09', 2),
(2669, 1183, 5, 1, 1, '2019-09-26 17:18:01', 2),
(2670, 1183, 14, 1, 1, '2019-09-26 17:18:04', 2),
(2671, 1183, 26, 1, 1, '2019-09-26 17:18:08', 2),
(2672, 1183, 17, 1, 4, '2019-09-26 17:18:12', 2),
(2673, 1184, 5, 1, 1, '2019-09-26 17:25:05', 2),
(2674, 1184, 14, 1, 1, '2019-09-26 17:25:08', 2),
(2675, 1184, 26, 1, 1, '2019-09-26 17:25:10', 2),
(2676, 1184, 17, 1, 7, '2019-09-26 17:25:13', 2),
(2677, 1185, 14, 1, 1, '2019-09-26 17:29:39', 2),
(2678, 1189, 5, 1, 1, '2019-09-26 18:38:29', 2),
(2679, 1190, 14, 1, 1, '2019-09-26 18:40:21', 2),
(2680, 1192, 5, 1, 1, '2019-09-26 19:00:25', 2),
(2681, 1191, 14, 1, 1, '2019-09-26 19:01:20', 2),
(2682, 1193, 5, 1, 1, '2019-09-26 19:04:12', 2),
(2683, 1196, 5, 1, 1, '2019-09-26 20:01:32', 2),
(2684, 1198, 14, 1, 1, '2019-09-27 11:09:31', 2),
(2685, 1199, 14, 1, 1, '2019-09-27 11:12:30', 2),
(2686, 1205, 5, 2, 1, '2019-09-27 12:31:52', 2),
(2687, 1205, 16, 2, 2, '2019-09-27 12:31:56', 2),
(2688, 1206, 5, 2, 1, '2019-09-27 12:37:29', 2),
(2689, 1206, 16, 2, 2, '2019-09-27 12:37:31', 2),
(2690, 1206, 14, 1, 1, '2019-09-27 12:37:51', 2),
(2691, 1209, 14, 1, 1, '2019-09-27 12:49:56', 2),
(2692, 1209, 5, 1, 1, '2019-09-27 12:50:41', 2),
(2693, 1210, 14, 1, 1, '2019-09-27 13:05:39', 2),
(2694, 1213, 5, 2, 1, '2019-09-27 15:35:52', 2),
(2695, 1213, 16, 2, 2, '2019-09-27 15:35:52', 2),
(2697, 1214, 5, 1, 1, '2019-09-27 18:00:55', 2),
(2698, 1214, 14, 1, 1, '2019-09-27 18:00:57', 2),
(2699, 1214, 17, 1, 5, '2019-09-27 18:01:01', 2),
(2700, 1214, 26, 1, 1, '2019-09-27 18:01:03', 2),
(2701, 1215, 14, 1, 1, '2019-09-27 18:47:32', 2),
(2702, 1216, 14, 1, 1, '2019-09-27 18:55:12', 2),
(2703, 1217, 5, 1, 1, '2019-09-27 18:59:28', 2),
(2704, 1217, 14, 1, 1, '2019-09-27 18:59:30', 2),
(2705, 1217, 17, 1, 2, '2019-09-27 18:59:33', 2),
(2706, 1217, 26, 1, 1, '2019-09-27 18:59:34', 2),
(2707, 1218, 5, 1, 1, '2019-09-27 19:04:02', 2),
(2708, 1220, 15, 1, 0, '2019-09-30 12:51:33', 2),
(2709, 1220, 14, 1, 1, '2019-09-30 12:51:39', 2),
(2710, 1220, 18, 1, 0, '2019-09-30 12:51:43', 2),
(2711, 1220, 17, 1, 2, '2019-09-30 12:51:45', 2),
(2712, 1220, 26, 1, 1, '2019-09-30 12:51:55', 2),
(2713, 1222, 5, 1, 1, '2019-09-30 14:06:46', 2),
(2714, 1223, 5, 1, 1, '2019-09-30 14:20:06', 2),
(2715, 1223, 14, 1, 1, '2019-09-30 14:20:09', 2),
(2716, 1226, 5, 1, 1, '2019-09-30 17:33:31', 0),
(2717, 1226, 14, 1, 1, '2019-09-30 17:33:31', 0),
(2718, 1226, 17, 1, 5, '2019-09-30 17:33:31', 0),
(2719, 1226, 26, 1, 1, '2019-09-30 17:33:31', 0),
(2723, 1227, 5, 1, 1, '2019-09-30 17:36:55', 0),
(2724, 1227, 14, 1, 1, '2019-09-30 17:36:55', 0),
(2725, 1227, 17, 1, 5, '2019-09-30 17:36:55', 0),
(2726, 1227, 26, 1, 1, '2019-09-30 17:36:55', 0),
(2730, 1228, 5, 1, 1, '2019-09-30 17:45:12', 2),
(2731, 1228, 14, 1, 0, '2019-09-30 17:45:18', 2),
(2732, 1228, 17, 1, 2, '2019-09-30 17:45:26', 2),
(2733, 1228, 26, 1, 1, '2019-09-30 17:45:28', 2),
(2734, 1229, 5, 1, 1, '2019-09-30 17:47:59', 2),
(2735, 1229, 14, 1, 1, '2019-09-30 17:48:01', 2),
(2736, 1229, 26, 1, 1, '2019-09-30 17:48:02', 2),
(2737, 1229, 17, 1, 5, '2019-09-30 17:48:04', 2),
(2738, 1230, 14, 1, 1, '2019-09-30 18:42:10', 2),
(2739, 1232, 14, 1, 1, '2019-09-30 18:45:49', 2),
(2740, 1233, 5, 1, 1, '2019-09-30 19:05:15', 2),
(2741, 1233, 14, 1, 1, '2019-09-30 19:05:15', 2),
(2742, 1233, 17, 1, 2, '2019-09-30 19:05:15', 2),
(2743, 1233, 26, 1, 1, '2019-09-30 19:05:15', 2),
(2744, 1234, 5, 1, 1, '2019-10-01 14:16:37', 2),
(2745, 1234, 14, 1, 1, '2019-10-01 14:16:37', 2),
(2747, 1235, 5, 2, 1, '2019-10-01 14:27:25', 2),
(2748, 1235, 16, 2, 2, '2019-10-01 14:27:46', 2),
(2749, 1239, 5, 1, 1, '2019-10-02 14:41:12', 2),
(2750, 1240, 5, 1, 1, '2019-10-02 15:02:48', 2),
(2751, 1242, 5, 1, 1, '2019-10-02 17:14:30', 2),
(2752, 1243, 14, 1, 1, '2019-10-02 17:18:24', 2),
(2753, 1243, 5, 1, 1, '2019-10-02 17:18:26', 2),
(2754, 1249, 5, 1, 1, '2019-10-03 11:24:57', 2),
(2755, 1250, 5, 2, 1, '2019-10-04 08:56:47', 2),
(2756, 1250, 16, 2, 2, '2019-10-04 08:56:47', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subpermisos_volar`
--

CREATE TABLE `subpermisos_volar` (
  `id_sp` int(11) NOT NULL COMMENT 'Llave Primaria',
  `nombre_sp` varchar(50) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Permiso',
  `permiso_sp` int(11) NOT NULL COMMENT 'Modulo',
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `subpermisos_volar`
--

INSERT INTO `subpermisos_volar` (`id_sp`, `nombre_sp`, `permiso_sp`, `register`, `status`) VALUES
(1, 'AGREGAR', 8, '2019-04-10 15:37:07', 1),
(2, 'CONCILIAR', 2, '2019-04-10 15:47:56', 1),
(3, 'PERMISOS', 8, '2019-04-10 16:36:49', 1),
(4, 'VER', 8, '2019-04-10 16:36:49', 0),
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
(27, 'CAMBIOS', 2, '2019-04-11 20:42:25', 0),
(29, 'ELIMINAR GRL', 2, '2019-04-15 09:19:54', 1),
(36, 'REPORTES', 2, '2019-05-12 15:25:57', 1),
(44, 'NOMINA', 8, '2019-05-19 22:03:04', 0),
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
(60, 'REPORTES', 16, '2019-08-05 07:21:26', 0),
(61, 'VER', 16, '2019-08-06 21:14:33', 1),
(62, 'AGREGAR', 17, '2019-08-06 22:29:40', 1),
(63, 'VER', 17, '2019-08-06 22:29:40', 1),
(64, 'ESTADOS', 18, '2019-08-07 00:18:30', 1),
(65, 'MOTIVOS', 18, '2019-08-07 00:18:30', 1),
(66, 'TIPOS VUELO', 18, '2019-08-07 00:18:30', 1),
(67, 'TARIFAS', 18, '2019-08-07 00:18:30', 0),
(68, 'METODOS PAGO', 18, '2019-08-07 00:18:30', 1),
(69, 'CUENTAS BANCOS', 18, '2019-08-07 00:18:30', 1),
(70, 'TIPOS GASTOS', 18, '2019-08-07 00:18:30', 1),
(71, 'EDITAR', 18, '2019-08-08 11:33:36', 1),
(72, 'ELIMINAR', 18, '2019-08-08 11:33:36', 1),
(73, 'PAGO SITIO', 2, '2019-08-08 13:50:59', 1),
(74, 'AGREGAR', 19, '2019-08-28 01:10:22', 1),
(75, 'EDITAR', 19, '2019-08-28 01:10:22', 1),
(76, 'ELIMINAR', 19, '2019-08-28 01:10:22', 1),
(77, 'AGREGAR', 20, '2019-08-28 01:14:49', 1),
(78, 'EDITAR', 20, '2019-08-28 01:14:49', 1),
(79, 'ELIMINAR', 20, '2019-08-28 01:14:49', 1),
(80, 'HABITACIONES', 20, '2019-08-28 01:14:49', 1),
(81, 'AGREGAR', 21, '2019-09-03 12:38:36', 1),
(82, 'EDITAR', 21, '2019-09-03 12:38:36', 1),
(83, 'ELIMINAR', 21, '2019-09-03 12:38:36', 1),
(84, 'COMENTARIO', 2, '2019-10-01 18:57:27', 1),
(85, 'COMENTARIO GRAL', 2, '2019-10-01 18:57:27', 1),
(86, 'REPROGRAMAR', 2, '2019-10-01 18:59:08', 1),
(87, 'REPROGRAMAR GRAL', 2, '2019-10-01 18:59:08', 1);

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
  `pasajerosn_temp` int(11) DEFAULT '0' COMMENT 'Pasajeros Niños',
  `motivo_temp` tinyint(4) DEFAULT NULL COMMENT 'Motivo',
  `tipo_temp` tinyint(4) DEFAULT NULL COMMENT 'Tipo',
  `fechavuelo_temp` date DEFAULT NULL COMMENT 'Fecha de Vuelo',
  `tarifa_temp` tinyint(4) DEFAULT NULL COMMENT 'Tipo de Tarifa',
  `hotel_temp` tinyint(4) DEFAULT NULL COMMENT 'Hotel',
  `habitacion_temp` tinyint(4) DEFAULT NULL COMMENT 'Habitación',
  `checkin_temp` date DEFAULT NULL COMMENT 'Check In',
  `checkout_temp` date DEFAULT NULL COMMENT 'Check Out',
  `comentario_temp` mediumtext COLLATE utf8_spanish_ci COMMENT 'Comentarios',
  `otroscar1_temp` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Otros Cargos',
  `precio1_temp` decimal(11,2) DEFAULT NULL COMMENT 'Precio',
  `otroscar2_temp` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Otros CArgos',
  `precio2_temp` decimal(11,2) DEFAULT NULL COMMENT 'Precio',
  `tdescuento_temp` tinyint(4) DEFAULT NULL COMMENT 'Tipo de Descuento',
  `cantdescuento_temp` decimal(8,2) NOT NULL DEFAULT '0.00' COMMENT 'Cantidad de Desuento',
  `total_temp` double(10,2) DEFAULT '0.00' COMMENT 'Total',
  `piloto_temp` int(11) DEFAULT '0' COMMENT 'Piloto',
  `kg_temp` decimal(10,2) DEFAULT '0.00' COMMENT 'Peso',
  `tipopeso_temp` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Tipo Peso',
  `globo_temp` int(11) DEFAULT '0' COMMENT 'Globo',
  `hora_temp` time DEFAULT NULL COMMENT 'Hora de Vuelo',
  `idioma_temp` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Idioma',
  `comentarioint_temp` text COLLATE utf8_spanish_ci COMMENT 'Comentarios Internos',
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT '2' COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Tabla Temporal' ROW_FORMAT=COMPACT;

--
-- Volcado de datos para la tabla `temp_volar`
--

INSERT INTO `temp_volar` (`id_temp`, `idusu_temp`, `clave_temp`, `nombre_temp`, `apellidos_temp`, `mail_temp`, `telfijo_temp`, `telcelular_temp`, `procedencia_temp`, `pasajerosa_temp`, `pasajerosn_temp`, `motivo_temp`, `tipo_temp`, `fechavuelo_temp`, `tarifa_temp`, `hotel_temp`, `habitacion_temp`, `checkin_temp`, `checkout_temp`, `comentario_temp`, `otroscar1_temp`, `precio1_temp`, `otroscar2_temp`, `precio2_temp`, `tdescuento_temp`, `cantdescuento_temp`, `total_temp`, `piloto_temp`, `kg_temp`, `tipopeso_temp`, `globo_temp`, `hora_temp`, `idioma_temp`, `comentarioint_temp`, `register`, `status`) VALUES
(1001, 16, NULL, 'NICOLE', 'LANIADO', 'sergio@volarenglobo.com.mx', NULL, '6178525539', 35, 4, 0, 36, 1, '2019-09-07', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, NULL, '0.00', 9200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-06 12:23:40', 8),
(1002, 16, NULL, 'PATRICIA', 'BARAHONA', 'sergio@volarenglobo.com.mx', NULL, '50487792824', 35, 2, 0, 36, 1, '2019-10-04', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, NULL, '0.00', 5600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-06 13:05:03', 8),
(1003, 16, NULL, 'ANA', 'ACUÃ‘A', 'anaacun1190@hotmail.com', NULL, '573107647968', 35, 3, 0, 36, 1, '2019-09-09', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, 2, '3.00', 8817.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-06 13:18:44', 8),
(1004, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-06 13:30:18', 0),
(1005, 16, NULL, 'EDSON', 'CONTRERAS', 'edconher@yahoo.com.mx', NULL, '6241785337', NULL, 2, 0, 38, 4, '2019-09-27', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la a', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '140.00', 1, 0, NULL, 1, NULL, '2019-09-09 11:37:39', 7),
(1006, 16, NULL, 'KELLY', 'PEREZ', 'kelly.perez@live.com', NULL, '573002084689', 35, 2, 0, 36, 1, '2019-09-18', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-09 15:24:23', 3),
(1007, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-10 15:48:18', 0),
(1008, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-10 16:34:27', 0),
(1009, 14, NULL, 'FLOR', 'GONZALEZ', 'sergio@volarenglobo.com.mx', NULL, '50671056755', 35, 2, 0, 37, 4, '2019-11-29', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD,DESPLIEGUE DE LONA', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-10 16:34:46', 3),
(1010, 11, NULL, 'LUIS', 'LEONARDO', 'luis@dominicanballoons.com', NULL, '18099778877', 35, 1, 0, 36, 1, '2019-09-12', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS, \nCOFFEE BREAK, \nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET, \nCERTIFICADO DE VUELO, \nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD, \nTRANSPORTE DESDE HOTEL DEL ANGEL CDMX IDA Y VUELTA\nCORTESIA SRG', NULL, NULL, NULL, NULL, 2, '2799.00', 1.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-10 17:30:26', 6),
(1011, 11, '1010', 'LUIS', 'LEONARDO', 'luis@dominicanballoons.com', NULL, '18099778877', 35, 1, 0, 36, 1, '2019-09-12', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS, \nCOFFEE BREAK, \nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET, \nCERTIFICADO DE VUELO, \nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD, \nTRANSPORTE DESDE HOTEL DEL ANGEL CDMX IDA Y VUELTA\nCORTESIA SRG', NULL, NULL, NULL, NULL, 2, '2799.00', 1.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-10 18:36:07', 4),
(1012, 14, NULL, 'ENRIQUE', 'NAVARRO', 'sergio@volarenglobo.com.mx', NULL, '50660044026', 35, 4, 0, 37, 1, '2019-09-21', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLI', NULL, NULL, NULL, NULL, NULL, '0.00', 11200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-11 10:32:55', 8),
(1013, 14, NULL, 'EDSON', 'MANDUJANO', 'sergio@volarenglobo.com.mx', NULL, '51984710551', 35, 2, 0, NULL, 1, '2019-09-26', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BEAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PESONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD,DESPLIEGUE DE LONA .', NULL, NULL, NULL, NULL, NULL, '0.00', 5600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-11 11:16:49', 6),
(1014, 16, NULL, 'JUAN MANUEL', 'HUMENIUK', 'jumeniuk@gmail.com', NULL, '6241767880', 17, 2, 0, 38, 4, '2019-09-12', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la a', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-11 12:16:47', 6),
(1015, 16, '1014', 'JUAN MANUEL', 'HUMENIUK', 'jumeniuk@gmail.com', NULL, '6241767880', 17, 2, 0, 38, 4, '2019-09-12', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la a', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-11 12:46:44', 8),
(1016, 16, NULL, 'JESSICA', 'MONDRAGON', 'jessi.juan.09@gmail.com', NULL, '5611880089', NULL, 2, 0, 37, 4, '2019-09-12', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la a', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-11 13:13:16', 6),
(1017, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-11 14:37:52', 0),
(1018, 16, '1016', 'JESSICA', 'MONDRAGON', 'jessi.juan.09@gmail.com', NULL, '5611880089', NULL, 2, 0, 37, 4, '2019-09-12', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la a', NULL, NULL, NULL, NULL, NULL, '0.00', 8600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-11 14:56:48', 6),
(1019, 16, '1018', 'JESSICA', 'MONDRAGON', 'jessi.juan.09@gmail.com', NULL, '5611880089', NULL, 2, 0, 37, 4, '2019-09-12', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la a', NULL, NULL, NULL, NULL, NULL, '0.00', 8600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-11 14:57:27', 8),
(1020, 14, NULL, 'SALVADOR ', 'HERNANDEZ', 'sergio@volarenglobo.com.mx', NULL, '5547072447', 35, 2, 0, 36, 1, '2019-09-14', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL, DESPLIEGUE DE LONA , TRANSPORT', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-11 15:36:22', 3),
(1021, 16, NULL, 'ISRAEL', 'GARCIA', 'toloigg@gmail.com', NULL, '5524303380', NULL, 2, 0, 36, 1, '2019-09-14', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 11:22:58', 3),
(1022, 14, NULL, 'CAROLINA', 'PEÃ‘A', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 12:27:44', 0),
(1023, 14, NULL, 'CLAUDIA', 'YOC', 'volarenglobo@yahoo.es', NULL, '50242100449', 35, 3, 0, 36, 1, '2019-09-15', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD,DESPLIEGUE DE LON', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 7197.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 12:29:05', 3),
(1024, 14, NULL, 'CECILIA', 'VAZQUEZ', 'volarenglobo@yahoo.es', NULL, '5512386502', 11, 15, 0, 36, 1, '2019-10-18', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 15 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD,DESPLIEGUE DE LO', NULL, NULL, NULL, NULL, 2, '4500.00', 34725.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 12:33:44', 3),
(1025, 14, NULL, 'LISSETTE', 'PERDOMO', 'volarenglobo@yahoo.es', NULL, '50255899206', 35, 3, 0, 36, 1, '2019-09-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE LOCAL, DESAYUNO BUFFET EN RESTAURANTE G', NULL, NULL, NULL, NULL, 2, '900.00', 7920.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 12:38:10', 4),
(1026, 14, NULL, 'YURIANA', 'QUERO', 'volarenglobo@yahoo.es', NULL, '5580056993', 11, 2, 0, 36, 4, '2019-09-30', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE LOCAL,SEGURO DE VIAJERO,BRINDIS CON VINO ', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 12:42:32', 6),
(1027, 16, NULL, 'RODRIGO', 'NOVELO', 'ronovelo2003@hotmail.com', NULL, '9811600715', NULL, 2, 0, NULL, 1, '2019-10-06', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, 2, '82.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 12:45:02', 8),
(1028, 16, NULL, 'LUISA FERNANDA', 'CANO', 'cotizacionesgirardottravel@gmail.com', NULL, '3204583383', NULL, 2, 0, NULL, 1, '2019-11-27', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 12:57:17', 3),
(1029, 16, NULL, 'GABRIEL', 'NUÃ‘EZ', 'lgnp3108@hotmail.com', NULL, '9931343692', NULL, 2, 0, 36, 1, '2019-09-14', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, NULL, '0.00', 5600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 13:09:31', 8),
(1030, 16, NULL, 'BERENICE', 'LOPEZ', 'moon_sun44@hotmail.com', NULL, '5525245058', NULL, 2, 0, 36, 1, '2019-09-16', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 13:41:53', 6),
(1031, 16, '1030', 'BERENICE', 'LOPEZ', 'moon_sun44@hotmail.com', NULL, '5525245058', NULL, 2, 0, 36, 1, '2019-09-16', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', 'DESAYUNO 3 PAX', '420.00', NULL, NULL, NULL, '0.00', 5020.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 13:56:54', 8),
(1032, 14, NULL, 'ERIKA', 'HURTADO', 'volarenglobo@yahoo.es', NULL, '4423419752', 11, 3, 0, 36, 1, '2019-09-15', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO,TRANSPORTE LOCAL , DESAYUNO BUFFET EN RESTAURA', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 7197.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 14:31:05', 8),
(1033, 16, NULL, 'CINDY', 'OVIEDO', 'cindy.oviedoo@hotmail.com', NULL, '8123504916', NULL, 2, 0, 36, 4, '2019-09-15', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la a', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-13 13:11:09', 6),
(1034, 16, '1033', 'CINDY', 'OVIEDO', 'cindy.oviedoo@hotmail.com', NULL, '8123504916', NULL, 2, 0, 36, 4, '2019-09-14', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la a', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-13 14:42:13', 8),
(1035, 16, NULL, 'ALEJANDRA', 'VACA', 'alejandra_vaca81@hotmail.com', NULL, '5530456145', NULL, 2, 0, 37, 1, '2019-09-20', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-13 14:55:31', 6),
(1036, 14, NULL, 'KARLA', 'MORALES', 'volarenglobo@yahoo.es', NULL, '50248731711', 35, 2, 0, 36, 1, '2019-10-11', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS  APROX. INCLUYE COFFE BREAK (CAFE,TE,GALLETAS  Y PAN) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO,TRANSP LOCAL , DESPLIEGUE DE LONA', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-13 15:17:26', 4),
(1037, 14, NULL, 'ARMANDO DE JESUS', 'ROJAS', 'volarenglobo@yahoo.es', NULL, '5613654574', 35, 2, 0, 38, 4, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE L', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-13 15:22:08', 3),
(1038, 14, NULL, 'GUILLERMO', 'MARROQUIN', 'volarenglobo@yahoo.es', NULL, '573002515160', 35, 2, 0, 38, 1, '2019-09-16', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLI', NULL, NULL, NULL, NULL, 2, '600.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-13 17:07:00', 8),
(1039, 11, NULL, 'IVAN', 'APARICIO SOLIS', 'sanvid90@gmail.com', NULL, '5540934897', 11, 2, 0, 36, 1, '2019-09-15', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD\n', NULL, NULL, NULL, NULL, 2, '1000.00', 3600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-13 23:16:25', 7),
(1040, 16, NULL, 'JOSE EDUARDO', 'RAMIREZ', 'ramieduardo97@gmail.com', NULL, '5547649558', NULL, 2, 0, 37, 4, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la a', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-14 11:38:38', 6),
(1041, 16, '1040', 'JOSE EDUARDO', 'RAMIREZ', 'ramieduardo97@gmail.com', NULL, '5547649558', NULL, 2, 0, 45, 4, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet \nâ€¢	TransportaciÃ³n local \nâ€¢	Lona desplegable con la leyenda Â¡Te Amo!\nâ', NULL, NULL, NULL, NULL, NULL, '0.00', 7300.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-14 11:47:03', 6),
(1042, 16, '1041', 'JOSE EDUARDO', 'RAMIREZ', 'ramieduardo97@gmail.com', NULL, '5547649558', NULL, 2, 0, 45, 4, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet \nâ€¢	TransportaciÃ³n local \nâ€¢	Lona desplegable con la leyenda Â¡Te Amo!\nâ', NULL, NULL, NULL, NULL, NULL, '0.00', 7300.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-14 12:20:06', 6),
(1043, 16, '1042', 'JOSE EDUARDO', 'RAMIREZ', 'ramieduardo97@gmail.com', NULL, '5547649558', NULL, 2, 0, 45, 4, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet \nâ€¢	TransportaciÃ³n local \nâ€¢	Lona desplegable con la leyenda Â¡Te Amo!\nâ', NULL, NULL, NULL, NULL, NULL, '0.00', 7300.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-14 12:38:37', 6),
(1044, 16, '1043', 'JOSE EDUARDO', 'RAMIREZ', 'ramieduardo97@gmail.com', NULL, '5547649558', NULL, 2, 0, 45, 4, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet \nâ€¢	TransportaciÃ³n local \nâ€¢	Lona desplegable con la leyenda Â¡Te Amo!\nâ', NULL, NULL, NULL, NULL, NULL, '0.00', 7300.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-14 12:40:52', 8),
(1045, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 12:26:50', 0),
(1046, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 12:27:38', 0),
(1047, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 12:46:56', 0),
(1048, 14, '1013', 'EDSON', 'MANDUJANO', 'sergio@volarenglobo.com.mx', NULL, '51984710551', 35, 2, 0, NULL, 1, '2019-09-26', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BEAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PESONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD,DESPLIEGUE DE LONA .', NULL, NULL, NULL, NULL, NULL, '0.00', 5600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 12:55:19', 3),
(1049, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 13:24:25', 0),
(1050, 14, NULL, 'EDSON', 'MANDUJANO', 'volarenglobo@yahoo.es', NULL, '51984710551', 35, 2, 0, 36, 1, '2019-09-26', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PESONALIZADO,TRANSP LOCAL,DESAYUNO BUFFET', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 6848.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 13:25:52', 6),
(1051, 14, '1050', 'EDSON', 'MANDUJANO', 'volarenglobo@yahoo.es', NULL, '51984710551', 35, 2, 0, 36, 1, '2019-09-26', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PESONALIZADO,TRANSP LOCAL,DESAYUNO BUFFET', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 6848.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 13:30:13', 7),
(1052, 16, '1035', 'ALEJANDRA', 'VACA', 'alejandra_vaca81@hotmail.com', NULL, '5530456145', NULL, 2, 0, 37, 1, '2019-09-20', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 13:42:28', 8),
(1053, 14, NULL, 'CHRISTIAN', 'MORALES', 'volarenglobo@yahoo.es', NULL, '5534594283', 11, 2, 0, 37, 4, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE L', 'VIP', '500.00', NULL, NULL, NULL, '0.00', 10800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 13:45:35', 6),
(1054, 14, NULL, 'CAMILO', 'PEREZ', 'volarenglobo@yahoo.es', NULL, '573016588684', 35, 7, 0, 36, 1, '2019-10-18', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, 2, '2100.00', 18480.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 13:52:24', 6),
(1055, 14, NULL, 'JENNIFER', 'PAULINO', 'volarenglobo@yahoo.es', NULL, '13477523690', 35, 6, 0, 36, 1, '2019-09-22', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYU', 'DESAYUNOS', '594.00', NULL, NULL, NULL, '0.00', 14394.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 14:16:09', 6),
(1056, 14, NULL, 'CLAUDIA', 'PERDOMO', 'volarenglobo@yahoo.es', NULL, '573007386751', 11, 2, 0, 36, 1, '2019-10-18', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, 2, '600.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 14:22:20', 6),
(1057, 14, '1055', 'JENNIFER', 'PAULINO', 'volarenglobo@yahoo.es', NULL, '13477523690', 35, 6, 0, 36, 1, '2019-09-22', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 6 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYU', 'DESAYUNOS', '594.00', NULL, NULL, NULL, '0.00', 14394.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 14:30:02', 8),
(1058, 14, NULL, 'FUSHION', 'LAY', 'volarenglobo@yahoo.es', NULL, '573160732', 35, 2, 0, 36, 1, '2019-09-24', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYU', NULL, NULL, NULL, NULL, 2, '600.00', 5280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 14:52:41', 6),
(1059, 16, NULL, 'JULIO CESAR', 'FUENTES', 'jcesar_fuentes30@hotmail.com', NULL, '5555068445', NULL, 2, 0, 38, 1, '2019-09-21', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 14:58:21', 8),
(1060, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 15:02:36', 0),
(1061, 14, '1054', 'CAMILO', 'PEREZ', 'volarenglobo@yahoo.es', '573016588684', '573016588684', 35, 7, 0, 36, 1, '2019-10-18', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 7 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, 2, '2100.00', 18480.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 15:07:39', 8),
(1062, 14, NULL, 'MARIO', 'GALVEZ', 'volarenglobo@yahoo.es', NULL, '6462941697', 35, 2, 0, 36, 1, '2019-09-22', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYU', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 15:22:33', 3),
(1063, 14, NULL, 'DAVID', 'GUADARRAMA', 'volarenglobo@yahoo.es', NULL, '6462941697', 35, 2, 0, 36, 1, '2019-09-22', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 42PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', 'TRANSPORTE ZOCALO', '700.00', 'DESAYUNOS', '198.00', NULL, '0.00', 7098.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 15:32:48', 3),
(1064, 14, NULL, 'LINA MARIA', 'ZAPATA', 'volarenglobo@yahoo.es', NULL, '5520380732', 11, 6, 0, 38, 1, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 6 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYU', 'DESAYUNOS', '594.00', NULL, NULL, NULL, '0.00', 14394.00, 0, '422.00', 1, 0, NULL, 1, NULL, '2019-09-17 15:42:00', 4),
(1065, 14, NULL, 'JAIME', 'ALCANTARA', 'volarenglobo@yahoo.es', NULL, '5549919393', 35, 3, 0, 36, 1, '2019-09-21', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', 'IVA', '1104.00', NULL, NULL, NULL, '0.00', 8004.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 16:55:02', 3),
(1066, 14, NULL, 'MILET MARISSELA', 'SALVATIERRA', 'volarenglobo@yahoo.es', NULL, '51981911669', 35, 2, 0, 38, 1, '2019-09-19', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLI', NULL, NULL, NULL, NULL, 2, '600.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 18:30:18', 3),
(1067, 14, NULL, 'ERIKA DENISSE ', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 18:38:14', 6),
(1068, 14, '1067', 'ERIKA DENISSE ', 'ANDRADE', 'volarenglobo@yahoo.es', NULL, '2221845901', 35, 2, 0, 36, 1, '2019-09-21', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYU', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 18:38:37', 3),
(1069, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 18:40:42', 0),
(1070, 14, NULL, 'CRISTINA', 'CONSTANZA', 'volarenglobo@yahoo.es', NULL, '50253353484', 35, 2, 0, 36, 1, '2019-10-15', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYU', NULL, NULL, NULL, NULL, 2, '600.00', 5280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 18:41:11', 3),
(1071, 14, NULL, 'HECTOR', 'VILLATORO', 'volarenglobo@yahoo.es', NULL, '429899963', 35, 2, 0, 36, 1, '2019-09-19', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYU', 'DESAYUNOS ADICIONALE', '280.00', 'TRANSPORTE ADICIONAL', '1000.00', 2, '600.00', 6560.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 18:44:32', 3),
(1072, 14, '1053', 'CHRISTIAN', 'MORALES', 'volarenglobo@yahoo.es', NULL, '5534594283', 35, 2, 0, 37, 4, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE L', NULL, NULL, NULL, NULL, NULL, '0.00', 8300.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 18:53:14', 8),
(1073, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 11:42:51', 0),
(1074, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 11:43:18', 0),
(1075, 16, NULL, 'FANY', 'RICARDO', 'licenf78@yahoo.com.mx', NULL, '5519071151', NULL, 1, 1, 38, 1, '2019-09-22', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, 2, '82.00', 4198.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 11:51:41', 8),
(1076, 16, NULL, 'AGUSTINA', 'SENA', 'agustina.sena@gmail.com', NULL, '5580484840', NULL, 2, 0, 36, 1, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, 2, '2.00', 5598.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 14:58:34', 8),
(1077, 9, NULL, 'MARTIN ALEJANDRO', 'SILVA CARDENAS', 'turismo@volarenglobo.com.mx', NULL, '5537048766', NULL, 2, 0, 36, 16, '2019-10-20', NULL, NULL, NULL, NULL, NULL, '2 pax privado bestday id 73529389-1', NULL, NULL, NULL, NULL, 2, '800.00', 5200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 16:31:58', 0),
(1078, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 16:34:53', 0),
(1079, 9, '1078', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 16:35:18', 0),
(1080, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 16:38:45', 6),
(1081, 16, '1080', 'SUSANA', 'SALAZAR', 'reserva@volarenglobo.com.mx', NULL, '5510998008', NULL, 2, 0, 38, 2, '2019-09-19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 16:39:25', 3),
(1082, 9, '1077', 'MARTIN ALEJANDRO', 'SILVA CARDENAS', 'turismo@volarenglobo.com.mx', NULL, '5537048766', NULL, 2, 0, 36, 16, '2019-10-20', NULL, NULL, NULL, NULL, NULL, '2 pax privado bestday id 73529389-1', NULL, NULL, NULL, NULL, 2, '800.00', 5200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 16:42:44', 4),
(1083, 14, NULL, 'FERNANDO', 'MADRIGAL', 'volarenglobo@yahoo.es', NULL, '50670701470', 35, 2, 0, 36, 1, '2019-09-22', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 17:05:37', 3),
(1084, 14, NULL, 'AXEL', 'MARTINEZ', 'volarenglobo@yahoo.es', NULL, '5532328480', 11, 2, 0, 36, 4, '2019-09-22', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE L', NULL, NULL, NULL, NULL, 2, '500.00', 6500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 17:08:35', 3),
(1085, 14, NULL, 'AXEL', 'MARTINEZ', 'volarenglobo@yahoo.es', NULL, '5532328480', 11, 2, 0, 36, 1, '2019-09-22', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 17:10:38', 3),
(1086, 14, NULL, 'ANGELA', 'GOMEZ', 'volarenglobo@yahoo.es', NULL, '573045305982', 35, 2, 0, 38, 1, '2019-09-21', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 17:13:56', 8),
(1087, 14, '1058', 'FUSHION', 'LAY', 'volarenglobo@yahoo.es', NULL, '573160732', 35, 2, 0, 36, 1, '2019-09-24', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, 2, '600.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 17:16:36', 6),
(1088, 14, '1087', 'FUSHION', 'LAY', 'volarenglobo@yahoo.es', NULL, '573160732', 35, 2, 0, 36, 1, '2019-09-24', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, 2, '600.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 17:20:57', 8),
(1089, 14, NULL, 'ALEJANDRO', 'CUAXOSPA', 'volarenglobo@yahoo.es', NULL, '5541947452', 11, 2, 0, 36, 4, '2019-09-22', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE L', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 18:00:09', 8),
(1090, 16, NULL, 'ANA', 'PACHECO', 'anapacheco1979@hotmail.com', NULL, '5532062243', 11, 2, 0, 38, 1, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 18:23:02', 8),
(1091, 14, NULL, 'ARMANDO ', 'PEREZ', 'volarenglobo@yahoo.es', NULL, '4431114232', 35, 2, 0, 36, 1, '2019-09-19', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYU', 'DESAYUNOS', '198.00', 'TRANSPORTE ZONA CENT', '700.00', NULL, '0.00', 5498.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 18:39:10', 6),
(1092, 14, '1091', 'ARMANDO ', 'PEREZ', 'volarenglobo@yahoo.es', NULL, '4431114232', 35, 2, 0, 36, 1, '2019-09-19', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYU', NULL, NULL, NULL, NULL, 2, '600.00', 5280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 18:55:42', 3),
(1093, 16, NULL, 'DANIEL', 'MARTINEZ', 'danieldyn@hotmail.com', NULL, '5611671200', NULL, 2, 0, 38, 1, '2019-09-21', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 11:15:46', 8),
(1094, 14, NULL, 'EYLEM', 'ARAUZ', 'volarenglobo@yahoo.es', NULL, '50766124237', 35, 3, 0, 36, 1, '2019-09-24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '900.00', 7920.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 12:55:31', 6),
(1095, 14, '1094', 'EYLEM', 'ARAUZ', 'volarenglobo@yahoo.es', NULL, '50766124237', 35, 3, 0, 36, 1, '2019-09-24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '900.00', 7920.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 12:59:04', 8),
(1096, 14, NULL, 'NADIA', 'MAYAAM', 'volarenglobo@yahoo.es', NULL, '52172258595262', 35, 7, 1, 38, 1, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 8 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLI', NULL, NULL, NULL, NULL, 2, '2141.00', 16779.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 13:03:18', 8),
(1097, 9, NULL, 'ELIZABETH', 'PEZZA', 'turismo@volarenglobo.com.mx', NULL, '99999999', 35, 2, 0, 36, 3, '2019-11-07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '340.00', 4560.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 13:45:27', 4),
(1098, 9, NULL, 'HERNAN DARIO', 'DIAZ SALAZAR', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 3, 0, 36, 3, '2019-10-05', NULL, NULL, NULL, NULL, NULL, '3 PAX COMPARTIDO  BESTDAY ID 73666355-1', NULL, NULL, NULL, NULL, NULL, '0.00', 5850.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 14:22:06', 4),
(1099, 9, NULL, 'JEIMY LORENA', 'MORALES', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, 37, 3, '2019-10-17', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO PRICE TRAVEL LOCATOR 12707825-1', NULL, NULL, NULL, NULL, 2, '500.00', 3400.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 14:36:16', 4),
(1100, 16, NULL, 'MONSE', 'ZAPATA', 'Zapata.montserrat@gmail.com', NULL, '7225126658', NULL, 4, 0, 38, 5, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la a', NULL, NULL, NULL, NULL, NULL, '0.00', 13000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 14:42:21', 6),
(1101, 9, NULL, 'MARK RICHARD', 'PRICE', 'turismo@volarenglobo.com.mx', NULL, '999999', 35, 4, 0, 36, 3, '2019-10-25', NULL, NULL, NULL, NULL, NULL, '4 PAX COMPARTIDO CON TRANSPORTE EXPEDIA ', NULL, NULL, NULL, NULL, 2, '200.00', 9600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 15:23:57', 4),
(1102, 9, NULL, 'JESUS ANTONIO', 'SERRANO', 'turismo@volarenglobo.com.mx', NULL, '999999', 35, 2, 0, 36, 3, '2019-10-04', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO EXPEDIA CON TRANSPORTE', NULL, NULL, NULL, NULL, 2, '100.00', 4800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 15:43:26', 4),
(1103, 14, NULL, 'GERMAN', 'MORENO', 'volarenglobo@yahoo.es', NULL, '57300200303', 35, 3, 0, 36, 1, '2019-10-30', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 43PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 8697.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 16:07:14', 3),
(1104, 9, NULL, 'UEMURA', 'HORUKA', 'turismo@volarenglobo.com.mx', NULL, '5555335133', NULL, 5, 0, NULL, 3, '2019-09-28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '50.00', 12200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 17:53:04', 0),
(1105, 9, NULL, 'KARINA ', NULL, 'turismo@volarenglobo.com.mx', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 18:10:02', 0),
(1106, 9, NULL, 'KARINA ', 'YEBRA OLIVARES', 'turismo@volarenglobo.com.mx', NULL, '5575086041', 11, 2, 0, 36, 3, '2019-09-21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 3900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 18:39:58', 4),
(1107, 9, NULL, 'ALEJANDRA', 'FLORES', 'turismo@volarenglobo.com.mx', NULL, '50499624394', 11, 4, 0, 36, 3, '2019-09-27', NULL, NULL, NULL, NULL, NULL, '4 PAX BOOKING CON TRANSPORTE', NULL, NULL, NULL, NULL, 2, '406.00', 9394.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 18:46:57', 4),
(1108, 14, '1056', 'CLAUDIA', 'PERDOMO', 'volarenglobo@yahoo.es', NULL, '573007386751', 11, 2, 0, 36, 1, '2019-10-18', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, 2, '600.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 11:05:16', 3),
(1109, 14, NULL, 'JOSHUA DANIEL', 'GONZALEZ', 'volarenglobo@yahoo.es', NULL, '5543231239', 11, 2, 0, 38, 1, '2019-10-15', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 12:10:15', 3),
(1110, 9, NULL, 'UEMURA', 'HORUKA', 'turismo@volarenglobo.com.mx', NULL, '5555335133', 35, 5, 0, 36, 3, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 5 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nTRANSPORTE REDONDO CDMX-TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.\nDESAYUNO BUFFET.', NULL, NULL, NULL, NULL, 2, '550.00', 12400.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 12:12:18', 4),
(1111, 9, NULL, 'MARIA CRISTINA', 'ORJUELA GAMBA', 'turismo@volarenglobo.com.mx', NULL, '9981933660', 11, 1, 0, 36, 3, '2019-12-05', NULL, NULL, NULL, NULL, NULL, '1 PAX COMPARTIDO PRICE TRAVEL LOCATOR 12209035-1', NULL, NULL, NULL, NULL, 2, '250.00', 1700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 12:24:11', 4),
(1112, 14, NULL, 'ITZAYANA', 'NORIEGA', 'itzanoriega3005@gmail.com', NULL, '5536815845', 11, 2, 0, 36, 4, '2019-09-30', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESAYUNO EN RES', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 12:39:50', 3),
(1113, 14, NULL, 'ITZAYANA', 'NORIEGA', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 12:42:25', 6),
(1114, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 12:45:11', 0),
(1115, 14, '1113', 'ITZAYANA', 'NORIEGA', 'itzanoriega3005@gmail.com', NULL, '5536815845', 11, 2, 0, 36, 1, '2019-09-30', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYU', NULL, NULL, NULL, NULL, 2, '600.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 12:48:07', 3);
INSERT INTO `temp_volar` (`id_temp`, `idusu_temp`, `clave_temp`, `nombre_temp`, `apellidos_temp`, `mail_temp`, `telfijo_temp`, `telcelular_temp`, `procedencia_temp`, `pasajerosa_temp`, `pasajerosn_temp`, `motivo_temp`, `tipo_temp`, `fechavuelo_temp`, `tarifa_temp`, `hotel_temp`, `habitacion_temp`, `checkin_temp`, `checkout_temp`, `comentario_temp`, `otroscar1_temp`, `precio1_temp`, `otroscar2_temp`, `precio2_temp`, `tdescuento_temp`, `cantdescuento_temp`, `total_temp`, `piloto_temp`, `kg_temp`, `tipopeso_temp`, `globo_temp`, `hora_temp`, `idioma_temp`, `comentarioint_temp`, `register`, `status`) VALUES
(1116, 14, NULL, 'SILVIA JANETH', 'CALDERON', 'volarenglobo@yahoo.es', NULL, '50257742000', 35, 2, 0, 38, 1, '2019-10-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 14:52:04', 4),
(1117, 9, NULL, 'BRENDA CLAUDIA', 'MENDOZA VILLEGAS', 'turismo@volarenglobo.com.mx', NULL, '5582094052', 11, 2, 0, 36, 16, '2019-10-05', NULL, NULL, NULL, NULL, NULL, '2 PAX PRIVADO 014 MEDIA', NULL, NULL, NULL, NULL, NULL, '0.00', 6000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 15:22:25', 4),
(1118, 16, NULL, 'CLAUDIA', 'CALDERON', 'clau.calderonc@gmail.com', NULL, '51944583583', NULL, 2, 0, 36, 1, '2019-09-22', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 15:38:35', 0),
(1119, 16, NULL, 'CLAUDIA', 'CALDERON', 'clau.calderonc@gmail.com', NULL, '51944583583', NULL, 2, 0, 36, 1, '2019-09-22', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 15:48:08', 8),
(1120, 14, NULL, 'OSCAR IVAN', 'PAZMINO', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 16:43:31', 0),
(1121, 9, NULL, 'CLAUDIA ELENA', 'BUENO MOLINA', 'turismo@volarenglobo.com.mx', NULL, '6562679108', 11, 1, 0, 36, 3, '2019-09-24', NULL, NULL, NULL, NULL, NULL, '1 PAX COMPARTIDO BOOKING CON TRANSPORTE', NULL, NULL, NULL, NULL, 2, '102.00', 2348.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 16:50:09', 4),
(1122, 9, NULL, 'ALMA', 'SOTO', 'turismo@volarenglobo.com.mx', NULL, '5556739085', 11, 8, 0, 36, 3, '2019-09-22', NULL, NULL, NULL, NULL, NULL, '8 PAX COMPARTIDO BOOKING FULL ', NULL, NULL, NULL, NULL, 2, '265.00', 21955.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 16:57:45', 4),
(1123, 9, NULL, 'VALERIA VANESSA', 'SALINAS', 'turismo@volarenglobo.com.mx', NULL, '99', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 17:10:03', 0),
(1124, 9, NULL, 'KENNY', 'VEL', 'kennyvel_a@hotmail.com', NULL, '5523022634', 17, 2, 0, 39, 4, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'Â°VUELO PRIVADO 2 PAX  SOBRE EL VALLE DE TEOTIHUACAN Â°COFFEE BREAK ANTES DE VUELO Â°SEGURO DE VIAJERO Â°DESPLIEGUE DE LONA Â¿TE QUIERES CASAR CONMIGO? Â°BRINDIS CON VINO ESPUMOSO Â°CERTIFICADO PERSONALIZADO Â°DESAYUNO BUFFET Â°FOTO IMPRESA A ELEGIR\n', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 18:08:59', 6),
(1125, 9, NULL, 'VALERIA VANESSA', 'SALINAS', 'turismo@volarenglobo.com.mx', NULL, '9981933660', 11, 2, 0, 36, 2, '2019-10-05', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO PRICE TRAVEL LOCATOR  12965767-1', NULL, NULL, NULL, NULL, NULL, '0.00', 4000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 18:19:50', 4),
(1126, 9, NULL, 'LUISA', 'DE MOYA', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, 36, 3, '2019-10-20', NULL, NULL, NULL, NULL, NULL, '2  PAX COMPARTIDO BESTDAY ID 73839672-5', NULL, NULL, NULL, NULL, NULL, '0.00', 3900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 18:40:00', 4),
(1127, 9, NULL, 'JUAN', 'MIÃ‘ANO', 'turismo@volarenglobo.com.mx', NULL, '34699453648', 35, 4, 0, 36, 3, '2019-10-05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '659.00', 10901.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-21 12:09:57', 4),
(1128, 9, NULL, 'JUNCHENG', 'TANG', 'turismo@volarenglobo.com.mx', NULL, '34699453648', 35, 2, 0, 36, 3, '2019-12-25', NULL, NULL, NULL, NULL, NULL, '2 pax compartido con transporte expedia', NULL, NULL, NULL, NULL, 2, '100.00', 4800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-21 12:17:02', 4),
(1129, 9, NULL, 'ELIANA ', 'LINHARES PIVATTO', 'turismo@volarenglobo.com.mx', NULL, '5549999199290', 35, 2, 0, 36, 3, '2019-09-22', NULL, NULL, NULL, NULL, NULL, '2 pax booking con transporte', NULL, NULL, NULL, NULL, 2, '203.00', 4697.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-21 12:23:23', 4),
(1130, 9, NULL, 'WENDY', 'MURILLO BECERRIL', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, 38, 3, '2019-09-22', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO BESTDAY ID 73865987-1', NULL, NULL, NULL, NULL, NULL, '0.00', 3900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-21 12:32:19', 4),
(1131, 9, NULL, 'ADRIAN', 'CAMAYO', 'turismo@volarenglobo.com.mx', NULL, '5516123007', 11, 4, 0, 36, 3, '2019-09-22', NULL, NULL, NULL, NULL, NULL, '4 PAX COMPARTIDO WAYAK', NULL, NULL, NULL, NULL, 2, '600.00', 7200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-21 13:22:59', 4),
(1132, 14, NULL, 'GABY', 'VEGA', 'volarenglobo@yahoo.es', NULL, '5548702712', 11, 1, 1, 38, 1, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 ADULTO 1 MENOR, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLE\" DESAYUNO Y PASTEL PARA CUMPLEAÃ‘ERO', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4198.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 12:22:35', 8),
(1133, 16, NULL, 'MARIA EMILIA', 'TERRAZAS', 'mterrazas9121@gmail.com', NULL, '9562256019', NULL, 2, 0, 38, 4, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la actividad en TeotihuacÃ¡n\nâ€¢	Despliegue de lona FELIZ CUMPLE! \nâ€¢	Foto Impresa\nâ€¢	Coffee Break\n', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '150.00', 1, 0, NULL, 1, NULL, '2019-09-23 12:42:44', 4),
(1134, 9, NULL, 'JUAN MANUEL', 'BAUTISTA CORREA', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 1, 0, 36, 3, '2019-10-14', NULL, NULL, NULL, NULL, NULL, '1 PAX COMPARTIDO BESTDAY ID 73929099-1', NULL, NULL, NULL, NULL, 2, '310.00', 1640.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 13:14:00', 4),
(1135, 9, NULL, 'EMILIO', 'AMARILLO', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, 36, 3, '2019-10-27', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO BESTDAY ID 73929685-1', NULL, NULL, NULL, NULL, NULL, '0.00', 3900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 13:25:55', 3),
(1136, 9, NULL, 'RICHARD', 'TURISKY', 'turismo@volarenglobo.com.mx', NULL, '573202405215', 11, 2, 0, 36, 3, '2019-09-24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '800.00', 4100.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 13:50:38', 4),
(1137, 14, NULL, 'HENRY', 'BULLA TORO', 'volarenglobo@yahoo.es', NULL, '05723286448015', 35, 2, 0, 37, 1, '2019-09-24', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ ANIVERSARIO\" DESAYUNO BUFFET Y TRANSPORTE ZONA CENTRO CDMX-TEOTIHUACAN-CDMX', NULL, NULL, NULL, NULL, 2, '600.00', 5280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 13:57:49', 4),
(1138, 16, NULL, 'JEIMI Y FABIAN', 'GOMEZ', 'jeimgomez@uan.edu.co', NULL, '5548522320', NULL, 5, 0, 36, 2, '2019-09-24', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, TE, GALLETAS, PAN.\nâ€¢	DESPLIEGUE DE LONA\nâ€¢	DESAYUNO BUFFETE EN RESTAURANTE GRAN TEOCALLI.\nâ€¢	TRANSPORTE REDONDO CDMX ZÃ“CALO- TEOTIHUACÃN\n', NULL, NULL, NULL, NULL, 2, '700.00', 12500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 14:19:31', 3),
(1139, 16, NULL, 'NAYELLI', 'SIERRA', 'nayelli.sierra@hotmail.com', NULL, '5532356975', NULL, 2, 0, 38, 4, '2019-10-06', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la actividad en TeotihuacÃ¡n\nâ€¢	Despliegue de lona FELIZ CUMPLE! \nâ€¢	Foto Impresa\nâ€¢	Coffee Break\n', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 17:23:45', 6),
(1140, 14, NULL, 'RUDY', 'HUAMAN', 'rudy.huamanq@gmail.com', NULL, '51980314278', 35, 2, 0, 45, 4, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA DE ------- DESAYUNO EN RESTAURANTE GRAN TEOCALLI Y FOTOGRAFIA IMPRESA A ELEGIR.', 'ENTRADAS A ZONA ARQU', '150.00', NULL, NULL, NULL, '0.00', 9050.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 18:14:02', 3),
(1141, 14, NULL, 'RUDY', 'HUAMAN', 'volarenglobo@yahoo.es', NULL, '511980314278', 35, 2, 0, 45, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA DE \"TE AMO\" DESAYUNO BUFFET', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 18:16:33', 6),
(1142, 14, '1141', 'RUDY', 'HUAMAN', 'volarenglobo@yahoo.es', NULL, '511980314278', 35, 2, 0, 45, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA DE \"TE AMO\" DESAYUNO BUFFET', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 6848.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 18:38:48', 3),
(1143, 16, NULL, 'ABRAHAM', 'ESPINOZA', 'urielurias@hotmail.com', NULL, '6671255249', NULL, 2, 0, 38, 4, '2019-11-29', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la actividad en TeotihuacÃ¡n\nâ€¢	Despliegue de lona  Feliz Cumple!\nâ€¢	Foto Impresa\nâ€¢	Coffee Break\n', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 18:38:50', 6),
(1144, 14, NULL, 'SERGIO', 'COVALEDA', 'volarenglobo@yahoo.es', NULL, '573176568559', 35, 4, 0, 38, 1, '2019-12-31', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET Y PASTEL PARA CUMPLEAÃ‘ERO', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 9596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 18:54:06', 3),
(1145, 14, NULL, 'ANDREA', 'MOLINA', 'volarenglobo@yahoo.es', NULL, '4431341252', 18, 2, 0, 36, 1, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET', 'DESAYUNOS', '198.00', 'TRANSPORTE ZONA ZOCA', '700.00', NULL, '0.00', 5498.00, 0, '187.00', 1, 0, NULL, 1, NULL, '2019-09-24 10:48:00', 4),
(1146, 16, '1100', 'MONSE', 'ZAPATA', 'Zapata.montserrat@gmail.com', NULL, '7225126658', NULL, 5, 0, 38, 16, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la a', NULL, NULL, NULL, NULL, NULL, '0.00', 15000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 12:12:14', 8),
(1147, 14, NULL, 'KATIA', 'AGUILAR', 'volarenglobo@yahoo.es', NULL, '5535133683', 11, 2, 0, 37, 4, '2019-10-09', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA DE \"FELIZ ANIVERSARIO\" DESAYUNO EN RESTAURANTE GRAN TEOCALLI Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7300.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 12:35:46', 3),
(1148, 9, NULL, 'CESAR DAVID', 'REYES', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, 36, 16, '2019-10-11', NULL, NULL, NULL, NULL, NULL, '2 PAX PRIVADO BESTDAY ID 73933847-1', NULL, NULL, NULL, NULL, 2, '1200.00', 4800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 12:41:06', 3),
(1149, 9, NULL, 'RACHEL', 'DURANTE', 'turismo@volarenglobo.com.mx', NULL, '15168512348', 35, 2, 0, NULL, 3, '2019-10-06', NULL, NULL, NULL, NULL, NULL, '**** 2019-10-06 ****\nâ€ƒâ€ƒTicket Type: Traveler: 2 ()\nâ€ƒâ€ƒPrimary Redeemer: Rachel Durante, 15168512348, lidelrach06@aol.com\nâ€ƒâ€ƒValid Day: Oct 6, 2019\nâ€ƒâ€ƒItem: Teotihuacan Pyramids Hot-Air Balloon Flight / 5:00 AM, Flight with Transportation / 529019\nâ€ƒâ€ƒVoucher: 80178990, 80178991\nâ€ƒâ€ƒItinerary: 7477752030237\nâ€ƒâ€ƒCustomer Staying At: HistÃ³rico Central Mexico City; Bolivar No. 28, Mexico City, CDMX \n', NULL, NULL, NULL, NULL, 2, '100.00', 4800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 12:50:04', 4),
(1150, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 13:15:05', 0),
(1151, 14, NULL, 'MARU', 'FIGUEROA', 'volarenglobo@yahoo.es', NULL, '5544948848', 11, 2, 2, 36, 4, '2019-10-05', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 ADULTOS 2 MENORES , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE GRAN TEOCALLI Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, 2, '2.00', 10598.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 13:21:18', 8),
(1152, 14, NULL, 'MONICA', 'BERMEO', 'volarenglobo@yahoo.es', NULL, '57320987023', 35, 2, 2, 36, 1, '2019-10-12', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 ADULTOS 2 MENORES, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET ', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 8396.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 15:35:32', 3),
(1153, 16, NULL, 'DANIELA', 'PEREZ', 'chicdannnn@gmail.com', NULL, '5586764141', NULL, 2, 0, 37, 4, '2019-09-25', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la actividad en TeotihuacÃ¡n\nâ€¢	Despliegue de lona FELIZ ANIVERSARIO!\nâ€¢	Foto Impresa\nâ€¢	Coffee Break\n', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '135.00', 1, 0, NULL, 1, NULL, '2019-09-24 17:18:24', 4),
(1154, 9, NULL, 'JAVIER', 'NAVARRO NAVARRO', 'turismo@volarenglobo.com.mx', NULL, '5580284011', 11, 2, 0, 36, 3, '2019-10-29', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO CON TRANSPORTE TU EXPERIENCIA', NULL, NULL, NULL, NULL, 2, '200.00', 4700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 17:23:01', 4),
(1155, 9, NULL, 'GRUPO', 'NOVIEMBRE', 'turismo@volarenglobo.com.mx', NULL, '5580284011', 11, 7, 0, 36, 3, '2019-11-10', NULL, NULL, NULL, NULL, NULL, '7 PAX COMPARTIDO  GALLEGOS TOURS', NULL, NULL, NULL, NULL, 2, '70.00', 14560.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 17:40:50', 4),
(1156, 16, '1139', 'NAYELLI', 'SIERRA', 'nayelli.sierra@hotmail.com', NULL, '5532356975', NULL, 4, 0, 38, 1, '2019-10-05', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, TE, GALLETAS, PAN.\nâ€¢	DESPLIEGUE DE LONA FELIZ CUMPLE!\n\n', NULL, NULL, NULL, NULL, 2, '164.00', 9596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 18:19:15', 4),
(1157, 14, NULL, 'JESUS', 'TAPIA', 'volarenglobo@yahoo.es', NULL, '2227663931', 11, 2, 0, 39, 4, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD,DESPLIEGUE DE LONA DE \"TE QUIERES CASAR CONMIGO\" DESAYUNO EN RESTAURANTE GRAN TEOCALLI Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 10100.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 18:28:48', 3),
(1158, 14, NULL, 'GONZALO', 'MORAN', 'volarenglobo@yahoo.es', NULL, '5522161041', 11, 2, 0, 36, 4, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESAYUNO EN RESTAURANTE GRAN TEOCALLI Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7500.00, 0, '133.00', 1, 0, NULL, 1, NULL, '2019-09-25 12:59:20', 8),
(1159, 14, NULL, 'ANDREA', 'GUERRA', 'volarenglobo@yahoo.es', NULL, '50257041207', 35, 3, 0, 38, 1, '2019-09-26', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA  3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA,DESAYUNO Y TRANSPORTE REDONDO', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 8697.00, 0, '248.00', 1, 0, NULL, 1, NULL, '2019-09-25 13:06:16', 7),
(1160, 16, NULL, 'CARLOS', 'GAMA', 'carl_yop@yahoo.com.mx', NULL, '4434100433', NULL, 10, 0, NULL, 2, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, TE, GALLETAS, PAN.\nâ€¢	DESPLIEGUE DE LONA\nâ€¢	DESAYUNO BUFFETE EN RESTAURANTE GRAN TEOCALLI.\n', NULL, NULL, NULL, NULL, NULL, '0.00', 21400.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-25 14:00:52', 3),
(1161, 11, NULL, 'DARIO', 'BRAVO', 'volarenglobo@yahoo.es', NULL, '573136855276', 35, 2, 0, NULL, 1, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFEE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nTRANSPORTE IDA Y VUELTA DESDE HOTEL FIESTA INN AEROPUERTO', NULL, NULL, NULL, NULL, NULL, '0.00', 5600.00, 0, '125.00', 1, 0, NULL, 1, NULL, '2019-09-25 14:36:15', 4),
(1162, 16, NULL, 'RICARDO', 'RODRIGUEZ', 'rodrigueztoledoricado10@gmail.com', NULL, '5568935326', NULL, 2, 0, 44, 1, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, TE, GALLETAS, PAN.\nâ€¢	DESPLIEGUE DE LONA\nâ€¢	DESAYUNO BUFFETE EN RESTAURANTE GRAN TEOCALLI.\n', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '135.00', 1, 0, NULL, 1, NULL, '2019-09-25 15:07:04', 4),
(1163, 16, NULL, 'MISSAEL', 'OLMEDO', 'ricardo.olmedo@live.com.mx', NULL, '5544200675', NULL, 2, 0, 36, 2, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, TE, GALLETAS, PAN.\n', NULL, NULL, NULL, NULL, NULL, '0.00', 4000.00, 0, '135.00', 1, 0, NULL, 1, NULL, '2019-09-25 15:21:20', 7),
(1164, 16, NULL, 'LAURA', 'REYNA', 'laurarsaenz@hotmail.com', NULL, '5554034929', NULL, 2, 0, 36, 1, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, TE, GALLETAS, PAN.\nâ€¢	DESPLIEGUE DE LONA\nâ€¢	DESAYUNO BUFFETE EN RESTAURANTE GRAN TEOCALLI.\nâ€¢	TRANSPORTE REDONDO CDMX TEOTIHUACÃN\n', NULL, NULL, NULL, NULL, 2, '82.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-25 15:57:42', 7),
(1165, 16, NULL, 'DANIEL', 'MONTOYA', 'daniel@tiberica.com', NULL, '5517432060', NULL, 2, 2, 38, 1, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, TE, GALLETAS, PAN.\nâ€¢	DESPLIEGUE DE LONA\n', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-25 16:00:03', 4),
(1166, 16, NULL, 'JUAN PABLO', 'MARTINEZ', 'pablomartz@msn.com', NULL, '4431645078', NULL, 6, 5, 43, 1, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, TE, GALLETAS, PAN.\nâ€¢	DESPLIEGUE DE LONA\n', NULL, NULL, NULL, NULL, 2, '1200.00', 21100.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-25 16:25:56', 4),
(1167, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-25 18:12:49', 0),
(1168, 14, NULL, 'ANA MARAI', 'ESTUPIÃ‘AN', 'volarenglobo@yahoo.es', NULL, '573144768664', 35, 4, 0, 36, 1, '2019-09-26', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, 2, '1200.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-25 18:21:02', 6),
(1169, 14, '1168', 'ANA MARIA', 'ESTUPIÃ‘AN', 'volarenglobo@yahoo.es', NULL, '573144768664', 35, 4, 0, 36, 1, '2019-09-26', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, 2, '1200.00', 8000.00, 0, '293.00', 1, 0, NULL, 1, NULL, '2019-09-25 18:22:50', 4),
(1170, 16, NULL, 'DIANEY', 'SAHAGUN', 'Dianey.sahagun@outlook.es', NULL, '3333991673', NULL, 2, 0, NULL, 5, '2019-10-01', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la actividad en TeotihuacÃ¡n\nâ€¢	Despliegue de lona \nâ€¢	Foto Impresa\nâ€¢	Coffee Break\n', NULL, NULL, NULL, NULL, NULL, '0.00', 6500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-25 18:57:56', 7),
(1171, 14, NULL, 'CATE', '.', 'sartoria2@gmail.com', NULL, '1281902276', 35, 5, 0, 73, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'TRADITIONAL SHARED FLIGHT,  HOT AIRE BALLON 2 PAX FOR 45 MINUTES APROX, TOAST WITH SPARKLIN FREIXENET WINE,PERSONALIZED FLIGHT CERTIFICATE,TRANSPORTATION DURING THE ACTIVITY (CHECK IN AREA-TAKE OFF AREA AND LANDING SITE CHECK IN AREA) , TRAVEL INSURANCE, TRANSPORTATION HOTEL - TEOTIHUACAN- HOTEL , TRADITIONAL BREAKFAST IN RESTAURANT GRAN TEOCALLI (BUFFET SERVICE). ', 'DESAYUNOS', '495.00', NULL, NULL, NULL, '0.00', 14495.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-09-26 11:31:40', 6),
(1172, 18, NULL, 'ALBERTO', 'MEZA', 'volarenglobo@yahoo.es', NULL, '50688120525', 35, 8, 0, 43, 4, '2019-10-25', NULL, NULL, NULL, NULL, NULL, 'INCLUYE:\n- VUELO PANORAMICO SOBRE EL VALLE DE TEOTIHUACAN. \n- COFFEE BREAK. \n- BRINDIS CON VINO ESPUMOSO. \n- CERTIFICADO PERSONALIZADO. \n- SEGURO DE VIAJERO. \n- DESAYUNO TIPO BUFFET. \n- FOTO IMPRESA.', NULL, NULL, NULL, NULL, 2, '2600.00', 25600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 12:23:47', 6),
(1173, 16, NULL, 'YUNUHE', 'QUIROZ', 'jasonquiroz74@gmail.com ', NULL, '5615100221', NULL, 2, 0, 39, 4, '2019-10-16', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo/ Brindis en vuelo con vino espumoso Freixenet/ Certificado de vuelo/ Seguro viajero/ Desayuno tipo Buffet / TransportaciÃ³n local / Despliegue de lona Â¿Te quieres casar conmigo?/ Foto Impresa', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 12:26:39', 6),
(1174, 16, NULL, 'ORIETTA', 'VALDERRAMA', 'lissyolv_00@hotmail.com', NULL, '50769832014', 35, 2, 0, 36, 1, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos /brindis con vino espumoso/ certificado de vuelo/ seguro viajero/ coffe break (cafÃ©, TÃ©, pan , galletas, fruta)despliegue de lona', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 12:31:42', 6),
(1175, 16, '1174', 'ORIETTA', 'VALDERRAMA', 'lissyolv_00@hotmail.com', NULL, '50769832014', 35, 2, 0, 36, 1, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos /brindis con vino espumoso/ certificado de vuelo/ seguro viajero/ coffe break (cafÃ©, TÃ©, pan , galletas, fruta)despliegue de lona', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '130.00', 1, 0, NULL, 1, NULL, '2019-09-26 12:46:26', 8),
(1176, 18, '1172', 'ALBERTO', 'MEZA', 'volarenglobo@yahoo.es', NULL, '50688120525', 35, 8, 0, 43, 4, '2019-10-25', NULL, NULL, NULL, NULL, NULL, 'INCLUYE:\n- VUELO PANORAMICO SOBRE EL VALLE DE TEOTIHUACAN. \n- COFFEE BREAK. \n- BRINDIS CON VINO ESPUMOSO. \n- CERTIFICADO PERSONALIZADO. \n- SEGURO DE VIAJERO. \n- DESAYUNO TIPO BUFFET. \n- FOTO IMPRESA.', NULL, NULL, NULL, NULL, 2, '2600.00', 25600.00, 0, '590.00', 1, 0, NULL, 1, NULL, '2019-09-26 12:48:27', 4),
(1177, 16, '1173', 'CARLOS', 'CISNEROS', 'jasonquiroz74@gmail.com ', NULL, '5615100221', NULL, 2, 0, 39, 4, '2019-10-16', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo/ Brindis en vuelo con vino espumoso Freixenet/ Certificado de vuelo/ Seguro viajero/ Desayuno tipo Buffet / TransportaciÃ³n local / Despliegue de lona Â¿Te quieres casar conmigo?/ Foto Impresa', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 12:58:54', 6),
(1178, 16, '1177', 'CARLOS', 'CISNEROS', 'jasonquiroz74@gmail.com ', NULL, '5615100221', NULL, 2, 0, 39, 4, '2019-10-16', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo/ Brindis en vuelo con vino espumoso Freixenet/ Certificado de vuelo/ Seguro viajero/ Desayuno tipo Buffet / TransportaciÃ³n local / Despliegue de lona Â¿Te quieres casar conmigo?/ Foto Impresa', 'DESAYUNO 7 PAX', '980.00', NULL, NULL, NULL, '0.00', 7980.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 14:03:11', 8),
(1179, 9, NULL, 'VERONICA', 'JIMENEZ', 'turismo@volarenglobo.com.mx', NULL, '5532401181', 11, 7, 0, 36, 3, '2019-09-29', NULL, NULL, NULL, NULL, NULL, '7 PAX COMPARTIDO FULL', NULL, NULL, NULL, NULL, 2, '162.25', 19392.75, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 15:05:15', 3),
(1180, 9, NULL, 'MONICA', NULL, 'turismo@volarenglobo.com.mx', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 15:27:03', 0),
(1181, 9, NULL, 'MONICA', 'GIRON', 'turismo@volarenglobo.com.mx', NULL, '5532408382', 11, 4, 0, NULL, 3, '2019-09-28', NULL, NULL, NULL, NULL, NULL, '4 PAX COMPARTIDO BOOKING FULL', NULL, NULL, NULL, NULL, 2, '659.00', 10901.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 16:44:18', 3),
(1182, 9, NULL, 'IVAN DARIO', 'DIAZ BELTARN', 'turismo@volarenglobo.com.mx', NULL, '55104461', 11, 1, 0, 36, 3, '2019-09-28', NULL, NULL, NULL, NULL, NULL, '1 PAX COMPARTIDO UNIVERSE TRAVEL CON TRANSPORTE', NULL, NULL, NULL, NULL, 2, '100.00', 2350.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 16:53:42', 7),
(1183, 9, NULL, 'CARINA', 'SALAZAR', 'turismo@volarenglobo.com.mx', NULL, '58634953', 11, 4, 0, 36, 3, '2019-09-28', NULL, NULL, NULL, NULL, NULL, '4 PAX COMPARTIDO BOOKING FULL', NULL, NULL, NULL, NULL, 2, '659.00', 10901.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 17:15:11', 3),
(1184, 9, NULL, 'ERIKA', 'LLIMA', 'turismo@volarenglobo.com.mx', NULL, '5534502546', 11, 7, 0, 36, 3, '2019-09-28', NULL, NULL, NULL, NULL, NULL, '7 PAX COMPARTIDO BOOKING FULL', NULL, NULL, NULL, NULL, 2, '162.25', 19392.75, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 17:23:20', 3),
(1185, 9, NULL, 'SULY', 'ORELLANA', 'turismo@volarenglobo.com.mx', NULL, '996343118', 11, 3, 0, 36, 3, '2019-10-05', NULL, NULL, NULL, NULL, NULL, '3 PAX COMPARTIDO BOOKING CON TRANSPORTE', NULL, NULL, NULL, NULL, 2, '304.00', 7046.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 17:28:25', 4),
(1186, 9, NULL, 'FRANCO', 'LAINEZ', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, 36, 16, '2019-10-07', NULL, NULL, NULL, NULL, NULL, '2 PAX PRIVADO  BESTDAY ID 73946246-1', NULL, NULL, NULL, NULL, 2, '1200.00', 4800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 17:35:41', 4),
(1187, 14, NULL, 'LORENA ', 'VILLARREAL', 'volarenglobo@yahoo.es', NULL, '593998725623', 35, 2, 0, 36, 1, '2019-09-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '135.00', 1, 0, NULL, 1, NULL, '2019-09-26 18:15:08', 7),
(1188, 16, NULL, 'ANGELA', 'FARIAS', 'Fariasguiang@prodigy.net.mx', NULL, '5519514113', NULL, 4, 0, 36, 2, '2019-09-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet (excepto bÃ¡sico)/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 18:26:20', 6),
(1189, 14, NULL, 'CLAUDIA', 'PARRA', 'volarenglobo@yahoo.es', NULL, '16469059712', 35, 8, 0, 38, 1, '2019-09-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 8 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO Y PASTEL PARA CUMPLEAÃ‘ERO', 'TRANSPORTE RED CENTR', '2800.00', NULL, NULL, 2, '2400.00', 19920.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 18:36:58', 6),
(1190, 16, NULL, 'DANIEL ', 'MARTINEZ', 'reserva@volarenglobo.com.mx', NULL, '5510998008', NULL, 5, 0, 36, 1, '2019-09-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet (excepto bÃ¡sico)/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 14000.00, 0, '400.00', 1, 0, NULL, 1, NULL, '2019-09-26 18:36:59', 4),
(1191, 9, NULL, 'GEORGE', 'HIDALGO', 'turismo@volarenglobo.com.mx', NULL, '593986812600', 11, 2, 0, 36, 1, '2019-09-27', NULL, NULL, NULL, NULL, NULL, '2 PAX INTERCAMBIO INSTAGRAM', NULL, NULL, NULL, NULL, 2, '1200.00', 4400.00, 0, '146.00', 1, 0, NULL, 1, NULL, '2019-09-26 19:00:24', 4),
(1192, 14, '1189', 'CLAUDIA', 'PARRA', 'volarenglobo@yahoo.es', NULL, '16469059712', 35, 8, 0, 38, 1, '2019-09-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 8 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO Y PASTEL PARA CUMPLEAÃ‘ERO', 'TRANSPORTE RED CENTR', '2800.00', NULL, NULL, 2, '2400.00', 19920.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 19:00:25', 3),
(1193, 14, NULL, 'CLAUDIA', 'PARRA', 'volarenglobo@yahoo.es', NULL, '16469059712', 35, 8, 0, 38, 1, '2019-09-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 8 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA DE FELIZ CUMPLEAÃ‘OS, DESAYUNO Y PASTEL PARA CUMPLEAÃ‘ERO', 'TRANSPORTE RED CENTR', '2800.00', NULL, NULL, 2, '2400.00', 19920.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 19:03:38', 6),
(1194, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 19:04:37', 0),
(1195, 16, '1188', 'ANGELA', 'FARIAS', 'Fariasguiang@prodigy.net.mx', NULL, '5519514113', NULL, 3, 0, 36, 2, '2019-09-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet (excepto bÃ¡sico)/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 6000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 19:04:39', 3),
(1196, 14, '1193', 'CLAUDIA', 'PARRA', 'volarenglobo@yahoo.es', NULL, '16469059712', 35, 8, 0, 38, 1, '2019-09-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 8 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA DE FELIZ CUMPLEAÃ‘OS, DESAYUNO Y PASTEL PARA CUMPLEAÃ‘ERO', 'TRANSPORTE RED CENTR', '2800.00', NULL, NULL, 2, '2400.00', 19920.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 20:01:32', 7),
(1197, 16, NULL, 'JUAN CARLOS', 'VIDAL', 'jvidal@aurainteractiva.com', NULL, '5579064844', NULL, 2, 0, 38, 4, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo/ Brindis en vuelo con vino espumoso Freixenet/ Certificado de vuelo/ Seguro viajero/ Desayuno tipo Buffet / TransportaciÃ³n local / Despliegue de lona Feliz Aniversario! / Foto Impresa/ Coffee Break', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '150.00', 1, 0, NULL, 1, NULL, '2019-09-27 10:50:24', 4),
(1198, 16, NULL, 'BLANCA', 'MAYOR', 'reserva@volarenglobo.com.mx', NULL, '573113676286', NULL, 2, 0, 36, 1, '2019-09-30', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet (excepto bÃ¡sico)/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 5600.00, 0, '140.00', 1, 0, NULL, 1, NULL, '2019-09-27 11:08:01', 8),
(1199, 16, '1143', 'ABRAHAM', 'ESPINOZA', 'urielurias@hotmail.com', NULL, '6671255249', NULL, 2, 0, 38, 4, '2019-11-29', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la actividad en TeotihuacÃ¡n\nâ€¢	Despliegue de lona  Feliz Cumple!\nâ€¢	Foto Impresa\nâ€¢	Coffee Break\n', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 11:12:23', 4),
(1200, 14, NULL, 'HORACIO', 'OCHOA', 'volarenglobo@yahoo.es', NULL, '5216621437600', 35, 2, 0, 36, 1, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO.', 'TRANSPORTE ZOCALO', '700.00', NULL, NULL, NULL, '0.00', 5300.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 11:41:19', 6),
(1201, 14, '1200', 'HORACIO', 'OCHOA', 'volarenglobo@yahoo.es', NULL, '5216621437600', 35, 2, 0, 36, 1, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO.', 'TRANSPORTE ZOCALO', '700.00', NULL, NULL, NULL, '0.00', 5300.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 11:43:50', 3),
(1202, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 11:56:28', 6),
(1203, 14, '1202', 'HORACIO', 'OCHOA', 'ventas@volarenglobo.com.mx', NULL, '5216621437600', 35, 2, 0, 36, 1, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE , GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD.', 'TRANSPORTE ZOCALO', '700.00', NULL, NULL, NULL, '0.00', 5300.00, 0, '188.00', 1, 0, NULL, 1, NULL, '2019-09-27 11:58:40', 6),
(1204, 14, NULL, 'CARLA CRISTINA', 'DIXON', 'volarenglobo@yahoo.es', NULL, '50763284728', 35, 2, 0, 36, 1, '2019-10-19', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 12:12:17', 4),
(1205, 14, NULL, 'MARIA', 'LUJAN ANDREETTA', 'volarenglobo@yahoo.es', NULL, '541165152125', 35, 2, 0, 36, 4, '2019-11-21', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE GRAN TEOCALLI Y FOTOGRAFIA IMPRESA A ELEGIR.', 'TRANSPORTE RED COYOA', '1400.00', NULL, NULL, NULL, '0.00', 8400.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 12:31:09', 4),
(1206, 14, NULL, 'ANDREA', 'GUTIERREZ', 'volarenglobo@yahoo.es', NULL, '521987138394', 35, 2, 0, 36, 4, '2019-10-03', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE GRAN TEOCALLI Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '122.00', 1, 0, NULL, 1, NULL, '2019-09-27 12:36:01', 8),
(1207, 11, NULL, 'ADOLFO', 'BENITEZ OLEA', 'selenesanz@hotmail.com', '2227436631', '2481451498', 23, 2, 0, 38, 1, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFEE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD\n', NULL, NULL, NULL, NULL, 2, '1000.00', 3600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 12:46:58', 3),
(1208, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 12:49:03', 0),
(1209, 14, '1171', 'CATE', '.', 'sartoria2@gmail.com', NULL, '1281902276', 35, 7, 0, 73, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'TRADITIONAL SHARED FLIGHT,  HOT AIRE BALLON 7 PAX FOR 45 MINUTES APROX, TOAST WITH SPARKLIN FREIXENET WINE,PERSONALIZED FLIGHT CERTIFICATE,TRANSPORTATION DURING THE ACTIVITY (CHECK IN AREA-TAKE OFF AREA AND LANDING SITE CHECK IN AREA) , TRAVEL INSURANCE, TRANSPORTATION HOTEL - TEOTIHUACAN- HOTEL , TRADITIONAL BREAKFAST IN RESTAURANT GRAN TEOCALLI (BUFFET SERVICE). ', NULL, NULL, NULL, NULL, 2, '2100.00', 18480.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-09-27 12:49:56', 3),
(1210, 16, NULL, 'LUIS', 'OLARTE', 'info@condesaamatlan.com.mx', NULL, '5540681630', NULL, 2, 0, 36, 2, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet (excepto bÃ¡sico)/ Seguro viajero/ Coffee break/transporte redondo ZÃ³calo', NULL, NULL, NULL, NULL, NULL, '0.00', 5000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 13:04:15', 3),
(1211, 16, NULL, 'GERARDO', 'MARTINEZ', 'gerrarmtz@gmail.com', NULL, '5571228493', NULL, 8, 0, NULL, 2, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break ', NULL, NULL, NULL, NULL, NULL, '0.00', 16000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 13:49:52', 4),
(1212, 14, '1203', 'HORACIO', 'OCHOA', 'ventas@volarenglobo.com.mx', NULL, '5216621437600', 35, 2, 0, 36, 1, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE , GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD.', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '188.00', 1, 0, NULL, 1, NULL, '2019-09-27 15:20:11', 4),
(1213, 9, '1124', 'KENNY', 'VEL', 'turismo@volarenglobo.com.mx', NULL, '5523022634', 17, 2, 0, 39, 4, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'CONKETA PEDIDO 4087 Â°VUELO PRIVADO 2 PAX  SOBRE EL VALLE DE TEOTIHUACAN Â°COFFEE BREAK ANTES DE VUELO Â°SEGURO DE VIAJERO Â°DESPLIEGUE DE LONA Â¿TE QUIERES CASAR CONMIGO? Â°BRINDIS CON VINO ESPUMOSO Â°CERTIFICADO PERSONALIZADO Â°DESAYUNO BUFFET Â°FOTO IMPRESA A ELEGIR\n', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '105.00', 1, 0, NULL, 1, NULL, '2019-09-27 15:35:52', 3),
(1214, 9, NULL, 'KEVIN', 'DOMINGUEZ', 'turismo@volarenglobo.com.mx', NULL, '5545037062', 11, 5, 0, 36, 3, '2019-09-29', NULL, NULL, NULL, NULL, NULL, '5 PAX FULL BOOKING', NULL, NULL, NULL, NULL, 2, '838.00', 13387.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 17:45:24', 6),
(1215, 9, NULL, 'GONZALO ALBERTO', 'SABOGAL MORENO', 'turismo@volarenglobo.com.mx', NULL, '3017114695', 11, 2, 0, NULL, 3, '2019-09-28', NULL, NULL, NULL, NULL, NULL, '2 PAX TU EXPERIENCIA', NULL, NULL, NULL, NULL, 2, '200.00', 4700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 18:45:49', 4),
(1216, 9, NULL, 'ERIKA ', 'MURILLO', 'turismo@volarenglobo.com.mx', NULL, '88587774', 11, 2, 0, 36, 3, '2019-09-28', NULL, NULL, NULL, NULL, NULL, '2 PAX TU EXPERIENCIA', NULL, NULL, NULL, NULL, 2, '200.00', 4700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 18:54:08', 4),
(1217, 9, NULL, 'FRANCIS', 'ESCURA', 'turismo@volarenglobo.com.mx', NULL, '33608040757', 35, 2, 0, 36, 3, '2019-09-28', NULL, NULL, NULL, NULL, NULL, '2 PAX FULL BOOKING', NULL, NULL, NULL, NULL, 2, '225.00', 6005.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 18:57:57', 4),
(1218, 16, NULL, 'STEPHANNIE', 'GUTIERREZ', 'ann_star3@hotmail.com', NULL, '5530731480', NULL, 2, 0, 38, 1, '2019-10-11', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona FELIZ CUMPLE!', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '150.00', 1, 0, NULL, 1, NULL, '2019-09-27 19:02:23', 8),
(1219, 11, NULL, 'YERIKENDY', 'CORDOBA PIÃ‘ON', 'yericor@hotmail.com', '5543432304', '5526897235', 17, 2, 0, 36, 1, '2019-10-06', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nINCKUYE 1 CORTESIA SRG', NULL, NULL, NULL, NULL, 2, '2300.00', 2300.00, 0, '130.00', 1, 0, NULL, 1, NULL, '2019-09-29 19:54:32', 8),
(1220, 14, NULL, 'GABRIELA', 'SEQUEIRA', 'volarenglobo@yahoo.es', NULL, '50685800714', 35, 2, 0, 38, 1, '2019-10-25', NULL, NULL, NULL, NULL, NULL, NULL, 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 6848.00, 0, '130.00', 1, 0, NULL, 1, NULL, '2019-09-30 12:50:40', 4),
(1221, 14, NULL, 'DABEGY', 'NOVOA', 'volarenglobo@yahoo.es', NULL, '5528147078', 35, 1, 0, 36, 1, '2019-10-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE,TE, GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD,DESAYUNO BUFFET ', NULL, NULL, NULL, NULL, NULL, '0.00', 2300.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-30 12:52:35', 4),
(1222, 16, NULL, 'JUAN', 'BUSTAMANTE', 'juan.bustamante@loreal.com', NULL, '5510998008', NULL, 62, 0, NULL, 2, '2019-10-14', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 132680.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-30 14:05:41', 3),
(1223, 16, NULL, 'WILLIAMS', 'UGALDE', 'williams1098@hotmail.com', NULL, '50686182027', NULL, 4, 0, 36, 1, '2019-10-24', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona /', NULL, NULL, NULL, NULL, 2, '164.00', 11596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-30 14:19:16', 6),
(1224, 14, NULL, 'CECILIA', 'TREVIÃ‘O', 'volarenglobo@yahoo.es', NULL, '5543569704', 11, 3, 0, 36, 1, '0019-02-21', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 7197.00, 0, '190.00', 1, 0, NULL, 1, NULL, '2019-09-30 14:33:27', 4);
INSERT INTO `temp_volar` (`id_temp`, `idusu_temp`, `clave_temp`, `nombre_temp`, `apellidos_temp`, `mail_temp`, `telfijo_temp`, `telcelular_temp`, `procedencia_temp`, `pasajerosa_temp`, `pasajerosn_temp`, `motivo_temp`, `tipo_temp`, `fechavuelo_temp`, `tarifa_temp`, `hotel_temp`, `habitacion_temp`, `checkin_temp`, `checkout_temp`, `comentario_temp`, `otroscar1_temp`, `precio1_temp`, `otroscar2_temp`, `precio2_temp`, `tdescuento_temp`, `cantdescuento_temp`, `total_temp`, `piloto_temp`, `kg_temp`, `tipopeso_temp`, `globo_temp`, `hora_temp`, `idioma_temp`, `comentarioint_temp`, `register`, `status`) VALUES
(1225, 16, NULL, 'BRENDA BEATRIZ', 'RODRIGUEZ', 'bren_rovergara@hotmail.com', NULL, '5569319660', NULL, 7, 0, 36, 1, '2019-10-06', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / Despliegue de lona', NULL, NULL, NULL, NULL, NULL, '0.00', 16100.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-30 14:53:41', 6),
(1226, 9, '1214', 'KEVIN', 'DOMINGUEZ', 'turismo@volarenglobo.com.mx', NULL, '5545037062', 11, 5, 0, 36, 3, '2019-09-29', NULL, NULL, NULL, NULL, NULL, '5 PAX FULL BOOKING', NULL, NULL, NULL, NULL, 2, '838.00', 13387.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-30 17:33:31', 0),
(1227, 9, '1226', 'KEVIN', 'DOMINGUEZ', 'turismo@volarenglobo.com.mx', NULL, '5545037062', 11, 5, 0, 36, 3, '2019-10-10', NULL, NULL, NULL, NULL, NULL, '5 PAX FULL BOOKING', NULL, NULL, NULL, NULL, 2, '838.00', 13387.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-30 17:36:55', 0),
(1228, 16, NULL, 'MEGHA', 'SINGH', 'meghasingh29@gmail.com', NULL, '5510998008', NULL, 2, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Flight insurance\n- Coffee break\n- Flight of 45 min. to 1 hour\n- Sparkling wine toast\n- Flight certificate\n- Buffet breakfast', NULL, NULL, NULL, NULL, 2, '82.00', 5848.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-09-30 17:42:25', 6),
(1229, 9, NULL, 'KEVIN ', 'DOMINGUEZ', 'turismo@volarenglobo.com.mx', NULL, '5545037062', 11, 5, 0, 36, 3, '2019-10-13', NULL, NULL, NULL, NULL, NULL, '5 PAX COMPARTIDO BOOKING FULL', NULL, NULL, NULL, NULL, 2, '838.00', 13387.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-30 17:46:19', 3),
(1230, 9, NULL, 'KAREN ', 'ACHIGE', 'turismo@volarenglobo.com.mx', NULL, '5543192994', 11, 1, 0, 36, 3, '2019-10-01', NULL, NULL, NULL, NULL, NULL, '1 PAX COMPARTIDO TURISKY', NULL, NULL, NULL, NULL, 2, '400.00', 2050.00, 0, '55.00', 1, 0, NULL, 1, NULL, '2019-09-30 18:38:22', 4),
(1231, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-30 18:41:39', 0),
(1232, 9, NULL, 'JUAN', 'ZAPATA', 'turismo@volarenglobo.com.mx', NULL, '5520594131', 11, 4, 0, 36, 3, '2019-10-01', NULL, NULL, NULL, NULL, NULL, '4 PAX COMPARTIDO TURISKY CON TRANSPORTE', NULL, NULL, NULL, NULL, 2, '1600.00', 8200.00, 0, '267.00', 1, 0, NULL, 1, NULL, '2019-09-30 18:44:55', 4),
(1233, 16, '1228', 'MEGHA', 'SINGH', 'meghasingh29@gmail.com', NULL, '5510998008', NULL, 2, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Flight insurance\n- Coffee break\n- Flight of 45 min. to 1 hour\n- Sparkling wine toast\n- Flight certificate\n- Buffet breakfast', NULL, NULL, NULL, NULL, 2, '82.00', 6848.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-09-30 19:05:15', 3),
(1234, 16, '1223', 'WILLIAMS', 'UGALDE', 'williams1098@hotmail.com', NULL, '50686182027', NULL, 4, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona /', NULL, NULL, NULL, NULL, 2, '164.00', 11596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-01 14:16:37', 4),
(1235, 14, NULL, 'REGINA', 'PICHARDINI', 'volarenglobo@yahoo.es', NULL, '5591081825', 35, 2, 0, 37, 4, '2019-10-06', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA DE ANIVERSARIO, DESAYUNO EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '110.00', 1, 0, NULL, 1, NULL, '2019-10-01 14:25:49', 4),
(1236, 16, '1225', 'BRENDA BEATRIZ', 'RODRIGUEZ', 'bren_rovergara@hotmail.com', NULL, '5569319660', NULL, 6, 0, 36, 1, '2019-10-06', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / Despliegue de lona', NULL, NULL, NULL, NULL, NULL, '0.00', 13800.00, 0, '460.00', 1, 0, NULL, 1, NULL, '2019-10-01 23:00:01', 8),
(1237, 11, NULL, 'CHRISTIN', 'WAGENHAUS', 'christin.wagenhaus@yahoo.de', '491743735003', '4499113679', 2, 5, 0, 38, 1, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nLONA DE FC \n', NULL, NULL, NULL, NULL, NULL, '0.00', 11500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-02 09:57:27', 6),
(1238, 11, '1237', 'CHRISTIN', 'WAGENHAUS', 'christin_wagenhaus@yahoo.de', '491743735003', '4499113679', 2, 5, 0, 38, 1, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nLONA DE FC \n', NULL, NULL, NULL, NULL, NULL, '0.00', 11500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-02 10:04:48', 6),
(1239, 16, NULL, 'GINA', 'ALVAREZ', 'ginalvarez@hotmail.com', NULL, '5540553688', NULL, 2, 0, 36, 1, '2019-10-05', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-02 14:40:25', 3),
(1240, 16, NULL, 'SHARON', 'MUÃ‘OZ', 'sharon.imr@gmail.com', NULL, '573016024972', NULL, 3, 0, 36, 2, '2019-10-03', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', 'PESO EXTRA', '100.00', NULL, NULL, NULL, '0.00', 6520.00, 0, '248.00', 1, 0, NULL, 1, NULL, '2019-10-02 15:00:26', 8),
(1241, 16, NULL, 'ADRIANA', 'BETANCOURT', 'adry_bero@yahoo.com', NULL, '5518441082', NULL, 1, 1, NULL, 1, '2019-10-04', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break /', NULL, NULL, NULL, NULL, NULL, '0.00', 4000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-02 17:10:35', 6),
(1242, 16, '1241', 'ADRIANA', 'BETANCOURT', 'adry_bero@yahoo.com', NULL, '5518441082', NULL, 1, 1, NULL, 1, '2019-10-04', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break /', NULL, NULL, NULL, NULL, 2, '82.00', 4198.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-02 17:14:28', 3),
(1243, 16, NULL, 'MIGUEL', 'ROSSY', 'rossymiguel1@gmail.com', NULL, '17876025041', NULL, 2, 0, NULL, 1, '2019-10-07', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, 2, '82.00', 5798.00, 0, '142.00', 1, 0, NULL, 1, NULL, '2019-10-02 17:17:11', 4),
(1244, 11, NULL, 'ABRIL', 'ESTEBAN', 'abrilstefany@hotmail.com', NULL, '573002518298', 35, 4, 0, 36, 1, '2019-10-10', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFEE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD', NULL, NULL, NULL, NULL, 2, '1200.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-02 17:20:32', 6),
(1245, 9, NULL, 'MARIA CRISTINA', 'FELICIANO APONTE', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 1, 0, 36, 3, '2019-10-03', NULL, NULL, NULL, NULL, NULL, '1 PAX COMPARTIDO BESTDAY ID 73915099-1', NULL, NULL, NULL, NULL, 2, '310.00', 1640.00, 0, '52.00', 1, 0, NULL, 1, NULL, '2019-10-02 18:34:48', 4),
(1246, 9, NULL, 'DILAN DANIEL', 'ARIAS', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 3, 0, 36, 3, '2019-09-04', NULL, NULL, NULL, NULL, NULL, '3 PAX COMPARTIDO PRICE TRAVEL LOCATOR 12976634-1', NULL, NULL, NULL, NULL, 2, '750.00', 5100.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-02 18:49:27', 4),
(1247, 11, '1244', 'ABRIL', 'ESTEBAN', 'abrilstefany@hotmail.com', NULL, '573002518298', 35, 4, 0, 36, 1, '2019-10-10', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFEE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD', NULL, NULL, NULL, NULL, 2, '1200.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-02 21:58:19', 3),
(1248, 11, '1238', 'CHRISTIN', 'WAGENHAUS', 'christin_wagenhaus@yahoo.de', '491743735003', '4499113679', 2, 6, 0, 38, 1, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nLONA DE FC \n', NULL, NULL, NULL, NULL, NULL, '0.00', 13800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-02 22:30:04', 3),
(1249, 14, NULL, 'ULISES', 'MARTINEZ', 'volarenglobo@yahoo.es', NULL, '5528902935', 11, 2, 0, 36, 1, '2019-10-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', NULL, NULL, NULL, NULL, 2, '600.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, 'Nextsasa', '2019-10-03 11:24:23', 4),
(1250, 1, '1026', 'YURIANA', 'QUERO', 'volarenglobo@yahoo.es', NULL, '5580056993', 11, 2, 0, 36, 4, '2019-10-17', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE LOCAL,SEGURO DE VIAJERO,BRINDIS CON VINO ', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-04 08:56:47', 6),
(1251, 1, '1250', 'YURIANA', 'QUERO', 'volarenglobo@yahoo.es', NULL, '5580056993', 11, 2, 0, 36, 4, '2019-10-17', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE LOCAL,SEGURO DE VIAJERO,BRINDIS CON VINO ', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-04 10:33:11', 6),
(1252, 1, '1251', 'YURIANA', 'QUERO', 'volarenglobo@yahoo.es', NULL, '5580056993', 11, 2, 0, 36, 4, '2019-10-17', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE LOCAL,SEGURO DE VIAJERO,BRINDIS CON VINO ', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-04 10:34:23', 6),
(1253, 1, '1252', 'YURIANA', 'QUERO', 'volarenglobo@yahoo.es', NULL, '5580056993', 11, 2, 0, 36, 4, '2019-10-17', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE LOCAL,SEGURO DE VIAJERO,BRINDIS CON VINO ', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-04 10:35:50', 6),
(1254, 1, '1253', 'YURIANA', 'QUERO', 'volarenglobo@yahoo.es', NULL, '5580056993', 11, 2, 0, 36, 4, '2019-10-17', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE LOCAL,SEGURO DE VIAJERO,BRINDIS CON VINO ', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-04 10:37:02', 6),
(1255, 1, '1254', 'YURIANA', 'QUERO', 'volarenglobo@yahoo.es', NULL, '5580056993', 11, 2, 0, 36, 4, '2019-10-17', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE LOCAL,SEGURO DE VIAJERO,BRINDIS CON VINO ', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-10-04 10:37:58', 6),
(1256, 1, '1255', 'YURIANA', 'QUERO', 'volarenglobo@yahoo.es', NULL, '5580056993', 11, 2, 0, 36, 4, '2019-10-17', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE LOCAL,SEGURO DE VIAJERO,BRINDIS CON VINO ', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-10-04 11:05:31', 6),
(1257, 1, '1256', 'YURIANA', 'QUERO', 'volarenglobo@yahoo.es', NULL, '5580056993', 11, 2, 0, 36, 4, '2019-10-17', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE LOCAL,SEGURO DE VIAJERO,BRINDIS CON VINO ', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 2, 'aaaa', '2019-10-04 11:06:43', 6),
(1258, 1, '1257', 'YURIANA', 'QUERO', 'volarenglobo@yahoo.es', NULL, '5580056993', 11, 2, 0, 36, 4, '2019-10-17', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE LOCAL,SEGURO DE VIAJERO,BRINDIS CON VINO ', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 2, 'Ejemplo', '2019-10-04 11:06:56', 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventasserv_volar`
--

CREATE TABLE `ventasserv_volar` (
  `id_vsv` int(11) NOT NULL COMMENT 'Llave Primaria',
  `idserv_vsv` int(11) DEFAULT NULL COMMENT 'Servicio',
  `idventa_vsv` int(11) DEFAULT NULL COMMENT 'Venta',
  `cantidad_vsv` int(11) DEFAULT NULL COMMENT 'Cantidad',
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Status'
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
(10, 11, 11, 2, '2019-08-06 22:24:34', 1),
(11, 38, 12, 1, '2019-09-26 13:09:11', 1),
(12, 38, 13, 2, '2019-09-26 13:10:22', 1),
(13, 7, 14, 2, '2019-09-26 13:12:16', 1),
(14, 8, 14, 2, '2019-09-26 13:12:16', 1),
(15, 7, 15, 7, '2019-09-27 12:33:20', 1),
(16, 8, 15, 1, '2019-09-27 12:33:20', 1),
(17, 16, 16, 5, '2019-09-27 12:36:32', 1),
(18, 38, 17, 7, '2019-09-27 12:44:36', 1),
(19, 38, 18, 1, '2019-09-28 17:05:46', 1),
(20, 38, 19, 1, '2019-09-28 17:06:35', 1),
(21, 38, 20, 1, '2019-09-28 17:07:22', 1),
(22, 38, 21, 1, '2019-09-28 17:07:58', 1),
(23, 38, 22, 1, '2019-09-28 17:09:40', 1),
(24, 7, 23, 1, '2019-09-28 17:10:31', 1),
(25, 16, 24, 1, '2019-09-28 17:11:12', 1),
(26, 16, 25, 1, '2019-09-28 17:11:49', 1),
(27, 7, 26, 1, '2019-09-28 17:13:36', 1),
(28, 16, 26, 1, '2019-09-28 17:13:36', 1),
(29, 7, 27, 1, '2019-09-28 17:14:54', 1),
(30, 16, 27, 1, '2019-09-28 17:14:54', 1),
(31, 7, 28, 1, '2019-09-28 17:16:23', 1),
(32, 16, 28, 1, '2019-09-28 17:16:23', 1),
(33, 38, 29, 1, '2019-09-28 17:17:10', 1),
(34, 38, 30, 1, '2019-09-28 17:17:43', 1),
(35, 38, 31, 2, '2019-09-28 17:18:30', 1),
(36, 16, 32, 1, '2019-09-28 17:19:13', 1),
(37, 16, 33, 1, '2019-09-28 17:19:53', 1),
(38, 7, 34, 1, '2019-09-28 17:20:44', 1),
(39, 16, 35, 1, '2019-09-28 17:21:17', 1),
(40, 38, 36, 1, '2019-09-28 17:21:41', 1),
(41, 16, 37, 2, '2019-09-28 17:22:35', 1),
(42, 7, 38, 1, '2019-09-28 17:23:31', 1),
(43, 16, 38, 1, '2019-09-28 17:23:31', 1),
(44, 7, 39, 1, '2019-10-01 10:35:39', 1),
(45, 7, 40, 1, '2019-10-02 15:41:50', 1),
(46, 16, 40, 1, '2019-10-02 15:41:50', 1),
(47, 7, 41, 1, '2019-10-02 15:42:31', 1),
(48, 16, 41, 1, '2019-10-02 15:42:31', 1),
(49, 7, 42, 1, '2019-10-02 15:43:41', 1),
(50, 16, 43, 1, '2019-10-02 15:44:42', 1),
(51, 38, 44, 2, '2019-10-02 15:46:33', 1),
(52, 38, 45, 1, '2019-10-02 15:49:43', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas_volar`
--

CREATE TABLE `ventas_volar` (
  `id_venta` int(11) NOT NULL COMMENT 'Llave Primaria',
  `idusu_venta` int(11) NOT NULL COMMENT 'Usuario',
  `comentario_venta` text COLLATE utf8_spanish_ci COMMENT 'Comentario',
  `otroscar1_venta` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Otros Cargos',
  `precio1_venta` double(10,2) DEFAULT NULL COMMENT 'Precio',
  `otroscar2_venta` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Otros Cargos',
  `precio2_venta` double(10,2) DEFAULT NULL COMMENT 'Precio',
  `tipodesc_venta` tinyint(4) DEFAULT NULL COMMENT 'Tipo de Descuento',
  `cantdesc_venta` double(10,2) DEFAULT NULL COMMENT 'Cantidad de Descuento',
  `pagoefectivo_venta` double(10,2) DEFAULT NULL COMMENT 'Efectivo',
  `pagotarjeta_venta` double(10,2) DEFAULT NULL COMMENT 'Tarjeta',
  `total_venta` double(10,2) DEFAULT NULL COMMENT 'Total',
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Ventas de CItio';

--
-- Volcado de datos para la tabla `ventas_volar`
--

INSERT INTO `ventas_volar` (`id_venta`, `idusu_venta`, `comentario_venta`, `otroscar1_venta`, `precio1_venta`, `otroscar2_venta`, `precio2_venta`, `tipodesc_venta`, `cantdesc_venta`, `pagoefectivo_venta`, `pagotarjeta_venta`, `total_venta`, `register`, `status`) VALUES
(10, 1, 'prueba servicios', NULL, NULL, NULL, NULL, NULL, NULL, 300.00, 3000.00, 3300.00, '2019-08-06 22:16:35', 1),
(11, 1, 'Aqui va un comentario muy grande para poner la descripciÃ³n de la venta qeu se acaba de realiazar desde el sitio por alguien que se encuentre por ahi ', NULL, NULL, NULL, NULL, NULL, NULL, 500.00, 11230.00, 11730.00, '2019-08-06 22:24:33', 1),
(12, 18, '2  126 IMAN MADERA 150\n1 138 LLAVERO FIBRA 100', NULL, NULL, NULL, NULL, 1, 100.00, 400.00, NULL, 400.00, '2019-09-26 13:09:11', 1),
(13, 18, '2 149 FOTOS TIERRA', NULL, NULL, NULL, NULL, 1, 400.00, NULL, 600.00, 600.00, '2019-09-26 13:10:22', 1),
(14, 18, '2 158 FOTO Y VIDEO 1,000', NULL, NULL, NULL, NULL, NULL, NULL, 2000.00, NULL, 2000.00, '2019-09-26 13:12:16', 1),
(15, 18, '6 140 FOTOS MICRO SD\n1 158 FOTOS Y VIDEO EN MICRO SD', NULL, NULL, NULL, NULL, NULL, NULL, 3500.00, 500.00, 4000.00, '2019-09-27 12:33:20', 1),
(16, 18, '9 145 FOTO IMPRESA POSTAL', NULL, NULL, NULL, NULL, 1, 100.00, 700.00, 200.00, 900.00, '2019-09-27 12:36:32', 1),
(17, 18, '2 056 GORRA 150\n2 056 GORRA 200\n4 138 LLAVERO FIBRA 100\n7 126 IMÃN MADERA 150\n4 127 IMÃN MADERA CH 100\n1 007 BARRO GLOBO 100\n2 124 BOLSA VINIL 200', NULL, NULL, NULL, NULL, 1, 450.00, 2600.00, 450.00, 3050.00, '2019-09-27 12:44:36', 1),
(18, 18, '1 138 LAVERO FIBRA 100\n1 127 IMAN MADERA CH 100', NULL, NULL, NULL, NULL, 1, 300.00, 200.00, NULL, 200.00, '2019-09-28 17:05:46', 1),
(19, 18, '1 047 TENDEDERO CH 250', NULL, NULL, NULL, NULL, 1, 250.00, NULL, 250.00, 250.00, '2019-09-28 17:06:35', 1),
(20, 18, '1 065 GLOBO VGAP 300', NULL, NULL, NULL, NULL, 1, 200.00, 300.00, NULL, 300.00, '2019-09-28 17:07:22', 1),
(21, 18, '1 065 GLOBO VGAP 300', NULL, NULL, NULL, NULL, 1, 200.00, NULL, 300.00, 300.00, '2019-09-28 17:07:58', 1),
(22, 18, '1 127 IMAN CH 100', NULL, NULL, NULL, NULL, 1, 400.00, NULL, 100.00, 100.00, '2019-09-28 17:09:40', 1),
(23, 18, '1 140 FOROS MICRO SD', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 500.00, 500.00, '2019-09-28 17:10:31', 1),
(24, 18, '1 145 FOTO POSTAL 100', NULL, NULL, NULL, NULL, 1, 100.00, NULL, 100.00, 100.00, '2019-09-28 17:11:12', 1),
(25, 18, '1 155 FOTO IMPRESA INCLUIDA', NULL, NULL, NULL, NULL, 1, 200.00, NULL, NULL, 0.00, '2019-09-28 17:11:49', 1),
(26, 18, '1 140 FOTOS MICRO SD \n1 145 FOTO POSTAL 100', NULL, NULL, NULL, NULL, 1, 100.00, NULL, 600.00, 600.00, '2019-09-28 17:13:36', 1),
(27, 18, '1 145 FOTO POSTAL \n1 140 FOTOS MICRO SD ', NULL, NULL, NULL, NULL, 1, 100.00, 600.00, NULL, 600.00, '2019-09-28 17:14:54', 1),
(28, 18, '1 140 FOTOS MICRO SD\n2 145 FOTO POSTAL ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 700.00, 700.00, '2019-09-28 17:16:23', 1),
(29, 18, '1 149 FOROS MICRO SD', NULL, NULL, NULL, NULL, 1, 200.00, NULL, 300.00, 300.00, '2019-09-28 17:17:10', 1),
(30, 18, '1 147 FOTO DIGITAL', NULL, NULL, NULL, NULL, 1, 400.00, 100.00, NULL, 100.00, '2019-09-28 17:17:43', 1),
(31, 18, '2 140 FOTOS MICRO SD ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1000.00, 1000.00, '2019-09-28 17:18:30', 1),
(32, 18, '2 145 FOTO POSTAL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 200.00, 200.00, '2019-09-28 17:19:13', 1),
(33, 18, '1 155 FOTO IMPRESA INCLUIDA', NULL, NULL, NULL, NULL, 1, 200.00, NULL, NULL, 0.00, '2019-09-28 17:19:53', 1),
(34, 18, '1 140 FOTOS MICRO SD', NULL, NULL, NULL, NULL, NULL, NULL, 500.00, NULL, 500.00, '2019-09-28 17:20:44', 1),
(35, 18, '1 145 FOTO POSTAL ', NULL, NULL, NULL, NULL, 1, 100.00, 100.00, NULL, 100.00, '2019-09-28 17:21:17', 1),
(36, 18, '2 014 ARETES ', NULL, NULL, NULL, NULL, 1, 400.00, 100.00, NULL, 100.00, '2019-09-28 17:21:41', 1),
(37, 18, '2 146 FOTOS ENMARCADAS ', NULL, NULL, NULL, NULL, 1, 100.00, 300.00, NULL, 300.00, '2019-09-28 17:22:35', 1),
(38, 18, '1 140 FOTOS MICRO SD\n1 145 FOTO POSTAL', NULL, NULL, NULL, NULL, 1, 100.00, 600.00, NULL, 600.00, '2019-09-28 17:23:31', 1),
(39, 18, '1 149 FOTOS TIERRA\n1 155 FOTO IMPRESA INCLUIDA', NULL, NULL, NULL, NULL, 1, 200.00, 300.00, NULL, 300.00, '2019-10-01 10:35:39', 1),
(40, 18, '1 140 FOTOSMICRO SD\n1 145 FOTO POSTAL', NULL, NULL, NULL, NULL, 1, 100.00, 600.00, NULL, 600.00, '2019-10-02 15:41:50', 1),
(41, 18, '1 140 FOTOS MICRO SD\n1 145 FOTO POSTAL', NULL, NULL, NULL, NULL, 1, 100.00, NULL, 600.00, 600.00, '2019-10-02 15:42:31', 1),
(42, 18, '1 149 FOTOS TIERRA', NULL, NULL, NULL, NULL, 1, 200.00, NULL, 300.00, 300.00, '2019-10-02 15:43:41', 1),
(43, 18, '1 155 FOTO IMPRESA INCLUIDA', NULL, NULL, NULL, NULL, 1, 200.00, NULL, NULL, 0.00, '2019-10-02 15:44:42', 1),
(44, 18, '1 007 BARRO GLOBO\n2 127 IMAN MADERA CH\n2 138 LLAVERO FRIBRA\n2 072 LLAVERO KEY', NULL, NULL, NULL, NULL, 1, 400.00, 600.00, NULL, 600.00, '2019-10-02 15:46:33', 1),
(45, 18, '1 091 PORTARETRATO LIZ\n1 037 ALAJERO', NULL, NULL, NULL, NULL, 1, 100.00, NULL, 400.00, 400.00, '2019-10-02 15:49:43', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `volar_usuarios`
--

CREATE TABLE `volar_usuarios` (
  `id_usu` int(4) NOT NULL COMMENT 'Llave Primaria',
  `nombre_usu` varchar(50) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Nombre',
  `apellidop_usu` varchar(50) COLLATE utf8_spanish_ci NOT NULL COMMENT 'Apellido Paterno',
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
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `volar_usuarios`
--

INSERT INTO `volar_usuarios` (`id_usu`, `nombre_usu`, `apellidop_usu`, `apellidom_usu`, `depto_usu`, `puesto_usu`, `correo_usu`, `telefono_usu`, `contrasena_usu`, `usuario_usu`, `nss_usu`, `sd_usu`, `sdi_usu`, `fiscal_usu`, `isr_usu`, `imss_usu`, `infonavit_usu`, `subsidio_usu`, `quincenal_usu`, `complemento_usu`, `falta_usu`, `banco_usu`, `cuenta_usu`, `register`, `status`) VALUES
(1, 'ENRIQUE', 'DAMASCO', 'ALDUCIN', 1, 1, 'enriquealducin@volarenglobo.com.mx', '5529227672', 'c4ca4238a0b923820dcc509a6f75849b', 'Quique', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-29 23:20:06', 1),
(3, 'SONIA', 'ALDUCIN', 'GUAJARDO', 3, 3, 'contabilidad@volarenglobo.com.mx', '5568177013', '86cd30166d3e74003ae788951843b8cd', 'sony', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 09:27:49', 1),
(8, 'RICARDO', 'CRUZ', 'ROCHA', 7, 17, 'ricardo@volarenglobo.com.mx', '5551068115', 'c899a91880ee511c03f5810cf9eaa022', 'Ricardo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 16:34:09', 1),
(9, 'ALEJANDRA', 'RAMIREZ', 'SERRANO', 5, 15, 'turismo@volarenglobo.com.mx', '5530704317', '746034988c74912ec9ca4b11cebfa5c4', 'turismo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 16:35:26', 1),
(11, 'SERGIO', 'RAMIREZ', 'GARCIA', 5, 7, 'sergio@volarenglobo.com.mx', '5555023615', '202cb962ac59075b964b07152d234b70', 'Sergio', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 07:52:34', 1),
(14, 'ALEJANDRA', 'MONTES DE OCA', 'FEREGRINO', 8, 13, 'ventas@volarenglobo.com.mx', '5524900000', '9c779f56f336b3c812343434f57b6a0e', 'alemonts', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-22 18:14:20', 1),
(15, 'CHRSITOFFER MICHELLE', 'OLIVIA', 'HERNANDEZ', 7, 17, 'auxiliar@volarenglobo.com.mx', '5545935376', '944facfeb153b4f01916a0f166fcc315', 'Chris', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-22 18:54:31', 1),
(16, 'SUSANA', 'SALAZAR', 'VIQUEZ', 8, 13, 'reserva@volarenglobo.com.mx', '5510998008', '8ef747720bc83aed6640295831a32d83', 'reserva', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-02 14:39:09', 1),
(17, 'ANA MARIA', 'ROCHA', 'MUÃ‘OZ', 3, 21, 'contabilidad@volarenglobo.com.mx', '5539773436', '807b9be210ec6018b61f32498bd5abab', 'anny', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 12:34:03', 1),
(18, 'MARIA DE JESUS', 'SORIANO', 'AGUILAR', 4, 12, 'admonteoti@volarenglobo.com.mx', '5560233534', 'c6e04c6343a907c961108fef4a8199dd', 'marichuy', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-18 19:02:11', 1),
(19, 'SERGIO', 'RAMIREZ', 'SERRANO', 4, 12, 'zergio@volarenglobo.com.mx', '5530203538', 'dbf2f270d829e1e31e59a8e39ca6b24a', 'zergioram', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-19 07:48:32', 1);

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
  `register` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `vueloscat_volar`
--

INSERT INTO `vueloscat_volar` (`id_vc`, `nombre_vc`, `tipo_vc`, `precioa_vc`, `precion_vc`, `register`, `status`) VALUES
(1, 'Compartido Normal', 47, '2300.00', '1700.00', '2019-04-05 11:03:46', 1),
(2, 'Compartido Promo 1', 47, '2000.00', '1700.00', '2019-04-05 11:03:46', 1),
(3, 'Compartido Operador', 47, '1950.00', '1700.00', '2019-04-05 11:04:31', 1),
(4, 'Privado Normal', 46, '3500.00', '1800.00', '2019-04-05 11:28:14', 1),
(5, 'Privado Promo 1', 46, '3250.00', '1800.00', '2019-04-05 11:28:53', 1),
(14, ' preuba', 47, '43.00', '22.00', '2019-04-09 12:52:38', 0),
(15, ' prueba35', 47, '3.00', '2.00', '2019-04-09 12:56:06', 0),
(16, 'Privado Operador', 46, '3000.00', '1800.00', '2019-06-05 23:06:53', 1),
(17, 'Prueba online', 47, '150.00', '110.00', '2019-08-28 01:11:55', 0);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `bitacora_actualizaciones_volar`
--
ALTER TABLE `bitacora_actualizaciones_volar`
  ADD PRIMARY KEY (`id_bit`);

--
-- Indices de la tabla `bitcomentarios_volar`
--
ALTER TABLE `bitcomentarios_volar`
  ADD PRIMARY KEY (`id_bc`);

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
-- Indices de la tabla `reprogramaciones_volar`
--
ALTER TABLE `reprogramaciones_volar`
  ADD PRIMARY KEY (`id_rep`);

--
-- Indices de la tabla `restaurantes_volar`
--
ALTER TABLE `restaurantes_volar`
  ADD PRIMARY KEY (`id_restaurant`);

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
-- AUTO_INCREMENT de la tabla `bitcomentarios_volar`
--
ALTER TABLE `bitcomentarios_volar`
  MODIFY `id_bc` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `bitpagos_volar`
--
ALTER TABLE `bitpagos_volar`
  MODIFY `id_bp` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=160;

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
  MODIFY `id_extra` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=98;

--
-- AUTO_INCREMENT de la tabla `gastos_volar`
--
ALTER TABLE `gastos_volar`
  MODIFY `id_gasto` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `globos_volar`
--
ALTER TABLE `globos_volar`
  MODIFY `id_globo` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `habitaciones_volar`
--
ALTER TABLE `habitaciones_volar`
  MODIFY `id_habitacion` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de la tabla `hoteles_volar`
--
ALTER TABLE `hoteles_volar`
  MODIFY `id_hotel` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `imghoteles_volar`
--
ALTER TABLE `imghoteles_volar`
  MODIFY `id_img` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria';

--
-- AUTO_INCREMENT de la tabla `permisosusuarios_volar`
--
ALTER TABLE `permisosusuarios_volar`
  MODIFY `id_puv` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=448;

--
-- AUTO_INCREMENT de la tabla `permisos_volar`
--
ALTER TABLE `permisos_volar`
  MODIFY `id_per` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `puestos_volar`
--
ALTER TABLE `puestos_volar`
  MODIFY `id_puesto` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=22;

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
-- AUTO_INCREMENT de la tabla `reprogramaciones_volar`
--
ALTER TABLE `reprogramaciones_volar`
  MODIFY `id_rep` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `restaurantes_volar`
--
ALTER TABLE `restaurantes_volar`
  MODIFY `id_restaurant` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `servicios_volar`
--
ALTER TABLE `servicios_volar`
  MODIFY `id_servicio` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT de la tabla `servicios_vuelo_temp`
--
ALTER TABLE `servicios_vuelo_temp`
  MODIFY `id_sv` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=2758;

--
-- AUTO_INCREMENT de la tabla `subpermisos_volar`
--
ALTER TABLE `subpermisos_volar`
  MODIFY `id_sp` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=88;

--
-- AUTO_INCREMENT de la tabla `temp_volar`
--
ALTER TABLE `temp_volar`
  MODIFY `id_temp` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=1259;

--
-- AUTO_INCREMENT de la tabla `ventasserv_volar`
--
ALTER TABLE `ventasserv_volar`
  MODIFY `id_vsv` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT de la tabla `ventas_volar`
--
ALTER TABLE `ventas_volar`
  MODIFY `id_venta` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT de la tabla `volar_usuarios`
--
ALTER TABLE `volar_usuarios`
  MODIFY `id_usu` int(4) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `vueloscat_volar`
--
ALTER TABLE `vueloscat_volar`
  MODIFY `id_vc` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=18;

DELIMITER $$
--
-- Eventos
--
CREATE EVENT `cancelarReservasSinCot` ON SCHEDULE EVERY 1 MINUTE STARTS '2019-09-03 12:29:00' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE temp_volar set status=0 where status=2$$

CREATE EVENT `cancelaReservas` ON SCHEDULE EVERY 1 DAY STARTS '2019-08-28 01:47:37' ON COMPLETION PRESERVE ENABLE COMMENT 'Cancelar reservas que tengan mas de 30 dias' DO Update temp_volar set status = 0 where  fechavuelo_temp < DATE_SUB(NOW(), INTERVAL 30 DAY) and status not in(1,7)$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
