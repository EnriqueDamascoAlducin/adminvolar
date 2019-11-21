-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 20-11-2019 a las 20:14:13
-- Versión del servidor: 10.4.6-MariaDB
-- Versión de PHP: 7.1.31

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
CREATE  PROCEDURE `actualizarDireccionesRestaurantes` (IN `_hotel` INT, IN `_nombre` VARCHAR(150), IN `_precion` DECIMAL(10,2), IN `_precioa` DECIMAL(10,2), IN `_restaurant` INT, OUT `respuesta` VARCHAR(15))  BEGIN
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
	Select id_temp, idusu_temp, IFNULL(clave_temp,"") as clave_temp, IFNULL(nombre_temp,"") as nombre_temp, IFNULL(apellidos_temp,"") as apellidos_temp, IFNULL(mail_temp,"") as mail_temp, IFNULL(telfijo_temp,"") as telfijo_temp, IFNULL(telcelular_temp,"") as telcelular_temp, IFNULL(procedencia_temp,"") as procedencia_temp, IFNULL(pasajerosa_temp,"") as pasajerosa_temp,IFNULL(pasajerosn_temp,"0") as pasajerosn_temp, IFNULL(motivo_temp,"") as motivo_temp, IFNULL(tipo_temp,"0") as tipo_temp,  IFNULL(fechavuelo_temp,"") as fechavuelo_temp,  IFNULL(tarifa_temp,"") as tarifa_temp, IFNULL(hotel_temp,"") as hotel_temp,  IFNULL(habitacion_temp,"") as habitacion_temp,  IFNULL(checkin_temp,"") as checkin_temp,IFNULL(checkout_temp,"") as checkout_temp,IFNULL(comentario_temp,"") as comentario_temp, IFNULL(otroscar1_temp,"") as otroscar1_temp, IFNULL(otroscar2_temp,"") as otroscar2_temp, IFNULL(precio1_temp,"") as precio1_temp,
IFNULL(precio2_temp,"") as precio2_temp, IFNULL(tdescuento_temp,"") as tdescuento_temp, IFNULL(cantdescuento_temp,"") as cantdescuento_temp, IFNULL(total_temp,"") as total_temp, IFNULL(piloto_temp,"") as piloto_temp, IFNULL(kg_temp,"") as kg_temp, IFNULL(globo_temp,"") AS globo_temp, IFNULL(hora_temp,"") as hora_temp,idioma_temp,tipopeso_temp,comentarioint_temp, register,status
from temp_volar
Where id_temp = _reserva and tipo_temp is not null and fechavuelo_temp is not null ;
END$$

CREATE  PROCEDURE `getResumenREserva` (IN `_reserva` BIGINT)  BEGIN
SELECT IFNULL((SELECT nombre_extra from extras_volar where id_extra=tv.motivo_temp),'') as motivo,IFNULL(comentario_temp,'') as comentario,ifnull(pasajerosa_temp,0) as pasajerosA , ifnull(pasajerosn_temp,0) as pasajerosN , IFNULL(habitacion_temp,'') as habitacion, tipo_temp, checkin_temp,checkout_temp, IFNULL(precio1_temp,0) as precio1, IFNULL(precio2_temp,0) as precio2, IFNULL(tdescuento_temp,'') as tdescuento, IFNULL(cantdescuento_temp,0) as cantdescuento, IFNULL(otroscar1_temp,'') as otroscar1,IFNULL(otroscar2_temp,'') as otroscar2,
IFNULL((SELECT IFNULL( nombre_hotel,'') as hotel FROM hoteles_volar where id_hotel=tv.hotel_temp),'') as hotel,
IFNULL((SELECT CONCAT(IFNULL(nombre_habitacion,''),'|', IFNULL(precio_habitacion,0) ,'|', IFNULL(capacidad_habitacion,0)  ,'|', IFNULL(descripcion_habitacion,'')  ) as Habitaciones FROM habitaciones_volar WHERE id_habitacion=tv.habitacion_temp),'') as habitacion,
IFNULL(fechavuelo_temp,'Fecha No Asignada') as fechavuelo, CONCAT(IFNULL(nombre_temp,''),' ', IFNULL(apellidos_temp,'')) as nombre, IFNULL(mail_temp,'') as correo, CONCAT(IFNULL(telfijo_temp,''),' <br> ', IFNULL(telcelular_temp,'')) as telefonos, nombre_vc as tipoVuelo, precion_vc as precioN, precioa_vc as precioA,idioma_temp,tipopeso_temp,comentarioint_temp
FROM temp_volar tv  INNER JOIN vueloscat_volar vcv on vcv.id_vc = tv.tipo_temp
Where id_temp= _reserva;
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

CREATE  PROCEDURE `registrarComentario` (IN `_comentario` TEXT, IN `_idusu` INT, IN `_reserva` INT, OUT `respuesta` VARCHAR(15))  BEGIN
	UPDATE bitcomentarios_volar set status = 2 where idtemp_bc = _reserva;
    INSERT INTO bitcomentarios_volar(idusu_bc,idtemp_bc,comentariop_bc,comentarion_bc)
    SELECT _idusu, _reserva, comentarioint_temp,_comentario from temp_volar where id_temp = _reserva;
    UPDATE temp_volar set comentarioint_temp = _comentario where id_temp = _reserva;
    set respuesta = 'Actualizado';
END$$

CREATE  PROCEDURE `registrarHabitacionHotel` (IN `_hotel` INT, IN `_nombre` VARCHAR(150), IN `_precion` DECIMAL(10,2), IN `_precioa` DECIMAL(10,2), OUT `lid` VARCHAR(15))  BEGIN
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

CREATE  PROCEDURE `registrarPago` (IN `_pago` BIGINT, IN `_reserva` BIGINT, IN `_usuario` INT, IN `_metodo` INT, IN `_banco` INT, IN `_referencia` VARCHAR(200), IN `_cantidad` DOUBLE(10,2), IN `_fechaPago` VARCHAR(30), IN `_usuarioCOncilia` INT, IN `_comision` TINYINT, IN `_cupon` TINYINT, IN `_moneda` INT, IN `_preciomoneda` DOUBLE(10,2), OUT `respuesta` VARCHAR(25))  BEGIN
IF(SELECT COUNT(id_bp) as pagos from bitpagos_volar  where idres_bp=_reserva )>0 THEN
    IF (SELECT (ifnull(sum(cantidad_bp),0)+ _cantidad ) from bitpagos_volar where idres_bp=_reserva and status<>0 )>(Select total_temp FROM temp_volar where id_temp  = _reserva) THEN
        SET respuesta = 'ERROR EN PAGO';
    ELSEIF (_usuarioConcilia=0) THEN
        INSERT INTO bitpagos_volar (idres_bp,idreg_bp,metodo_bp,banco_bp,referencia_bp,cantidad_bp,fecha_bp,comision_bp,cupon_bp,moneda_bp,preciomoneda_bp) VALUES (_reserva,_usuario,_metodo,_banco,_referencia,_cantidad,_fechaPago,_comision,_cupon,_moneda,_preciomoneda);
        SET respuesta = CONCAT('Registrado|',LAST_INSERT_ID());
        IF(_banco=83) THEN
            UPDATE bitpagos_volar set status = 2 WHERE id_bp = LAST_INSERT_ID();
              IF (SELECT (sum(cantidad_bp) ) from bitpagos_volar where idres_bp in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID()) )=(Select total_temp FROM temp_volar where id_temp  in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID())) THEN
                  UPDATE temp_volar set status = 8 WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID());
              ELSE
                  UPDATE temp_volar set status = 8 WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID());
              END IF;
        END IF;
    ELSE
        UPDATE bitpagos_volar SET idconc_bp=_usuarioCOncilia, fechaconc_bp= CURRENT_TIMESTAMP, status = 3 WHERE id_bp = _pago;
        SET respuesta = 'Conciliado';
          IF (SELECT (sum(cantidad_bp)+ _cantidad ) from bitpagos_volar where idres_bp in (SELECT idres_bp from bitpagos_volar where id_bp = _pago) )=(Select total_temp FROM temp_volar where id_temp  in (SELECT idres_bp from bitpagos_volar where id_bp = _pago)) THEN
              UPDATE temp_volar set status = 8  WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp =  _pago);
          ELSE
              UPDATE temp_volar set status = 4 WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp =  _pago);
          END IF;
    END IF;

  ELSEIF(SELECT total_temp from temp_volar where id_temp=_reserva) < _cantidad THEN
    SET respuesta = 'ERROR EN PAGO';

  ELSE
    INSERT INTO bitpagos_volar (idres_bp,idreg_bp,metodo_bp,banco_bp,referencia_bp,cantidad_bp,fecha_bp,comision_bp,cupon_bp,moneda_bp,precio_bp,preciomoneda_bp) VALUES (_reserva,_usuario,_metodo,_banco,_referencia,_cantidad,_fechaPago,_comision,_cupon,_moneda,_preciomoneda);
    SET respuesta = CONCAT('Registrado|',LAST_INSERT_ID());

    IF(_banco=83) THEN
        UPDATE bitpagos_volar set status = 2 WHERE id_bp = LAST_INSERT_ID();
          IF (SELECT (sum(cantidad_bp) ) from bitpagos_volar where status<> 0 and idres_bp in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID()) )=(Select total_temp FROM temp_volar where id_temp  in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID())) THEN
              UPDATE temp_volar set status = 8 WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID());
          ELSE
              UPDATE temp_volar set status = 8 WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID());
          END IF;
    END IF;
  END IF;
END$$

CREATE  PROCEDURE `registrarReserva` (IN `_idusu` INT, OUT `lid` BIGINT)  BEGIN
	Insert INTO temp_volar (idusu_temp) VALUES(_idusu);
   	SET lid =  LAST_INSERT_ID();
END$$

CREATE  PROCEDURE `registrarRestaurantHotel` (IN `_hotel` INT, IN `_nombre` VARCHAR(250), IN `_precion` DECIMAL(10,2), IN `_precioa` DECIMAL(10,2), OUT `LID` INT)  BEGIN
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

CREATE  PROCEDURE `registrarServicioVta` (IN `servicio` INT, IN `venta` BIGINT, IN `cantidad` INT, OUT `respuesta` VARCHAR(20))  BEGIN
	INSERT INTO ventasserv_volar (idserv_vsv,idventa_vsv,cantidad_vsv) VALUES (servicio,venta,cantidad);
    SET respuesta = 'Venta Registrada';
END$$

CREATE  PROCEDURE `registrarUsuario` (IN `idusu` INT, IN `nombre` VARCHAR(200), IN `apellidop` VARCHAR(200), IN `apellidom` VARCHAR(200), IN `depto` INT, IN `puesto` INT, IN `correo` VARCHAR(250), IN `telefono` VARCHAR(14), IN `contrasena` VARCHAR(200), IN `usuario` VARCHAR(200), OUT `respuesta` VARCHAR(20))  BEGIN
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

CREATE  PROCEDURE `registroVenta` (IN `usuario` INT, IN `comentario` TEXT, IN `otroscar1` VARCHAR(250), IN `precio1` DOUBLE(10,2), IN `otroscar2` VARCHAR(250), IN `precio2` DOUBLE(10,2), IN `tipodesc` INT, IN `cantdesc` DOUBLE(10,2), IN `pagoefectivo` DOUBLE(10,2), IN `pagotarjeta` DOUBLE(10,2), IN `total` DOUBLE(10,2), IN `cupon` DOUBLE(10,2), IN `moneda` INT, IN `preciomoneda` INT, OUT `LID` INT)  BEGIN
	INSERT INTO ventas_volar (idusu_venta,comentario_venta,otroscar1_venta,precio1_venta,otroscar2_venta,precio2_venta,tipodesc_venta,cantdesc_venta,pagoefectivo_venta,pagotarjeta_venta,total_venta,pagocupon_venta,tipomoneda_venta , preciomoneda_venta) VALUES (usuario,comentario,otroscar1,precio1,otroscar2,precio2,tipodesc,cantdesc,pagoefectivo,pagotarjeta,total,cupon,moneda,preciomoneda);
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

CREATE  PROCEDURE `remplazarServiciosReservas` (IN `_reserva` BIGINT, IN `_oldReserva` BIGINT)  BEGIN
	INSERT INTO servicios_vuelo_temp
		(idservi_sv,tipo_sv,cantidad_sv,status)
		SELECT idservi_sv,tipo_sv,cantidad_sv,status from servicios_vuelo_temp where idtemp_sv =_oldReserva;
        UPDATE servicios_vuelo_temp set idtemp_sv = _reserva where idtemp_sv is null;
END$$

CREATE  PROCEDURE `reprogramarReserva` (IN `_reserva` BIGINT, IN `_idusu` INT, IN `_fechan` DATE, IN `_comentario` TEXT, IN `_motivo` TINYINT, IN `_cargo` TINYINT, OUT `_respuesta` VARCHAR(15))  BEGIN
	UPDATE reprogramaciones_volar set status = 2 where idtemp_rep = _reserva;
	INSERT INTO reprogramaciones_volar
(idtemp_rep,idusu_rep,fechaa_rep,fechan_rep,comentario_rep,motivo_rep,cargo_rep)
		SELECT _reserva, _idusu,fechavuelo_temp,_fechan,_comentario, _motivo, _cargo FROM temp_volar where id_temp=_reserva;
	UPDATE temp_volar set fechavuelo_temp =_fechan where id_temp = _reserva;
    SET _respuesta = 'Reprogramado';
END$$

CREATE  PROCEDURE `usuarioLoggeado` (IN `_usuario` VARCHAR(100), IN `_password` VARCHAR(150))  BEGIN
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
-- Estructura de tabla para la tabla `bitcomentarios_volar`
--

CREATE TABLE `bitcomentarios_volar` (
  `id_bc` int(11) NOT NULL COMMENT 'Llave Primaria',
  `idusu_bc` int(11) NOT NULL COMMENT 'Usuario',
  `idtemp_bc` bigint(20) NOT NULL COMMENT 'Reserva',
  `comentariop_bc` text NOT NULL COMMENT 'Comentario Pasado',
  `comentarion_bc` text NOT NULL COMMENT 'Comentario Nuevo',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `bitcomentarios_volar`
--

INSERT INTO `bitcomentarios_volar` (`id_bc`, `idusu_bc`, `idtemp_bc`, `comentariop_bc`, `comentarion_bc`, `register`, `status`) VALUES
(12, 14, 1318, '', 'pago por error $10.500.00 por conekta, favor de regresar  $500.00 pesos en sitio', '2019-10-11 16:29:21', 1),
(13, 16, 1320, '', 'INCLUYE DESAYUNOS Y FOTO IMPRESA/ FIRMAR CARTA DE PAGO POR CONEKTA PEDIDO 4135 /PEDIR TARJETA DE CREDITO  E IDENTIFICACIÃ“N', '2019-10-11 17:22:36', 1),
(14, 16, 1321, '', 'INCLUYE DESAYUNOS/ FIRMAR CARTA DE PAGO CON TC/ PEDIR ID/ PAGA CON TARJETA BANCOMER PUEDE SER A MESES SIN COMISION DEL 4%/ SE ENVIA TICKET DE PAGO EN TERMINAL DE OFICINA', '2019-10-11 17:23:17', 1),
(15, 16, 1400, '', 'PASTEL EN DESAYUNO', '2019-10-16 16:59:52', 1),
(16, 16, 1359, '', 'SI LIQUIDA CON TARJETA BANCOMER NO COBRAR COMISION DEL 4%', '2019-10-17 14:42:11', 1),
(17, 11, 1350, '', 'Pick up hotal Capital O Vallejo\nNorte 1 C tlacamaca, delegacion Gustavo A Madero\nPendiente confirmar hora de pick Up', '2019-10-21 11:29:19', 1),
(18, 18, 1576, '', 'EN SITIO SE LE REALIZÃ“ EL COBRO POR 9,200 CON TC MAS EL 4% DE COMISION POR LO CUAL EN EL SISTEMA HACE FALTA AGREGA $40.00', '2019-10-23 13:08:48', 1),
(19, 16, 1634, '', 'Debe pagar $300 dÃ³lares descontando $1000 pesos de anticipo y tomÃ¡ndolo a 17.50 por favor', '2019-10-23 23:02:42', 1),
(20, 16, 1507, '', 'RESERVA CANCELADA POR EL CLIENTE, SE REALIZO REEMBOLSO', '2019-10-25 11:03:02', 1),
(21, 16, 1762, '', '4 PAX VUELAN EN PRIMER HORARIO Y 2 EN SEGUNDO, LLEVAN UN BEBE Y SE TURNAN PARA CUIDARLO', '2019-10-31 14:30:52', 1),
(22, 16, 2035, '', 'DEBEN FIRMAR DOS CARTAS DE PAGO POR CONEKTA MARIA JOSE BENITEZ PEDIDO 4329 $2299\nDIANA DIAZ PEDIDO 4332 $4598', '2019-11-05 18:38:44', 1);

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
  `moneda_bp` int(11) NOT NULL COMMENT 'Tipo de Moneda',
  `preciomoneda_bp` double(10,2) NOT NULL COMMENT 'Precio de Moneda',
  `fecha_bp` date NOT NULL COMMENT 'Fecha de Pago',
  `idconc_bp` int(11) DEFAULT NULL COMMENT 'Usuario que Coincilia',
  `fechaconc_bp` datetime DEFAULT NULL COMMENT 'Fecha de Conciliación',
  `comision_bp` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Comisión',
  `cupon_bp` tinyint(4) DEFAULT 0 COMMENT 'Cupón',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Register',
  `status` tinyint(4) NOT NULL DEFAULT 4 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Bitácora de Pagos';

--
-- Volcado de datos para la tabla `bitpagos_volar`
--

INSERT INTO `bitpagos_volar` (`id_bp`, `idres_bp`, `idreg_bp`, `metodo_bp`, `banco_bp`, `referencia_bp`, `cantidad_bp`, `moneda_bp`, `preciomoneda_bp`, `fecha_bp`, `idconc_bp`, `fechaconc_bp`, `comision_bp`, `cupon_bp`, `register`, `status`) VALUES
(9, 0, 0, 0, 0, '', '0.00', 0, 0.00, '0000-00-00', NULL, NULL, 0, 0, '2019-08-08 15:21:04', 4),
(22, 1001, 16, 89, 64, '13066Y', '2000.00', 0, 0.00, '2019-09-06', 17, '2019-09-06 12:34:27', 0, 0, '2019-09-06 12:31:48', 1),
(23, 1003, 16, 61, 64, 'PEDIDO 3952', '8817.00', 0, 0.00, '2019-09-06', 17, '2019-09-06 13:34:20', 0, 0, '2019-09-06 13:31:04', 2),
(24, 1011, 11, 60, 83, 'CHECO002', '1.00', 0, 0.00, '2019-09-10', 17, '2019-09-10 17:43:48', 0, 0, '2019-09-10 17:41:57', 1),
(25, 1015, 16, 57, 64, '0056969008', '2000.00', 0, 0.00, '2019-09-11', 17, '2019-09-11 12:57:45', 0, 0, '2019-09-11 12:54:11', 1),
(26, 1012, 14, 55, 64, '23564', '2000.00', 0, 0.00, '2019-09-11', 17, '2019-09-11 16:45:50', 0, 0, '2019-09-11 13:16:06', 2),
(27, 1019, 16, 61, 64, 'PEDIDO 3993', '8600.00', 0, 0.00, '2019-09-11', 17, '2019-09-11 15:01:33', 0, 0, '2019-09-11 14:58:20', 2),
(28, 1027, 16, 89, 64, 'APROB: 510011', '2000.00', 0, 0.00, '2019-09-12', 17, '2019-09-12 13:05:29', 0, 0, '2019-09-12 13:00:37', 1),
(29, 1029, 16, 89, 64, 'APROB: 648421', '2000.00', 0, 0.00, '2019-09-12', 17, '2019-09-12 13:32:40', 0, 0, '2019-09-12 13:29:17', 1),
(30, 1031, 16, 61, 64, 'PEDIDO3996', '5018.00', 0, 0.00, '2019-09-12', 17, '2019-09-12 14:39:16', 0, 0, '2019-09-12 14:37:38', 2),
(31, 1025, 14, 55, 64, '23589', '2000.00', 0, 0.00, '2019-09-12', 17, '2019-09-12 17:26:41', 0, 0, '2019-09-12 17:22:54', 1),
(32, 1032, 14, 59, 64, '23596', '7197.00', 0, 0.00, '2019-09-12', 17, '2019-09-12 17:27:20', 0, 0, '2019-09-12 17:25:18', 2),
(33, 1034, 16, 57, 64, 'SPEI 59279', '2000.00', 0, 0.00, '2019-09-13', 17, '2019-09-13 14:47:31', 0, 0, '2019-09-13 14:45:45', 1),
(34, 1044, 16, 57, 64, '0000554008', '2000.00', 0, 0.00, '2019-09-14', 17, '2019-09-14 12:49:13', 0, 0, '2019-09-14 12:21:10', 1),
(35, 1039, 11, 87, 76, 'Aut 69473', '3600.00', 0, 0.00, '2019-09-14', 17, '2019-09-14 22:45:45', 0, 0, '2019-09-14 22:17:39', 3),
(36, 1038, 14, 55, 64, '23610', '2000.00', 0, 0.00, '2019-09-14', 17, '2019-09-17 12:43:31', 0, 0, '2019-09-17 12:29:41', 2),
(37, 1052, 16, 57, 64, 'folio 0044193011', '2000.00', 0, 0.00, '2019-09-17', 17, '2019-09-17 13:36:11', 0, 0, '2019-09-17 13:32:37', 1),
(38, 1051, 14, 55, 64, '1051', '2000.00', 0, 0.00, '2019-09-13', 17, '2019-09-17 13:37:28', 0, 0, '2019-09-17 13:33:43', 2),
(39, 1057, 14, 55, 64, '1057', '2000.00', 0, 0.00, '2019-09-17', 17, '2019-09-17 14:33:58', 0, 0, '2019-09-17 14:32:38', 2),
(40, 1088, 14, 59, 64, 'FOL 5332 AUT 984314', '2000.00', 0, 0.00, '2019-09-17', 17, '2019-09-17 15:01:07', 0, 0, '2019-09-17 14:59:34', 1),
(41, 1002, 16, 55, 64, 'FORMATO 0095', '2000.00', 0, 0.00, '2019-09-17', 17, '2019-09-18 15:03:21', 0, 0, '2019-09-18 11:46:47', 1),
(42, 1076, 16, 61, 64, '4003', '5598.00', 0, 0.00, '2019-09-18', 17, '2019-09-18 15:05:03', 0, 0, '2019-09-18 15:02:47', 2),
(43, 1082, 11, 94, 64, 'BESTDAY ID 73529389-1', '0.00', 0, 0.00, '2019-09-18', 17, '2019-09-18 17:58:11', 0, 0, '2019-09-18 17:26:02', 3),
(44, 1090, 16, 57, 64, '0004503013', '2000.00', 0, 0.00, '2019-09-18', 17, '2019-09-18 18:28:29', 0, 0, '2019-09-18 18:26:35', 2),
(45, 1059, 16, 57, 64, '21864', '2000.00', 0, 0.00, '2019-09-18', 17, '2019-09-18 20:02:50', 0, 0, '2019-09-18 19:52:50', 1),
(46, 1086, 14, 55, 64, '1086', '2000.00', 0, 0.00, '2019-09-18', 17, '2019-09-19 10:56:53', 0, 0, '2019-09-19 10:35:10', 2),
(47, 1089, 14, 57, 64, 'ref 6704517', '4000.00', 0, 0.00, '2019-09-18', 17, '2019-09-19 10:59:14', 0, 0, '2019-09-19 10:36:53', 2),
(48, 1093, 16, 56, 77, 'AUT 281843 FOLIO 1228642', '1800.00', 0, 0.00, '2019-09-19', 17, '2019-09-19 11:21:56', 0, 0, '2019-09-19 11:18:15', 1),
(49, 1096, 14, 57, 64, 'FOL 0036138011', '2000.00', 0, 0.00, '2019-09-19', 17, '2019-09-19 13:08:21', 0, 0, '2019-09-19 13:06:37', 1),
(50, 1097, 9, 94, 64, 'CXC EXPEDIA', '0.00', 0, 0.00, '2019-09-19', 17, '2019-09-19 14:18:27', 0, 0, '2019-09-19 14:14:11', 3),
(51, 1098, 9, 94, 64, 'CXC BESTDAY ID 73666355-1', '0.00', 0, 0.00, '2019-09-19', 17, '2019-09-19 14:28:47', 0, 0, '2019-09-19 14:27:20', 3),
(52, 1099, 9, 94, 64, 'CXC PRICE TRAVEL LOCATOR 12707825-1', '0.00', 0, 0.00, '2019-09-19', 17, '2019-09-19 15:05:12', 0, 0, '2019-09-19 14:51:12', 2),
(53, 1146, 16, 57, 64, '281877', '3000.00', 0, 0.00, '2019-09-19', 17, '2019-09-19 15:18:15', 0, 0, '2019-09-19 15:13:26', 3),
(54, 1101, 9, 94, 64, 'CXC EXPEDIA', '0.00', 0, 0.00, '2019-09-19', 17, '2019-09-19 15:36:58', 0, 0, '2019-09-19 15:29:19', 2),
(55, 1102, 9, 94, 64, 'CXC EXPEDIA', '0.00', 0, 0.00, '2019-09-19', 17, '2019-09-19 15:52:01', 0, 0, '2019-09-19 15:50:09', 3),
(56, 1106, 9, 94, 64, 'CXC EXPLORA Y DESCUBRE', '0.00', 0, 0.00, '2019-09-19', 17, '2019-09-19 18:46:13', 0, 0, '2019-09-19 18:43:45', 3),
(57, 1107, 9, 94, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-09-19', 17, '2019-09-19 18:52:25', 0, 0, '2019-09-19 18:50:45', 3),
(58, 1095, 14, 55, 64, '0100', '2000.00', 0, 0.00, '2019-09-19', 17, '2019-09-20 11:32:12', 0, 0, '2019-09-20 11:28:20', 2),
(59, 1110, 9, 94, 64, 'CXC HIS', '0.00', 0, 0.00, '2019-09-20', 17, '2019-09-20 12:21:29', 0, 0, '2019-09-20 12:19:28', 2),
(60, 1111, 9, 94, 64, 'CXC PRICE TRAVEL LOCATOR 12209035-1', '0.00', 0, 0.00, '2019-09-20', 17, '2019-09-20 12:36:42', 0, 0, '2019-09-20 12:34:48', 3),
(61, 1116, 14, 89, 64, '151648', '2000.00', 0, 0.00, '2019-09-20', 17, '2019-09-20 15:20:11', 0, 0, '2019-09-20 15:14:36', 1),
(62, 1117, 9, 94, 64, 'CXC 014 MEDIA', '0.00', 0, 0.00, '2019-09-20', 17, '2019-09-20 15:27:28', 0, 0, '2019-09-20 15:25:52', 3),
(63, 1117, 9, 94, 64, 'CXC 014 MEDIA', '0.00', 0, 0.00, '2019-09-20', NULL, NULL, 0, 0, '2019-09-20 15:25:54', 0),
(64, 1121, 9, 94, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-09-20', 17, '2019-09-20 16:57:42', 0, 0, '2019-09-20 16:56:07', 3),
(65, 1122, 9, 94, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-09-20', 17, '2019-09-20 17:07:57', 0, 0, '2019-09-20 17:06:28', 3),
(66, 1119, 16, 55, 64, 'PAYPAL FORMATO 0102', '2000.00', 0, 0.00, '2019-09-20', 17, '2019-09-20 18:05:33', 0, 0, '2019-09-20 18:02:31', 2),
(67, 1125, 9, 94, 64, 'CXC PRICE TRAVEL LOCATOR 12965767-1', '0.00', 0, 0.00, '2019-09-20', 17, '2019-09-20 18:29:49', 0, 0, '2019-09-20 18:28:04', 3),
(68, 1126, 9, 94, 64, 'cxc bestday id 73839672-5', '0.00', 0, 0.00, '2019-09-20', 17, '2019-09-20 18:50:19', 0, 0, '2019-09-20 18:47:19', 3),
(69, 1213, 9, 89, 64, 'APROB 005345', '2000.00', 0, 0.00, '2019-09-20', 17, '2019-09-20 18:51:41', 0, 0, '2019-09-20 18:50:25', 3),
(70, 1127, 9, 94, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-09-21', 17, '2019-09-21 12:21:13', 0, 0, '2019-09-21 12:15:36', 3),
(71, 1128, 9, 94, 64, 'cxc expedia', '0.00', 0, 0.00, '2019-09-21', 3, '2019-09-21 12:23:31', 0, 0, '2019-09-21 12:22:04', 3),
(72, 1129, 9, 94, 64, 'cxc booking', '0.00', 0, 0.00, '2019-09-21', 17, '2019-09-21 12:31:01', 0, 0, '2019-09-21 12:29:37', 3),
(73, 1130, 9, 94, 64, 'CXC BESTDAY ID 73865987-1', '0.00', 0, 0.00, '2019-09-21', 17, '2019-09-21 12:45:46', 0, 0, '2019-09-21 12:35:55', 3),
(74, 1131, 9, 94, 64, 'CXC WAYAK', '0.00', 0, 0.00, '2019-09-21', 3, '2019-09-21 13:27:47', 0, 0, '2019-09-21 13:26:01', 3),
(75, 1075, 9, 59, 64, 'aut 025468', '1000.00', 0, 0.00, '2019-09-21', 17, '2019-09-21 14:43:52', 0, 0, '2019-09-21 14:20:04', 2),
(76, 1064, 14, 57, 64, '8070909637', '2000.00', 0, 0.00, '2019-09-21', 17, '2019-09-21 18:21:52', 0, 0, '2019-09-21 18:18:31', 1),
(77, 1132, 14, 61, 64, 'CONEKTA PED 4028', '4198.00', 0, 0.00, '2019-09-23', 17, '2019-09-23 12:26:27', 0, 0, '2019-09-23 12:25:07', 2),
(78, 1134, 9, 94, 64, 'CXC BESTDAY ID 73929099-1', '0.00', 0, 0.00, '2019-09-23', 17, '2019-09-23 13:24:21', 0, 0, '2019-09-23 13:22:32', 2),
(79, 1061, 14, 55, 64, 'FACT 0104', '2000.00', 0, 0.00, '2019-09-21', 17, '2019-09-23 13:34:16', 0, 0, '2019-09-23 13:30:49', 2),
(80, 1135, 9, 94, 64, 'CXC BESTDAY ID 73929685-1', '0.00', 0, 0.00, '2019-09-23', NULL, NULL, 0, 0, '2019-09-23 13:31:04', 4),
(81, 1072, 14, 61, 64, 'CONEKTA PED 4010', '7000.00', 0, 0.00, '2019-09-20', 3, '2019-09-23 13:51:33', 0, 0, '2019-09-23 13:38:05', 2),
(82, 1136, 9, 94, 64, 'CXC TURISKY', '0.00', 0, 0.00, '2019-09-23', 3, '2019-09-23 13:57:39', 0, 0, '2019-09-23 13:56:20', 3),
(83, 1133, 16, 59, 64, 'mov 25265', '2000.00', 0, 0.00, '2019-09-23', 3, '2019-09-23 15:34:46', 0, 0, '2019-09-23 15:25:09', 1),
(84, 1137, 14, 55, 64, 'paypal', '2000.00', 0, 0.00, '2019-09-23', 17, '2019-09-23 16:48:54', 0, 0, '2019-09-23 16:34:26', 1),
(85, 1146, 16, 57, 64, '281877', '3000.00', 0, 0.00, '2019-09-19', 17, '2019-09-24 12:36:30', 0, 0, '2019-09-24 12:15:37', 1),
(86, 1148, 9, 94, 64, 'CXC BESTDAY ID 73933847-1', '0.00', 0, 0.00, '2019-09-24', NULL, NULL, 0, 0, '2019-09-24 12:49:06', 4),
(87, 1149, 9, 94, 64, 'CXC EXPEDIA', '0.00', 0, 0.00, '2019-09-24', 17, '2019-09-24 12:54:47', 0, 0, '2019-09-24 12:53:19', 3),
(88, 1146, 16, 57, 64, '281877', '-3000.00', 0, 0.00, '2019-09-19', 3, '2019-09-24 13:14:50', 0, 0, '2019-09-24 13:13:46', 2),
(89, 1145, 14, 57, 64, '0070926008', '2000.00', 0, 0.00, '2019-09-24', 17, '2019-09-24 15:26:19', 0, 0, '2019-09-24 15:24:31', 1),
(90, 1382, 9, 94, 64, 'CXC TU EXPERIENCIA', '0.00', 0, 0.00, '2019-09-24', 17, '2019-09-24 17:53:04', 0, 0, '2019-09-24 17:39:00', 2),
(91, 1606, 9, 94, 64, 'CXC GALLEGOS TOURS', '0.00', 0, 0.00, '2019-09-23', 17, '2019-09-24 17:55:55', 0, 0, '2019-09-24 17:55:42', 3),
(92, 1151, 14, 57, 64, '2701116', '10598.00', 0, 0.00, '2019-09-24', 17, '2019-09-24 18:06:56', 0, 0, '2019-09-24 18:05:33', 2),
(93, 1156, 16, 59, 64, '25282', '2500.00', 0, 0.00, '2019-09-24', 17, '2019-09-24 18:30:30', 0, 0, '2019-09-24 18:23:45', 1),
(94, 1153, 16, 60, 75, '675103', '2000.00', 0, 0.00, '2019-09-24', 3, '2019-09-24 22:47:41', 0, 0, '2019-09-24 22:28:56', 1),
(95, 1158, 14, 61, 64, 'CONEKTA PED 4070', '7500.00', 0, 0.00, '2019-09-25', 17, '2019-09-25 13:06:51', 0, 0, '2019-09-25 13:05:12', 2),
(96, 1159, 14, 61, 64, 'CONEKTA PED 4073', '8697.00', 0, 0.00, '2019-09-25', 17, '2019-09-25 13:12:50', 0, 0, '2019-09-25 13:09:32', 3),
(97, 1162, 16, 57, 64, '0064728007', '2000.00', 0, 0.00, '2019-09-25', 17, '2019-09-25 15:21:34', 0, 0, '2019-09-25 15:10:55', 1),
(98, 1163, 16, 57, 64, '08590277483032689', '2000.00', 0, 0.00, '2019-09-25', 17, '2019-09-25 15:33:11', 0, 0, '2019-09-25 15:30:40', 2),
(99, 1161, 11, 89, 64, '778068', '2000.00', 0, 0.00, '2019-09-25', 17, '2019-09-25 17:14:49', 0, 0, '2019-09-25 17:12:37', 1),
(100, 1166, 16, 57, 64, '0019762006', '2000.00', 0, 0.00, '2019-09-25', 17, '2019-09-25 17:34:02', 0, 0, '2019-09-25 17:28:42', 1),
(101, 1165, 16, 57, 64, '0054096012', '2000.00', 0, 0.00, '2019-09-25', 17, '2019-09-25 18:18:32', 0, 0, '2019-09-25 18:15:48', 1),
(102, 1169, 14, 55, 64, '0115', '2000.00', 0, 0.00, '2019-09-25', 17, '2019-09-25 18:39:55', 0, 0, '2019-09-25 18:24:54', 1),
(103, 1164, 16, 89, 64, '571879', '2000.00', 0, 0.00, '2019-09-25', 17, '2019-09-25 19:05:11', 0, 0, '2019-09-25 19:03:40', 2),
(104, 1170, 16, 57, 64, '0083426007', '2000.00', 0, 0.00, '2019-09-25', 3, '2019-09-25 21:00:47', 0, 0, '2019-09-25 20:12:08', 2),
(106, 1678, 18, 55, 64, '5H503078D9755090S', '2000.00', 0, 0.00, '2019-09-25', 3, '2019-09-26 12:56:50', 0, 0, '2019-09-26 12:53:00', 3),
(107, 1051, 18, 60, 83, 'Pago en Sitio', '4848.00', 0, 0.00, '2019-09-26', NULL, NULL, 0, 0, '2019-09-26 13:16:15', 2),
(108, 1175, 16, 55, 64, 'PAYPAL FORMATO 0117', '2000.00', 0, 0.00, '2019-09-26', 3, '2019-09-26 13:22:27', 0, 0, '2019-09-26 13:16:44', 2),
(109, 1179, 9, 94, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-09-26', 3, '2019-09-26 15:28:50', 0, 0, '2019-09-26 15:23:26', 3),
(110, 1181, 9, 94, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-09-26', 3, '2019-09-26 16:59:50', 0, 0, '2019-09-26 16:52:18', 3),
(111, 1182, 9, 94, 64, 'CXC UNIVERSE TRAVEL', '0.00', 0, 0.00, '2019-09-26', 3, '2019-09-26 17:02:45', 0, 0, '2019-09-26 16:59:47', 3),
(112, 1183, 9, 90, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-09-26', 3, '2019-09-26 17:24:01', 0, 0, '2019-09-26 17:20:52', 3),
(113, 1184, 9, 90, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-09-26', 17, '2019-09-26 17:29:56', 0, 0, '2019-09-26 17:27:40', 3),
(114, 1185, 9, 94, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-09-26', 3, '2019-09-26 23:51:51', 0, 0, '2019-09-26 17:34:34', 3),
(115, 1186, 9, 94, 64, 'CXC BESTDAY ID 73946246-1', '0.00', 0, 0.00, '2019-09-26', 3, '2019-09-26 23:49:38', 0, 0, '2019-09-26 17:39:58', 3),
(116, 1187, 14, 57, 64, 'FOL 0055754014', '4798.00', 0, 0.00, '2019-09-26', 3, '2019-09-26 19:39:54', 0, 0, '2019-09-26 18:21:01', 3),
(117, 1005, 16, 60, 64, 'AUT 427375 FOLIO 6216', '7000.00', 0, 0.00, '2019-09-23', 3, '2019-09-26 18:52:04', 0, 0, '2019-09-26 18:36:05', 2),
(118, 1190, 16, 55, 64, 'FORMATO 0090', '2000.00', 0, 0.00, '2019-09-11', 17, '2019-09-26 18:51:17', 0, 0, '2019-09-26 18:45:16', 1),
(119, 1191, 9, 56, 76, 'AUT 037475 FOLIO 2020853', '1000.00', 0, 0.00, '2019-09-26', 3, '2019-09-26 23:50:15', 0, 0, '2019-09-26 19:04:15', 3),
(120, 1196, 14, 55, 64, 'PAYPAL', '2000.00', 0, 0.00, '2019-09-03', 3, '2019-09-26 19:42:35', 0, 0, '2019-09-26 19:07:26', 2),
(121, 1197, 16, 57, 64, '0053542008', '2000.00', 0, 0.00, '2019-09-27', 17, '2019-09-27 11:07:46', 0, 0, '2019-09-27 11:02:46', 1),
(122, 1198, 16, 55, 64, 'FORMATO 0120', '2000.00', 0, 0.00, '2019-09-27', 17, '2019-09-27 11:15:39', 0, 0, '2019-09-27 11:10:31', 2),
(123, 1199, 16, 57, 64, '25335', '2000.00', 0, 0.00, '2019-09-27', 17, '2019-09-27 12:07:27', 0, 0, '2019-09-27 12:04:10', 1),
(124, 1212, 14, 57, 64, '0062996006', '1000.00', 0, 0.00, '2019-09-26', 17, '2019-09-27 12:07:50', 0, 0, '2019-09-27 12:04:54', 1),
(125, 1430, 14, 55, 64, '0118', '2000.00', 0, 0.00, '2019-09-26', 17, '2019-09-27 12:22:23', 0, 0, '2019-09-27 12:18:02', 3),
(126, 1205, 14, 55, 64, '0114', '2000.00', 0, 0.00, '2019-09-25', 17, '2019-09-27 12:35:26', 0, 0, '2019-09-27 12:33:53', 1),
(127, 1206, 14, 61, 64, 'conekta ped 4082', '8000.00', 0, 0.00, '2019-09-26', 3, '2019-09-27 12:48:30', 0, 0, '2019-09-27 12:40:48', 2),
(128, 1196, 18, 60, 83, 'Pago en Sitio', '17920.00', 0, 0.00, '2019-09-27', NULL, NULL, 0, 0, '2019-09-27 12:46:31', 2),
(129, 1005, 18, 60, 83, 'Pago en Sitio', '0.00', 0, 0.00, '2019-09-27', NULL, NULL, 0, 0, '2019-09-27 12:48:41', 2),
(130, 1211, 16, 60, 64, 'aut 231226 folio 2357', '2000.00', 0, 0.00, '2019-09-27', 3, '2019-09-27 15:01:58', 0, 0, '2019-09-27 14:59:12', 1),
(131, 1182, 9, 57, 64, 'CLAVE RASTREO 085904766080326998', '2350.00', 0, 0.00, '2019-09-27', 17, '2019-09-27 16:20:27', 0, 0, '2019-09-27 16:19:03', 3),
(132, 1227, 9, 94, 64, 'cxc booking', '0.00', 0, 0.00, '2019-09-27', 17, '2019-09-27 18:28:44', 0, 0, '2019-09-27 18:26:05', 3),
(133, 1215, 9, 94, 64, 'CXC TU EXPERIENCIA', '0.00', 0, 0.00, '2019-09-27', 3, '2019-09-27 18:55:09', 0, 0, '2019-09-27 18:53:14', 3),
(134, 1216, 9, 94, 64, 'CXC TU EXPERIENCIA', '0.00', 0, 0.00, '2019-09-27', 17, '2019-09-27 18:57:47', 0, 0, '2019-09-27 18:56:46', 3),
(135, 1217, 9, 94, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-09-27', 3, '2019-09-27 19:15:03', 0, 0, '2019-09-27 19:01:30', 3),
(136, 1218, 16, 55, 64, 'STEPHANNIE GUTIERREZ', '4798.00', 0, 0.00, '2019-09-27', 17, '2019-09-27 19:13:17', 0, 0, '2019-09-27 19:07:01', 2),
(137, 1164, 18, 90, 83, 'Pago en Sitio', '3798.00', 0, 0.00, '2019-09-28', NULL, NULL, 0, 0, '2019-09-28 16:59:32', 2),
(138, 1163, 18, 60, 83, 'Pago en Sitio', '2000.00', 0, 0.00, '2019-09-28', NULL, NULL, 0, 0, '2019-09-28 16:59:59', 2),
(139, 1381, 16, 59, 64, '106883', '2000.00', 0, 0.00, '2019-09-28', 3, '2019-09-28 19:30:12', 0, 0, '2019-09-28 19:25:58', 2),
(140, 1219, 11, 57, 75, '39428014', '2300.00', 0, 0.00, '2019-09-29', 3, '2019-09-29 20:31:08', 0, 0, '2019-09-29 20:28:55', 2),
(141, 1264, 14, 59, 64, 'FOL 2900 AUT 248049', '2000.00', 0, 0.00, '2019-09-28', 17, '2019-09-30 13:02:24', 0, 0, '2019-09-30 12:58:02', 1),
(142, 1220, 14, 55, 64, '0128', '2000.00', 0, 0.00, '2019-09-30', 17, '2019-10-01 14:38:00', 0, 0, '2019-09-30 13:35:27', 1),
(143, 1224, 14, 57, 64, '00025383', '3000.00', 0, 0.00, '2019-09-30', 17, '2019-09-30 17:58:15', 0, 0, '2019-09-30 17:57:17', 1),
(144, 1230, 9, 94, 64, 'CXC TURISKY', '0.00', 0, 0.00, '2019-09-30', 17, '2019-09-30 18:45:34', 0, 0, '2019-09-30 18:44:17', 3),
(145, 1232, 9, 94, 64, 'CXC TURISKY', '0.00', 0, 0.00, '2019-09-30', 17, '2019-09-30 19:10:06', 0, 0, '2019-09-30 18:48:09', 3),
(146, 1170, 18, 57, 83, 'Pago en Sitio', '4500.00', 0, 0.00, '2019-10-01', NULL, NULL, 0, 0, '2019-10-01 10:34:36', 2),
(147, 1036, 14, 55, 64, 'paypal', '2000.00', 0, 0.00, '2019-10-01', 17, '2019-10-01 14:50:37', 0, 0, '2019-10-01 12:00:37', 1),
(148, 1234, 16, 55, 64, 'PAYPAL FORMATO 0129', '1000.00', 0, 0.00, '2019-10-01', 3, '2019-10-01 13:35:30', 0, 0, '2019-10-01 13:24:53', 2),
(149, 1234, 16, 55, 64, 'PAYPAL FORMATO 0129', '1000.00', 0, 0.00, '2019-10-01', 17, '2019-10-01 14:23:44', 0, 0, '2019-10-01 14:18:08', 3),
(150, 1234, 16, 55, 64, 'PAYPAL FORMATO 0129', '-1000.00', 0, 0.00, '2019-10-01', 17, '2019-10-01 14:27:10', 0, 0, '2019-10-01 14:26:08', 3),
(151, 1235, 14, 59, 64, 'FOL 4222 AUT 184828', '2000.00', 0, 0.00, '2019-10-01', 17, '2019-10-01 14:32:40', 0, 0, '2019-10-01 14:30:25', 1),
(152, 1234, 16, 55, 64, 'PAYPAL FORMATO 0129', '1000.00', 0, 0.00, '2019-10-01', 3, '2019-10-01 14:32:30', 0, 0, '2019-10-01 14:32:00', 1),
(153, 1234, 16, 55, 64, 'PAYPAL FORMATO 0129', '-1000.00', 0, 0.00, '2019-10-01', 3, '2019-10-01 14:37:42', 0, 0, '2019-10-01 14:37:13', 3),
(154, 1236, 16, 59, 64, 'mov 25421', '13800.00', 0, 0.00, '2019-10-02', 17, '2019-10-02 13:18:12', 0, 0, '2019-10-02 13:15:34', 2),
(155, 1243, 16, 55, 64, 'formato 0135', '2000.00', 0, 0.00, '2019-10-02', 17, '2019-10-02 18:25:35', 0, 0, '2019-10-02 18:23:04', 3),
(156, 1245, 9, 94, 64, 'CXC BESTDAY ID 73915099-1', '0.00', 0, 0.00, '2019-10-02', 3, '2019-10-02 18:40:31', 0, 0, '2019-10-02 18:38:11', 3),
(157, 1246, 9, 94, 64, 'CXC PRICETRAVEL LOCATOR 12976634-1', '0.00', 0, 0.00, '2019-10-02', 17, '2019-10-02 18:54:17', 0, 0, '2019-10-02 18:52:47', 3),
(158, 1240, 16, 56, 77, 'Aut 822297', '1000.00', 0, 0.00, '2019-10-02', 3, '2019-10-02 21:51:05', 0, 0, '2019-10-02 21:43:13', 2),
(159, 1249, 14, 59, 64, 'aut 886556', '1000.00', 0, 0.00, '2019-10-02', 17, '2019-10-03 11:36:16', 0, 0, '2019-10-03 11:30:29', 1),
(160, 1251, 14, 55, 64, '0136', '2000.00', 0, 0.00, '2019-10-03', 17, '2019-10-03 13:42:32', 0, 0, '2019-10-03 13:41:14', 1),
(161, 1250, 9, 94, 64, 'CXC EXPEDIA', '0.00', 0, 0.00, '2019-10-03', 17, '2019-10-03 13:50:28', 0, 0, '2019-10-03 13:44:12', 3),
(162, 1253, 9, 94, 64, '20300.00 - clave de rastreo 085905956630325290', '20300.00', 0, 0.00, '2019-10-03', 17, '2019-10-03 13:56:58', 0, 0, '2019-10-03 13:52:46', 3),
(163, 1242, 16, 57, 64, 'SPEI 085902548440327697', '4198.00', 0, 0.00, '2019-10-03', 17, '2019-10-03 14:21:54', 0, 0, '2019-10-03 14:18:17', 2),
(164, 1257, 14, 55, 64, '0137', '2000.00', 0, 0.00, '2019-10-03', 17, '2019-10-03 14:46:32', 0, 0, '2019-10-03 14:44:22', 1),
(165, 1258, 9, 94, 64, 'CXC KAYTRIP', '0.00', 0, 0.00, '2019-10-03', 17, '2019-10-03 14:55:59', 0, 0, '2019-10-03 14:54:00', 3),
(166, 1260, 11, 57, 75, '9091609305', '10000.00', 0, 0.00, '2019-10-03', 17, '2019-10-03 15:06:42', 0, 0, '2019-10-03 15:03:53', 2),
(167, 1262, 14, 55, 64, '0131', '2000.00', 0, 0.00, '2019-10-04', 17, '2019-10-04 14:50:00', 0, 0, '2019-10-04 14:43:35', 1),
(168, 1263, 14, 89, 64, 'APROB 578682', '2000.00', 0, 0.00, '2019-08-30', 17, '2019-10-04 15:01:20', 0, 0, '2019-10-04 14:56:51', 1),
(169, 1248, 11, 56, 64, '186308', '2000.00', 0, 0.00, '2019-10-04', 17, '2019-10-04 18:20:43', 0, 0, '2019-10-04 18:12:16', 1),
(170, 1265, 9, 94, 64, 'CXC EXPEDIA', '0.00', 0, 0.00, '2019-10-05', 3, '2019-10-05 15:26:21', 0, 0, '2019-10-05 15:24:02', 3),
(171, 1266, 9, 94, 64, 'CXC BESTDAY ID 73970884-1', '0.00', 0, 0.00, '2019-10-05', 3, '2019-10-05 15:37:12', 0, 0, '2019-10-05 15:29:11', 3),
(172, 1267, 9, 94, 64, 'CXC KAYTRIP', '0.00', 0, 0.00, '2019-10-05', 3, '2019-10-05 15:37:22', 0, 0, '2019-10-05 15:35:27', 3),
(173, 1268, 9, 94, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-10-05', 3, '2019-10-05 15:43:49', 0, 0, '2019-10-05 15:40:46', 3),
(174, 1270, 9, 94, 64, 'CXC KAYTRIP', '0.00', 0, 0.00, '2019-10-05', 3, '2019-10-05 15:45:01', 0, 0, '2019-10-05 15:43:58', 3),
(175, 1271, 9, 94, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-10-05', 3, '2019-10-05 16:09:25', 0, 0, '2019-10-05 15:47:42', 3),
(176, 1272, 9, 94, 64, 'CXC GRAN TEOCALLI', '0.00', 0, 0.00, '2019-10-05', 3, '2019-10-05 16:09:37', 0, 0, '2019-10-05 15:51:11', 3),
(177, 1233, 16, 57, 64, 'tranfer wise', '2000.00', 0, 0.00, '2019-10-02', 17, '2019-10-07 11:38:09', 0, 0, '2019-10-07 11:35:57', 2),
(178, 1397, 16, 57, 64, 'CUENTA ORIGEN 1162', '12000.00', 0, 0.00, '2019-10-07', 17, '2019-10-07 14:25:38', 0, 0, '2019-10-07 14:22:21', 2),
(179, 1283, 1, 55, 75, '1105638', '1000.00', 0, 0.00, '2019-10-08', NULL, NULL, 0, 0, '2019-10-08 14:32:06', 0),
(180, 1283, 11, 55, 75, '6LU006286M1105638', '1000.00', 0, 0.00, '2019-10-08', 17, '2019-10-08 14:36:24', 0, 0, '2019-10-08 14:32:44', 2),
(181, 1281, 14, 55, 64, '0154', '1000.00', 0, 0.00, '2019-10-08', 17, '2019-10-08 14:59:31', 0, 0, '2019-10-08 14:57:43', 2),
(182, 1286, 14, 57, 64, 'FOL 0051943010', '2000.00', 0, 0.00, '2019-10-08', 17, '2019-10-08 16:19:08', 0, 0, '2019-10-08 16:18:35', 2),
(183, 1207, 11, 60, 83, 'Marichuy', '2000.00', 0, 0.00, '2019-09-29', NULL, NULL, 0, 0, '2019-10-08 16:19:30', 2),
(184, 1207, 11, 60, 83, 'marichuy', '1600.00', 0, 0.00, '2019-09-29', NULL, NULL, 0, 0, '2019-10-08 16:25:49', 2),
(185, 1207, 11, 60, 76, 'checo', '0.00', 0, 0.00, '2019-10-08', 17, '2019-10-08 17:03:35', 0, 0, '2019-10-08 17:02:26', 2),
(186, 1291, 16, 57, 64, 'SPEI FOLIO9689585025', '2000.00', 0, 0.00, '2019-10-10', 17, '2019-10-10 11:19:10', 0, 0, '2019-10-10 11:18:03', 2),
(187, 1292, 14, 61, 64, '4124', '7000.00', 0, 0.00, '2019-10-10', 17, '2019-10-10 11:55:58', 0, 0, '2019-10-10 11:54:50', 2),
(188, 1293, 14, 61, 64, '4127', '4798.00', 0, 0.00, '2019-10-10', 17, '2019-10-10 12:00:15', 0, 0, '2019-10-10 11:58:25', 2),
(189, 1289, 14, 59, 64, 'FOL 9562 AUT 429181', '2000.00', 0, 0.00, '2019-10-08', 17, '2019-10-10 12:16:07', 0, 0, '2019-10-10 12:08:55', 1),
(190, 1295, 14, 55, 64, '0141', '2000.00', 0, 0.00, '2019-10-05', 17, '2019-10-10 12:17:52', 0, 0, '2019-10-10 12:15:02', 2),
(191, 1296, 16, 55, 64, 'FORMATO 0159', '2000.00', 0, 0.00, '2019-10-10', 17, '2019-10-10 12:31:24', 0, 0, '2019-10-10 12:21:29', 2),
(192, 1297, 14, 89, 64, 'APROB 584726', '1000.00', 0, 0.00, '2019-10-10', 17, '2019-10-10 16:20:16', 0, 0, '2019-10-10 16:09:10', 1),
(193, 1298, 9, 94, 64, 'CXC TURISKY', '0.00', 0, 0.00, '2019-10-10', 17, '2019-10-10 18:20:05', 0, 0, '2019-10-10 18:17:36', 3),
(194, 1299, 9, 94, 64, 'CXC GRAN TEOCALLI', '0.00', 0, 0.00, '2019-10-10', 17, '2019-10-10 18:29:18', 0, 0, '2019-10-10 18:25:59', 3),
(195, 1300, 9, 94, 64, '6000.00 - clave de rastreo 085901091120328297', '6000.00', 0, 0.00, '2019-10-10', 17, '2019-10-10 18:39:10', 0, 0, '2019-10-10 18:36:13', 3),
(196, 1301, 9, 94, 64, 'CXC EXPEDIA', '0.00', 0, 0.00, '2019-10-10', 17, '2019-10-10 18:42:30', 0, 0, '2019-10-10 18:40:55', 3),
(197, 1302, 9, 94, 64, 'CXC EXPEDIA', '0.00', 0, 0.00, '2019-10-10', 17, '2019-10-10 18:46:07', 0, 0, '2019-10-10 18:44:46', 3),
(201, 1218, 18, 60, 83, 'Pago en Sitio', '0.00', 0, 0.00, '2019-10-11', NULL, NULL, 0, 0, '2019-10-11 12:35:57', 2),
(202, 1303, 16, 55, 64, 'FORMATO 0101', '2000.00', 0, 0.00, '2019-09-24', 17, '2019-10-11 12:51:54', 0, 0, '2019-10-11 12:49:10', 2),
(203, 1304, 16, 57, 64, 'SPEI GERMAN RUA', '3000.00', 0, 0.00, '2019-10-04', 17, '2019-10-11 13:00:35', 0, 0, '2019-10-11 12:58:17', 2),
(204, 1305, 16, 59, 64, 'Depositoolio 8573 Aut. 392299', '2000.00', 0, 0.00, '2019-10-08', 17, '2019-10-11 13:09:08', 0, 0, '2019-10-11 13:06:56', 2),
(205, 1306, 16, 57, 64, 'SPEI FOLIO 0011075013', '4000.00', 0, 0.00, '2019-10-09', 17, '2019-10-11 13:15:05', 0, 0, '2019-10-11 13:13:38', 2),
(206, 1307, 14, 59, 64, '2419', '2000.00', 0, 0.00, '2019-10-11', 17, '2019-10-11 13:31:22', 0, 0, '2019-10-11 13:28:34', 1),
(207, 1309, 16, 61, 64, 'pedido 4096', '5098.00', 0, 0.00, '2019-10-01', 17, '2019-10-11 13:53:38', 0, 0, '2019-10-11 13:41:09', 2),
(208, 1310, 14, 61, 64, '4112', '7097.00', 0, 0.00, '2019-10-11', 17, '2019-10-11 13:44:38', 0, 0, '2019-10-11 13:43:00', 2),
(209, 1109, 14, 61, 64, '4131', '4798.00', 0, 0.00, '2019-10-11', 17, '2019-10-11 13:57:47', 0, 0, '2019-10-11 13:55:55', 2),
(210, 1312, 16, 55, 64, 'PAYPAL FORMATO 0163', '1000.00', 0, 0.00, '2019-10-11', 17, '2019-11-04 11:03:48', 0, 0, '2019-10-11 13:57:29', 3),
(211, 1313, 16, 59, 64, 'Deposito en efectivo Folio 7003 Aut. 600817', '2000.00', 0, 0.00, '2019-10-07', 17, '2019-10-11 14:43:44', 0, 0, '2019-10-11 14:42:06', 2),
(212, 1314, 14, 57, 64, 'FOL 0037200008', '2798.00', 0, 0.00, '2019-10-05', 17, '2019-10-11 14:57:26', 0, 0, '2019-10-11 14:52:39', 1),
(213, 1309, 11, 60, 64, 'TODOOK', '0.00', 0, 0.00, '2019-10-11', 3, '2019-10-11 15:06:50', 0, 0, '2019-10-11 15:05:49', 2),
(214, 1315, 14, 55, 64, '0065', '2000.00', 0, 0.00, '2019-10-07', 17, '2019-10-11 15:22:34', 0, 0, '2019-10-11 15:10:50', 1),
(215, 1316, 16, 57, 64, '9709195287', '7000.00', 0, 0.00, '2019-10-10', 17, '2019-10-11 15:21:20', 0, 0, '2019-10-11 15:18:09', 2),
(216, 1316, 16, 57, 64, '9788869100', '10000.00', 0, 0.00, '2019-10-11', 17, '2019-10-11 15:21:18', 0, 0, '2019-10-11 15:19:25', 2),
(217, 1317, 14, 57, 64, '91019', '2000.00', 0, 0.00, '2019-10-09', 3, '2019-10-11 15:43:54', 0, 0, '2019-10-11 15:30:03', 1),
(218, 1318, 14, 61, 64, '3795', '10000.00', 0, 0.00, '2019-08-03', 17, '2019-10-11 16:32:16', 0, 0, '2019-10-11 16:28:27', 2),
(219, 1319, 9, 94, 75, 'CXC ESPIRITU AVENTURERO', '0.00', 0, 0.00, '2019-10-11', 17, '2019-10-11 16:32:30', 0, 0, '2019-10-11 16:30:35', 3),
(220, 1311, 16, 59, 64, 'FOLIO 6376 AUT 803166', '2000.00', 0, 0.00, '2019-10-11', 17, '2019-10-11 16:38:40', 0, 0, '2019-10-11 16:36:24', 2),
(221, 1320, 16, 61, 64, 'pedido 4135', '7000.00', 0, 0.00, '2019-10-11', 17, '2019-10-11 16:47:40', 0, 0, '2019-10-11 16:45:31', 2),
(222, 1321, 16, 89, 64, '734389', '2000.00', 0, 0.00, '2019-10-11', 17, '2019-10-11 17:03:31', 0, 0, '2019-10-11 17:01:10', 2),
(223, 1323, 9, 94, 64, 'CXC TRIPAVDISOR', '0.00', 0, 0.00, '2019-10-11', 17, '2019-10-11 17:35:20', 0, 0, '2019-10-11 17:34:08', 2),
(224, 1324, 9, 94, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-10-11', 17, '2019-10-11 17:48:58', 0, 0, '2019-10-11 17:46:45', 2),
(225, 1325, 9, 94, 64, 'CXC WAYAK', '0.00', 0, 0.00, '2019-10-11', 17, '2019-10-11 17:55:13', 0, 0, '2019-10-11 17:54:04', 2),
(226, 1326, 9, 94, 64, 'CXC EZRA', '0.00', 0, 0.00, '2019-10-11', 17, '2019-10-11 17:58:31', 0, 0, '2019-10-11 17:57:17', 2),
(227, 1327, 9, 61, 64, 'CONEKTA PED 3940 PAGO TC', '6698.00', 0, 0.00, '2019-10-11', 17, '2019-10-11 18:08:19', 0, 0, '2019-10-11 18:04:10', 2),
(228, 1328, 9, 94, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-10-11', 17, '2019-10-11 18:14:35', 0, 0, '2019-10-11 18:13:44', 2),
(229, 1329, 9, 94, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-10-11', 17, '2019-10-11 18:24:55', 0, 0, '2019-10-11 18:18:00', 2),
(230, 1330, 9, 94, 64, '15600.00 - numero de recibo 3W603993T63812738', '15600.00', 0, 0.00, '2019-10-11', 17, '2019-10-11 18:25:30', 0, 0, '2019-10-11 18:23:34', 2),
(231, 1332, 9, 94, 64, '11100.00 - Folio de Internet: 0005407017', '11100.00', 0, 0.00, '2019-10-11', 17, '2019-10-11 18:35:29', 0, 0, '2019-10-11 18:32:51', 2),
(232, 1333, 9, 94, 64, 'CXC GRAN TEOCALLI', '0.00', 0, 0.00, '2019-10-11', 17, '2019-10-11 18:37:24', 0, 0, '2019-10-11 18:36:11', 2),
(233, 1335, 16, 55, 64, 'PAYPAL FORMATO 0166', '1000.00', 0, 0.00, '2019-10-11', 3, '2019-10-11 19:14:17', 0, 0, '2019-10-11 19:11:54', 2),
(234, 1335, 18, 60, 83, 'Pago en Sitio', '1899.00', 0, 0.00, '2019-10-12', NULL, NULL, 0, 0, '2019-10-12 12:20:40', 2),
(235, 1326, 18, 94, 83, 'Pago en Sitio', '11700.00', 0, 0.00, '2019-10-12', NULL, NULL, 0, 0, '2019-10-12 13:04:42', 2),
(236, 1324, 18, 94, 83, 'Pago en Sitio', '21955.00', 0, 0.00, '2019-10-12', NULL, NULL, 0, 0, '2019-10-12 13:05:23', 2),
(237, 1323, 18, 94, 83, 'Pago en Sitio', '3900.00', 0, 0.00, '2019-10-12', NULL, NULL, 0, 0, '2019-10-12 13:05:55', 2),
(238, 1317, 18, 60, 83, 'Pago en Sitio', '3656.00', 0, 0.00, '2019-10-12', NULL, NULL, 0, 0, '2019-10-12 13:08:15', 2),
(239, 1315, 18, 60, 83, 'Pago en Sitio', '14793.00', 0, 0.00, '2019-10-12', NULL, NULL, 0, 0, '2019-10-12 13:08:46', 2),
(240, 1314, 18, 60, 83, 'Pago en Sitio', '2000.00', 0, 0.00, '2019-10-12', NULL, NULL, 0, 0, '2019-10-12 13:09:09', 2),
(241, 1306, 18, 60, 83, 'Pago en Sitio', '600.00', 0, 0.00, '2019-10-12', NULL, NULL, 0, 0, '2019-10-12 13:09:26', 2),
(242, 1305, 18, 55, 83, 'Pago en Sitio', '8598.00', 0, 0.00, '2019-10-12', NULL, NULL, 4, 0, '2019-10-12 13:10:18', 2),
(243, 1304, 18, 90, 83, 'Pago en Sitio', '4000.00', 0, 0.00, '2019-10-12', NULL, NULL, 4, 0, '2019-10-12 13:11:25', 2),
(244, 1303, 18, 90, 83, 'Pago en Sitio', '23755.00', 0, 0.00, '2019-10-12', NULL, NULL, 4, 0, '2019-10-12 13:11:55', 2),
(245, 1286, 18, 60, 83, 'Pago en Sitio', '4500.00', 0, 0.00, '2019-10-12', NULL, NULL, 0, 0, '2019-10-12 13:13:52', 2),
(246, 1286, 18, 60, 83, 'Pago en Sitio', '6500.00', 0, 0.00, '2019-10-12', NULL, NULL, 4, 0, '2019-10-12 13:16:08', 2),
(247, 1336, 16, 57, 64, '0073392007', '2000.00', 0, 0.00, '2019-10-12', 3, '2019-10-12 13:57:58', 0, 0, '2019-10-12 13:36:42', 2),
(248, 1338, 9, 57, 88, '081834', '11750.00', 0, 0.00, '2019-10-12', NULL, NULL, 0, 0, '2019-10-12 13:51:19', 4),
(249, 1340, 14, 59, 64, 'Fol 4528', '2000.00', 0, 0.00, '2019-10-12', 3, '2019-10-12 15:39:23', 0, 0, '2019-10-12 15:34:51', 1),
(250, 1358, 14, 59, 64, '9094', '2000.00', 0, 0.00, '2019-10-12', 3, '2019-10-12 18:10:46', 0, 0, '2019-10-12 17:52:23', 1),
(251, 1343, 16, 60, 64, 'Pago en sitio con Mary', '6000.00', 0, 0.00, '2019-10-12', 3, '2019-10-12 20:41:41', 0, 0, '2019-10-12 20:13:13', 2),
(252, 1344, 14, 56, 64, 'Aut 113654', '1000.00', 0, 0.00, '2019-10-12', 3, '2019-10-12 21:54:46', 0, 0, '2019-10-12 21:52:11', 1),
(253, 1321, 1, 90, 83, 'Pago en Sitio', '5197.00', 0, 0.00, '2019-10-13', NULL, NULL, 0, 0, '2019-10-13 10:41:19', 2),
(254, 1313, 1, 60, 83, 'Pago en Sitio', '6646.00', 0, 0.00, '2019-10-13', NULL, NULL, 0, 0, '2019-10-13 10:41:50', 2),
(255, 1311, 1, 60, 83, 'Pago en Sitio', '5700.00', 0, 0.00, '2019-10-13', NULL, NULL, 0, 0, '2019-10-13 10:42:12', 2),
(256, 1248, 1, 60, 83, 'Pago en Sitio', '11800.00', 0, 0.00, '2019-10-13', NULL, NULL, 0, 0, '2019-10-13 10:42:27', 2),
(257, 1353, 9, 94, 64, 'TURISKY L-V', '0.00', 0, 0.00, '2019-10-12', 3, '2019-10-13 12:40:14', 0, 0, '2019-10-13 12:38:46', 3),
(258, 1352, 9, 56, 96, 'AUT. 342067', '1000.00', 0, 0.00, '2019-10-13', 17, '2019-10-13 19:05:55', 0, 0, '2019-10-13 18:20:15', 3),
(259, 1354, 16, 55, 64, 'Formato 0170', '1000.00', 0, 0.00, '2019-10-13', 17, '2019-10-13 21:22:17', 0, 0, '2019-10-13 21:13:37', 2),
(260, 1349, 14, 56, 64, '973823', '1000.00', 0, 0.00, '2019-10-13', 17, '2019-10-13 21:41:07', 0, 0, '2019-10-13 21:36:35', 1),
(261, 1355, 14, 55, 64, '0155', '1000.00', 0, 0.00, '2019-10-14', 17, '2019-10-14 10:52:50', 0, 0, '2019-10-14 10:51:55', 1),
(262, 1357, 9, 94, 64, 'CXC EXPEDIA', '0.00', 0, 0.00, '2019-10-14', 17, '2019-10-14 11:19:29', 0, 0, '2019-10-14 11:03:55', 3),
(263, 1360, 16, 55, 64, 'PAYPAL FORMATO 072', '1000.00', 0, 0.00, '2019-10-14', 17, '2019-10-14 13:44:52', 0, 0, '2019-10-14 13:41:37', 2),
(264, 1361, 16, 55, 64, 'Paypal formato 0167 Camino Ramirez', '1000.00', 0, 0.00, '2019-10-12', 17, '2019-10-14 13:53:20', 0, 0, '2019-10-14 13:51:13', 2),
(265, 1562, 16, 57, 64, 'Spei Folio 0084108009', '2000.00', 0, 0.00, '2019-10-12', 17, '2019-10-14 14:06:53', 0, 0, '2019-10-14 13:55:28', 1),
(266, 1363, 16, 57, 64, 'Spei Folio 0055744007', '2000.00', 0, 0.00, '2019-10-13', 17, '2019-10-14 14:09:49', 0, 0, '2019-10-14 13:58:13', 1),
(267, 1364, 16, 89, 64, 'Terminal Aprobacion 302149', '2000.00', 0, 0.00, '2019-10-14', 17, '2019-10-14 14:18:34', 0, 0, '2019-10-14 14:13:52', 2),
(268, 1367, 16, 59, 64, 'Dep en efectivo aut 992375 folio 0706', '2000.00', 0, 0.00, '2019-09-24', 17, '2019-10-14 15:22:04', 0, 0, '2019-10-14 15:16:21', 2),
(269, 1383, 16, 57, 64, '0038517008', '2000.00', 0, 0.00, '2019-10-14', 17, '2019-10-14 15:37:05', 0, 0, '2019-10-14 15:34:29', 2),
(270, 1370, 14, 55, 64, 'PAYPAL', '1000.00', 0, 0.00, '2019-10-14', 17, '2019-10-14 15:50:33', 0, 0, '2019-10-14 15:45:17', 1),
(271, 1350, 11, 55, 75, 'Daniela G', '1000.00', 0, 0.00, '2019-10-14', 17, '2019-10-14 17:46:38', 0, 0, '2019-10-14 17:25:53', 1),
(272, 1374, 9, 94, 64, 'TURISKY L-V', '0.00', 0, 0.00, '2019-10-14', 17, '2019-10-14 18:04:46', 0, 0, '2019-10-14 18:03:55', 3),
(273, 1375, 14, 57, 64, '24189', '17376.00', 0, 0.00, '2019-10-14', 17, '2019-10-14 18:18:53', 0, 0, '2019-10-14 18:16:25', 2),
(274, 1376, 16, 59, 77, 'Deposito en efectivo Folio 347799 Aut. 198862', '2000.00', 0, 0.00, '2019-10-14', 17, '2019-10-14 18:20:09', 0, 0, '2019-10-14 18:18:59', 2),
(275, 1377, 9, 94, 64, 'TURISKY L-V', '0.00', 0, 0.00, '2019-10-14', 17, '2019-10-14 19:29:59', 0, 0, '2019-10-14 19:28:13', 3),
(276, 1371, 16, 57, 64, 'Spei folio 0020969020', '1500.00', 0, 0.00, '2019-10-14', 3, '2019-10-14 20:04:05', 0, 0, '2019-10-14 20:02:53', 2),
(277, 1372, 16, 59, 77, 'Ref 107573 folio 650328', '2000.00', 0, 0.00, '2019-10-14', 17, '2019-10-14 22:11:56', 0, 0, '2019-10-14 21:40:17', 2),
(278, 1354, 18, 60, 83, 'Pago en Sitio', '2280.00', 0, 0.00, '2019-10-14', NULL, NULL, 0, 0, '2019-10-14 23:40:42', 2),
(279, 1354, 18, 90, 83, 'Pago en Sitio', '1000.00', 0, 0.00, '2019-10-14', NULL, NULL, 4, 0, '2019-10-14 23:40:58', 2),
(280, 1336, 18, 60, 83, 'Pago en Sitio', '7200.00', 0, 0.00, '2019-10-14', NULL, NULL, 0, 0, '2019-10-14 23:41:30', 2),
(281, 1134, 18, 60, 83, 'Pago en Sitio', '400.00', 0, 0.00, '2019-10-14', NULL, NULL, 0, 0, '2019-10-14 23:42:14', 2),
(282, 1378, 16, 57, 64, 'SPEI 0125312268', '4450.00', 0, 0.00, '2019-10-15', 17, '2019-10-15 12:04:05', 0, 0, '2019-10-15 11:54:10', 1),
(283, 1379, 16, 57, 64, '085902700060328895', '2000.00', 0, 0.00, '2019-10-15', 17, '2019-10-15 12:37:45', 0, 0, '2019-10-15 12:35:28', 2),
(284, 1380, 16, 59, 64, 'MOV 000025623', '4600.00', 0, 0.00, '2019-10-15', 17, '2019-10-15 13:04:11', 0, 0, '2019-10-15 13:03:23', 3),
(285, 1376, 18, 60, 83, 'Pago en Sitio', '14097.00', 0, 0.00, '2019-10-15', NULL, NULL, 0, 0, '2019-10-15 17:26:21', 2),
(286, 1371, 18, 60, 83, 'Pago en Sitio', '6000.00', 0, 0.00, '2019-10-15', NULL, NULL, 0, 0, '2019-10-15 17:26:53', 2),
(287, 1385, 16, 55, 64, 'Formato 0176', '2000.00', 0, 0.00, '2019-10-15', 17, '2019-10-15 20:22:40', 0, 0, '2019-10-15 20:12:08', 2),
(288, 1356, 14, 55, 64, '0171', '1000.00', 0, 0.00, '2019-10-16', 17, '2019-10-16 10:48:18', 0, 0, '2019-10-16 10:32:50', 1),
(289, 1389, 9, 94, 64, 'CXC BESTDAY ID 74038839-1', '0.00', 0, 0.00, '2019-10-16', 17, '2019-10-16 11:42:29', 0, 0, '2019-10-16 11:26:54', 2),
(290, 1391, 9, 94, 64, 'CXC TONA GORILAS', '0.00', 0, 0.00, '2019-10-16', 17, '2019-10-16 11:49:36', 0, 0, '2019-10-16 11:48:23', 2),
(291, 1392, 16, 89, 64, 'aprob 010961', '1000.00', 0, 0.00, '2019-10-16', 17, '2019-10-16 12:42:12', 0, 0, '2019-10-16 12:41:00', 2),
(292, 1393, 9, 94, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-10-16', 17, '2019-10-16 13:28:19', 0, 0, '2019-10-16 13:27:04', 2),
(293, 1394, 14, 59, 64, '000091809393', '2000.00', 0, 0.00, '2019-10-15', 17, '2019-10-16 14:10:01', 0, 0, '2019-10-16 13:57:11', 1),
(294, 1395, 9, 94, 64, 'CXC TURISKY', '0.00', 0, 0.00, '2019-10-16', 17, '2019-10-16 14:51:15', 0, 0, '2019-10-16 14:49:54', 2),
(295, 1398, 9, 94, 64, 'CXC GRAN TEOCALLI', '0.00', 0, 0.00, '2019-10-16', 17, '2019-10-16 15:16:31', 0, 0, '2019-10-16 15:11:33', 2),
(296, 1399, 14, 59, 64, '000025641', '2000.00', 0, 0.00, '2019-10-16', 17, '2019-10-16 15:45:57', 0, 0, '2019-10-16 15:40:52', 1),
(297, 1387, 16, 59, 64, 'mov 25642', '2000.00', 0, 0.00, '2019-10-16', 17, '2019-10-16 16:55:48', 0, 0, '2019-10-16 16:53:05', 2),
(298, 1400, 16, 56, 77, 'AUT 295882 FOLIO 2255903', '1000.00', 0, 0.00, '2019-10-16', 17, '2019-10-16 17:06:21', 0, 0, '2019-10-16 16:58:40', 2),
(299, 1401, 14, 57, 64, '8901346', '4798.00', 0, 0.00, '2019-10-15', 17, '2019-10-17 10:57:34', 0, 0, '2019-10-16 18:04:45', 2),
(300, 1403, 16, 61, 64, 'pedido 4147', '7800.00', 0, 0.00, '2019-10-16', 17, '2019-10-16 18:58:34', 0, 0, '2019-10-16 18:50:33', 2),
(301, 1405, 14, 55, 64, '0179', '1000.00', 0, 0.00, '2019-10-16', 17, '2019-10-17 11:10:00', 0, 0, '2019-10-17 11:06:19', 1),
(302, 1406, 14, 56, 64, 'AUT 507045', '1000.00', 0, 0.00, '2019-10-17', 17, '2019-10-17 11:26:27', 0, 0, '2019-10-17 11:22:28', 1),
(303, 1408, 11, 60, 93, 'PAGA EN SITIO', '0.00', 0, 0.00, '2019-10-17', 17, '2019-10-17 12:29:57', 0, 0, '2019-10-17 12:27:56', 2),
(304, 1454, 14, 57, 64, '7469951', '2000.00', 0, 0.00, '2019-10-17', 17, '2019-10-17 12:52:18', 0, 0, '2019-10-17 12:44:04', 1),
(305, 1665, 16, 61, 64, 'pedido 4151', '4798.00', 0, 0.00, '2019-10-17', 17, '2019-10-17 12:53:42', 0, 0, '2019-10-17 12:47:23', 2),
(306, 1415, 9, 94, 64, 'CXC HOTEL QUINTO SOL', '0.00', 0, 0.00, '2019-10-17', 17, '2019-10-17 12:59:37', 0, 0, '2019-10-17 12:58:25', 2),
(307, 1413, 14, 55, 64, '0180', '1000.00', 0, 0.00, '2019-10-17', 17, '2019-10-17 13:42:24', 0, 0, '2019-10-17 13:21:57', 3),
(308, 1416, 14, 55, 64, '0182', '1000.00', 0, 0.00, '2019-10-17', 17, '2019-10-17 14:04:24', 0, 0, '2019-10-17 14:00:33', 1),
(309, 1359, 16, 89, 64, 'APROBACIÃ“N 817396', '2000.00', 0, 0.00, '2019-10-17', 17, '2019-10-17 14:29:57', 0, 0, '2019-10-17 14:24:36', 1),
(310, 1417, 14, 57, 64, '000024070', '2200.00', 0, 0.00, '2019-07-11', 17, '2019-10-17 14:34:44', 0, 0, '2019-10-17 14:29:00', 2),
(311, 1417, 14, 59, 64, '6468', '5000.00', 0, 0.00, '2019-10-08', 17, '2019-10-17 14:34:46', 0, 0, '2019-10-17 14:29:42', 2),
(312, 1417, 14, 59, 64, '2549', '3000.00', 0, 0.00, '2019-10-17', 17, '2019-10-17 14:34:48', 0, 0, '2019-10-17 14:30:50', 2),
(313, 1418, 14, 57, 64, '0308113081', '2000.00', 0, 0.00, '2019-10-17', 17, '2019-10-17 14:49:35', 0, 0, '2019-10-17 14:46:10', 2),
(314, 1419, 16, 59, 64, 'folio 5350 aut 955738', '7000.00', 0, 0.00, '2019-10-17', 17, '2019-10-17 16:49:26', 0, 0, '2019-10-17 16:46:27', 2),
(315, 1421, 14, 55, 64, '0183', '2000.00', 0, 0.00, '2019-10-17', 17, '2019-10-17 17:36:22', 0, 0, '2019-10-17 17:31:26', 1),
(316, 1658, 16, 55, 64, 'PAYPAL FORMATO 0184', '1000.00', 0, 0.00, '2019-10-17', 17, '2019-10-17 17:47:39', 0, 0, '2019-10-17 17:42:07', 2),
(317, 1423, 9, 94, 64, 'CORTESIAS EXPEDIA', '0.00', 0, 0.00, '2019-10-17', 17, '2019-10-17 17:58:10', 0, 0, '2019-10-17 17:56:23', 2),
(318, 1422, 9, 94, 64, 'CXC TURISKY', '0.00', 0, 0.00, '2019-10-17', 17, '2019-10-17 18:46:06', 0, 0, '2019-10-17 17:59:00', 2),
(319, 1396, 16, 56, 77, 'AUT 700103 FOLIO 22639', '1000.00', 0, 0.00, '2019-10-17', 17, '2019-10-17 18:14:17', 0, 0, '2019-10-17 18:07:42', 1),
(320, 1322, 9, 55, 75, 'TRIPADVISOR 741163490', '3900.00', 0, 0.00, '2019-10-14', 17, '2019-10-17 18:14:40', 0, 0, '2019-10-17 18:12:01', 3),
(321, 1407, 16, 55, 64, 'PAYPAL FORMATO 0181', '1000.00', 0, 0.00, '2019-10-17', 3, '2019-10-21 13:20:45', 0, 0, '2019-10-17 18:42:33', 2),
(322, 1425, 9, 94, 64, 'CXC PRICE TRAVEL LOCATOR 1327492-1', '0.00', 0, 0.00, '2019-10-16', 17, '2019-10-17 18:51:54', 0, 0, '2019-10-17 18:49:59', 2),
(323, 1426, 9, 94, 64, '6000.00 - Folio de Internet: 0081937007', '6000.00', 0, 0.00, '2019-10-17', 17, '2019-10-17 18:59:46', 0, 0, '2019-10-17 18:54:02', 2),
(324, 1427, 14, 89, 64, '426919', '1000.00', 0, 0.00, '2019-10-17', 17, '2019-10-17 19:07:05', 0, 0, '2019-10-17 19:04:53', 1),
(325, 1427, 18, 55, 83, 'Pago en Sitio', '8200.00', 0, 0.00, '2019-10-18', NULL, NULL, 4, 0, '2019-10-18 09:08:23', 2),
(326, 1406, 18, 60, 83, 'Pago en Sitio', '3116.00', 0, 0.00, '2019-10-18', NULL, NULL, 0, 0, '2019-10-18 09:10:26', 2),
(327, 1399, 18, 60, 83, 'Pago en Sitio', '2600.00', 0, 0.00, '2019-10-18', NULL, NULL, 0, 0, '2019-10-18 09:11:55', 2),
(328, 1396, 18, 60, 83, 'Pago en Sitio', '6147.00', 0, 0.00, '2019-10-18', NULL, NULL, 0, 0, '2019-10-18 09:12:16', 2),
(329, 1387, 18, 90, 83, 'Pago en Sitio', '2600.00', 0, 0.00, '2019-10-18', NULL, NULL, 4, 0, '2019-10-18 09:13:08', 2),
(330, 1364, 18, 90, 83, 'Pago en Sitio', '6550.00', 0, 0.00, '2019-10-18', NULL, NULL, 4, 0, '2019-10-18 09:14:09', 2),
(331, 1363, 18, 90, 83, 'Pago en Sitio', '23680.00', 0, 0.00, '2019-10-18', NULL, NULL, 4, 0, '2019-10-18 09:14:39', 2),
(332, 1061, 18, 60, 83, 'Pago en Sitio', '13840.00', 0, 0.00, '2019-10-18', NULL, NULL, 0, 0, '2019-10-18 09:15:09', 2),
(333, 1061, 18, 90, 83, 'Pago en Sitio', '2640.00', 0, 0.00, '2019-10-18', NULL, NULL, 4, 0, '2019-10-18 09:15:22', 2),
(334, 1414, 16, 89, 64, 'aprob 646651', '2000.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 10:38:36', 0, 0, '2019-10-18 10:36:37', 2),
(335, 1431, 16, 59, 64, 'FOLIO 9979 AUT 674880', '2500.00', 0, 0.00, '2019-10-09', 17, '2019-10-18 12:01:54', 0, 0, '2019-10-18 11:59:29', 2),
(336, 1433, 16, 57, 64, 'TRANF ORANGE LOGISTIC', '2000.00', 0, 0.00, '2019-10-02', 17, '2019-10-18 12:19:24', 0, 0, '2019-10-18 12:10:14', 2),
(337, 1429, 9, 94, 64, 'cxc expedia', '0.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 12:29:34', 0, 0, '2019-10-18 12:26:18', 2),
(338, 1434, 14, 59, 64, '0163', '1000.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 12:58:01', 0, 0, '2019-10-18 12:53:29', 1),
(339, 1435, 9, 94, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 13:20:01', 0, 0, '2019-10-18 13:18:18', 2),
(340, 1438, 9, 94, 64, '2019-10-02	5000.00 - folio aut 005833', '5000.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 13:49:46', 0, 0, '2019-10-18 13:46:34', 2),
(341, 1439, 9, 94, 64, 'CXC BESTDAY ID 73529389-1', '0.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 14:35:22', 0, 0, '2019-10-18 14:30:25', 2),
(342, 1440, 9, 94, 64, 'CXC SEE MEXICO', '0.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 14:38:52', 0, 0, '2019-10-18 14:38:04', 2),
(343, 1441, 9, 94, 64, '2019-10-10	13520.00 - clave de rastreo 085901101060328293', '13520.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 14:50:46', 0, 0, '2019-10-18 14:46:41', 1),
(344, 1436, 16, 56, 77, 'aut 335493 folio 284479', '2000.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 14:53:08', 0, 0, '2019-10-18 14:49:18', 2),
(345, 1442, 9, 94, 64, '2019-10-09	8400.00 - FOLIO 3772 AUT 830494', '8400.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 14:57:44', 0, 0, '2019-10-18 14:52:54', 2),
(346, 1444, 9, 94, 64, 'CXC TU EXPERIENCIA', '0.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 15:29:15', 0, 0, '2019-10-18 15:11:32', 2),
(347, 1445, 9, 94, 64, 'CXC TU EXPERIENCIA', '0.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 15:28:45', 0, 0, '2019-10-18 15:22:08', 2),
(348, 1443, 9, 90, 64, 'PAGA EN SITIO', '0.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 15:31:56', 0, 0, '2019-10-18 15:31:13', 2),
(349, 1448, 9, 94, 64, 'CXC  VIAJES FLOTUR', '0.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 16:43:18', 0, 0, '2019-10-18 15:37:40', 2),
(350, 1449, 9, 94, 64, 'CXC PRICE TRAVEL 13381691-1', '0.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 16:43:37', 0, 0, '2019-10-18 15:55:24', 2),
(351, 1450, 9, 59, 64, 'AUT 905405', '1000.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 17:08:16', 0, 0, '2019-10-18 17:00:12', 2),
(352, 1451, 9, 94, 64, 'CXC OMAR BAUTISTA', '0.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 17:17:30', 0, 0, '2019-10-18 17:16:44', 2),
(353, 1438, 9, 94, 64, 'AUT 028669', '2700.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 17:25:38', 0, 0, '2019-10-18 17:23:04', 3),
(354, 1452, 9, 94, 64, 'CXC TU EXPERIENCIA', '0.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 17:50:52', 0, 0, '2019-10-18 17:47:41', 2),
(355, 1453, 9, 94, 64, 'CORTESIAS KAYTRIP', '0.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 18:07:11', 0, 0, '2019-10-18 18:02:47', 2),
(356, 1454, 14, 57, 64, '7469951', '2000.00', 0, 0.00, '2019-10-16', NULL, NULL, 0, 0, '2019-10-18 18:09:55', 0),
(357, 1455, 9, 94, 64, 'cxc expedia', '0.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 18:17:58', 0, 0, '2019-10-18 18:14:44', 2),
(358, 1390, 16, 55, 64, 'formato 0177', '1000.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 18:29:12', 0, 0, '2019-10-18 18:18:22', 2),
(359, 1456, 14, 55, 64, '0155', '1000.00', 0, 0.00, '2019-10-08', NULL, NULL, 0, 0, '2019-10-18 18:27:36', 4),
(360, 1457, 9, 94, 64, 'CXC EXPLORA Y DESCUBRE', '0.00', 0, 0.00, '2019-10-18', 17, '2019-10-18 18:34:17', 0, 0, '2019-10-18 18:33:06', 2),
(361, 1461, 16, 89, 64, 'AprobaciÃ³n 025147', '2000.00', 0, 0.00, '2019-10-18', 3, '2019-10-18 19:21:25', 0, 0, '2019-10-18 19:18:15', 1),
(362, 1460, 16, 56, 77, 'Aut 962162 folio 339037', '1000.00', 0, 0.00, '2019-10-18', 3, '2019-10-18 21:01:45', 0, 0, '2019-10-18 20:52:27', 2),
(363, 1462, 16, 56, 77, 'Aut 109401 folio 4301682', '1000.00', 0, 0.00, '2019-10-18', 3, '2019-10-18 21:32:19', 0, 0, '2019-10-18 21:26:40', 2),
(364, 1465, 16, 89, 64, 'APROB 933975', '2000.00', 0, 0.00, '2019-10-19', 3, '2019-10-19 12:18:07', 0, 0, '2019-10-19 11:56:10', 1),
(365, 1467, 9, 61, 64, 'Conekta ped 4155 pago tc', '7000.00', 0, 0.00, '2019-10-19', 3, '2019-10-19 12:18:41', 0, 0, '2019-10-19 12:11:17', 2),
(366, 1466, 16, 61, 64, 'PEDIDO 4158', '8597.00', 0, 0.00, '2019-10-19', 3, '2019-10-19 12:20:42', 0, 0, '2019-10-19 12:11:59', 2),
(367, 1468, 16, 90, 64, 'PAGO EN SITIO CON KAREN', '5800.00', 0, 0.00, '2019-10-19', 3, '2019-10-19 12:53:12', 0, 0, '2019-10-19 12:21:39', 3),
(368, 1339, 14, 59, 64, '6257', '2000.00', 0, 0.00, '2019-10-19', 3, '2019-10-19 12:41:34', 0, 0, '2019-10-19 12:35:58', 1),
(369, 1471, 14, 55, 64, '0186', '1000.00', 0, 0.00, '2019-10-19', 3, '2019-10-19 13:23:15', 0, 0, '2019-10-19 13:20:52', 1),
(370, 1473, 16, 89, 64, 'APROB 347195', '2000.00', 0, 0.00, '2019-10-19', 3, '2019-10-19 14:52:24', 0, 0, '2019-10-19 14:49:54', 2),
(371, 1472, 16, 59, 64, 'FOLIO 6412 AUT 350062', '2000.00', 0, 0.00, '2019-10-19', 3, '2019-10-19 14:57:53', 0, 0, '2019-10-19 14:55:15', 2),
(372, 1474, 16, 56, 77, 'Aut. Samara santa fe', '1000.00', 0, 0.00, '2019-10-19', 17, '2019-10-19 17:08:15', 0, 0, '2019-10-19 17:01:59', 3),
(373, 1477, 14, 61, 64, 'Ped  4161', '6897.00', 0, 0.00, '2019-10-19', 3, '2019-10-19 19:01:15', 0, 0, '2019-10-19 18:14:18', 2),
(374, 1481, 9, 94, 64, 'Cxc omar bautista', '0.00', 0, 0.00, '2019-10-19', 3, '2019-10-19 21:08:35', 0, 0, '2019-10-19 20:14:48', 2),
(375, 1475, 14, 57, 64, '6474458', '2000.00', 0, 0.00, '2019-10-19', 3, '2019-10-19 22:13:27', 0, 0, '2019-10-19 21:49:50', 1),
(376, 1397, 16, 57, 64, '9524830', '4000.00', 0, 0.00, '2019-10-19', 3, '2019-10-19 23:49:52', 0, 0, '2019-10-19 23:36:20', 2),
(377, 1397, 16, 57, 64, '8413515', '8000.00', 0, 0.00, '2019-10-19', 3, '2019-10-19 23:49:54', 0, 0, '2019-10-19 23:37:17', 2),
(378, 1485, 14, 59, 64, '5306', '2000.00', 0, 0.00, '2019-10-20', 3, '2019-10-20 16:06:02', 0, 0, '2019-10-20 15:35:31', 1),
(379, 1486, 14, 55, 64, '0188', '1000.00', 0, 0.00, '2019-10-20', 3, '2019-10-20 16:32:54', 0, 0, '2019-10-20 16:28:43', 1),
(380, 1490, 9, 94, 64, 'Cxc best day id 74063040-1', '0.00', 0, 0.00, '2019-10-20', 3, '2019-10-20 21:52:16', 0, 0, '2019-10-20 21:49:29', 2),
(381, 1491, 9, 94, 64, 'CXC TURISKY L-V', '0.00', 0, 0.00, '2019-10-20', 3, '2019-10-20 23:14:28', 0, 0, '2019-10-20 22:44:06', 3),
(382, 1492, 16, 59, 64, 'Folio 435', '4600.00', 0, 0.00, '2019-10-20', 3, '2019-10-20 23:34:19', 0, 0, '2019-10-20 22:57:48', 2),
(383, 1495, 16, 55, 64, 'Paypal Formato 0189', '2000.00', 0, 0.00, '2019-10-20', NULL, NULL, 0, 0, '2019-10-20 23:03:36', 2),
(384, 1482, 16, 55, 64, 'Formato 0187', '1000.00', 0, 0.00, '2019-10-20', 3, '2019-10-20 23:25:24', 0, 0, '2019-10-20 23:06:47', 1),
(385, 1499, 9, 94, 64, 'cxc expedia', '0.00', 0, 0.00, '2019-10-21', 17, '2019-10-21 10:57:34', 0, 0, '2019-10-21 10:55:40', 2),
(386, 1508, 16, 61, 64, 'PEDIDO 4164', '7000.00', 0, 0.00, '2019-10-21', 17, '2019-10-21 12:55:40', 0, 0, '2019-10-21 12:52:20', 2),
(387, 1337, 14, 89, 93, '672745', '1000.00', 0, 0.00, '2019-10-21', 17, '2019-10-21 13:13:37', 0, 0, '2019-10-21 13:11:06', 1),
(388, 1511, 16, 57, 64, 'SPEI FOLIO 189970', '2000.00', 0, 0.00, '2019-09-29', 17, '2019-10-21 14:00:33', 0, 0, '2019-10-21 13:55:21', 2),
(389, 1418, 14, 57, 64, '0650736819', '3000.00', 0, 0.00, '2019-10-21', 17, '2019-10-21 14:04:23', 0, 0, '2019-10-21 14:00:30', 1),
(390, 1512, 9, 94, 64, 'cxc turisky', '0.00', 0, 0.00, '2019-10-21', 17, '2019-10-21 14:01:47', 0, 0, '2019-10-21 14:00:32', 2),
(391, 1513, 14, 55, 64, '0191', '1000.00', 0, 0.00, '2019-10-21', 17, '2019-10-21 14:19:23', 0, 0, '2019-10-21 14:15:32', 1),
(392, 1516, 9, 94, 64, 'FOLIO 0079121010', '21200.00', 0, 0.00, '2019-10-18', 17, '2019-10-21 14:48:32', 0, 0, '2019-10-21 14:44:47', 2),
(393, 1520, 14, 61, 64, 'ped 4167', '4798.00', 0, 0.00, '2019-10-21', 17, '2019-10-21 16:50:38', 0, 0, '2019-10-21 16:46:31', 2),
(394, 1517, 16, 61, 64, 'pedido 4171', '4598.00', 0, 0.00, '2019-10-21', 17, '2019-10-21 18:18:00', 0, 0, '2019-10-21 18:06:40', 2),
(395, 1523, 9, 60, 64, 'PAGA EN SITIO', '0.00', 0, 0.00, '2019-10-21', 17, '2019-10-21 18:21:53', 0, 0, '2019-10-21 18:21:06', 2),
(396, 1527, 16, 94, 64, 'PAGA EN SITIO', '0.00', 0, 0.00, '2019-10-21', 17, '2019-10-21 18:41:10', 0, 0, '2019-10-21 18:40:54', 2),
(397, 1530, 9, 94, 64, 'c xc price travel  locator 13409093-1', '0.00', 0, 0.00, '2019-10-21', 3, '2019-10-21 19:12:44', 0, 0, '2019-10-21 19:08:08', 2),
(398, 1531, 9, 94, 64, 'folio 0005228120', '7800.00', 0, 0.00, '2019-10-21', 3, '2019-10-21 19:23:19', 0, 0, '2019-10-21 19:13:58', 2),
(399, 1532, 9, 55, 75, 'edisonymax@hotmail.com', '1000.00', 0, 0.00, '2019-10-12', 3, '2019-10-21 22:34:17', 0, 0, '2019-10-21 19:20:35', 3),
(400, 1685, 14, 55, 64, '0121', '2000.00', 0, 0.00, '2019-09-27', 3, '2019-10-21 22:16:27', 0, 0, '2019-10-21 21:36:19', 1),
(401, 1529, 16, 55, 64, 'Formato 0192', '2000.00', 0, 0.00, '2019-10-21', 3, '2019-10-21 22:16:40', 0, 0, '2019-10-21 22:12:26', 2),
(402, 1539, 14, 55, 64, '0193', '1000.00', 0, 0.00, '2019-10-21', 3, '2019-10-21 23:26:52', 0, 0, '2019-10-21 23:13:43', 1),
(403, 1543, 9, 94, 64, 'Cxc booking', '0.00', 0, 0.00, '2019-10-21', 3, '2019-10-22 01:48:03', 0, 0, '2019-10-22 00:09:47', 2),
(404, 1515, 16, 57, 77, '0020321010', '2000.00', 0, 0.00, '2019-10-22', 3, '2019-10-22 10:33:47', 0, 0, '2019-10-22 10:10:39', 2),
(405, 1528, 16, 61, 64, 'Pedido 4178', '7000.00', 0, 0.00, '2019-10-22', 3, '2019-10-22 10:34:28', 0, 0, '2019-10-22 10:16:05', 2);
INSERT INTO `bitpagos_volar` (`id_bp`, `idres_bp`, `idreg_bp`, `metodo_bp`, `banco_bp`, `referencia_bp`, `cantidad_bp`, `moneda_bp`, `preciomoneda_bp`, `fecha_bp`, `idconc_bp`, `fechaconc_bp`, `comision_bp`, `cupon_bp`, `register`, `status`) VALUES
(406, 1545, 14, 61, 64, 'ped 4175', '7000.00', 0, 0.00, '2019-10-21', 17, '2019-10-22 11:02:02', 0, 0, '2019-10-22 10:58:45', 2),
(407, 1544, 9, 94, 64, 'cxc nomadic', '0.00', 0, 0.00, '2019-10-22', 17, '2019-10-22 11:06:25', 0, 0, '2019-10-22 11:05:07', 2),
(408, 1509, 16, 59, 64, 'Folio 2551 aut 662901', '2000.00', 0, 0.00, '2019-10-22', 17, '2019-10-22 11:36:35', 0, 0, '2019-10-22 11:31:14', 2),
(409, 1550, 9, 94, 64, 'clave de rastreo 085903782440329499', '41730.00', 0, 0.00, '2019-10-21', 17, '2019-10-22 12:28:48', 0, 0, '2019-10-22 12:16:39', 2),
(410, 1549, 14, 61, 64, 'PED 3862', '5798.00', 0, 0.00, '2019-08-17', 17, '2019-10-22 12:50:34', 0, 0, '2019-10-22 12:37:34', 2),
(411, 1554, 14, 61, 64, 'PED 3865', '2899.00', 0, 0.00, '2019-08-17', 17, '2019-10-22 12:50:48', 0, 0, '2019-10-22 12:38:20', 2),
(412, 1559, 9, 94, 64, 'cxc ketzaltour', '0.00', 0, 0.00, '2019-10-22', 17, '2019-10-22 14:25:00', 0, 0, '2019-10-22 14:23:37', 2),
(413, 1563, 14, 61, 64, '3987', '4598.00', 0, 0.00, '2019-09-10', 17, '2019-10-22 14:42:15', 0, 0, '2019-10-22 14:40:49', 2),
(414, 1908, 16, 59, 64, 'folio 7557 aut 088625', '10100.00', 0, 0.00, '2019-10-22', 3, '2019-10-22 15:02:04', 0, 0, '2019-10-22 15:01:29', 2),
(415, 1501, 14, 55, 64, 'paypal', '2000.00', 0, 0.00, '2019-10-21', 17, '2019-10-22 15:43:40', 0, 0, '2019-10-22 15:12:21', 1),
(416, 1713, 9, 94, 64, 'CLAVE RASTTEO 085901302120329599', '4700.00', 0, 0.00, '2019-10-22', 17, '2019-10-22 15:22:06', 0, 0, '2019-10-22 15:14:48', 2),
(417, 1717, 9, 94, 64, 'CLAVE DE RASTREO', '4700.00', 0, 0.00, '2019-10-22', 17, '2019-10-22 15:25:35', 0, 0, '2019-10-22 15:23:19', 2),
(418, 1566, 9, 94, 64, 'CXC TURISKY', '0.00', 0, 0.00, '2019-10-22', 17, '2019-10-22 15:42:25', 0, 0, '2019-10-22 15:38:23', 2),
(419, 1507, 16, 57, 64, 'folio 0743402653', '2000.00', 0, 0.00, '2019-10-22', 17, '2019-10-22 15:43:01', 0, 0, '2019-10-22 15:42:45', 0),
(420, 1567, 9, 94, 64, 'CXC TURISKY', '0.00', 0, 0.00, '2019-10-22', 17, '2019-10-22 16:04:45', 0, 0, '2019-10-22 15:52:25', 2),
(421, 1570, 9, 94, 64, 'CXC KAYTRIP', '0.00', 0, 0.00, '2019-10-22', 3, '2019-10-22 18:02:19', 0, 0, '2019-10-22 18:00:15', 2),
(422, 1573, 9, 94, 64, 'CXC TURISKY', '0.00', 0, 0.00, '2019-10-22', 3, '2019-10-22 18:24:22', 0, 0, '2019-10-22 18:17:03', 2),
(423, 1540, 16, 59, 64, 'MOV 000025736', '3000.00', 0, 0.00, '2019-10-22', 3, '2019-10-22 18:23:37', 0, 0, '2019-10-22 18:17:56', 1),
(424, 1576, 14, 59, 64, '142433', '1000.00', 0, 0.00, '2019-10-22', 3, '2019-10-22 19:00:16', 0, 0, '2019-10-22 18:57:17', 2),
(425, 1584, 14, 55, 64, '0196', '1000.00', 0, 0.00, '2019-10-22', 3, '2019-10-22 23:13:21', 0, 0, '2019-10-22 23:08:59', 1),
(426, 1586, 9, 94, 64, 'Cxc booking', '0.00', 0, 0.00, '2019-10-22', 3, '2019-10-23 00:11:01', 0, 0, '2019-10-22 23:16:04', 2),
(427, 1547, 14, 57, 64, '191023', '2000.00', 0, 0.00, '2019-10-23', 3, '2019-10-23 10:56:15', 0, 0, '2019-10-23 10:26:51', 1),
(428, 1583, 16, 89, 64, 'aprob 058078', '2000.00', 0, 0.00, '2019-10-09', 3, '2019-10-23 10:56:44', 0, 0, '2019-10-23 10:28:18', 2),
(429, 1587, 14, 59, 64, '9138', '2000.00', 0, 0.00, '2019-10-22', 3, '2019-10-23 11:11:47', 0, 0, '2019-10-23 10:38:56', 1),
(430, 1575, 14, 55, 64, '0195', '2000.00', 0, 0.00, '2019-10-23', 3, '2019-10-23 11:00:11', 0, 0, '2019-10-23 10:42:39', 1),
(431, 1591, 9, 94, 64, 'CXC KETZALTOUR', '0.00', 0, 0.00, '2019-10-23', 17, '2019-10-23 12:41:21', 0, 0, '2019-10-23 12:39:16', 3),
(432, 1593, 16, 61, 64, 'PEDIDO 4184', '4798.00', 0, 0.00, '2019-10-22', 17, '2019-10-23 12:54:43', 0, 0, '2019-10-23 12:51:36', 1),
(433, 1595, 14, 55, 64, '0201', '1000.00', 0, 0.00, '2019-10-23', 3, '2019-10-23 13:24:24', 0, 0, '2019-10-23 12:57:57', 1),
(434, 1576, 18, 90, 83, 'Pago en Sitio', '8200.00', 0, 0.00, '2019-10-23', NULL, NULL, 4, 0, '2019-10-23 13:07:46', 2),
(435, 1457, 18, 60, 83, 'Pago en Sitio', '1950.00', 0, 0.00, '2019-10-23', NULL, NULL, 0, 0, '2019-10-23 13:12:12', 2),
(436, 1392, 18, 60, 83, 'Pago en Sitio', '3798.00', 0, 0.00, '2019-10-23', NULL, NULL, 0, 0, '2019-10-23 13:12:44', 2),
(437, 1515, 18, 90, 83, 'Pago en Sitio', '5500.00', 0, 0.00, '2019-10-23', NULL, NULL, 4, 0, '2019-10-23 13:13:03', 2),
(438, 1481, 9, 56, 75, 'aut 036550', '4180.00', 0, 0.00, '2019-10-23', NULL, NULL, 0, 0, '2019-10-23 13:17:11', 4),
(439, 1596, 14, 55, 64, '0030', '2000.00', 0, 0.00, '2019-08-19', 17, '2019-10-23 13:30:41', 0, 0, '2019-10-23 13:20:07', 1),
(440, 1597, 9, 56, 75, 'aut 036550', '1690.00', 0, 0.00, '2019-10-23', 17, '2019-10-23 13:31:05', 0, 0, '2019-10-23 13:28:41', 2),
(441, 1451, 9, 56, 75, 'aut 036177', '1300.00', 0, 0.00, '2019-10-23', 17, '2019-10-23 13:34:45', 0, 0, '2019-10-23 13:33:21', 2),
(442, 1601, 9, 94, 64, 'TURISKY L-V', '0.00', 0, 0.00, '2019-10-23', 3, '2019-10-23 13:48:00', 0, 0, '2019-10-23 13:45:34', 2),
(443, 1795, 9, 94, 64, 'CXC GRAN TEOCALLI', '0.00', 0, 0.00, '2019-10-23', 17, '2019-10-23 14:03:21', 0, 0, '2019-10-23 14:02:13', 2),
(444, 1603, 16, 89, 64, 'aprob 413041', '2000.00', 0, 0.00, '2019-10-23', 17, '2019-10-23 14:12:35', 0, 0, '2019-10-23 14:10:12', 1),
(445, 1598, 16, 59, 64, 'folio 7159 aut 045806', '2000.00', 0, 0.00, '2019-10-23', 17, '2019-10-23 14:22:36', 0, 0, '2019-10-23 14:20:18', 2),
(446, 1582, 16, 59, 64, '25756', '6500.00', 0, 0.00, '2019-10-23', 17, '2019-10-23 14:48:50', 0, 0, '2019-10-23 14:45:25', 2),
(447, 1607, 9, 57, 64, 'clave de rastreo 085901255084326797', '2500.00', 0, 0.00, '2019-09-24', 17, '2019-10-23 15:03:38', 0, 0, '2019-10-23 15:00:53', 3),
(448, 1605, 9, 94, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-10-23', 17, '2019-10-23 15:04:22', 0, 0, '2019-10-23 15:01:59', 2),
(449, 1606, 9, 94, 64, 'GALLEGO TOURS', '0.00', 0, 0.00, '2019-10-23', 17, '2019-10-23 15:04:02', 0, 0, '2019-10-23 15:02:48', 3),
(450, 1609, 9, 94, 64, 'GORILAS TOURS', '0.00', 0, 0.00, '2019-10-22', 17, '2019-10-23 15:22:35', 0, 0, '2019-10-23 15:21:43', 3),
(451, 1570, 9, 94, 64, 'folio  0027489034', '6000.00', 0, 0.00, '2019-10-23', 17, '2019-10-23 15:51:35', 0, 0, '2019-10-23 15:43:16', 3),
(452, 1611, 14, 57, 64, '231019', '2000.00', 0, 0.00, '2019-10-23', 17, '2019-10-23 15:51:18', 0, 0, '2019-10-23 15:44:39', 1),
(453, 1706, 16, 89, 64, 'aprob: 212245', '2000.00', 0, 0.00, '2019-10-23', 17, '2019-10-23 16:46:26', 0, 0, '2019-10-23 16:40:54', 2),
(454, 1623, 16, 89, 64, 'aprob: T01721', '1000.00', 0, 0.00, '2019-10-23', 17, '2019-10-23 17:26:00', 0, 0, '2019-10-23 17:23:31', 2),
(455, 1625, 9, 94, 64, 'CXC BESTDAY ID 74050582-1', '0.00', 0, 0.00, '2019-10-23', 17, '2019-10-23 17:48:59', 0, 0, '2019-10-23 17:47:42', 2),
(456, 1837, 9, 57, 64, 'Clave de rastreo BB92690008445', '780.00', 0, 0.00, '2019-10-22', 17, '2019-10-23 18:00:41', 0, 0, '2019-10-23 17:57:00', 1),
(457, 1630, 9, 61, 64, 'CONEKTA PED 4192 PAGO TC', '4598.00', 0, 0.00, '2019-10-23', 17, '2019-10-23 18:21:38', 0, 0, '2019-10-23 18:17:35', 2),
(458, 1569, 15, 57, 64, '83528', '12200.00', 0, 0.00, '2019-10-23', 3, '2019-10-23 18:36:46', 0, 0, '2019-10-23 18:29:16', 3),
(459, 1541, 16, 56, 77, 'folio 617094 aut 315921', '1000.00', 0, 0.00, '2019-10-23', 17, '2019-10-23 22:33:55', 0, 0, '2019-10-23 22:29:48', 3),
(460, 1634, 16, 55, 64, 'Formato 0204', '1000.00', 0, 0.00, '2019-10-23', 17, '2019-10-23 22:59:19', 0, 0, '2019-10-23 22:49:20', 2),
(461, 1644, 16, 55, 64, 'Formato 0203', '100.00', 0, 0.00, '2019-10-23', 17, '2019-10-23 23:10:49', 0, 0, '2019-10-23 23:05:20', 3),
(462, 1644, 16, 55, 64, 'Formato ,0203', '900.00', 0, 0.00, '2019-10-23', 17, '2019-10-23 23:10:47', 0, 0, '2019-10-23 23:09:39', 2),
(463, 1636, 9, 94, 64, 'Cxc trip advisor', '0.00', 0, 0.00, '2019-10-24', 17, '2019-10-24 10:35:26', 0, 0, '2019-10-24 01:21:00', 2),
(464, 1638, 9, 94, 64, 'cxc booking', '0.00', 0, 0.00, '2019-10-24', 17, '2019-10-24 10:37:53', 0, 0, '2019-10-24 10:36:23', 2),
(465, 1591, 9, 94, 64, 'clave rastreo 65607600', '40537.00', 0, 0.00, '2019-10-23', 17, '2019-10-24 10:59:36', 0, 0, '2019-10-24 10:40:44', 2),
(466, 1496, 14, 55, 64, '0205', '1000.00', 0, 0.00, '2019-10-24', 17, '2019-10-24 12:27:29', 0, 0, '2019-10-24 12:23:32', 1),
(467, 1609, 9, 60, 83, 'GORILAS TOURS', '40000.00', 0, 0.00, '2019-10-24', NULL, NULL, 0, 0, '2019-10-24 12:53:34', 2),
(468, 1645, 14, 61, 64, 'PED 3854', '13895.00', 0, 0.00, '2019-08-16', 17, '2019-10-24 13:34:06', 0, 0, '2019-10-24 13:30:52', 2),
(469, 1719, 14, 57, 64, '0000026', '2000.00', 0, 0.00, '2019-10-24', 17, '2019-10-24 14:07:53', 0, 0, '2019-10-24 14:02:59', 2),
(470, 1647, 16, 61, 64, 'PEDIDO 3934', '11596.00', 0, 0.00, '2019-09-03', 17, '2019-10-24 14:28:08', 0, 0, '2019-10-24 14:22:40', 2),
(471, 1649, 16, 56, 64, 'Deposito en efectivo Folio 4006 Aut. 755967', '1000.00', 0, 0.00, '2019-10-01', 17, '2019-10-24 14:29:49', 0, 0, '2019-10-24 14:27:01', 2),
(472, 1650, 16, 61, 64, 'pedido 3884', '15000.00', 0, 0.00, '2019-08-20', 17, '2019-10-24 14:36:26', 0, 0, '2019-10-24 14:31:01', 3),
(473, 1654, 16, 57, 64, 'Spei Folio 5050288909', '2000.00', 0, 0.00, '2019-08-17', 17, '2019-10-24 14:48:13', 0, 0, '2019-10-24 14:41:09', 2),
(474, 1656, 16, 55, 64, 'PAYPAL FORMATO 156 ALEJANDRA JIMENEZ', '2000.00', 0, 0.00, '2019-10-09', 17, '2019-10-24 14:57:59', 0, 0, '2019-10-24 14:53:28', 2),
(475, 1657, 16, 55, 64, 'AYPAL FORMATO 0159 JOHANA HERNANDEZ', '2000.00', 0, 0.00, '2019-10-10', 17, '2019-10-24 15:26:48', 0, 0, '2019-10-24 15:14:39', 2),
(476, 1659, 14, 57, 64, '0920670190', '2000.00', 0, 0.00, '2019-10-24', 17, '2019-10-24 17:01:28', 0, 0, '2019-10-24 16:47:20', 1),
(477, 1667, 16, 57, 64, 'SPEI FOLIO 0043387008', '2000.00', 0, 0.00, '2019-09-09', 17, '2019-10-24 17:56:16', 0, 0, '2019-10-24 17:45:50', 2),
(478, 1662, 16, 57, 64, 'FOLIO 0924447348', '2000.00', 0, 0.00, '2019-10-24', 17, '2019-10-24 18:03:11', 0, 0, '2019-10-24 17:59:40', 2),
(479, 1673, 16, 61, 64, 'PEDIDO 4197', '8900.00', 0, 0.00, '2019-10-24', 17, '2019-10-24 18:56:56', 0, 0, '2019-10-24 18:53:51', 2),
(480, 1675, 9, 94, 64, 'KAANA TOURS', '0.00', 0, 0.00, '2019-10-23', 17, '2019-10-24 19:05:56', 0, 0, '2019-10-24 18:57:52', 2),
(481, 1674, 9, 94, 64, 'CXC OMAR BAUTISTA', '0.00', 0, 0.00, '2019-10-24', 17, '2019-10-24 19:03:03', 0, 0, '2019-10-24 19:02:09', 2),
(482, 1679, 18, 55, 64, '5H503078D9755090S', '2000.00', 0, 0.00, '2019-09-25', 17, '2019-10-24 19:44:39', 0, 0, '2019-10-24 19:41:16', 3),
(483, 1604, 16, 57, 64, 'Clave 29796', '2000.00', 0, 0.00, '2019-10-24', 17, '2019-10-24 21:09:16', 0, 0, '2019-10-24 21:02:49', 2),
(484, 1646, 16, 61, 64, 'Pedido 4200', '4598.00', 0, 0.00, '2019-10-24', 17, '2019-10-24 21:39:14', 0, 0, '2019-10-24 21:22:30', 2),
(485, 1676, 16, 55, 64, 'Formato 0206', '1000.00', 0, 0.00, '2019-10-24', 17, '2019-10-24 23:02:11', 0, 0, '2019-10-24 23:00:46', 2),
(486, 1683, 9, 94, 64, 'Cxc  trip advisor', '0.00', 0, 0.00, '2019-10-24', 17, '2019-10-25 11:15:47', 0, 0, '2019-10-25 00:57:04', 2),
(487, 1689, 14, 57, 64, 'mov 00000024', '1000.00', 0, 0.00, '2019-10-25', 17, '2019-10-25 11:11:39', 0, 0, '2019-10-25 11:03:43', 2),
(488, 1681, 9, 94, 64, 'cxc price travel locator 13443381-1', '0.00', 0, 0.00, '2019-10-25', 17, '2019-10-25 11:15:28', 0, 0, '2019-10-25 11:13:36', 2),
(489, 1688, 9, 94, 64, '2019-10-07	2000.00 - FOLIO 0020195008', '2000.00', 0, 0.00, '2019-10-25', 17, '2019-10-25 11:25:36', 0, 0, '2019-10-25 11:23:14', 2),
(490, 1691, 14, 59, 64, 'MOV 000000000023348', '4000.00', 0, 0.00, '2019-09-14', 17, '2019-10-25 11:50:06', 0, 0, '2019-10-25 11:40:52', 2),
(491, 1690, 16, 55, 64, 'formato 209', '2000.00', 0, 0.00, '2019-10-25', 17, '2019-10-25 12:01:59', 0, 0, '2019-10-25 12:01:33', 2),
(492, 1589, 16, 61, 64, 'PEDIDO 4205', '5398.00', 0, 0.00, '2019-10-25', 17, '2019-10-25 12:17:28', 0, 0, '2019-10-25 12:11:58', 2),
(493, 1694, 16, 57, 64, 'Spei Folio 0041981007', '2000.00', 0, 0.00, '2019-08-31', 17, '2019-10-25 12:31:55', 0, 0, '2019-10-25 12:29:51', 2),
(494, 1635, 11, 55, 75, '0208', '1000.00', 0, 0.00, '2019-10-25', 3, '2019-10-25 13:15:13', 0, 0, '2019-10-25 13:14:41', 1),
(495, 1580, 16, 56, 96, 'FOLIO 806132 AUT 1339770', '1000.00', 0, 0.00, '2019-10-25', 3, '2019-10-25 13:30:46', 0, 0, '2019-10-25 13:18:07', 2),
(496, 1699, 9, 94, 64, 'CXC BEST DAY ID 73929685-1', '0.00', 0, 0.00, '2019-10-25', 17, '2019-10-25 13:58:35', 0, 0, '2019-10-25 13:57:07', 2),
(497, 1698, 14, 55, 64, '0018', '2000.00', 0, 0.00, '2019-08-12', 17, '2019-10-25 14:06:26', 0, 0, '2019-10-25 14:05:51', 1),
(498, 1700, 14, 55, 64, '0180', '1000.00', 0, 0.00, '2019-10-17', 17, '2019-10-25 14:11:46', 0, 0, '2019-10-25 14:11:17', 1),
(499, 1703, 16, 59, 64, 'folio 3772 aut 835513', '2000.00', 0, 0.00, '2019-10-25', 17, '2019-10-25 15:40:24', 0, 0, '2019-10-25 15:37:41', 1),
(500, 1642, 14, 55, 64, '0207', '1000.00', 0, 0.00, '2019-10-24', 17, '2019-10-25 15:43:54', 0, 0, '2019-10-25 15:38:03', 1),
(501, 1459, 16, 57, 64, '856387', '2000.00', 0, 0.00, '2019-10-25', 17, '2019-10-25 15:46:31', 0, 0, '2019-10-25 15:41:18', 2),
(502, 1651, 9, 55, 75, 'szarate@indoamericana.edu.co', '1000.00', 0, 0.00, '2019-10-25', 17, '2019-10-25 15:48:16', 0, 0, '2019-10-25 15:43:59', 2),
(503, 1704, 9, 94, 64, 'CXC TEOCALLI', '0.00', 0, 0.00, '2019-10-25', 17, '2019-10-25 15:52:48', 0, 0, '2019-10-25 15:51:33', 2),
(504, 1701, 14, 57, 64, 'fol 1006835883', '2000.00', 0, 0.00, '2019-10-25', 17, '2019-10-25 16:59:36', 0, 0, '2019-10-25 16:55:55', 1),
(505, 1708, 9, 94, 64, 'CXC BESTDAY ID 73891316-1', '0.00', 0, 0.00, '2019-10-25', 17, '2019-10-25 17:34:10', 0, 0, '2019-10-25 17:32:41', 2),
(506, 1711, 9, 94, 64, 'cxc bestday id 73891316-1', '0.00', 0, 0.00, '2019-10-25', 17, '2019-10-25 17:55:12', 0, 0, '2019-10-25 17:53:33', 2),
(507, 1721, 9, 94, 64, 'cxc booking', '0.00', 0, 0.00, '2019-10-25', 17, '2019-10-25 19:09:07', 0, 0, '2019-10-25 19:05:49', 2),
(508, 1714, 16, 57, 64, 'cta 20581', '4850.00', 0, 0.00, '2019-10-25', 17, '2019-10-25 19:08:50', 0, 0, '2019-10-25 19:06:42', 3),
(509, 1723, 9, 94, 64, 'cxc booking', '0.00', 0, 0.00, '2019-10-25', 17, '2019-10-25 19:27:15', 0, 0, '2019-10-25 19:18:11', 2),
(510, 1718, 16, 57, 64, '0002833020', '2000.00', 0, 0.00, '2019-10-25', 3, '2019-10-25 19:39:04', 0, 0, '2019-10-25 19:25:01', 2),
(511, 1675, 9, 57, 64, 'CLAVE RASTREO 085903554390328891', '3900.00', 0, 0.00, '2019-10-25', NULL, NULL, 0, 0, '2019-10-25 19:32:57', 4),
(512, 1626, 14, 57, 64, '00000001', '2000.00', 0, 0.00, '2019-10-25', 3, '2019-10-25 21:27:43', 0, 0, '2019-10-25 21:21:42', 1),
(513, 1729, 9, 55, 75, 'GUILLERMO RECATERO', '1000.00', 0, 0.00, '2019-10-23', NULL, NULL, 0, 0, '2019-10-25 22:26:26', 0),
(514, 1731, 9, 94, 64, 'Cxc overseas mexico', '0.00', 0, 0.00, '2019-10-26', 3, '2019-10-26 11:00:41', 0, 0, '2019-10-26 02:48:21', 2),
(515, 1732, 9, 94, 64, 'Cxc booking', '0.00', 0, 0.00, '2019-10-26', 3, '2019-10-26 11:01:01', 0, 0, '2019-10-26 02:49:03', 2),
(516, 1712, 16, 57, 64, '1646662', '2000.00', 0, 0.00, '2019-10-26', 3, '2019-10-26 11:36:46', 0, 0, '2019-10-26 11:29:33', 2),
(517, 1735, 14, 55, 64, '0211', '1000.00', 0, 0.00, '2019-10-25', NULL, NULL, 0, 0, '2019-10-26 11:33:12', 1),
(518, 1674, 9, 94, 64, 'Aut 075860', '1450.00', 0, 0.00, '2019-10-26', 3, '2019-10-26 14:29:18', 0, 0, '2019-10-26 13:34:39', 2),
(519, 1669, 14, 59, 64, '000025816', '1000.00', 0, 0.00, '2019-10-26', 3, '2019-10-26 14:45:42', 0, 0, '2019-10-26 14:38:51', 1),
(520, 1743, 14, 57, 64, '1107325386', '5000.00', 0, 0.00, '2019-10-26', 3, '2019-10-26 20:47:18', 0, 0, '2019-10-26 20:40:31', 1),
(521, 1731, 9, 94, 64, 'Folio internet  0053016011', '2150.00', 0, 0.00, '2019-10-26', 3, '2019-10-26 22:13:59', 0, 0, '2019-10-26 22:07:28', 2),
(522, 1744, 16, 60, 64, 'Paga en sitio', '0.00', 0, 0.00, '2019-10-26', 3, '2019-10-26 23:04:56', 0, 0, '2019-10-26 23:02:15', 3),
(523, 1745, 9, 94, 83, 'GUÃA RUSA ANGELINA', '0.00', 0, 0.00, '2019-10-27', NULL, NULL, 0, 0, '2019-10-27 12:42:06', 2),
(524, 1729, 9, 55, 75, 'Wallace_rr@hotmail.com', '1000.00', 0, 0.00, '2019-10-27', 17, '2019-10-27 12:49:40', 0, 0, '2019-10-27 12:46:32', 2),
(525, 1746, 9, 94, 64, 'Cxc tu experiencia', '0.00', 0, 0.00, '2019-10-27', 17, '2019-10-27 13:28:58', 0, 0, '2019-10-27 13:05:37', 2),
(526, 1886, 14, 61, 64, 'Ped 1748', '5598.00', 0, 0.00, '2019-10-27', 17, '2019-10-27 13:33:38', 0, 0, '2019-10-27 13:32:12', 1),
(527, 1740, 16, 56, 75, 'Aut 658120 folio 636138', '1000.00', 0, 0.00, '2019-10-26', 3, '2019-10-27 15:07:23', 0, 0, '2019-10-27 14:55:55', 2),
(528, 1752, 9, 94, 64, 'Cxc best day id 74092686-1', '0.00', 0, 0.00, '2019-10-27', 3, '2019-10-27 15:07:45', 0, 0, '2019-10-27 15:04:28', 2),
(529, 1771, 14, 59, 64, '7457', '2000.00', 0, 0.00, '2019-10-27', 3, '2019-10-27 15:40:11', 0, 0, '2019-10-27 15:32:31', 3),
(530, 1759, 14, 55, 64, '0214', '1000.00', 0, 0.00, '2019-10-27', 3, '2019-10-27 17:56:33', 0, 0, '2019-10-27 16:59:33', 1),
(531, 1755, 16, 55, 64, 'FORMATO 0215', '2000.00', 0, 0.00, '2019-10-27', 17, '2019-10-27 17:14:09', 0, 0, '2019-10-27 17:05:59', 1),
(532, 1760, 9, 94, 64, 'EXPLORA TEOTIHUACAN', '0.00', 0, 0.00, '2019-10-27', 3, '2019-10-27 17:32:03', 0, 0, '2019-10-27 17:30:21', 2),
(533, 1766, 9, 61, 64, 'Conekta pedido 4216', '4598.00', 0, 0.00, '2019-10-27', 17, '2019-10-27 20:28:59', 0, 0, '2019-10-27 20:26:02', 2),
(534, 1767, 14, 61, 64, '4212', '6897.00', 0, 0.00, '2019-10-27', 3, '2019-10-27 21:08:26', 0, 0, '2019-10-27 20:57:41', 2),
(535, 1768, 14, 57, 64, 'Aut 109932', '2000.00', 0, 0.00, '2019-10-27', 3, '2019-10-28 08:56:19', 0, 0, '2019-10-28 07:35:29', 1),
(536, 1770, 14, 55, 64, '0153', '1000.00', 0, 0.00, '2019-10-07', 17, '2019-10-28 12:08:02', 0, 0, '2019-10-28 12:04:07', 1),
(537, 1772, 9, 94, 64, 'cxc gran teocalli', '0.00', 0, 0.00, '2019-10-28', 17, '2019-10-28 12:44:44', 0, 0, '2019-10-28 12:43:54', 2),
(538, 1762, 16, 55, 64, 'formato 0216', '2000.00', 0, 0.00, '2019-10-28', 17, '2019-10-28 13:14:35', 0, 0, '2019-10-28 13:12:57', 2),
(539, 1773, 14, 61, 64, '4220', '5598.00', 0, 0.00, '2019-10-28', 17, '2019-10-28 13:33:27', 0, 0, '2019-10-28 13:20:12', 3),
(540, 1774, 14, 59, 64, '0000000027', '1300.00', 0, 0.00, '2019-10-28', 17, '2019-10-28 13:46:30', 0, 0, '2019-10-28 13:41:26', 1),
(541, 1709, 16, 89, 64, 'APROB: H08465', '1000.00', 0, 0.00, '2019-10-28', 17, '2019-10-28 13:48:51', 0, 0, '2019-10-28 13:42:59', 2),
(542, 1775, 9, 94, 64, 'cxc kaytrip', '0.00', 0, 0.00, '2019-10-28', 3, '2019-10-28 14:12:57', 0, 0, '2019-10-28 14:02:37', 2),
(543, 1776, 14, 55, 64, '21864', '2000.00', 0, 0.00, '2019-07-19', 17, '2019-10-28 14:35:46', 0, 0, '2019-10-28 14:28:47', 2),
(544, 1533, 14, 57, 64, 'ref 191028', '2000.00', 0, 0.00, '2019-10-28', 17, '2019-10-28 14:44:35', 0, 0, '2019-10-28 14:40:01', 1),
(545, 1780, 9, 94, 64, 'cxc turisky', '0.00', 0, 0.00, '2019-10-28', 17, '2019-10-28 14:55:11', 0, 0, '2019-10-28 14:50:39', 2),
(546, 1788, 9, 94, 64, 'cxc bestday id 74096257-1', '0.00', 0, 0.00, '2019-10-28', 17, '2019-10-28 15:59:24', 0, 0, '2019-10-28 15:57:43', 2),
(547, 1794, 9, 94, 64, 'cxc gran teocalli', '0.00', 0, 0.00, '2019-10-28', 17, '2019-10-28 16:29:22', 0, 0, '2019-10-28 16:28:07', 2),
(548, 1795, 9, 94, 64, 'CXC GRAN TEOCALLI', '0.00', 0, 0.00, '2019-10-28', 3, '2019-10-28 17:25:44', 0, 0, '2019-10-28 16:40:03', 2),
(549, 1805, 14, 57, 64, '23946', '2000.00', 0, 0.00, '2019-10-02', 17, '2019-10-28 17:44:32', 0, 0, '2019-10-28 17:42:30', 1),
(550, 1724, 14, 59, 64, '9836', '2000.00', 0, 0.00, '2019-10-28', 17, '2019-10-28 17:55:57', 0, 0, '2019-10-28 17:49:17', 1),
(551, 1806, 14, 55, 64, '0016', '2000.00', 0, 0.00, '2019-08-11', 17, '2019-10-28 18:24:58', 0, 0, '2019-10-28 18:19:08', 1),
(552, 1807, 16, 57, 64, '7136223860', '9280.00', 0, 0.00, '2019-10-28', 17, '2019-10-28 19:04:48', 0, 0, '2019-10-28 18:31:12', 3),
(553, 1793, 16, 89, 64, 'aprob 696171', '2000.00', 0, 0.00, '2019-10-28', 3, '2019-10-28 18:50:33', 0, 0, '2019-10-28 18:48:29', 2),
(554, 1811, 9, 94, 64, 'Cxc best day id 74098991-1', '0.00', 0, 0.00, '2019-10-29', 3, '2019-10-29 11:37:47', 0, 0, '2019-10-29 02:29:39', 2),
(555, 1859, 9, 94, 64, 'CXC WAYAK', '0.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 11:49:16', 0, 0, '2019-10-29 11:47:39', 2),
(556, 1816, 16, 60, 64, 'PAGO EN SITIO CON MARY', '2399.00', 0, 0.00, '2019-10-27', 17, '2019-10-29 11:49:30', 0, 0, '2019-10-29 11:47:53', 3),
(557, 1817, 9, 94, 64, 'CXC TU EXPERIENCIA', '0.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 12:00:04', 0, 0, '2019-10-29 11:52:05', 2),
(558, 1789, 14, 57, 64, '734062', '2000.00', 0, 0.00, '2019-10-28', 17, '2019-10-29 12:35:55', 0, 0, '2019-10-29 12:20:46', 1),
(559, 1821, 14, 89, 64, 'aprob 002166', '2000.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 13:05:19', 0, 0, '2019-10-29 13:01:21', 2),
(560, 1827, 14, 57, 64, '0088396008', '2000.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 13:18:21', 0, 0, '2019-10-29 13:12:53', 1),
(561, 1822, 14, 55, 64, '0217', '1000.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 13:41:48', 0, 0, '2019-10-29 13:17:59', 1),
(562, 1823, 16, 89, 64, 'APROB 527342', '2000.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 13:42:09', 0, 0, '2019-10-29 13:34:19', 2),
(563, 1832, 9, 94, 64, 'cxc turisky', '0.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 14:13:39', 0, 0, '2019-10-29 14:11:12', 2),
(564, 1837, 9, 57, 64, 'FOLIO 1150 AUT 307920', '1300.00', 0, 0.00, '2019-10-28', 17, '2019-10-29 14:57:53', 0, 0, '2019-10-29 14:52:40', 1),
(565, 1837, 9, 57, 64, 'REF. 9627800', '3920.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 14:58:24', 0, 0, '2019-10-29 14:53:25', 1),
(566, 1836, 9, 94, 64, 'cxc tu experiencia', '0.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 15:13:32', 0, 0, '2019-10-29 15:11:21', 2),
(567, 1839, 9, 94, 64, 'cxc kaytrip', '0.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 15:35:40', 0, 0, '2019-10-29 15:33:51', 2),
(568, 1840, 9, 94, 64, 'cxc expedia', '0.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 15:48:10', 0, 0, '2019-10-29 15:47:10', 2),
(569, 1838, 14, 55, 64, 'paypal', '1000.00', 0, 0.00, '2019-06-18', 17, '2019-10-29 16:10:17', 0, 0, '2019-10-29 15:50:13', 1),
(570, 1841, 9, 94, 64, 'cxc expedia', '0.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 15:51:53', 0, 0, '2019-10-29 15:51:02', 2),
(571, 1842, 9, 94, 64, 'cxc explora y descubre', '0.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 15:58:42', 0, 0, '2019-10-29 15:56:27', 2),
(572, 1835, 16, 57, 64, '1343910879', '2000.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 16:03:07', 0, 0, '2019-10-29 16:00:12', 2),
(573, 1843, 9, 94, 64, 'cxc price travel locator 13374232-1', '0.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 16:03:25', 0, 0, '2019-10-29 16:01:15', 2),
(574, 1845, 14, 55, 64, 'paypal', '1750.00', 0, 0.00, '2019-05-14', 17, '2019-10-29 16:25:39', 0, 0, '2019-10-29 16:22:07', 1),
(575, 1851, 14, 55, 64, '136', '2000.00', 0, 0.00, '2019-10-03', 17, '2019-10-29 17:08:23', 0, 0, '2019-10-29 16:55:37', 2),
(576, 1852, 14, 55, 64, '0132', '1000.00', 0, 0.00, '2019-10-02', 17, '2019-10-29 17:37:45', 0, 0, '2019-10-29 17:26:20', 2),
(577, 1857, 14, 55, 64, '21126', '2399.00', 0, 0.00, '2019-04-30', 17, '2019-10-29 17:52:25', 0, 0, '2019-10-29 17:50:46', 2),
(578, 1859, 9, 94, 64, 'CXC WAYAK', '0.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 18:01:12', 0, 0, '2019-10-29 17:58:14', 2),
(579, 1860, 14, 57, 64, '265468', '9596.00', 0, 0.00, '2019-10-09', 17, '2019-10-29 18:03:38', 0, 0, '2019-10-29 18:00:30', 2),
(580, 1862, 9, 94, 64, 'CXC WAYAK', '0.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 18:09:01', 0, 0, '2019-10-29 18:07:38', 2),
(581, 1863, 9, 94, 64, 'CLAVE DE RASREO 085907634680330193', '4700.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 18:30:15', 0, 0, '2019-10-29 18:22:49', 2),
(582, 1864, 9, 94, 64, 'CXC TU EXPERIENCIA', '0.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 18:49:40', 0, 0, '2019-10-29 18:48:00', 2),
(583, 1866, 9, 94, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 18:56:30', 0, 0, '2019-10-29 18:51:25', 2),
(584, 1837, 3, 55, 83, 'Pago en Sitio', '-1840.00', 0, 0.00, '2019-10-29', NULL, NULL, 0, 0, '2019-10-29 19:03:29', 2),
(585, 1808, 14, 57, 64, '191029', '2000.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 19:14:13', 0, 0, '2019-10-29 19:09:23', 1),
(586, 1869, 9, 57, 64, 'CLAVE RASTREO 085905163890329895', '6000.00', 0, 0.00, '2019-10-25', 17, '2019-10-29 19:14:34', 0, 0, '2019-10-29 19:10:46', 2),
(587, 1834, 16, 57, 64, '0042234009', '2000.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 19:42:26', 0, 0, '2019-10-29 19:26:50', 2),
(588, 1871, 9, 94, 64, 'TURISKY L-V', '0.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 19:35:57', 0, 0, '2019-10-29 19:27:52', 2),
(589, 1872, 9, 94, 64, 'ESPIRITU AVENTURERO', '0.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 19:36:14', 0, 0, '2019-10-29 19:34:52', 2),
(590, 1846, 16, 55, 64, 'FORMATO 0219', '1000.00', 0, 0.00, '2019-10-29', 17, '2019-10-29 19:52:10', 0, 0, '2019-10-29 19:46:00', 2),
(591, 1875, 16, 55, 64, 'Formato 0220', '2000.00', 0, 0.00, '2019-10-29', 3, '2019-10-29 20:25:21', 0, 0, '2019-10-29 20:21:45', 2),
(592, 1833, 14, 55, 64, '0218', '1000.00', 0, 0.00, '2019-10-28', 17, '2019-10-30 11:52:09', 0, 0, '2019-10-30 11:46:57', 1),
(593, 1917, 9, 94, 64, 'clave de rastreo 085905021140330296', '5425.00', 0, 0.00, '2019-10-30', 17, '2019-10-30 13:06:45', 0, 0, '2019-10-30 13:02:55', 2),
(594, 1861, 16, 59, 64, 'folio 2641 aut 034879', '2000.00', 0, 0.00, '2019-10-30', 17, '2019-10-30 13:22:37', 0, 0, '2019-10-30 13:18:34', 2),
(595, 1885, 9, 94, 64, '2019-10-15	13650.00 - folio 0001464 aut 867155', '13650.00', 0, 0.00, '2019-10-30', 17, '2019-10-30 13:35:43', 0, 0, '2019-10-30 13:32:37', 2),
(596, 1849, 16, 59, 64, 'FOLIO 7146 AUT 113551', '2000.00', 0, 0.00, '2019-10-30', 17, '2019-10-30 13:36:20', 0, 0, '2019-10-30 13:34:44', 2),
(597, 1892, 9, 94, 64, 'TEOCALLI', '0.00', 0, 0.00, '2019-10-30', 17, '2019-10-30 15:11:32', 0, 0, '2019-10-30 15:10:33', 2),
(598, 1544, 9, 94, 64, 'clave de rastreo  085902503690329897', '12180.00', 0, 0.00, '2019-10-30', 17, '2019-10-30 15:34:16', 0, 0, '2019-10-30 15:27:37', 2),
(599, 1893, 9, 94, 64, 'cxc booking', '0.00', 0, 0.00, '2019-10-30', 17, '2019-10-30 15:41:17', 0, 0, '2019-10-30 15:40:08', 1),
(600, 1897, 9, 55, 75, 'natalia_0320@hotmail.com', '1000.00', 0, 0.00, '2019-10-07', 17, '2019-10-30 16:04:56', 0, 0, '2019-10-30 16:03:29', 2),
(601, 1898, 9, 94, 64, 'cxc omar bautista', '0.00', 0, 0.00, '2019-10-30', 17, '2019-10-30 16:24:31', 0, 0, '2019-10-30 16:22:46', 2),
(602, 1900, 9, 89, 64, 'APROBACION 931406', '1000.00', 0, 0.00, '2019-10-30', 3, '2019-10-30 17:06:26', 0, 0, '2019-10-30 16:56:24', 2),
(603, 1900, 9, 89, 64, 'APROBACION 046528', '1000.00', 0, 0.00, '2019-10-30', 3, '2019-10-30 17:06:24', 0, 0, '2019-10-30 16:56:55', 2),
(604, 1761, 16, 59, 64, 'folio 8291 aut 023004', '2000.00', 0, 0.00, '2019-10-30', 17, '2019-10-30 17:51:19', 0, 0, '2019-10-30 17:48:01', 2),
(605, 1876, 16, 57, 64, '282841', '2000.00', 0, 0.00, '2019-10-30', 17, '2019-10-30 17:51:54', 0, 0, '2019-10-30 17:50:50', 2),
(606, 1874, 16, 59, 64, '25894', '3000.00', 0, 0.00, '2019-10-30', 17, '2019-10-30 17:56:48', 0, 0, '2019-10-30 17:53:51', 2),
(607, 1437, 16, 61, 64, 'pedido 4224', '6098.00', 0, 0.00, '2019-10-30', 17, '2019-10-30 19:14:44', 0, 0, '2019-10-30 19:12:07', 2),
(608, 1887, 14, 89, 64, '002886', '2000.00', 0, 0.00, '2019-10-30', 17, '2019-10-30 19:22:09', 0, 0, '2019-10-30 19:19:45', 1),
(609, 1902, 14, 61, 64, '4227', '7000.00', 0, 0.00, '2019-10-30', 3, '2019-10-30 19:58:38', 0, 0, '2019-10-30 19:43:05', 1),
(610, 1778, 16, 59, 64, 'Folio 2701 aut 098850', '2000.00', 0, 0.00, '2019-10-30', 17, '2019-10-30 21:12:35', 0, 0, '2019-10-30 21:07:53', 2),
(611, 1896, 16, 59, 64, 'Folio 9882 aut 400021', '2000.00', 0, 0.00, '2019-10-30', 3, '2019-10-30 21:54:56', 0, 0, '2019-10-30 21:45:16', 2),
(612, 1903, 9, 94, 64, 'CXC TU EXPERIENCIA', '0.00', 0, 0.00, '2019-10-30', 17, '2019-10-30 22:15:19', 0, 0, '2019-10-30 22:14:01', 2),
(613, 1904, 16, 55, 64, 'Formato 0222', '2000.00', 0, 0.00, '2019-10-30', 17, '2019-10-31 00:14:30', 0, 0, '2019-10-31 00:11:36', 2),
(614, 1905, 9, 94, 64, 'Cxc tu experiencia', '0.00', 0, 0.00, '2019-10-30', 17, '2019-10-31 00:21:55', 0, 0, '2019-10-31 00:20:26', 2),
(615, 1882, 14, 57, 64, '1497161389', '2000.00', 0, 0.00, '2019-10-31', 17, '2019-10-31 11:55:37', 0, 0, '2019-10-31 11:48:08', 1),
(616, 1906, 9, 61, 64, 'conekta ped 4233 pago tc', '7197.00', 0, 0.00, '2019-10-31', NULL, NULL, 0, 0, '2019-10-31 11:57:59', 4),
(617, 1911, 16, 55, 64, 'formato 0223', '1000.00', 0, 0.00, '2019-10-31', NULL, NULL, 0, 0, '2019-10-31 13:16:34', 2),
(618, 1914, 9, 94, 64, 'EXPLORA TEOTIHUACAN', '0.00', 0, 0.00, '2019-10-31', 3, '2019-10-31 14:24:33', 0, 0, '2019-10-31 13:57:31', 2),
(619, 1913, 14, 55, 64, '0112', '2000.00', 0, 0.00, '2019-10-07', 17, '2019-10-31 14:06:54', 0, 0, '2019-10-31 14:05:05', 2),
(620, 1915, 9, 90, 64, 'PAGO EN SITIO EN TERMINAL HOY', '2000.00', 0, 0.00, '2019-10-31', 17, '2019-10-31 14:13:24', 0, 0, '2019-10-31 14:11:24', 3),
(621, 1917, 9, 94, 64, '085905021140330296', '-725.00', 0, 0.00, '2019-10-31', 3, '2019-10-31 14:39:47', 0, 0, '2019-10-31 14:33:46', 2),
(622, 1922, 14, 57, 64, '311019', '19859.00', 0, 0.00, '2019-10-31', 17, '2019-10-31 15:57:41', 0, 0, '2019-10-31 15:52:33', 2),
(623, 1929, 14, 59, 64, 'ref 000025925', '2000.00', 0, 0.00, '2019-10-31', 17, '2019-10-31 16:48:42', 0, 0, '2019-10-31 16:42:56', 1),
(624, 1912, 16, 59, 64, 'folio 5642 aut 696597', '2000.00', 0, 0.00, '2019-10-31', 17, '2019-10-31 16:48:29', 0, 0, '2019-10-31 16:45:40', 2),
(625, 1923, 16, 61, 64, 'pedido 4294', '4598.00', 0, 0.00, '2019-10-31', 17, '2019-10-31 17:07:15', 0, 0, '2019-10-31 17:04:13', 2),
(626, 1927, 14, 89, 64, '076357', '2000.00', 0, 0.00, '2019-10-31', 17, '2019-10-31 19:11:24', 0, 0, '2019-10-31 18:39:27', 1),
(627, 1931, 14, 59, 64, '6040', '1000.00', 0, 0.00, '2019-10-31', 3, '2019-10-31 22:26:15', 0, 0, '2019-10-31 22:11:12', 2),
(628, 1937, 9, 94, 64, 'cxc expedia', '0.00', 0, 0.00, '2019-11-01', 17, '2019-11-01 12:24:51', 0, 0, '2019-11-01 12:23:30', 2),
(629, 1988, 16, 57, 64, '6732263', '10000.00', 0, 0.00, '2019-11-01', 17, '2019-11-01 12:42:58', 0, 0, '2019-11-01 12:34:21', 2),
(630, 1932, 14, 57, 64, '1592494623', '4798.00', 0, 0.00, '2019-11-01', 17, '2019-11-01 12:45:46', 0, 0, '2019-11-01 12:43:01', 2),
(631, 1941, 9, 94, 64, 'cxc gran teocalli', '0.00', 0, 0.00, '2019-11-01', 17, '2019-11-01 13:58:40', 0, 0, '2019-11-01 13:41:15', 2),
(632, 1942, 14, 59, 64, '7413', '2000.00', 0, 0.00, '2019-11-01', 17, '2019-11-01 14:04:29', 0, 0, '2019-11-01 14:01:07', 1),
(633, 1944, 14, 90, 64, '1944', '4000.00', 0, 0.00, '2019-11-01', 17, '2019-11-01 14:24:42', 0, 0, '2019-11-01 14:23:44', 2),
(634, 1943, 9, 94, 64, 'cxc gran teocalli', '0.00', 0, 0.00, '2019-11-01', 17, '2019-11-01 14:27:32', 0, 0, '2019-11-01 14:26:32', 2),
(635, 1945, 16, 90, 64, 'PAGO EN SITIO', '6900.00', 0, 0.00, '2019-11-01', 17, '2019-11-01 14:31:52', 0, 0, '2019-11-01 14:29:37', 3),
(636, 1946, 9, 94, 64, 'cxc gran teocalli', '0.00', 0, 0.00, '2019-11-01', 17, '2019-11-01 14:39:54', 0, 0, '2019-11-01 14:36:38', 2),
(637, 1948, 9, 94, 64, 'CXC BRISA TOURS', '0.00', 0, 0.00, '2019-11-01', 17, '2019-11-01 14:46:18', 0, 0, '2019-11-01 14:45:10', 2),
(638, 1950, 9, 94, 64, 'CXC WAYAK', '0.00', 0, 0.00, '2019-11-01', 17, '2019-11-01 14:56:35', 0, 0, '2019-11-01 14:55:52', 2),
(639, 1749, 14, 55, 64, '0224', '1000.00', 0, 0.00, '2019-11-01', 17, '2019-11-01 15:54:59', 0, 0, '2019-11-01 15:51:34', 1),
(640, 1958, 14, 89, 64, '036053', '2000.00', 0, 0.00, '2019-11-01', 17, '2019-11-01 17:56:00', 0, 0, '2019-11-01 17:53:07', 1),
(641, 1959, 16, 59, 64, 'folio 8967 aut 890934', '2000.00', 0, 0.00, '2019-11-01', 17, '2019-11-01 17:59:00', 0, 0, '2019-11-01 17:56:35', 2),
(642, 1960, 14, 59, 64, '00000030', '2000.00', 0, 0.00, '2019-11-01', 17, '2019-11-01 18:07:15', 0, 0, '2019-11-01 18:02:29', 2),
(643, 1963, 9, 94, 64, 'cxc nomadic', '0.00', 0, 0.00, '2019-11-01', 17, '2019-11-01 18:38:32', 0, 0, '2019-11-01 18:36:12', 2),
(644, 1962, 16, 55, 64, 'formato 0225', '1000.00', 0, 0.00, '2019-11-01', 17, '2019-11-01 19:18:40', 0, 0, '2019-11-01 19:13:50', 2),
(645, 1966, 16, 89, 64, 'Aprob 013946', '2000.00', 0, 0.00, '2019-11-01', 17, '2019-11-01 20:59:43', 0, 0, '2019-11-01 20:49:52', 2),
(646, 1971, 14, 55, 64, '0087', '2000.00', 0, 0.00, '2019-09-07', 17, '2019-11-01 21:44:16', 0, 0, '2019-11-01 21:41:33', 1),
(647, 1972, 14, 55, 64, '0143', '2000.00', 0, 0.00, '2019-10-07', 17, '2019-11-01 22:01:48', 0, 0, '2019-11-01 21:59:12', 1),
(648, 1973, 16, 57, 64, '330599', '2000.00', 0, 0.00, '2019-11-01', 17, '2019-11-01 22:55:22', 0, 0, '2019-11-01 22:00:17', 2),
(649, 1976, 14, 55, 64, '000', '2000.00', 0, 0.00, '2019-06-20', 17, '2019-11-01 22:31:02', 0, 0, '2019-11-01 22:28:54', 1),
(650, 1980, 9, 94, 64, 'Cxc booking', '0.00', 0, 0.00, '2019-11-01', 3, '2019-11-02 00:17:36', 0, 0, '2019-11-02 00:14:42', 2),
(651, 1981, 9, 94, 64, 'Cxc booking', '0.00', 0, 0.00, '2019-11-01', 3, '2019-11-02 00:17:55', 0, 0, '2019-11-02 00:15:16', 2),
(652, 1964, 14, 55, 64, '0226', '1000.00', 0, 0.00, '2019-11-01', 3, '2019-11-02 12:45:22', 0, 0, '2019-11-02 12:41:49', 1),
(653, 1983, 14, 59, 64, '3299', '2000.00', 0, 0.00, '2019-11-02', 3, '2019-11-02 13:56:10', 0, 0, '2019-11-02 13:50:16', 1),
(654, 1988, 16, 57, 64, '628020', '8000.00', 0, 0.00, '2019-11-02', 3, '2019-11-02 20:25:57', 0, 0, '2019-11-02 20:22:44', 2),
(655, 1988, 16, 57, 64, '8727299', '8000.00', 0, 0.00, '2019-11-02', 3, '2019-11-02 21:46:53', 0, 0, '2019-11-02 21:43:55', 2),
(656, 1988, 16, 57, 64, '4656134', '6500.00', 0, 0.00, '2019-11-02', 3, '2019-11-02 21:46:50', 0, 0, '2019-11-02 21:44:25', 2),
(657, 1989, 14, 55, 64, '0229', '1000.00', 0, 0.00, '2019-11-02', 3, '2019-11-02 22:18:17', 0, 0, '2019-11-02 22:14:41', 1),
(658, 1994, 16, 55, 64, 'Formato 230', '1000.00', 0, 0.00, '2019-11-02', 3, '2019-11-02 22:20:13', 0, 0, '2019-11-02 22:18:27', 2),
(659, 1996, 16, 55, 64, 'Formato 0232', '1000.00', 0, 0.00, '2019-11-02', 17, '2019-11-02 23:06:37', 0, 0, '2019-11-02 23:05:13', 2),
(660, 1626, 14, 57, 64, '000000001', '6040.00', 0, 0.00, '2019-11-02', 17, '2019-11-03 00:13:32', 0, 0, '2019-11-03 00:06:38', 2),
(661, 2033, 14, 55, 64, '0228', '1000.00', 0, 0.00, '2019-11-02', 3, '2019-11-03 10:16:00', 0, 0, '2019-11-03 10:15:25', 1),
(662, 2000, 14, 55, 64, '0236', '1000.00', 0, 0.00, '2019-11-03', 17, '2019-11-03 11:06:54', 0, 0, '2019-11-03 10:59:24', 1),
(663, 2001, 14, 61, 64, 'Ped 4298', '5798.00', 0, 0.00, '2019-11-03', 17, '2019-11-03 11:52:16', 0, 0, '2019-11-03 11:45:57', 1),
(664, 2002, 9, 94, 64, 'Cxc booking', '0.00', 0, 0.00, '2019-11-03', 17, '2019-11-03 12:27:11', 0, 0, '2019-11-03 12:23:47', 2),
(665, 1961, 16, 57, 64, 'Folio 248', '1000.00', 0, 0.00, '2019-11-02', 17, '2019-11-03 13:19:04', 0, 0, '2019-11-03 13:13:57', 2),
(666, 1978, 16, 55, 64, 'Formato 0227', '2000.00', 0, 0.00, '2019-11-03', 17, '2019-11-03 13:38:59', 0, 0, '2019-11-03 13:34:23', 2),
(667, 1982, 14, 89, 64, '496650', '2000.00', 0, 0.00, '2019-11-03', 17, '2019-11-03 15:06:50', 0, 0, '2019-11-03 14:58:52', 1),
(668, 2005, 9, 57, 88, '0001549', '4000.00', 0, 0.00, '2019-11-03', 17, '2019-11-03 15:08:23', 0, 0, '2019-11-03 15:04:19', 2),
(669, 2006, 9, 57, 88, '085905021140330296', '9400.00', 0, 0.00, '2019-10-29', 17, '2019-11-03 15:40:02', 0, 0, '2019-11-03 15:37:57', 2),
(670, 2008, 9, 94, 64, 'Cxc wayak', '0.00', 0, 0.00, '2019-11-03', 17, '2019-11-03 17:09:12', 0, 0, '2019-11-03 16:59:03', 2),
(671, 1984, 16, 55, 64, 'Formato 0238', '1000.00', 0, 0.00, '2019-11-03', 17, '2019-11-03 17:21:55', 0, 0, '2019-11-03 17:19:38', 2),
(672, 1999, 16, 59, 64, 'Folio 3089 aut 762831', '1000.00', 0, 0.00, '2019-11-03', 17, '2019-11-03 17:56:00', 0, 0, '2019-11-03 17:51:37', 2),
(673, 2010, 16, 55, 64, 'Formato 0238', '1000.00', 0, 0.00, '2019-11-03', 17, '2019-11-03 18:48:32', 0, 0, '2019-11-03 18:45:58', 2),
(674, 2013, 16, 55, 64, '0231', '1000.00', 0, 0.00, '2019-11-02', NULL, NULL, 0, 0, '2019-11-03 18:54:24', 2),
(675, 2013, 16, 55, 64, 'Formato 0231', '1000.00', 0, 0.00, '2019-11-03', 17, '2019-11-03 19:05:15', 0, 0, '2019-11-03 18:55:59', 3),
(676, 2014, 16, 55, 64, 'Formato 0240', '1000.00', 0, 0.00, '2019-11-03', 17, '2019-11-03 19:55:28', 0, 0, '2019-11-03 19:48:39', 2),
(677, 2018, 9, 94, 64, 'cxc expedia', '0.00', 0, 0.00, '2019-11-04', 17, '2019-11-04 10:34:31', 0, 0, '2019-11-04 10:32:53', 2),
(678, 2019, 16, 61, 64, 'PEDIDO 4304', '7500.00', 0, 0.00, '2019-11-04', 17, '2019-11-04 10:44:28', 0, 0, '2019-11-04 10:39:28', 2),
(679, 2020, 16, 59, 64, 'folio 9845 aut 275912', '2000.00', 0, 0.00, '2019-11-04', 17, '2019-11-04 11:42:34', 0, 0, '2019-11-04 11:39:07', 2),
(680, 2021, 16, 61, 64, 'PEDIDO 4307', '6597.00', 0, 0.00, '2019-11-04', 17, '2019-11-04 11:57:07', 0, 0, '2019-11-04 11:51:45', 2),
(681, 2021, 16, 61, 64, 'PEDIDO 4307', '300.00', 0, 0.00, '2019-11-04', 17, '2019-11-04 11:58:50', 0, 0, '2019-11-04 11:58:34', 2),
(682, 2031, 14, 55, 64, '0241', '1000.00', 0, 0.00, '2019-11-04', 17, '2019-11-04 14:38:37', 0, 0, '2019-11-04 14:29:17', 1),
(683, 1975, 14, 57, 64, '041119', '2000.00', 0, 0.00, '2019-11-04', 17, '2019-11-04 14:40:41', 0, 0, '2019-11-04 14:33:19', 1),
(684, 2038, 14, 55, 64, '0246', '1000.00', 0, 0.00, '2019-11-04', 17, '2019-11-04 15:00:38', 0, 0, '2019-11-04 14:45:02', 1),
(685, 1963, 9, 94, 64, 'clave de rastreo 085903206810330899', '4060.00', 0, 0.00, '2019-11-04', 17, '2019-11-04 17:15:48', 0, 0, '2019-11-04 17:11:24', 3),
(686, 1995, 14, 55, 64, '0245', '1000.00', 0, 0.00, '2019-11-04', 17, '2019-11-04 18:12:44', 0, 0, '2019-11-04 18:09:52', 1),
(687, 2058, 14, 61, 64, '4314', '2799.00', 0, 0.00, '2019-11-04', 3, '2019-11-04 19:24:22', 0, 0, '2019-11-04 19:16:48', 2),
(688, 2057, 14, 61, 64, '4311', '2799.00', 0, 0.00, '2019-11-04', 3, '2019-11-04 19:24:02', 0, 0, '2019-11-04 19:17:47', 2),
(689, 2056, 16, 57, 64, 'Spei folio 0124', '2000.00', 0, 0.00, '2019-11-04', 3, '2019-11-04 19:48:28', 0, 0, '2019-11-04 19:45:04', 2),
(690, 2059, 11, 55, 75, '070819 Katherine', '2000.00', 0, 0.00, '2019-08-07', 3, '2019-11-04 21:33:07', 0, 0, '2019-11-04 21:27:15', 1),
(691, 2060, 16, 55, 64, 'Formato 0250', '1000.00', 0, 0.00, '2019-11-04', 3, '2019-11-04 21:58:36', 0, 0, '2019-11-04 21:52:57', 2),
(692, 2061, 9, 55, 75, '6NM12303T2379724C', '4900.00', 0, 0.00, '2019-11-04', NULL, NULL, 0, 0, '2019-11-04 21:53:49', 4),
(693, 2062, 9, 61, 64, 'Conekta ped 4324 pago tc', '4798.00', 0, 0.00, '2019-11-04', 3, '2019-11-04 23:19:18', 0, 0, '2019-11-04 23:12:47', 2),
(694, 1968, 16, 59, 64, 'folio 6381 aut 871469', '2000.00', 0, 0.00, '2019-11-04', 17, '2019-11-05 10:18:11', 0, 0, '2019-11-05 10:14:03', 2),
(695, 2065, 9, 94, 64, 'cxc expedia', '0.00', 0, 0.00, '2019-11-05', 17, '2019-11-05 10:44:57', 0, 0, '2019-11-05 10:35:59', 2),
(696, 1628, 14, 55, 64, '0248', '1000.00', 0, 0.00, '2019-11-04', 17, '2019-11-05 10:40:39', 0, 0, '2019-11-05 10:36:01', 2),
(697, 2071, 14, 61, 64, '4317', '5798.00', 0, 0.00, '2019-11-04', 17, '2019-11-05 10:53:57', 0, 0, '2019-11-05 10:50:33', 2),
(698, 2072, 14, 55, 64, '0247', '1000.00', 0, 0.00, '2019-11-04', NULL, NULL, 0, 0, '2019-11-05 11:04:20', 1),
(699, 2073, 9, 94, 64, 'cxc turisky', '0.00', 0, 0.00, '2019-11-05', 3, '2019-11-05 11:24:06', 0, 0, '2019-11-05 11:22:32', 2),
(700, 2044, 16, 59, 64, '26011', '2000.00', 0, 0.00, '2019-11-05', 17, '2019-11-05 12:39:05', 0, 0, '2019-11-05 12:36:01', 2),
(701, 1417, 14, 59, 64, '4138', '2999.00', 0, 0.00, '2019-11-05', 17, '2019-11-05 13:30:22', 0, 0, '2019-11-05 13:26:20', 2),
(702, 2120, 9, 59, 64, 'movimiento 000026014', '2000.00', 0, 0.00, '2019-11-05', 17, '2019-11-05 13:40:32', 0, 0, '2019-11-05 13:34:51', 3),
(703, 2070, 16, 59, 64, 'FOLIO 5383 AUT 541835', '2000.00', 0, 0.00, '2019-11-05', 17, '2019-11-05 14:26:09', 0, 0, '2019-11-05 14:23:26', 2),
(704, 1985, 16, 61, 64, 'PEDIDO 4301', '4598.00', 0, 0.00, '2019-11-03', 17, '2019-11-05 14:51:15', 0, 0, '2019-11-05 14:48:25', 2),
(705, 2076, 16, 59, 64, 'FOLIO 8396 AUT 849701', '3000.00', 0, 0.00, '2019-11-05', 17, '2019-11-05 14:59:13', 0, 0, '2019-11-05 14:56:33', 2),
(706, 2093, 16, 60, 64, 'PAGA EN SITIO', '5700.00', 0, 0.00, '2019-11-04', 17, '2019-11-05 15:27:43', 0, 0, '2019-11-05 15:21:38', 3),
(707, 2088, 16, 59, 64, 'folio 8464 aut 931000', '2000.00', 0, 0.00, '2019-11-05', 17, '2019-11-05 16:56:15', 0, 0, '2019-11-05 16:52:44', 1),
(708, 2097, 9, 94, 64, 'cxc turisky', '0.00', 0, 0.00, '2019-11-05', 17, '2019-11-05 17:52:34', 0, 0, '2019-11-05 17:51:42', 2),
(709, 2098, 9, 94, 64, 'cxc teocalli', '0.00', 0, 0.00, '2019-11-05', 17, '2019-11-05 17:57:08', 0, 0, '2019-11-05 17:55:39', 2),
(710, 2035, 16, 61, 64, 'pedido 4329', '2299.00', 0, 0.00, '2019-11-05', 17, '2019-11-05 18:08:40', 0, 0, '2019-11-05 18:06:11', 2),
(711, 2035, 16, 61, 64, 'pedido 4332', '4598.00', 0, 0.00, '2019-11-05', 17, '2019-11-05 18:24:52', 0, 0, '2019-11-05 18:21:51', 2),
(712, 2099, 9, 94, 64, 'CXC TURISKY', '0.00', 0, 0.00, '2019-11-05', 17, '2019-11-05 18:58:16', 0, 0, '2019-11-05 18:56:47', 3),
(713, 2102, 16, 55, 64, 'formato 0257', '2000.00', 0, 0.00, '2019-11-05', 3, '2019-11-05 19:12:59', 0, 0, '2019-11-05 19:08:32', 2),
(714, 2102, 16, 89, 64, 'Aut 863646', '2000.00', 0, 0.00, '2019-11-05', 3, '2019-11-05 20:15:36', 0, 0, '2019-11-05 20:12:01', 2),
(715, 2029, 16, 55, 64, 'Formato 0259', '1000.00', 0, 0.00, '2019-11-05', 17, '2019-11-05 22:25:30', 0, 0, '2019-11-05 22:23:56', 2),
(716, 2103, 9, 61, 64, 'Conekta ped 4341', '4598.00', 0, 0.00, '2019-11-05', 17, '2019-11-05 23:10:54', 0, 0, '2019-11-05 23:02:43', 2),
(717, 2105, 9, 94, 64, 'Cxc booking', '0.00', 0, 0.00, '2019-11-05', 17, '2019-11-05 23:11:04', 0, 0, '2019-11-05 23:07:41', 2),
(723, 1735, 11, 60, 83, 'Pago en Sitio', '4558.10', 0, 0.00, '2019-11-06', NULL, NULL, 0, 0, '2019-11-06 10:03:48', 2),
(724, 1886, 11, 60, 83, 'Pago en Sitio', '-300.00', 0, 0.00, '2019-11-06', NULL, NULL, 0, 0, '2019-11-06 10:11:49', 2),
(725, 1886, 11, 94, 83, 'Pago en Sitio', '0.00', 0, 0.00, '2019-11-06', NULL, NULL, 0, 0, '2019-11-06 10:12:56', 2),
(726, 2002, 11, 94, 83, 'Pago en Sitio', '2350.00', 0, 0.00, '2019-11-06', NULL, NULL, 0, 0, '2019-11-06 10:15:18', 0),
(727, 2022, 14, 55, 64, '0244', '1000.00', 0, 0.00, '2019-11-05', 17, '2019-11-06 11:05:57', 0, 0, '2019-11-06 11:02:41', 1),
(728, 2049, 14, 55, 64, '2049', '1000.00', 0, 0.00, '2019-11-05', 17, '2019-11-06 11:12:29', 0, 0, '2019-11-06 11:09:17', 1),
(729, 1695, 14, 89, 93, '564266', '2000.00', 0, 0.00, '2019-11-06', 17, '2019-11-06 11:19:35', 0, 0, '2019-11-06 11:17:46', 1),
(730, 2075, 14, 55, 64, '0251', '1000.00', 0, 0.00, '2019-11-06', 17, '2019-11-06 11:28:40', 0, 0, '2019-11-06 11:25:21', 1),
(731, 2108, 14, 59, 64, '6230', '3600.00', 0, 0.00, '2019-11-06', 17, '2019-11-06 11:36:57', 0, 0, '2019-11-06 11:32:27', 1),
(732, 2109, 9, 94, 64, 'CXC BOOKING', '0.00', 0, 0.00, '2019-11-06', 17, '2019-11-06 11:43:42', 0, 0, '2019-11-06 11:41:05', 2),
(733, 2110, 14, 61, 64, 'PED 4344', '6698.00', 0, 0.00, '2019-11-05', 17, '2019-11-06 11:53:03', 0, 0, '2019-11-06 11:50:14', 2),
(734, 2092, 16, 55, 64, 'PAYPAL FORMATO 0254', '1000.00', 0, 0.00, '2019-11-05', 17, '2019-11-06 15:01:59', 0, 0, '2019-11-06 11:59:32', 2),
(735, 2034, 16, 55, 64, 'PAYPAL FORMATO 0262', '1000.00', 0, 0.00, '2019-11-06', 17, '2019-11-06 12:54:46', 0, 0, '2019-11-06 12:52:25', 2),
(736, 2122, 14, 55, 64, '0260', '1000.00', 0, 0.00, '2019-11-06', 17, '2019-11-06 13:46:16', 0, 0, '2019-11-06 13:43:19', 1),
(737, 1636, 9, 94, 64, 'trip advisor pago 04-11-19', '1950.00', 0, 0.00, '2019-11-04', 17, '2019-11-06 13:46:47', 0, 0, '2019-11-06 13:44:21', 3),
(738, 2119, 16, 55, 64, 'PAYPAL FORMATO 0263', '2000.00', 0, 0.00, '2019-11-06', 17, '2019-11-06 14:08:03', 0, 0, '2019-11-06 14:06:29', 2),
(739, 2117, 14, 57, 64, '2034304184', '2000.00', 0, 0.00, '2019-11-06', 17, '2019-11-06 14:16:26', 0, 0, '2019-11-06 14:12:59', 1),
(740, 2114, 16, 59, 64, 'FOLIO 5774 AUT 127890', '2000.00', 0, 0.00, '2019-11-06', 17, '2019-11-06 15:06:47', 0, 0, '2019-11-06 15:04:45', 2),
(741, 1987, 16, 59, 64, 'mov 26034', '2000.00', 0, 0.00, '2019-11-06', 17, '2019-11-06 16:51:45', 0, 0, '2019-11-06 16:47:18', 2),
(742, 2126, 14, 55, 64, '0264', '1000.00', 0, 0.00, '2019-11-06', 17, '2019-11-06 17:00:03', 0, 0, '2019-11-06 16:57:17', 1),
(757, 2106, 1, 60, 83, 'Pago en Sitio', '21.00', 0, 0.00, '2019-11-06', NULL, NULL, 0, 0, '2019-11-06 17:37:36', 2),
(758, 1635, 1, 60, 75, '2121', '12.00', 0, 0.00, '2019-11-06', NULL, NULL, 0, 0, '2019-11-07 09:26:33', 4),
(759, 1635, 1, 57, 76, '21', '3.00', 0, 0.00, '2019-11-04', NULL, NULL, 0, 0, '2019-11-07 09:28:02', 4),
(760, 2127, 1, 55, 83, 'Pago en Sitio', '21.00', 0, 0.00, '2019-11-11', NULL, NULL, 0, 0, '2019-11-11 14:40:28', 2),
(761, 1899, 1, 56, 64, 'aaa', '10.00', 0, 0.00, '2019-11-15', NULL, NULL, 0, 0, '2019-11-15 10:39:53', 0),
(762, 1899, 1, 55, 75, 'dol 19.21', '192.10', 100, 19.21, '2019-11-15', NULL, NULL, 0, 0, '2019-11-15 10:59:55', 4),
(763, 1899, 1, 56, 64, 'ww', '0.00', 100, 19.21, '2019-11-15', NULL, NULL, 0, 0, '2019-11-15 11:05:38', 4),
(764, 2127, 1, 55, 83, 'Pago en Sitio', '19.21', 100, 19.21, '2019-11-20', NULL, NULL, 0, 0, '2019-11-20 09:09:54', 2),
(765, 2127, 1, 55, 83, 'Pago en Sitio', '6859.70', 100, 19.21, '2019-11-20', NULL, NULL, 0, 0, '2019-11-20 09:14:56', 2),
(766, 2127, 1, 55, 83, 'Pago en Sitio', '-6900.00', 99, 1.00, '2019-11-20', NULL, NULL, 0, 0, '2019-11-20 09:15:47', 2),
(767, 2127, 1, 60, 83, 'Pago en Sitio', '6555.09', 100, 19.21, '2019-11-20', NULL, NULL, 0, 1, '2019-11-20 10:13:03', 2),
(768, 2127, 1, 55, 83, 'Pago en Sitio', '-125921.55', 100, 19.21, '2019-11-20', NULL, NULL, 0, 0, '2019-11-20 10:13:32', 2),
(769, 2127, 1, 55, 83, 'Pago en Sitio', '125921.55', 100, 19.21, '2019-11-20', NULL, NULL, 0, 0, '2019-11-20 10:14:35', 2),
(770, 2127, 1, 55, 83, 'Pago en Sitio', '-6555.00', 99, 1.00, '2019-11-20', NULL, NULL, 0, 0, '2019-11-20 10:14:47', 2),
(771, 2127, 1, 55, 83, 'Pago en Sitio', '57.63', 100, 19.21, '2019-11-20', NULL, NULL, 0, 0, '2019-11-20 10:15:03', 2),
(772, 2127, 1, 55, 83, 'Pago en Sitio', '6497.37', 101, 21.22, '2019-11-20', NULL, NULL, 0, 0, '2019-11-20 10:15:11', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cargosextras_volar`
--

CREATE TABLE `cargosextras_volar` (
  `id_ce` bigint(20) NOT NULL COMMENT 'Llave Primaria',
  `reserva_ce` bigint(20) NOT NULL COMMENT 'Reserva',
  `usuario_ce` int(11) NOT NULL COMMENT 'Usuario que Registra',
  `motivo_ce` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Motivo',
  `cantidad_ce` double(10,2) DEFAULT NULL COMMENT 'Cantidad',
  `comentario_ce` text COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Comentario',
  `tipo_ce` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Tipo de cargo (1 Car, 2 Desc)',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Register',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Estatus'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `cargosextras_volar`
--

INSERT INTO `cargosextras_volar` (`id_ce`, `reserva_ce`, `usuario_ce`, `motivo_ce`, `cantidad_ce`, `comentario_ce`, `tipo_ce`, `register`, `status`) VALUES
(1, 2106, 1, 'Peso Extra', 500.00, 'Se cobra peso extra', 1, '2019-11-05 23:38:44', 1),
(2, 2106, 1, 'Pasajero Menos', 2000.00, 'No asistio un pasajero', 2, '2019-11-05 23:41:10', 1),
(3, 1735, 11, 'CUPON', 239.90, ' CANCELARDESCUENTO', 2, '2019-11-06 10:08:12', 1),
(4, 1735, 11, 'CUPON5', 479.80, 'ETC', 2, '2019-11-06 10:08:52', 1),
(5, 1735, 1, 'Quitar Descuento', 479.80, 'Cancelar descuento extra', 1, '2019-11-06 10:13:07', 1),
(6, 2106, 1, 'as', 2.00, 'ddd', 1, '2019-11-06 16:30:49', 1),
(7, 2106, 1, 'sas', 2.00, '22', 1, '2019-11-06 16:36:03', 1),
(8, 2106, 1, 'sa', 20.00, 'd', 1, '2019-11-06 16:36:32', 1),
(9, 2106, 1, 'aa', 2.00, 'aa', 1, '2019-11-06 16:36:59', 1),
(10, 2106, 1, 'd', 2.00, 's', 1, '2019-11-06 16:37:12', 1),
(11, 2106, 1, 'f', 28.00, '111', 2, '2019-11-06 16:37:39', 1),
(12, 2106, 1, 'Aplica CupÃ³n de 5%', 125.00, 'Se aplicÃ³ cupÃ³n por pago en efectivo', 2, '2019-11-06 17:28:13', 1),
(13, 2106, 1, 'Aplica CupÃ³n de 5%', 125.00, 'Se aplicÃ³ cupÃ³n por pago en efectivo', 2, '2019-11-06 17:29:08', 1),
(14, 2106, 1, 'Aplica Cupón de 5%', 125.00, 'Se aplicó cupón por pago en efectivo', 2, '2019-11-06 17:29:56', 1),
(15, 2106, 1, 'Aplica CupÃ³n de 5%', 125.00, 'Se aplicÃ³ cupÃ³n por pago en efectivo', 2, '2019-11-06 17:32:16', 1),
(16, 2127, 1, 'Aplica CupÃ³n de 5%', 345.00, 'Se aplicÃ³ cupÃ³n por pago en efectivo', 2, '2019-11-20 10:13:03', 1);

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
(11, 'CDMX', 'Ciudad de MÃ©xico', 'estados', '2019-03-31 17:30:33', 1),
(12, 'Dgo', 'Durango	', 'estados', '2019-03-31 17:30:55', 1),
(13, 'Gto.', 'Guanajuato	', 'estados', '2019-03-31 17:31:24', 1),
(14, 'Gro.', 'Guerrero	', 'estados', '2019-03-31 17:32:26', 1),
(15, 'Hgo.', 'Hidalgo	', 'estados', '2019-03-31 17:33:09', 1),
(16, 'Jal.', 'Jalisco	', 'estados', '2019-03-31 17:33:33', 1),
(17, 'EdoMe', 'MÃ©xico	', 'estados', '2019-03-31 17:34:04', 1),
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
(97, '5204 1672 4767 6299', 'OXXO BNMX SRG 6299', 'cuentasvolar', '2019-09-18 17:15:00', 1),
(98, NULL, 'TC', 'metodopago', '2019-10-14 19:19:06', 1),
(99, '1', 'Pesos', 'monedas', '2019-11-11 09:18:34', 1),
(100, '19.21', 'Dolares', 'monedas', '2019-11-15 09:16:05', 1),
(101, '21.22', 'Euros', 'monedas', '2019-11-15 09:20:43', 1);

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
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
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
(24, 'Doble', 7, '1450.00', 2, 'HabitaciÃ³n Doble', '2019-09-02 23:17:56', 1),
(25, 'Doble', 1, '1300.00', 2, '1 cama king size', '2019-10-09 14:20:11', 1);

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
(216, 3, 7, '2019-08-01 22:55:13', 0),
(217, 3, 26, '2019-08-01 22:55:23', 1),
(218, 3, 11, '2019-08-01 22:56:04', 1),
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
(233, 1, 66, '2019-08-07 00:18:42', 0),
(234, 1, 65, '2019-08-07 00:18:42', 0),
(235, 1, 64, '2019-08-07 00:18:43', 1),
(236, 1, 68, '2019-08-07 00:18:44', 0),
(237, 1, 69, '2019-08-07 00:18:45', 0),
(238, 1, 70, '2019-08-07 00:18:46', 0),
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
(444, 1, 84, '2019-10-08 00:36:05', 1),
(445, 1, 86, '2019-10-08 00:36:10', 1),
(446, 1, 85, '2019-10-08 00:36:29', 1),
(447, 1, 87, '2019-10-08 00:36:30', 1),
(448, 11, 86, '2019-10-08 16:41:35', 1),
(449, 11, 87, '2019-10-08 16:41:40', 1),
(450, 9, 86, '2019-10-08 17:06:50', 1),
(451, 9, 87, '2019-10-08 17:06:51', 1),
(452, 18, 86, '2019-10-08 17:07:40', 1),
(453, 18, 87, '2019-10-08 17:07:42', 1),
(454, 18, 84, '2019-10-08 17:07:47', 1),
(455, 18, 85, '2019-10-08 17:07:48', 1),
(456, 9, 84, '2019-10-08 17:08:03', 1),
(457, 9, 85, '2019-10-08 17:08:04', 1),
(458, 14, 84, '2019-10-08 17:08:21', 1),
(459, 8, 84, '2019-10-08 17:09:10', 1),
(460, 8, 85, '2019-10-08 17:09:12', 1),
(461, 11, 84, '2019-10-08 17:09:26', 1),
(462, 11, 85, '2019-10-08 17:09:27', 1),
(463, 19, 7, '2019-10-08 17:09:41', 1),
(464, 19, 8, '2019-10-08 17:09:42', 1),
(465, 19, 9, '2019-10-08 17:09:43', 1),
(466, 19, 12, '2019-10-08 17:09:46', 1),
(467, 19, 13, '2019-10-08 17:09:47', 1),
(468, 19, 84, '2019-10-08 17:09:52', 1),
(469, 19, 85, '2019-10-08 17:09:53', 1),
(470, 19, 86, '2019-10-08 17:09:56', 1),
(471, 19, 87, '2019-10-08 17:09:58', 1),
(472, 19, 24, '2019-10-08 17:10:02', 1),
(473, 19, 26, '2019-10-08 17:10:04', 1),
(474, 3, 84, '2019-10-08 17:10:24', 1),
(475, 3, 85, '2019-10-08 17:10:26', 1),
(476, 15, 56, '2019-10-11 13:28:05', 1),
(477, 15, 57, '2019-10-11 13:28:09', 1),
(478, 15, 58, '2019-10-11 13:28:11', 1),
(479, 15, 7, '2019-10-11 13:28:37', 1),
(480, 15, 8, '2019-10-11 13:28:38', 1),
(481, 15, 9, '2019-10-11 13:28:39', 1),
(482, 15, 11, '2019-10-11 13:29:26', 1),
(483, 15, 12, '2019-10-11 13:29:27', 1),
(484, 15, 13, '2019-10-11 13:29:29', 1),
(485, 15, 23, '2019-10-11 13:29:31', 0),
(486, 15, 24, '2019-10-11 13:29:33', 1),
(487, 15, 26, '2019-10-11 13:29:35', 1),
(488, 15, 36, '2019-10-11 13:29:41', 1),
(489, 15, 84, '2019-10-11 13:29:42', 1),
(490, 15, 25, '2019-10-11 13:30:11', 1),
(491, 15, 47, '2019-10-11 13:30:20', 1),
(492, 15, 85, '2019-10-11 13:30:30', 1),
(493, 15, 86, '2019-10-11 13:30:36', 1),
(494, 15, 87, '2019-10-11 13:30:45', 1),
(495, 14, 86, '2019-10-11 13:31:10', 1),
(496, 8, 86, '2019-10-11 13:32:24', 1),
(497, 11, 47, '2019-10-11 13:32:41', 1),
(498, 16, 86, '2019-10-11 13:33:25', 1),
(499, 16, 84, '2019-10-11 13:33:27', 1),
(500, 15, 60, '2019-10-11 13:34:54', 1),
(501, 15, 74, '2019-10-11 13:35:04', 1),
(502, 15, 75, '2019-10-11 13:35:05', 1),
(503, 15, 76, '2019-10-11 13:35:08', 1),
(504, 20, 8, '2019-10-11 14:53:17', 1),
(505, 20, 24, '2019-10-11 14:54:38', 1),
(506, 20, 13, '2019-10-11 14:56:49', 1),
(507, 20, 25, '2019-10-11 14:56:52', 1),
(508, 20, 26, '2019-10-11 14:57:00', 1),
(509, 20, 84, '2019-10-11 14:57:06', 1),
(510, 20, 11, '2019-10-11 15:03:21', 1),
(511, 20, 36, '2019-10-11 15:09:43', 1),
(512, 15, 1, '2019-10-14 18:20:42', 1),
(513, 15, 6, '2019-10-14 18:20:48', 1),
(514, 15, 5, '2019-10-14 18:21:12', 1),
(515, 17, 11, '2019-10-17 18:02:02', 1),
(516, 8, 74, '2019-10-22 17:45:13', 1),
(517, 8, 75, '2019-10-22 17:45:17', 1),
(518, 1, 88, '2019-11-05 13:42:04', 1),
(519, 1, 89, '2019-11-05 13:42:05', 1),
(520, 22, 7, '2019-11-06 09:46:54', 1),
(521, 22, 8, '2019-11-06 09:46:56', 1),
(522, 22, 9, '2019-11-06 09:47:01', 1),
(523, 22, 10, '2019-11-06 09:47:03', 1),
(524, 22, 11, '2019-11-06 09:47:06', 1),
(525, 22, 12, '2019-11-06 09:47:09', 1),
(526, 22, 13, '2019-11-06 09:47:11', 1),
(527, 22, 24, '2019-11-06 09:47:13', 1),
(528, 22, 26, '2019-11-06 09:47:15', 1),
(529, 22, 36, '2019-11-06 09:47:18', 1),
(530, 22, 52, '2019-11-06 09:47:20', 1),
(531, 22, 73, '2019-11-06 09:47:23', 1),
(532, 22, 84, '2019-11-06 09:47:24', 1),
(533, 22, 85, '2019-11-06 09:47:25', 1),
(534, 22, 86, '2019-11-06 09:47:28', 1),
(535, 22, 87, '2019-11-06 09:47:35', 1),
(536, 22, 88, '2019-11-06 09:47:40', 1),
(537, 22, 89, '2019-11-06 09:47:42', 1),
(538, 18, 88, '2019-11-06 09:48:00', 1),
(539, 18, 89, '2019-11-06 09:48:01', 1),
(540, 22, 59, '2019-11-06 09:53:16', 1),
(541, 22, 60, '2019-11-06 09:53:17', 1),
(542, 22, 61, '2019-11-06 09:53:21', 1),
(543, 11, 88, '2019-11-06 10:05:27', 1),
(544, 11, 89, '2019-11-06 10:05:28', 1),
(545, 1, 90, '2019-11-15 09:11:49', 1);

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
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Regsitro',
  `status` int(11) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `reprogramaciones_volar`
--

INSERT INTO `reprogramaciones_volar` (`id_rep`, `idtemp_rep`, `idusu_rep`, `fechaa_rep`, `fechan_rep`, `comentario_rep`, `motivo_rep`, `cargo_rep`, `register`, `status`) VALUES
(8, 1159, 11, '2019-09-26', '2019-10-13', 'Reprogramacion por cancelaciÃ³n de vuelo por clima', 1, 0, '2019-10-08 16:46:02', 2),
(9, 1207, 11, '2019-09-29', '2019-10-13', 'ReprogramaciÃ³n por cancelaciÃ³n de vuelo por mal clima', 1, 0, '2019-10-08 16:53:02', 1),
(10, 1159, 1, '2019-10-13', '2019-09-26', '', 1, 0, '2019-10-08 17:02:42', 1),
(11, 1254, 16, '2019-10-20', '2019-10-20', '', 1, 0, '2019-10-15 13:12:55', 2),
(12, 1254, 16, '2019-10-20', '2019-10-20', '', 2, 0, '2019-10-15 13:14:03', 1),
(13, 1366, 16, '2019-10-19', '2019-10-19', '', 2, 0, '2019-10-15 17:08:44', 1),
(14, 1363, 16, '2019-10-17', '2019-10-18', 'cliente solicita cambio de fecha por clima', 1, 0, '2019-10-16 16:51:12', 1),
(15, 1387, 16, '2019-10-17', '2019-10-18', 'reprogramo por lluvia', 1, 0, '2019-10-17 10:26:11', 1),
(16, 1388, 16, '2019-10-18', '2019-10-18', '', 1, 0, '2019-10-17 13:50:24', 1),
(17, 1396, 16, '2019-10-17', '2019-10-18', '', 1, 0, '2019-10-17 18:06:19', 1),
(18, 1461, 16, '2019-10-19', '2019-10-20', '', 1, 0, '2019-10-18 19:19:29', 1),
(19, 1339, 14, '2019-10-19', '2019-10-26', '', 1, 0, '2019-10-19 12:33:56', 1),
(20, 1457, 9, '2019-10-21', '2019-10-23', '', 1, 0, '2019-10-20 12:43:42', 1),
(21, 1502, 11, '2020-03-20', '2020-03-21', '', 1, 0, '2019-10-21 13:28:40', 2),
(22, 1548, 16, '2019-10-27', '2019-10-27', '', 1, 0, '2019-10-22 11:57:24', 1),
(23, 1515, 16, '2019-10-22', '2019-10-23', '', 1, 0, '2019-10-22 17:35:27', 2),
(24, 1515, 16, '2019-10-23', '2019-10-23', '', 1, 0, '2019-10-22 17:38:47', 1),
(25, 1482, 16, '2019-10-31', '2019-11-03', '', 1, 0, '2019-10-22 22:40:23', 1),
(26, 1517, 16, '2019-10-27', '2019-10-26', '', 1, 0, '2019-10-22 22:46:46', 1),
(27, 1559, 9, '2019-10-26', '2019-10-07', '', 1, 0, '2019-10-23 12:26:34', 1),
(28, 1593, 16, '2019-11-09', '2019-11-16', '', 1, 0, '2019-10-23 13:17:36', 1),
(29, 1481, 9, '2019-10-24', '2019-10-14', '', 1, 0, '2019-10-23 13:22:10', 1),
(30, 1608, 16, '2019-11-30', '2019-12-01', '', 1, 0, '2019-10-24 10:58:18', 1),
(31, 1418, 14, '2019-11-02', '2019-11-16', '', 1, 0, '2019-10-25 10:44:42', 1),
(32, 1690, 16, '2019-11-01', '2019-11-02', '', 1, 0, '2019-10-25 11:40:24', 1),
(33, 1625, 9, '2019-10-25', '2019-11-01', '', 1, 0, '2019-10-25 15:44:14', 1),
(34, 1605, 9, '2019-10-26', '2019-10-26', 'CANCELADA POR CLIENTE BOOKING', 1, 0, '2019-10-25 19:17:25', 2),
(35, 1605, 9, '2019-10-26', '2019-10-25', 'CANCELADA BOOKING', 1, 0, '2019-10-25 19:18:21', 1),
(36, 1709, 16, '2019-10-28', '2019-10-29', '', 1, 0, '2019-10-28 12:43:00', 1),
(37, 1602, 9, '2019-10-30', '2019-10-30', '', 1, 0, '2019-10-28 16:38:33', 2),
(38, 1602, 9, '2019-10-30', '2019-10-05', '', 1, 0, '2019-10-28 16:39:20', 1),
(39, 1735, 14, '2019-11-06', '2019-11-03', '', 1, 0, '2019-10-28 18:01:15', 2),
(40, 1735, 14, '2019-11-03', '2019-11-06', '', 1, 0, '2019-10-28 18:03:40', 1),
(41, 1810, 16, '2019-11-03', '2019-11-18', '', 1, 0, '2019-10-29 11:24:32', 1),
(42, 1813, 14, '2019-11-02', '2019-11-01', '', 1, 0, '2019-10-29 13:30:58', 1),
(43, 1849, 16, '2019-10-30', '2019-10-31', '', 1, 0, '2019-10-29 17:40:22', 1),
(44, 1857, 14, '2019-11-01', '2019-11-02', '', 1, 0, '2019-10-29 17:54:35', 1),
(45, 1814, 9, '2019-10-30', '2019-10-14', '', 1, 0, '2019-10-29 17:57:13', 1),
(46, 1627, 9, '2019-10-30', '2019-10-28', '', 1, 0, '2019-10-29 19:00:14', 1),
(47, 1437, 16, '2019-11-03', '2019-11-02', '', 1, 0, '2019-10-30 18:45:06', 1),
(48, 1872, 9, '2019-11-03', '2019-10-30', 'CANCELADA ', 1, 0, '2019-10-30 20:12:23', 1),
(49, 1916, 9, '2019-11-01', '2019-10-27', '', 1, 0, '2019-10-31 14:28:08', 1),
(50, 1880, 9, '2019-11-01', '2019-10-28', '', 1, 0, '2019-10-31 14:28:25', 1),
(51, 1929, 14, '2019-10-31', '2019-11-01', '', 1, 0, '2019-10-31 19:48:12', 1),
(52, 1931, 14, '2019-11-02', '2019-11-01', '', 1, 0, '2019-10-31 22:10:08', 1),
(53, 1823, 16, '2019-11-03', '2019-11-04', '', 1, 0, '2019-11-01 12:16:50', 1),
(54, 1903, 9, '2019-11-02', '2019-10-31', 'CANCELADA POR OPERADOR', 1, 0, '2019-11-01 19:53:45', 2),
(55, 1903, 9, '2019-10-31', '2019-11-02', '', 1, 0, '2019-11-01 20:29:25', 1),
(56, 1681, 9, '2019-11-03', '2019-11-23', '', 1, 0, '2019-11-03 11:23:25', 2),
(57, 1289, 14, '2019-11-09', '2019-11-16', '', 1, 0, '2019-11-04 12:29:09', 1),
(58, 1681, 9, '2019-11-23', '2019-11-24', 'MAL CLIMA', 1, 0, '2019-11-04 12:35:08', 1),
(59, 2008, 9, '2019-11-04', '2019-11-05', 'paga penalizacion fue no show', 1, 0, '2019-11-04 14:57:46', 1),
(60, 1915, 9, '2019-11-05', '2019-11-01', '', 1, 0, '2019-11-04 18:28:34', 1),
(61, 1628, 14, '2019-11-15', '2019-11-14', '', 1, 0, '2019-11-04 19:41:22', 1),
(62, 1932, 14, '2019-11-03', '2019-11-10', 'se reprogramo por clima', 1, 0, '2019-11-05 15:19:22', 1),
(63, 2069, 9, '2019-11-06', '2019-11-08', '', 1, 20, '2019-11-05 22:06:13', 2),
(64, 1695, 14, '2019-11-05', '2019-11-06', '', 1, 0, '2019-11-06 12:09:50', 2),
(65, 1695, 14, '2019-11-06', '2019-11-07', '', 1, 0, '2019-11-06 12:54:18', 2),
(66, 1695, 14, '2019-11-07', '2019-11-07', '', 1, 0, '2019-11-06 12:54:29', 1),
(67, 2069, 9, '2019-11-08', '2019-11-07', '', 1, 0, '2019-11-06 13:24:54', 1),
(68, 1635, 1, '2019-11-11', '2019-11-01', '', 1, 0, '2019-11-07 09:33:30', 1),
(69, 1502, 1, '2020-03-21', '2019-10-10', '', 1, 0, '2019-11-07 09:33:46', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `restaurantes_volar`
--

CREATE TABLE `restaurantes_volar` (
  `id_restaurant` int(11) NOT NULL COMMENT 'Llave Primaria',
  `nombre_restaurant` varchar(150) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Nombre',
  `hotel_restaurant` int(11) NOT NULL DEFAULT 1 COMMENT 'Hotel',
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
  `precion_restaurant` double(10,2) DEFAULT 0.00 COMMENT 'Precio de Niños',
  `precioa_restaurant` double(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Precio de Adultos',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Estatus'
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
  `cortesia_servicio` tinyint(4) DEFAULT 1 COMMENT 'Con Cortesia',
  `cantmax_servicio` tinyint(4) DEFAULT NULL COMMENT 'Cantidad',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
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
(28, 'QUITO SOL DOBLE', '1300.00', 'noimage.png', 0, 0, '2019-08-16 14:54:58', 0),
(29, 'HAB TRIPLE QTO SOL', '1450.00', 'noimage.png', 0, 0, '2019-08-16 14:55:53', 0),
(30, 'QUINTO SOL CUADRUPLE', '1650.00', 'noimage.png', 0, 0, '2019-08-16 14:56:53', 0),
(31, 'HAB CUADRUPLE QTO SOL', '1650.00', 'noimage.png', 0, 0, '2019-08-16 14:57:04', 0),
(32, 'QUINTO SOL SUITE', '1950.00', 'noimage.png', 0, 0, '2019-08-16 14:57:38', 0),
(33, 'JAGUAR DOBLE', '1450.00', 'noimage.png', 0, 0, '2019-08-16 14:59:19', 0),
(34, 'HAB TRIP BOU JAGUAR', '0.00', 'noimage.png', 0, 0, '2019-08-16 14:59:45', 0),
(35, 'JAGUAR CUADRUPLE', '1750.00', 'noimage.png', 0, 0, '2019-08-16 15:00:12', 0),
(36, 'HAB QUINTUPLE JAGUAR', '0.00', 'noimage.png', 0, 0, '2019-08-16 15:00:34', 0),
(37, 'QUINTO SOL TRIPLE', '1450.00', 'noimage.png', 0, 0, '2019-08-22 18:00:04', 0),
(38, 'VARIOS', '500.00', 'noimage.png', 0, 1, '2019-08-22 18:07:42', 1);

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
(2573, 1097, 14, 1, 1, '2019-09-19 13:48:54', 0),
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
(2621, 1154, 14, 1, 1, '2019-09-24 17:24:53', 0),
(2622, 1155, 5, 1, 1, '2019-09-24 17:42:46', 0),
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
(2755, 1250, 14, 1, 1, '2019-10-03 13:39:18', 2),
(2756, 1251, 14, 1, 1, '2019-10-03 13:39:55', 2),
(2757, 1251, 5, 1, 1, '2019-10-03 13:39:56', 2),
(2758, 1253, 5, 1, 1, '2019-10-03 13:47:54', 2),
(2759, 1255, 5, 1, 1, '2019-10-03 14:35:05', 0),
(2760, 1257, 14, 1, 1, '2019-10-03 14:43:09', 2),
(2761, 1258, 5, 1, 1, '2019-10-03 14:49:12', 2),
(2762, 1258, 14, 1, 1, '2019-10-03 14:49:13', 2),
(2763, 1258, 26, 1, 1, '2019-10-03 14:49:16', 2),
(2764, 1258, 17, 1, 2, '2019-10-03 14:49:18', 2),
(2765, 1259, 14, 1, 1, '2019-10-03 14:56:42', 2),
(2766, 1259, 5, 1, 1, '2019-10-03 14:57:47', 2),
(2767, 1261, 5, 1, 0, '2019-10-04 09:26:45', 2),
(2768, 1262, 14, 1, 1, '2019-10-04 14:40:32', 2),
(2769, 1263, 14, 1, 1, '2019-10-04 14:53:51', 2),
(2770, 1265, 14, 1, 1, '2019-10-05 15:22:34', 2),
(2771, 1267, 5, 1, 1, '2019-10-05 15:33:21', 2),
(2772, 1267, 14, 1, 1, '2019-10-05 15:33:23', 2),
(2773, 1267, 17, 1, 2, '2019-10-05 15:33:26', 2),
(2774, 1267, 26, 1, 1, '2019-10-05 15:33:28', 2),
(2775, 1268, 5, 1, 1, '2019-10-05 15:38:11', 2),
(2776, 1268, 14, 1, 1, '2019-10-05 15:38:12', 2),
(2777, 1268, 17, 1, 7, '2019-10-05 15:38:17', 2),
(2778, 1268, 26, 1, 1, '2019-10-05 15:38:19', 2),
(2779, 1270, 5, 1, 1, '2019-10-05 15:42:28', 2),
(2780, 1270, 14, 1, 1, '2019-10-05 15:42:33', 2),
(2781, 1270, 17, 1, 2, '2019-10-05 15:42:36', 2),
(2782, 1270, 26, 1, 1, '2019-10-05 15:42:37', 2),
(2783, 1271, 5, 1, 1, '2019-10-05 15:45:57', 2),
(2784, 1271, 14, 1, 1, '2019-10-05 15:45:58', 2),
(2785, 1271, 17, 1, 8, '2019-10-05 15:46:04', 2),
(2786, 1271, 26, 1, 1, '2019-10-05 15:46:06', 2),
(2787, 1273, 14, 1, 1, '2019-10-06 22:09:10', 2),
(2788, 1274, 5, 1, 1, '2019-10-07 13:55:20', 2),
(2789, 1275, 5, 1, 1, '2019-10-07 14:17:25', 2),
(2802, 1281, 14, 1, 1, '2019-10-08 13:21:27', 2),
(2803, 1283, 5, 1, 1, '2019-10-08 14:10:26', 2),
(2804, 1286, 14, 1, 1, '2019-10-08 15:47:07', 2),
(2805, 1292, 5, 2, 1, '2019-10-10 11:52:08', 2),
(2806, 1292, 16, 2, 2, '2019-10-10 11:52:10', 2),
(2807, 1296, 5, 1, 1, '2019-10-10 12:19:54', 2),
(2808, 1296, 7, 1, 3, '2019-10-10 12:19:56', 2),
(2809, 1296, 2, 1, 3, '2019-10-10 12:19:59', 2),
(2810, 1297, 14, 1, 1, '2019-10-10 16:07:24', 2),
(2811, 1298, 14, 1, 1, '2019-10-10 18:14:54', 2),
(2815, 1303, 5, 1, 0, '2019-10-11 12:44:04', 2),
(2816, 1307, 14, 1, 1, '2019-10-11 13:26:12', 2),
(2817, 1309, 1, 1, 2, '2019-10-11 13:35:28', 2),
(2818, 1309, 5, 1, 1, '2019-10-11 13:35:30', 2),
(2819, 1310, 7, 1, 3, '2019-10-11 13:39:05', 2),
(2820, 1312, 14, 1, 1, '2019-10-11 13:54:37', 2),
(2821, 1312, 5, 1, 1, '2019-10-11 13:54:41', 2),
(2822, 1313, 5, 1, 1, '2019-10-11 14:38:28', 2),
(2823, 1316, 5, 1, 1, '2019-10-11 15:13:03', 2),
(2824, 1317, 17, 1, 2, '2019-10-11 15:21:12', 2),
(2825, 1318, 14, 1, 1, '2019-10-11 16:05:58', 2),
(2826, 1318, 2, 1, 2, '2019-10-11 16:06:01', 2),
(2827, 1318, 7, 1, 2, '2019-10-11 16:06:03', 2),
(2828, 1321, 5, 1, 1, '2019-10-11 16:55:46', 2),
(2829, 1324, 14, 1, 1, '2019-10-11 17:42:23', 2),
(2830, 1324, 5, 1, 1, '2019-10-11 17:42:28', 2),
(2831, 1324, 18, 1, 0, '2019-10-11 17:42:31', 2),
(2832, 1324, 17, 1, 8, '2019-10-11 17:42:34', 2),
(2833, 1324, 26, 1, 1, '2019-10-11 17:42:35', 2),
(2834, 1325, 5, 1, 1, '2019-10-11 17:49:19', 2),
(2835, 1325, 14, 1, 1, '2019-10-11 17:49:24', 2),
(2836, 1325, 17, 1, 2, '2019-10-11 17:50:26', 2),
(2837, 1325, 26, 1, 1, '2019-10-11 17:51:26', 2),
(2838, 1327, 5, 1, 1, '2019-10-11 18:01:58', 2),
(2839, 1327, 14, 1, 1, '2019-10-11 18:02:00', 2),
(2840, 1327, 17, 1, 2, '2019-10-11 18:02:03', 2),
(2841, 1328, 5, 1, 1, '2019-10-11 18:11:31', 2),
(2842, 1328, 14, 1, 1, '2019-10-11 18:11:33', 2),
(2843, 1328, 17, 1, 10, '2019-10-11 18:11:34', 2),
(2844, 1328, 26, 1, 1, '2019-10-11 18:11:37', 2),
(2845, 1329, 5, 1, 1, '2019-10-11 18:15:21', 2),
(2846, 1329, 14, 1, 1, '2019-10-11 18:15:23', 2),
(2847, 1329, 17, 1, 8, '2019-10-11 18:15:25', 2),
(2848, 1329, 26, 1, 1, '2019-10-11 18:15:26', 2),
(2849, 1332, 5, 1, 1, '2019-10-11 18:29:19', 2),
(2850, 1332, 14, 1, 1, '2019-10-11 18:29:20', 2),
(2851, 1332, 17, 1, 4, '2019-10-11 18:29:21', 2),
(2852, 1332, 26, 1, 1, '2019-10-11 18:29:22', 2),
(2853, 1334, 5, 1, 1, '2019-10-11 18:59:10', 2),
(2854, 1334, 14, 1, 1, '2019-10-11 18:59:11', 2),
(2855, 1335, 5, 1, 1, '2019-10-11 19:02:27', 2),
(2856, 1335, 14, 1, 1, '2019-10-11 19:02:27', 2),
(2858, 1337, 5, 2, 1, '2019-10-12 13:13:09', 2),
(2859, 1337, 16, 2, 2, '2019-10-12 13:13:11', 2),
(2860, 1337, 14, 1, 1, '2019-10-12 13:14:44', 2),
(2861, 1338, 14, 2, 1, '2019-10-12 13:48:08', 2),
(2862, 1340, 5, 2, 1, '2019-10-12 14:26:49', 2),
(2863, 1340, 16, 2, 2, '2019-10-12 14:26:52', 2),
(2864, 1350, 14, 1, 1, '2019-10-13 14:56:53', 2),
(2865, 1350, 5, 1, 1, '2019-10-13 14:57:22', 2),
(2866, 1354, 5, 1, 1, '2019-10-13 21:11:53', 2),
(2867, 1355, 14, 1, 1, '2019-10-14 10:50:18', 2),
(2868, 1357, 14, 1, 1, '2019-10-14 11:02:21', 2),
(2869, 1360, 5, 1, 1, '2019-10-14 13:40:42', 2),
(2870, 1361, 5, 1, 1, '2019-10-14 13:48:27', 2),
(2871, 1361, 14, 1, 1, '2019-10-14 13:48:32', 2),
(2872, 1363, 5, 1, 1, '2019-10-14 13:57:00', 2),
(2873, 1364, 5, 1, 0, '2019-10-14 14:12:01', 2),
(2874, 1364, 14, 1, 1, '2019-10-14 14:12:11', 2),
(2875, 1364, 17, 1, 2, '2019-10-14 14:12:13', 2),
(2876, 1364, 26, 1, 1, '2019-10-14 14:12:15', 2),
(2877, 1365, 5, 1, 1, '2019-10-14 14:52:39', 2),
(2878, 1365, 14, 1, 1, '2019-10-14 14:52:50', 2),
(2879, 1366, 5, 1, 1, '2019-10-14 15:00:54', 2),
(2880, 1367, 5, 1, 1, '2019-10-14 15:14:33', 2),
(2881, 1368, 5, 1, 0, '2019-10-14 15:22:43', 2),
(2882, 1369, 5, 1, 1, '2019-10-14 15:31:18', 2),
(2883, 1370, 5, 1, 1, '2019-10-14 15:42:51', 2),
(2884, 1371, 5, 1, 0, '2019-10-14 15:45:29', 2),
(2885, 1372, 5, 1, 0, '2019-10-14 15:55:29', 2),
(2886, 1372, 14, 1, 1, '2019-10-14 15:55:39', 2),
(2887, 1374, 14, 2, 1, '2019-10-14 18:01:17', 2),
(2888, 1375, 5, 1, 1, '2019-10-14 18:13:29', 2),
(2889, 1376, 5, 1, 1, '2019-10-14 18:17:21', 2),
(2890, 1377, 14, 2, 1, '2019-10-14 19:26:54', 2),
(2891, 1378, 12, 1, 1, '2019-10-15 11:51:50', 2),
(2892, 1378, 1, 1, 2, '2019-10-15 11:51:51', 2),
(2893, 1379, 5, 1, 1, '2019-10-15 12:11:23', 2),
(2894, 1381, 17, 1, 0, '2019-10-15 13:17:42', 2),
(2895, 1381, 11, 1, 0, '2019-10-15 13:17:42', 2),
(2896, 1381, 9, 1, 0, '2019-10-15 13:17:42', 2),
(2897, 1382, 14, 1, 1, '2019-10-15 13:26:55', 2),
(2898, 1383, 5, 1, 1, '2019-10-15 13:39:29', 2),
(2899, 1383, 14, 1, 1, '2019-10-15 13:39:29', 2),
(2901, 1384, 5, 1, 1, '2019-10-15 13:52:09', 2),
(2902, 1384, 14, 1, 1, '2019-10-15 13:52:12', 2),
(2903, 1385, 5, 1, 1, '2019-10-15 14:04:11', 2),
(2904, 1386, 14, 1, 1, '2019-10-15 15:45:04', 2),
(2905, 1390, 5, 1, 1, '2019-10-16 11:15:57', 2),
(2906, 1392, 5, 1, 1, '2019-10-16 11:46:09', 2),
(2907, 1393, 14, 1, 1, '2019-10-16 13:24:40', 2),
(2908, 1394, 14, 1, 1, '2019-10-16 13:55:04', 2),
(2909, 1395, 14, 1, 1, '2019-10-16 14:47:59', 2),
(2910, 1396, 5, 1, 1, '2019-10-16 14:54:12', 2),
(2911, 1397, 5, 1, 1, '2019-10-16 15:02:41', 2),
(2912, 1402, 5, 1, 1, '2019-10-16 18:40:14', 2),
(2913, 1402, 14, 1, 1, '2019-10-16 18:40:16', 2),
(2914, 1402, 26, 1, 1, '2019-10-16 18:40:22', 2),
(2915, 1403, 1, 1, 2, '2019-10-16 18:49:07', 2),
(2916, 1403, 8, 1, 2, '2019-10-16 18:49:10', 2),
(2917, 1404, 5, 1, 1, '2019-10-17 10:59:38', 2),
(2918, 1405, 15, 1, 1, '2019-10-17 11:04:58', 2),
(2919, 1406, 5, 1, 1, '2019-10-17 11:20:56', 2),
(2920, 1407, 5, 1, 1, '2019-10-17 11:30:25', 2),
(2921, 1407, 14, 1, 1, '2019-10-17 11:30:25', 2),
(2922, 1407, 26, 1, 1, '2019-10-17 11:30:25', 2),
(2923, 1408, 15, 1, 1, '2019-10-17 12:07:26', 2),
(2924, 1409, 14, 1, 1, '2019-10-17 12:12:11', 2),
(2925, 1410, 5, 1, 1, '2019-10-17 12:17:17', 2),
(2926, 1414, 14, 1, 1, '2019-10-17 13:52:07', 2),
(2927, 1414, 5, 1, 1, '2019-10-17 13:52:09', 2),
(2928, 1420, 14, 1, 1, '2019-10-17 17:07:13', 2),
(2929, 1421, 5, 1, 1, '2019-10-17 17:29:04', 2),
(2930, 1422, 14, 1, 1, '2019-10-17 17:34:16', 2),
(2931, 1423, 14, 1, 1, '2019-10-17 17:44:45', 2),
(2932, 1422, 13, 1, 0, '2019-10-17 18:03:07', 2),
(2933, 1426, 14, 1, 1, '2019-10-17 18:51:51', 2),
(2934, 1426, 5, 1, 1, '2019-10-17 18:51:52', 2),
(2935, 1426, 17, 1, 2, '2019-10-17 18:51:54', 2),
(2936, 1426, 26, 1, 1, '2019-10-17 18:51:55', 2),
(2937, 1429, 14, 1, 1, '2019-10-18 10:47:52', 2),
(2938, 1432, 14, 1, 1, '2019-10-18 12:02:52', 2),
(2939, 1433, 14, 1, 1, '2019-10-18 12:05:57', 2),
(2940, 1435, 14, 1, 1, '2019-10-18 12:56:00', 2),
(2941, 1435, 5, 1, 1, '2019-10-18 12:56:06', 2),
(2942, 1435, 17, 1, 1, '2019-10-18 12:56:09', 2),
(2943, 1435, 26, 1, 1, '2019-10-18 12:56:10', 2),
(2944, 1436, 5, 1, 1, '2019-10-18 13:11:02', 2),
(2945, 1437, 5, 1, 1, '2019-10-18 13:32:05', 2),
(2946, 1438, 5, 1, 1, '2019-10-18 13:44:07', 2),
(2947, 1438, 14, 1, 1, '2019-10-18 13:44:08', 2),
(2948, 1439, 5, 2, 1, '2019-10-18 14:28:04', 2),
(2949, 1440, 5, 2, 1, '2019-10-18 14:36:21', 2),
(2950, 1441, 5, 1, 1, '2019-10-18 14:43:32', 2),
(2951, 1442, 5, 1, 1, '2019-10-18 14:50:59', 2),
(2952, 1443, 5, 2, 1, '2019-10-18 14:58:04', 2),
(2953, 1444, 14, 1, 1, '2019-10-18 15:09:02', 2),
(2954, 1445, 14, 1, 1, '2019-10-18 15:15:49', 2),
(2955, 1448, 5, 1, 1, '2019-10-18 15:34:03', 2),
(2956, 1452, 5, 2, 1, '2019-10-18 17:43:54', 2),
(2957, 1452, 14, 1, 1, '2019-10-18 17:44:28', 2),
(2958, 1453, 14, 1, 1, '2019-10-18 17:52:28', 2),
(2959, 1455, 14, 1, 1, '2019-10-18 18:12:28', 2),
(2960, 1456, 14, 1, 1, '2019-10-18 18:19:32', 2),
(2961, 1462, 5, 1, 1, '2019-10-18 20:41:29', 2),
(2962, 1462, 14, 1, 1, '2019-10-18 20:41:29', 2),
(2963, 1465, 14, 1, 1, '2019-10-19 11:53:46', 2),
(2964, 1465, 5, 1, 1, '2019-10-19 11:53:47', 2),
(2965, 1467, 5, 2, 1, '2019-10-19 12:08:39', 2),
(2966, 1470, 5, 2, 1, '2019-10-19 12:56:25', 2),
(2967, 1470, 14, 2, 1, '2019-10-19 12:56:46', 2),
(2968, 1472, 14, 1, 1, '2019-10-19 13:31:43', 2),
(2969, 1475, 5, 2, 1, '2019-10-19 16:16:42', 2),
(2970, 1475, 16, 2, 2, '2019-10-19 16:16:47', 2),
(2971, 1476, 5, 2, 1, '2019-10-19 17:40:46', 2),
(2972, 1476, 16, 2, 2, '2019-10-19 17:40:51', 2),
(2973, 1476, 14, 1, 1, '2019-10-19 17:41:44', 2),
(2974, 1476, 7, 1, 2, '2019-10-19 17:41:51', 2),
(2975, 1481, 5, 1, 1, '2019-10-19 20:08:12', 2),
(2976, 1482, 5, 1, 1, '2019-10-19 22:03:30', 2),
(2977, 1482, 14, 1, 1, '2019-10-19 22:03:34', 2),
(2978, 1483, 5, 1, 1, '2019-10-20 12:18:50', 2),
(2979, 1486, 5, 1, 1, '2019-10-20 15:56:01', 2),
(2980, 1486, 14, 1, 1, '2019-10-20 15:56:05', 2),
(2981, 1487, 14, 1, 1, '2019-10-20 18:11:09', 2),
(2982, 1491, 14, 2, 1, '2019-10-20 22:42:16', 2),
(2983, 1493, 14, 1, 1, '2019-10-21 10:23:20', 2),
(2984, 1498, 5, 2, 1, '2019-10-21 10:48:37', 2),
(2985, 1498, 16, 2, 2, '2019-10-21 10:48:39', 2),
(2986, 1498, 14, 1, 1, '2019-10-21 10:49:07', 2),
(2987, 1498, 17, 1, 2, '2019-10-21 10:49:11', 2),
(2988, 1499, 14, 1, 1, '2019-10-21 10:53:03', 2),
(2989, 1501, 5, 1, 1, '2019-10-21 11:00:01', 2),
(2990, 1505, 5, 2, 1, '2019-10-21 12:34:49', 2),
(2991, 1505, 16, 2, 2, '2019-10-21 12:34:51', 2),
(2992, 1510, 14, 1, 1, '2019-10-21 13:51:32', 2),
(2993, 1510, 5, 1, 1, '2019-10-21 13:51:57', 2),
(2994, 1513, 14, 1, 1, '2019-10-21 13:55:07', 2),
(2995, 1513, 5, 1, 1, '2019-10-21 13:55:07', 2),
(2997, 1512, 14, 1, 1, '2019-10-21 13:56:04', 2),
(2998, 1514, 14, 1, 1, '2019-10-21 14:26:00', 2),
(2999, 1514, 5, 2, 1, '2019-10-21 14:26:03', 2),
(3000, 1515, 14, 1, 1, '2019-10-21 14:31:58', 2),
(3001, 1515, 5, 2, 1, '2019-10-21 14:31:58', 2),
(3003, 1515, 16, 2, 2, '2019-10-21 14:33:21', 2),
(3004, 1521, 5, 2, 1, '2019-10-21 16:50:11', 2),
(3005, 1521, 16, 2, 11, '2019-10-21 16:50:12', 2),
(3006, 1522, 5, 2, 1, '2019-10-21 17:17:15', 2),
(3007, 1522, 16, 2, 11, '2019-10-21 17:17:15', 2),
(3009, 1523, 14, 1, 1, '2019-10-21 18:13:05', 2),
(3010, 1525, 14, 1, 1, '2019-10-21 18:23:35', 2),
(3011, 1525, 5, 1, 1, '2019-10-21 18:23:35', 2),
(3013, 1528, 5, 2, 1, '2019-10-21 18:38:57', 2),
(3014, 1528, 16, 2, 2, '2019-10-21 18:39:19', 2),
(3015, 1536, 14, 1, 0, '2019-10-21 19:54:46', 2),
(3016, 1536, 5, 1, 0, '2019-10-21 19:54:46', 2),
(3018, 1537, 14, 1, 0, '2019-10-21 21:27:20', 2),
(3019, 1537, 5, 1, 0, '2019-10-21 21:27:20', 2),
(3021, 1539, 14, 1, 1, '2019-10-21 21:40:18', 2),
(3022, 1540, 16, 2, 2, '2019-10-21 22:09:46', 2),
(3023, 1540, 5, 2, 1, '2019-10-21 22:09:53', 2),
(3024, 1541, 14, 1, 1, '2019-10-21 22:18:40', 2),
(3025, 1541, 5, 2, 1, '2019-10-21 22:21:16', 2),
(3026, 1543, 5, 1, 1, '2019-10-22 00:06:58', 2),
(3027, 1543, 14, 1, 1, '2019-10-22 00:07:07', 2),
(3028, 1543, 17, 1, 1, '2019-10-22 00:07:10', 2),
(3029, 1543, 26, 1, 1, '2019-10-22 00:07:13', 2),
(3030, 1544, 5, 1, 1, '2019-10-22 10:55:44', 2),
(3031, 1545, 5, 2, 1, '2019-10-22 10:57:08', 2),
(3032, 1545, 16, 2, 2, '2019-10-22 10:57:09', 2),
(3033, 1550, 5, 1, 1, '2019-10-22 12:12:25', 2),
(3034, 1549, 14, 1, 1, '2019-10-22 12:12:42', 2),
(3035, 1551, 5, 1, 1, '2019-10-22 12:15:07', 2),
(3036, 1552, 5, 1, 1, '2019-10-22 12:22:56', 2),
(3037, 1553, 16, 2, 7, '2019-10-22 12:25:01', 2),
(3038, 1553, 5, 2, 1, '2019-10-22 12:25:02', 2),
(3039, 1554, 14, 1, 1, '2019-10-22 12:34:40', 2),
(3040, 1564, 14, 1, 1, '2019-10-22 15:11:11', 0),
(3041, 1565, 14, 1, 1, '2019-10-22 15:17:14', 0),
(3042, 1566, 14, 1, 1, '2019-10-22 15:31:00', 2),
(3043, 1567, 14, 1, 1, '2019-10-22 15:47:32', 2),
(3044, 1568, 14, 1, 1, '2019-10-22 16:09:31', 0),
(3045, 1568, 5, 2, 1, '2019-10-22 16:11:14', 0),
(3046, 1569, 5, 1, 1, '2019-10-22 16:17:40', 2),
(3047, 1569, 14, 1, 1, '2019-10-22 16:17:41', 2),
(3048, 1569, 17, 1, 5, '2019-10-22 16:17:45', 2),
(3049, 1569, 26, 1, 1, '2019-10-22 16:18:55', 2),
(3050, 1570, 14, 1, 1, '2019-10-22 17:56:53', 2),
(3051, 1570, 5, 1, 1, '2019-10-22 17:56:54', 2),
(3052, 1570, 17, 1, 2, '2019-10-22 17:56:57', 2),
(3053, 1570, 26, 1, 1, '2019-10-22 17:56:59', 2),
(3054, 1572, 5, 1, 0, '2019-10-22 18:03:53', 2),
(3055, 1573, 14, 1, 1, '2019-10-22 18:04:09', 2),
(3056, 1574, 5, 2, 1, '2019-10-22 18:09:13', 2),
(3057, 1574, 16, 2, 2, '2019-10-22 18:09:15', 2),
(3058, 1575, 5, 1, 1, '2019-10-22 18:26:51', 2),
(3059, 1579, 5, 1, 1, '2019-10-22 18:49:25', 2),
(3060, 1581, 5, 2, 1, '2019-10-22 20:44:33', 2),
(3061, 1581, 16, 2, 2, '2019-10-22 20:44:52', 2),
(3062, 1583, 5, 1, 1, '2019-10-22 22:51:21', 2),
(3063, 1586, 14, 1, 1, '2019-10-22 23:12:51', 2),
(3064, 1587, 5, 2, 1, '2019-10-23 10:35:36', 2),
(3065, 1587, 16, 2, 2, '2019-10-23 10:35:37', 2),
(3066, 1589, 5, 1, 1, '2019-10-23 11:51:44', 2),
(3067, 1593, 5, 1, 1, '2019-10-23 12:50:39', 2),
(3068, 1596, 5, 1, 1, '2019-10-23 13:16:47', 2),
(3069, 1596, 14, 1, 1, '2019-10-23 13:17:06', 2),
(3070, 1597, 5, 1, 1, '2019-10-23 13:24:16', 2),
(3071, 1599, 14, 2, 1, '2019-10-23 13:41:22', 0),
(3072, 1600, 5, 1, 1, '2019-10-23 13:42:50', 2),
(3073, 1601, 14, 2, 1, '2019-10-23 13:44:41', 2),
(3074, 1604, 5, 2, 1, '2019-10-23 14:15:49', 2),
(3075, 1604, 7, 2, 2, '2019-10-23 14:15:51', 2),
(3076, 1606, 5, 1, 1, '2019-10-23 14:53:55', 2),
(3077, 1605, 14, 1, 1, '2019-10-23 14:56:09', 2),
(3078, 1607, 5, 1, 1, '2019-10-23 14:57:15', 2),
(3079, 1608, 5, 1, 1, '2019-10-23 15:17:08', 2),
(3080, 1608, 14, 1, 1, '2019-10-23 15:17:10', 2),
(3081, 1610, 5, 2, 1, '2019-10-23 15:25:45', 2),
(3082, 1610, 16, 2, 2, '2019-10-23 15:25:47', 2),
(3083, 1610, 1, 1, 2, '2019-10-23 15:26:19', 2),
(3084, 1610, 7, 1, 2, '2019-10-23 15:26:32', 2),
(3085, 1611, 5, 2, 1, '2019-10-23 15:41:15', 2),
(3086, 1611, 16, 2, 3, '2019-10-23 15:42:19', 2),
(3087, 1615, 5, 2, 1, '2019-10-23 16:00:32', 2),
(3088, 1615, 16, 2, 2, '2019-10-23 16:00:33', 2),
(3089, 1617, 5, 1, 1, '2019-10-23 16:27:01', 2),
(3090, 1617, 14, 1, 1, '2019-10-23 16:27:25', 2),
(3091, 1623, 26, 1, 1, '2019-10-23 17:12:37', 2),
(3092, 1623, 5, 1, 1, '2019-10-23 17:12:42', 2),
(3093, 1623, 14, 1, 1, '2019-10-23 17:14:11', 2),
(3094, 1624, 5, 1, 1, '2019-10-23 17:14:13', 2),
(3095, 1624, 14, 1, 1, '2019-10-23 17:14:13', 2),
(3097, 1624, 18, 1, 7, '2019-10-23 17:14:42', 2),
(3098, 1624, 26, 1, 1, '2019-10-23 17:14:47', 2),
(3099, 1627, 5, 2, 1, '2019-10-23 17:53:47', 0),
(3100, 1628, 5, 2, 1, '2019-10-23 17:58:16', 2),
(3101, 1628, 16, 2, 2, '2019-10-23 17:58:18', 2),
(3102, 1629, 5, 1, 0, '2019-10-23 18:01:53', 2),
(3103, 1632, 14, 1, 1, '2019-10-23 18:18:52', 2),
(3104, 1633, 5, 1, 1, '2019-10-23 21:44:34', 2),
(3105, 1634, 14, 1, 1, '2019-10-23 22:36:44', 2),
(3106, 1635, 5, 1, 1, '2019-10-23 22:57:58', 2),
(3107, 1637, 5, 2, 1, '2019-10-24 10:25:42', 2),
(3108, 1637, 16, 2, 2, '2019-10-24 10:25:43', 2),
(3109, 1638, 14, 1, 1, '2019-10-24 10:32:16', 2),
(3110, 1639, 5, 1, 1, '2019-10-24 10:39:05', 2),
(3111, 1641, 5, 2, 1, '2019-10-24 11:45:04', 2),
(3112, 1641, 16, 2, 2, '2019-10-24 11:45:05', 2),
(3113, 1642, 14, 1, 1, '2019-10-24 11:55:16', 2),
(3114, 1644, 5, 1, 1, '2019-10-24 12:47:43', 2),
(3115, 1644, 17, 1, 4, '2019-10-24 12:47:55', 2),
(3116, 1644, 26, 1, 1, '2019-10-24 12:47:58', 2),
(3117, 1645, 14, 1, 1, '2019-10-24 13:02:37', 2),
(3118, 1647, 5, 1, 1, '2019-10-24 14:20:03', 2),
(3119, 1647, 14, 1, 1, '2019-10-24 14:20:04', 2),
(3120, 1648, 5, 1, 1, '2019-10-24 14:21:24', 2),
(3121, 1650, 14, 1, 1, '2019-10-24 14:29:27', 2),
(3122, 1652, 5, 1, 0, '2019-10-24 14:30:06', 2),
(3123, 1651, 5, 2, 1, '2019-10-24 14:33:06', 2),
(3124, 1654, 5, 1, 1, '2019-10-24 14:39:12', 2),
(3125, 1656, 14, 1, 1, '2019-10-24 14:50:36', 2),
(3126, 1657, 14, 1, 0, '2019-10-24 15:10:09', 2),
(3127, 1657, 2, 1, 3, '2019-10-24 15:10:28', 2),
(3128, 1657, 7, 1, 3, '2019-10-24 15:10:31', 2),
(3129, 1657, 5, 1, 1, '2019-10-24 15:13:29', 2),
(3130, 1658, 14, 1, 1, '2019-10-24 15:22:08', 2),
(3131, 1659, 5, 2, 1, '2019-10-24 15:30:06', 2),
(3132, 1659, 16, 2, 2, '2019-10-24 15:30:07', 2),
(3133, 1660, 5, 1, 1, '2019-10-24 16:32:03', 2),
(3134, 1663, 14, 1, 1, '2019-10-24 17:11:50', 2),
(3135, 1665, 5, 1, 1, '2019-10-24 17:18:43', 2),
(3136, 1667, 5, 1, 1, '2019-10-24 17:44:31', 2),
(3137, 1668, 5, 1, 0, '2019-10-24 17:45:50', 2),
(3138, 1669, 14, 1, 1, '2019-10-24 18:11:11', 2),
(3139, 1669, 5, 1, 1, '2019-10-24 18:11:17', 2),
(3140, 1673, 5, 2, 1, '2019-10-24 18:50:45', 2),
(3141, 1673, 16, 2, 2, '2019-10-24 18:50:45', 2),
(3143, 1674, 7, 1, 2, '2019-10-24 18:55:44', 2),
(3144, 1676, 14, 1, 1, '2019-10-24 18:58:08', 2),
(3145, 1677, 16, 1, 8, '2019-10-24 19:16:00', 0),
(3146, 1678, 16, 1, 8, '2019-10-24 19:29:28', 2),
(3147, 1679, 16, 2, 9, '2019-10-24 19:31:45', 2),
(3148, 1679, 5, 2, 1, '2019-10-24 19:31:49', 2),
(3149, 1680, 14, 1, 1, '2019-10-25 00:09:28', 2),
(3150, 1681, 5, 2, 1, '2019-10-25 00:25:26', 2),
(3151, 1686, 5, 1, 1, '2019-10-25 11:01:54', 2),
(3152, 1687, 5, 2, 1, '2019-10-25 11:14:41', 2),
(3153, 1687, 16, 2, 5, '2019-10-25 11:14:48', 2),
(3154, 1688, 5, 2, 1, '2019-10-25 11:17:20', 2),
(3155, 1689, 5, 1, 1, '2019-10-25 11:23:23', 2),
(3156, 1690, 5, 2, 1, '2019-10-25 11:32:17', 2),
(3157, 1690, 16, 2, 5, '2019-10-25 11:32:17', 2),
(3159, 1693, 5, 2, 1, '2019-10-25 12:12:49', 2),
(3160, 1693, 16, 2, 2, '2019-10-25 12:12:50', 2),
(3161, 1698, 5, 2, 1, '2019-10-25 13:58:13', 2),
(3162, 1701, 5, 2, 1, '2019-10-25 15:26:14', 2),
(3163, 1701, 16, 2, 2, '2019-10-25 15:26:17', 2),
(3164, 1703, 5, 1, 1, '2019-10-25 15:36:04', 2),
(3165, 1705, 5, 1, 1, '2019-10-25 15:56:41', 2),
(3166, 1709, 5, 1, 1, '2019-10-25 17:27:16', 2),
(3167, 1709, 14, 1, 1, '2019-10-25 17:27:24', 2),
(3168, 1710, 14, 1, 0, '2019-10-25 17:28:31', 2),
(3169, 1713, 14, 1, 1, '2019-10-25 18:05:53', 2),
(3170, 1716, 14, 1, 1, '2019-10-25 18:25:46', 0),
(3171, 1717, 14, 1, 1, '2019-10-25 18:26:23', 2),
(3172, 1719, 5, 2, 1, '2019-10-25 18:44:12', 2),
(3173, 1719, 16, 2, 2, '2019-10-25 18:44:12', 2),
(3175, 1721, 5, 1, 1, '2019-10-25 18:58:54', 2),
(3176, 1721, 14, 1, 1, '2019-10-25 18:58:55', 2),
(3177, 1721, 17, 1, 2, '2019-10-25 18:58:58', 2),
(3178, 1721, 26, 1, 1, '2019-10-25 18:58:59', 2),
(3179, 1722, 14, 1, 1, '2019-10-25 19:05:46', 2),
(3180, 1724, 5, 2, 1, '2019-10-25 19:09:44', 2),
(3181, 1724, 16, 2, 2, '2019-10-25 19:09:46', 2),
(3182, 1723, 5, 1, 1, '2019-10-25 19:10:07', 2),
(3183, 1723, 14, 1, 1, '2019-10-25 19:10:07', 2),
(3184, 1723, 17, 1, 2, '2019-10-25 19:10:10', 2),
(3185, 1723, 26, 1, 1, '2019-10-25 19:10:11', 2),
(3186, 1727, 14, 1, 1, '2019-10-25 21:02:13', 2),
(3187, 1728, 14, 1, 1, '2019-10-25 22:11:15', 2),
(3188, 1731, 15, 1, 1, '2019-10-26 02:39:23', 2),
(3189, 1732, 14, 1, 1, '2019-10-26 02:44:29', 2),
(3190, 1733, 5, 2, 1, '2019-10-26 11:39:44', 2),
(3191, 1733, 16, 2, 2, '2019-10-26 11:39:47', 2),
(3192, 1735, 14, 1, 1, '2019-10-26 13:52:49', 1),
(3193, 1737, 14, 1, 1, '2019-10-26 15:14:23', 2),
(3194, 1737, 5, 1, 1, '2019-10-26 15:14:24', 2),
(3195, 1739, 14, 1, 1, '2019-10-26 19:39:05', 2),
(3196, 1745, 5, 2, 1, '2019-10-27 12:40:12', 2),
(3197, 1746, 14, 1, 1, '2019-10-27 13:02:56', 2),
(3198, 1748, 14, 1, 1, '2019-10-27 13:23:32', 2),
(3199, 1754, 14, 1, 1, '2019-10-27 16:08:49', 2),
(3200, 1756, 14, 1, 1, '2019-10-27 16:21:12', 2),
(3201, 1759, 14, 1, 1, '2019-10-27 16:56:58', 2),
(3202, 1760, 15, 1, 1, '2019-10-27 17:28:41', 2),
(3203, 1764, 14, 1, 1, '2019-10-27 20:10:06', 2),
(3204, 1769, 17, 1, 2, '2019-10-28 11:36:00', 2),
(3205, 1769, 14, 1, 1, '2019-10-28 11:36:03', 2),
(3206, 1770, 17, 1, 2, '2019-10-28 11:52:14', 2),
(3207, 1770, 14, 1, 1, '2019-10-28 11:52:14', 2),
(3209, 1773, 14, 1, 1, '2019-10-28 13:18:08', 2),
(3210, 1774, 5, 2, 1, '2019-10-28 13:38:07', 2),
(3211, 1775, 5, 1, 1, '2019-10-28 13:48:17', 2),
(3212, 1775, 14, 1, 1, '2019-10-28 13:48:19', 2),
(3213, 1775, 26, 1, 1, '2019-10-28 13:48:20', 2),
(3214, 1775, 17, 1, 2, '2019-10-28 13:48:22', 2),
(3215, 1776, 16, 2, 2, '2019-10-28 14:26:24', 2),
(3216, 1776, 5, 2, 1, '2019-10-28 14:26:25', 2),
(3217, 1779, 5, 1, 1, '2019-10-28 14:38:54', 2),
(3218, 1780, 14, 1, 1, '2019-10-28 14:40:30', 2),
(3219, 1782, 14, 1, 1, '2019-10-28 14:55:26', 2),
(3220, 1782, 5, 2, 1, '2019-10-28 14:55:28', 2),
(3221, 1783, 5, 1, 1, '2019-10-28 14:55:33', 2),
(3222, 1785, 5, 1, 1, '2019-10-28 15:20:22', 2),
(3223, 1787, 5, 2, 1, '2019-10-28 15:47:22', 2),
(3224, 1787, 16, 2, 3, '2019-10-28 15:47:23', 2),
(3225, 1790, 5, 2, 1, '2019-10-28 15:54:47', 2),
(3226, 1790, 16, 2, 5, '2019-10-28 15:55:02', 2),
(3227, 1792, 5, 1, 1, '2019-10-28 16:01:54', 2),
(3228, 1792, 16, 2, 2, '2019-10-28 16:01:59', 2),
(3229, 1793, 5, 2, 1, '2019-10-28 16:02:39', 2),
(3230, 1793, 16, 2, 2, '2019-10-28 16:02:39', 2),
(3232, 1796, 14, 1, 1, '2019-10-28 16:47:06', 2),
(3233, 1797, 5, 1, 1, '2019-10-28 16:50:55', 2),
(3234, 1799, 14, 1, 1, '2019-10-28 17:06:32', 2),
(3235, 1800, 5, 2, 1, '2019-10-28 17:12:59', 2),
(3236, 1800, 16, 2, 2, '2019-10-28 17:13:00', 2),
(3237, 1803, 5, 1, 1, '2019-10-28 17:26:14', 2),
(3238, 1804, 5, 1, 1, '2019-10-28 17:28:09', 2),
(3239, 1806, 17, 1, 2, '2019-10-28 18:15:07', 2),
(3240, 1806, 14, 1, 1, '2019-10-28 18:15:10', 2),
(3241, 1806, 26, 1, 1, '2019-10-28 18:15:11', 2),
(3242, 1807, 14, 1, 1, '2019-10-28 18:29:25', 2),
(3243, 1808, 5, 2, 1, '2019-10-28 19:44:49', 2),
(3244, 1808, 16, 2, 2, '2019-10-28 19:44:51', 2),
(3245, 1812, 5, 2, 1, '2019-10-29 11:30:11', 2),
(3246, 1812, 16, 2, 2, '2019-10-29 11:30:12', 2),
(3247, 1814, 5, 1, 1, '2019-10-29 11:40:05', 2),
(3248, 1814, 26, 1, 1, '2019-10-29 11:40:08', 2),
(3249, 1814, 17, 1, 2, '2019-10-29 11:40:09', 2),
(3250, 1814, 14, 1, 1, '2019-10-29 11:40:11', 2),
(3251, 1813, 5, 2, 1, '2019-10-29 11:40:43', 2),
(3252, 1813, 16, 2, 2, '2019-10-29 11:40:46', 2),
(3253, 1816, 5, 1, 1, '2019-10-29 11:45:57', 2),
(3254, 1817, 14, 1, 1, '2019-10-29 11:49:31', 2),
(3255, 1819, 5, 2, 1, '2019-10-29 11:55:32', 2),
(3256, 1819, 16, 2, 2, '2019-10-29 11:55:33', 2),
(3257, 1820, 14, 1, 0, '2019-10-29 12:09:37', 2),
(3258, 1822, 14, 1, 0, '2019-10-29 12:39:16', 2),
(3259, 1823, 5, 1, 1, '2019-10-29 13:21:42', 2),
(3260, 1823, 14, 1, 1, '2019-10-29 13:21:44', 2),
(3261, 1823, 17, 1, 2, '2019-10-29 13:21:48', 2),
(3262, 1823, 26, 1, 1, '2019-10-29 13:21:50', 2),
(3263, 1824, 5, 2, 1, '2019-10-29 13:27:17', 2),
(3264, 1824, 16, 2, 2, '2019-10-29 13:27:17', 2),
(3265, 1824, 14, 1, 1, '2019-10-29 13:27:17', 2),
(3266, 1824, 7, 1, 0, '2019-10-29 13:27:17', 2),
(3270, 1825, 5, 2, 1, '2019-10-29 13:29:07', 2),
(3271, 1825, 16, 2, 2, '2019-10-29 13:29:07', 2),
(3272, 1825, 14, 1, 1, '2019-10-29 13:29:07', 2),
(3273, 1825, 7, 1, 0, '2019-10-29 13:29:07', 2),
(3277, 1827, 5, 2, 1, '2019-10-29 13:32:47', 2),
(3278, 1827, 16, 2, 2, '2019-10-29 13:32:47', 2),
(3280, 1828, 5, 2, 1, '2019-10-29 13:43:22', 2),
(3281, 1828, 16, 2, 2, '2019-10-29 13:43:23', 2),
(3282, 1829, 5, 2, 1, '2019-10-29 13:50:34', 2),
(3283, 1831, 5, 1, 0, '2019-10-29 13:56:11', 2),
(3284, 1832, 14, 1, 1, '2019-10-29 14:07:28', 2),
(3285, 1833, 5, 2, 1, '2019-10-29 14:16:24', 2),
(3286, 1833, 16, 2, 2, '2019-10-29 14:16:24', 2),
(3287, 1833, 14, 1, 1, '2019-10-29 14:16:24', 2),
(3288, 1833, 7, 1, 0, '2019-10-29 14:16:24', 2),
(3292, 1834, 1, 1, 2, '2019-10-29 14:53:49', 2),
(3293, 1834, 5, 2, 1, '2019-10-29 14:54:08', 2),
(3294, 1834, 16, 2, 2, '2019-10-29 14:54:14', 2),
(3295, 1837, 5, 1, 1, '2019-10-29 15:26:05', 2),
(3296, 1839, 5, 1, 1, '2019-10-29 15:31:40', 2),
(3297, 1839, 14, 1, 1, '2019-10-29 15:31:43', 2),
(3298, 1839, 17, 1, 2, '2019-10-29 15:31:45', 2),
(3299, 1839, 26, 1, 1, '2019-10-29 15:31:46', 2),
(3300, 1838, 15, 1, 1, '2019-10-29 15:43:53', 2),
(3301, 1840, 14, 1, 1, '2019-10-29 15:45:34', 2),
(3302, 1842, 5, 1, 1, '2019-10-29 15:54:10', 2),
(3303, 1844, 5, 1, 1, '2019-10-29 16:15:36', 2),
(3304, 1846, 5, 1, 1, '2019-10-29 16:28:15', 2),
(3305, 1846, 14, 1, 1, '2019-10-29 16:28:16', 2),
(3306, 1847, 5, 1, 1, '2019-10-29 16:32:14', 2),
(3307, 1848, 5, 1, 1, '2019-10-29 16:34:11', 2),
(3308, 1849, 5, 1, 1, '2019-10-29 16:37:56', 2),
(3309, 1851, 14, 1, 1, '2019-10-29 16:53:40', 2),
(3310, 1852, 14, 1, 1, '2019-10-29 17:23:45', 2),
(3311, 1855, 5, 1, 1, '2019-10-29 17:43:52', 2),
(3312, 1855, 14, 1, 1, '2019-10-29 17:43:53', 2),
(3313, 1855, 1, 1, 2, '2019-10-29 17:43:54', 2),
(3314, 1855, 7, 1, 2, '2019-10-29 17:43:58', 2),
(3315, 1856, 14, 1, 1, '2019-10-29 17:49:02', 2),
(3316, 1857, 14, 1, 1, '2019-10-29 17:53:59', 2),
(3317, 1859, 5, 1, 1, '2019-10-29 17:54:18', 2),
(3318, 1859, 26, 1, 1, '2019-10-29 17:54:18', 2),
(3319, 1859, 17, 1, 2, '2019-10-29 17:54:18', 2),
(3320, 1859, 14, 1, 0, '2019-10-29 17:54:18', 2),
(3324, 1863, 14, 1, 1, '2019-10-29 18:18:39', 2),
(3325, 1866, 14, 1, 1, '2019-10-29 18:49:50', 2),
(3326, 1867, 5, 2, 1, '2019-10-29 18:55:42', 2),
(3327, 1867, 16, 2, 2, '2019-10-29 18:55:43', 2),
(3328, 1869, 5, 2, 1, '2019-10-29 19:08:50', 2),
(3329, 1871, 14, 2, 1, '2019-10-29 19:26:20', 2),
(3330, 1873, 5, 1, 1, '2019-10-29 19:54:53', 2),
(3331, 1874, 5, 1, 1, '2019-10-29 23:34:35', 2),
(3332, 1875, 5, 1, 1, '2019-10-30 00:28:37', 2),
(3333, 1876, 14, 1, 0, '2019-10-30 11:37:31', 2),
(3334, 1876, 5, 1, 1, '2019-10-30 11:37:34', 2),
(3335, 1876, 7, 1, 2, '2019-10-30 11:37:39', 2),
(3336, 1877, 14, 1, 1, '2019-10-30 12:00:26', 2),
(3337, 1877, 17, 1, 2, '2019-10-30 12:00:47', 2),
(3338, 1877, 26, 1, 1, '2019-10-30 12:00:51', 2),
(3339, 1879, 5, 2, 1, '2019-10-30 12:34:41', 2),
(3340, 1879, 16, 2, 2, '2019-10-30 12:34:43', 2),
(3341, 1879, 14, 1, 1, '2019-10-30 12:35:14', 2),
(3342, 1879, 17, 1, 2, '2019-10-30 12:35:23', 2),
(3343, 1879, 26, 1, 1, '2019-10-30 12:35:25', 2),
(3344, 1880, 14, 1, 1, '2019-10-30 12:49:28', 2),
(3345, 1882, 5, 2, 1, '2019-10-30 12:54:12', 2),
(3346, 1882, 16, 2, 2, '2019-10-30 12:54:14', 2),
(3347, 1884, 14, 1, 1, '2019-10-30 13:02:25', 2),
(3348, 1886, 14, 1, 0, '2019-10-30 14:12:00', 2),
(3349, 1888, 14, 1, 1, '2019-10-30 14:34:19', 2),
(3350, 1888, 5, 2, 1, '2019-10-30 14:35:03', 2),
(3351, 1890, 14, 1, 1, '2019-10-30 14:36:47', 2),
(3352, 1890, 5, 2, 1, '2019-10-30 14:36:47', 2),
(3354, 1890, 26, 1, 1, '2019-10-30 14:36:54', 2),
(3355, 1890, 18, 1, 15, '2019-10-30 14:36:56', 2),
(3356, 1891, 5, 2, 1, '2019-10-30 14:44:34', 2),
(3357, 1891, 16, 2, 6, '2019-10-30 14:44:36', 2),
(3358, 1893, 14, 1, 1, '2019-10-30 15:20:54', 2),
(3359, 1895, 16, 2, 2, '2019-10-30 15:44:17', 2),
(3360, 1895, 5, 2, 1, '2019-10-30 15:44:18', 2),
(3361, 1896, 5, 2, 1, '2019-10-30 15:58:08', 2),
(3362, 1896, 16, 2, 2, '2019-10-30 15:58:11', 2),
(3363, 1897, 14, 1, 1, '2019-10-30 16:00:53', 2),
(3364, 1899, 5, 2, 1, '2019-10-30 16:37:58', 2),
(3365, 1899, 16, 2, 4, '2019-10-30 16:38:01', 2),
(3366, 1902, 5, 2, 1, '2019-10-30 19:41:46', 2),
(3367, 1902, 16, 2, 2, '2019-10-30 19:41:46', 2),
(3368, 1902, 14, 1, 1, '2019-10-30 19:41:46', 2),
(3369, 1902, 17, 1, 0, '2019-10-30 19:41:46', 2),
(3370, 1902, 26, 1, 0, '2019-10-30 19:41:46', 2),
(3373, 1903, 14, 1, 1, '2019-10-30 22:10:39', 2),
(3374, 1904, 5, 1, 1, '2019-10-30 23:27:56', 2),
(3375, 1904, 14, 1, 1, '2019-10-30 23:28:12', 2),
(3376, 1905, 14, 1, 1, '2019-10-31 00:18:55', 2),
(3377, 1906, 5, 1, 1, '2019-10-31 11:50:18', 2),
(3378, 1908, 5, 1, 1, '2019-10-31 12:06:05', 2),
(3379, 1912, 5, 1, 1, '2019-10-31 13:45:20', 2),
(3380, 1913, 14, 1, 1, '2019-10-31 13:49:43', 2),
(3381, 1916, 14, 1, 1, '2019-10-31 14:20:22', 2),
(3382, 1917, 14, 1, 1, '2019-10-31 14:26:28', 2),
(3383, 1918, 5, 1, 1, '2019-10-31 14:53:39', 2),
(3384, 1921, 5, 1, 1, '2019-10-31 15:38:59', 2),
(3385, 1922, 5, 1, 1, '2019-10-31 15:39:57', 2),
(3386, 1923, 14, 1, 0, '2019-10-31 16:05:22', 2),
(3387, 1925, 14, 1, 1, '2019-10-31 16:25:57', 2),
(3388, 1938, 5, 1, 0, '2019-11-01 12:26:41', 2),
(3389, 1939, 5, 1, 1, '2019-11-01 13:16:46', 2),
(3390, 1947, 14, 1, 1, '2019-11-01 14:41:41', 2),
(3391, 1950, 5, 1, 1, '2019-11-01 14:51:37', 2),
(3392, 1950, 14, 1, 1, '2019-11-01 14:51:40', 2),
(3393, 1950, 26, 1, 1, '2019-11-01 14:51:42', 2),
(3394, 1950, 17, 1, 2, '2019-11-01 14:51:43', 2),
(3395, 1951, 5, 1, 1, '2019-11-01 14:54:58', 2),
(3396, 1951, 14, 1, 1, '2019-11-01 14:55:01', 2),
(3397, 1951, 17, 1, 4, '2019-11-01 14:55:04', 2),
(3398, 1951, 26, 1, 1, '2019-11-01 14:55:59', 2),
(3399, 1952, 5, 1, 1, '2019-11-01 15:11:15', 2),
(3400, 1954, 14, 1, 1, '2019-11-01 15:39:34', 2),
(3401, 1955, 14, 1, 1, '2019-11-01 16:06:13', 2),
(3402, 1955, 5, 2, 1, '2019-11-01 16:10:05', 2),
(3403, 1955, 16, 2, 2, '2019-11-01 16:10:09', 2),
(3404, 1958, 14, 1, 1, '2019-11-01 17:50:40', 2),
(3405, 1959, 5, 1, 1, '2019-11-01 17:50:41', 2),
(3406, 1963, 5, 1, 1, '2019-11-01 18:25:15', 2),
(3407, 1964, 14, 1, 0, '2019-11-01 18:57:20', 2),
(3408, 1967, 14, 1, 1, '2019-11-01 20:31:03', 2),
(3409, 1971, 14, 1, 1, '2019-11-01 21:25:00', 2),
(3410, 1971, 9, 1, 0, '2019-11-01 21:26:00', 2),
(3411, 1972, 14, 1, 1, '2019-11-01 21:54:42', 2),
(3412, 1976, 5, 2, 1, '2019-11-01 22:25:55', 2),
(3413, 1976, 14, 1, 1, '2019-11-01 22:25:59', 2),
(3414, 1976, 16, 2, 2, '2019-11-01 22:26:00', 2),
(3415, 1977, 5, 1, 1, '2019-11-01 22:49:37', 2),
(3416, 1977, 14, 1, 1, '2019-11-01 22:49:47', 2),
(3417, 1978, 5, 1, 1, '2019-11-01 22:57:22', 2),
(3418, 1978, 14, 1, 1, '2019-11-01 22:57:22', 2),
(3420, 1980, 5, 1, 1, '2019-11-02 00:09:10', 2),
(3421, 1980, 14, 1, 1, '2019-11-02 00:09:12', 2),
(3422, 1980, 17, 1, 5, '2019-11-02 00:09:18', 2),
(3423, 1980, 26, 1, 1, '2019-11-02 00:09:32', 2),
(3424, 1981, 14, 1, 1, '2019-11-02 00:13:37', 2),
(3425, 1983, 14, 1, 1, '2019-11-02 12:29:57', 2),
(3426, 1984, 5, 1, 1, '2019-11-02 14:35:22', 2),
(3427, 1987, 5, 1, 1, '2019-11-02 16:25:32', 2),
(3428, 1988, 5, 1, 0, '2019-11-02 20:15:13', 2),
(3429, 1989, 14, 1, 1, '2019-11-02 20:33:52', 2),
(3430, 1989, 18, 1, 0, '2019-11-02 20:35:04', 2),
(3431, 1989, 17, 1, 3, '2019-11-02 20:36:58', 2),
(3432, 1990, 5, 2, 1, '2019-11-02 20:44:33', 2),
(3433, 1990, 16, 2, 2, '2019-11-02 20:44:43', 2),
(3434, 1991, 17, 1, 5, '2019-11-02 21:17:52', 2),
(3435, 1991, 26, 1, 1, '2019-11-02 21:17:59', 2),
(3436, 1992, 14, 1, 1, '2019-11-02 21:34:17', 2),
(3437, 1993, 17, 1, 5, '2019-11-02 21:36:09', 2),
(3438, 1993, 26, 1, 1, '2019-11-02 21:36:09', 2),
(3440, 1995, 17, 1, 0, '2019-11-02 22:03:40', 2),
(3441, 1995, 26, 1, 1, '2019-11-02 22:03:40', 2),
(3443, 1995, 18, 1, 4, '2019-11-02 22:03:54', 2),
(3444, 1997, 5, 1, 1, '2019-11-02 22:18:38', 2),
(3445, 1998, 5, 1, 1, '2019-11-02 23:23:02', 2),
(3446, 1998, 14, 1, 1, '2019-11-02 23:23:15', 2),
(3447, 1998, 18, 1, 8, '2019-11-02 23:23:18', 2),
(3448, 1998, 26, 1, 1, '2019-11-02 23:23:20', 2),
(3449, 1999, 5, 2, 1, '2019-11-03 01:20:10', 2),
(3450, 2000, 5, 1, 1, '2019-11-03 10:56:23', 2),
(3451, 2000, 14, 1, 1, '2019-11-03 10:56:23', 2),
(3452, 2000, 18, 1, 8, '2019-11-03 10:56:23', 2),
(3453, 2000, 26, 1, 1, '2019-11-03 10:56:23', 2),
(3457, 2001, 14, 1, 1, '2019-11-03 11:42:31', 2),
(3458, 2002, 14, 1, 1, '2019-11-03 12:22:30', 2),
(3459, 2003, 5, 1, 1, '2019-11-03 14:39:50', 2),
(3460, 2003, 14, 1, 1, '2019-11-03 14:39:56', 2),
(3461, 2007, 5, 2, 1, '2019-11-03 15:48:20', 2),
(3462, 2008, 14, 1, 1, '2019-11-03 16:56:32', 2),
(3463, 2009, 5, 1, 1, '2019-11-03 17:07:53', 2),
(3464, 2010, 5, 1, 1, '2019-11-03 17:15:46', 2),
(3465, 2011, 14, 1, 1, '2019-11-03 17:54:15', 2),
(3466, 2012, 5, 2, 1, '2019-11-03 17:57:27', 2),
(3467, 2012, 14, 1, 1, '2019-11-03 17:57:30', 2),
(3468, 2012, 16, 2, 2, '2019-11-03 17:57:33', 2),
(3469, 2013, 5, 1, 1, '2019-11-03 18:55:12', 2),
(3470, 2013, 14, 1, 0, '2019-11-03 18:55:12', 2),
(3472, 2014, 5, 2, 1, '2019-11-03 19:21:28', 2),
(3473, 2014, 26, 1, 1, '2019-11-03 19:21:46', 2),
(3474, 2015, 14, 1, 1, '2019-11-03 21:28:05', 2),
(3475, 2017, 5, 1, 1, '2019-11-03 22:32:32', 2),
(3476, 2018, 14, 1, 1, '2019-11-04 10:30:08', 2),
(3477, 2019, 5, 2, 1, '2019-11-04 10:35:48', 2),
(3478, 2019, 7, 1, 2, '2019-11-04 10:35:50', 2),
(3479, 2020, 5, 1, 1, '2019-11-04 10:48:41', 2),
(3480, 2021, 5, 2, 1, '2019-11-04 11:02:27', 2),
(3481, 2022, 14, 1, 0, '2019-11-04 11:48:25', 2),
(3482, 2024, 14, 1, 1, '2019-11-04 12:36:46', 2),
(3483, 2025, 14, 1, 1, '2019-11-04 13:22:23', 2),
(3484, 2026, 14, 1, 1, '2019-11-04 13:28:16', 2),
(3485, 2027, 5, 2, 1, '2019-11-04 13:57:23', 2),
(3486, 2027, 16, 2, 2, '2019-11-04 13:57:26', 2),
(3487, 2028, 5, 2, 1, '2019-11-04 14:09:38', 2),
(3488, 2028, 16, 2, 2, '2019-11-04 14:09:57', 2),
(3489, 2029, 5, 1, 1, '2019-11-04 14:16:24', 2),
(3490, 2031, 14, 1, 0, '2019-11-04 14:26:52', 2),
(3491, 2032, 5, 2, 1, '2019-11-04 14:41:57', 2),
(3492, 2032, 14, 1, 1, '2019-11-04 14:41:57', 2),
(3493, 2032, 16, 2, 2, '2019-11-04 14:41:57', 2),
(3494, 2033, 14, 1, 1, '2019-11-04 14:48:35', 2),
(3495, 2036, 5, 2, 1, '2019-11-04 15:52:55', 2),
(3496, 2036, 16, 2, 3, '2019-11-04 15:52:56', 2),
(3497, 2037, 5, 1, 1, '2019-11-04 15:55:42', 2),
(3498, 2038, 5, 2, 0, '2019-11-04 16:06:40', 2),
(3499, 2038, 14, 1, 1, '2019-11-04 16:06:40', 2),
(3500, 2038, 16, 2, 0, '2019-11-04 16:06:40', 2),
(3501, 2040, 5, 2, 1, '2019-11-04 16:29:05', 2),
(3502, 2040, 16, 2, 2, '2019-11-04 16:29:07', 2),
(3503, 2043, 5, 2, 1, '2019-11-04 17:21:06', 2),
(3504, 2043, 16, 2, 2, '2019-11-04 17:21:30', 2),
(3505, 2046, 5, 1, 1, '2019-11-04 17:38:37', 2),
(3506, 2048, 5, 2, 1, '2019-11-04 17:48:02', 2),
(3507, 2048, 16, 2, 2, '2019-11-04 17:48:08', 2),
(3508, 2049, 14, 1, 1, '2019-11-04 17:48:56', 2),
(3509, 2050, 14, 1, 1, '2019-11-04 17:53:26', 2),
(3510, 2053, 5, 1, 1, '2019-11-04 19:03:19', 2),
(3511, 2054, 14, 1, 1, '2019-11-04 19:09:05', 2),
(3512, 2055, 5, 1, 1, '2019-11-04 19:09:18', 2),
(3513, 2055, 9, 1, 0, '2019-11-04 19:09:20', 2),
(3514, 2055, 14, 1, 1, '2019-11-04 19:09:23', 2),
(3515, 2056, 5, 2, 1, '2019-11-04 19:13:25', 2),
(3516, 2056, 16, 2, 2, '2019-11-04 19:13:25', 2),
(3518, 2057, 14, 1, 1, '2019-11-04 19:14:50', 2),
(3519, 2058, 14, 1, 1, '2019-11-04 19:15:08', 2),
(3520, 2059, 14, 1, 1, '2019-11-04 21:21:45', 2),
(3521, 2060, 5, 1, 1, '2019-11-04 21:40:37', 2),
(3522, 2061, 14, 1, 1, '2019-11-04 21:51:18', 2),
(3523, 2062, 5, 1, 1, '2019-11-04 23:10:23', 1),
(3524, 2063, 5, 1, 1, '2019-11-05 09:46:03', 2),
(3525, 2063, 14, 1, 1, '2019-11-05 09:46:17', 2),
(3526, 2064, 5, 2, 1, '2019-11-05 10:22:36', 2),
(3527, 2066, 5, 2, 1, '2019-11-05 10:34:42', 2),
(3528, 2066, 16, 2, 4, '2019-11-05 10:34:47', 2),
(3529, 2067, 5, 2, 1, '2019-11-05 10:37:09', 2),
(3530, 2067, 16, 2, 4, '2019-11-05 10:37:09', 2),
(3532, 2068, 5, 2, 1, '2019-11-05 10:41:59', 2),
(3533, 2068, 16, 2, 4, '2019-11-05 10:41:59', 2),
(3535, 2069, 14, 1, 1, '2019-11-05 10:44:21', 2),
(3536, 2070, 5, 1, 1, '2019-11-05 10:45:08', 2),
(3537, 2070, 14, 1, 1, '2019-11-05 10:45:17', 2),
(3538, 2071, 14, 1, 1, '2019-11-05 10:47:32', 2),
(3539, 2072, 14, 1, 1, '2019-11-05 11:04:57', 2),
(3540, 2073, 14, 1, 1, '2019-11-05 11:19:27', 2),
(3541, 2075, 5, 2, 1, '2019-11-05 11:38:39', 2),
(3542, 2075, 16, 2, 2, '2019-11-05 11:38:39', 2),
(3544, 2076, 5, 1, 1, '2019-11-05 11:52:38', 2),
(3545, 2078, 14, 1, 1, '2019-11-05 12:00:42', 2),
(3546, 2081, 14, 1, 1, '2019-11-05 12:24:15', 2),
(3547, 2082, 5, 2, 1, '2019-11-05 12:31:21', 2),
(3548, 2082, 16, 2, 2, '2019-11-05 12:31:22', 2),
(3549, 2082, 2, 1, 2, '2019-11-05 12:31:24', 2),
(3550, 2082, 7, 1, 2, '2019-11-05 12:31:54', 2),
(3551, 2083, 5, 1, 1, '2019-11-05 12:32:48', 2),
(3552, 2083, 14, 1, 1, '2019-11-05 12:32:54', 2),
(3553, 2086, 14, 1, 1, '2019-11-05 13:13:52', 2),
(3554, 2087, 14, 1, 1, '2019-11-05 13:16:09', 2),
(3555, 2088, 5, 1, 1, '2019-11-05 13:17:06', 2),
(3556, 2089, 5, 2, 1, '2019-11-05 13:28:29', 2),
(3557, 2089, 16, 2, 2, '2019-11-05 13:28:37', 2),
(3558, 2089, 7, 1, 2, '2019-11-05 13:28:42', 2),
(3559, 2090, 16, 2, 2, '2019-11-05 14:01:43', 2),
(3560, 2090, 5, 2, 1, '2019-11-05 14:02:32', 2),
(3561, 2092, 14, 1, 1, '2019-11-05 14:21:20', 2),
(3562, 2091, 5, 1, 1, '2019-11-05 14:21:59', 2),
(3563, 2091, 14, 1, 1, '2019-11-05 14:25:04', 2),
(3564, 2096, 5, 1, 1, '2019-11-05 16:48:47', 2),
(3565, 2097, 14, 1, 1, '2019-11-05 17:49:16', 2),
(3566, 2099, 14, 1, 1, '2019-11-05 18:48:14', 2),
(3567, 2100, 5, 1, 1, '2019-11-05 18:52:51', 2),
(3568, 2101, 5, 2, 1, '2019-11-05 18:54:49', 2),
(3569, 2101, 16, 2, 4, '2019-11-05 18:54:50', 2),
(3570, 2105, 14, 1, 1, '2019-11-05 23:06:27', 2),
(3571, 2109, 14, 1, 1, '2019-11-06 11:35:32', 2),
(3572, 2110, 18, 1, 0, '2019-11-06 11:41:23', 2),
(3573, 2110, 17, 1, 2, '2019-11-06 11:41:23', 2),
(3574, 2110, 14, 1, 1, '2019-11-06 11:41:47', 2),
(3575, 2111, 17, 1, 3, '2019-11-06 11:52:29', 2),
(3576, 2111, 26, 1, 1, '2019-11-06 11:52:40', 2),
(3577, 2111, 14, 1, 1, '2019-11-06 11:53:21', 2),
(3578, 2112, 17, 1, 3, '2019-11-06 12:43:20', 2),
(3579, 2112, 26, 1, 1, '2019-11-06 12:43:20', 2),
(3580, 2112, 14, 1, 1, '2019-11-06 12:43:20', 2),
(3581, 2113, 5, 1, 0, '2019-11-06 12:46:29', 2),
(3582, 2114, 5, 1, 1, '2019-11-06 13:09:12', 2),
(3583, 2115, 5, 2, 1, '2019-11-06 13:31:29', 2),
(3584, 2115, 16, 2, 2, '2019-11-06 13:31:32', 2),
(3585, 2116, 5, 1, 1, '2019-11-06 13:33:45', 2),
(3586, 2116, 14, 1, 1, '2019-11-06 13:33:47', 2),
(3587, 2119, 5, 1, 1, '2019-11-06 13:58:29', 2),
(3588, 2119, 14, 1, 1, '2019-11-06 13:58:29', 2);
INSERT INTO `servicios_vuelo_temp` (`id_sv`, `idtemp_sv`, `idservi_sv`, `tipo_sv`, `cantidad_sv`, `register`, `status`) VALUES
(3590, 2118, 5, 1, 1, '2019-11-06 14:01:10', 2),
(3591, 2120, 14, 1, 1, '2019-11-06 14:01:52', 2),
(3592, 2121, 5, 1, 1, '2019-11-06 14:22:11', 2),
(3593, 2121, 14, 1, 1, '2019-11-06 14:25:12', 2),
(3594, 2122, 5, 2, 1, '2019-11-06 14:51:06', 2),
(3595, 2122, 16, 2, 4, '2019-11-06 14:51:17', 2),
(3596, 2123, 5, 1, 1, '2019-11-06 15:29:03', 2),
(3597, 2123, 14, 1, 1, '2019-11-06 15:29:04', 2),
(3598, 2124, 5, 2, 1, '2019-11-06 16:17:53', 2),
(3599, 2124, 16, 2, 3, '2019-11-06 16:17:58', 2),
(3600, 2125, 5, 2, 1, '2019-11-06 16:18:58', 2),
(3601, 2125, 16, 2, 3, '2019-11-06 16:18:58', 2),
(3603, 2126, 5, 2, 1, '2019-11-06 16:26:50', 2),
(3604, 2126, 16, 2, 2, '2019-11-06 16:26:52', 2);

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
(60, 'REPORTES', 16, '2019-08-05 07:21:26', 1),
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
(87, 'REPROGRAMAR GRAL', 2, '2019-10-01 18:59:08', 1),
(88, 'CARGOS', 2, '2019-10-26 13:46:48', 1),
(89, 'DESCUENTOS', 2, '2019-10-26 13:46:48', 1),
(90, 'MONEDAS', 18, '2019-11-11 16:37:40', 1);

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
  `comentario_temp` mediumtext COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Comentarios',
  `otroscar1_temp` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Otros Cargos',
  `precio1_temp` decimal(11,2) DEFAULT NULL COMMENT 'Precio',
  `otroscar2_temp` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Otros CArgos',
  `precio2_temp` decimal(11,2) DEFAULT NULL COMMENT 'Precio',
  `tdescuento_temp` tinyint(4) DEFAULT NULL COMMENT 'Tipo de Descuento',
  `cantdescuento_temp` decimal(8,2) NOT NULL DEFAULT 0.00 COMMENT 'Cantidad de Desuento',
  `total_temp` double(10,2) DEFAULT 0.00 COMMENT 'Total',
  `piloto_temp` int(11) DEFAULT 0 COMMENT 'Piloto',
  `kg_temp` decimal(10,2) DEFAULT 0.00 COMMENT 'Peso',
  `tipopeso_temp` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Tipo Peso',
  `globo_temp` int(11) DEFAULT 0 COMMENT 'Globo',
  `hora_temp` time DEFAULT NULL COMMENT 'Hora de Vuelo',
  `idioma_temp` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Idioma',
  `comentarioint_temp` text COLLATE utf8_spanish_ci DEFAULT NULL COMMENT 'Comentarios Internos',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(4) NOT NULL DEFAULT 2 COMMENT 'Status'
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
(1006, 16, NULL, 'KELLY', 'PEREZ', 'kelly.perez@live.com', NULL, '573002084689', 35, 2, 0, 36, 1, '2019-09-18', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-09 15:24:23', 0),
(1007, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-10 15:48:18', 0),
(1008, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-10 16:34:27', 0),
(1009, 14, NULL, 'FLOR', 'GONZALEZ', 'sergio@volarenglobo.com.mx', NULL, '50671056755', 35, 2, 0, 37, 4, '2019-11-29', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD,DESPLIEGUE DE LONA', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-10 16:34:46', 0),
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
(1020, 14, NULL, 'SALVADOR ', 'HERNANDEZ', 'sergio@volarenglobo.com.mx', NULL, '5547072447', 35, 2, 0, 36, 1, '2019-09-14', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL, DESPLIEGUE DE LONA , TRANSPORT', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-11 15:36:22', 0),
(1021, 16, NULL, 'ISRAEL', 'GARCIA', 'toloigg@gmail.com', NULL, '5524303380', NULL, 2, 0, 36, 1, '2019-09-14', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 11:22:58', 0),
(1022, 14, NULL, 'CAROLINA', 'PEÃ‘A', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 12:27:44', 0),
(1023, 14, NULL, 'CLAUDIA', 'YOC', 'volarenglobo@yahoo.es', NULL, '50242100449', 35, 3, 0, 36, 1, '2019-09-15', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD,DESPLIEGUE DE LON', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 7197.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 12:29:05', 0),
(1024, 14, NULL, 'CECILIA', 'VAZQUEZ', 'volarenglobo@yahoo.es', NULL, '5512386502', 11, 15, 0, 36, 1, '2019-10-18', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 15 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD,DESPLIEGUE DE LO', NULL, NULL, NULL, NULL, 2, '4500.00', 34725.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 12:33:44', 0),
(1025, 14, NULL, 'LISSETTE', 'PERDOMO', 'volarenglobo@yahoo.es', NULL, '50255899206', 35, 3, 0, 36, 1, '2019-09-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE LOCAL, DESAYUNO BUFFET EN RESTAURANTE G', NULL, NULL, NULL, NULL, 2, '900.00', 7920.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 12:38:10', 4),
(1026, 14, NULL, 'YURIANA', 'QUERO', 'volarenglobo@yahoo.es', NULL, '5580056993', 11, 2, 0, 36, 4, '2019-09-30', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE LOCAL,SEGURO DE VIAJERO,BRINDIS CON VINO ', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 12:42:32', 0),
(1027, 16, NULL, 'RODRIGO', 'NOVELO', 'ronovelo2003@hotmail.com', NULL, '9811600715', NULL, 2, 0, NULL, 1, '2019-10-06', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, 2, '82.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 12:45:02', 8),
(1028, 16, NULL, 'LUISA FERNANDA', 'CANO', 'cotizacionesgirardottravel@gmail.com', NULL, '3204583383', NULL, 2, 0, NULL, 1, '2019-11-27', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 12:57:17', 0),
(1029, 16, NULL, 'GABRIEL', 'NUÃ‘EZ', 'lgnp3108@hotmail.com', NULL, '9931343692', NULL, 2, 0, 36, 1, '2019-09-14', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, NULL, '0.00', 5600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 13:09:31', 8),
(1030, 16, NULL, 'BERENICE', 'LOPEZ', 'moon_sun44@hotmail.com', NULL, '5525245058', NULL, 2, 0, 36, 1, '2019-09-16', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 13:41:53', 6),
(1031, 16, '1030', 'BERENICE', 'LOPEZ', 'moon_sun44@hotmail.com', NULL, '5525245058', NULL, 2, 0, 36, 1, '2019-09-16', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', 'DESAYUNO 3 PAX', '420.00', NULL, NULL, NULL, '0.00', 5020.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 13:56:54', 8),
(1032, 14, NULL, 'ERIKA', 'HURTADO', 'volarenglobo@yahoo.es', NULL, '4423419752', 11, 3, 0, 36, 1, '2019-09-15', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO,TRANSPORTE LOCAL , DESAYUNO BUFFET EN RESTAURA', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 7197.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-12 14:31:05', 8),
(1033, 16, NULL, 'CINDY', 'OVIEDO', 'cindy.oviedoo@hotmail.com', NULL, '8123504916', NULL, 2, 0, 36, 4, '2019-09-15', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la a', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-13 13:11:09', 6),
(1034, 16, '1033', 'CINDY', 'OVIEDO', 'cindy.oviedoo@hotmail.com', NULL, '8123504916', NULL, 2, 0, 36, 4, '2019-09-14', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la a', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-13 14:42:13', 8),
(1035, 16, NULL, 'ALEJANDRA', 'VACA', 'alejandra_vaca81@hotmail.com', NULL, '5530456145', NULL, 2, 0, 37, 1, '2019-09-20', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-13 14:55:31', 6),
(1036, 14, NULL, 'KARLA', 'MORALES', 'volarenglobo@yahoo.es', NULL, '50248731711', 35, 2, 0, 36, 1, '2019-10-11', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS  APROX. INCLUYE COFFE BREAK (CAFE,TE,GALLETAS  Y PAN) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO,TRANSP LOCAL , DESPLIEGUE DE LONA', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-13 15:17:26', 4),
(1037, 14, NULL, 'ARMANDO DE JESUS', 'ROJAS', 'volarenglobo@yahoo.es', NULL, '5613654574', 35, 2, 0, 38, 4, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE L', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-13 15:22:08', 0),
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
(1048, 14, '1013', 'EDSON', 'MANDUJANO', 'sergio@volarenglobo.com.mx', NULL, '51984710551', 35, 2, 0, NULL, 1, '2019-09-26', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BEAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PESONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD,DESPLIEGUE DE LONA .', NULL, NULL, NULL, NULL, NULL, '0.00', 5600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 12:55:19', 0),
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
(1062, 14, NULL, 'MARIO', 'GALVEZ', 'volarenglobo@yahoo.es', NULL, '6462941697', 35, 2, 0, 36, 1, '2019-09-22', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYU', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 15:22:33', 0),
(1063, 14, NULL, 'DAVID', 'GUADARRAMA', 'volarenglobo@yahoo.es', NULL, '6462941697', 35, 2, 0, 36, 1, '2019-09-22', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 42PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', 'TRANSPORTE ZOCALO', '700.00', 'DESAYUNOS', '198.00', NULL, '0.00', 7098.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 15:32:48', 0),
(1064, 14, NULL, 'LINA MARIA', 'ZAPATA', 'volarenglobo@yahoo.es', NULL, '5520380732', 11, 6, 0, 38, 1, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 6 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYU', 'DESAYUNOS', '594.00', NULL, NULL, NULL, '0.00', 14394.00, 0, '422.00', 1, 0, NULL, 1, NULL, '2019-09-17 15:42:00', 4),
(1065, 14, NULL, 'JAIME', 'ALCANTARA', 'volarenglobo@yahoo.es', NULL, '5549919393', 35, 3, 0, 36, 1, '2019-09-21', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', 'IVA', '1104.00', NULL, NULL, NULL, '0.00', 8004.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 16:55:02', 0),
(1066, 14, NULL, 'MILET MARISSELA', 'SALVATIERRA', 'volarenglobo@yahoo.es', NULL, '51981911669', 35, 2, 0, 38, 1, '2019-09-19', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLI', NULL, NULL, NULL, NULL, 2, '600.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 18:30:18', 0),
(1067, 14, NULL, 'ERIKA DENISSE ', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 18:38:14', 6),
(1068, 14, '1067', 'ERIKA DENISSE ', 'ANDRADE', 'volarenglobo@yahoo.es', NULL, '2221845901', 35, 2, 0, 36, 1, '2019-09-21', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYU', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 18:38:37', 0),
(1069, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 18:40:42', 0),
(1070, 14, NULL, 'CRISTINA', 'CONSTANZA', 'volarenglobo@yahoo.es', NULL, '50253353484', 35, 2, 0, 36, 1, '2019-10-15', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYU', NULL, NULL, NULL, NULL, 2, '600.00', 5280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 18:41:11', 0),
(1071, 14, NULL, 'HECTOR', 'VILLATORO', 'volarenglobo@yahoo.es', NULL, '429899963', 35, 2, 0, 36, 1, '2019-09-19', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYU', 'DESAYUNOS ADICIONALE', '280.00', 'TRANSPORTE ADICIONAL', '1000.00', 2, '600.00', 6560.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 18:44:32', 0),
(1072, 14, '1053', 'CHRISTIAN', 'MORALES', 'volarenglobo@yahoo.es', NULL, '5534594283', 35, 2, 0, 37, 4, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE L', NULL, NULL, NULL, NULL, NULL, '0.00', 8300.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-17 18:53:14', 8),
(1073, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 11:42:51', 0),
(1074, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 11:43:18', 0),
(1075, 16, NULL, 'FANY', 'RICARDO', 'licenf78@yahoo.com.mx', NULL, '5519071151', NULL, 1, 1, 38, 1, '2019-09-22', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, 2, '82.00', 4198.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 11:51:41', 8),
(1076, 16, NULL, 'AGUSTINA', 'SENA', 'agustina.sena@gmail.com', NULL, '5580484840', NULL, 2, 0, 36, 1, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, 2, '2.00', 5598.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 14:58:34', 8),
(1077, 9, NULL, 'MARTIN ALEJANDRO', 'SILVA CARDENAS', 'turismo@volarenglobo.com.mx', NULL, '5537048766', NULL, 2, 0, 36, 16, '2019-10-20', NULL, NULL, NULL, NULL, NULL, '2 pax privado bestday id 73529389-1', NULL, NULL, NULL, NULL, 2, '800.00', 5200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 16:31:58', 0),
(1078, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 16:34:53', 0),
(1079, 9, '1078', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 16:35:18', 0),
(1080, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 16:38:45', 6),
(1081, 16, '1080', 'SUSANA', 'SALAZAR', 'reserva@volarenglobo.com.mx', NULL, '5510998008', NULL, 2, 0, 38, 2, '2019-09-19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 16:39:25', 0),
(1082, 9, '1077', 'MARTIN ALEJANDRO', 'SILVA CARDENAS', 'turismo@volarenglobo.com.mx', NULL, '5537048766', NULL, 2, 0, 36, 16, '2019-10-20', NULL, NULL, NULL, NULL, NULL, '2 pax privado bestday id 73529389-1', NULL, NULL, NULL, NULL, 2, '800.00', 5200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 16:42:44', 4),
(1083, 14, NULL, 'FERNANDO', 'MADRIGAL', 'volarenglobo@yahoo.es', NULL, '50670701470', 35, 2, 0, 36, 1, '2019-09-22', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 17:05:37', 0),
(1084, 14, NULL, 'AXEL', 'MARTINEZ', 'volarenglobo@yahoo.es', NULL, '5532328480', 11, 2, 0, 36, 4, '2019-09-22', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE L', NULL, NULL, NULL, NULL, 2, '500.00', 6500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 17:08:35', 0),
(1085, 14, NULL, 'AXEL', 'MARTINEZ', 'volarenglobo@yahoo.es', NULL, '5532328480', 11, 2, 0, 36, 1, '2019-09-22', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 17:10:38', 0),
(1086, 14, NULL, 'ANGELA', 'GOMEZ', 'volarenglobo@yahoo.es', NULL, '573045305982', 35, 2, 0, 38, 1, '2019-09-21', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 17:13:56', 8),
(1087, 14, '1058', 'FUSHION', 'LAY', 'volarenglobo@yahoo.es', NULL, '573160732', 35, 2, 0, 36, 1, '2019-09-24', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, 2, '600.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 17:16:36', 6),
(1088, 14, '1087', 'FUSHION', 'LAY', 'volarenglobo@yahoo.es', NULL, '573160732', 35, 2, 0, 36, 1, '2019-09-24', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, 2, '600.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 17:20:57', 8),
(1089, 14, NULL, 'ALEJANDRO', 'CUAXOSPA', 'volarenglobo@yahoo.es', NULL, '5541947452', 11, 2, 0, 36, 4, '2019-09-22', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE L', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 18:00:09', 8),
(1090, 16, NULL, 'ANA', 'PACHECO', 'anapacheco1979@hotmail.com', NULL, '5532062243', 11, 2, 0, 38, 1, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 18:23:02', 8),
(1091, 14, NULL, 'ARMANDO ', 'PEREZ', 'volarenglobo@yahoo.es', NULL, '4431114232', 35, 2, 0, 36, 1, '2019-09-19', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYU', 'DESAYUNOS', '198.00', 'TRANSPORTE ZONA CENT', '700.00', NULL, '0.00', 5498.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 18:39:10', 6),
(1092, 14, '1091', 'ARMANDO ', 'PEREZ', 'volarenglobo@yahoo.es', NULL, '4431114232', 35, 2, 0, 36, 1, '2019-09-19', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYU', NULL, NULL, NULL, NULL, 2, '600.00', 5280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-18 18:55:42', 0),
(1093, 16, NULL, 'DANIEL', 'MARTINEZ', 'danieldyn@hotmail.com', NULL, '5611671200', NULL, 2, 0, 38, 1, '2019-09-21', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 11:15:46', 8),
(1094, 14, NULL, 'EYLEM', 'ARAUZ', 'volarenglobo@yahoo.es', NULL, '50766124237', 35, 3, 0, 36, 1, '2019-09-24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '900.00', 7920.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 12:55:31', 6),
(1095, 14, '1094', 'EYLEM', 'ARAUZ', 'volarenglobo@yahoo.es', NULL, '50766124237', 35, 3, 0, 36, 1, '2019-09-24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '900.00', 7920.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 12:59:04', 8),
(1096, 14, NULL, 'NADIA', 'MAYAAM', 'volarenglobo@yahoo.es', NULL, '52172258595262', 35, 7, 1, 38, 1, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 8 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLI', NULL, NULL, NULL, NULL, 2, '2141.00', 16779.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 13:03:18', 8),
(1097, 9, NULL, 'ELIZABETH', 'PEZZA', 'turismo@volarenglobo.com.mx', NULL, '99999999', 35, 2, 0, 36, 3, '2019-11-07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '340.00', 4560.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 13:45:27', 0),
(1098, 9, NULL, 'HERNAN DARIO', 'DIAZ SALAZAR', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 3, 0, 36, 3, '2019-10-05', NULL, NULL, NULL, NULL, NULL, '3 PAX COMPARTIDO  BESTDAY ID 73666355-1', NULL, NULL, NULL, NULL, NULL, '0.00', 5850.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 14:22:06', 4),
(1099, 9, NULL, 'JEIMY LORENA', 'MORALES', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, 37, 3, '2019-10-17', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO PRICE TRAVEL LOCATOR 12707825-1', NULL, NULL, NULL, NULL, 2, '500.00', 3400.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 14:36:16', 8),
(1100, 16, NULL, 'MONSE', 'ZAPATA', 'Zapata.montserrat@gmail.com', NULL, '7225126658', NULL, 4, 0, 38, 5, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la a', NULL, NULL, NULL, NULL, NULL, '0.00', 13000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 14:42:21', 6),
(1101, 9, NULL, 'MARK RICHARD', 'PRICE', 'turismo@volarenglobo.com.mx', NULL, '999999', 35, 4, 0, 36, 3, '2019-10-25', NULL, NULL, NULL, NULL, NULL, '4 PAX COMPARTIDO CON TRANSPORTE EXPEDIA ', NULL, NULL, NULL, NULL, 2, '200.00', 9600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 15:23:57', 8),
(1102, 9, NULL, 'JESUS ANTONIO', 'SERRANO', 'turismo@volarenglobo.com.mx', NULL, '999999', 35, 2, 0, 36, 3, '2019-10-04', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO EXPEDIA CON TRANSPORTE', NULL, NULL, NULL, NULL, 2, '100.00', 4800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 15:43:26', 4),
(1103, 14, NULL, 'GERMAN', 'MORENO', 'volarenglobo@yahoo.es', NULL, '57300200303', 35, 3, 0, 36, 1, '2019-10-30', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 43PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 8697.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 16:07:14', 0),
(1104, 9, NULL, 'UEMURA', 'HORUKA', 'turismo@volarenglobo.com.mx', NULL, '5555335133', NULL, 5, 0, NULL, 3, '2019-09-28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '50.00', 12200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 17:53:04', 0),
(1105, 9, NULL, 'KARINA ', NULL, 'turismo@volarenglobo.com.mx', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 18:10:02', 0),
(1106, 9, NULL, 'KARINA ', 'YEBRA OLIVARES', 'turismo@volarenglobo.com.mx', NULL, '5575086041', 11, 2, 0, 36, 3, '2019-09-21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 3900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 18:39:58', 4),
(1107, 9, NULL, 'ALEJANDRA', 'FLORES', 'turismo@volarenglobo.com.mx', NULL, '50499624394', 11, 4, 0, 36, 3, '2019-09-27', NULL, NULL, NULL, NULL, NULL, '4 PAX BOOKING CON TRANSPORTE', NULL, NULL, NULL, NULL, 2, '406.00', 9394.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-19 18:46:57', 4),
(1108, 14, '1056', 'CLAUDIA', 'PERDOMO', 'volarenglobo@yahoo.es', NULL, '573007386751', 11, 2, 0, 36, 1, '2019-10-18', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, 2, '600.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 11:05:16', 6),
(1109, 14, NULL, 'JOSHUA DANIEL', 'GONZALEZ', 'volarenglobo@yahoo.es', NULL, '5543231239', 11, 2, 0, 38, 1, '2019-10-15', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '138.00', 1, 0, NULL, 1, NULL, '2019-09-20 12:10:15', 7),
(1110, 9, NULL, 'UEMURA', 'HORUKA', 'turismo@volarenglobo.com.mx', NULL, '5555335133', 35, 5, 0, 36, 3, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 5 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nTRANSPORTE REDONDO CDMX-TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.\nDESAYUNO BUFFET.', NULL, NULL, NULL, NULL, 2, '550.00', 12400.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 12:12:18', 8),
(1111, 9, NULL, 'MARIA CRISTINA', 'ORJUELA GAMBA', 'turismo@volarenglobo.com.mx', NULL, '9981933660', 11, 1, 0, 36, 3, '2019-12-05', NULL, NULL, NULL, NULL, NULL, '1 PAX COMPARTIDO PRICE TRAVEL LOCATOR 12209035-1', NULL, NULL, NULL, NULL, 2, '250.00', 1700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 12:24:11', 4),
(1112, 14, NULL, 'ITZAYANA', 'NORIEGA', 'itzanoriega3005@gmail.com', NULL, '5536815845', 11, 2, 0, 36, 4, '2019-09-30', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESAYUNO EN RES', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 12:39:50', 0),
(1113, 14, NULL, 'ITZAYANA', 'NORIEGA', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 12:42:25', 6),
(1114, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 12:45:11', 0),
(1115, 14, '1113', 'ITZAYANA', 'NORIEGA', 'itzanoriega3005@gmail.com', NULL, '5536815845', 11, 2, 0, 36, 1, '2019-09-30', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYU', NULL, NULL, NULL, NULL, 2, '600.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 12:48:07', 0);
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
(1126, 9, NULL, 'LUISA', 'DE MOYA', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, 36, 3, '2019-10-20', NULL, NULL, NULL, NULL, NULL, '2  PAX COMPARTIDO BESTDAY ID 73839672-5', NULL, NULL, NULL, NULL, NULL, '0.00', 3900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-20 18:40:00', 0),
(1127, 9, NULL, 'JUAN', 'MIÃ‘ANO', 'turismo@volarenglobo.com.mx', NULL, '34699453648', 35, 4, 0, 36, 3, '2019-10-05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '659.00', 10901.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-21 12:09:57', 4),
(1128, 9, NULL, 'JUNCHENG', 'TANG', 'turismo@volarenglobo.com.mx', NULL, '34699453648', 35, 2, 0, 36, 3, '2019-12-25', NULL, NULL, NULL, NULL, NULL, '2 pax compartido con transporte expedia', NULL, NULL, NULL, NULL, 2, '100.00', 4800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-21 12:17:02', 4),
(1129, 9, NULL, 'ELIANA ', 'LINHARES PIVATTO', 'turismo@volarenglobo.com.mx', NULL, '5549999199290', 35, 2, 0, 36, 3, '2019-09-22', NULL, NULL, NULL, NULL, NULL, '2 pax booking con transporte', NULL, NULL, NULL, NULL, 2, '203.00', 4697.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-21 12:23:23', 4),
(1130, 9, NULL, 'WENDY', 'MURILLO BECERRIL', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, 38, 3, '2019-09-22', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO BESTDAY ID 73865987-1', NULL, NULL, NULL, NULL, NULL, '0.00', 3900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-21 12:32:19', 4),
(1131, 9, NULL, 'ADRIAN', 'CAMAYO', 'turismo@volarenglobo.com.mx', NULL, '5516123007', 11, 4, 0, 36, 3, '2019-09-22', NULL, NULL, NULL, NULL, NULL, '4 PAX COMPARTIDO WAYAK', NULL, NULL, NULL, NULL, 2, '600.00', 7200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-21 13:22:59', 4),
(1132, 14, NULL, 'GABY', 'VEGA', 'volarenglobo@yahoo.es', NULL, '5548702712', 11, 1, 1, 38, 1, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 ADULTO 1 MENOR, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLE\" DESAYUNO Y PASTEL PARA CUMPLEAÃ‘ERO', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4198.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 12:22:35', 8),
(1133, 16, NULL, 'MARIA EMILIA', 'TERRAZAS', 'mterrazas9121@gmail.com', NULL, '9562256019', NULL, 2, 0, 38, 4, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la actividad en TeotihuacÃ¡n\nâ€¢	Despliegue de lona FELIZ CUMPLE! \nâ€¢	Foto Impresa\nâ€¢	Coffee Break\n', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '150.00', 1, 0, NULL, 1, NULL, '2019-09-23 12:42:44', 4),
(1134, 9, NULL, 'JUAN MANUEL', 'BAUTISTA CORREA', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 1, 0, 36, 3, '2019-10-14', NULL, NULL, NULL, NULL, NULL, '1 PAX COMPARTIDO BESTDAY ID 73929099-1', NULL, NULL, NULL, NULL, 2, '310.00', 1640.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 13:14:00', 8),
(1135, 9, NULL, 'EMILIO', 'AMARILLO', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, 36, 3, '2019-10-27', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO BESTDAY ID 73929685-1', NULL, NULL, NULL, NULL, NULL, '0.00', 3900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 13:25:55', 0),
(1136, 9, NULL, 'RICHARD', 'TURISKY', 'turismo@volarenglobo.com.mx', NULL, '573202405215', 11, 2, 0, 36, 3, '2019-09-24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '800.00', 4100.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 13:50:38', 4),
(1137, 14, NULL, 'HENRY', 'BULLA TORO', 'volarenglobo@yahoo.es', NULL, '05723286448015', 35, 2, 0, 37, 1, '2019-09-24', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ ANIVERSARIO\" DESAYUNO BUFFET Y TRANSPORTE ZONA CENTRO CDMX-TEOTIHUACAN-CDMX', NULL, NULL, NULL, NULL, 2, '600.00', 5280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 13:57:49', 4),
(1138, 16, NULL, 'JEIMI Y FABIAN', 'GOMEZ', 'jeimgomez@uan.edu.co', NULL, '5548522320', NULL, 5, 0, 36, 2, '2019-09-24', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, TE, GALLETAS, PAN.\nâ€¢	DESPLIEGUE DE LONA\nâ€¢	DESAYUNO BUFFETE EN RESTAURANTE GRAN TEOCALLI.\nâ€¢	TRANSPORTE REDONDO CDMX ZÃ“CALO- TEOTIHUACÃN\n', NULL, NULL, NULL, NULL, 2, '700.00', 12500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 14:19:31', 0),
(1139, 16, NULL, 'NAYELLI', 'SIERRA', 'nayelli.sierra@hotmail.com', NULL, '5532356975', NULL, 2, 0, 38, 4, '2019-10-06', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la actividad en TeotihuacÃ¡n\nâ€¢	Despliegue de lona FELIZ CUMPLE! \nâ€¢	Foto Impresa\nâ€¢	Coffee Break\n', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 17:23:45', 6),
(1140, 14, NULL, 'RUDY', 'HUAMAN', 'rudy.huamanq@gmail.com', NULL, '51980314278', 35, 2, 0, 45, 4, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA DE ------- DESAYUNO EN RESTAURANTE GRAN TEOCALLI Y FOTOGRAFIA IMPRESA A ELEGIR.', 'ENTRADAS A ZONA ARQU', '150.00', NULL, NULL, NULL, '0.00', 9050.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 18:14:02', 0),
(1141, 14, NULL, 'RUDY', 'HUAMAN', 'volarenglobo@yahoo.es', NULL, '511980314278', 35, 2, 0, 45, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA DE \"TE AMO\" DESAYUNO BUFFET', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 18:16:33', 6),
(1142, 14, '1141', 'RUDY', 'HUAMAN', 'volarenglobo@yahoo.es', NULL, '511980314278', 35, 2, 0, 45, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA DE \"TE AMO\" DESAYUNO BUFFET', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 6848.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 18:38:48', 0),
(1143, 16, NULL, 'ABRAHAM', 'ESPINOZA', 'urielurias@hotmail.com', NULL, '6671255249', NULL, 2, 0, 38, 4, '2019-11-29', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la actividad en TeotihuacÃ¡n\nâ€¢	Despliegue de lona  Feliz Cumple!\nâ€¢	Foto Impresa\nâ€¢	Coffee Break\n', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 18:38:50', 6),
(1144, 14, NULL, 'SERGIO', 'COVALEDA', 'volarenglobo@yahoo.es', NULL, '573176568559', 35, 4, 0, 38, 1, '2019-12-31', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET Y PASTEL PARA CUMPLEAÃ‘ERO', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 9596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-23 18:54:06', 6),
(1145, 14, NULL, 'ANDREA', 'MOLINA', 'volarenglobo@yahoo.es', NULL, '4431341252', 18, 2, 0, 36, 1, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET', 'DESAYUNOS', '198.00', 'TRANSPORTE ZONA ZOCA', '700.00', NULL, '0.00', 5498.00, 0, '187.00', 1, 0, NULL, 1, NULL, '2019-09-24 10:48:00', 4),
(1146, 16, '1100', 'MONSE', 'ZAPATA', 'Zapata.montserrat@gmail.com', NULL, '7225126658', NULL, 5, 0, 38, 16, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la a', NULL, NULL, NULL, NULL, NULL, '0.00', 15000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 12:12:14', 8),
(1147, 14, NULL, 'KATIA', 'AGUILAR', 'volarenglobo@yahoo.es', NULL, '5535133683', 11, 2, 0, 37, 4, '2019-10-09', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA DE \"FELIZ ANIVERSARIO\" DESAYUNO EN RESTAURANTE GRAN TEOCALLI Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7300.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 12:35:46', 0),
(1148, 9, NULL, 'CESAR DAVID', 'REYES', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, 36, 16, '2019-10-11', NULL, NULL, NULL, NULL, NULL, '2 PAX PRIVADO BESTDAY ID 73933847-1', NULL, NULL, NULL, NULL, 2, '1200.00', 4800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 12:41:06', 0),
(1149, 9, NULL, 'RACHEL', 'DURANTE', 'turismo@volarenglobo.com.mx', NULL, '15168512348', 35, 2, 0, NULL, 3, '2019-10-06', NULL, NULL, NULL, NULL, NULL, '**** 2019-10-06 ****\nâ€ƒâ€ƒTicket Type: Traveler: 2 ()\nâ€ƒâ€ƒPrimary Redeemer: Rachel Durante, 15168512348, lidelrach06@aol.com\nâ€ƒâ€ƒValid Day: Oct 6, 2019\nâ€ƒâ€ƒItem: Teotihuacan Pyramids Hot-Air Balloon Flight / 5:00 AM, Flight with Transportation / 529019\nâ€ƒâ€ƒVoucher: 80178990, 80178991\nâ€ƒâ€ƒItinerary: 7477752030237\nâ€ƒâ€ƒCustomer Staying At: HistÃ³rico Central Mexico City; Bolivar No. 28, Mexico City, CDMX \n', NULL, NULL, NULL, NULL, 2, '100.00', 4800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 12:50:04', 4),
(1150, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 13:15:05', 0),
(1151, 14, NULL, 'MARU', 'FIGUEROA', 'volarenglobo@yahoo.es', NULL, '5544948848', 11, 2, 2, 36, 4, '2019-10-05', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 ADULTOS 2 MENORES , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE GRAN TEOCALLI Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, 2, '2.00', 10598.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 13:21:18', 8),
(1152, 14, NULL, 'MONICA', 'BERMEO', 'volarenglobo@yahoo.es', NULL, '57320987023', 35, 2, 2, 36, 1, '2019-10-12', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 ADULTOS 2 MENORES, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET ', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 8396.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 15:35:32', 0),
(1153, 16, NULL, 'DANIELA', 'PEREZ', 'chicdannnn@gmail.com', NULL, '5586764141', NULL, 2, 0, 37, 4, '2019-09-25', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la actividad en TeotihuacÃ¡n\nâ€¢	Despliegue de lona FELIZ ANIVERSARIO!\nâ€¢	Foto Impresa\nâ€¢	Coffee Break\n', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '135.00', 1, 0, NULL, 1, NULL, '2019-09-24 17:18:24', 4),
(1154, 9, NULL, 'JAVIER', 'NAVARRO NAVARRO', 'turismo@volarenglobo.com.mx', NULL, '5580284011', 11, 2, 0, 36, 3, '2019-10-29', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO CON TRANSPORTE TU EXPERIENCIA', NULL, NULL, NULL, NULL, 2, '200.00', 4700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 17:23:01', 0),
(1155, 9, NULL, 'GRUPO', 'NOVIEMBRE', 'turismo@volarenglobo.com.mx', NULL, '5580284011', 11, 7, 0, 36, 3, '2019-11-10', NULL, NULL, NULL, NULL, NULL, '7 PAX COMPARTIDO  GALLEGOS TOURS', NULL, NULL, NULL, NULL, 2, '70.00', 14560.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 17:40:50', 0),
(1156, 16, '1139', 'NAYELLI', 'SIERRA', 'nayelli.sierra@hotmail.com', NULL, '5532356975', NULL, 4, 0, 38, 1, '2019-10-05', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, TE, GALLETAS, PAN.\nâ€¢	DESPLIEGUE DE LONA FELIZ CUMPLE!\n\n', NULL, NULL, NULL, NULL, 2, '164.00', 9596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 18:19:15', 4),
(1157, 14, NULL, 'JESUS', 'TAPIA', 'volarenglobo@yahoo.es', NULL, '2227663931', 11, 2, 0, 39, 4, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD,DESPLIEGUE DE LONA DE \"TE QUIERES CASAR CONMIGO\" DESAYUNO EN RESTAURANTE GRAN TEOCALLI Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 10100.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-24 18:28:48', 0),
(1158, 14, NULL, 'GONZALO', 'MORAN', 'volarenglobo@yahoo.es', NULL, '5522161041', 11, 2, 0, 36, 4, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESAYUNO EN RESTAURANTE GRAN TEOCALLI Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7500.00, 0, '133.00', 1, 0, NULL, 1, NULL, '2019-09-25 12:59:20', 8),
(1159, 14, NULL, 'ANDREA', 'GUERRA', 'volarenglobo@yahoo.es', NULL, '50257041207', 35, 3, 0, 38, 1, '2019-09-26', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA  3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA,DESAYUNO Y TRANSPORTE REDONDO', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 8697.00, 0, '248.00', 1, 0, NULL, 1, NULL, '2019-09-25 13:06:16', 7),
(1160, 16, NULL, 'CARLOS', 'GAMA', 'carl_yop@yahoo.com.mx', NULL, '4434100433', NULL, 10, 0, NULL, 2, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, TE, GALLETAS, PAN.\nâ€¢	DESPLIEGUE DE LONA\nâ€¢	DESAYUNO BUFFETE EN RESTAURANTE GRAN TEOCALLI.\n', NULL, NULL, NULL, NULL, NULL, '0.00', 21400.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-25 14:00:52', 6),
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
(1176, 18, '1172', 'ALBERTO', 'MEZA', 'volarenglobo@yahoo.es', NULL, '50688120525', 35, 8, 0, 43, 4, '2019-10-25', NULL, NULL, NULL, NULL, NULL, 'INCLUYE:\n- VUELO PANORAMICO SOBRE EL VALLE DE TEOTIHUACAN. \n- COFFEE BREAK. \n- BRINDIS CON VINO ESPUMOSO. \n- CERTIFICADO PERSONALIZADO. \n- SEGURO DE VIAJERO. \n- DESAYUNO TIPO BUFFET. \n- FOTO IMPRESA.', NULL, NULL, NULL, NULL, 2, '2600.00', 25600.00, 0, '590.00', 1, 0, NULL, 1, NULL, '2019-09-26 12:48:27', 6),
(1177, 16, '1173', 'CARLOS', 'CISNEROS', 'jasonquiroz74@gmail.com ', NULL, '5615100221', NULL, 2, 0, 39, 4, '2019-10-16', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo/ Brindis en vuelo con vino espumoso Freixenet/ Certificado de vuelo/ Seguro viajero/ Desayuno tipo Buffet / TransportaciÃ³n local / Despliegue de lona Â¿Te quieres casar conmigo?/ Foto Impresa', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 12:58:54', 6),
(1178, 16, '1177', 'CARLOS', 'CISNEROS', 'jasonquiroz74@gmail.com ', NULL, '5615100221', NULL, 2, 0, 39, 4, '2019-10-16', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo/ Brindis en vuelo con vino espumoso Freixenet/ Certificado de vuelo/ Seguro viajero/ Desayuno tipo Buffet / TransportaciÃ³n local / Despliegue de lona Â¿Te quieres casar conmigo?/ Foto Impresa', 'DESAYUNO 7 PAX', '980.00', NULL, NULL, NULL, '0.00', 7980.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 14:03:11', 6),
(1179, 9, NULL, 'VERONICA', 'JIMENEZ', 'turismo@volarenglobo.com.mx', NULL, '5532401181', 11, 7, 0, 36, 3, '2019-09-29', NULL, NULL, NULL, NULL, NULL, '7 PAX COMPARTIDO FULL', NULL, NULL, NULL, NULL, 2, '162.25', 19392.75, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 15:05:15', 0),
(1180, 9, NULL, 'MONICA', NULL, 'turismo@volarenglobo.com.mx', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 15:27:03', 0),
(1181, 9, NULL, 'MONICA', 'GIRON', 'turismo@volarenglobo.com.mx', NULL, '5532408382', 11, 4, 0, NULL, 3, '2019-09-28', NULL, NULL, NULL, NULL, NULL, '4 PAX COMPARTIDO BOOKING FULL', NULL, NULL, NULL, NULL, 2, '659.00', 10901.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 16:44:18', 0),
(1182, 9, NULL, 'IVAN DARIO', 'DIAZ BELTARN', 'turismo@volarenglobo.com.mx', NULL, '55104461', 11, 1, 0, 36, 3, '2019-09-28', NULL, NULL, NULL, NULL, NULL, '1 PAX COMPARTIDO UNIVERSE TRAVEL CON TRANSPORTE', NULL, NULL, NULL, NULL, 2, '100.00', 2350.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 16:53:42', 7),
(1183, 9, NULL, 'CARINA', 'SALAZAR', 'turismo@volarenglobo.com.mx', NULL, '58634953', 11, 4, 0, 36, 3, '2019-09-28', NULL, NULL, NULL, NULL, NULL, '4 PAX COMPARTIDO BOOKING FULL', NULL, NULL, NULL, NULL, 2, '659.00', 10901.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 17:15:11', 0),
(1184, 9, NULL, 'ERIKA', 'LLIMA', 'turismo@volarenglobo.com.mx', NULL, '5534502546', 11, 7, 0, 36, 3, '2019-09-28', NULL, NULL, NULL, NULL, NULL, '7 PAX COMPARTIDO BOOKING FULL', NULL, NULL, NULL, NULL, 2, '162.25', 19392.75, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 17:23:20', 0),
(1185, 9, NULL, 'SULY', 'ORELLANA', 'turismo@volarenglobo.com.mx', NULL, '996343118', 11, 3, 0, 36, 3, '2019-10-05', NULL, NULL, NULL, NULL, NULL, '3 PAX COMPARTIDO BOOKING CON TRANSPORTE', NULL, NULL, NULL, NULL, 2, '304.00', 7046.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 17:28:25', 4),
(1186, 9, NULL, 'FRANCO', 'LAINEZ', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, 36, 16, '2019-10-07', NULL, NULL, NULL, NULL, NULL, '2 PAX PRIVADO  BESTDAY ID 73946246-1', NULL, NULL, NULL, NULL, 2, '1200.00', 4800.00, 0, '150.00', 1, 19, '06:30:00', 1, NULL, '2019-09-26 17:35:41', 4),
(1187, 14, NULL, 'LORENA ', 'VILLARREAL', 'volarenglobo@yahoo.es', NULL, '593998725623', 35, 2, 0, 36, 1, '2019-09-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '135.00', 1, 0, NULL, 1, NULL, '2019-09-26 18:15:08', 7),
(1188, 16, NULL, 'ANGELA', 'FARIAS', 'Fariasguiang@prodigy.net.mx', NULL, '5519514113', NULL, 4, 0, 36, 2, '2019-09-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet (excepto bÃ¡sico)/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 18:26:20', 6),
(1189, 14, NULL, 'CLAUDIA', 'PARRA', 'volarenglobo@yahoo.es', NULL, '16469059712', 35, 8, 0, 38, 1, '2019-09-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 8 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO Y PASTEL PARA CUMPLEAÃ‘ERO', 'TRANSPORTE RED CENTR', '2800.00', NULL, NULL, 2, '2400.00', 19920.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 18:36:58', 6),
(1190, 16, NULL, 'DANIEL ', 'MARTINEZ', 'reserva@volarenglobo.com.mx', NULL, '5510998008', NULL, 5, 0, 36, 1, '2019-09-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet (excepto bÃ¡sico)/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 14000.00, 0, '400.00', 1, 0, NULL, 1, NULL, '2019-09-26 18:36:59', 4),
(1191, 9, NULL, 'GEORGE', 'HIDALGO', 'turismo@volarenglobo.com.mx', NULL, '593986812600', 11, 2, 0, 36, 1, '2019-09-27', NULL, NULL, NULL, NULL, NULL, '2 PAX INTERCAMBIO INSTAGRAM', NULL, NULL, NULL, NULL, 2, '1200.00', 4400.00, 0, '146.00', 1, 0, NULL, 1, NULL, '2019-09-26 19:00:24', 4),
(1192, 14, '1189', 'CLAUDIA', 'PARRA', 'volarenglobo@yahoo.es', NULL, '16469059712', 35, 8, 0, 38, 1, '2019-09-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 8 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO Y PASTEL PARA CUMPLEAÃ‘ERO', 'TRANSPORTE RED CENTR', '2800.00', NULL, NULL, 2, '2400.00', 19920.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 19:00:25', 0),
(1193, 14, NULL, 'CLAUDIA', 'PARRA', 'volarenglobo@yahoo.es', NULL, '16469059712', 35, 8, 0, 38, 1, '2019-09-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 8 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA DE FELIZ CUMPLEAÃ‘OS, DESAYUNO Y PASTEL PARA CUMPLEAÃ‘ERO', 'TRANSPORTE RED CENTR', '2800.00', NULL, NULL, 2, '2400.00', 19920.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 19:03:38', 6),
(1195, 16, '1188', 'ANGELA', 'FARIAS', 'Fariasguiang@prodigy.net.mx', NULL, '5519514113', NULL, 3, 0, 36, 2, '2019-09-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet (excepto bÃ¡sico)/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 6000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 19:04:39', 0),
(1196, 14, '1193', 'CLAUDIA', 'PARRA', 'volarenglobo@yahoo.es', NULL, '16469059712', 35, 8, 0, 38, 1, '2019-09-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 8 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA DE FELIZ CUMPLEAÃ‘OS, DESAYUNO Y PASTEL PARA CUMPLEAÃ‘ERO', 'TRANSPORTE RED CENTR', '2800.00', NULL, NULL, 2, '2400.00', 19920.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-26 20:01:32', 7),
(1197, 16, NULL, 'JUAN CARLOS', 'VIDAL', 'jvidal@aurainteractiva.com', NULL, '5579064844', NULL, 2, 0, 38, 4, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo/ Brindis en vuelo con vino espumoso Freixenet/ Certificado de vuelo/ Seguro viajero/ Desayuno tipo Buffet / TransportaciÃ³n local / Despliegue de lona Feliz Aniversario! / Foto Impresa/ Coffee Break', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '150.00', 1, 0, NULL, 1, NULL, '2019-09-27 10:50:24', 4),
(1198, 16, NULL, 'BLANCA', 'MAYOR', 'reserva@volarenglobo.com.mx', NULL, '573113676286', NULL, 2, 0, 36, 1, '2019-09-30', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet (excepto bÃ¡sico)/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 5600.00, 0, '140.00', 1, 0, NULL, 1, NULL, '2019-09-27 11:08:01', 8),
(1199, 16, '1143', 'ABRAHAM', 'ESPINOZA', 'urielurias@hotmail.com', NULL, '6671255249', NULL, 2, 0, 38, 4, '2019-11-29', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo\nâ€¢	Brindis en vuelo con vino espumoso Freixenet\nâ€¢	Certificado de vuelo\nâ€¢	Seguro viajero\nâ€¢	Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)\nâ€¢	TransportaciÃ³n local durante la actividad en TeotihuacÃ¡n\nâ€¢	Despliegue de lona  Feliz Cumple!\nâ€¢	Foto Impresa\nâ€¢	Coffee Break\n', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 11:12:23', 8),
(1200, 14, NULL, 'HORACIO', 'OCHOA', 'volarenglobo@yahoo.es', NULL, '5216621437600', 35, 2, 0, 36, 1, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO.', 'TRANSPORTE ZOCALO', '700.00', NULL, NULL, NULL, '0.00', 5300.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 11:41:19', 6),
(1201, 14, '1200', 'HORACIO', 'OCHOA', 'volarenglobo@yahoo.es', NULL, '5216621437600', 35, 2, 0, 36, 1, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO.', 'TRANSPORTE ZOCALO', '700.00', NULL, NULL, NULL, '0.00', 5300.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 11:43:50', 0),
(1202, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 11:56:28', 6),
(1203, 14, '1202', 'HORACIO', 'OCHOA', 'ventas@volarenglobo.com.mx', NULL, '5216621437600', 35, 2, 0, 36, 1, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE , GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD.', 'TRANSPORTE ZOCALO', '700.00', NULL, NULL, NULL, '0.00', 5300.00, 0, '188.00', 1, 0, NULL, 1, NULL, '2019-09-27 11:58:40', 6),
(1204, 14, NULL, 'CARLA CRISTINA', 'DIXON', 'volarenglobo@yahoo.es', NULL, '50763284728', 35, 2, 0, 36, 1, '2019-10-19', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 12:12:17', 6),
(1205, 14, NULL, 'MARIA', 'LUJAN ANDREETTA', 'volarenglobo@yahoo.es', NULL, '541165152125', 35, 2, 0, 36, 4, '2019-11-21', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE GRAN TEOCALLI Y FOTOGRAFIA IMPRESA A ELEGIR.', 'TRANSPORTE RED COYOA', '1400.00', NULL, NULL, NULL, '0.00', 8400.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 12:31:09', 8),
(1206, 14, NULL, 'ANDREA', 'GUTIERREZ', 'volarenglobo@yahoo.es', NULL, '521987138394', 35, 2, 0, 36, 4, '2019-10-03', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE GRAN TEOCALLI Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '122.00', 1, 0, NULL, 1, NULL, '2019-09-27 12:36:01', 8),
(1207, 11, NULL, 'ADOLFO', 'BENITEZ OLEA', 'selenesanz@hotmail.com', '2227436631', '2481451498', 23, 2, 0, 38, 1, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFEE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD\n', NULL, NULL, NULL, NULL, 2, '1000.00', 3600.00, 0, '145.00', 1, 0, NULL, 1, NULL, '2019-09-27 12:46:58', 7),
(1208, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 12:49:03', 0),
(1209, 14, '1171', 'CATE', '.', 'sartoria2@gmail.com', NULL, '1281902276', 35, 7, 0, 73, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'TRADITIONAL SHARED FLIGHT,  HOT AIRE BALLON 7 PAX FOR 45 MINUTES APROX, TOAST WITH SPARKLIN FREIXENET WINE,PERSONALIZED FLIGHT CERTIFICATE,TRANSPORTATION DURING THE ACTIVITY (CHECK IN AREA-TAKE OFF AREA AND LANDING SITE CHECK IN AREA) , TRAVEL INSURANCE, TRANSPORTATION HOTEL - TEOTIHUACAN- HOTEL , TRADITIONAL BREAKFAST IN RESTAURANT GRAN TEOCALLI (BUFFET SERVICE). ', NULL, NULL, NULL, NULL, 2, '2100.00', 18480.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-09-27 12:49:56', 6),
(1210, 16, NULL, 'LUIS', 'OLARTE', 'info@condesaamatlan.com.mx', NULL, '5540681630', NULL, 2, 0, 36, 2, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet (excepto bÃ¡sico)/ Seguro viajero/ Coffee break/transporte redondo ZÃ³calo', NULL, NULL, NULL, NULL, NULL, '0.00', 5000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 13:04:15', 0),
(1211, 16, NULL, 'GERARDO', 'MARTINEZ', 'gerrarmtz@gmail.com', NULL, '5571228493', NULL, 8, 0, NULL, 2, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break ', NULL, NULL, NULL, NULL, NULL, '0.00', 16000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 13:49:52', 4),
(1212, 14, '1203', 'HORACIO', 'OCHOA', 'ventas@volarenglobo.com.mx', NULL, '5216621437600', 35, 2, 0, 36, 1, '2019-09-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE , GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD.', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '188.00', 1, 0, NULL, 1, NULL, '2019-09-27 15:20:11', 4),
(1213, 9, '1124', 'KENNY', 'VEL', 'turismo@volarenglobo.com.mx', NULL, '5523022634', 17, 2, 0, 39, 4, '2019-09-29', NULL, NULL, NULL, NULL, NULL, 'CONKETA PEDIDO 4087 Â°VUELO PRIVADO 2 PAX  SOBRE EL VALLE DE TEOTIHUACAN Â°COFFEE BREAK ANTES DE VUELO Â°SEGURO DE VIAJERO Â°DESPLIEGUE DE LONA Â¿TE QUIERES CASAR CONMIGO? Â°BRINDIS CON VINO ESPUMOSO Â°CERTIFICADO PERSONALIZADO Â°DESAYUNO BUFFET Â°FOTO IMPRESA A ELEGIR\n', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '105.00', 1, 0, NULL, 1, NULL, '2019-09-27 15:35:52', 0),
(1214, 9, NULL, 'KEVIN', 'DOMINGUEZ', 'turismo@volarenglobo.com.mx', NULL, '5545037062', 11, 5, 0, 36, 3, '2019-09-29', NULL, NULL, NULL, NULL, NULL, '5 PAX FULL BOOKING', NULL, NULL, NULL, NULL, 2, '838.00', 13387.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 17:45:24', 6),
(1215, 9, NULL, 'GONZALO ALBERTO', 'SABOGAL MORENO', 'turismo@volarenglobo.com.mx', NULL, '3017114695', 11, 2, 0, NULL, 3, '2019-09-28', NULL, NULL, NULL, NULL, NULL, '2 PAX TU EXPERIENCIA', NULL, NULL, NULL, NULL, 2, '200.00', 4700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 18:45:49', 4),
(1216, 9, NULL, 'ERIKA ', 'MURILLO', 'turismo@volarenglobo.com.mx', NULL, '88587774', 11, 2, 0, 36, 3, '2019-09-28', NULL, NULL, NULL, NULL, NULL, '2 PAX TU EXPERIENCIA', NULL, NULL, NULL, NULL, 2, '200.00', 4700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 18:54:08', 4),
(1217, 9, NULL, 'FRANCIS', 'ESCURA', 'turismo@volarenglobo.com.mx', NULL, '33608040757', 35, 2, 0, 36, 3, '2019-09-28', NULL, NULL, NULL, NULL, NULL, '2 PAX FULL BOOKING', NULL, NULL, NULL, NULL, 2, '225.00', 6005.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-27 18:57:57', 4),
(1218, 16, NULL, 'STEPHANNIE', 'GUTIERREZ', 'ann_star3@hotmail.com', NULL, '5530731480', NULL, 2, 0, 38, 1, '2019-10-11', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona FELIZ CUMPLE!', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '150.00', 1, 0, NULL, 1, NULL, '2019-09-27 19:02:23', 7),
(1219, 11, NULL, 'YERIKENDY', 'CORDOBA PIÃ‘ON', 'yericor@hotmail.com', '5543432304', '5526897235', 17, 2, 0, 36, 1, '2019-10-06', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nINCKUYE 1 CORTESIA SRG', NULL, NULL, NULL, NULL, 2, '2300.00', 2300.00, 0, '130.00', 1, 0, NULL, 1, NULL, '2019-09-29 19:54:32', 8),
(1220, 14, NULL, 'GABRIELA', 'SEQUEIRA', 'volarenglobo@yahoo.es', NULL, '50685800714', 35, 2, 0, 38, 1, '2019-10-25', NULL, NULL, NULL, NULL, NULL, NULL, 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 6848.00, 0, '130.00', 1, 0, NULL, 1, NULL, '2019-09-30 12:50:40', 8),
(1221, 14, NULL, 'DABEGY', 'NOVOA', 'volarenglobo@yahoo.es', NULL, '5528147078', 35, 1, 0, 36, 1, '2019-10-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE,TE, GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD,DESAYUNO BUFFET ', NULL, NULL, NULL, NULL, NULL, '0.00', 2300.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-30 12:52:35', 6),
(1222, 16, NULL, 'JUAN', 'BUSTAMANTE', 'juan.bustamante@loreal.com', NULL, '5510998008', NULL, 62, 0, NULL, 2, '2019-10-14', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 132680.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-30 14:05:41', 0),
(1223, 16, NULL, 'WILLIAMS', 'UGALDE', 'williams1098@hotmail.com', NULL, '50686182027', NULL, 4, 0, 36, 1, '2019-10-24', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona /', NULL, NULL, NULL, NULL, 2, '164.00', 11596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-30 14:19:16', 6),
(1224, 14, NULL, 'CECILIA', 'TREVIÃ‘O', 'volarenglobo@yahoo.es', NULL, '5543569704', 11, 3, 0, 36, 1, '0019-02-21', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 7197.00, 0, '190.00', 1, 0, NULL, 1, 'Ejemplo', '2019-09-30 14:33:27', 4);
INSERT INTO `temp_volar` (`id_temp`, `idusu_temp`, `clave_temp`, `nombre_temp`, `apellidos_temp`, `mail_temp`, `telfijo_temp`, `telcelular_temp`, `procedencia_temp`, `pasajerosa_temp`, `pasajerosn_temp`, `motivo_temp`, `tipo_temp`, `fechavuelo_temp`, `tarifa_temp`, `hotel_temp`, `habitacion_temp`, `checkin_temp`, `checkout_temp`, `comentario_temp`, `otroscar1_temp`, `precio1_temp`, `otroscar2_temp`, `precio2_temp`, `tdescuento_temp`, `cantdescuento_temp`, `total_temp`, `piloto_temp`, `kg_temp`, `tipopeso_temp`, `globo_temp`, `hora_temp`, `idioma_temp`, `comentarioint_temp`, `register`, `status`) VALUES
(1225, 16, NULL, 'BRENDA BEATRIZ', 'RODRIGUEZ', 'bren_rovergara@hotmail.com', NULL, '5569319660', NULL, 7, 0, 36, 1, '2019-10-06', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / Despliegue de lona', NULL, NULL, NULL, NULL, NULL, '0.00', 16100.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-30 14:53:41', 6),
(1226, 9, '1214', 'KEVIN', 'DOMINGUEZ', 'turismo@volarenglobo.com.mx', NULL, '5545037062', 11, 5, 0, 36, 3, '2019-09-29', NULL, NULL, NULL, NULL, NULL, '5 PAX FULL BOOKING', NULL, NULL, NULL, NULL, 2, '838.00', 13387.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-30 17:33:31', 0),
(1227, 9, '1226', 'KEVIN', 'DOMINGUEZ', 'turismo@volarenglobo.com.mx', NULL, '5545037062', 11, 5, 0, 36, 3, '2019-10-10', NULL, NULL, NULL, NULL, NULL, '5 PAX FULL BOOKING', NULL, NULL, NULL, NULL, 2, '838.00', 13387.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-30 17:36:55', 0),
(1228, 16, NULL, 'MEGHA', 'SINGH', 'meghasingh29@gmail.com', NULL, '5510998008', NULL, 2, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Flight insurance\n- Coffee break\n- Flight of 45 min. to 1 hour\n- Sparkling wine toast\n- Flight certificate\n- Buffet breakfast', NULL, NULL, NULL, NULL, 2, '82.00', 5848.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-09-30 17:42:25', 6),
(1229, 9, NULL, 'KEVIN ', 'DOMINGUEZ', 'turismo@volarenglobo.com.mx', NULL, '5545037062', 11, 5, 0, 36, 3, '2019-10-13', NULL, NULL, NULL, NULL, NULL, '5 PAX COMPARTIDO BOOKING FULL', NULL, NULL, NULL, NULL, 2, '838.00', 13387.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-30 17:46:19', 0),
(1230, 9, NULL, 'KAREN ', 'ACHIGE', 'turismo@volarenglobo.com.mx', NULL, '5543192994', 11, 1, 0, 36, 3, '2019-10-01', NULL, NULL, NULL, NULL, NULL, '1 PAX COMPARTIDO TURISKY', NULL, NULL, NULL, NULL, 2, '400.00', 2050.00, 0, '55.00', 1, 0, NULL, 1, NULL, '2019-09-30 18:38:22', 4),
(1231, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-09-30 18:41:39', 0),
(1232, 9, NULL, 'JUAN', 'ZAPATA', 'turismo@volarenglobo.com.mx', NULL, '5520594131', 11, 4, 0, 36, 3, '2019-10-01', NULL, NULL, NULL, NULL, NULL, '4 PAX COMPARTIDO TURISKY CON TRANSPORTE', NULL, NULL, NULL, NULL, 2, '1600.00', 8200.00, 0, '267.00', 1, 0, NULL, 1, NULL, '2019-09-30 18:44:55', 4),
(1233, 16, '1228', 'MEGHA', 'SINGH', 'meghasingh29@gmail.com', NULL, '5510998008', NULL, 2, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Flight insurance\n- Coffee break\n- Flight of 45 min. to 1 hour\n- Sparkling wine toast\n- Flight certificate\n- Buffet breakfast', NULL, NULL, NULL, NULL, 2, '82.00', 6848.00, 0, '130.00', 1, 0, NULL, 2, NULL, '2019-09-30 19:05:15', 8),
(1234, 16, '1223', 'WILLIAMS', 'UGALDE', 'williams1098@hotmail.com', NULL, '50686182027', NULL, 4, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona /', NULL, NULL, NULL, NULL, 2, '164.00', 11596.00, 0, '291.00', 1, 0, NULL, 1, NULL, '2019-10-01 14:16:37', 8),
(1235, 14, NULL, 'REGINA', 'PICHARDINI', 'volarenglobo@yahoo.es', NULL, '5591081825', 35, 2, 0, 37, 4, '2019-10-06', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA DE ANIVERSARIO, DESAYUNO EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '110.00', 1, 0, NULL, 1, NULL, '2019-10-01 14:25:49', 4),
(1236, 16, '1225', 'BRENDA BEATRIZ', 'RODRIGUEZ', 'bren_rovergara@hotmail.com', NULL, '5569319660', NULL, 6, 0, 36, 1, '2019-10-06', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / Despliegue de lona', NULL, NULL, NULL, NULL, NULL, '0.00', 13800.00, 0, '460.00', 1, 0, NULL, 1, NULL, '2019-10-01 23:00:01', 8),
(1237, 11, NULL, 'CHRISTIN', 'WAGENHAUS', 'christin.wagenhaus@yahoo.de', '491743735003', '4499113679', 2, 5, 0, 38, 1, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nLONA DE FC \n', NULL, NULL, NULL, NULL, NULL, '0.00', 11500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-02 09:57:27', 6),
(1238, 11, '1237', 'CHRISTIN', 'WAGENHAUS', 'christin_wagenhaus@yahoo.de', '491743735003', '4499113679', 2, 5, 0, 38, 1, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nLONA DE FC \n', NULL, NULL, NULL, NULL, NULL, '0.00', 11500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-02 10:04:48', 6),
(1239, 16, NULL, 'GINA', 'ALVAREZ', 'ginalvarez@hotmail.com', NULL, '5540553688', NULL, 2, 0, 36, 1, '2019-10-05', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-02 14:40:25', 6),
(1240, 16, NULL, 'SHARON', 'MUÃ‘OZ', 'sharon.imr@gmail.com', NULL, '573016024972', NULL, 3, 0, 36, 2, '2019-10-03', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', 'PESO EXTRA', '100.00', NULL, NULL, NULL, '0.00', 6520.00, 0, '248.00', 1, 0, NULL, 1, NULL, '2019-10-02 15:00:26', 8),
(1241, 16, NULL, 'ADRIANA', 'BETANCOURT', 'adry_bero@yahoo.com', NULL, '5518441082', NULL, 1, 1, NULL, 1, '2019-10-04', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break /', NULL, NULL, NULL, NULL, NULL, '0.00', 4000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-02 17:10:35', 6),
(1242, 16, '1241', 'ADRIANA', 'BETANCOURT', 'adry_bero@yahoo.com', NULL, '5518441082', NULL, 1, 1, NULL, 1, '2019-10-04', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break /', NULL, NULL, NULL, NULL, 2, '82.00', 4198.00, 0, '105.00', 1, 0, NULL, 1, NULL, '2019-10-02 17:14:28', 8),
(1243, 16, NULL, 'MIGUEL', 'ROSSY', 'rossymiguel1@gmail.com', NULL, '17876025041', NULL, 2, 0, NULL, 1, '2019-10-07', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, 2, '82.00', 5798.00, 0, '142.00', 1, 0, NULL, 1, NULL, '2019-10-02 17:17:11', 4),
(1244, 11, NULL, 'ABRIL', 'ESTEBAN', 'abrilstefany@hotmail.com', NULL, '573002518298', 35, 4, 0, 36, 1, '2019-10-10', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFEE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD', NULL, NULL, NULL, NULL, 2, '1200.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-02 17:20:32', 6),
(1245, 9, NULL, 'MARIA CRISTINA', 'FELICIANO APONTE', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 1, 0, 36, 3, '2019-10-03', NULL, NULL, NULL, NULL, NULL, '1 PAX COMPARTIDO BESTDAY ID 73915099-1', NULL, NULL, NULL, NULL, 2, '310.00', 1640.00, 0, '52.00', 1, 0, NULL, 1, NULL, '2019-10-02 18:34:48', 4),
(1246, 9, NULL, 'DILAN DANIEL', 'ARIAS', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 3, 0, 36, 3, '2019-09-04', NULL, NULL, NULL, NULL, NULL, '3 PAX COMPARTIDO PRICE TRAVEL LOCATOR 12976634-1', NULL, NULL, NULL, NULL, 2, '750.00', 5100.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-02 18:49:27', 4),
(1247, 11, '1244', 'ABRIL', 'ESTEBAN', 'abrilstefany@hotmail.com', NULL, '573002518298', 35, 4, 0, 36, 1, '2019-10-10', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFEE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD', NULL, NULL, NULL, NULL, 2, '1200.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-02 21:58:19', 6),
(1248, 11, '1238', 'CHRISTIN', 'WAGENHAUS', 'christin_wagenhaus@yahoo.de', '491743735003', '4499113679', 2, 6, 0, 38, 1, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nLONA DE FC \n', NULL, NULL, NULL, NULL, NULL, '0.00', 13800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-02 22:30:04', 7),
(1249, 14, NULL, 'ULISES', 'MARTINEZ', 'volarenglobo@yahoo.es', NULL, '5528902935', 11, 2, 0, 36, 1, '2019-10-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', NULL, NULL, NULL, NULL, 2, '600.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-03 11:24:23', 4),
(1250, 9, NULL, 'SAMGNING', 'SUN', 'turismo@volarenglobo.com.mx', NULL, '16476756008', 11, 2, 0, NULL, 3, '2019-10-04', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO CON TRANSPORTE EXPEDIA', NULL, NULL, NULL, NULL, 2, '100.00', 4800.00, 0, '100.00', 1, 0, NULL, 1, NULL, '2019-10-03 13:36:19', 4),
(1251, 14, NULL, 'ESTIVEN', 'ACUÃ‘A', 'volarenglobo@yahoo.es', NULL, '50686610890', 35, 3, 0, 36, 1, '2019-10-09', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET Y TRANSPORTE CDXM-TEOTIHUACAN-CDMX ', NULL, NULL, NULL, NULL, 2, '900.00', 7920.00, 0, '198.00', 1, 0, NULL, 1, NULL, '2019-10-03 13:38:38', 4),
(1252, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-03 13:42:23', 0),
(1253, 9, NULL, 'ROBERTO', 'NOVEY', 'turismo@volarenglobo.com.mx', NULL, '5532258091', 35, 10, 0, NULL, 3, '2019-10-04', NULL, NULL, NULL, NULL, NULL, '10 PAX COMPARTIDO NOMADIC', NULL, NULL, NULL, NULL, 2, '600.00', 20300.00, 0, '717.00', 1, 0, NULL, 1, NULL, '2019-10-03 13:46:00', 7),
(1254, 16, NULL, 'MAGALI', 'BARVADILLO', 'magalibarvadillo@gmail.com', NULL, '5587861916', NULL, 2, 2, 43, 4, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo/ Brindis en vuelo con vino espumoso Freixenet y jugo para menores/ Certificado de vuelo/ Seguro viajero/ Desayuno tipo Buffet / TransportaciÃ³n local / Despliegue de lona FELIZ VUELO / Foto Impresa/ Coffee Break', NULL, NULL, NULL, NULL, NULL, '0.00', 10600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-03 14:20:23', 0),
(1255, 9, NULL, 'CLEIDE', 'NAKASHIMA', 'turismo@volarenglobo.com.mx', NULL, '5567913896', 35, 18, 0, 36, 3, '2019-10-04', NULL, NULL, NULL, NULL, NULL, '18 pax compartido universe travel con 20 desayunos', 'DESAYUNOS EXTRA', '260.00', NULL, NULL, 2, '180.00', 37700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-03 14:31:04', 0),
(1256, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-03 14:41:14', 6),
(1257, 14, '1256', 'HANNALY', 'DROEGE', 'volarenglobo@yahoo.es', NULL, '50241055666', 35, 2, 0, 36, 1, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD,DESAYUNO BUFFET , TRANSPORTE CDMX-TEOTIHUACAN-CDMX ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-03 14:41:27', 8),
(1258, 9, NULL, 'JIANG', 'ZHIMIN', 'turismo@volarenglobo.com.mx', NULL, '5582217356', 35, 2, 0, 36, 3, '2019-10-04', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO FULL KAYTRIP', NULL, NULL, NULL, NULL, 2, '230.00', 6000.00, 0, '130.00', 1, 0, NULL, 1, NULL, '2019-10-03 14:48:00', 4),
(1259, 16, NULL, 'PAULA', 'VALLEJO', 'Paulavallejo@hotmail.com', NULL, '573167429304', NULL, 3, 0, NULL, 1, '2019-10-12', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet/ Seguro viajero/ Coffee break / Despliegue de lona ', NULL, NULL, NULL, NULL, 2, '123.00', 8697.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-03 14:55:28', 0),
(1260, 11, NULL, 'ALEJANDRA', 'BOTERO', 'Alejandraboteromesa@gmail.com', '5568282913', '5522615862', 11, 5, 3, 43, 1, '2019-10-04', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFEE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nDESCUENTO ESPECIAL AMIGA ALE BOTERO', NULL, NULL, NULL, NULL, 2, '6600.00', 10000.00, 0, '420.00', 1, 0, NULL, 1, NULL, '2019-10-03 14:57:26', 8),
(1261, 16, '1239', 'GINA', 'ALVAREZ', 'ginalvarez@hotmail.com', NULL, '5540553688', NULL, 2, 0, 36, 1, '2019-10-05', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-04 09:26:45', 0),
(1262, 14, NULL, 'ERIKA', 'MENDEZ', 'volarenglobo@yahoo.es', NULL, '573143228805', 35, 2, 0, 36, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET, Y TRANSPORTE REDONDO', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '130.00', 1, 0, NULL, 1, NULL, '2019-10-04 14:38:06', 8),
(1263, 14, NULL, 'SHARON', 'SOLIS', 'volarenglobo@yahoo.es', NULL, '50683743212', 35, 4, 0, 38, 1, '2019-10-31', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA FELIZ CUMPLEAÃ‘OS, DESAYUNOS ,TRANSP REDONDO', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 11596.00, 0, '360.00', 1, 0, NULL, 1, NULL, '2019-10-04 14:51:42', 8),
(1264, 14, '1221', 'DABEGY', 'NOVOA', 'volarenglobo@yahoo.es', NULL, '5528147078', 35, 2, 0, 36, 1, '2019-10-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE,TE, GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD,DESAYUNO BUFFET ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-04 18:13:50', 4),
(1265, 9, NULL, 'SHU', 'XU', 'turismo@volarenglobo.com.mx', NULL, '8618501685586', 35, 2, 0, 36, 3, '2019-10-06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '100.00', 4800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-05 15:21:29', 4),
(1266, 9, NULL, 'FERNANDO ', 'MENDOZA', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, 36, 3, '2019-10-07', NULL, NULL, NULL, NULL, NULL, '2 PAX BESTDAY ID 73970884-1', NULL, NULL, NULL, NULL, 2, '620.00', 3280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-05 15:24:50', 4),
(1267, 9, NULL, 'TANG', 'ZIXUAN', 'turismo@volarenglobo.com.mx', NULL, '5582217356', 35, 2, 0, 36, 3, '2019-10-07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '230.00', 6000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-05 15:32:22', 4),
(1268, 9, NULL, 'LUCIA ', 'ALONSO', 'turismo@volarenglobo.com.mx', NULL, '5539876913', 35, 7, 0, 36, 3, '2019-10-06', NULL, NULL, NULL, NULL, NULL, '7 PAX FULL BOOKING', NULL, NULL, NULL, NULL, 2, '162.00', 19393.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-05 15:36:45', 4),
(1269, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-05 15:39:50', 0),
(1270, 9, NULL, 'MA', 'ZEHUA', 'turismo@volarenglobo.com.mx', NULL, '5582217356', 35, 2, 0, 36, 3, '2019-10-06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '230.00', 6000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-05 15:41:40', 4),
(1271, 9, NULL, 'EUGENIA', 'ROMERO', 'turismo@volarenglobo.com.mx', NULL, '5951102285', 35, 8, 0, 36, 3, '2019-10-06', NULL, NULL, NULL, NULL, NULL, '8 PAX FULL BOOKING', NULL, NULL, NULL, NULL, 2, '265.00', 21955.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-05 15:44:42', 4),
(1272, 9, NULL, 'HECTOR ', 'GIL', 'turismo@volarenglobo.com.mx', NULL, '5510411697', 11, 3, 0, 36, 3, '2019-10-07', NULL, NULL, NULL, NULL, NULL, 'GRAN TEOCALLI', NULL, NULL, NULL, NULL, 2, '600.00', 5250.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-05 15:48:23', 4),
(1273, 11, NULL, 'DANIELA', 'GOMEZ', 'Dannygomez111@hotmail.com', NULL, '573017123918', 35, 2, 0, 36, 1, '2019-10-25', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nINCLUYE TRANSPORTE IDA Y VUELTA CDMX', NULL, NULL, NULL, NULL, 2, '600.00', 5000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-06 22:07:11', 6),
(1274, 11, '1247', 'ABRIL', 'ESTEBAN', 'abrilstefany@hotmail.com', NULL, '573002518298', 35, 4, 0, 36, 1, '2019-10-10', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFEE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nDESAYUNOS BUFETTE EN RESTAURANTE GRAN TEOCALLI', NULL, NULL, NULL, NULL, 2, '1200.00', 8560.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-07 13:54:58', 6),
(1275, 16, '1160', 'CARLOS', 'GAMA', 'carl_yop@yahoo.com.mx', NULL, '4434100433', NULL, 12, 2, NULL, 2, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, TE, GALLETAS, PAN.\nâ€¢	DESPLIEGUE DE LONA\nâ€¢	DESAYUNO BUFFETE EN RESTAURANTE GRAN TEOCALLI.\n', NULL, NULL, NULL, NULL, 2, '82.00', 29278.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-07 14:17:25', 6),
(1280, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-08 12:58:08', 0),
(1281, 14, NULL, 'FLORA', 'MONTERO', 'volarenglobo@yahoo.es', NULL, '50683028841', 35, 2, 0, 38, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA FELIZ CUMPLEAÃ‘OS , PASTEL CUMPLEÃ‘ERO,TRANSPORTE REDONDO', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-08 13:20:33', 8),
(1282, 14, NULL, 'ESTHER', 'SALAS', 'volarenglobo@yahoo.es', NULL, '50687634255', 35, 4, 0, 36, 1, '2019-10-11', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET ', NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-08 13:24:31', 0),
(1283, 11, '1274', 'ABRIL', 'ESTEBAN', 'abrilstefany@hotmail.com', '573002518298', '573002518298', 35, 4, 0, 36, 1, '2019-10-11', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFEE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nDESAYUNOS BUFETTE EN RESTAURANTE GRAN TEOCALLI', NULL, NULL, NULL, NULL, 2, '1200.00', 8560.00, 0, '260.00', 1, 0, NULL, 1, NULL, '2019-10-08 14:10:26', 4),
(1284, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-08 14:26:53', 0),
(1285, 14, NULL, 'ESTHER', 'SALAS', 'volarenglobo@yahoo.es', NULL, '50687634255', 35, 4, 0, 36, 1, '2019-10-11', NULL, 1, 20, '2019-10-10', '2019-10-11', 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA,DESAYUNO BUFFET ', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 9596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-08 15:24:43', 6),
(1286, 14, NULL, 'CAMILO', 'SIERRA', 'volarenglobo@yahoo.es', NULL, '5570991245', 35, 4, 0, 36, 4, '2019-10-12', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 4 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE GRAN TEOCALLI Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, 2, '1000.00', 15000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-08 15:44:45', 8),
(1287, 14, NULL, 'VIRGINIA', 'SANDOVAL', 'volarenglobo@yahoo.es', NULL, '5541823033', 35, 2, 0, 38, 1, '2019-11-09', NULL, NULL, NULL, '2019-11-08', '2019-11-09', 'VUELO COMPARTIDO PARA 2PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA FELIZ CUMPLEAÃ‘OS,DESAYUNO BUFFET', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-09 13:51:32', 6),
(1288, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-09 14:01:28', 0),
(1289, 14, '1287', 'VIRGINIA', 'SANDOVAL', 'volarenglobo@yahoo.es', NULL, '5541823033', 35, 2, 0, 38, 1, '2019-11-16', NULL, 1, 25, '2019-11-08', '2019-11-09', 'VUELO COMPARTIDO PARA 2PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA FELIZ CUMPLEAÃ‘OS,DESAYUNO BUFFET', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 6098.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-09 14:23:33', 8),
(1291, 16, NULL, 'FRANCISCO', 'ISAY', 'reserva@volarenglobo.com.mx', NULL, '9841200221', NULL, 4, 0, 39, 5, '2019-10-26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 13000.00, 0, '320.00', 1, 0, NULL, 1, 'â€¢	Vuelo en globo exclusivo/ Brindis en vuelo con vino espumoso Freixenet/ Certificado de vuelo/ Seguro viajero/ Desayuno tipo Buffet / TransportaciÃ³n local / Despliegue de lona Â¿Te quieres casar conmigo?/ Foto Impresa/ Coffee Break', '2019-10-10 11:16:01', 8),
(1292, 14, NULL, 'CLARA ESTEFANIA', 'BRAVO', 'volarenglobo@yahoo.es', NULL, '5530396750', 35, 2, 0, 37, 4, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA , DESAYUNO EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '144.00', 1, 0, NULL, 1, NULL, '2019-10-10 11:51:32', 7),
(1293, 14, NULL, 'FERNANDO', 'RODRIGUEZ', 'volarenglobo@yahoo.es', NULL, '5560836026', 11, 2, 0, 38, 1, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA, DESAYUNO BUFFET', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '118.00', 1, 0, NULL, 1, NULL, '2019-10-10 11:55:43', 7),
(1294, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-10 12:05:52', 0),
(1295, 14, '1285', 'ESTHER', 'SALAS', 'volarenglobo@yahoo.es', NULL, '50687634255', 35, 4, 0, 36, 1, '2019-10-11', NULL, 1, 20, '2019-10-10', '2019-10-11', 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA,DESAYUNO BUFFET ', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 11246.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-10 12:12:43', 4),
(1296, 16, NULL, 'JOHANA', 'HERNANDEZ', 'reserva@volarenglobo.com.mx', NULL, '59323824192', NULL, 3, 0, 38, 1, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona FELIZ CUMPLE!', NULL, NULL, NULL, NULL, NULL, '0.00', 9320.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-10 12:18:47', 8),
(1297, 14, NULL, 'ROXANA', 'CHINCHILLA', 'volarenglobo@yahoo.es', NULL, '50670757527', 35, 2, 0, 36, 1, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET, TRANSPORTE REDONDO', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-10 16:06:07', 8),
(1298, 9, NULL, 'FRANKIE', 'PAEZ', 'turismo@volarenglobo.com.mx', NULL, '593960269088', 35, 2, 0, NULL, 3, '2019-10-11', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO TURISKY', NULL, NULL, NULL, NULL, 2, '800.00', 4100.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-10 18:13:28', 4),
(1299, 9, NULL, 'AILYN', 'ECHEVERRY', 'turismo@volarenglobo.com.mx', NULL, '5510411697', 11, 5, 0, 36, 3, '2019-10-11', NULL, NULL, NULL, NULL, NULL, '5 PAX COMPARTIDO GRAN TEOCALLI', NULL, NULL, NULL, NULL, 2, '1000.00', 8750.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-10 18:21:06', 4),
(1300, 9, NULL, 'SR', 'JINDAL', 'turismo@volarenglobo.com.mx', NULL, '5535258091', 35, 2, 0, 36, 16, '2019-10-11', NULL, NULL, NULL, NULL, NULL, '2 PAX PRIVADO NOMADIC', NULL, NULL, NULL, NULL, NULL, '0.00', 6000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-10 18:27:11', 7),
(1301, 9, NULL, 'ALIA ', 'HASBUN', 'turismo@volarenglobo.com.mx', NULL, '50377972228', 35, 2, 0, 36, 3, '2019-10-11', NULL, NULL, NULL, NULL, NULL, '2 PAX EXPEDIA SOLO VUELO', NULL, NULL, NULL, NULL, NULL, '0.00', 3900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-10 18:38:23', 4),
(1302, 9, NULL, 'PAOLA ', 'AGUDELO', 'turismo@volarenglobo.com.mx', NULL, '16464983609', 11, 3, 0, 36, 3, '2019-10-11', NULL, NULL, NULL, NULL, NULL, '3 PAX COMPARTIDO EXPEDIA', NULL, NULL, NULL, NULL, NULL, '0.00', 5850.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-10 18:42:05', 4),
(1303, 16, NULL, 'JUAN DIEGO', 'ASTURIAS', 'reserva@volarenglobo.com.mx', NULL, '50254144387', NULL, 10, 0, 36, 2, '2019-10-12', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona FELIZ VUELO', 'TRANSPORTE REDONDO 1', '3500.00', 'CARGO POR PESO EXTRA', '2255.00', NULL, '0.00', 25755.00, 0, '877.00', 1, 0, NULL, 1, NULL, '2019-10-11 12:42:37', 7),
(1304, 16, NULL, 'GERMAN ', 'RUA', 'reserva@volarenglobo.com.mx', NULL, '2225053140', NULL, 2, 0, 39, 4, '2019-10-12', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo/ Brindis en vuelo con vino espumoso Freixenet/ Certificado de vuelo/ Seguro viajero/ Desayuno tipo Buffet / TransportaciÃ³n local / Despliegue de lona Â¿Te quieres casar conmigo?/ Foto Impresa/ Coffee Break', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '145.00', 1, 0, NULL, 1, NULL, '2019-10-11 12:54:36', 7),
(1305, 16, NULL, 'CATALINA', 'REYES', 'reserva@volarenglobo.com.mx', NULL, '5579294275', NULL, 2, 2, 36, 4, '2019-10-12', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo/ Brindis en vuelo con vino espumoso Freixenet/ Certificado de vuelo/ Seguro viajero/ Desayuno tipo Buffet / TransportaciÃ³n local / Despliegue de lona FELIZ VUELO / Foto Impresa/ Coffee Break', NULL, NULL, NULL, NULL, 2, '2.00', 10598.00, 0, '175.00', 1, 0, NULL, 1, NULL, '2019-10-11 13:01:29', 7),
(1306, 16, NULL, 'ANGEL', 'SANCHEZ', 'reserva@volarenglobo.com.mx', NULL, '5520982520', NULL, 2, 0, 38, 1, '2019-10-12', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja / Seguro viajero/ Coffee break / Despliegue de lona ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '125.00', 1, 0, NULL, 1, 'El pax lleva su propia lona y botella para brindar con su hija, favor de pedirla para el despliegue', '2019-10-11 13:11:01', 7),
(1307, 14, NULL, 'MARTHA', 'FLORES', 'volarenglobo@yahoo.es', NULL, '5214425983335', 11, 2, 1, 36, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 ADULTOS 1 MENOR , VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET Y TRANSPORTE REDONDO (CENTRO)', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 8097.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-11 13:24:30', 8),
(1308, 14, NULL, 'FERNANDO', 'RODRIGUEZ', 'volarenglobo@yahoo.es', NULL, '5560836026', 11, 2, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-11 13:30:23', 0),
(1309, 16, NULL, 'MARTIN', 'MONTIEL', 'volarenglobo@yahoo.es', NULL, '5575110019', NULL, 2, 0, 38, 1, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona FELIZ CUMPLE', NULL, NULL, NULL, NULL, 2, '82.00', 5098.00, 0, '140.00', 1, 0, NULL, 1, 'INCLUYE RAMO DE ROSAS Y DESAYUNOS', '2019-10-11 13:34:27', 7),
(1310, 14, NULL, 'LUZ ERIKA', 'GONZALEZ', 'volarenglobo@yahoo.es', NULL, '5513894679', 35, 2, 1, 36, 1, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 ADULTOS 1 MENOR , VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET ', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 7097.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-11 13:34:56', 7),
(1311, 16, NULL, 'ARACELI', 'BRAVO', 'aracelibravoc93@gmail.com', NULL, '5536680941', NULL, 2, 0, 38, 4, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo/ Brindis en vuelo con vino espumoso Freixenet/ Certificado de vuelo/ Seguro viajero/ Desayuno tipo Buffet / TransportaciÃ³n local / Despliegue de lona FELIZ CUMPLE / Foto Impresa/ Coffbreak', 'TRANSPORTE REDONDO Z', '700.00', NULL, NULL, NULL, '0.00', 7700.00, 0, '135.00', 1, 0, NULL, 1, NULL, '2019-10-11 13:41:48', 7),
(1312, 16, NULL, 'SEBASTIAN ', 'CORDERO', 'volarenglobo@yahoo.es', NULL, '50688820411', NULL, 2, 0, 36, 1, '2019-10-12', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet  / Seguro viajero/ Coffee break / Despliegue de lona', NULL, NULL, NULL, NULL, 2, '82.00', 5798.00, 0, '142.00', 1, 0, NULL, 1, NULL, '2019-10-11 13:53:15', 4),
(1313, 16, NULL, 'ALFREDO', 'ACOSTA', 'volarenglobo@yahoo.es', NULL, '5528556005', NULL, 3, 1, 38, 1, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona FELIZ CUMPLE!', NULL, NULL, NULL, NULL, 2, '164.00', 8996.00, 0, '275.00', 1, 0, NULL, 1, NULL, '2019-10-11 14:37:29', 8),
(1314, 14, NULL, 'OSCAR', 'GODINEZ', 'volarenglobo@yahoo.es', NULL, '5523270422', 35, 2, 0, 36, 1, '2019-10-12', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-11 14:49:07', 7),
(1315, 14, NULL, 'MARIBEL ', 'GONZALEZ', 'volarenglobo@yahoo.es', NULL, '15155200210', 35, 8, 0, NULL, 1, '2019-10-12', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 8 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA FELIZ CUMPLEAÃ‘OS , DESAYUNO Y PASTEL PARA CUMPLEAÃ‘ERO', 'DESAYUNOS', '792.00', NULL, NULL, 2, '2399.00', 16793.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-11 15:05:43', 7),
(1316, 16, NULL, 'MONICA', 'MORENO', 'Monicamariamp@gmail.com', NULL, '573143608808', NULL, 11, 0, 36, 2, '2019-10-25', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', 'TRANSPORTE REDONDO 1', '3500.00', NULL, NULL, NULL, '0.00', 27040.00, 0, '0.00', 1, 0, NULL, 1, 'va una persona en silla de ruedas ligera ', '2019-10-11 15:11:22', 8),
(1317, 14, NULL, 'ALMA LORENA', 'GALAVIZ', 'volarenglobo@yahoo.es', NULL, '5513387379', 35, 2, 0, 38, 1, '2019-10-12', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA FELIZ CUMPLEAÃ‘OS, DESAYUNO BUFFET  Y PASTEL PARA CUMPLEAÃ‘ERO, GUIA, ENTRADAS A ZONA ARQUEOLOGICA ', 'DESAYUNOS ', '198.00', 'ENTRADA A ZONA ARQUE', '150.00', NULL, '0.00', 5848.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-11 15:19:26', 8),
(1318, 14, NULL, 'JULIAN ', 'FERNANDEZ', 'volarenglobo@yahoo.es', NULL, '573204643252', 35, 2, 0, 36, 4, '2019-10-14', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESAYUNO EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 10000.00, 0, '138.00', 1, 0, NULL, 1, 'pago por error $10.500.00 por conekta, favor de regresar  $500.00 pesos en sitio', '2019-10-11 15:53:16', 7),
(1319, 9, NULL, 'JESUS', 'REYES ROBLES', 'turismo@volarenglobo.com.mx', NULL, '5577108350', 17, 2, 1, NULL, 3, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 3 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN. SEGURO DE VIAJERO. COFFEE BREAK ANTES DEL VUELO. BRINDIS CON VINO ESPUMOSO Y JUGO PARA EL MENOR. CERTIFICADO PERSONALIZADO. ', 'AJUSTE', '250.00', NULL, NULL, NULL, '0.00', 5850.00, 0, '159.00', 1, 0, NULL, 1, NULL, '2019-10-11 16:27:58', 4),
(1320, 16, NULL, 'ALEJANDRO', 'LOPEZ', 'Alopezdelap@yahoo.com.mx', NULL, '5527373545', NULL, 2, 0, NULL, 4, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'â€¢	Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '150.00', 1, 0, NULL, 1, 'INCLUYE DESAYUNOS Y FOTO IMPRESA/ FIRMAR CARTA DE PAGO POR CONEKTA PEDIDO 4135 /PEDIR TARJETA DE CREDITO  E IDENTIFICACIÃ“N', '2019-10-11 16:40:03', 7),
(1321, 16, NULL, 'ANGELA', 'MARTINEZ', 'ange_la69@hotmail.com', NULL, '5544882746', NULL, 3, 0, NULL, 1, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, 2, '123.00', 7197.00, 0, '160.00', 1, 0, NULL, 1, 'INCLUYE DESAYUNOS/ FIRMAR CARTA DE PAGO CON TC/ PEDIR ID/ PAGA CON TARJETA BANCOMER PUEDE SER A MESES SIN COMISION DEL 4%/ SE ENVIA TICKET DE PAGO EN TERMINAL DE OFICINA', '2019-10-11 16:54:43', 7),
(1322, 9, NULL, 'MOLLY', 'BERNSTEIN', 'turismo@volarenglobo.com.mx', NULL, '4365444', 11, 2, 0, 36, 3, '2019-10-11', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO SOLO VUELO TRIPADVISOR', NULL, NULL, NULL, NULL, NULL, '0.00', 3900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-11 17:07:15', 8),
(1323, 9, NULL, 'MOLLY', 'BERNSTEIN', 'turismo@volarenglobo.com.mx', NULL, '4365444', 11, 2, 0, 36, 3, '2019-10-12', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO TRIPAVDISOR', NULL, NULL, NULL, NULL, NULL, '0.00', 3900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-11 17:31:37', 7),
(1324, 9, NULL, 'AMAPOLA', 'HERNANDEZ', 'turismo@volarenglobo.com.mx', NULL, '5951162669', 11, 8, 0, 36, 3, '2019-10-12', NULL, NULL, NULL, NULL, NULL, '8 PAX BOOKING FULL', NULL, NULL, NULL, NULL, 2, '265.00', 21955.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-11 17:40:34', 7),
(1325, 9, NULL, 'EDWIN OSWALDO', 'GAMBOA', 'turismo@volarenglobo.com.mx', NULL, '5516123007', 11, 2, 0, NULL, 3, '2019-10-12', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO WAYAK', NULL, NULL, NULL, NULL, 2, '530.00', 5700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-11 17:48:05', 8),
(1326, 9, NULL, 'EZRA', 'FLORES', 'turismo@volarenglobo.com.mx', NULL, '5549107054', 11, 6, 0, 36, 3, '2019-10-12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 11700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-11 17:55:03', 7),
(1327, 9, NULL, 'HERNALDO', 'SALAZAR', 'turismo@volarenglobo.com.mx', NULL, '573155070810', 35, 2, 0, 36, 1, '2019-10-13', NULL, NULL, NULL, NULL, NULL, '2 PAX CONEKTA PED 3940', NULL, NULL, NULL, NULL, 2, '82.00', 6698.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-11 18:00:03', 7),
(1328, 9, NULL, 'FATIMA', 'PEREZGALAN', 'turismo@volarenglobo.com.mx', NULL, '5575078771', 35, 10, 0, 36, 3, '2019-10-13', NULL, NULL, NULL, NULL, NULL, '10 PAX COMPARTIDO BOOKING', NULL, NULL, NULL, NULL, 2, '775.00', 26775.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-11 18:10:16', 8),
(1329, 9, NULL, 'MABELY', 'SAUCEDO', 'turismo@volarenglobo.com.mx', NULL, '5541397659', 35, 8, 0, 36, 3, '2019-10-13', NULL, NULL, NULL, NULL, NULL, '/8 PAX FULL BOOKING', NULL, NULL, NULL, NULL, 2, '265.00', 21955.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-11 18:14:27', 8),
(1330, 9, NULL, 'RODOLFO', 'DAVILA', 'turismo@volarenglobo.com.mx', NULL, '99999', NULL, 8, 0, NULL, 3, '2019-10-13', NULL, NULL, NULL, NULL, NULL, '8 PAX ESPIRITU AVENTURERO', NULL, NULL, NULL, NULL, NULL, '0.00', 15600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-11 18:20:02', 7),
(1331, 16, NULL, 'MISSAEL', 'OLMEDO', 'ricardo.olmedo@live.com.mx', NULL, '5544200675', NULL, 3, 0, 38, 2, '2019-10-12', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / Despliegue de lona FELIZ CUMPLE!', NULL, NULL, NULL, NULL, NULL, '0.00', 6000.00, 0, '0.00', 1, 0, NULL, 1, 'vuelo bÃ¡sico, precio GuÃ­a Missael Olmedo', '2019-10-11 18:22:53', 6),
(1332, 9, NULL, 'ZHENG', 'BOQING', 'turismo@volarenglobo.com.mx', NULL, '5582217356', 35, 4, 0, 36, 3, '2019-10-14', NULL, NULL, NULL, NULL, NULL, '4 PAX COMPARTIDO KAYTRIP', NULL, NULL, NULL, NULL, 2, '460.00', 11100.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-11 18:28:18', 7),
(1333, 9, NULL, 'DANIEL', 'CIFUENTES', 'turismo@volarenglobo.com.mx', NULL, '5510411697', NULL, 2, 0, 36, 3, '2019-10-14', NULL, NULL, NULL, NULL, NULL, '2 PAX GRAN TEOCALLI', NULL, NULL, NULL, NULL, 2, '400.00', 3500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-11 18:33:54', 8),
(1334, 16, NULL, 'SANTIAGO', 'LECUE', 'esplecue@hotmail.com', NULL, '5549005820', NULL, 1, 0, NULL, 1, '2019-10-12', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, 2, '41.00', 2899.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-11 18:57:01', 6),
(1335, 16, '1334', 'SANTIAGO', 'LECUE', 'eselecue@hotmail.com', NULL, '5549005820', NULL, 1, 0, NULL, 1, '2019-10-12', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, 2, '41.00', 2899.00, 0, '70.00', 1, 0, NULL, 1, NULL, '2019-10-11 19:02:27', 7),
(1336, 16, NULL, 'CARMENZA', 'TARACHI', 'luisfeolarte@gmail.com', NULL, '573107833093', NULL, 4, 0, NULL, 1, '2019-10-14', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\n', NULL, NULL, NULL, NULL, NULL, '0.00', 9200.00, 0, '280.00', 1, 0, NULL, 1, NULL, '2019-10-12 11:42:20', 8),
(1337, 14, NULL, 'REBECA', 'SANTANCRUZ', 'volarenglobo@yahoo.es', NULL, '593997331443', 35, 2, 0, 37, 4, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD,DESPLIEGUE DE LONA, DESAYUNO BUFFET Y FOTO IMPRESA  , TRANSPORTE CDMX-TEOTIHUACAN-CDMX (CENTRO) ', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '182.00', 1, 0, NULL, 1, NULL, '2019-10-12 13:12:36', 8),
(1338, 9, NULL, 'ERIC', 'KREUTZER', 'rosillo.vianey@hotmail.com', NULL, '5568868307', 35, 5, 0, NULL, 3, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 5 PAX DE 45 MIN APROXIMADAMENTE SOBRE EL VALLE DE TEOTIHUACAN. TRANSPORTE REDONDO. CDMX. SEGURO DE VIAJERO. BRINDIS CON VINO ESPUMOSO. CERTIFICADO PERSONALIZADO', 'TRANSPORTE REDONDO $', '2000.00', NULL, NULL, NULL, '0.00', 11750.00, 0, '350.00', 1, 0, NULL, 1, 'TRANSPORTE REDONDO ÃMSTERDAM 188 Depto 602', '2019-10-12 13:46:24', 0),
(1339, 14, NULL, 'CLAUDIA', 'GIL', 'volarenglobo@yahoo.es', NULL, '5521360972', 11, 1, 1, 38, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 ADULTO 1 MENOR,  VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE EN TEOTIHUACAN, DESPLIEGUE DE LONA, DESAYUNO BUFFET ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4198.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-12 13:53:54', 8),
(1340, 14, NULL, 'CLEMENTE', 'MANI', 'volarenglobo@yahoo.es', NULL, '2712077145', 35, 2, 0, 36, 4, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE, TE , GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE LOCAL , DESAYUNO BUFFET Y FOTO IMPRESA.', 'TRANSPORTE RED CENTR', '700.00', NULL, NULL, NULL, '0.00', 7700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-12 14:25:26', 4),
(1341, 14, NULL, 'MAURICIO', 'FLORES', 'volarenglobo@yahoo.es', NULL, '5212215196430', 35, 2, 0, 36, 1, '2019-10-19', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET, DESPLIEGUE DE LONA', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-12 14:45:29', 6),
(1342, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-12 15:33:07', 0),
(1343, 16, '1331', 'MISSAEL', 'OLMEDO', 'ricardo.olmedo@live.com.mx', NULL, '5544200675', NULL, 3, 0, 38, 2, '2019-10-14', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / Despliegue de lona FELIZ CUMPLE!', NULL, NULL, NULL, NULL, NULL, '0.00', 6000.00, 0, '205.00', 1, 0, NULL, 1, 'vuelo bÃ¡sico, precio GuÃ­a Missael Olmedo', '2019-10-12 20:11:51', 7),
(1344, 14, NULL, 'KAROLL', 'MUÃ‘OZ ', 'volarenglobo@gmail.es', NULL, '9991981302', 33, 2, 0, 38, 1, '2019-10-13', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y PASTEL PARA CUMPLEAÃ‘ERO, DESPLIEGUE DE LONA FELIZ CUMPLEAÃ‘OS ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-12 21:23:33', 4),
(1345, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-13 12:29:01', 0),
(1346, 9, NULL, 'JOHANNA', 'VELARGA', 'turismo@volarenglobo.com.mx', NULL, '3104312608', NULL, 2, 0, NULL, 1, '2019-10-14', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX TURISKY L-V TRANSPORTE REDONDO ZOCALO', NULL, NULL, NULL, NULL, 2, '500.00', 4100.00, 0, '124.00', 1, 0, NULL, 1, NULL, '2019-10-13 12:30:30', 6);
INSERT INTO `temp_volar` (`id_temp`, `idusu_temp`, `clave_temp`, `nombre_temp`, `apellidos_temp`, `mail_temp`, `telfijo_temp`, `telcelular_temp`, `procedencia_temp`, `pasajerosa_temp`, `pasajerosn_temp`, `motivo_temp`, `tipo_temp`, `fechavuelo_temp`, `tarifa_temp`, `hotel_temp`, `habitacion_temp`, `checkin_temp`, `checkout_temp`, `comentario_temp`, `otroscar1_temp`, `precio1_temp`, `otroscar2_temp`, `precio2_temp`, `tdescuento_temp`, `cantdescuento_temp`, `total_temp`, `piloto_temp`, `kg_temp`, `tipopeso_temp`, `globo_temp`, `hora_temp`, `idioma_temp`, `comentarioint_temp`, `register`, `status`) VALUES
(1347, 14, NULL, 'SOKOLOV', 'SERGEI', '7djsokolov@mail.ru', NULL, NULL, 35, 2, 0, 36, 1, '2019-10-14', NULL, NULL, NULL, NULL, NULL, 'SHARED FLIGHT 2 PEOPLE, COFFE BREAK , ENSURANCE ', NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-10-13 13:14:59', 6),
(1348, 14, '1347', 'SOKOLOV', 'SERGEI', '7djsokolov@mail.ru', NULL, NULL, 35, 2, 0, 36, 1, '2019-10-14', NULL, NULL, NULL, NULL, NULL, 'SHARED FLIGHT 2 PEOPLE, COFFE BREAK , TRAVEL ENSURANCE, TOAST WITH WINE , BREAKFAST BUFFET', 'BREAKFAST ', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-10-13 13:22:03', 6),
(1349, 14, '1348', 'SOKOLOV', 'SERGEI', '7djsokolov@mail.ru', NULL, '79210627198', 35, 2, 0, 36, 1, '2019-10-14', NULL, NULL, NULL, NULL, NULL, 'SHARED FLIGHT 2 PEOPLE, COFFE BREAK , TRAVEL ENSURANCE, TOAST WITH WINE , BREAKFAST BUFFET', 'BREAKFAST ', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-10-13 13:26:03', 4),
(1350, 11, '1273', 'DANIELA', 'GOMEZ', 'Dannygomez111@hotmail.com', NULL, '573017123918', 35, 2, 0, 36, 1, '2019-10-24', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nINCLUYE TRANSPORTE IDA Y VUELTA CDMX\nDESAYUNOS BUFET RESTAURANTE GRAN TEOCALLI ', NULL, NULL, NULL, NULL, 2, '600.00', 5280.00, 0, '118.00', 1, 0, NULL, 1, 'Pick up hotal Capital O Vallejo\nNorte 1 C tlacamaca, delegacion Gustavo A Madero\nPendiente confirmar hora de pick Up', '2019-10-13 14:56:53', 8),
(1351, 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-13 14:59:31', 0),
(1352, 9, NULL, 'SELENE', 'L', 'turismo@volarenglobo.com.mx', NULL, '5573487852', NULL, 2, 0, NULL, 1, '2019-10-14', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MIN SOBRE EL VALLE DE TEOTIHUACAN, COFFEE BREAK ANTES DE VUELO, SEGURO DE VIAJERO, BRINDIS CON VINO ESOUMOSO, CERTIFICADO PERSONALIZADO', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '127.00', 1, 0, NULL, 1, 'DAR A GUIA COMISION DE $300 POR PAX CUANDO VUELEN', '2019-10-13 18:16:19', 4),
(1353, 9, '1346', 'JOHANNA', 'VELARGA', 'turismo@volarenglobo.com.mx', NULL, '3104312608', NULL, 2, 0, NULL, 1, '2019-10-14', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX TURISKY L-V TRANSPORTE REDONDO ZOCALO', NULL, NULL, NULL, NULL, 2, '500.00', 4100.00, 0, '124.00', 1, 0, NULL, 1, NULL, '2019-10-13 18:33:49', 4),
(1354, 16, NULL, 'KRISTIAN', 'SANCHEZ', 'reserva@volarenglobo.com.mx', NULL, '4426482006', 19, 2, 0, 38, 2, '2019-10-14', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDespliegue de lona', NULL, NULL, NULL, NULL, NULL, '0.00', 4280.00, 0, '125.00', 1, 0, NULL, 1, NULL, '2019-10-13 21:10:19', 8),
(1355, 14, NULL, 'SARAH', 'CABRAL', 'volarenglobo@yahoo.es', NULL, '18098385286', 35, 2, 0, 36, 1, '2019-10-21', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, DESPLIEGUE DE LONA, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI, TRANSPORTE CDMX-TEOTIHUACAN-CDMX ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-14 10:48:30', 8),
(1356, 14, '1144', 'SERGIO', 'COVALEDA', 'volarenglobo@yahoo.es', NULL, '573176568559', 35, 4, 0, 38, 1, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET Y PASTEL PARA CUMPLEAÃ‘ERO', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 9596.00, 0, '260.00', 1, 0, NULL, 1, NULL, '2019-10-14 10:55:45', 8),
(1357, 9, NULL, 'LUCA', 'FIASCHI', 'turismo@volarenglobo.com.mx', NULL, '19173622490', 35, 2, 0, 36, 3, '2019-11-29', NULL, NULL, NULL, NULL, NULL, '**** 2019-11-29 ****\nâ€ƒâ€ƒTicket Type: Traveler: 2 ()\nâ€ƒâ€ƒPrimary Redeemer: Luca Fiaschi, 19173622490, luca.fiaschi@gmail.com\nâ€ƒâ€ƒValid Day: Nov 29, 2019\nâ€ƒâ€ƒItem: Teotihuacan Pyramids Hot-Air Balloon Flight / 5:00 AM, Flight with Transportation / 529019\nâ€ƒâ€ƒVoucher: 80466112, 80466113\nâ€ƒâ€ƒItinerary: 7484615307776\n', NULL, NULL, NULL, NULL, 2, '100.00', 4800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-14 11:00:55', 4),
(1358, 14, '1341', 'MAURICIO', 'FLORES', 'volarenglobo@yahoo.es', NULL, '5212215196430', 35, 2, 0, 36, 1, '2019-10-19', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET, DESPLIEGUE DE LONA', 'DESAYUNOS', '198.00', 'TRANSPORTE ZONA ZOCA', '700.00', NULL, '0.00', 5498.00, 0, '0.00', 1, 0, NULL, 1, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET Y TRANSPORTE RED ZOCALO', '2019-10-14 13:13:59', 8),
(1359, 16, NULL, 'SETH', 'ROJAS', 'comertamos@gmail.com', NULL, '5951108968', NULL, 2, 0, 37, 4, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona FELIZ ANIVERSARIO / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '130.00', 1, 0, NULL, 1, 'SI LIQUIDA CON TARJETA BANCOMER NO COBRAR COMISION DEL 4%', '2019-10-14 13:15:30', 8),
(1360, 16, NULL, 'CAROLINA', 'VELANDIA', 'reserva@volarenglobo.com.mx', NULL, '573112617843', NULL, 2, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '112.00', 1, 0, NULL, 1, NULL, '2019-10-14 13:40:10', 8),
(1361, 16, NULL, 'CAMILO', 'RAMIREZ', 'reserva@volarenglobo.com.mx', NULL, '573115226867', NULL, 2, 0, NULL, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, 2, '82.00', 5798.00, 0, '155.00', 1, 0, NULL, 1, NULL, '2019-10-14 13:47:44', 8),
(1362, 16, NULL, 'ISRAEL', 'VIEYRA', 'reserva@volarenglobo.com.mx', NULL, '55836996', NULL, 2, 0, 44, 4, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona QUIERES SER MI NOVIA / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '140.00', 1, 0, NULL, 1, NULL, '2019-10-14 13:52:43', 6),
(1363, 16, NULL, 'JAVIER', 'TORTOSA', 'reserva@volarenglobo.com.mx', NULL, '5526927044', NULL, 12, 0, 36, 2, '2019-10-18', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet (excepto bÃ¡sico)/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 25680.00, 0, '870.00', 1, 0, NULL, 1, NULL, '2019-10-14 13:56:25', 8),
(1364, 16, NULL, 'JORGE', 'RISEK', 'reserva@volarenglobo.com.mx', NULL, '18093831919', NULL, 2, 0, 45, 5, '2019-10-18', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona TE AMO/ Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.\n\n', NULL, NULL, NULL, NULL, NULL, '0.00', 8550.00, 0, '145.00', 1, 0, NULL, 1, NULL, '2019-10-14 14:11:17', 8),
(1365, 16, NULL, 'GABRIELA', 'MARCIAL', 'iitalia19@hotmail.com', NULL, '9612317551', NULL, 2, 0, 36, 1, '2019-10-19', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Transporte redondo ZÃ³calo-TeotihuacÃ¡n', NULL, NULL, NULL, NULL, 2, '382.00', 5498.00, 0, '110.00', 1, 0, NULL, 1, NULL, '2019-10-14 14:51:48', 6),
(1366, 16, NULL, 'LIZ', 'GALVAN', 'lizgalvan87@live.com', NULL, '5539579186', NULL, 3, 1, 36, 1, '2019-10-19', NULL, NULL, NULL, NULL, NULL, '\nVuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona \n', NULL, NULL, NULL, NULL, 2, '164.00', 8996.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-14 15:00:09', 0),
(1367, 16, NULL, 'LIZBETH', 'MONROY', 'reserva@volarenglobo.com.mx', NULL, '5540842334', NULL, 4, 0, 38, 1, '2019-10-19', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona FELIZ CUMPLE!', NULL, NULL, NULL, NULL, 2, '164.00', 9596.00, 0, '275.00', 1, 0, NULL, 1, NULL, '2019-10-14 15:12:36', 8),
(1368, 16, NULL, 'JAVIER', 'PADILLA', 'erisca.op@gmail.com', NULL, '5528104454', NULL, 6, 0, NULL, 1, '2019-10-15', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet )/ Seguro viajero/ Coffee break / Despliegue de lona', NULL, NULL, NULL, NULL, NULL, '0.00', 13800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-14 15:21:42', 6),
(1369, 16, '1368', 'JAVIER', 'PADILLA', 'erisca.op@gmail.com', NULL, '5528104454', NULL, 6, 0, NULL, 2, '2019-10-15', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet )/ Seguro viajero/ Coffee break / Despliegue de lona', NULL, NULL, NULL, NULL, NULL, '0.00', 12840.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-14 15:31:18', 6),
(1370, 14, NULL, 'HAIDA', 'XOYON', 'volarenglobo@yahoo.es', NULL, '50242165465', 35, 2, 0, 36, 1, '2019-10-25', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', NULL, NULL, NULL, NULL, 2, '600.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-14 15:41:38', 8),
(1371, 16, '1369', 'JAVIER', 'PADILLA', 'erisca.op@gmail.com', NULL, '5528104454', NULL, 6, 0, NULL, 2, '2019-10-15', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet )/ Seguro viajero/ Coffee break / Despliegue de lona', NULL, NULL, NULL, NULL, NULL, '0.00', 12000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-14 15:45:29', 8),
(1372, 16, NULL, 'RODRIGO', 'GUTIERREZ', 'isamaurerb@gmail.com', NULL, '2227074700', NULL, 2, 0, NULL, 1, '2019-10-19', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 5600.00, 0, '140.00', 1, 0, NULL, 1, NULL, '2019-10-14 15:52:05', 8),
(1373, 11, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-14 17:40:34', 0),
(1374, 9, NULL, 'SERGIO', 'TURISKY', 'turismo@volarenglobo.com.mx', NULL, '381652204025', 35, 2, 0, NULL, 3, '2019-10-15', NULL, NULL, NULL, NULL, NULL, NULL, 'TRANSPORTE TURISKY', '200.00', NULL, NULL, NULL, '0.00', 4100.00, 0, '158.00', 1, 0, NULL, 2, 'PEDIR BOLETITOS TURISKY7 TRANSPORTE HOTEL KALI CUIDADELA LUIS MOYA 101, REGRESO 10:30', '2019-10-14 18:00:19', 4),
(1375, 14, NULL, 'YENNY ', 'SOLORZANO', 'volarenglobo@yahoo.es', NULL, '5573546508', 11, 7, 0, 36, 1, '2019-10-19', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 7 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'IVA', '2396.00', NULL, NULL, 2, '2100.00', 17376.00, 0, '482.00', 1, 0, NULL, 1, NULL, '2019-10-14 18:12:45', 8),
(1376, 16, NULL, 'JAVIER', 'VIZCANO', 'reserva@volarenglobo.com.mx', '573013385252', '5547304368', NULL, 5, 3, 36, 2, '2019-10-15', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona FELIZ VUELO!', NULL, NULL, NULL, NULL, 2, '123.00', 16097.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-14 18:16:10', 8),
(1377, 9, NULL, 'DANIEL ', 'R SOCIO', 'turismo@volarenglobo.com.mx', NULL, '5491165833775', NULL, 1, 0, NULL, 3, '2019-10-15', NULL, NULL, NULL, NULL, NULL, 'PASAJERO TURISKY L-V', 'TRANSPORTE TURISKY', '100.00', NULL, NULL, 2, '0.00', 2050.00, 0, '80.00', 1, 0, NULL, 1, 'PEDIR BOLETITO TURISKY ', '2019-10-14 19:25:56', 4),
(1378, 16, NULL, 'ANDRES', 'GONZALEZ', 'andresgonzalezuscanga5@gmail.com', NULL, '2321594001', NULL, 2, 0, 38, 4, '2019-10-31', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona FELIZ CUMPLE / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 8900.00, 0, '150.00', 1, 0, NULL, 1, NULL, '2019-10-15 11:50:42', 8),
(1379, 16, NULL, 'LUISA', 'CONTRERAS', 'Luisa.contreras.ariza@gmail.com', NULL, '51991171113', NULL, 4, 0, 36, 1, '2019-10-19', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, 2, '164.00', 9596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-15 12:09:35', 8),
(1380, 16, NULL, 'FRANCISCO', 'FERIA', 'reserva@volarenglobo.com.mx', NULL, '5521076678', NULL, 2, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '140.00', 1, 0, NULL, 1, NULL, '2019-10-15 12:58:59', 8),
(1381, 16, '1178', 'CARLOS', 'CISNEROS', 'jasonquiroz74@gmail.com ', NULL, '5615100221', NULL, 2, 0, 39, 4, '2019-10-16', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo/ Brindis en vuelo con vino espumoso Freixenet/ Certificado de vuelo/ Seguro viajero/ Desayuno tipo Buffet / TransportaciÃ³n local / Despliegue de lona Â¿Te quieres casar conmigo?/ Foto Impresa', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-15 13:17:42', 8),
(1382, 9, '1154', 'JAVIER', 'NAVARRO NAVARRO', 'turismo@volarenglobo.com.mx', NULL, '5580284011', 11, 2, 0, 36, 3, '2019-10-31', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO CON TRANSPORTE TU EXPERIENCIA', NULL, NULL, NULL, NULL, 2, '200.00', 4700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-15 13:26:55', 8),
(1383, 16, '1365', 'GABRIELA', 'MARCIAL', 'iitalia19@hotmail.com', NULL, '9612317551', NULL, 2, 0, 36, 1, '2019-10-19', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Transporte redondo CDMX/TEOTIHUACÃN', NULL, NULL, NULL, NULL, 2, '82.00', 5798.00, 0, '110.00', 1, 0, NULL, 1, NULL, '2019-10-15 13:39:29', 8),
(1384, 16, NULL, 'ANDRES LEONARDO', 'BELTRAN', 'andresbp01@outlook.com', NULL, '50374963029', NULL, 3, 0, 36, 1, '2019-10-19', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break /Transporte redondo: Ãngel de la Independencia', NULL, NULL, NULL, NULL, 2, '573.00', 8247.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-15 13:51:25', 6),
(1385, 16, NULL, 'FELIX MIGUEL', 'RINCON', 'drfelix.rincon@gmail.com', NULL, '6381152740', NULL, 3, 0, 36, 1, '2019-10-19', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet (excepto bÃ¡sico)/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, 2, '123.00', 7197.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-15 14:03:05', 8),
(1386, 16, NULL, 'CARLOS', 'RINCON', 'crgv41@gmail.com', NULL, '8117190486', NULL, 2, 0, NULL, 4, '2019-11-17', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-15 15:44:15', 6),
(1387, 16, NULL, 'ROSARIO', 'MORENO', 'rosariodoctora@hotmail.com', NULL, '2211175297', NULL, 2, 0, NULL, 1, '2019-10-18', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno Buffete/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '130.00', 1, 0, NULL, 1, NULL, '2019-10-15 18:06:17', 8),
(1388, 16, NULL, 'MONICA', 'CELIS', 'monica.celis@xifragroup.com', NULL, '2226591632', NULL, 2, 0, NULL, 4, '2019-10-18', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-16 10:46:27', 0),
(1389, 9, NULL, 'LUISA', 'DE MOYA', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, 36, 3, '2019-10-21', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO BESTDAY ID 74038839-1', NULL, NULL, NULL, NULL, 2, '620.00', 3280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-16 10:51:40', 8),
(1390, 16, NULL, 'GABRIELA', 'AYLAGAS', 'gabriela.aylagas89@gmail.com', NULL, '50372108563', NULL, 2, 0, 37, 1, '2019-11-29', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona FELIZ ANIVERSARIO!', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-16 11:15:00', 8),
(1391, 9, NULL, 'VANESSSA', 'ESCAF', 'turismo@volarenglobo.com.mx', NULL, '5516088121', 11, 2, 0, 36, 3, '2019-10-21', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTDO TONA SOLO VUELO', NULL, NULL, NULL, NULL, NULL, '0.00', 3900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-16 11:44:35', 8),
(1392, 16, NULL, 'MARGOTH', 'QUIROS', 'm_23_90@hotmail.com', NULL, '50683266812', NULL, 2, 0, NULL, 1, '2019-10-23', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona ', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '120.00', 1, 0, NULL, 1, NULL, '2019-10-16 11:45:03', 8),
(1393, 9, NULL, 'REGINA', 'GUARAGNA', 'turismo@volarenglobo.com.mx', NULL, '5551999844286', 35, 2, 0, 36, 3, '2019-10-18', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO BOOKING CON TRANSPORTE', NULL, NULL, NULL, NULL, 2, '203.00', 4697.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-16 13:22:59', 8),
(1394, 14, NULL, 'MANUELA', 'ZULUAGA', 'volarenglobo@yahoo.es', NULL, '5215584119307', 11, 3, 0, 36, 1, '2019-10-23', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI, TRANSPORTE RED CENTRO', 'DESAYUNOS', '420.00', NULL, NULL, 2, '900.00', 7920.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-16 13:53:30', 8),
(1395, 9, NULL, 'STEPHANI', 'TURISKY', 'turismo@volarenglobo.com.mx', NULL, '5215548733296', 11, 2, 0, 36, 3, '2019-10-17', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO TURISKY', NULL, NULL, NULL, NULL, 2, '800.00', 4100.00, 0, '128.00', 1, 0, NULL, 1, NULL, '2019-10-16 14:46:31', 8),
(1396, 16, NULL, 'ARIEL', 'GONZALEZ', 'ariel.gzg@gmail.com', NULL, '595994288798', NULL, 3, 0, 36, 2, '2019-10-18', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', 'TRANSPORTE SOLO IDA', '1050.00', NULL, NULL, NULL, '0.00', 7470.00, 0, '218.00', 1, 0, NULL, 1, NULL, '2019-10-16 14:53:23', 8),
(1397, 16, '1275', 'CARLOS', 'GAMA', 'carl_yop@yahoo.com.mx', NULL, '4434100433', NULL, 14, 2, NULL, 2, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'TE INCLUYE: \nâ€¢	VUELO LIBRE SOBRE EL VALLE DE TEOTIHUACÃN DE 45 A 60 MINUTOS \nâ€¢	BRINDIS CON VINO ESPUMOSO O JUGO DE FRUTA \nâ€¢	CERTIFICADO DE VUELO PERSONALIZADO \nâ€¢	SEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nâ€¢	COFFE BREAK: CAFE, TE, GALLETAS, PAN.\nâ€¢	DESPLIEGUE DE LONA\nâ€¢	DESAYUNO BUFFETE EN RESTAURANTE GRAN TEOCALLI.\n', 'PESO EXTRA', '500.00', NULL, NULL, 2, '82.00', 34058.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-16 15:02:41', 8),
(1398, 9, NULL, 'GIDEON', 'GONEN', 'turismo@volarenglobo.com.mx', NULL, '5510411697', 11, 2, 0, NULL, 3, '2019-10-28', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO TEOCALLI', NULL, NULL, NULL, NULL, 2, '400.00', 3500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-16 15:05:57', 8),
(1399, 14, NULL, 'MANUEL', 'GONZALEZ', 'volarenglobo@yahoo.es', NULL, '5544842627', 11, 2, 0, 36, 1, '2019-10-18', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 1, NULL, 1, NULL, '2019-10-16 15:38:49', 8),
(1400, 16, NULL, 'ARTURO', 'SANTAMA', 'arturos.lcdz@gmail.com', NULL, '7223503987', NULL, 2, 0, 38, 4, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona FELIZ CUMPLE! / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '150.00', 1, 0, NULL, 1, 'PASTEL EN DESAYUNO', '2019-10-16 16:54:33', 8),
(1401, 14, NULL, 'YASMIN', 'NAJUL', 'volarenglobo@yahoo.es', NULL, '5534924991', 11, 2, 0, 36, 1, '2019-10-17', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-16 18:01:15', 7),
(1402, 16, NULL, 'ALEX', 'DA SILVA', 'reserva@volarenglobo.com.mx', NULL, '5510998008', NULL, 2, 0, 36, 1, '2019-10-28', NULL, NULL, NULL, NULL, NULL, '- Flight insurance / Flight of 45 min. to 1 hour/ Coffee break/ Sparkling wine toast/ Flight certificate/ Buffet breakfast', NULL, NULL, NULL, NULL, 2, '30.00', 6000.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-10-16 18:34:26', 6),
(1403, 16, NULL, 'HAROLD', 'BARBOSA', 'haroldbarbosa0824@gmail.com', NULL, '573213790877', NULL, 2, 0, 39, 4, '2019-11-24', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona Te Quieres casar conmigo?/ Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-16 18:48:29', 8),
(1404, 16, NULL, 'POLA', 'SALMUN', 'salmunpola@gmail.com', NULL, '5559894517', NULL, 3, 0, 36, 1, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, 2, '123.00', 7197.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-17 10:51:59', 0),
(1405, 14, NULL, 'DERECK', 'BRENES', 'volarenglobo@yahoo.es', NULL, '50686317817', 35, 2, 0, 36, 1, '2019-10-31', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS,VUELO SOBRE EL VALLE  DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD.', NULL, NULL, NULL, NULL, 2, '600.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-17 11:03:25', 8),
(1406, 14, '1108', 'CLAUDIA', 'PERDOMO', 'volarenglobo@yahoo.es', NULL, '573007386751', 11, 2, 0, 36, 1, '2019-10-18', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, 2, '600.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET ', '2019-10-17 11:20:50', 8),
(1407, 16, '1402', 'ALEX', 'DA SILVA', 'alex.silva@pandrol.com', NULL, '51989342727', NULL, 1, 0, 36, 1, '2019-10-28', NULL, NULL, NULL, NULL, NULL, '- Flight insurance / Flight of 45 min. to 1 hour/ Coffee break/ Sparkling wine toast/ Flight certificate/ Buffet breakfast', NULL, NULL, NULL, NULL, 2, '15.00', 3000.00, 0, '85.00', 1, 0, NULL, 2, NULL, '2019-10-17 11:30:25', 8),
(1408, 11, NULL, 'DORA', 'CUERVO', 'isavargas75@gmail.com', '573023703086', '573113725699', 35, 3, 0, 36, 1, '2019-11-06', NULL, NULL, NULL, NULL, NULL, 'INCLUYE VUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS,\nCOFFE BREAK, BRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET, CERTIFICADO DE VUELO,\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD\nTRANSPORTE DESDE HOTEL ROYAL REFORMA SOLO IDA', NULL, NULL, NULL, NULL, 2, '150.00', 7650.00, 0, '210.00', 1, 0, NULL, 1, NULL, '2019-10-17 11:57:23', 8),
(1409, 16, NULL, 'CRISTIAN', 'MOREL', 'Cmorelguzman@gmail.com', NULL, '18296058090', NULL, 4, 0, 36, 2, '2019-10-22', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 10000.00, 0, '0.00', 1, 0, NULL, 1, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', '2019-10-17 12:02:37', 6),
(1410, 16, NULL, 'LEYLA', 'VAZQUEZ', 'leyla_2590@hotmail.com', NULL, '8711325247', NULL, 2, 0, NULL, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '163.00', 1, 0, NULL, 1, NULL, '2019-10-17 12:13:57', 6),
(1411, 14, NULL, 'ALVARO', 'MUÃ‘OZ', 'volarenglobo@yahoo.es', NULL, '5545103250', 11, 4, 0, 36, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 9596.00, 0, '293.00', 1, 0, NULL, 1, NULL, '2019-10-17 12:39:28', 6),
(1412, 9, NULL, 'JAZMIN ', 'MONTERROSA', 'reservasteo@gshoteles.com.mx', NULL, '5949561881', NULL, 4, 0, NULL, 3, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 4 PAX DE 45 MIN. APROX. SOBRE VALLE DE TEOTIHUACAN. COFFEE BREAK ANTES DE VUELO. SEGURO DE VIAJERO. BRINDIS CON VINO ESPUMOSO. CERTIFICADO PERSONALIZADO', NULL, NULL, NULL, NULL, NULL, '0.00', 7800.00, 0, '0.00', 1, 0, NULL, 1, 'PASAR POR ELLOS QUINTO SOL 08:00 AM', '2019-10-17 12:41:04', 6),
(1413, 14, NULL, 'STEFANIA', 'OIDOR', 'volarenglobo@yahoo.es', NULL, '5731389483553', 35, 2, 0, 36, 1, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '147.00', 1, 0, NULL, 1, NULL, '2019-10-17 13:19:23', 4),
(1414, 16, '1409', 'CRISTIAN', 'MOREL', 'Cmorelguzman@gmail.com', NULL, '18296058090', NULL, 4, 0, 36, 2, '2019-10-22', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 10560.00, 0, '257.00', 1, 0, NULL, 1, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', '2019-10-17 13:52:07', 8),
(1415, 9, '1412', 'JAZMIN ', 'MONTERROSA', 'reservasteo@gshoteles.com.mx', NULL, '5949561881', NULL, 4, 0, NULL, 3, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 4 PAX DE 45 MIN. APROX. SOBRE VALLE DE TEOTIHUACAN. COFFEE BREAK ANTES DE VUELO. SEGURO DE VIAJERO. BRINDIS CON VINO ESPUMOSO. CERTIFICADO PERSONALIZADO', NULL, NULL, NULL, NULL, 2, '400.00', 7400.00, 0, '0.00', 1, 0, NULL, 1, 'PASAR POR ELLOS QUINTO SOL 08:00 AM', '2019-10-17 13:52:08', 8),
(1416, 14, NULL, 'MARIA DEL ROSARIO', 'VASQUEZ', 'volarenglobo@yahoo.es', NULL, '50683995148', 35, 4, 0, 36, 1, '2019-12-14', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 9596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-17 13:57:59', 8),
(1417, 14, NULL, 'OSCAR DAVID', 'SALAS', 'volarenglobo@yahoo.es', NULL, '12281948556', 35, 3, 1, 36, 4, '2019-11-17', NULL, 1, 20, '2019-11-16', '2019-11-17', 'VUELO PRIVADO PARA 3 ADULTOS 1 MENOR , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE  Y  FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, 2, '751.00', 13199.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-17 14:16:23', 8),
(1418, 14, NULL, 'VALERIA', 'ALVAREZ', 'volarenglobo@yahoo.es', NULL, '5551061308', 11, 2, 0, 36, 4, '2019-11-16', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE , PASTEL PARA CUMPLEAÃ‘ERO (SIN LONA) Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-17 14:42:11', 8),
(1419, 16, NULL, 'ANTONIO', 'FRANCO', 'bernyportillo@live.com.mx', NULL, '9981683776', NULL, 2, 0, NULL, 4, '2019-10-18', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo/ brindis con vino espumoso/certificado de vuelo/seguro viajero/coffe break/Desayuno buffet', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '150.00', 1, 0, NULL, 1, NULL, '2019-10-17 15:30:24', 8),
(1420, 16, NULL, 'JOHANA', 'VENTOCILLA', 'j.ventocilla@pucp.pe', NULL, '51943727478', NULL, 3, 0, 36, 1, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 8400.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-17 17:06:27', 6),
(1421, 14, NULL, 'AUGUSTO', 'ROJAS', 'volarenglobo@yahoo.es', NULL, '8180293253', 21, 13, 0, 43, 1, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 13 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ VUELO\" ,DESAYUNO BUFFET', NULL, NULL, NULL, NULL, 2, '3900.00', 27820.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-17 17:28:02', 8),
(1422, 9, NULL, 'MARGARITA', 'ALVAREZ', 'turismo@volarenglobo.com.mx', NULL, '974791511', 11, 2, NULL, 36, 3, '2019-10-18', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO CON TRANSPORTE TURISKY', NULL, NULL, NULL, NULL, 2, '800.00', 4100.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-17 17:33:15', 8),
(1423, 9, NULL, 'FABIO', 'SANNIA', 'turismo@volarenglobo.com.mx', NULL, '5534360536', NULL, 2, 0, 36, 3, '2019-10-26', NULL, NULL, NULL, NULL, NULL, '2 CORTESIAS EXPEDIA CON TRANSPORTE', NULL, NULL, NULL, NULL, 2, '4899.00', 1.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-17 17:41:36', 8),
(1424, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-17 18:05:56', 0),
(1425, 9, NULL, 'IVAN JOSE', 'MIRANDA', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, NULL, 16, '2019-10-18', NULL, NULL, NULL, NULL, NULL, '2 PAX PRIVADO PRICE TRAVEL LOCATOR 13272492-1', NULL, NULL, NULL, NULL, 2, '800.00', 5200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-17 18:46:41', 8),
(1426, 9, NULL, 'TAN', 'HAOXIANG', 'turismo@volarenglobo.com.mx', NULL, '5582217356', 35, 2, 0, 36, 3, '2019-10-18', NULL, NULL, NULL, NULL, NULL, '2 PAX FULL KAYTRIP', NULL, NULL, NULL, NULL, 2, '230.00', 6000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-17 18:50:51', 8),
(1427, 14, NULL, 'NOE ', 'MORENO', 'volarenglobo@yahoo.es', NULL, '5537044884', 11, 4, 0, 36, 1, '2019-10-18', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 9596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-17 19:02:50', 8),
(1428, 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 09:15:31', 0),
(1429, 9, NULL, 'LIZ', 'RODRIGUEZ', 'turismo@volarenglobo.com.mx', NULL, '17874299829', 11, 1, NULL, NULL, 3, '2019-11-03', NULL, NULL, NULL, NULL, NULL, '**** 2019-11-03 ****\nâ€ƒâ€ƒTicket Type: Traveler: 1 ()\nâ€ƒâ€ƒPrimary Redeemer: LIZ RODRIGUEZ, 17874299829, LN.ROMA.90@GMAIL.COM\nâ€ƒâ€ƒValid Day: Nov 3, 2019\nâ€ƒâ€ƒItem: Teotihuacan Pyramids Hot-Air Balloon Flight / 5:00 AM, Flight with Transportation / 529019\nâ€ƒâ€ƒVoucher: 80519009\nâ€ƒâ€ƒItinerary: 7485855026610\n', NULL, NULL, NULL, NULL, 2, '50.00', 2400.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 10:46:36', 8),
(1430, 14, '1204', 'CARLA CRISTINA', 'DIXON', 'volarenglobo@yahoo.es', NULL, '50763284728', 35, 2, 0, 36, 1, '2019-10-06', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 11:32:02', 0),
(1431, 16, NULL, 'DIEGO ALEJANDRO', 'NAVA', 'reserva@volarenglobo.com.mx', NULL, '5549073758', NULL, 2, 0, NULL, 1, '2019-10-19', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', 'TRANSPORTE REDONDO A', '700.00', NULL, NULL, 2, '600.00', 4700.00, 0, '140.00', 1, 0, NULL, 1, NULL, '2019-10-18 11:55:59', 8),
(1432, 14, NULL, 'CECILIA', 'ORTIGOZA', 'moly_16ceci@hotmail.com', NULL, '52155591665101', 11, 2, 0, 38, 1, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE, TE , GALLETAS Y PAN) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO , TRANSPORTE LOCAL , DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI , PASTEL PARA CUMPLEAÃ‘ERO , TRANSPORTE CDMX-TEOTIHUACAN-CDMX (CENTRO)', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 11:58:25', 6),
(1433, 16, NULL, 'VALEZKA', 'DE PEREZ', 'reserva@volarenglobo.com.mx', NULL, '50255040260', NULL, 4, 0, NULL, 1, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 11200.00, 0, '260.00', 1, 0, NULL, 1, NULL, '2019-10-18 12:04:36', 8),
(1434, 14, NULL, 'PATTY', 'ALVEAR', 'patty.alvear@hotmail.com', NULL, '593984462071', 35, 2, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS , VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , INCLUYE COFFE BREAK (CAFE, TE , GALLETAS Y PAN) SEGURO DE VIAJERO , BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD LOCAL .', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 12:33:31', 8),
(1435, 9, NULL, 'ALISTAIR ', 'SMITH', 'turismo@volarenglobo.com.mx', NULL, '353851003025', 35, 1, 0, 36, 3, '2019-10-21', NULL, NULL, NULL, NULL, NULL, '1 PAX COMPARTIDO FULL BOOKING', NULL, NULL, NULL, NULL, 2, '140.00', 3425.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 12:53:00', 8),
(1436, 16, NULL, 'BERNARDO', 'VAZQUEZ', 'vazquezaradillas@hotmail.com', NULL, '9993149139', NULL, 2, 0, NULL, 1, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '129.00', 1, 0, NULL, 1, NULL, '2019-10-18 13:10:16', 8),
(1437, 16, NULL, 'ELIZABETH', 'MORALES', 'ely_8417mh@icloud.com', NULL, '2225849752', NULL, 2, 0, NULL, 1, '2019-11-02', NULL, 1, 25, '2019-11-02', '2019-11-03', 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, 2, '82.00', 6098.00, 0, '148.00', 1, 0, NULL, 1, NULL, '2019-10-18 13:31:01', 8),
(1438, 9, NULL, 'EDWIN', 'SALAS JIMENEZ', 'turismo@volarenglobo.com.mx', NULL, '9999999', 11, 3, 0, 36, 3, '2019-10-19', NULL, NULL, NULL, NULL, NULL, '3 PAX COMPARTIDO OMAR BAUTISTA', NULL, NULL, NULL, NULL, NULL, '0.00', 7770.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 13:43:07', 4),
(1439, 9, NULL, 'MARTIN ALEJANDRO', 'SILVA CARDENAS', 'turismo@volarenglobo.com.mx', NULL, '5537048766', 11, 2, 0, 36, 16, '2019-10-20', NULL, NULL, NULL, NULL, NULL, '2 PAX PRIVADO BESTDAY ID 73529389-1', NULL, NULL, NULL, NULL, 2, '800.00', 5200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 14:24:34', 8),
(1440, 9, NULL, 'LARISSA', 'SCHENEIDER CALZA', 'turismo@volarenglobo.com.mx', NULL, '5526909678', 11, 3, 0, 36, 16, '2019-10-20', NULL, NULL, NULL, NULL, NULL, '3 PAX PRIVADO SEE MEXICO', NULL, NULL, NULL, NULL, NULL, '0.00', 9000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 14:34:58', 8),
(1441, 9, NULL, 'MARIA MARTHA', 'DURAN', 'turismo@volarenglobo.com.mx', NULL, '99999999', 11, 4, 3, 36, 3, '2019-10-20', NULL, NULL, NULL, NULL, NULL, '7 PAX NOMADIC', NULL, NULL, NULL, NULL, 2, '360.00', 13520.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 14:40:48', 8),
(1442, 9, NULL, 'VIAJES ', 'FLOTUR', 'turismo@volarenglobo.com.mx', NULL, '999999', 11, 12, 0, 36, 2, '2019-10-20', NULL, NULL, NULL, NULL, NULL, '12 PAX CON DESAYUNO', NULL, NULL, NULL, NULL, NULL, '0.00', 25680.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 14:49:50', 8),
(1443, 9, NULL, 'LILIAM', 'CHAGAS', 'turismo@volarenglobo.com.mx', NULL, '5526909678', 11, 1, 0, 36, 4, '2019-10-20', NULL, NULL, NULL, NULL, NULL, '1 PAX PRIVADO SEE MEXICO PAGA EN SITIO', NULL, NULL, NULL, NULL, NULL, '0.00', 3500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 14:56:56', 8),
(1444, 9, NULL, 'ARIEL', 'SAFFATI', 'turismo@volarenglobo.com.mx', NULL, '50683179292', 11, 1, 3, 36, 3, '2019-10-20', NULL, NULL, NULL, NULL, NULL, '4 PAX TU EXPERIENCIA ', 'AJUSTE', '350.00', NULL, NULL, NULL, '0.00', 9400.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 15:04:20', 8),
(1445, 9, NULL, 'ARIELA', 'FACHLER', 'turismo@volarenglobo.com.mx', NULL, '50683179292', 11, 1, 2, 36, 3, '2019-10-20', NULL, NULL, NULL, NULL, NULL, '3 PAX TU EXPERIENCIA ', 'AJUSTE', '200.00', NULL, NULL, NULL, '0.00', 7050.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 15:14:03', 8),
(1446, 14, NULL, 'LETICIA', 'LEON', 'ventas@volarenglobo.com.mx', NULL, '55237857', 11, 3, 0, 36, 1, '2019-10-19', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 ADULTOS , VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX . INCLUYE COFFE BREAK (CAFE,TE,PAN Y GALLETAS) CERTIFICADO PERSONALIZADO,TRANSPORTE LOCAL , DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 7197.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 15:27:26', 0),
(1447, 9, NULL, 'JORGE ALBERTO', 'AGUILAR', 'turismo@volarenglobo.com.mx', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 15:28:00', 0),
(1448, 9, NULL, 'JORGE ALBERTO', 'AGUILAR', 'turismo@volarenglobo.com.mx', NULL, '99999', 11, 2, 0, 36, 2, '2019-10-20', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO VIAJES FLOTUR', NULL, NULL, NULL, NULL, NULL, '0.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 15:33:12', 8),
(1449, 9, NULL, 'ADOLFO', 'VARGAS ESPINDOLA', 'turismo@volarenglobo.com.mx', NULL, '0181002378329', 11, 4, 1, 36, 2, '2019-10-20', NULL, NULL, NULL, NULL, NULL, '5 PAX PRICE TRAVEL LOCATOR 13381691-1', 'AJUSTE', '300.00', NULL, NULL, NULL, '0.00', 10000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 15:49:49', 8),
(1450, 9, NULL, 'CARLOS EDUARDO', 'ROSALES', 'turismo@volarenglobo.com.mx', NULL, '5215511964894', 11, 1, 0, 36, 1, '2019-10-19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 2300.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 16:54:08', 8),
(1451, 9, NULL, 'JOVANNY', ' XELHUANTZI LOPEZ', 'omarbaucam93@gmail.com', NULL, '7752365213', 11, 2, 0, 38, 3, '2019-10-27', NULL, NULL, NULL, NULL, NULL, '2 PAX OMAR BAUTISTA', NULL, NULL, NULL, NULL, NULL, '0.00', 3900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 17:09:33', 8),
(1452, 9, NULL, 'JOSE MANUEL', 'TORRES', 'reservas@tuexperiencia.com', NULL, '5580284011', 11, 2, 0, 36, 16, '2019-10-25', NULL, NULL, NULL, NULL, NULL, 'TUGA-181019-01  TU EXPERIENCIA 2PAX PRIVADO', NULL, NULL, NULL, NULL, 2, '200.00', 6800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 17:42:26', 8),
(1453, 9, NULL, 'CHEN ', 'MEIQUI', 'kaytripdemexico@gmail.com', NULL, '5582217356', 11, 2, 0, 36, 3, '2019-10-23', NULL, NULL, NULL, NULL, NULL, '2 CORTESIAS KAYTRIP', NULL, NULL, NULL, NULL, 2, '4899.00', 1.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 17:50:38', 8),
(1454, 14, '1411', 'ALVARO', 'MUÃ‘OZ', 'volarenglobo@yahoo.es', NULL, '5545103250', 11, 4, 0, 36, 1, '2019-10-25', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 9596.00, 0, '293.00', 1, 0, NULL, 1, NULL, '2019-10-18 18:05:42', 8),
(1455, 9, NULL, 'RACHEL', 'KNOWLES', 'turismo@volarenglobo.com.mx', NULL, '447720251310', 35, 1, 0, 36, 3, '2019-10-21', NULL, NULL, NULL, NULL, NULL, ' 1 PAX COMPARTIDO  EXPEDIA', NULL, NULL, NULL, NULL, 2, '50.00', 2400.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 18:10:58', 8),
(1456, 14, NULL, 'SARAH', 'CABRAL', 'ventas@volarenglobo.com.mx', NULL, '18098385286', 35, 2, 0, 36, 1, '2019-10-12', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD,DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 18:18:00', 0);
INSERT INTO `temp_volar` (`id_temp`, `idusu_temp`, `clave_temp`, `nombre_temp`, `apellidos_temp`, `mail_temp`, `telfijo_temp`, `telcelular_temp`, `procedencia_temp`, `pasajerosa_temp`, `pasajerosn_temp`, `motivo_temp`, `tipo_temp`, `fechavuelo_temp`, `tarifa_temp`, `hotel_temp`, `habitacion_temp`, `checkin_temp`, `checkout_temp`, `comentario_temp`, `otroscar1_temp`, `precio1_temp`, `otroscar2_temp`, `precio2_temp`, `tdescuento_temp`, `cantdescuento_temp`, `total_temp`, `piloto_temp`, `kg_temp`, `tipopeso_temp`, `globo_temp`, `hora_temp`, `idioma_temp`, `comentarioint_temp`, `register`, `status`) VALUES
(1457, 9, NULL, 'YAMILETTE', 'MACHORRO', 'turismo@volarenglobo.com.mx', NULL, '999999999', 11, 1, 0, 36, 3, '2019-10-23', NULL, NULL, NULL, NULL, NULL, '1 PAX EXPLORA Y DESCUBRE', NULL, NULL, NULL, NULL, NULL, '0.00', 1950.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 18:30:29', 8),
(1458, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-18 18:39:44', 0),
(1459, 16, NULL, 'CESAR', 'JIMENEZ', 'cesarjimenez@politubos.com.mx', NULL, '5519900714', NULL, 2, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja / Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '140.00', 1, 0, NULL, 1, NULL, '2019-10-18 18:43:01', 8),
(1460, 16, NULL, 'EDISON', 'CRISTOBAL', 'Edison.cristobal.parraga@gmail.com', NULL, '51994393495', NULL, 2, 0, 36, 1, '2019-10-19', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '148.00', 1, 0, NULL, 1, NULL, '2019-10-18 18:55:54', 8),
(1461, 16, NULL, 'ANA INES', 'VIGNE', 'anavigne@gmail.com', NULL, '5555053939', NULL, 5, 2, NULL, 1, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso y jugo\nCertificado de vuelo\nSeguro viajero\nCoffe break', NULL, NULL, NULL, NULL, NULL, '0.00', 14900.00, 0, '360.00', 1, 0, NULL, 1, NULL, '2019-10-18 19:07:15', 8),
(1462, 16, '1384', 'ANDRES LEONARDO', 'BELTRAN', 'andresbp01@outlook.com', NULL, '50374963029', NULL, 2, 0, 36, 1, '2019-10-19', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break /Transporte redondo: Ãngel de la Independencia', 'TRANSPORTE Y DESAYUN', '640.00', NULL, NULL, 2, '82.00', 6438.00, 0, '130.00', 1, 0, NULL, 1, NULL, '2019-10-18 20:41:29', 8),
(1463, 16, NULL, 'MANUEL', 'SANCHEZ', 'ms@entropylabs.science', NULL, '5529556638', NULL, 4, 0, 36, 1, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 9200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-19 11:37:12', 6),
(1464, 16, '1463', 'MANUEL', 'SANCHEZ', 'ms@entropylabs.science', NULL, '5529556638', NULL, 4, 0, 36, 1, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', 'I.V.A.', '1472.00', NULL, NULL, NULL, '0.00', 10672.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-19 11:40:34', 6),
(1465, 16, NULL, 'FERNANDO', 'BENAVIDES', 'fbenavidesarias@gmail.com', NULL, '50683435959', NULL, 3, 0, 36, 1, '2019-10-24', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, 2, '123.00', 8697.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-19 11:53:04', 8),
(1466, 16, '1464', 'MANUEL', 'SANCHEZ', 'ms@entropylabs.science', NULL, '5529556638', NULL, 3, 1, 36, 1, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', 'I.V.A.', '1376.00', NULL, NULL, NULL, '0.00', 9976.00, 0, '298.00', 1, 0, NULL, 1, NULL, '2019-10-19 12:05:03', 8),
(1467, 9, NULL, 'JULIEN', 'CASTEJON', 'turismo@volarenglobo.com.mx', NULL, '0033673025282', 11, 2, 0, 36, 4, '2019-10-28', NULL, NULL, NULL, NULL, NULL, '2 pax privado conekta ped 4155', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-19 12:06:47', 8),
(1468, 16, NULL, 'BLADIMIR', 'VITE', 'reserva@volarenglobo.com.mx', NULL, '7714036084', NULL, 2, 0, 36, 1, '2019-10-19', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', 'COMPLEMENTO DE VUELO', '1200.00', NULL, NULL, NULL, '0.00', 5800.00, 0, '154.00', 1, 0, NULL, 1, NULL, '2019-10-19 12:17:49', 8),
(1469, 14, NULL, 'ANDREA', 'YAÃ‘EZ', 'andreay810@gmail.com', NULL, '5566737335', NULL, 2, 0, 36, 1, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,  SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-19 12:48:07', 6),
(1470, 14, NULL, 'JORGE  RICARDO', 'MENESES', 'Hr.meneses54@gmail.com', NULL, '5215610485941', 35, 2, 0, 39, 4, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN  SEGURO DE VIAJERO,  BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, DESPLIEGUE DE LONA \"TE QUIERES CASAR CONMIGO \" DESAYUNO BUFFET EN RESTAURANTE Y FOTO IMPRESA ', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-19 12:54:32', 0),
(1471, 14, NULL, 'JORGE', 'GONZÃLEZ ', 'george_gg07@live.com.mx', NULL, '521668236', 35, 2, 0, 38, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 44 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO , CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL DURANTE LA ACTIVIDAD,DESPLIEGUE DE LONA FELIZ CUMPLEAÃ‘OS ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-19 13:03:32', 8),
(1472, 16, NULL, 'FERNANDO', 'GOMEZ', 'ortizyluis@hotmail.com', NULL, '6243586714', NULL, 2, 0, 36, 1, '2019-10-24', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break ', NULL, NULL, NULL, NULL, NULL, '0.00', 5600.00, 0, '145.00', 1, 0, NULL, 1, NULL, '2019-10-19 13:31:05', 8),
(1473, 16, NULL, 'SERAPIO', 'VARGAS', 'serapiovargas@live.com', NULL, '7223949897', NULL, 5, 0, NULL, 1, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 11500.00, 0, '422.00', 1, 0, NULL, 1, NULL, '2019-10-19 14:41:40', 8),
(1474, 16, NULL, 'JOSEPH', 'ERMOFF', 'joe.ermoff@gmail.com', NULL, '8117473838', NULL, 2, 0, 36, 1, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\n', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '153.00', 1, 0, NULL, 1, NULL, '2019-10-19 16:03:41', 4),
(1475, 14, '1469', 'ANDREA', 'YAÃ‘EZ', 'andreay810@gmail.com', NULL, '5566737335', NULL, 2, 0, 36, 4, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,  SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE Y FOTO IMPRESA ', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-19 16:16:26', 8),
(1476, 14, NULL, 'CLAUDIA ', 'ATALAH', 'atalahclaudia@gmail.com', NULL, '50373932148', 35, 2, 0, 37, 4, '2019-12-29', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET Y FOTO IMPRESA ', NULL, NULL, NULL, NULL, NULL, '0.00', 8500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-19 17:39:24', 6),
(1477, 14, NULL, 'MARIO', 'HERNANDEZ ', 'ventas@volarenglobo.com.mx', NULL, '9999', 11, 3, 0, NULL, 1, '2019-10-20', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,  SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL ', NULL, NULL, NULL, NULL, 2, '3.00', 6897.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-19 18:09:10', 8),
(1478, 14, NULL, 'GLENDA', 'BACA', 'glendabh@hotmail.com', NULL, '5215559671808', 11, 2, 0, 36, 1, '2019-10-21', NULL, 1, 25, '2019-10-20', '2019-10-21', 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 6098.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-19 19:05:34', 6),
(1479, 9, NULL, 'CINDY', 'CAMARGO', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-19 20:01:35', 0),
(1480, 9, NULL, 'CINDY', 'CAMARGO', 'omarbaucam93@gmail.com', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-19 20:04:36', 0),
(1481, 9, NULL, 'CINDY', 'CAMARGO', 'omarbaucam93@gmail.com', NULL, '99999', 11, 2, 0, 37, 3, '2019-10-14', NULL, NULL, NULL, NULL, NULL, '2 pax compartido Omar bautista', NULL, NULL, NULL, NULL, NULL, '0.00', 4180.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-19 20:06:10', 8),
(1482, 16, NULL, 'GRACIELA', 'COVELLO', 'estudiocovello@yahoo.com.ar', NULL, '541162044113', NULL, 1, 0, 36, 1, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet\nTransporte CDMX TEOTIHUACÃN', NULL, NULL, NULL, NULL, 2, '41.00', 2899.00, 0, '73.00', 1, 0, NULL, 1, NULL, '2019-10-19 22:02:04', 8),
(1483, 14, NULL, 'ALEJANDRA ', 'GALINDO', 'alejandra.gms09@gmail.com', NULL, '5073124865735', 35, 4, 0, 36, 1, '2019-11-07', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 ADULTOS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN , SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL DURANTE LA ACTIVIDAD Y  DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', NULL, NULL, NULL, NULL, 2, '1200.00', 8560.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-20 12:16:18', 0),
(1484, 14, NULL, 'MARCELA', 'RODRÃGUEZ ', 'marcelareyes@yahoo.com', NULL, '573107652699', 35, 6, 0, 36, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 6 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '594.00', NULL, NULL, NULL, '0.00', 14394.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-20 14:12:23', 6),
(1485, 14, '1478', 'GLENDA', 'BACA', 'glendabh@hotmail.com', NULL, '5215559671808', 11, 2, 0, 36, 1, '2019-10-21', NULL, 1, 25, '2019-10-20', '2019-10-21', 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 6098.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-20 15:32:30', 8),
(1486, 14, NULL, 'ILLIAK', 'CASTRO', 'iliakcastro@gmail.com', NULL, '50257093791', 35, 2, 0, 36, 1, '2019-10-21', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y TRANSPORTE CDMX-TEOTIHUACAN-CDMX TEOTIHUACAN CENTRO ', NULL, NULL, NULL, NULL, 2, '600.00', 5280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-20 15:54:28', 8),
(1487, 14, NULL, 'MAURICIO ', 'HERNÃNDEZ ', 'mauricio_jaubert@hotmail.com', NULL, '50687128427', 35, 2, 0, 36, 1, '2019-10-24', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL Y DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI, TRANSPORTE CDMX-TEOTIHUACAN-CDMX CENTRO ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-20 18:09:36', 0),
(1488, 16, NULL, 'CAROLINA', 'MATEUS', 'cmgcarolina@gmail.com', NULL, '543123514216', NULL, 8, 0, NULL, 4, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo de 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet\nFoto impresa\n', NULL, NULL, NULL, NULL, 2, '5600.00', 22400.00, 0, '526.00', 1, 0, NULL, 1, NULL, '2019-10-20 18:52:36', 6),
(1489, 16, NULL, 'ALEJANDRO', 'MUÃ‘OZ', 'alejo-mg@hotmail.com', NULL, '15145831671', NULL, 2, 0, NULL, 4, '2019-12-07', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo de 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet\nFoto impresa\nDespliegue de lona', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-20 21:06:57', 0),
(1490, 9, NULL, 'LORETO PAOLA', 'OLMEDO', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 4, 0, 36, 3, '2019-10-31', NULL, NULL, NULL, NULL, NULL, '4 pax compartido best day id 74063040-1', NULL, NULL, NULL, NULL, 2, '1240.00', 6560.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-20 21:40:25', 8),
(1491, 9, NULL, 'JOSÃ‰ MIGUEL ', 'FERRER', 'turismo@volarenglobo.com.mx', NULL, '6644772543', NULL, 2, 0, NULL, 3, '2019-10-21', NULL, NULL, NULL, NULL, NULL, 'Pasajeros Turisky L-V ', 'AJUSTE', '200.00', NULL, NULL, NULL, '0.00', 4100.00, 0, '189.00', 1, 0, NULL, 1, 'Pasajeros turibus pasar por ellos a parada zÃ³calo y pedir boletitos ', '2019-10-20 22:41:25', 4),
(1492, 16, NULL, 'ANGELICA', 'BALDERRABANO', 'reserva@volarenglobo.com.mx', NULL, '2331105163', NULL, 2, 0, 36, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-20 22:55:48', 8),
(1493, 14, NULL, 'FIORELLA', 'LOPEZ', 'azofeifalopez@hotmail.com', NULL, '50684126153', 35, 2, 0, 36, 1, '2019-12-23', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX . INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI,TRANSPORTE CDMX-TEOTIHUACAN-CDMX (CENTRO)', 'DESAYUNOS', '198.00', 'DESAYUNO ADICIONAL Y', '640.00', NULL, '0.00', 6438.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 10:19:11', 6),
(1494, 14, NULL, 'DAVID', 'MENA', 'davidmh10@gmail.com', NULL, '573148727915', 35, 3, 0, 36, 1, '2019-11-08', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD , DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 10:30:03', 6),
(1495, 16, '1488', 'HELEN', 'GONGORA', 'gphelen2001@hotmail.com', NULL, '543123514216', NULL, 8, 0, NULL, 4, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo de 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet\nFoto impresa\n', NULL, NULL, NULL, NULL, 2, '5600.00', 22400.00, 0, '526.00', 1, 0, NULL, 1, NULL, '2019-10-21 10:33:09', 8),
(1496, 14, '1494', 'DAVID', 'MENA', 'davidmh10@gmail.com', NULL, '573148727915', 35, 3, 0, 36, 1, '2019-11-08', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD , DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 7197.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 10:34:39', 8),
(1497, 14, NULL, 'HAYDEE', 'PEREZ', 'haydeepzg@gmail.com', NULL, '5520702152', 11, 3, 0, 38, 1, '2019-12-30', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET Y PASTEL PARA CUMPLEAÃ‘ERO', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 7197.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 10:40:22', 3),
(1498, 14, NULL, 'ROMEO JOSE', 'CORDOVA', 'romeocordova84@gmail.com', NULL, '593983312105', 35, 2, 0, 39, 4, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA \"TE QUIERES CASAR CONMIGO\" DESAYUNO EN RESTAURANTE Y FOTOGRAFIA IMPRESA A ELEGIR.', 'ENTRADAS A ZONA ARQU', '150.00', NULL, NULL, NULL, '0.00', 9050.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 10:43:57', 3),
(1499, 9, NULL, 'ELIZABETH ', ' PEZZA', 'turismo@volarenglobo.com.mx', NULL, '15624006739', 11, 2, 0, 36, 3, '2019-11-11', NULL, NULL, NULL, NULL, NULL, '**** 2019-11-11 ****\nâ€ƒâ€ƒTicket Type: Traveler: 2 ()\nâ€ƒâ€ƒPrimary Redeemer: ELIZABETH PEZZA, 15624006739, epezza@gmail.com\nâ€ƒâ€ƒValid Day: Nov 11, 2019\nâ€ƒâ€ƒItem: Teotihuacan Pyramids Hot-Air Balloon Flight / 5:00 AM, Flight with Transportation / 529019\nâ€ƒâ€ƒVoucher: 80551062, 80551064\nâ€ƒâ€ƒItinerary: 7486560280501\nâ€ƒâ€ƒCustomer Staying At: Le Meridien Mexico City; Paseo De La Reforma 69, Mexico City, CDMX \n', NULL, NULL, NULL, NULL, 2, '100.00', 4800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 10:51:47', 8),
(1500, 14, NULL, 'SANDRA', 'GOMEZ', 'S.gomez@une.net.co', NULL, '573187828792', 35, 11, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 10:52:49', 0),
(1501, 14, NULL, 'SANDRA', 'GOMEZ', 'S.gomez@une.net.co', NULL, '573187828792', 35, 11, 0, 38, 1, '2019-12-07', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 11 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\"  DESAYUNO BUFFET Y PASTEL PARA CUMPLEAÃ‘ERO, TRANSPORTE CDMX-TEOTIHUACAN-CDMX (CENTRO) ', 'TRANSPORTE RED CENTR', '3500.00', 'DESAYUNOS ADICIONALE', '420.00', 2, '3300.00', 27460.00, 0, '725.00', 1, 0, NULL, 1, NULL, '2019-10-21 10:58:47', 8),
(1502, 11, NULL, 'KAREN', 'SPORTCITY', 'karen-d-n@hotmail.com', NULL, '5543600188', 17, 2, 0, 36, 1, '2019-10-10', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFEE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD', NULL, NULL, NULL, NULL, 2, '600.00', 4000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 11:34:06', 3),
(1503, 14, NULL, 'KAREM', 'MARTINEZ', 'karemtz01@hotmail.com', NULL, '2293181160', 11, 4, 0, 38, 1, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" Y PASTEL PARA CUMPLEAÃ‘ERO', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 9596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 12:29:53', 3),
(1504, 16, NULL, 'ESTEFANI DANIELA', 'HERNANDEZ', 'dani_hvera@hotmail.com', NULL, '5518229648', NULL, 2, 1, 38, 4, '2019-11-10', NULL, 1, 25, '2019-11-09', '2019-11-10', 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona FELIZ CUMPLE!/ Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 10100.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 12:30:23', 6),
(1505, 14, NULL, 'KAREM', 'MARTINEZ', 'karemtz01@hotmail.com', NULL, '2293181160', 11, 2, 0, 38, 4, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO EN RESTAURANTE , PASTEL PARA CUMPLEAÃ‘ERO  Y FOTOGRAFIA IMPRESA A ELEGIR', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 12:34:03', 3),
(1506, 14, NULL, 'SARA ', 'MARTINEZ', 'saramartinezpa@gmail.com', NULL, '5554510976', 11, 2, 1, 37, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 ADULTOS 1 MENOR, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE, TE , GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD,DESPLIEGUE DE LONA \"FELIZ ANIVERSARIO\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI.', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 6597.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 12:43:26', 6),
(1507, 16, NULL, 'JUAN CARLOS', 'CALDERON', 'xarleemoor09@gmail.com', NULL, '5519804726', NULL, 2, 0, 36, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '125.00', 1, 0, NULL, 1, 'RESERVA CANCELADA POR EL CLIENTE, SE REALIZO REEMBOLSO', '2019-10-21 12:45:14', 0),
(1508, 16, NULL, 'SERGIO', 'RAMIREZ OTERO', 'sergioramirez2525@hotmail.com', NULL, '4422709239', NULL, 2, 0, 39, 4, '2019-11-16', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona TE QUIERES CASAR CONMIGO? / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 12:49:15', 8),
(1509, 16, NULL, 'JULIO CESAR', 'CUPA', 'viajartours.mx@gmail.com', NULL, '5522532806', NULL, 2, 0, 36, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, 2, '320.00', 4280.00, 0, '157.00', 1, 0, NULL, 1, NULL, '2019-10-21 13:43:17', 8),
(1510, 14, '1493', 'FIORELLA', 'LOPEZ', 'azofeifalopez@hotmail.com', NULL, '50684126153', 35, 3, 0, 36, 1, '2019-12-23', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX . INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI,TRANSPORTE CDMX-TEOTIHUACAN-CDMX (CENTRO)', NULL, NULL, NULL, NULL, 2, '900.00', 7920.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 13:51:32', 6),
(1511, 16, NULL, 'ROSA', 'GAMEZ', 'mrosagamez@gmail.com', NULL, '6672737276', NULL, 2, 0, 36, 4, '2019-10-22', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '155.00', 1, 0, NULL, 1, NULL, '2019-10-21 13:52:08', 8),
(1512, 9, NULL, ' GUMERSINDO', ' IDELFONSO ', 'turismo@volarenglobo.com.mx', NULL, '54290115418918', 35, 2, 0, 36, 3, '2019-10-22', NULL, NULL, NULL, NULL, NULL, '2 pax compartido turisky con transporte', NULL, NULL, NULL, NULL, 2, '800.00', 4100.00, 0, '146.00', 1, 0, NULL, 1, NULL, '2019-10-21 13:54:18', 8),
(1513, 14, '1510', 'FIORELLA', 'LOPEZ', 'azofeifalopez@hotmail.com', NULL, '50684126153', 35, 3, 0, 36, 1, '2019-12-24', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX . INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI,TRANSPORTE CDMX-TEOTIHUACAN-CDMX (CENTRO)', NULL, NULL, NULL, NULL, 2, '900.00', 7920.00, 0, '172.00', 1, 0, NULL, 1, NULL, '2019-10-21 13:55:07', 8),
(1514, 16, NULL, 'ISRAEL', 'PACHECO', 'arq_pacheco@live.com.mx', NULL, '9841080470', NULL, 2, 0, 36, 1, '2019-10-22', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 5600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 14:25:13', 6),
(1515, 16, '1514', 'ISRAEL', 'PACHECO', 'arq_pacheco@live.com.mx', NULL, '9841080470', NULL, 2, 0, 36, 5, '2019-10-23', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona FELIZ VUELO / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7500.00, 0, '158.00', 1, 0, NULL, 1, NULL, '2019-10-21 14:31:58', 8),
(1516, 9, NULL, 'ESPIRITU ', 'AVENTURERO 3 NOV', 'producto@espirituaventurero.com.mx', NULL, '99999999', 11, 10, 1, 36, 3, '2019-11-03', NULL, NULL, NULL, NULL, NULL, '10 PAX ADULTOS Y UN MENOR COMPARTIDO ESPIRITU AVENTURERO', NULL, NULL, NULL, NULL, NULL, '0.00', 21200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 14:36:39', 8),
(1517, 16, NULL, 'DIEGO', 'NAVA', '0201892@up.edu.mx', NULL, '5540584295', NULL, 2, 0, NULL, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 14:44:20', 8),
(1518, 16, NULL, 'ANTONIO', 'PEREZ', 'peterpfp@outlook.com', NULL, '8411024351', NULL, 2, 0, 38, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / Despliegue de lona FELIZ CUMPLE!', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 15:06:37', 3),
(1519, 16, NULL, 'RANDALL', 'CHACON', 'crchacon837@hotmail.com', NULL, '50684259141', NULL, 6, 0, 36, 1, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 13800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 15:10:16', 3),
(1520, 14, NULL, 'ZAYDA CRISTINA', 'MORALES', 'ventas@volarenglobo.com.mx', NULL, '5544895286', 11, 2, 0, 38, 1, '2019-11-17', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y PASTEL PARA CUMPLEAÃ‘ERO', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 16:42:41', 8),
(1521, 14, NULL, 'NATALIA', 'GARCIA', 'Mexico.infocenter@gmail.com', NULL, '5219982419346', 35, 8, 3, 36, 4, '2019-12-26', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 8 ADULTOS 3 MENORES  , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR .', NULL, NULL, NULL, NULL, 2, '5339.00', 28061.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 16:49:14', 6),
(1522, 14, '1521', 'NATALIA', 'GARCIA', 'Mexico.infocenter@gmail.com', NULL, '5219982419346', 35, 5, 3, 36, 4, '2019-12-26', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 5 ADULTOS 3 MENORES  , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR .', NULL, NULL, NULL, NULL, 2, '3338.00', 19562.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 17:17:15', 3),
(1523, 9, NULL, 'MAURA CRISTINA', 'CHAVEZ RUIZ', 'Cristi0111@icloud.com', NULL, '5213418797411', 11, 1, 0, 36, 1, '2019-12-31', NULL, NULL, NULL, NULL, NULL, '1 pax compartdo con transporte se agrega a la reserva de luis roman', NULL, NULL, NULL, NULL, NULL, '0.00', 2800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 18:07:48', 8),
(1524, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 18:21:18', 0),
(1525, 14, '1209', 'CATE', '.', 'sartoria2@gmail.com', NULL, '1281902276', 35, 6, 0, 73, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'TRADITIONAL SHARED FLIGHT,  HOT AIRE BALLON 7 PAX FOR 45 MINUTES APROX, TOAST WITH SPARKLIN FREIXENET WINE,PERSONALIZED FLIGHT CERTIFICATE,TRANSPORTATION DURING THE ACTIVITY (CHECK IN AREA-TAKE OFF AREA AND LANDING SITE CHECK IN AREA) , TRAVEL INSURANCE, TRANSPORTATION HOTEL - TEOTIHUACAN- HOTEL , TRADITIONAL BREAKFAST IN RESTAURANT GRAN TEOCALLI (BUFFET SERVICE). ', NULL, NULL, NULL, NULL, 2, '2100.00', 18480.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-10-21 18:23:35', 6),
(1526, 16, NULL, 'JOHN', 'DAVID', 'fource.johndavid@gmail.com', NULL, '50764467516', NULL, 2, 0, 36, 1, '2019-11-29', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break /  ', 'TRANSPORTE REDONDO 5', '2500.00', NULL, NULL, NULL, '0.00', 7100.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 18:31:30', 6),
(1527, 16, NULL, 'JORGE', 'BAUTISTA', 'reserva@volarenglobo.com.mx', NULL, '5568092406', NULL, 2, 0, 36, 1, '2019-10-22', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja / Seguro viajero/ Coffee break ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '150.00', 1, 0, NULL, 1, NULL, '2019-10-21 18:33:57', 8),
(1528, 16, NULL, 'RICARDO', 'VIVAR', 'ricardo.pineda2525@gmail.com', NULL, '5582560468', NULL, 2, 0, 39, 4, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona TE QUIERES CASAR CONMIGO?/ Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '140.00', 1, 0, NULL, 1, NULL, '2019-10-21 18:37:32', 8),
(1529, 16, '1526', 'JOHN', 'DAVID', 'Source.johndavid@gmail.com', NULL, '50764467516', NULL, 2, 0, 36, 1, '2019-11-29', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break /  ', 'TRANSPORTE REDONDO 5', '2500.00', NULL, NULL, NULL, '0.00', 7100.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 18:56:15', 8),
(1530, 9, NULL, 'AURELIO', ' DAVILA DAVILA', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, NULL, 2, '2019-11-24', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO PRICE TREVEL  locator 13409093-1', NULL, NULL, NULL, NULL, NULL, '0.00', 4000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 19:03:55', 8),
(1531, 9, NULL, 'BASTIAN ', ' ILKA ', 'mexico.overseas@overseasmexico.com', NULL, '99999999999', 11, 4, 0, NULL, 3, '2019-10-24', NULL, NULL, NULL, NULL, NULL, '4 pax compartido overseas', NULL, NULL, NULL, NULL, NULL, '0.00', 7800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 19:09:18', 8),
(1532, 9, NULL, 'EDISON', 'OSPINA', 'turismo@volarenglobo.com.mx', NULL, '573167447645', 35, 2, 2, NULL, 1, '2019-12-17', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 ADULTOS 2 MENORES DE 45 MIN APROXIMADAMENTE SOBRE EL VALLE. SEGURO DE VIAJERO. BRINDIS CON VINO ESPUMOSO Y JUGO PARA MENOR . CERTIFICADO PERSONALIZADO', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '200.00', 1, 0, NULL, 1, 'SOLICITAR CARTA DE PAGO POR PAYPAL $1000 PAGO EL 12 DE OCT', '2019-10-21 19:16:02', 4),
(1533, 14, NULL, 'KARLA', 'ROSAS', 'krosas07@hotmail.com', NULL, '5215518413998', 11, 3, 0, 36, 1, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO CERTIFICADO PERSONALIZADO  DESAYUNO BUFFET EN  RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '297.00', NULL, NULL, NULL, '0.00', 7197.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 19:41:47', 8),
(1534, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 19:52:18', 0),
(1535, 14, NULL, 'CATE', '.', 'ventas@volarenglobo.com.mx', NULL, NULL, 35, 6, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 19:52:48', 0),
(1536, 14, '1525', 'CATE', '.', 'sartoria2@gmail.com', NULL, '1281902276', 35, 6, 0, 73, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'TRADITIONAL SHARED FLIGHT,  HOT AIRE BALLON 6 PAX FOR 45 MINUTES APROX, TOAST WITH SPARKLIN FREIXENET WINE,PERSONALIZED FLIGHT CERTIFICATE,TRANSPORTATION DURING THE ACTIVITY (CHECK IN AREA-TAKE OFF AREA AND LANDING SITE CHECK IN AREA) , TRAVEL INSURANCE, TRANSPORTATION  ZOCALO-TEOTIHUACAN- ZOCALO , TRADITIONAL BREAKFAST IN RESTAURANT GRAN TEOCALLI (BUFFET SERVICE). ', 'BREAKFAST', '594.00', 'TRANSPORTATION ZOCAL', '2100.00', NULL, '0.00', 16494.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-10-21 19:54:46', 6),
(1537, 14, '1536', 'CATE', '.', 'sartoria2@gmail.com', NULL, '1281902276', 35, 6, 0, 73, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'TRADITIONAL SHARED FLIGHT,  HOT AIRE BALLON 6 PAX FOR 45 MINUTES APROX, TOAST WITH SPARKLIN FREIXENET WINE,PERSONALIZED FLIGHT CERTIFICATE,TRANSPORTATION DURING THE ACTIVITY (CHECK IN AREA-TAKE OFF AREA AND LANDING SITE CHECK IN AREA) , TRAVEL INSURANCE, TRANSPORTATION  ZOCALO-TEOTIHUACAN- ZOCALO , TRADITIONAL BREAKFAST IN RESTAURANT GRAN TEOCALLI (BUFFET SERVICE). ', 'BREAKFAST', '594.00', 'TRANSPORTATION ZOCAL', '2100.00', NULL, '0.00', 16494.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-10-21 21:27:20', 3),
(1538, 14, NULL, 'CATE', '.', 'ventas@volarenglobo.com.mx', NULL, '2819022716', NULL, 6, 0, 73, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'TRADITIONAL SHARED FLIGHT, HOT AIRE BALLON 6 PAX FOR 45 MINUTES APROX, TOAST WITH SPARKLIN FREIXENET WINE,PERSONALIZED FLIGHT CERTIFICATE,TRANSPORTATION DURING THE ACTIVITY (CHECK IN AREA-TAKE OFF AREA AND LANDING SITE CHECK IN AREA) , TRAVEL INSURANCE, TRANSPORTATION ZOCALO-TEOTIHUACAN- ZOCALO , TRADITIONAL BREAKFAST IN RESTAURANT GRAN TEOCALLI (BUFFET SERVICE).', 'BREAKFAST', '594.00', 'TRANSPORTATION ZOCAL', '2100.00', NULL, '0.00', 16494.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-10-21 21:31:57', 6),
(1539, 14, NULL, 'MARCOS ', 'HERNÃNDEZ ', 'juanmarcoshernandez@yahoo.com', NULL, '50250009320', 35, 3, 0, 36, 1, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,  SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO , CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '297.00', NULL, NULL, NULL, '0.00', 8697.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-21 21:38:12', 8),
(1540, 16, NULL, 'POLETT', 'ANDRADE', 'polansi1999@gmail.com', NULL, '5530817460', NULL, 2, 0, 36, 4, '2019-11-30', NULL, 1, 25, '2019-11-29', '2019-11-30', 'Vuelo en globo exclusivo de 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet\nFoto impresa\nDespliegue de lona', NULL, NULL, NULL, NULL, NULL, '0.00', 8300.00, 0, '140.00', 1, 0, NULL, 1, NULL, '2019-10-21 22:08:12', 8),
(1541, 16, NULL, 'OSIRIS', 'OLASCOAGA', 'oq.osiris@gmail.com', NULL, '2711843839', NULL, 1, 0, 36, 1, '2019-10-24', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break', NULL, NULL, NULL, NULL, NULL, '0.00', 2800.00, 0, '52.00', 1, 0, NULL, 1, NULL, '2019-10-21 22:16:55', 4),
(1542, 9, NULL, 'DANIEL', 'CISNEROS', 'turismo@volarenglobo.com.mx', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 00:00:45', 0),
(1543, 9, NULL, 'DANIEL', 'CISNEROS', 'turismo@volarenglobo.com.mx', NULL, '51991054925', 11, 1, 0, 36, 3, '2019-11-07', NULL, NULL, NULL, NULL, NULL, '1 pax compartido full booking', NULL, NULL, NULL, NULL, 2, '122.50', 3442.50, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 00:05:52', 8),
(1544, 9, NULL, 'MERCEDES  ', ' TYPALDOS ', 'ana@nomadictotem.com', NULL, '99999999', 35, 6, 0, NULL, 3, '2019-11-07', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 6 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.\nDESAYUNO BUFFET.', NULL, NULL, NULL, NULL, 2, '360.00', 12180.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 10:54:34', 8),
(1545, 14, NULL, 'RAYMOND', 'PICHARDO', 'ventas@volarenglobo.com.mx', NULL, '525555668333', 35, 2, 0, 36, 4, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,  DESAYUNO EN RESTAURANTE Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 10:55:10', 8),
(1546, 14, NULL, 'BENITO', 'ENRIQUEZ', 'benitotemible@hotmail.com', NULL, '5538787416', 35, 5, 0, 36, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 5 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '495.00', NULL, NULL, NULL, '0.00', 11995.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 11:13:52', 3),
(1547, 14, NULL, 'MARIBEL', 'ROMAN', 'maribelroman@hotmail.com', NULL, '9987349878', 35, 1, 0, 36, 1, '2019-10-24', NULL, 1, 25, '2019-10-23', '2019-10-24', 'VUELO COMPARTIDO PARA 1 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNO', '99.00', NULL, NULL, NULL, '0.00', 3699.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 11:37:08', 8),
(1548, 16, NULL, 'ANTONIO', 'P', 'peterpfp@outlook.com', NULL, '8411024351', NULL, 2, 0, 36, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 11:53:46', 6),
(1549, 14, NULL, 'VALERIA', 'VARGAS', 'ventas@volarenglobo.com.mx', NULL, '50688717863', 35, 2, 0, NULL, 1, '2019-10-23', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 12:07:50', 8),
(1550, 9, NULL, 'CLEIDE', 'NAKASHIMA', 'turismo@volarenglobo.com.mx', NULL, '999999999999', 35, 20, 0, 36, 3, '2019-10-04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '70.00', 41730.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 12:08:02', 8),
(1551, 14, NULL, 'RAFEL', 'PEÃ‘A', 'joserafaelpena27@hotmail.com', NULL, '5578810116', 11, 2, 0, 36, 1, '2019-10-23', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA DE -------', NULL, NULL, NULL, NULL, 2, '600.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 12:14:16', 3),
(1552, 14, NULL, 'DANIELA', 'HERNANDEZ', 'hsdanni@gmail.com', NULL, '5513040889', 35, 7, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 7 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', NULL, NULL, NULL, NULL, 2, '2100.00', 14980.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 12:21:15', 3),
(1553, 14, NULL, 'DANIELA', 'HERNANDEZ', 'hsdanni@gmail.com', NULL, '5513040899', 35, 7, 0, 36, 4, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 7 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,  DESAYUNO EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, 2, '2800.00', 21700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 12:24:14', 3),
(1554, 14, NULL, 'LAURA', 'CHAVERRI', 'ventas@volarenglobo.com.mx', NULL, '50688717863', 35, 1, 0, 36, 1, '2019-10-23', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNO', '99.00', NULL, NULL, NULL, '0.00', 2899.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 12:31:25', 8),
(1555, 14, NULL, 'MARIA ANTONIETA ', 'MAGAÃ‘A', 'maganaflores@yahoo.com.mx', NULL, '5521787854', 11, 2, 0, 36, 1, '2020-01-31', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 13:13:37', 6),
(1556, 14, NULL, 'DENISE', 'MONCADA', 'denise181998@gmail.com', NULL, '5559063944', 35, 2, 0, 38, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y PASTEL PARA CUMPLEAÃ‘ERO', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 13:31:14', 3),
(1557, 14, NULL, 'ALICIA', 'FUENTES', 'aliciafuenteshp@hotmail.com', NULL, '50376536805', 35, 2, 0, 36, 1, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 13:39:08', 3),
(1558, 16, NULL, 'SUSAN', 'BELLO', 'susan.bello.priego@gmail.com', NULL, '5591855637', NULL, 2, 0, 36, 2, '2019-10-24', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break /', NULL, NULL, NULL, NULL, NULL, '0.00', 4000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 13:53:32', 3),
(1559, 9, NULL, 'KETZALTOUR', 'OCTUBRE ', 'ventas8@ketzaltour.com.mx', NULL, '525555534242', 11, 20, 0, NULL, 3, '2019-10-07', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 20  PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, NULL, '0.00', 39000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 14:03:12', 8),
(1560, 16, NULL, 'VALENTE', 'PADILLA', 'escapebryan@gmail.com', NULL, '5542015833', NULL, 2, 0, 36, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break /', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 14:10:28', 6);
INSERT INTO `temp_volar` (`id_temp`, `idusu_temp`, `clave_temp`, `nombre_temp`, `apellidos_temp`, `mail_temp`, `telfijo_temp`, `telcelular_temp`, `procedencia_temp`, `pasajerosa_temp`, `pasajerosn_temp`, `motivo_temp`, `tipo_temp`, `fechavuelo_temp`, `tarifa_temp`, `hotel_temp`, `habitacion_temp`, `checkin_temp`, `checkout_temp`, `comentario_temp`, `otroscar1_temp`, `precio1_temp`, `otroscar2_temp`, `precio2_temp`, `tdescuento_temp`, `cantdescuento_temp`, `total_temp`, `piloto_temp`, `kg_temp`, `tipopeso_temp`, `globo_temp`, `hora_temp`, `idioma_temp`, `comentarioint_temp`, `register`, `status`) VALUES
(1561, 14, NULL, 'ALEJANDRA', 'GAMEZ', 'Aleja_g8713@hotmail.com', NULL, '573102553347', 35, 2, 0, 36, 1, '2019-11-17', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 14:12:45', 3),
(1562, 16, '1362', 'ISRAEL', 'VIEYRA', 'bart_vieyra@hotmail.com', NULL, '55836996', NULL, 2, 0, 44, 4, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona QUIERES SER MI NOVIA / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', '2 RAMOS DE ROSAS EN ', '600.00', 'CUATRIMOTO PARA 2 PA', '1200.00', NULL, '0.00', 8800.00, 0, '140.00', 1, 0, NULL, 1, NULL, '2019-10-22 14:30:02', 8),
(1563, 14, NULL, 'JORDI', 'RIVAS GUASCH', 'ventas@volarenglobo.com.mx', NULL, '34636017125', 35, 2, 0, 36, 1, '2019-10-23', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, 2, '2.00', 4598.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 14:36:41', 8),
(1564, 9, NULL, 'VIANEY', '27 OCT', 'turismo@volarenglobo.com.mx', NULL, '99999999999', 11, 2, 0, 36, 3, '2019-10-27', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTDO CON TRANSPORTE', NULL, NULL, NULL, NULL, 2, '200.00', 4700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 15:08:47', 0),
(1565, 9, NULL, 'VIANEY', '31 OCT', 'turismo@volarenglobo.com.mx', NULL, '99999999999', 11, 2, 0, NULL, 3, '2019-10-31', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO  CON TRANSPORTE', NULL, NULL, NULL, NULL, 2, '200.00', 4700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 15:16:24', 0),
(1566, 9, NULL, 'CAMILO ANDRES', 'GARCIA', 'turismo@volarenglobo.com.mx', NULL, '99999999999', 11, 2, 0, NULL, 3, '2019-10-23', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO CON TRANSPORTE TURISKY', NULL, NULL, NULL, NULL, 2, '800.00', 4100.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 15:29:46', 8),
(1567, 9, NULL, 'JUDITH ', ' ALEGRE', 'turismo@volarenglobo.com.mx', NULL, '9999999999', 11, 3, 0, 36, 3, '2019-10-23', NULL, NULL, NULL, NULL, NULL, '3 PAX COMPARTIDO TURISKY', 'AJUSTE', '500.00', NULL, NULL, 2, '1200.00', 6650.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 15:38:58', 8),
(1568, 9, NULL, 'ALBERTO', 'ABED', 'auxiliar@volarenglobo.com.mx', NULL, '999999999999', 35, 5, 0, 36, 4, '2019-10-24', NULL, NULL, NULL, NULL, NULL, '5 pax privado con transporte', NULL, NULL, NULL, NULL, 2, '19999.00', 1.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 16:07:07', 0),
(1569, 9, NULL, 'ALBERTO ', 'ABED', 'auxiliar@volarenglobo.com.mx', NULL, '9999999', 35, 5, 0, 36, 16, '2019-10-24', NULL, NULL, NULL, NULL, NULL, '5 pax privado full', NULL, NULL, NULL, NULL, 2, '7275.00', 12200.00, 0, '420.00', 1, 0, NULL, 1, NULL, '2019-10-22 16:16:57', 8),
(1570, 9, NULL, 'LU ', ' XI', 'kaytripdemexico@gmail.com', NULL, '5582217356', 35, 2, 0, 36, 3, '2019-10-23', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nTRANSPORTE REDONDO CDMX-TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.\nDESAYUNO BUFFET.\nENTRADA A ZONA ARQUEOLOGICA', NULL, NULL, NULL, NULL, 2, '230.00', 6000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 17:55:47', 8),
(1571, 14, '1506', 'SARA ', 'MARTINEZ', 'saramartinezpa@gmail.com', NULL, '5554510976', 11, 2, 1, 37, 1, '2019-10-27', NULL, 1, 22, '2019-11-02', '2019-11-03', 'VUELO COMPARTIDO PARA 2 ADULTOS 1 MENOR, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE, TE , GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD,DESPLIEGUE DE LONA \"FELIZ ANIVERSARIO\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI.', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 8047.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 17:57:24', 6),
(1572, 14, NULL, 'LUISANNA', 'RIVERA', 'Luisanna_99@hotmail.com', NULL, '5216591022085', 35, 2, 0, 38, 1, '2019-10-29', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS \" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y PASTEL PARA CUMPLEAÃ‘ERO ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 18:01:21', 3),
(1573, 9, NULL, 'EDINSON', 'ROJAS', 'turismo@volarenglobo.com.mx', NULL, '5552994828', 11, 2, 0, 36, 3, '2019-10-23', NULL, NULL, NULL, NULL, NULL, '2 PAX  COMPARTDO TURISKY CON TRANSPORTE', NULL, NULL, NULL, NULL, 2, '800.00', 4100.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 18:02:30', 8),
(1574, 14, NULL, 'LUISANNA', 'RIVERA', 'Luisanna_99@hotmail.com', NULL, '5216591022085', 35, 2, 0, 38, 4, '2019-10-29', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO EN RESTAURANTE , PASTEL PARA CUMPLEAÃ‘ERO  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 18:08:34', 3),
(1575, 14, NULL, 'SANDRA', 'GOMEZ', 'ventas@volarenglobo.com.mx', NULL, '573187828792', 35, 11, 0, 38, 1, '2019-12-07', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 11 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET Y PASTEL PARA CUMPLEAÃ‘ERO, TRANSPORTE CDMX-TEOTIHUACAN-CDMX (CENTRO) ', 'DESAYUNOS', '420.00', 'TRANSPORTE RED 14 PA', '3500.00', 2, '3300.00', 27460.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 18:23:13', 8),
(1576, 14, NULL, 'RICARDO', 'MEDINA', 'ventas@volarenglobo.com.mx', '5215517974407', '5215517974407', 11, 4, 0, 36, 1, '2019-10-23', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, NULL, '0.00', 9200.00, 0, '265.00', 1, 0, NULL, 1, 'EN SITIO SE LE REALIZÃ“ EL COBRO POR 9,200 CON TC MAS EL 4% DE COMISION POR LO CUAL EN EL SISTEMA HACE FALTA AGREGA $40.00', '2019-10-22 18:30:26', 8),
(1577, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 18:36:01', 0),
(1578, 14, NULL, 'SARA ELIZABETH', 'LEYTE', 'saraelc@hotmail.com', NULL, '5529207473', 11, 2, 0, 36, 1, '2019-12-25', NULL, 1, 25, '2019-12-24', '2019-12-25', 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 6098.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 18:41:55', 3),
(1579, 14, NULL, 'ORALIA', 'MARTINEZ', 'deviajeyaventura@gmail.com', NULL, '5545065243', 35, 20, 0, 36, 1, '2020-02-16', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 20 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ VUELO\"', NULL, NULL, NULL, NULL, 2, '6000.00', 42800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 18:47:14', 3),
(1580, 16, '1548', 'ANDRESA', 'PEREZ', 'peterpfp@outlook.com', NULL, '8411024351', NULL, 2, 0, 36, 4, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 19:08:30', 8),
(1581, 16, NULL, 'CARLOS ', 'BARRON', 'carlosalberto.barron@bbva.com', NULL, '5534960647', NULL, 2, 0, 39, 4, '2019-10-30', NULL, 1, 25, '2019-10-30', '2019-10-31', 'Vuelo en globo exclusivo\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDespliegue de lona Te quieres casar conmigo?\nFoto impresa\nDesayuno buffet', 'TRANSPORTE SOLO IDA', '600.00', NULL, NULL, NULL, '0.00', 8900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 20:36:01', 6),
(1582, 16, NULL, 'ARACELI', 'CORNEJO', 'aracm@att.net.mx', NULL, '5510253814', NULL, 4, 1, 36, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break', NULL, NULL, NULL, NULL, NULL, '0.00', 10900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 21:53:21', 8),
(1583, 16, NULL, 'VICTOR', 'PEÃ‘A', 'reserva@volarenglobo.com.mx', NULL, '5513538732', NULL, 2, 0, 37, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet\nDespliegue de lona Feliz Aniversario!', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '140.00', 1, 0, NULL, 1, NULL, '2019-10-22 22:48:59', 8),
(1584, 14, NULL, 'TARCISIO', 'BRAVO', 'bravo@outlook.com', NULL, '5511950310042', 35, 1, 0, 36, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN , SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y TRANSPORTE CDMX-TEOTIHUACAN-CDMX ( ZOCALO)', 'DESAYUNO ', '99.00', 'TRANSPORTE  ZÃ“CALO ', '350.00', NULL, '0.00', 2749.00, 0, '80.00', 1, 0, NULL, 1, NULL, '2019-10-22 22:51:28', 8),
(1585, 9, NULL, 'MARIA TERESA', 'CAMARGO CAMARGO', 'turismo@volarenglobo.com.mx', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-22 23:09:53', 0),
(1586, 9, NULL, 'MARIA TERESA', 'CAMARGO CAMARGO', 'turismo@volarenglobo.com.mx', NULL, '3138687315', 11, 4, 0, 36, 3, '2019-11-01', NULL, NULL, NULL, NULL, NULL, ' 4 pax compartido booking con transporte', NULL, NULL, NULL, NULL, 2, '400.00', 9400.00, 0, '320.00', 1, 0, NULL, 1, NULL, '2019-10-22 23:11:44', 8),
(1587, 14, NULL, 'REGINA ', 'VIVANCO', 'ventas@volarenglobo.com.mx', NULL, '5513584692', 35, 2, 0, 37, 4, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD LOCAL, DESPLIEGUE DE LONA \"FELIZ ANIVERSARIO\" DESAYUNO BUFFET Y FOTO IMPRESA.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 10:34:32', 8),
(1588, 14, NULL, 'NATALIA', 'BADILLA', 'mailto:natybav95@hotmail.com', NULL, '50684151331', 35, 2, 0, 36, 1, '2019-10-25', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS', '198.00', 'TRANSPORTE ZONA CENT', '700.00', NULL, '0.00', 5498.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 10:47:52', 3),
(1589, 16, NULL, 'OMAR', 'PALOMINO', 'jvelazco@corad.com.mx', NULL, '5534553901', NULL, 2, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', 'PESO EXTRA', '625.00', NULL, NULL, 2, '82.00', 5423.00, 0, '200.00', 1, 0, NULL, 1, NULL, '2019-10-23 11:50:22', 8),
(1590, 14, NULL, 'ALEJANDRA', 'CAMACHO', 'ale41355gabm@gmail.com', NULL, '5584919678', 11, 2, 0, 37, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ ANIVERARIO\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '140.00', 1, 0, NULL, 1, NULL, '2019-10-23 12:02:02', 6),
(1591, 9, NULL, 'KETZALTOUR', 'OCTUBRE ', 'ventas8@ketzaltour.com.mx', NULL, '525555534242', 11, 20, 0, 36, 3, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 20 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.', 'PESO EXTRA', '1537.00', NULL, NULL, NULL, '0.00', 40537.00, 0, '1718.00', 1, 0, NULL, 1, NULL, '2019-10-23 12:27:35', 8),
(1592, 16, NULL, 'KAREN', 'ADLER', 'karadlers@gmail.com', NULL, '5585309717', NULL, 2, 0, 36, 1, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, 2, '2.00', 4598.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 12:44:56', 6),
(1593, 16, '1592', 'KAREN', 'ADLER', 'karadlers@gmail.com', NULL, '5585309717', NULL, 2, 0, 36, 1, '2019-11-16', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 12:50:36', 8),
(1594, 14, NULL, 'OMAR', 'ANDRADE', 'andra7@live.com.mx', NULL, '5540180501', 11, 2, 0, 36, 1, '2019-11-11', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 12:54:29', 3),
(1595, 14, '1590', 'ALEJANDRA', 'CAMACHO', 'ale41355gabm@gmail.com', NULL, '5584919678', 11, 2, 0, 38, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS \" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y PASTEL PARA DOS CUMPLEAÃ‘EROS', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '140.00', 1, 0, NULL, 1, NULL, '2019-10-23 12:58:12', 8),
(1596, 14, NULL, 'PAOLA', 'CALDERON', 'ventas@volarenglobo.com.mx', NULL, '50240168331', 35, 6, 0, 36, 1, '2019-10-24', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 6 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', NULL, NULL, NULL, NULL, 2, '1800.00', 15840.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 13:14:31', 8),
(1597, 9, NULL, 'CINDY', 'CAMARGO', 'turismo@volarenglobo.com.mx', '2', '99999999999', 11, 2, 0, 37, 3, '2019-10-24', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO OMAR BAUTISTA', NULL, NULL, NULL, NULL, NULL, '0.00', 4180.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 13:22:49', 8),
(1598, 16, '1560', 'VALENTE', 'PADILLA', 'escapesbryans@gmail.com', NULL, '5542015833', NULL, 2, 0, 36, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break /', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 13:33:04', 8),
(1599, 9, NULL, 'MAURICIO', 'HERNANDEZ', 'turismo@volarenglobo.com.mx', NULL, '5539156221', 35, 2, 0, NULL, 1, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'PASAJEROS TURISKY L-V, TRANSPORTE REDONDO', NULL, NULL, NULL, NULL, 2, '500.00', 4100.00, 0, '0.00', 1, 0, NULL, 1, 'PEDIR BOLETITOS Y TRANSPORTE REDONDO', '2019-10-23 13:39:51', 0),
(1600, 14, NULL, 'OLGA', 'CALDERON', 'ventas@volarenglobo.com.mx', NULL, '5585586575', 11, 6, 1, 38, 1, '2019-11-10', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 6 ADULTOS 1 MENOR , VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\"  , DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y PASTEL PARA EL CUMPLEAÃ‘ERO ', NULL, NULL, NULL, NULL, 2, '1841.00', 14639.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 13:42:16', 3),
(1601, 9, '1599', 'MAURICIO', 'HERNANDEZ', 'turismo@volarenglobo.com.mx', NULL, '5539156221', 35, 2, 0, NULL, 1, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'PASAJEROS TURISKY L-V, TRANSPORTE REDONDO', 'PESO EXTRA', '75.00', NULL, NULL, 2, '500.00', 4175.00, 0, '0.00', 1, 0, NULL, 1, 'PEDIR BOLETITOS Y TRANSPORTE REDONDO', '2019-10-23 13:44:41', 8),
(1602, 9, NULL, 'ROSA CLEMENCIA', 'CALLE AGUILAR', 'hector@ruizmed.com.mx', NULL, '5510411697', 11, 6, 0, 36, 3, '2019-10-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 6 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, 2, '1200.00', 10500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 13:56:44', 6),
(1603, 16, NULL, 'MARIO', 'CASAS', 'casasteevens_mario@hotmail.com', NULL, '5511512895', NULL, 8, 0, 36, 2, '2019-10-24', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 16000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 13:59:41', 8),
(1604, 16, NULL, 'SERGIO', 'CASTILLO', 'sergio_ibo13@hotmail.com', NULL, '5530787192', NULL, 2, 0, 39, 4, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona TE QUIERES CASAR CONMIGO?/ Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '140.00', 1, 0, NULL, 1, NULL, '2019-10-23 14:14:58', 8),
(1605, 9, NULL, 'DIANE', ' REIFF', 'turismo@volarenglobo.com.mx', NULL, '7608158984', 11, 3, 0, 36, 3, '2019-10-25', NULL, NULL, NULL, NULL, NULL, '3 PAX COMPARTIDO BOOKING CON TRANSPORTE', NULL, NULL, NULL, NULL, 2, '300.00', 7050.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 14:51:07', 8),
(1606, 9, '1155', 'GALLEGO TOURS', 'DOMINGO', 'turismo@volarenglobo.com.mx', NULL, '5580284011', 11, 9, 0, 36, 3, '2019-11-10', NULL, NULL, NULL, '2019-11-10', '2019-11-11', '9 PAX COMPARTIDO  GALLEGOS TOURS CON DESAYUNO', NULL, NULL, NULL, NULL, 2, '90.00', 18720.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 14:53:55', 4),
(1607, 9, NULL, 'GALLEGO TOURS', 'SABADO NOVIEMBRE', 'turismo@volarenglobo.com.mx', NULL, '4424115589', NULL, 12, 0, NULL, 3, '2019-11-09', NULL, NULL, NULL, NULL, NULL, '12 PAX COMPARTIDO GGALEGO TOURS CON DESAYUNO', NULL, NULL, NULL, NULL, 2, '120.00', 24960.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 14:56:53', 4),
(1608, 16, NULL, 'LUZ ADRIANA', 'FIGUEROA', 'lafs82@hotmail.com', NULL, '573006358156', NULL, 2, 0, 36, 1, '2019-12-01', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n /Transporte redondo CDMX recojo en hotel y regreso a BÃ¡silica', NULL, NULL, NULL, NULL, 2, '82.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 15:13:42', 3),
(1609, 9, NULL, 'TONA', '22 PAX', 'tonatiuh.cervantes@gmail.com', NULL, '5544228234', NULL, 22, 0, NULL, 3, '2019-10-25', NULL, NULL, NULL, NULL, NULL, 'PASAJEROS GRUPO 22 PAX TONA GORLAS TOURS ($1900 POR PAX) SOLO VUELO', NULL, NULL, NULL, NULL, 2, '1100.00', 41800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 15:19:34', 8),
(1610, 14, NULL, 'DANIEL ', 'RODRIGUEZ ', 'daro0723@gmail.com', NULL, '5574236241', 11, 2, 0, 39, 4, '2019-10-25', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA \"TE QUIERES CASAR CONMIGO\" DESAYUNO EN RESTAURANTE Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 15:23:30', 3),
(1611, 14, NULL, 'GABRIELA ', 'ROBLES ', 'andrea_primadedurango@live.com.mx', NULL, '5525031601', 11, 2, 1, 38, 4, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 ADULTOS 1 MENOR  , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA \" FELIZ CUMPLEAÃ‘OS\"  DESAYUNO EN RESTAURANTE , PASTEL PARA CUMPLEAÃ‘ERO  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, 2, '1.00', 8799.00, 0, '193.00', 1, 0, NULL, 1, NULL, '2019-10-23 15:39:55', 8),
(1612, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 15:42:57', 0),
(1613, 14, NULL, 'LIZETH', 'BARRERA', 'lizpatbar@hotmail.com', NULL, '573132516299', 35, 2, 2, 36, 1, '2019-11-13', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 ADULTOS Y 2 MENORES, PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO. ', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 15:53:14', 6),
(1614, 14, NULL, 'KELLY', 'DURAN', 'reservasq2@organizacionsorrento.com', NULL, '573502957544', 35, 2, 0, 36, 1, '2019-11-12', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 15:56:37', 3),
(1615, 14, NULL, 'KELLY', 'DURAN', 'reservasq2@organizacionsorrento.com', NULL, '573502957544', 35, 2, 0, 36, 4, '2019-11-12', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA, DESAYUNO EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 15:59:55', 3),
(1616, 16, NULL, 'BANJAMIN', 'XUCHITL', 'Padrinobenja@hotmail.com', NULL, '2381034658', NULL, 2, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 16:17:19', 6),
(1617, 14, NULL, 'MARIA ELENA', 'HERNANDEZ', 'mehernandezx@gmail.com', NULL, '5544438993', 11, 7, 0, 36, 1, '2019-10-24', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 7 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', NULL, NULL, NULL, NULL, 2, '2100.00', 18480.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 16:26:18', 6),
(1618, 16, NULL, 'PAOLA', 'GONZALEZ', 'alcocer_36@hotmail.com', NULL, '4591049321', NULL, 2, 0, 36, 1, '2019-11-14', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 16:30:27', 6),
(1619, 16, '1618', 'PAOLA', 'GONZALEZ', 'alcocer_36@hotmail.com', NULL, '4591049321', NULL, 2, 0, 36, 1, '2019-11-24', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 16:32:02', 3),
(1620, 14, NULL, 'ELIZABETH', 'AMAYA ', 'eli_amaya_bastida@hotmail.com', NULL, '5517055291', 11, 2, 1, 37, 1, '2020-04-18', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ ANIVERSARIO\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 6597.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 16:47:49', 3),
(1621, 14, NULL, 'ALCIRA', 'SALAMANCA', 'alcira.salamanca@gmail.com', NULL, '573016607938', 35, 4, 0, 36, 1, '2020-01-23', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA , DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 9596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 16:53:42', 3),
(1622, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 16:57:48', 0),
(1623, 16, NULL, 'MARCELA', 'GONZALEZ', 'Machego26@hotmail.com', NULL, '573008920042', NULL, 1, 0, 36, 1, '2019-10-24', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', 'TRANSPORTE, DESAYUNO', '715.00', NULL, NULL, 2, '300.00', 3430.00, 0, '63.00', 1, 0, NULL, 1, NULL, '2019-10-23 17:11:26', 8),
(1624, 14, '1617', 'MARIA ELENA', 'HERNANDEZ', 'mehernandezx@gmail.com', NULL, '5544438993', 11, 7, 0, 36, 1, '2019-10-24', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 7 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', NULL, NULL, NULL, NULL, 2, '2100.00', 20505.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 17:14:13', 3),
(1625, 9, NULL, 'BERTHA GRISSEL', 'RUIZ', 'turismo@volarenglobo.com.mx', NULL, '5533679454', 11, 2, 0, 36, 3, '2019-11-01', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO BESTDAY ID 74050582-1 ', NULL, NULL, NULL, NULL, 2, '620.00', 3280.00, 0, '160.00', 1, 0, NULL, 1, NULL, '2019-10-23 17:33:18', 8),
(1626, 14, '1571', 'SARA ', 'MARTINEZ', 'saramartinezpa@gmail.com', NULL, '5554510976', 11, 2, 1, 37, 1, '2019-11-03', NULL, 1, 22, '2019-11-02', '2019-11-03', 'VUELO COMPARTIDO PARA 2 ADULTOS 1 MENOR, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE, TE , GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD,DESPLIEGUE DE LONA \"FELIZ ANIVERSARIO\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI.', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 8047.00, 0, '171.00', 1, 0, NULL, 1, NULL, '2019-10-23 17:47:39', 8),
(1627, 9, NULL, 'MARIA FERNANDA', 'HERNANDEZ MONTERO', 'direccion@huellasmexicanas.com.mx', NULL, '5576631175', NULL, 2, 0, NULL, 16, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO 2 PAX DE 45 MIN. APROXIMADO SOBRE EL VALLE DE TEOTIHUACÃN, COFFEE BREAK ANTES DE VUELO, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET DESPUES DE VUELO.', NULL, NULL, NULL, NULL, NULL, '0.00', 6000.00, 0, '120.00', 1, 0, NULL, 1, 'PASAJEROS OPERADOR HUELLAS MEXICANAS', '2019-10-23 17:50:03', 0),
(1628, 14, NULL, 'CARLOS', 'GUZMAN', 'travelcarlosmx@gmail.com', NULL, '443771776', 35, 2, 0, 36, 4, '2019-11-14', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '136.00', 1, 0, NULL, 1, NULL, '2019-10-23 17:54:25', 8),
(1629, 14, NULL, 'CARLOS', 'GUZMAN', 'travelcarlosmx@gmail.com', NULL, '4433771776', 35, 2, 0, 36, 1, '2019-11-15', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, 2, '600.00', 4000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 17:59:58', 3),
(1630, 9, NULL, 'ALFREDO ', 'TORAL', 'turismo@volarenglobo.com.mx', NULL, '4260469', 11, 2, 0, 36, 1, '2019-10-24', NULL, NULL, NULL, NULL, NULL, '2 PAX CONEKTA PED 4192', NULL, NULL, NULL, NULL, 2, '2.00', 4598.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 18:12:01', 8),
(1631, 14, NULL, 'CARMEN', 'BELLATRIZ', 'bellatrizc@gmail.com', NULL, '5215581007574', 11, 2, 2, 38, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI , PASTEL PARA CUMPLEAÃ‘ERO ', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 8396.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 18:13:17', 3),
(1632, 14, NULL, 'CARMEN', 'BELLATRIZ', 'bellatrizc@gmail.com', NULL, '5215581007574', 11, 2, 2, 38, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \" FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET Y PASTEL PARA CUMPLEAÃ‘ERO ', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 10396.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-23 18:17:58', 3),
(1633, 16, NULL, 'JOHN', 'MIRANDA', 'jhon.mirandao@gmail.com', NULL, '7135014838', NULL, 4, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet', NULL, NULL, NULL, NULL, 2, '960.00', 8800.00, 0, '270.00', 1, 0, NULL, 1, NULL, '2019-10-23 21:43:22', 6),
(1634, 16, NULL, 'MARTIN', 'RODRIGUEZ', 'frutaplaga33@gmail.com', NULL, '5492235171570', NULL, 2, 0, 36, 2, '2019-10-24', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet\nTransporte redondo\nHostal Regina Cdmx', 'DESAYUNO', '250.00', NULL, NULL, NULL, '0.00', 5250.00, 0, '140.00', 1, 0, NULL, 1, 'Debe pagar $300 dÃ³lares descontando $1000 pesos de anticipo y tomÃ¡ndolo a 17.50 por favor', '2019-10-23 22:32:01', 8),
(1635, 11, NULL, 'MARIA MONICA', 'TORO GAITAN', 'maria.1101@hotmail.com', NULL, '573212117787', 35, 2, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'INCLUYE\nVUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS\nCOFFE BREAK\nBRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET\nCERTIFICADO DE VUELO\nSEGURO DE VIAJERO DURANTE LA ACTIVIDAD\n', NULL, NULL, NULL, NULL, 2, '600.00', 4280.00, 0, '125.00', 1, 0, NULL, 1, NULL, '2019-10-23 22:54:46', 8),
(1636, 9, NULL, 'JULIO', 'EXEQUIEL', 'turismo@volarenglobo.com.mx', NULL, '529981168243', 35, 1, 0, 36, 3, '2019-10-27', NULL, NULL, NULL, NULL, NULL, '1 pax compartido puro vuelo trip advisor', NULL, NULL, NULL, NULL, NULL, '0.00', 1950.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 01:17:33', 8),
(1637, 14, NULL, 'KIARA PATRICIA', 'CAMPOS', 'Kiarita.1988@hotmail.com', NULL, '5577851267', 35, 2, 0, 36, 4, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 10:24:18', 6),
(1638, 9, NULL, 'CLAIRE ', ' DAIGNEAULT', 'turismo@volarenglobo.com.mx', NULL, '5148038081', 35, 1, 0, NULL, 3, '2019-10-31', NULL, NULL, NULL, NULL, NULL, '1 pax compartido booking con transporte', NULL, NULL, NULL, NULL, 2, '100.00', 2350.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 10:31:04', 8),
(1639, 16, '1633', 'JOHN', 'MIRANDA', 'jhon.mirandao@siemens.com', NULL, '7135014838', NULL, 4, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet', NULL, NULL, NULL, NULL, 2, '960.00', 8800.00, 0, '270.00', 1, 0, NULL, 1, NULL, '2019-10-24 10:39:05', 6),
(1640, 14, NULL, 'DORA GIRESSE', 'VERA', 'dorami92-15@hotmail.com', NULL, '593992071026', 35, 2, 0, 36, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE LOCA  DURANTE LA ACTIVIDAD, DESPLIEGUE DE LONA, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 11:34:00', 3),
(1641, 14, NULL, 'DORA GIRESSE', 'VERA', 'dorami92-15@hotmail.com', NULL, '593992071026', 35, 2, 0, 36, 4, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA , DESAYUNO EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 11:39:37', 3),
(1642, 14, NULL, 'PAULA MARIA', 'FIGUEROA ', 'Maria20fm@gmail.com', NULL, '50250196304', 35, 3, 0, 36, 1, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ,TRANSPORTE CDMX-TEOTIHUACAN-CDMX (CENTRO)', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 8697.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 11:53:46', 8),
(1643, 16, '1616', 'BANJAMIN', 'XUCHITL', 'Padrinobenja@hotmail.com', NULL, '2381034658', NULL, 3, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 6900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 12:35:53', 6),
(1644, 16, '1639', 'JOHN', 'MIRANDA', 'jhon.miranda@siemens.com', NULL, '7135014838', NULL, 4, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet', NULL, NULL, NULL, NULL, 2, '960.00', 10000.00, 0, '270.00', 1, 0, NULL, 1, NULL, '2019-10-24 12:47:43', 8),
(1645, 14, NULL, 'ANA CAROLINA', 'VARGAS', 'ventas@volarenglobo.com.mx', NULL, '50683644186', 35, 4, 1, 36, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 ADULTOS 1 MENOR , VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI, TRANSPORTE CDMX-TEOTIHUACAN-CDMX (CENTRO) ', 'DESAYUNOS', '495.00', NULL, NULL, NULL, '0.00', 13895.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 13:01:37', 8),
(1646, 16, NULL, 'LUIS CAMILO', 'ARIZA', 'luis.camilo.ariza@gmail.com', NULL, '5540276551', NULL, 2, 0, 36, 1, '2019-11-16', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 13:34:50', 8),
(1647, 16, NULL, 'ANDREA', 'ULATE', 'reserva@volarenglobo.com.mx', NULL, '50672732945', NULL, 4, 0, 36, 1, '2019-10-30', NULL, NULL, NULL, NULL, NULL, NULL, 'PESO EXTRA', '550.00', NULL, NULL, 2, '164.00', 12146.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 14:18:02', 8),
(1648, 14, NULL, 'KARINA ', 'SANDON', 'Kari1909@hotmail.com', NULL, '573024652598', 35, 6, 0, 38, 1, '2019-11-12', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 6 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI , PASTEL PARA CUMPLEAÃ‘ERA', NULL, NULL, NULL, NULL, 2, '1800.00', 12840.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 14:18:40', 6),
(1649, 16, NULL, 'JESUS', 'LEAL', 'reserva@volarenglobo.com.mx', NULL, '8448692894', NULL, 3, 1, NULL, 1, '2019-10-31', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 8600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 14:24:41', 8),
(1650, 16, NULL, 'ALBA', 'CABEZAS', 'reserva@volarenglobo.com.mx', NULL, '999560801', NULL, 4, 0, 36, 4, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, 2, '1000.00', 15000.00, 0, '295.00', 1, 0, NULL, 1, NULL, '2019-10-24 14:28:26', 8),
(1651, 9, NULL, 'SHIRLEY ZARATE Y HERNANDO MURCIA', 'SHIRLEY ', 'szarate@indoamericana.edu.co', NULL, '18569384679', 11, 2, 0, 37, 4, '2019-10-29', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO  2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.\nDESAYUNO BUFFET.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 14:29:59', 8),
(1652, 14, '1648', 'KARINA ', 'SANDON', 'Kari1909@hotmail.com', NULL, '573024652598', 35, 6, 0, 38, 1, '2019-11-12', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 6 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" ', NULL, NULL, NULL, NULL, NULL, '0.00', 13800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 14:30:06', 3),
(1653, 14, NULL, 'CARLOS', 'LEAL', 'Josealbetoh@gmail.com', NULL, '5565791742', 35, 6, 0, 36, 1, '2019-10-30', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 6 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, NULL, '0.00', 13800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 14:34:28', 6),
(1654, 16, NULL, 'DIANA', 'VELEZ', 'reserva@volarenglobo.com.mx', NULL, '5537332651', NULL, 4, 0, 36, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, 2, '164.00', 9596.00, 0, '275.00', 1, 0, NULL, 1, NULL, '2019-10-24 14:38:30', 8),
(1655, 14, NULL, 'DENISSE ALEJANDRA', 'CAZARES', 'yaha_denis@hotmail.com', NULL, '6641285915', 35, 4, 0, 36, 1, '2020-01-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 9596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 14:47:36', 3),
(1656, 16, NULL, 'ALEJANDRA', 'JIMENEZ', 'reserva@volarenglobo.com.mx', NULL, '3015022545', NULL, 4, 0, 36, 4, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, 2, '1000.00', 15000.00, 0, '276.00', 1, 0, NULL, 1, NULL, '2019-10-24 14:49:42', 8),
(1657, 16, NULL, 'JOHANA', 'HERNANDEZ', 'reserva@volarenglobo.com.mx', NULL, '593984981991', NULL, 3, 0, 38, 1, '2019-11-09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 9320.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 15:06:31', 8),
(1658, 16, '1420', 'JOHANA', 'VENTOCILLA', 'j.ventocilla@pucp.pe', NULL, '51943727478', NULL, 3, 0, 36, 1, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 8400.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 15:22:08', 8),
(1659, 14, NULL, 'HUMBERTO', 'REYNOSO', 'ahreynoso@gmail.com', NULL, '5530864797', 11, 2, 0, 36, 4, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '130.00', 1, 0, NULL, 1, NULL, '2019-10-24 15:28:13', 8),
(1660, 14, NULL, 'DANIELA', 'BENITEZ', 'danitabg@hotmail.com', NULL, '5551804130', 11, 8, 2, 38, 1, '2019-11-30', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 8 ADULTOS 2 MENORES , VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI  Y PASTEL PARA CUMPLEAÃ‘ERO ', NULL, NULL, NULL, NULL, 2, '2482.00', 20718.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 16:30:47', 6),
(1661, 14, '1555', 'MARIA ANTONIETA ', 'MAGAÃ‘A', 'maganaflores@yahoo.com.mx', NULL, '5521787854', 11, 2, 0, 36, 1, '2020-01-31', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 16:40:47', 3),
(1662, 16, NULL, 'MARIA ALEJANDRA', 'COLLAZOS', 'Covieshe@hotmail.com', NULL, '5559043215', NULL, 2, 0, 38, 4, '2019-10-25', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '155.00', 1, 0, NULL, 1, NULL, '2019-10-24 16:48:14', 8);
INSERT INTO `temp_volar` (`id_temp`, `idusu_temp`, `clave_temp`, `nombre_temp`, `apellidos_temp`, `mail_temp`, `telfijo_temp`, `telcelular_temp`, `procedencia_temp`, `pasajerosa_temp`, `pasajerosn_temp`, `motivo_temp`, `tipo_temp`, `fechavuelo_temp`, `tarifa_temp`, `hotel_temp`, `habitacion_temp`, `checkin_temp`, `checkout_temp`, `comentario_temp`, `otroscar1_temp`, `precio1_temp`, `otroscar2_temp`, `precio2_temp`, `tdescuento_temp`, `cantdescuento_temp`, `total_temp`, `piloto_temp`, `kg_temp`, `tipopeso_temp`, `globo_temp`, `hora_temp`, `idioma_temp`, `comentarioint_temp`, `register`, `status`) VALUES
(1663, 14, NULL, 'YESENIA', 'MUÃ‘OZ', 'admin@kantatiry.com', NULL, '51958797460', 35, 2, 0, 36, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI, TRANSPORTE CDMX-TEOTIHUACAN-CDMX (CENTRO)', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 17:09:21', 6),
(1664, 16, NULL, 'ELIANA', 'MEJIA', 'mejia09@hotmail.com', NULL, '573143228671', NULL, 4, 0, 36, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 9200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 17:13:37', 6),
(1665, 16, '1410', 'LEYLA', 'VAZQUEZ', 'leyla_2590@hotmail.com', NULL, '8711325247', NULL, 2, 0, NULL, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', 'TRANSPORTE SOLO IDA', '600.00', NULL, NULL, 2, '82.00', 5398.00, 0, '163.00', 1, 0, NULL, 1, NULL, '2019-10-24 17:18:43', 8),
(1666, 16, '1664', 'ELIANA', 'MEJIA', 'Eli_mejia09@hotmail.com', NULL, '573143228671', NULL, 4, 0, 36, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 9200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 17:32:07', 6),
(1667, 16, NULL, 'ROY', 'SEGURA', 'reserva@volarenglobo.com.mx', NULL, '50689184568', NULL, 2, 0, 36, 1, '2019-12-22', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 17:42:48', 8),
(1668, 14, '1660', 'DANIELA', 'BENITEZ', 'danitabg@hotmail.com', NULL, '5551804130', 11, 8, 2, 38, 1, '2019-11-30', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 8 ADULTOS 2 MENORES , VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI  Y PASTEL PARA CUMPLEAÃ‘ERO ', 'DESAYUNOS', '990.00', NULL, NULL, 2, '2399.00', 20391.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 17:45:50', 3),
(1669, 14, '1663', 'YESENIA', 'MUÃ‘OZ', 'admin@kantatiry.com', NULL, '51958797460', 35, 2, 0, 36, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI, TRANSPORTE CDMX-TEOTIHUACAN-CDMX (CENTRO)', NULL, NULL, NULL, NULL, 2, '600.00', 5280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 18:11:11', 8),
(1670, 14, NULL, 'GERARDO', 'RAMIREZ', 'mailto:Zetactus@gmail.com', NULL, '5568051070', 11, 2, 0, 38, 1, '2019-10-29', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI, PASTEL PARA CUMPLEAÃ‘ERO', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 18:27:34', 3),
(1671, 14, NULL, 'JONATHAN', 'CHINEY', 'chineyjhon@hotmail.com', NULL, '5215540388402', 11, 2, 1, 36, 1, '2019-12-26', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 ADULTOS 1 MENOR, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI .', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 6597.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 18:45:59', 3),
(1672, 16, NULL, 'LUIS PEDRO', 'BERMEJO', 'lpbermejo@bermejo-bermejo.com', NULL, '50257454202', NULL, 2, 0, 36, 1, '2019-11-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 18:46:00', 6),
(1673, 16, '1581', 'CARLOS ', 'BARRON', 'carlosalberto.barron@bbva.com', NULL, '5534960647', NULL, 2, 0, 39, 4, '2019-10-30', NULL, 1, 25, '2019-10-30', '2019-10-31', 'Vuelo en globo exclusivo\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDespliegue de lona Te quieres casar conmigo?\nFoto impresa\nDesayuno buffet', 'TRANSPORTE SOLO IDA', '600.00', NULL, NULL, NULL, '0.00', 8900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 18:50:45', 8),
(1674, 9, NULL, 'ALEJANDRO', 'PELAEZ  HERNANDEZ', 'omarbaucam93@gmail.com', NULL, '4425076908', 11, 2, 0, 39, 3, '2019-10-27', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO OMAR BAUTISTA ', NULL, NULL, NULL, NULL, NULL, '0.00', 4400.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 18:52:32', 8),
(1675, 9, NULL, 'RODOLFO', 'GAMBOA', 'reservaciones1@kaanatours.com.mx', NULL, '5529458673', NULL, 2, 0, NULL, 3, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MIN. APROX. SOBRE VALLE DE TEOTIHUACAN.\nCOFFEE BREAK ANTES DE VUELO. \nSEGURO DE VIAJERO. \nBRINDIS CON VINO ESPUMOSO. \nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, NULL, '0.00', 3900.00, 0, '140.00', 1, 0, NULL, 1, NULL, '2019-10-24 18:55:48', 8),
(1676, 16, '1672', 'LUIS PEDRO', 'BERMEJO', 'lpbermejo@bermejo-bermejo.com', NULL, '50257454202', NULL, 2, 0, 36, 1, '2019-11-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 5600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-24 18:58:05', 8),
(1677, 18, '1176', 'ALBERTO', 'MEZA', 'volarenglobo@yahoo.es', NULL, '50688120525', 35, 9, 0, 43, 4, '2019-10-25', NULL, NULL, NULL, NULL, NULL, 'INCLUYE:\n- VUELO PANORAMICO SOBRE EL VALLE DE TEOTIHUACAN. \n- COFFEE BREAK. \n- BRINDIS CON VINO ESPUMOSO. \n- CERTIFICADO PERSONALIZADO. \n- SEGURO DE VIAJERO. \n- DESAYUNO TIPO BUFFET. \n- FOTO IMPRESA.', NULL, NULL, NULL, NULL, 2, '2600.00', 25600.00, 0, '590.00', 1, 0, NULL, 1, NULL, '2019-10-24 19:16:00', 0),
(1678, 18, '1677', 'ALBERTO', 'MEZA', 'volarenglobo@yahoo.es', NULL, '50688120525', 35, 9, 0, 43, 4, '2019-10-25', NULL, NULL, NULL, NULL, NULL, 'INCLUYE:\n- VUELO PANORAMICO SOBRE EL VALLE DE TEOTIHUACAN. \n- COFFEE BREAK. \n- BRINDIS CON VINO ESPUMOSO. \n- CERTIFICADO PERSONALIZADO. \n- SEGURO DE VIAJERO. \n- DESAYUNO TIPO BUFFET. \n- FOTO IMPRESA.', NULL, NULL, NULL, NULL, 2, '2600.00', 25600.00, 0, '590.00', 1, 0, NULL, 1, NULL, '2019-10-24 19:29:28', 4),
(1679, 18, NULL, 'ALBERTO', 'MEZA', 'karlopezna@yahoo.com', NULL, '50688120525', 35, 9, 0, 43, 4, '2019-10-25', NULL, NULL, NULL, NULL, NULL, 'El vuelo te incluye:\n\n- Coffee break\n- Brindis con vino espumoso.\n- Certificado personalizado \n- Seguro de viajero.\n- Despliegue de lona \"Feliz vuelo\"\n- Desayuno tipo Buffet.\n-  1 Foto impresa.', NULL, NULL, NULL, NULL, 2, '2700.00', 28800.00, 0, '646.00', 1, 0, NULL, 1, 'Cambio de reservacion debido a que, se agrego un pasajero ', '2019-10-24 19:29:57', 4),
(1680, 16, '1666', 'ELIANA', 'MEJIA', 'Eli_mejia09@hotmail.com', NULL, '573143228671', NULL, 4, 0, 36, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 11200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 00:09:21', 6),
(1681, 9, NULL, 'EDER', 'ALCANTARA', 'turismo@volarenglobo.com.mx', NULL, '0', NULL, 2, 0, NULL, 16, '2019-11-24', NULL, NULL, NULL, NULL, NULL, 'Price Travel 2 pax privado 13443381-1', NULL, NULL, NULL, NULL, 2, '200.00', 5800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 00:23:34', 8),
(1682, 9, NULL, 'JAYME', 'TAYLOR', 'turismo@volarenglobo.com.mx', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 00:50:35', 0),
(1683, 9, NULL, 'JAYME', 'TAYLOR', 'turismo@volarenglobo.com.mx', NULL, '3604401682', NULL, 3, 0, 36, 3, '2019-11-05', NULL, NULL, NULL, NULL, NULL, '3 pax compartido trip advisor  puro vuelo', NULL, NULL, NULL, NULL, NULL, '0.00', 5850.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 00:51:50', 8),
(1684, 9, NULL, 'JAYME', 'TAILOR', 'turismo@volarenglobo.com.mx', NULL, '13604401682', 35, 3, 0, NULL, 3, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'Nombre del tour: Basic Shared Flight - Balloon Flying\nFecha del viaje: Tue, Nov 05, 2019\nNombre del viajero principal: Jayme Taylor\nNombres de los viajeros: Jayme Taylor, Blair Brown, Nicole Griffith\nViajeros: 3 Adults\nCÃ³digo del producto: 177648P1\nCalificaciÃ³n del tour: Basic Shared Flight 06:00\nCÃ³digo de la calificaciÃ³n del tour: TG1~06:00\nIdioma del tour: English - Guide\nUbicaciÃ³n: San MartÃ­n Centro, Mexico\nPrecio neto: USD $360.00\nPesos de los pasajeros: Jayme Taylor: 79.4 kgs\nDate of Birth: 10/20/1987, 2/3/1988, 2/19/1987\nRequisitos especiales: No\nTelÃ©fono: (Alternate Phone)US+â€ª1  EnvÃ­ele un mensaje al cliente.', NULL, NULL, 'AJUSTE DOLAR', '270.00', NULL, '0.00', 6120.00, 0, '0.00', 1, 0, NULL, 1, 'Reserva Tripadvisor vuelo bÃ¡sico pagan $360 dolares', '2019-10-25 01:19:17', 0),
(1685, 14, '1538', 'CATE', '.', 'ventas@volarenglobo.com.mx', NULL, '2819022716', NULL, 6, 0, 73, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'TRADITIONAL SHARED FLIGHT, HOT AIRE BALLON 6 PAX FOR 45 MINUTES APROX, TOAST WITH SPARKLIN FREIXENET WINE,PERSONALIZED FLIGHT CERTIFICATE,TRANSPORTATION DURING THE ACTIVITY (CHECK IN AREA-TAKE OFF AREA AND LANDING SITE CHECK IN AREA) , TRAVEL INSURANCE , TRADITIONAL BREAKFAST IN RESTAURANT GRAN TEOCALLI (BUFFET SERVICE).', 'BREAKFAST', '594.00', NULL, NULL, NULL, '0.00', 14394.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-10-25 10:33:02', 8),
(1686, 14, '1484', 'MARCELA', 'RODRÃGUEZ ', 'marcelareyes@yahoo.com', NULL, '573107652699', 35, 6, 0, 36, 1, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 6 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', NULL, NULL, NULL, NULL, 2, '1800.00', 12840.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 11:00:51', 6),
(1687, 16, NULL, 'READ', 'WHITNEY', 'rtwhit730@gmail.com', NULL, '6014154557', NULL, 5, 0, 36, 16, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 15000.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-10-25 11:11:26', 6),
(1688, 9, NULL, 'ROJO', 'SIDETRACK', 'turismo@volarenglobo.com.mx', NULL, '9999999999', 11, 4, 0, 36, 16, '2019-10-26', NULL, NULL, NULL, NULL, NULL, '4 pax privado', NULL, NULL, NULL, NULL, NULL, '0.00', 12000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 11:15:24', 8),
(1689, 14, '1686', 'MARCELA', 'GARCIA', 'ventas@volarenglobo.com.mx', NULL, '573107652699', 35, 6, 0, 36, 1, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 6 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', NULL, NULL, NULL, NULL, 2, '1800.00', 12840.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 11:23:23', 8),
(1690, 16, '1687', 'READ', 'WHITNEY', 'rtwhit730@gmail.com', NULL, '6014154557', NULL, 6, 0, 36, 16, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, 2, '1000.00', 17000.00, 0, '510.00', 1, 0, NULL, 2, NULL, '2019-10-25 11:32:17', 8),
(1691, 14, NULL, 'ROBERTO', 'FERNANDEZ', 'ventas@volarenglobo.com.mx', NULL, '2224424970', 35, 2, 0, 38, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA\"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET  Y PASTEL PARA CUMPLEAÃ‘ERO', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 11:37:28', 8),
(1692, 14, NULL, 'AMANDA GRETCHEN', 'MEDINA', 'medina.amandag@gmail.com', NULL, '5535558903', 35, 4, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 9596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 11:47:50', 3),
(1693, 14, NULL, 'NOE', 'GUERRERO', 'n.guerreroh@hotmail.com', NULL, '5214422701570', 11, 2, 0, 38, 4, '2019-10-29', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA\"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 12:12:12', 3),
(1694, 16, NULL, 'GABRIELA', 'BLANCO', 'reserva@volarenglobo.com.mx', NULL, '5566598532', NULL, 9, 0, 36, 2, '2019-12-25', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 18000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 12:27:32', 8),
(1695, 14, NULL, 'GERMAN EDUARDO', 'PEREZ', 'germanperezmendez@gmail.com', NULL, '573203010050', 35, 2, 0, 37, 1, '2019-11-07', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ ANIVERSARIO\" , DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '150.00', 1, 0, NULL, 1, NULL, '2019-10-25 13:07:43', 8),
(1696, 9, NULL, 'EMILIO   ', 'AMARILLO', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, 36, 3, '2019-10-27', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO BESTDAY ID 73929685-1', NULL, NULL, NULL, NULL, NULL, '0.00', 3900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 13:25:52', 0),
(1697, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 13:48:06', 0),
(1698, 14, NULL, 'NAVEEN', 'PEREA', 'ventas@volarenglobo.com.mx', NULL, '61469307850', 35, 2, 0, 36, 4, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'TRADITIONAL PRIVATE FLIGHT 2 PAX , HOT AIRE BALLON 6 PAX FOR 45 MINUTES APROX, TOAST WITH SPARKLIN FREIXENET WINE,PERSONALIZED FLIGHT CERTIFICATE,TRANSPORTATION DURING THE ACTIVITY (CHECK IN AREA-TAKE OFF AREA AND LANDING SITE CHECK IN AREA) , TRAVEL INSURANCE , TRADITIONAL BREAKFAST IN RESTAURANT (BUFFET SERVICE).', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-10-25 13:53:52', 8),
(1699, 9, NULL, 'EMILIO', 'AMARILLO', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, 36, 3, '2019-10-27', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO BESTDAY ID 73929685-1', NULL, NULL, NULL, NULL, NULL, '0.00', 3900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 13:54:59', 8),
(1700, 14, NULL, 'STEFANIA', 'OIDOR', 'ventas@volarenglobo.com.mx', NULL, '573138948353', 35, 2, 0, 36, 1, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 14:02:18', 8),
(1701, 14, NULL, 'ROGELIO', 'GARCIA', 'ventas@volarenglobo.com.mx', NULL, '5522725721', 11, 2, 0, 38, 4, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO EN RESTAURANTE , PASTEL PARA CUMPLEAÃ‘ERO  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 15:24:06', 8),
(1702, 14, NULL, 'BEATRIZ', 'ALVARADO', 'beatriz.alvarado@gmail.com', NULL, '5546965953', 11, 5, 0, 36, 1, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS', '495.00', NULL, NULL, NULL, '0.00', 11995.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 15:32:19', 3),
(1703, 16, NULL, 'PAOLA', 'FAJARDO', 'pao.g.fajardo@gmail.com', NULL, '2227900936', NULL, 3, 1, 36, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet (excepto / Seguro viajero/ Coffee break / Despliegue de lona ', NULL, NULL, NULL, NULL, 2, '164.00', 8996.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 15:33:13', 8),
(1704, 9, NULL, 'JOSE IVAN', 'CAETANO', 'hector@ruizmed.com.mx', NULL, '5563740719', NULL, 3, 0, NULL, 1, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 3 PAX DE 45 MIN. APROX. SOBRE VALLE DE TEOTIHUACAN.\nCOFFEE BREAK ANTES DE VUELO. \nSEGURO DE VIAJERO. \nBRINDIS CON VINO ESPUMOSO. \nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, 2, '1650.00', 5250.00, 0, '197.00', 1, 0, NULL, 1, 'PASAJEROS TEOCALLI PASAR POR ELLOS PUNTUALES', '2019-10-25 15:49:01', 8),
(1705, 16, NULL, 'RICARDO', 'FICO', 'ficco.alessandro@gmail.com', NULL, '5491168178543', NULL, 2, 0, 36, 2, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona ', NULL, NULL, NULL, NULL, NULL, '0.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 15:55:27', 6),
(1706, 16, '1643', 'BANJAMIN', 'XUCHITL', 'Padrinobenja@hotmail.com', NULL, '2381034658', NULL, 4, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 9200.00, 0, '270.00', 1, 0, NULL, 1, NULL, '2019-10-25 16:55:03', 8),
(1707, 14, NULL, 'SAMANTHA', 'GARCIA', 'ventas@volarenglobo.com.mx', NULL, '19152716772', 35, 3, 0, 36, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 7197.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 17:08:49', 3),
(1708, 9, NULL, 'OBRIAN', 'AQUECHE', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 1, 0, NULL, 3, '2019-10-28', NULL, NULL, NULL, NULL, NULL, '1 PAX COMPARTIDO BESTDAY ID 73891316-1', NULL, NULL, NULL, NULL, 2, '310.00', 1640.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 17:26:00', 8),
(1709, 16, '1705', 'RICARDO', 'FICO', 'ficco.alessandro@gmail.com', NULL, '5491168178543', NULL, 1, 0, 36, 2, '2019-10-29', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona ', NULL, NULL, NULL, NULL, NULL, '0.00', 2640.00, 0, '75.00', 1, 0, NULL, 1, NULL, '2019-10-25 17:27:16', 8),
(1710, 16, '1680', 'ELIANA', 'MEJIA', 'Eli_mejia09@hotmail.com', NULL, '573143228671', NULL, 4, 0, 36, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 9200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 17:28:31', 3),
(1711, 9, NULL, 'ANTONIA', 'CEBALLOS CRUZ', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 6, 0, 36, 3, '2019-10-28', NULL, NULL, NULL, NULL, NULL, '6 pax compartido best day id 73848579-1', NULL, NULL, NULL, NULL, 2, '1860.00', 9840.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 17:45:44', 8),
(1712, 16, NULL, 'PILAR', 'CALDERON', 'pilycalderon.s@gmail.com', NULL, '992781094', NULL, 2, 0, 36, 1, '2019-11-09', NULL, NULL, NULL, NULL, NULL, '\nVuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet (excepto bÃ¡sico)/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n \n', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '160.00', 1, 0, NULL, 1, NULL, '2019-10-25 17:49:54', 8),
(1713, 9, '1564', 'SHANE', 'SUAZO', 'turismo@volarenglobo.com.mx', NULL, '14159007039', 35, 2, 0, 36, 3, '2019-10-27', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTDO CON TRANSPORTE\nCOFFEE BREAK ANTES DE VUELO. \nSEGURO DE VIAJERO. \nBRINDIS CON VINO ESPUMOSO. \nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, 2, '200.00', 4700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 18:05:53', 8),
(1714, 16, NULL, 'ENRIQUE', 'BERUMEN', 'enriqueberumen@rocketmail.com', NULL, '6141422214', NULL, 2, 0, 36, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/  / Seguro viajero/ Coffee break /', 'PESO EXTRA', '250.00', NULL, NULL, NULL, '0.00', 4850.00, 0, '168.00', 1, 0, NULL, 1, NULL, '2019-10-25 18:11:26', 8),
(1715, 14, NULL, 'RODOLFO', 'HERNANDEZ', 'be_180689@hotmail.com', NULL, '5521416245', 11, 2, 0, 38, 1, '2019-11-10', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y PASTEL PARA EL CUMPLEAÃ‘ERO', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 18:23:25', 6),
(1716, 9, '1565', 'YSESE', '31 OCT', 'turismo@volarenglobo.com.mx', NULL, '99999999999', 11, 2, 0, NULL, 3, '2019-10-31', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO  CON TRANSPORTE', NULL, NULL, NULL, NULL, 2, '200.00', 4700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 18:25:46', 0),
(1717, 9, '1716', 'YESENIA', 'CASTANON', 'turismo@volarenglobo.com.mx', NULL, '19257847783', 35, 2, 0, NULL, 3, '2019-10-31', NULL, NULL, NULL, NULL, NULL, '2 PAX COMPARTIDO  CON TRANSPORTE\nCOFFEE BREAK ANTES DE VUELO. \nSEGURO DE VIAJERO. \nBRINDIS CON VINO ESPUMOSO. \nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, 2, '200.00', 4700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 18:26:23', 8),
(1718, 16, NULL, 'LILIANA', 'QUINTERO', 'liliqo@hotmail.com', NULL, '5536662299', NULL, 3, 0, 36, 1, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 6900.00, 0, '192.00', 1, 0, NULL, 1, NULL, '2019-10-25 18:37:02', 8),
(1719, 14, '1637', 'KIARA PATRICIA', 'CAMPOS', 'ventas@volarenglobo.com.mx', NULL, '5577851267', 35, 2, 0, 36, 4, '2019-10-26', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', 'TRANSPORTE ZOCALO', '700.00', NULL, NULL, NULL, '0.00', 7700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 18:44:12', 8),
(1720, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 18:55:21', 0),
(1721, 9, NULL, 'LAURA', 'DESIMONE', 'turismo@volarenglobo.com.mx', NULL, '6318850734', 11, 2, 0, NULL, 3, '2019-11-12', NULL, NULL, NULL, NULL, NULL, '2 pax full booking', NULL, NULL, NULL, NULL, 2, '230.00', 6000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 18:55:24', 8),
(1722, 14, NULL, 'ANDREA', 'BURBANO', 'andreavbona@gmail.com', NULL, '593962894663', 35, 2, 0, 36, 1, '2019-11-06', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, , TRANSPORTE CDMX-TEOTIHUACAN-CDMX (CENTRO) ', NULL, NULL, NULL, NULL, NULL, '0.00', 5600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 19:04:38', 6),
(1723, 9, NULL, 'EBERHARD ', 'POTSCHERNIK', 'turismo@volarenglobo.com.mx', NULL, '4916090805050', 11, 2, 0, 36, 3, '2019-11-03', NULL, NULL, NULL, NULL, NULL, '2 pax full booking', NULL, NULL, NULL, NULL, 2, '230.00', 6000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 19:08:50', 8),
(1724, 14, '1715', 'RODOLFO', 'HERNANDEZ', 'be_180689@hotmail.com', NULL, '5521416245', 11, 2, 0, 38, 4, '2019-11-10', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE , PASTEL PARA EL CUMPLEAÃ‘ERO Y FOTO IMPRESA', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '123.00', 1, 0, NULL, 1, NULL, '2019-10-25 19:09:36', 8),
(1725, 14, NULL, 'MIRIAM', 'CORTINA', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 19:17:53', 0),
(1726, 14, NULL, 'MIRIAM', 'CORTINA', 'miriamcog@gmail.com', NULL, '2221148572', 35, 2, 0, 38, 1, '2019-11-16', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET Y PASTEL PARA CUMPLEAÃ‘ERO', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 19:21:25', 3),
(1727, 14, NULL, 'FRANCISCO', 'SANCHEZ', 'fsanchez1688@gmail.com', NULL, '50683153591', 35, 2, 0, 36, 1, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,  SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 21:00:10', 6),
(1728, 14, '1727', 'FRANCISCO', 'SANCHEZ', 'fsanchez1688@gmail.com', NULL, '50683153591', 35, 2, 0, 36, 1, '2019-11-06', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,  SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-25 22:11:15', 6),
(1729, 9, NULL, 'GUILLERMO', 'RECATERO', 'turismo@volarenglobo.com.mx', NULL, '34661815638', 35, 2, 0, NULL, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'INTERCAMBIO REVISTA ESPAÃ‘A PRECIO ESPECIAL $1800 X PAX \nVUELO COMPARTIDO 2 PAX DE 45 MIN APROXIMADAMENTE SOBRE EL VALLE DE TEOTIHUACAN. COFFEE BREAK ANTES DE VUELO. SEGURO DE VIAJERO. BRINDIS CON VINO ESPUMOSO. CERTIFICADO PERSONALIZADO ', NULL, NULL, NULL, NULL, 2, '1000.00', 3600.00, 0, '147.00', 1, 0, NULL, 1, 'Intercambio revista espaÃ±ola $1800 X PAX precio especial ', '2019-10-25 22:22:36', 8),
(1730, 9, NULL, 'FLAVIA', 'COSTA', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-26 02:34:51', 0),
(1731, 9, NULL, 'FLAVIA ', 'COSTA', 'mexico.overseas@overseasmexico.com', NULL, '999999', 11, 1, 0, 36, 3, '2019-10-28', NULL, NULL, NULL, NULL, NULL, '1 pax compartido con transporte sencillo overseas', NULL, NULL, NULL, NULL, 2, '100.00', 2150.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-26 02:36:53', 8),
(1732, 9, NULL, 'BENJAMIN', 'DIBBERT', 'turismo@volarenglobo.com.mx', NULL, '9541590572', 35, 1, 0, 36, 3, '2019-10-30', NULL, NULL, NULL, NULL, NULL, '1 pax compartido booking con transporte', NULL, NULL, NULL, NULL, 2, '100.00', 2350.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-26 02:43:06', 8),
(1733, 16, NULL, 'JENNIFER', 'LONDOÃ‘O', 'Jennifer211713@gmail.com', NULL, '5574594119', NULL, 2, 0, NULL, 4, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-26 11:38:27', 3),
(1734, 16, NULL, 'OMAR', 'ESTRADA', 'omarestrada07@gmail.com', NULL, '7681012153', NULL, 2, 0, NULL, 1, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', 'TRANSPORTE REDONDO Z', '700.00', NULL, NULL, NULL, '0.00', 5300.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-26 11:49:21', 3),
(1735, 14, '1728', 'FRANCISCO', 'SANCHEZ', 'Francisco.sanchezperez@ucr.ac.cr', NULL, '50683153591', 35, 2, 0, 36, 1, '2019-11-06', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,  SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 5558.10, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-26 13:52:49', 1),
(1736, 14, NULL, 'NOEMI', 'RODRIGUEZ', 'noemi_curd@hotmail.com', NULL, '5521835854', 11, 2, 0, 36, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO , CERTIFICADO PERSONALIZADO', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-26 14:08:53', 3),
(1737, 16, NULL, 'BEATRIZ', 'SANDINO', 'beatrizsandino.beatriz@gmail.com', NULL, '34646681848', NULL, 1, 0, 36, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno buffet/ Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, 2, '41.00', 2899.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-26 15:13:13', 3),
(1738, 14, NULL, 'ANDREA', 'QUESADA', 'Altheaquillaja@yahoo.com', NULL, '50687235797', 35, 2, 0, 38, 1, '2019-11-15', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET ', 'DESAYUNOS ', '198.00', 'TRANSPORTATION ÃNGE', '700.00', NULL, '0.00', 5498.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-26 16:11:15', 3),
(1739, 14, NULL, 'DANIELA ', 'BRAVO', 'Daniela.bravo@latam.com', NULL, '56994522525', 35, 4, 0, 36, 1, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN  SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO  , DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '396.00', NULL, NULL, NULL, '0.00', 11596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-26 19:35:20', 6),
(1740, 16, NULL, 'LINA', 'CUERVO', ' andresgir@yahoo.com', NULL, '573208438203', NULL, 2, 0, NULL, 2, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break', NULL, NULL, NULL, NULL, NULL, '0.00', 4000.00, 0, '155.00', 1, 0, NULL, 1, NULL, '2019-10-26 19:56:29', 8),
(1741, 14, NULL, 'ELSA ', 'VÃZQUEZ ', 'ventas@volarenglobo.com.mx ', NULL, '5574817356', 11, 5, 0, 36, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 5 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '495.00', NULL, NULL, NULL, '0.00', 11995.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-26 20:01:52', 6),
(1742, 14, NULL, 'JUAN', 'OLEA', 'antonio1331om@gmail.com', NULL, '5537223149', 11, 3, 0, 36, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,  SEGURO DE VIAJERO,  BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO Y DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '297.00', NULL, NULL, NULL, '0.00', 7197.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-26 20:10:05', 3),
(1743, 14, '1741', 'ELSA ', 'VÃZQUEZ ', 'ventas@volarenglobo.com.mx ', NULL, '5574817356', 11, 5, 1, 36, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 5 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '594.00', NULL, NULL, NULL, '0.00', 13794.00, 0, '383.00', 1, 0, NULL, 1, NULL, '2019-10-26 20:34:24', 8),
(1744, 16, NULL, 'JORGE', 'BAUTISTA', 'reserva@volarenglobo.com.mx', NULL, '5612789440', NULL, 2, 0, NULL, 1, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '150.00', 1, 0, NULL, 1, 'Dar $300 pesos de comisiÃ³n al taxista', '2019-10-26 22:58:25', 4),
(1745, 9, NULL, 'GUIA', 'AGELINA', 'turismo@volarenglobo.com.mx', NULL, '5530103913', NULL, 2, 0, NULL, 16, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO 2 PAX DE 45 MIN APROXIMADAMENTE SOBRE EL VALLE DE TEOTIHUACAN.\nGUIA RUSA \n', NULL, NULL, NULL, NULL, NULL, '0.00', 6000.00, 0, '120.00', 1, 0, NULL, 1, 'GUIIA RUSA PAGA EN SITIO LLEGA A RECEPCIÃ“N ', '2019-10-27 12:39:32', 8),
(1746, 9, NULL, 'KEN', 'RAMOS GUERRERO', 'reservas@tuexperiencia.com', NULL, '9982142518', 35, 2, 0, 38, 3, '2019-10-28', NULL, NULL, NULL, NULL, NULL, '2 pax compartido tu experiencia con transporte', NULL, NULL, NULL, NULL, 2, '200.00', 4700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-27 13:01:15', 8),
(1747, 14, NULL, 'LIZZET', 'RAMIREZ', 'lizzzeththres@gmail.com', NULL, '5215615257759', 11, 2, 0, 38, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y PASTEL PARA CUMPLEAÃ‘ERO ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-27 13:14:36', 3),
(1748, 14, '1722', 'ANDREA', 'BURBANO', 'ventas@volarenglobo.com.mx ', NULL, '593962894663', 35, 2, 0, 36, 1, '2019-11-06', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, , TRANSPORTE CDMX-TEOTIHUACAN-CDMX (CENTRO) ', NULL, NULL, NULL, NULL, 2, '2.00', 5598.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-27 13:23:32', 6),
(1749, 14, NULL, 'SEBASTIAN ', 'JARAMILLO', 'sebastianjillo@gmail com', NULL, '17863060451', 35, 2, 0, 36, 1, '2019-11-08', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,  SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, Y  DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '170.00', 1, 0, NULL, 1, NULL, '2019-10-27 13:26:53', 8),
(1750, 14, NULL, 'KATHERINE ', 'HERNÃNDEZ ', 'kar.dha11@live.com', NULL, '50683093056', 35, 2, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-27 13:36:02', 6),
(1751, 14, NULL, 'DANILO', 'AREIZA', 'hbdanilohb@yahoo.es', NULL, '573502239602', 35, 2, 0, 36, 1, '2019-10-29', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL DURANTE LA ACTIVIDAD DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-27 14:03:52', 6),
(1752, 9, NULL, 'MARIA FERNANDA', 'JIMENEZ PAZ', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, 36, 3, '2019-10-31', NULL, NULL, NULL, NULL, NULL, '2-pax compartido best day id 74092686-1', NULL, NULL, NULL, NULL, 2, '620.00', 3280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-27 14:59:37', 8),
(1753, 14, NULL, 'AMANDA ', 'MEZA', 'a.meza22@gmail.com', NULL, '50687850109', 35, 3, 0, 38, 1, '2020-02-12', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y PASTEL PARA CUMPLEAÃ‘ERO ', 'DESAYUNOS ', NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-27 16:06:07', 6),
(1754, 14, '1753', 'AMANDA ', 'MEZA', 'a.meza22@gmail.com', NULL, '50687850109', 35, 3, 0, 38, 1, '2020-02-12', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y PASTEL PARA CUMPLEAÃ‘ERO ', 'DESAYUNOS ', '297.00', NULL, NULL, NULL, '0.00', 8697.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-27 16:08:23', 3),
(1755, 16, NULL, 'AUREA', 'RABADAN', 'Alexa-iva@hotmail.com', NULL, '3328165463', NULL, 2, 2, 36, 4, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo de 45 a 60 minutos/ Brindis con vino espumoso y jugo para menores/ seguro viajero/ coffe break/ foto impresa/ Desayuno buffet', NULL, NULL, NULL, NULL, NULL, '0.00', 10600.00, 0, '220.00', 1, 0, NULL, 1, NULL, '2019-10-27 16:19:13', 8),
(1756, 14, '1739', 'DANIELA ', 'BRAVO', 'Daniela.bravo@latam.com', NULL, '56994522525', 35, 3, 0, 36, 1, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN  SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO  , DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '297.00', NULL, NULL, NULL, '0.00', 8697.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-27 16:21:12', 6),
(1758, 16, NULL, 'GERARDO', 'LEDEZMA', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-27 16:52:15', 0),
(1759, 14, '1756', 'DANIELA ', 'BRAVO', 'Daniela.bravo@latam.com', NULL, '56994522525', 35, 3, 0, 36, 1, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN  SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO  , DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '297.00', NULL, NULL, NULL, '0.00', 8697.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-27 16:56:58', 8),
(1760, 9, NULL, 'RODRIGO ', 'OCHARAN', 'turismo@volarenglobo.com.mx', NULL, '5215575086041', NULL, 1, 0, NULL, 3, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 1 PAX DE 45 MIN APROXIMADAMENTE SOBRE EL VALLE DE TEOTIHUACAN TRANSPORTE SENCILLO ', NULL, NULL, NULL, NULL, NULL, '0.00', 2250.00, 0, '85.00', 1, 0, NULL, 1, 'PASAJERO EXPLORA TEOTIHUACAN TRANSPORTE SOLO IDA HOTEL SELINA', '2019-10-27 17:26:07', 8),
(1761, 16, NULL, 'CARLOS', 'TOLEDANO', 'Carlos.toledano@grupolala.com', NULL, '5547660493', NULL, 2, 0, 39, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos/ brindis con vino espumoso/ certificado de vuelo/ seguro viajero/ coffe break/ despliegue de lona Te quieres casar conmigo?', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '110.00', 1, 0, NULL, 1, NULL, '2019-10-27 18:16:41', 8),
(1762, 16, NULL, 'GERARDO', 'LEDEZMA', 'Gerlebra@yahoo.com ', NULL, '50688618985', NULL, 6, 0, 36, 1, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'vuelo compartido 45 a 60 minutos/ brindis con vino espumoso/ certificado de vuelo/ seguro viajero/coffe break\n4 adultos en primer horario y 2 en segundo', NULL, NULL, NULL, NULL, NULL, '0.00', 13800.00, 0, '444.00', 1, 0, NULL, 1, '4 PAX VUELAN EN PRIMER HORARIO Y 2 EN SEGUNDO, LLEVAN UN BEBE Y SE TURNAN PARA CUIDARLO', '2019-10-27 18:19:49', 8),
(1763, 14, NULL, 'ANA ', 'VILLARREAL', 'Ana.wmtz@gmail.com', NULL, '8117428430', 35, 4, 0, 36, 1, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,  CERTIFICADO PERSONALIZADO ', NULL, NULL, NULL, NULL, NULL, '0.00', 9200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-27 19:25:30', 6),
(1764, 14, '1750', 'KATHERINE ', 'HERNÃNDEZ ', 'Kat.dha11@live.com', NULL, '50683093056', 35, 2, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-27 20:09:42', 6),
(1765, 9, NULL, 'JUAN CARLOS', 'VEGA CHAVES', 'turismo@volarenglobo.com.mx', NULL, '50683268931', NULL, 2, 0, 36, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-27 20:21:26', 0),
(1766, 9, NULL, 'JUAN CARLOS', 'VEGA CHAVES', 'turismo@volarenglobo.com.mx', NULL, '50683268931', NULL, 2, 0, 36, 1, '2019-11-14', NULL, NULL, NULL, NULL, NULL, '2 pax compartido conekta pedido 4216', NULL, NULL, NULL, NULL, 2, '2.00', 4598.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-27 20:23:23', 8),
(1767, 14, NULL, 'MINERVA ', 'RIVERO', 'ventas@volarenglobo.com.mx', NULL, '5582173839', NULL, 3, 0, 36, 1, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN  SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO , CERTIFICADO PERSONALIZADO  DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', NULL, NULL, NULL, NULL, 2, '3.00', 6897.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-27 20:48:17', 8),
(1768, 14, '1763', 'ANA ', 'VILLARREAL', 'Ana.wmtz@gmail.com', NULL, '8117428430', 35, 2, 0, 36, 1, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,  CERTIFICADO PERSONALIZADO ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 07:33:48', 8),
(1769, 14, NULL, 'MAUREN', NULL, 'ventas@volarenglobo.com.mx', NULL, '50683122837', 35, 2, 0, 38, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 6698.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 11:31:01', 6);
INSERT INTO `temp_volar` (`id_temp`, `idusu_temp`, `clave_temp`, `nombre_temp`, `apellidos_temp`, `mail_temp`, `telfijo_temp`, `telcelular_temp`, `procedencia_temp`, `pasajerosa_temp`, `pasajerosn_temp`, `motivo_temp`, `tipo_temp`, `fechavuelo_temp`, `tarifa_temp`, `hotel_temp`, `habitacion_temp`, `checkin_temp`, `checkout_temp`, `comentario_temp`, `otroscar1_temp`, `precio1_temp`, `otroscar2_temp`, `precio2_temp`, `tdescuento_temp`, `cantdescuento_temp`, `total_temp`, `piloto_temp`, `kg_temp`, `tipopeso_temp`, `globo_temp`, `hora_temp`, `idioma_temp`, `comentarioint_temp`, `register`, `status`) VALUES
(1770, 14, '1769', 'LIGIA', 'VELASCO', 'ventas@volarenglobo.com.mx', NULL, '50683122837', 35, 2, 0, 38, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 6698.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 11:52:14', 8),
(1771, 14, '1751', 'DANILO', 'AREIZA', 'ventas@volarenglobo.com.mx', NULL, '573502239602', 35, 2, 0, 36, 1, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL DURANTE LA ACTIVIDAD DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 12:32:43', 3),
(1772, 9, NULL, 'MARIA', 'MARIN', 'hector@ruizmed.com.mx', NULL, '5510411697', 11, 3, 0, 36, 3, '2019-10-31', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, 2, '600.00', 5250.00, 0, '170.00', 1, 0, NULL, 1, NULL, '2019-10-28 12:37:50', 8),
(1773, 14, NULL, 'ULRICH', 'HERNANDEZ', 'ventas@volarenglobo.com.mx', NULL, '316338747334', 35, 2, 0, 36, 1, '2019-10-29', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, 2, '2.00', 5598.00, 0, '212.00', 1, 0, NULL, 1, NULL, '2019-10-28 13:16:27', 8),
(1774, 14, NULL, 'GERARDO MANUEL', 'CARRILLO', 'ventas@volarenglobo.com.mx', NULL, '5217761020681', 11, 2, 0, 36, 4, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESAYUNO EN RESTAURANTE Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '158.00', 1, 0, NULL, 1, NULL, '2019-10-28 13:36:58', 8),
(1775, 9, NULL, 'ZHANG ', ' YIHING', 'kaytripdemexico@gmail.com', NULL, '4379721237', 35, 2, 0, 36, 3, '2019-11-08', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nTRANSPORTE REDONDO CDMX-TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.\nDESAYUNO BUFFET.\nENTRADA A ZONA ARQUEOLOGICA', NULL, NULL, NULL, NULL, 2, '230.00', 6000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 13:39:43', 8),
(1776, 14, NULL, 'STIFEN', 'VARGAS', 'ventas@volarenglobo.com.mx', NULL, '50660564762', 35, 2, 0, 39, 4, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA \"TE QUIERES CASAR CONMIGO\"  DESAYUNO EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 14:25:07', 8),
(1777, 16, NULL, 'ANA LETICIA', 'DOMINGUEZ', 'adominguez_antonio@hotmail.com', NULL, '2292139277', NULL, 2, 0, NULL, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 14:28:04', 6),
(1778, 16, '1777', 'ANA LETICIA', 'DOMINGUEZ', 'adominguez_antonio@hotmail.com', NULL, '2292139277', NULL, 2, 0, NULL, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', 'TRANSPORTE SOLO IDA', '600.00', NULL, NULL, NULL, '0.00', 5200.00, 0, '130.00', 1, 0, NULL, 1, NULL, '2019-10-28 14:30:37', 8),
(1779, 16, NULL, 'CECILIA', 'ORTIGOZA', 'ortigozasolarescecilia@gmail.com', NULL, '5591665101', NULL, 2, 0, 38, 1, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona FELIZ CUMPLE!', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 14:36:48', 3),
(1780, 9, NULL, 'LUCIA', ' LEDA', 'turismo@volarenglobo.com.mx', NULL, '5521439141', 11, 2, 0, 36, 3, '2019-10-29', NULL, NULL, NULL, NULL, NULL, '2 pax compartido turisky con transporte', NULL, NULL, NULL, NULL, 2, '800.00', 4100.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 14:38:32', 8),
(1781, 14, NULL, 'MARIA CRISTINA', 'MOGOYON', 'ventas@volarenglobo.com.mx', NULL, '15619299761', 35, 3, 0, 36, 1, '2019-11-28', NULL, 1, 22, '2019-11-27', '2019-11-28', 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 8647.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 14:42:23', 6),
(1782, 16, NULL, 'SYLVIA', 'RODRIGUEZ', 'syroca1@gmail.com', NULL, '5732049633817', NULL, 2, 0, 36, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 5600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 14:53:11', 3),
(1783, 14, NULL, 'MARCELA', 'CASTILLO', 'marcegcr@gmail.com', NULL, '573217172714', 35, 11, 0, 36, 1, '2019-01-02', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 11  PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET Y PASTEL PARA CUMPLEAÃ‘ERO ', 'TRANSP RED ', '3500.00', NULL, NULL, 2, '3300.00', 27040.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 14:53:50', 3),
(1784, 9, NULL, 'RODRIGO ', 'NAZARIO LUNA', 'rodrgonazario21@gmail.com', NULL, '99999999999', 11, 2, 0, 36, 1, '2019-11-18', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 15:00:01', 3),
(1785, 14, NULL, 'LAURA', 'CALDERON', 'moneymyle@hotmail.com', NULL, '5545253810', 11, 7, 0, 36, 1, '2019-12-29', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 7 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', NULL, NULL, NULL, NULL, 2, '2100.00', 14980.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 15:19:36', 6),
(1786, 9, NULL, 'OBRIAN', 'AQUECHE', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 35, 1, 0, 36, 3, '2019-10-30', NULL, NULL, NULL, NULL, NULL, '1 PAX COMPARTIDO BEST DAY ID 74096257-1 ', NULL, NULL, NULL, NULL, 2, '310.00', 1640.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 15:40:57', 0),
(1787, 14, NULL, 'SUSANA', 'DOMINGUEZ', 'zuu.dominguezf@hotmail.com', NULL, '5215562330101', 11, 3, 0, 36, 4, '2019-12-28', NULL, 1, 22, '2019-12-27', '2019-12-28', 'VUELO PRIVADO PARA 3 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESAYUNO EN RESTAURANTE Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 11950.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 15:44:16', 3),
(1788, 9, '1786', 'OBRIAN', 'AQUECHE', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 35, 1, 0, 36, 3, '2019-10-29', NULL, NULL, NULL, NULL, NULL, '1 PAX COMPARTIDO BEST DAY ID 74096257-1 ', NULL, NULL, NULL, NULL, 2, '310.00', 1640.00, 0, '82.00', 1, 0, NULL, 1, NULL, '2019-10-28 15:45:24', 8),
(1789, 14, NULL, 'NAHEELI', 'RUIZ', 'Naheeli.ruizp@live.com.mx', NULL, '5568705060', 11, 3, 0, 36, 1, '2019-10-31', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3  PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 7197.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 15:50:33', 8),
(1790, 16, NULL, 'CECILIA', 'BERNAL', 'cecilibernala@hotmail.com', NULL, '5539551321', NULL, 2, 3, 38, 4, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta', NULL, NULL, NULL, NULL, 2, '3.00', 12397.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 15:52:21', 3),
(1791, 14, NULL, 'ALEXANDRA ', 'FISZMAN', 'ale.fiszman@gmail.com', NULL, '5541454698', NULL, 2, 0, 37, 1, '2019-11-26', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA DE \"FELIZ ANIVERSARIO\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 15:54:32', 6),
(1792, 16, NULL, 'JESUS', 'MENDEZ', 'Contacto@vivians.mx', NULL, '8124055500', NULL, 2, 0, 39, 4, '2019-10-30', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 16:01:04', 6),
(1793, 16, '1792', 'JESUS', 'MENDEZ', 'Contacto@vivians.mx', NULL, '8124055500', NULL, 2, 0, 39, 4, '2019-10-30', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '135.00', 1, 0, NULL, 1, NULL, '2019-10-28 16:02:39', 8),
(1794, 9, NULL, ' VENUS', 'MAGAÃ‘A ', 'hector@ruizmed.com.mx', NULL, '5510411697', 11, 2, 0, 36, 3, '2019-10-30', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO', NULL, NULL, NULL, NULL, 2, '400.00', 3500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 16:23:44', 8),
(1795, 9, '1602', 'ROSA CLEMENCIA', 'CALLE AGUILAR', 'hector@ruizmed.com.mx', NULL, '5510411697', 11, 5, 0, 36, 3, '2019-10-30', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 6 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, 2, '1000.00', 8750.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 16:33:39', 8),
(1796, 14, NULL, 'JUAN FDO', 'VALENCIA', 'santiago.torresv0619@hotmail.com', NULL, '3053290051', 35, 2, 0, 38, 1, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y PASTEL PARA CUMPLEAÃ‘ERO , TRANSPORTE CDMX-TEOTIHUACAN-CDMX (CENTRO)', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 16:44:25', 3),
(1797, 14, NULL, 'DENIS', 'CARVALLO', 'essened@hotmail.com', NULL, '2291523700', 35, 6, 1, 36, 1, '2019-11-23', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 6 ADULTOS 1 MENOR , VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNO ADICIONAL', '140.00', NULL, NULL, 2, '1841.00', 14779.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 16:50:08', 3),
(1798, 14, '1791', 'ALEXANDRA ', 'FISZMAN', 'ale.fiszman@gmail.com', NULL, '5541454698', NULL, 2, 0, 37, 4, '2019-11-26', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA DE \"FELIZ ANIVERSARIO\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y FOTO IMPRESA ', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 16:55:00', 3),
(1799, 14, NULL, 'FERNANDO', 'PERILLA', 'fperilla@hotmail.com', NULL, '573165213572', 35, 2, 0, 36, 1, '2019-11-13', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI , TRANSPORTE REDONDO ZONA CENTRO', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 16:59:59', 3),
(1800, 14, NULL, 'ANTONIO', 'ESPINOZA', 'tonn065@hotmail.com', NULL, '9381036378', 11, 2, 0, 36, 4, '2019-12-20', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 17:12:01', 3),
(1801, 14, NULL, 'ANTONIO', 'ESPINOZA', 'tonn065@hotmail.com', NULL, '9381036378', 11, 2, 0, 36, 1, '2019-12-20', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 17:13:55', 3),
(1802, 14, NULL, 'AMEYALI', 'ANGUIANO', 'comercializacion_02@gruposony.com.mx', NULL, '2282303030', 11, 4, 0, 36, 1, '2019-11-18', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 9596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 17:20:42', 3),
(1803, 14, '1785', 'LAURA', 'CALDERON', 'monemyle@hotmail.com', NULL, '5545253810', 11, 7, 0, 36, 1, '2019-12-29', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 7 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', NULL, NULL, NULL, NULL, 2, '2100.00', 14980.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 17:26:14', 6),
(1804, 14, '1781', 'MARIA CRISTINA', 'MOGOYON', 'ventas@volarenglobo.com.mx', NULL, '15619299761', 35, 3, 0, 36, 1, '2019-11-28', NULL, 1, 22, '2019-11-27', '2019-11-28', 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', NULL, NULL, NULL, NULL, 2, '900.00', 7870.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 17:28:07', 6),
(1805, 14, NULL, 'CITLALLI', 'MUÃ‘OZ', 'ventas@volarenglobo.com.mx', NULL, '5569150117', 35, 2, 0, 38, 1, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET Y PASTEL PARA CUMPLEAÃ‘ERO', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 17:36:57', 8),
(1806, 14, NULL, 'CLAUDIA VERONICA', 'HOAJACA', 'ventas@volarenglobo.com.mx', NULL, '50259660713', 35, 2, 0, 36, 1, '2019-10-29', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 6848.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 18:13:27', 8),
(1807, 16, '1386', 'CARLOS', 'RINCON', 'crgv41@gmail.com', NULL, '8117190486', NULL, 2, 0, NULL, 4, '2019-11-30', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', 'I.V.A.', '1280.00', NULL, NULL, NULL, '0.00', 9280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 18:29:25', 8),
(1808, 14, NULL, 'ANDRES', 'GONZALEZ', 'andregondu@gmail.com', NULL, '2282109891', 35, 2, 0, 37, 4, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA \" FELIZ ANIVERSARIO\"  DESAYUNO BUFFET EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '126.00', 1, 0, NULL, 1, NULL, '2019-10-28 19:43:25', 8),
(1809, 14, NULL, 'NATALUA', 'MARTINEZ ', 'nmartinezzarate@gmail.com', NULL, '5548380463', 11, 5, 1, 36, 1, '2019-10-29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 13200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-28 22:05:25', 3),
(1810, 16, NULL, 'VICTOR', 'GONZALEZ', 'vial85@hotmail.com', NULL, '4625090919', NULL, 3, 0, NULL, 1, '2019-11-18', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos/ brindis con vino espumoso/ certificado de vuelo/ seguro viajero/ coffe break', NULL, NULL, NULL, NULL, NULL, '0.00', 6900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 00:09:08', 3),
(1811, 9, NULL, 'MARIA VIRGINIA', 'PALOMINO PINEDA', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 1, 0, 36, 3, '2020-01-03', NULL, NULL, NULL, NULL, NULL, '1 pax compartido best day id 74098991-1', NULL, NULL, NULL, NULL, 2, '200.00', 1750.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 02:26:30', 8),
(1812, 14, NULL, 'OSCAR ISMAEL', 'MARTINEZ', 'oscarmtzmtz91@hotmail.com', NULL, '5583193500', 11, 2, 0, 39, 4, '2019-11-16', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA DE \"TE QUIERES CASAR CONMIGO\"  DESAYUNO EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 11:29:17', 3),
(1813, 14, NULL, 'ROBERTO', 'SANTIESTEBAN', 'santiesteban1911@gmail.com', NULL, '5529005440', 11, 2, 0, 38, 4, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA DE  \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO EN RESTAURANTE Y PASTEL PARA CUMPLEAÃ‘ERO  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '170.00', 1, 0, NULL, 1, NULL, '2019-10-29 11:33:45', 6),
(1814, 9, NULL, 'LINDA', 'MIKEL. ', ' j.santos@wayakbus.com', NULL, '5516123007', 11, 2, 0, 36, 3, '2019-10-14', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nTRANSPORTE REDONDO CDMX-TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.\nDESAYUNO BUFFET.\nENTRADA A ZONA ARQUEOLOGICA', NULL, NULL, NULL, NULL, 2, '530.00', 5700.00, 0, '152.00', 1, 0, NULL, 1, NULL, '2019-10-29 11:37:46', 6),
(1815, 14, NULL, 'ROBERTO', 'SANTIESTEBAN', 'santiesteban1911@gmail.com', NULL, '5529005440', 11, 2, 0, 38, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 11:42:10', 3),
(1816, 16, NULL, 'MARIA JOSE', 'MONGE', 'reserva@volarenglobo.com.mx', NULL, '50683108612', NULL, 1, 0, 36, 1, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet  / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, 2, '41.00', 2399.00, 0, '53.00', 1, 0, NULL, 1, NULL, '2019-10-29 11:44:11', 8),
(1817, 9, NULL, ' DUVAN ', 'HURTADO  ', 'reservas@tuexperiencia.com', NULL, '3115581285', 11, 2, 0, 36, 3, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nTRANSPORTE REDONDO CDMX-TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.\n', NULL, NULL, NULL, NULL, 2, '200.00', 4700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 11:48:26', 8),
(1818, 14, NULL, 'MANUEL', 'ORTIZ', 'manuel00@hotmail.com', NULL, '5546124396', 11, 3, 0, 38, 1, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI, PASTEL PARA CUMPLEAÃ‘ERO ', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 7197.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 11:49:36', 3),
(1819, 14, NULL, 'ALEJANDRO', 'VESGA', 'vavesga@gmail.com', NULL, '61481130138', 35, 2, 0, 37, 4, '2019-01-20', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA \"FELIZ ANIVERSARIO\"  DESAYUNO EN RESTAURANTE Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 11:55:04', 3),
(1820, 14, '1432', 'CECILIA', 'ORTIGOZA', 'moly_16ceci@hotmail.com', NULL, '52155591665101', 11, 2, 0, 38, 1, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE, TE , GALLETAS Y PAN) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO , TRANSPORTE LOCAL , DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI , PASTEL PARA CUMPLEAÃ‘ERO , TRANSPORTE CDMX-TEOTIHUACAN-CDMX (CENTRO)', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 12:09:37', 6),
(1821, 14, '1653', 'CARLOS', 'LEAL', 'Josealbetoh@gmail.com', NULL, '5565791742', 35, 6, 0, 36, 1, '2019-10-31', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 6 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, NULL, '0.00', 13800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 12:11:42', 8),
(1822, 14, '1820', 'CECILIA', 'ORTIGOZA', 'moly_16ceci@hotmail.com', NULL, '52155591665101', 11, 2, 0, 38, 1, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE, TE , GALLETAS Y PAN) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO , TRANSPORTE LOCAL , DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI , PASTEL PARA CUMPLEAÃ‘ERO ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '140.00', 1, 0, NULL, 1, NULL, '2019-10-29 12:39:16', 8),
(1823, 16, NULL, 'ALVARO', 'MEJIA', 'armejiasalazar@gmail.com', NULL, '593995790111', NULL, 2, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona FELIZ VUELO!', NULL, NULL, NULL, NULL, 2, '82.00', 6848.00, 0, '130.00', 1, 0, NULL, 1, NULL, '2019-10-29 13:20:37', 8),
(1824, 14, '1476', 'CLAUDIA ', 'ATALAH', 'atalahclaudia@gmail.com', NULL, '50373932148', 35, 2, 0, 37, 4, '2019-12-29', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET Y FOTO IMPRESA ', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 13:27:17', 6),
(1825, 14, '1824', 'CLAUDIA ', 'ATALAH', 'atalahclaudia@gmail.com', NULL, '50373932148', 35, 2, 0, 37, 4, '2019-12-30', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET Y FOTO IMPRESA ', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 13:29:07', 6),
(1826, 9, NULL, 'TRANPORTADORA TUR', '& EM', ' transportadoraturyem@gmail.com', NULL, '99999999', 11, 4, 0, 36, 3, '2019-12-24', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 4  PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.\n', NULL, NULL, NULL, NULL, NULL, '0.00', 7800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 13:30:21', 3),
(1827, 14, '1813', 'ROBERTO', 'SANTIESTEBAN', 'santiesteban1911@gmail.com', NULL, '5529005440', 11, 2, 0, 38, 4, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA DE  \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO EN RESTAURANTE Y PASTEL PARA CUMPLEAÃ‘ERO  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '170.00', 1, 0, NULL, 1, NULL, '2019-10-29 13:32:47', 8),
(1828, 14, NULL, 'PATRICIO', 'GUTIERREZ', 'patogtz.94@gmail.com', NULL, '4422596676', 11, 2, 0, 37, 4, '2019-12-15', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA  \"FELIZ ANIVERSARIO\" DESAYUNO EN RESTAURANTE Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 13:42:21', 3),
(1829, 16, NULL, 'MARIA CRISTINA', 'MOGOLLON', 'reserva@volarenglobo.com.mx', NULL, '5619299761', NULL, 3, 0, NULL, 1, '2019-11-29', NULL, 1, 22, '2019-11-28', '2019-11-29', 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet/ Seguro viajero/ Coffee break / Despliegue de lona ', NULL, NULL, NULL, NULL, NULL, '0.00', 8350.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 13:45:32', 3),
(1830, 14, NULL, 'KARLA', 'BALION', 'karbalico23@gmail.com', NULL, '2482006364', 35, 2, 0, 36, 1, '2019-11-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 13:45:44', 3),
(1831, 14, '1804', 'MARIA CRISTINA', 'MOGOYON', 'ventas@volarenglobo.com.mx', NULL, '15619299761', 35, 3, 0, 36, 1, '2019-11-28', NULL, 1, 22, '2019-11-29', '2019-11-30', 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 8647.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 13:56:11', 3),
(1832, 9, NULL, 'MARIO', 'RAMIREZ', 'turismo@volarenglobo.com.mx', NULL, '5536913088', 11, 3, 0, 36, 3, '2019-10-30', NULL, NULL, NULL, NULL, NULL, '3 pax compartido turisky con transporte', NULL, NULL, NULL, NULL, 2, '1200.00', 6150.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 14:06:39', 8),
(1833, 14, '1825', 'CLAUDIA ', 'ATALAH', 'atalahclaudia@gmail.com', NULL, '50373932148', 35, 2, 0, 45, 4, '2019-12-29', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET Y FOTO IMPRESA ,DESPLIEGUE DE LONA \"TE AMO\" ,TRANSPORTE CDMX-TEOTIHUACAN-CDMX (CENTRO)', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 14:16:24', 8),
(1834, 16, NULL, 'SAMANTHA', 'CALDERON', 'saccalderon@hotmail.com', NULL, '5585497258', NULL, 2, 0, 45, 4, '2019-11-26', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona TE AMO / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7300.00, 0, '120.00', 1, 0, NULL, 1, NULL, '2019-10-29 14:52:21', 8),
(1835, 16, NULL, 'ANDREA', 'DIAZ', 'andreadiazfa@gmail.com', NULL, '5580960091', NULL, 4, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona ', NULL, NULL, NULL, NULL, NULL, '0.00', 9200.00, 0, '260.00', 1, 0, NULL, 1, NULL, '2019-10-29 15:01:22', 8),
(1836, 9, NULL, 'ANGIE', 'PORRAS', 'turismo@volarenglobo.com.mx', NULL, '50688297144', 11, 5, 0, NULL, 3, '2019-11-01', NULL, NULL, NULL, NULL, NULL, '5 pax compartido puro vuelo tu experiencia', NULL, NULL, NULL, NULL, NULL, '0.00', 9750.00, 0, '340.00', 1, 0, NULL, 1, NULL, '2019-10-29 15:03:00', 8),
(1837, 9, '1627', 'MARIA FERNANDA', 'HERNANDEZ MONTERO', 'direccion@huellasmexicanas.com.mx', NULL, '5576631175', NULL, 2, 0, NULL, 3, '2019-10-30', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO 2 PAX DE 45 MIN. APROXIMADO SOBRE EL VALLE DE TEOTIHUACÃN, COFFEE BREAK ANTES DE VUELO, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET DESPUES DE VUELO.', NULL, NULL, NULL, NULL, 2, '20.00', 4160.00, 0, '120.00', 1, 0, NULL, 1, 'PASAJEROS OPERADOR HUELLAS MEXICANAS', '2019-10-29 15:26:05', 8),
(1838, 14, NULL, 'JOSE LUIS', 'LEON', 'ventas@volarenglobo.com.mx', NULL, '593992119283', 35, 1, 0, 36, 1, '2019-10-30', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO.', 'TRANSP SENCILLO EXTR', '300.00', NULL, NULL, NULL, '0.00', 2900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 15:29:59', 8),
(1839, 9, NULL, 'FANG', 'ZHU0NI', 'turismo@volarenglobo.com.mx', NULL, '13641975373', 35, 2, 0, 36, 3, '2019-11-01', NULL, NULL, NULL, NULL, NULL, '2 pax full kaytrip', NULL, NULL, NULL, NULL, 2, '230.00', 6000.00, 0, '130.00', 1, 0, NULL, 1, NULL, '2019-10-29 15:30:12', 8),
(1840, 9, NULL, 'MICHAEL', 'KEALY', 'turismo@volarenglobo.com.mx', NULL, '330788802197', 35, 2, 0, 36, 3, '2019-11-01', NULL, NULL, NULL, NULL, NULL, '2 pax compartido con transporte expedia', NULL, NULL, NULL, NULL, 2, '100.00', 4800.00, 0, '145.00', 1, 0, NULL, 1, NULL, '2019-10-29 15:43:48', 8),
(1841, 9, NULL, 'RENE', 'PENA', 'turismo@volarenglobo.com.mx', NULL, '15629005324', 35, 1, 0, 36, 3, '2019-11-01', NULL, NULL, NULL, NULL, NULL, '1 pax compartido expedia solo vuelo', NULL, NULL, NULL, NULL, NULL, '0.00', 1950.00, 0, '72.00', 1, 0, NULL, 1, NULL, '2019-10-29 15:48:24', 8),
(1842, 9, NULL, 'ARELY', 'MORA', 'turismo@volarenglobo.com.mx', NULL, '99999', 11, 2, 0, 36, 3, '2019-11-01', NULL, NULL, NULL, NULL, NULL, '2 pax compartido explora y descubre con desayuno', NULL, NULL, NULL, NULL, 2, '20.00', 4160.00, 0, '150.00', 1, 0, NULL, 1, NULL, '2019-10-29 15:52:52', 8),
(1843, 9, NULL, 'CARLOS ALBERTO', 'SIERRA', 'turismo@volarenglobo.com.mx', NULL, '018002378329', 11, 2, 0, 36, 3, '2019-11-01', NULL, NULL, NULL, NULL, NULL, '2 pax compartido price travel locator 13374232-1', NULL, NULL, NULL, NULL, 2, '500.00', 3400.00, 0, '173.00', 1, 0, NULL, 1, NULL, '2019-10-29 15:58:07', 8),
(1844, 16, NULL, 'MAURICIO', 'CARDONA', 'maocardona369@hotmail.com', NULL, '5585137568', NULL, 4, 0, 36, 2, '2019-10-30', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', 'TRANSPORTE REDONDO A', '1400.00', NULL, NULL, NULL, '0.00', 9960.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 16:14:37', 6),
(1845, 14, NULL, 'KELLY ', 'MILUHSKA', 'ventas@volarenglobo.com.mx', NULL, '593996169556', 35, 1, 0, 36, 1, '2019-10-30', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, NULL, '0.00', 2300.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 16:16:25', 8),
(1846, 16, NULL, 'DANIEL', 'VAZQUEZ', 'Dartvf@gmail.com', NULL, '3310261174', NULL, 2, 0, 36, 2, '2019-10-30', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n /Transporte CDMX  - TEOTIHUACÃN', NULL, NULL, NULL, NULL, NULL, '0.00', 5280.00, 0, '130.00', 1, 0, NULL, 1, NULL, '2019-10-29 16:27:09', 8),
(1847, 16, NULL, 'MARIBETH', 'ZAMBRANO', 'maribethcxm@gmail.com', NULL, '5539533531', NULL, 5, 0, 36, 1, '2019-11-24', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, 2, '205.00', 11995.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 16:31:20', 3),
(1848, 14, NULL, 'GRISEL', 'FRAGA', 'grissfrg@hotmail.com', NULL, '5531308149', 11, 10, 0, 38, 1, '2019-12-14', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 10 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" , DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y PASTEL PARA CUMPLEAÃ‘ERO', NULL, NULL, NULL, NULL, 2, '3000.00', 21400.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 16:32:51', 3),
(1849, 16, NULL, 'MICAELA', 'GALVEZ', 'Micaelagalvez@gmail.com', NULL, '5195288006', NULL, 3, 0, 36, 2, '2019-10-31', NULL, NULL, NULL, NULL, NULL, '\nVuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n \n', NULL, NULL, NULL, NULL, NULL, '0.00', 6420.00, 0, '180.00', 1, 0, NULL, 1, NULL, '2019-10-29 16:37:07', 8),
(1850, 14, NULL, 'HECTOR', 'ALFONSO', 'ventas@volarenglobo.com.mx', NULL, '18179462721', 35, 5, 0, 36, 1, '2019-12-15', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 5 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '495.00', NULL, NULL, NULL, '0.00', 11995.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 16:42:12', 3),
(1851, 14, NULL, 'STEPHANIE ', 'ACUÃ‘A', 'ventas@volarenglobo.com.mx', NULL, '50685875869', 35, 2, 0, 38, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA  \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET Y PASTEL PARA CUMPLEAÃ‘ERO ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 16:51:50', 8),
(1852, 14, NULL, 'ALISSON', 'ARITA', 'ventas@volarenglobo.com.mx', NULL, '50241286832', 35, 3, 0, 36, 1, '2019-10-31', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 8697.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 17:20:31', 8),
(1853, 16, NULL, 'LUZ ELENA', 'FLORES', 'luzfcb@yahoo.com', NULL, '5543472427', NULL, 3, 0, 37, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona FELIZ ANIVERSARIO', NULL, NULL, NULL, NULL, NULL, '0.00', 6900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 17:34:45', 6),
(1854, 16, '1853', 'LUZ ELENA', 'FLORES', 'luzfcb@yahoo.com.mx', NULL, '5543472427', NULL, 3, 0, 37, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona FELIZ ANIVERSARIO', NULL, NULL, NULL, NULL, NULL, '0.00', 6900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 17:36:51', 6),
(1855, 16, NULL, 'DAVID', 'MALDONADO', 'Davidmaldonado@gmail.com', NULL, '573183818640', NULL, 2, 0, 38, 1, '2019-11-06', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet (excepto bÃ¡sico)/ Seguro viajero/ Coffee break / Despliegue de lona FELIZ CUMPLE!', NULL, NULL, NULL, NULL, 2, '82.00', 6598.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 17:43:04', 3),
(1856, 14, NULL, 'GUSTAVO ADOLFO ', 'GAMBOA', 'ventas@volarenglobo.com.mx', NULL, '57315350235', 35, 1, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET ', 'DESAYUNOS', '99.00', NULL, NULL, NULL, '0.00', 2899.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 17:47:04', 6),
(1857, 14, '1856', 'GUSTAVO ADOLFO ', 'GAMBOA', 'ventas@volarenglobo.com.mx', NULL, '57315350235', 35, 1, 0, 36, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET ', 'DESAYUNOS', '99.00', NULL, NULL, NULL, '0.00', 2899.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 17:53:59', 8),
(1858, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 17:54:00', 0),
(1859, 9, '1814', 'LINDA', 'MIKEL. ', ' j.santos@wayakbus.com', NULL, '5516123007', 11, 2, 0, 36, 3, '2019-10-30', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nTRANSPORTE REDONDO CDMX-TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.\nDESAYUNO BUFFET.\nENTRADA A ZONA ARQUEOLOGICA', NULL, NULL, NULL, NULL, 2, '330.00', 4900.00, 0, '152.00', 1, 0, NULL, 1, NULL, '2019-10-29 17:54:18', 8),
(1860, 14, NULL, 'PAMELA ', 'ALMANZA', 'ventas@volarenglobo.com.mx', NULL, '5533326864', 35, 4, 0, 38, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA DE \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO Y PASTEL PARA CUMPLEAÃ‘OS', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 9596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 17:55:46', 8),
(1861, 16, '1854', 'LUZ ELENA', 'FLORES', 'luzfcb@yahoo.com.mx', NULL, '5543472427', NULL, 3, 0, 37, 4, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, 2, '500.00', 10000.00, 0, '210.00', 1, 0, NULL, 1, NULL, '2019-10-29 18:00:03', 8),
(1862, 9, NULL, 'SANDRA ', 'MOLINO', 'j.santos@wayakbus.com', NULL, '5569387728', 11, 2, 0, 36, 3, '2019-10-30', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, 2, '300.00', 3600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 18:03:04', 8),
(1863, 9, NULL, 'NICK ', 'AERNI', 'turismo@volarenglobo.com.mx', NULL, '8596538725', 11, 2, 0, 36, 3, '2019-10-30', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nTRANSPORTE REDONDO CDMX-TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.\n', NULL, NULL, NULL, NULL, 2, '200.00', 4700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 18:15:53', 8),
(1864, 9, NULL, 'FERNANDO ', 'FONCESA', 'turismo@volarenglobo.com.mx', NULL, '3153494904', 11, 6, 0, 36, 3, '2019-10-30', NULL, NULL, NULL, NULL, NULL, '6 PAX SOLO VUELO TU EXPERIENCIA', NULL, NULL, NULL, NULL, NULL, '0.00', 11700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 18:45:31', 8),
(1865, 14, NULL, 'FABRICIO JOSUE', 'FUENTES', 'f.fuentes788@gmail.com', NULL, '50377233665', 35, 6, 0, 38, 1, '2019-11-16', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 6 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y PASTEL PARA CUMPLEÃ‘ERO', 'DESAYUNOS', '594.00', NULL, NULL, NULL, '0.00', 14394.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 18:48:28', 3),
(1866, 9, NULL, 'LUDIVINE ANNETTE', 'DELAYRE', 'turismo@volarenglobo.com.mx', NULL, '768125095', 35, 2, 0, 36, 3, '2019-10-30', NULL, NULL, NULL, NULL, NULL, '2 PAX CON TRANSPORTE BOOKING', NULL, NULL, NULL, NULL, 2, '200.00', 4700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 18:48:29', 8);
INSERT INTO `temp_volar` (`id_temp`, `idusu_temp`, `clave_temp`, `nombre_temp`, `apellidos_temp`, `mail_temp`, `telfijo_temp`, `telcelular_temp`, `procedencia_temp`, `pasajerosa_temp`, `pasajerosn_temp`, `motivo_temp`, `tipo_temp`, `fechavuelo_temp`, `tarifa_temp`, `hotel_temp`, `habitacion_temp`, `checkin_temp`, `checkout_temp`, `comentario_temp`, `otroscar1_temp`, `precio1_temp`, `otroscar2_temp`, `precio2_temp`, `tdescuento_temp`, `cantdescuento_temp`, `total_temp`, `piloto_temp`, `kg_temp`, `tipopeso_temp`, `globo_temp`, `hora_temp`, `idioma_temp`, `comentarioint_temp`, `register`, `status`) VALUES
(1867, 14, NULL, 'CARLO', 'SALAMANCA', 'toraxtoro@hotmail.com', NULL, '2225347340', 11, 2, 0, 39, 4, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA DE \"TE QUIERES CASAR CONMIGO\"  DESAYUNO BUFFET EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', 'TRANSPORTE ZOCALO', '700.00', NULL, NULL, NULL, '0.00', 7700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 18:55:04', 3),
(1868, 14, NULL, 'MA DEL PILAR', 'MADRAZO', 'pmadrazog@hotmail.com', NULL, '5551020986', 11, 2, 0, 36, 1, '2019-11-18', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, 2, '600.00', 4000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 18:59:13', 3),
(1869, 9, NULL, 'RACHID', 'TONALI TOURS', 'turismo@volarenglobo.com.mx', NULL, '9', NULL, 2, 0, NULL, 16, '2019-10-29', NULL, NULL, NULL, NULL, NULL, 'vuelo privado 2 pax ', NULL, NULL, NULL, NULL, NULL, '0.00', 6000.00, 0, '150.00', 1, 0, NULL, 1, 'llegan a sitio ya volaron hoy', '2019-10-29 19:08:03', 8),
(1870, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 19:18:53', 0),
(1871, 9, NULL, 'PAULA', 'TURISKY', 'turismo@volarenglobo.com.mx', NULL, '50686918053', NULL, 2, 0, NULL, 3, '2019-10-31', NULL, NULL, NULL, NULL, NULL, 'PASAJEROS TURISKY L-V\nTOTAL $4,100', 'TRANSPORTE TURISKY', '200.00', NULL, NULL, NULL, '0.00', 4100.00, 0, '180.00', 1, 0, NULL, 1, 'PASAJEROS TURISKY L-V\nTRANSPORTE REDONDO\nTOTAL $4,100\n', '2019-10-29 19:25:33', 8),
(1872, 9, NULL, 'ESPIRITU ', 'AVENTURERO 1 PAX', 'producto@espirituaventurero.com.mx', NULL, '5577108350', NULL, 1, 0, NULL, 3, '2019-10-30', NULL, NULL, NULL, NULL, NULL, 'PASAJEROS ESPIRITU AVENTURERO 1 PAX RESERVA CON LOS OTROS 10 Y 1 MENOR', NULL, NULL, NULL, NULL, NULL, '0.00', 1950.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 19:33:18', 0),
(1873, 14, NULL, 'KAREN', 'SOTO', 'soto.h.karen.l@gmail.com', NULL, '5567797009', 11, 10, 0, 36, 1, '2020-02-25', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 10 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'TRANSPORTE ZOCALO 10', '3500.00', NULL, NULL, 2, '3000.00', 24900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-29 19:54:08', 3),
(1874, 16, NULL, 'ASTRID', 'MANDUJANO', 'Astridmandujanoa@hotmail.com', NULL, '2481350043', NULL, 4, 0, 36, 1, '2019-11-03', NULL, 1, 20, '2019-11-02', '2019-11-03', 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet\nTransportacion local durante la actividad', NULL, NULL, NULL, NULL, 2, '164.00', 11246.00, 0, '265.00', 1, 0, NULL, 1, NULL, '2019-10-29 23:33:17', 8),
(1875, 16, '1844', 'MAURICIO', 'CARDONA', 'maocardona369@hotmail.com', NULL, '5585137568', NULL, 4, 0, 36, 2, '2019-10-30', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', 'TRANSPORTE REDONDO A', NULL, NULL, NULL, NULL, '0.00', 8560.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 00:28:37', 8),
(1876, 16, NULL, 'EDGAR', 'ALMAGUER', 'enas36@hotmail.com', NULL, '4772071808', NULL, 2, 0, 36, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', 'TRANSPORTE REDONDO Z', '700.00', NULL, NULL, 2, '82.00', 5998.00, 0, '161.00', 1, 0, NULL, 1, NULL, '2019-10-30 11:35:38', 8),
(1877, 14, NULL, 'MONIKA', 'AGUILAR', 'monikap09@hotmail.com', NULL, '50688465143', 35, 2, 0, 36, 1, '2019-11-21', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO. ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 6848.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 11:56:47', 3),
(1878, 14, NULL, 'LEONARDO', 'ALVAREZ', 'lalvarez1680@gmail.com', NULL, '50688375253', 35, 3, 0, 36, 1, '0020-01-07', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 7197.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 12:03:11', 3),
(1879, 14, NULL, 'TITO', 'GUTIERREZ', 'vgutierrezcabral@gmail.com', NULL, '51997643380', 35, 2, 0, 39, 4, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA DE \"TE QUIERES CASAR CONMIGO\"  DESAYUNO EN RESTAURANTE Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 9050.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 12:32:54', 6),
(1880, 9, NULL, 'JONATHAN ', 'LOPEZ', ' rosillo.vianey@hotmail.com', NULL, '999999999', 11, 2, 0, 36, 3, '2019-10-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nTRANSPORTE REDONDO CDMX-TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.', 'PESO EXTRA', '725.00', NULL, NULL, 2, '200.00', 5425.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 12:47:51', 6),
(1881, 14, NULL, 'JOSE ARMANDO', 'CRISOSTOMO', 'ventas@volarenglobo.com.mx', NULL, '5519838215', 11, 2, 0, 36, 1, '2019-12-19', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 12:49:21', 3),
(1882, 14, NULL, 'ABNER', 'GARCIA', 'dr_abner@outlook.com', NULL, '5540329747', 11, 2, 0, 38, 4, '2019-11-13', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\"  DESAYUNO EN RESTAURANTE , PASTEL PARA CUMPLEAÃ‘ERO Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '126.00', 1, 0, NULL, 1, NULL, '2019-10-30 12:53:21', 8),
(1883, 14, NULL, 'JESSICA', 'DIAZ', 'jessik_dias@hotmail.com', NULL, '50763050473', NULL, 2, 0, 38, 1, '2019-11-07', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET Y PASTEL PARA CUMPLEAÃ‘ERO ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 12:58:08', 6),
(1884, 14, '1883', 'JESSICA', 'DIAZ', 'jessik_dias@hotmail.com', NULL, '50763050473', NULL, 2, 0, 38, 1, '2019-11-07', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET Y PASTEL PARA CUMPLEAÃ‘ERO ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 13:02:22', 6),
(1885, 9, NULL, 'MEANARD', 'CHRISTOPHE', 'turismo@volarenglobo.com.mx', NULL, '99999', 35, 7, 0, 36, 3, '2019-10-31', NULL, NULL, NULL, NULL, NULL, '7 PAX COMPARTIDO TRANSPORTADORA TUR &EM ', NULL, NULL, NULL, NULL, NULL, '0.00', 13650.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 13:29:25', 8),
(1886, 14, '1748', 'ANDREA', 'BURBANO', 'ventas@volarenglobo.com.mx ', NULL, '593962894663', 35, 2, 0, 36, 1, '2019-11-06', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, TRANSPORTE ZOCALO TEOTIHUACAN ZOCALO ', 'TRANSPORTE RED CENTR', '700.00', NULL, NULL, 2, '2.00', 5298.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 14:12:00', 8),
(1887, 14, NULL, 'MONICA', 'LONDOÃ‘O', 'Monica.londono.duque@gmail.com', NULL, '573116450891', 35, 6, 0, 36, 1, '2019-10-31', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 6 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS', '594.00', NULL, NULL, NULL, '0.00', 14394.00, 0, '417.00', 1, 0, NULL, 1, NULL, '2019-10-30 14:22:15', 8),
(1888, 9, NULL, 'UNIVERSE', 'TRAVEL', 'reservas6@globalutm.com.mx', NULL, '999999999', 11, 15, 0, 36, 16, '2019-12-23', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO 15  PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nTRANSPORTE REDONDO CDMX-TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.\nDESAYUNO BUFFET.', NULL, NULL, NULL, NULL, 2, '1500.00', 51000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 14:32:47', 6),
(1889, 16, NULL, 'KATHERINE', 'SOLANO', 'kat280690@hotmail.es', NULL, '50686523906', NULL, 5, 0, 36, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 11500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 14:36:26', 6),
(1890, 9, '1888', 'UNIVERSE', 'TRAVEL', 'reservas6@globalutm.com.mx', NULL, '999999999', 11, 15, 0, 36, 16, '2019-12-23', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO 15  PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nTRANSPORTE REDONDO CDMX-TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.\nDESAYUNO BUFFET.', NULL, NULL, NULL, NULL, 2, '1500.00', 53625.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 14:36:47', 3),
(1891, 14, NULL, 'TATYANE', 'GUERRA', 'tatyane@imaginarcontent.com', NULL, '5521970245600', 35, 6, 0, 36, 4, '2019-11-23', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 6 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, 2, '1800.00', 19200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 14:43:50', 3),
(1892, 9, NULL, 'ADA', 'ANGULO', 'hector@ruizmed.com.mx', NULL, '5563740719', NULL, 3, 0, NULL, 3, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'PASAJEROS TEOCALLI\nVUELO COMPARTIDO 3 PAX DE 45 MIN. APROX. SOBRE VALLE DE TEOTIHUACAN.\nCOFFEE BREAK ANTES DE VUELO. \nSEGURO DE VIAJERO. \nBRINDIS CON VINO ESPUMOSO. \nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, 2, '600.00', 5250.00, 0, '0.00', 1, 0, NULL, 1, 'PASAJEROS TEOCALLI/ PASAR POR ELLOS 5:40 PUNTUALES/ SOLO VUELO', '2019-10-30 15:08:07', 8),
(1893, 9, NULL, 'ESTRELLITA ', 'GARCIA', 'turismo@volarenglobo.com.mx', NULL, '0983302069', 11, 2, 0, 36, 3, '2019-11-02', NULL, NULL, NULL, NULL, NULL, '2 pax compartido con transporte booking ', NULL, NULL, NULL, NULL, 2, '200.00', 4700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 15:19:05', 8),
(1894, 9, NULL, 'LUCIRALIA', 'LEON SOTO', 'lucydann86@hotmail.com', NULL, '7717028987', NULL, 2, 0, 36, 1, '2019-11-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MIN. APROX. SOBRE VALLE DE TEOTIHUACAN.\nCOFFEE BREAK ANTES DE VUELO. \nSEGURO DE VIAJERO. \nBRINDIS CON VINO ESPUMOSO. \nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, 'FACEBOOK', '2019-10-30 15:40:58', 3),
(1895, 9, NULL, 'JESUS ', 'VALENCIA CASTILLO', 'jesusva0798@gmail.com', NULL, '5536815313', NULL, 2, 0, 36, 4, '2019-11-30', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO 2 PAX DE 45 MIN. APROX. SOBRE VALLE DE TEOTIHUACAN.\nCOFFEE BREAK ANTES DE VUELO. \nSEGURO DE VIAJERO. \nBRINDIS CON VINO ESPUMOSO. \nCERTIFICADO PERSONALIZADO.\nDESAYUNO BUFFET\nFOTO IMPRESA A ELEGIR', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 15:43:05', 3),
(1896, 16, NULL, 'ESDRAS', 'JASSO', 'esdrasjassogomez@gmail.com', NULL, '5514256854', NULL, 2, 0, 38, 4, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona FELIZ CUMPLE!/ Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.\n\n', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '150.00', 1, 0, NULL, 1, NULL, '2019-10-30 15:57:13', 8),
(1897, 9, NULL, 'NATALIA', 'SALAS', 'turismo@volarenglobo.com.mx', NULL, '593999691472', NULL, 4, 0, 36, 1, '2019-11-13', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 4 PAX DE 45 MIN. APROX. SOBRE VALLE DE TEOTIHUACAN.\nCOFFEE BREAK ANTES DE VUELO. \nTRANSPORTE REDONDO CDMX\nSEGURO DE VIAJERO. \nBRINDIS CON VINO ESPUMOSO. \nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, NULL, '0.00', 11200.00, 0, '265.00', 1, 0, NULL, 1, 'TRANSPORTE REDONDO HOTEL REGENTE/ PAGO POR PAYPAL $1000', '2019-10-30 16:00:14', 8),
(1898, 9, NULL, 'WILMA', 'RODRIGUEZ VILLAREAL', 'omarbaucam93@gmail.com', NULL, '73596866', 35, 1, 0, 36, 3, '2019-11-23', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 1 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, NULL, '0.00', 1950.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 16:18:13', 8),
(1899, 8, NULL, 'ALVARO ', 'CORDERO', 'Al.cordero.f@gmail.com', NULL, '5554024406', 11, 4, 0, 38, 4, '2020-02-01', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO - CUMPLEAÃ‘OS:\n\nTu vuelo incluye: Coffee break, seguro de viajero, vuelo de 45 min. a 1 hora, despliegue de lona \"CumpleaÃ±os\", brindis con vino espumoso, certificado personalizado, foto impresa y desayuno buffet.', NULL, NULL, NULL, NULL, 2, '2000.00', 12000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 16:22:02', 3),
(1900, 9, NULL, 'SAULO', 'AGUIRRE', 'turismo@volarenglobo.com.mx', NULL, '12144144670', NULL, 2, 0, 36, 3, '2019-10-31', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MIN. APROX. SOBRE VALLE DE TEOTIHUACAN.\nCOFFEE BREAK ANTES DE VUELO. \nSEGURO DE VIAJERO. \nBRINDIS CON VINO ESPUMOSO. \nCERTIFICADO PERSONALIZADO.', 'AJUSTE', '10.00', NULL, NULL, NULL, '0.00', 3910.00, 0, '200.00', 1, 0, NULL, 1, 'PASAJEROS BENEFICIO TARJETA DE DESCUENTO/ FIRMAR CARTA DE PAGO CON 2 TARJETAS ANTICIPO $1,000 Y $1,000 TERMINACIONES 1797 Y 2651/ PRESENTAR TARJETA DE REGALO VIGENTE', '2019-10-30 16:52:15', 8),
(1901, 16, NULL, 'FLORENCIA', 'AGUIRRE', 'flor17.arg@gmail.com', NULL, '9841443246', NULL, 2, 0, 36, 1, '2019-10-31', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 19:06:09', 3),
(1902, 14, '1879', 'TITO', 'GUTIERREZ', 'vgutierrezcabral@gmail.com', NULL, '51997643380', 35, 2, 0, 39, 4, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA DE \"TE QUIERES CASAR CONMIGO\"  DESAYUNO EN RESTAURANTE Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-30 19:41:46', 8),
(1903, 9, NULL, 'SIJING', 'ZHANG ', 'reservas@tuexperiencia.com', NULL, '13882202092', 35, 4, 0, NULL, 3, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 4 PAX DE 45 MIN. APROXIMADAMENTE SOBRE EL VALLE DE TEOTIHUACAN. TRANSPORTE REDONDO CDMX. SEGURO DE VIAJERO. COFFEE BREAK ANTES DE VUELO. BRINDIS CON VINO ESPUMOSO. CERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, 2, '400.00', 9400.00, 0, '0.00', 1, 0, NULL, 1, 'Pasajeros tu experiencia TUE-146476300 transporte pendiente hotel', '2019-10-30 22:08:53', 8),
(1904, 16, NULL, 'ADRIAN', 'OROZCO', 'adrian21ok@hotmail.com', NULL, '56977407156', NULL, 4, 0, 36, 2, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet\nTransporte redondo CDMX TEOTIHUACÃN', NULL, NULL, NULL, NULL, NULL, '0.00', 10560.00, 0, '300.00', 1, 0, NULL, 1, NULL, '2019-10-30 23:26:40', 8),
(1905, 9, NULL, 'MARCO', 'LOYOLA', 'reservas@tuexperiencia.com', NULL, '945575347', 11, 2, 0, 36, 3, '2019-11-02', NULL, NULL, NULL, NULL, NULL, '2-pax compartido con transporte tu experiencia ', NULL, NULL, NULL, NULL, 2, '200.00', 4700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-31 00:17:47', 8),
(1906, 9, NULL, 'LUIS ALBERTO ', 'PINILLA MOGOLLON.', 'turismo@volarenglobo.com.mx', NULL, '3005305590', 11, 3, NULL, 36, 1, '2019-11-30', NULL, NULL, NULL, NULL, NULL, ' 3 pax compartido conekta ped 4233', NULL, NULL, NULL, NULL, 2, '123.00', 7197.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-31 11:48:08', 3),
(1907, 14, NULL, 'KARLA JOHANKA', 'GOMEZ', 'sunieska08@hotmail.com', NULL, '5215510523636', 11, 2, 0, 38, 1, '2019-11-16', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN)SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO,CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD,DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y PASTEL PARA CUMPLEAÃ‘ERO', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-31 11:59:53', 3),
(1908, 16, '1504', 'ESTEFANI DANIELA', 'HERNANDEZ', 'dani_hvera@hotmail.com', NULL, '5518229648', NULL, 4, 2, 38, 1, '2019-11-10', NULL, 1, 25, '2019-11-09', '2019-11-10', 'Vuelo en globo compartido sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona FELIZ CUMPLE!/ Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', 'HABITACIÃ“N DOBLE QU', '1300.00', NULL, NULL, 2, '246.00', 15794.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-31 12:05:45', 8),
(1909, 14, NULL, 'EVELEEN ', 'TORO', 'eyleen40@yahoo.es', NULL, '3115589526', 35, 2, 0, 38, 1, '2019-11-08', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL DURANTE LA ACTIVIDAD, DESPLIEGUE DE LONA  \" FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET Y PASTEL PARA CUMPLEAÃ‘ERO ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-31 12:19:16', 3),
(1910, 14, NULL, 'VICTOR MIGUEL', 'AMOROSO', 'hectorvieyra@americaviaja.com', NULL, '5215533742980', 35, 2, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO', NULL, NULL, NULL, NULL, 2, '600.00', 4000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-31 13:15:30', 3),
(1911, 16, '1889', 'PAMELA', 'VILLALOBOS', 'pamevillacar@hotmail.com', NULL, '50686523906', NULL, 5, 0, 36, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 11500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-31 13:22:57', 8),
(1912, 16, NULL, 'FRANCISCO', 'ISLA', 'franciscoislad@gmail.com', '56977464652', '5583679667', NULL, 5, 0, 36, 2, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 10700.00, 0, '420.00', 1, 0, NULL, 1, NULL, '2019-10-31 13:42:24', 8),
(1913, 14, NULL, 'GABRIELA', 'LARRAGA', 'ventas@volarenglobo.com.mx', NULL, '593984502333', 35, 5, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 5 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '495.00', NULL, NULL, NULL, '0.00', 14495.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-31 13:47:27', 8),
(1914, 9, NULL, 'RUBENS', 'PASCALE', 'turismo@volarenglobo.com.mx', NULL, '5575086041', NULL, 5, 0, NULL, 3, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 5 PAX DE 45 MIN. APROX. SOBRE VALLE DE TEOTIHUACAN.\nCOFFEE BREAK ANTES DE VUELO. \nSEGURO DE VIAJERO. \nBRINDIS CON VINO ESPUMOSO. \nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, NULL, '0.00', 9750.00, 0, '305.00', 1, 0, NULL, 1, 'PASAJEROS OPERADOR EXPLORA TEOTIHUACAN/ LLEGAN A RECE/ SOLO VUELO', '2019-10-31 13:51:43', 8),
(1915, 9, NULL, 'MARIANA', 'PEREIRA', 'mpereira@rojassa.com', NULL, '50688204427', 35, 11, 0, 38, 3, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 11 PAX DE 45 MIN. APROX. SOBRE VALLE DE TEOTIHUACAN.\nCOFFEE BREAK ANTES DE VUELO. \nSEGURO DE VIAJERO. \nBRINDIS CON VINO ESPUMOSO. \nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, NULL, '0.00', 21450.00, 0, '789.00', 1, 0, NULL, 1, 'REPROGRAMACION EL 31 OCT/ ANTICIPO EN SITIO $2,000 CON TC/ 789 KG', '2019-10-31 14:09:00', 4),
(1916, 9, '1880', 'JONATHAN ', 'LOPEZ', ' rosillo.vianey@hotmail.com', NULL, '999999999', 11, 2, 0, 36, 3, '2019-10-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nTRANSPORTE REDONDO CDMX-TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.', 'PESO EXTRA', '725.00', NULL, NULL, 2, '200.00', 5425.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-31 14:20:22', 6),
(1917, 9, '1916', 'JONATHAN ', 'LOPEZ', 'turismo@volarenglobo.com.mx', NULL, '999999999', 11, 2, 0, 36, 3, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nTRANSPORTE REDONDO CDMX-TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.', 'PESO EXTRA', '725.00', NULL, NULL, 2, '200.00', 5425.00, 0, '409.00', 2, 0, NULL, 1, NULL, '2019-10-31 14:26:28', 8),
(1918, 14, NULL, 'GEOVANNI', 'DURAN', 'ventas@volarenglobo.com.mx', NULL, '5538972656', 35, 8, 0, 36, 1, '2019-10-31', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 8 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'IVA', '2739.00', NULL, NULL, 2, '2400.00', 19859.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-31 14:46:19', 6),
(1919, 14, NULL, 'YUSHIN', '.', 'ventas@volarenglobo.com.mx', NULL, '97433916826', 35, 3, 0, 73, 1, '2019-10-31', NULL, NULL, NULL, NULL, NULL, 'Hot Air Balloon Ride\nCoffee Break, Transportation during the activity (check-in area-takeoff area and landing site â€“ check in area),Personalized Flight Certificate\nSparkling wine toast, breakfast bufett\n', 'BREAKFAST', '297.00', NULL, NULL, NULL, '0.00', 7197.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-10-31 15:09:39', 6),
(1920, 14, '1919', 'YUSHIN', '.', 'ventas@volarenglobo.com.mx', NULL, '97433916826', 35, 3, 0, 73, 1, '2019-10-31', NULL, NULL, NULL, NULL, NULL, 'Hot Air Balloon Ride\nCoffee Break, Transportation during the activity (check-in area-takeoff area and landing site â€“ check in area),Personalized Flight Certificate\nSparkling wine toast\n', NULL, NULL, NULL, NULL, NULL, '0.00', 6900.00, 0, '0.00', 1, 0, NULL, 2, NULL, '2019-10-31 15:23:56', 6),
(1921, 14, '1918', 'GEOVANNI', 'DURAN', 'ventas@volarenglobo.com.mx', NULL, '5538972656', 35, 8, 0, 36, 1, '2019-10-01', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 8 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'IVA', '2739.00', NULL, NULL, 2, '2400.00', 19859.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-31 15:38:59', 6),
(1922, 14, '1921', 'GEOVANNI', 'DURAN', 'ventas@volarenglobo.com.mx', NULL, '5538972656', 35, 8, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 8 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'IVA', '2739.00', NULL, NULL, 2, '2400.00', 19859.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-31 15:39:57', 8),
(1923, 16, NULL, 'TERESA', 'HURTADO', 'tetehp@gmail.com', NULL, '50257039265', NULL, 2, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '132.00', 1, 0, NULL, 1, NULL, '2019-10-31 16:04:15', 8),
(1924, 14, NULL, 'SHARON', 'MUSTRIS', 'sharonmustris@gmail.com', NULL, '5530356518', 11, 2, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS', '198.00', 'TRANSPORTE ZONA ZOCA', '700.00', NULL, '0.00', 5498.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-31 16:16:49', 6),
(1925, 14, NULL, 'ROCIO', 'AKE', 'rocioake_@hotmail.com', NULL, '5219811168464', 11, 1, 0, 36, 1, '2019-12-07', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', 'DESAYUNO Y DESAYUNO ', '239.00', 'TRANSP ADICIONAL', '500.00', NULL, '0.00', 3539.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-31 16:23:57', 3),
(1926, 14, '1920', 'YUSHIN', '.', 'ventas@volarenglobo.com.mx', NULL, '97433916826', 35, 3, 0, 73, 1, '2019-10-31', NULL, NULL, NULL, NULL, NULL, 'Hot Air Balloon Ride\nCoffee Break, Transportation during the activity (check-in area-takeoff area and landing site â€“ check in area),Personalized Flight Certificate\nSparkling wine toast\n', 'TRANSPORTE ZOCALO', '1050.00', NULL, NULL, NULL, '0.00', 7950.00, 0, '201.00', 1, 0, NULL, 2, NULL, '2019-10-31 16:36:15', 6),
(1927, 14, '1924', 'SHARON', 'MUSTRIS', 'ventas@volarenglobo.com.mx', NULL, '5530356518', 11, 2, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO.', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-31 18:42:52', 8),
(1928, 16, NULL, 'VICTOR', 'SALDIVAR', 'bikthorxavyer@gmail.com', NULL, '5545470494', NULL, 2, 0, 36, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-31 19:11:16', 3),
(1929, 14, '1926', 'YUSHIN', '.', 'ventas@volarenglobo.com.mx', NULL, '97433916826', 35, 3, 0, 73, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Hot Air Balloon Ride\nCoffee Break, Transportation during the activity (check-in area-takeoff area and landing site â€“ check in area),Personalized Flight Certificate\nSparkling wine toast\n', NULL, NULL, NULL, NULL, NULL, '0.00', 6900.00, 0, '201.00', 1, 0, NULL, 2, NULL, '2019-10-31 19:25:16', 8),
(1930, 14, NULL, 'MA TERESA ', 'SUNES', 'mate74@gmail.com', NULL, '50372187573', 35, 1, 0, 36, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN ) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '99.00', NULL, NULL, NULL, '0.00', 2399.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-10-31 19:59:27', 6),
(1931, 14, NULL, 'JORGE ', 'BARRON', 'ventas@volarenglobo.com.mx', NULL, '999999', 11, 2, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,  SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '120.00', 1, 0, NULL, 1, NULL, '2019-10-31 22:06:32', 8),
(1932, 14, NULL, 'ANDREA', 'NATALIA', 'andreanataliasr@gmail.com', NULL, '99999', 11, 2, 0, 37, 1, '2019-11-10', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y,  SEGURO DE VIAJERO;BRINDIS CON VINO ESPUMOSO ,CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI DESPLIEGUE DE LONA FELIZ ANIVERSARIO ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '140.00', 1, 0, NULL, 1, NULL, '2019-10-31 22:25:19', 8),
(1933, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 04:12:19', 0),
(1934, 14, NULL, 'DIEGO ALEXANDER', 'MONGUI', 'Theater489@gmail.com', NULL, '573013376081', 35, 4, 0, 36, 1, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS ,  VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI.', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 9596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 11:49:15', 6),
(1935, 14, '1930', 'MA TERESA ', 'SUNES', 'mate74@gmail.com', NULL, '50372187573', 35, 3, 0, 36, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN ) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 7197.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 11:55:59', 6),
(1936, 14, NULL, 'MARIO', 'MANJARREZ', 'Mario.manjarres@gmail.com', NULL, '573185321345', 35, 2, 1, 38, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 ADULTOS 1 MENOR, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO,BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 6597.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 12:09:18', 3),
(1937, 9, NULL, 'YUEDAN ', ' YANG', 'turismo@volarenglobo.com.mx', NULL, '16174136534', 35, 2, 0, 36, 3, '2019-11-03', NULL, NULL, NULL, NULL, NULL, '**** 2019-11-03 ****\nâ€ƒâ€ƒTicket Type: Traveler: 2 ()\nâ€ƒâ€ƒPrimary Redeemer: Yuedan Yang, 16174136534, 736368769@qq.com\nâ€ƒâ€ƒValid Day: Nov 3, 2019\nâ€ƒâ€ƒItem: Teotihuacan Pyramids Hot-Air Balloon Flight / 6:00 AM, Flight Only / 525355\nâ€ƒâ€ƒVoucher: 80690395, 80690396\nâ€ƒâ€ƒItinerary: 7490813449173\n', NULL, NULL, NULL, NULL, NULL, '0.00', 3900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 12:20:15', 8),
(1938, 16, NULL, 'JESUS', 'HERNANDEZ', 'jessayala2016@gmail.com', NULL, '5554308887', NULL, 15, 0, 36, 2, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', 'TRANSPORTE PARA 15 P', '4550.00', 'DESAYUNO BUFFET 15 P', '2250.00', NULL, '0.00', 36800.00, 0, '1060.00', 1, 0, NULL, 1, NULL, '2019-11-01 12:22:21', 6),
(1939, 16, NULL, 'MARIA ELENA', 'PACHECO', 'elenapachecoh@hotmail.com', NULL, '7838390266', NULL, 3, 1, 38, 1, '2019-11-29', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n FELIZ CUMPLE!', NULL, NULL, NULL, NULL, 2, '164.00', 8996.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 13:15:36', 6),
(1940, 14, NULL, 'BENJAMIN', 'MAR', 'benjamin.mar@daimler.com', NULL, '4497699753', 35, 2, 0, 36, 1, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS,VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO , CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL DURANTE LA ACTIVIDAD,DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI .', 'DESAYUNOS', '198.00', 'TRANSPORTE ZONA ZOCA', '700.00', NULL, '0.00', 5498.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 13:25:24', 3),
(1941, 9, NULL, 'JONH', 'ORTEGA', 'hector@ruizmed.com.mx', NULL, '5510411697', 11, 1, 0, 36, 3, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 1 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, 2, '200.00', 1750.00, 0, '75.00', 1, 0, NULL, 1, NULL, '2019-11-01 13:34:40', 8),
(1942, 14, '1935', 'MA TERESA ', 'SUNES', 'ventas@volarenglobo.com.mx', NULL, '50372187573', 35, 1, 0, 36, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN ) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '99.00', NULL, NULL, NULL, '0.00', 2399.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 13:58:47', 8),
(1943, 9, NULL, 'CARLOS', ' DEL CAMPO', 'hector@ruizmed.com.mx', NULL, '5510411697', 11, 2, 0, 36, 3, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, 2, '400.00', 3500.00, 0, '146.00', 1, 0, NULL, 1, NULL, '2019-11-01 14:10:40', 8),
(1944, 14, NULL, 'MIGUEL', 'AMOROSO', 'ventas@volarenglobo.com.mx', NULL, '99999', 35, 2, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX  , VUELO BASICO ', NULL, NULL, NULL, NULL, 2, '600.00', 4000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 14:10:56', 8),
(1945, 16, NULL, 'JOSE', 'LIRA', 'reserva@volarenglobo.com.mx', NULL, '5554198309', NULL, 3, 0, 36, 1, '2019-11-01', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 6900.00, 0, '290.00', 1, 0, NULL, 1, NULL, '2019-11-01 14:22:16', 8),
(1946, 9, NULL, 'JUAN', ' VELEZ', 'hector@ruizmed.com.mx', NULL, '5510411697', 11, 2, 0, 36, 3, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, 2, '400.00', 3500.00, 0, '145.00', 1, 0, NULL, 1, NULL, '2019-11-01 14:33:05', 8),
(1947, 14, NULL, 'IVETTE ', 'ROMAB', 'Sugarpopanama@gmail.com', NULL, '50763144918', 35, 2, 0, 36, 1, '2019-11-11', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO , BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL DURANTE LA ACTIVIDAD, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI , TRANSP CDMX-TEOTIHUACAN-CDMX (CENTRO)', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 14:39:45', 3),
(1948, 9, NULL, 'BRISA', 'TOURS', 'turismo@volarenglobo.com.mx', NULL, '999999999', 11, 4, 0, 36, 3, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 4 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.\n', NULL, NULL, NULL, NULL, NULL, '0.00', 7800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 14:40:48', 8),
(1949, 14, NULL, 'IVETTE', 'ROMAB', 'Sugarpopanama@gmail.com', NULL, '50763144918', 35, 2, 0, 36, 1, '2019-11-11', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS , VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE, TE , GALLETAS Y PAN) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL DURANTE LA ACTIVIDAD', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 14:42:23', 6),
(1950, 9, NULL, 'GENA ', 'Y BRIAN', 'j.santos@wayakbus.com', NULL, '5516123007', 11, 2, 0, 37, 3, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nTRANSPORTE REDONDO CDMX-TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.\nDESAYUNO BUFFET.', NULL, NULL, NULL, NULL, 2, '530.00', 5700.00, 0, '165.00', 1, 0, NULL, 1, NULL, '2019-11-01 14:50:00', 8),
(1951, 16, NULL, 'DANIEL', 'SANTOS TABORA', 'ventas@vivelatours.com', NULL, '5510998008', NULL, 4, 0, 36, 2, '2019-11-20', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 11760.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 14:52:36', 3),
(1952, 16, NULL, 'RENATA', 'ZARATE', 'rzarate@fumec.org', NULL, '5530455382', NULL, 5, 2, 36, 1, '2019-12-24', NULL, 1, 20, '2019-12-23', '2019-12-25', 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', 'HABITACIÃ“N TRIPLE  ', '2900.00', NULL, NULL, 2, '287.00', 21793.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 15:07:34', 3),
(1953, 14, NULL, 'JAIME', 'LARREA', 'jaimelarream@gmail.com', NULL, '5521065320', 11, 3, 0, 36, 1, '2019-11-29', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 7197.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 15:17:43', 3),
(1954, 14, NULL, 'ARIANA', 'DOMENICA', 'areanebravo@gmail.com', NULL, '593994697289', 35, 1, 0, 36, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y TRANSPORTE CDMX-TEOTIHUACAN-CDMX (CENTRO)', 'DESAYUNO ', '99.00', NULL, NULL, NULL, '0.00', 2899.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 15:38:17', 3),
(1955, 14, NULL, 'JUAN CARLOS ', 'REYES', 'juan17_chirias@hotmail.com', NULL, '4494123527', 21, 2, 0, 39, 4, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA \"TE QUIERES CASAR CONMIGO\"  DESAYUNO EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 16:05:35', 3),
(1956, 14, NULL, 'MARIANA', 'MENDOZA', 'marianamj11@gmail.com', NULL, '50250458985', 35, 2, 0, 36, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 16:16:22', 6),
(1957, 14, NULL, 'ERIKA DENISSE', 'ANDRADE', 'denisseandrade2911@gmail.com', NULL, '2224845901', 11, 3, 2, 38, 1, '2019-11-29', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 ADULTOS 2 MENORES , VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI , PASTEL PARA CUMPLEAÃ‘ERO Y DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\"', 'DESAYUNOS', '495.00', NULL, NULL, NULL, '0.00', 10795.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 16:52:04', 3),
(1958, 14, NULL, 'ROBERTO', 'BARRIGA', 'ventas@volarenglobo.com.mx', NULL, '593959864', 35, 2, 0, 36, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 17:49:24', 8),
(1959, 16, '1939', 'MARIA ELENA', 'PACHECO', 'elenapachecoh@hotmail.com', NULL, '7838390266', NULL, 3, NULL, 38, 1, '2019-11-29', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n FELIZ CUMPLE!', NULL, NULL, NULL, NULL, 2, '123.00', 7197.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 17:50:41', 8),
(1960, 14, NULL, 'ANDREA', 'BORREGO', 'ventas@volarenglobo.com.mx', NULL, '5565791742', 35, 5, 0, 36, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 5 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, NULL, '0.00', 11500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 17:58:00', 8),
(1961, 16, NULL, 'VICTOR HUGO', 'ROCHA', 'victor.rochamedina@outlook.com', NULL, '5587668632', NULL, 2, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '130.00', 1, 0, NULL, 1, NULL, '2019-11-01 17:59:21', 8),
(1962, 16, NULL, 'ALESSANDRA', 'AMIUNA', 'amiunaale@gmail.com', NULL, '55995527260', NULL, 1, 0, NULL, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', 'TRANSPORTE REDONDO Z', '350.00', NULL, NULL, NULL, '0.00', 2650.00, 0, '78.00', 1, 0, NULL, 1, NULL, '2019-11-01 18:02:04', 8),
(1963, 9, NULL, 'WESLEY  ELIZABETH', ' CULLEN', 'ana@nomadictotem.com', NULL, '999999', 35, 2, 0, 36, 3, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.\nDESAYUNO BUFFET.', NULL, NULL, NULL, NULL, 2, '120.00', 4060.00, 0, '176.00', 1, 0, NULL, 1, NULL, '2019-11-01 18:22:43', 8),
(1964, 14, '1934', 'DIEGO ALEXANDER', 'MONGUI', 'Theater489@gmail.com', NULL, '573013376081', 35, 2, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS ,  VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX.INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI.', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '145.00', 1, 0, NULL, 1, NULL, '2019-11-01 18:57:06', 8);
INSERT INTO `temp_volar` (`id_temp`, `idusu_temp`, `clave_temp`, `nombre_temp`, `apellidos_temp`, `mail_temp`, `telfijo_temp`, `telcelular_temp`, `procedencia_temp`, `pasajerosa_temp`, `pasajerosn_temp`, `motivo_temp`, `tipo_temp`, `fechavuelo_temp`, `tarifa_temp`, `hotel_temp`, `habitacion_temp`, `checkin_temp`, `checkout_temp`, `comentario_temp`, `otroscar1_temp`, `precio1_temp`, `otroscar2_temp`, `precio2_temp`, `tdescuento_temp`, `cantdescuento_temp`, `total_temp`, `piloto_temp`, `kg_temp`, `tipopeso_temp`, `globo_temp`, `hora_temp`, `idioma_temp`, `comentarioint_temp`, `register`, `status`) VALUES
(1965, 16, NULL, 'CAROL', 'MARROQUIN', 'krol.vivi.mm@gmail.com', NULL, '573006829737', NULL, 8, 0, 36, 2, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break, cafÃ©, te, galletas, pan, fruta', NULL, NULL, NULL, NULL, NULL, '0.00', 16000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 20:06:59', 6),
(1966, 16, NULL, 'ELIAS', 'LITCHI', 'elias.litchi@gmail.com', NULL, '5554375569', NULL, 3, 0, NULL, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos.\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\n', NULL, NULL, NULL, NULL, NULL, '0.00', 6900.00, 0, '195.00', 1, 0, NULL, 1, NULL, '2019-11-01 20:25:41', 8),
(1967, 14, NULL, 'LUIS ', 'RAMIREZ ', 'ventas@volarenglobo.com.mx', NULL, '9999999', NULL, 1, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,  SEGURO DE VIAJERO  , BRINDIS CON VINO ESPUMOSO,  CERTIFICADO PERSONALIZADO,  DESAYUNO ', 'DESAYUNO', '99.00', NULL, NULL, NULL, '0.00', 2899.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 20:28:38', 6),
(1968, 16, NULL, 'SARAI', 'BLANCO', 'sarax_777@hotmail.com', NULL, '393481532625', NULL, 2, 0, NULL, 1, '2019-12-28', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 20:28:49', 8),
(1969, 14, NULL, 'CESAR ', 'GONZÃLEZ ', 'cegon08@gmail.com', NULL, '5617920532', 35, 2, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS,  VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,  SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO  ,DESAYUNO BUFFET.', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 20:40:39', 6),
(1970, 14, '1969', 'CESAR ', 'GONZÃLEZ ', 'cegon08@gmail.com', NULL, '5617920532', 35, 2, 0, 36, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS,  VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,  SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO  ,DESAYUNO BUFFET.', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 21:12:27', 3),
(1971, 14, '1967', 'LUIS ', 'RAMIREZ ', 'ventas@volarenglobo.com.mx', NULL, '9999999', NULL, 3, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,  SEGURO DE VIAJERO  , BRINDIS CON VINO ESPUMOSO,  CERTIFICADO PERSONALIZADO,  DESAYUNO ', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 8697.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 21:25:00', 8),
(1972, 14, NULL, 'LUIS CARLOS', 'RAMÃREZ ', 'ventas@volarenglobo.com.mx', NULL, '9999999', 35, 1, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNO ', '99.00', NULL, NULL, NULL, '0.00', 2899.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 21:52:27', 8),
(1973, 16, '1965', 'CAROL', 'MARROQUIN', 'krol.vivi.mm@gmail.com', NULL, '573006829737', NULL, 10, 0, 36, 2, '2019-11-02', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break, cafÃ©, te, galletas, pan, fruta', NULL, NULL, NULL, NULL, NULL, '0.00', 20000.00, 0, '715.00', 1, 0, NULL, 1, NULL, '2019-11-01 21:57:24', 8),
(1974, 14, NULL, 'MILAGROS ', 'ESTEBAN', 'ventas@volarenglobo.com.mx', NULL, '9999', 11, 2, 0, 36, 1, '2019-11-02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 22:01:24', 3),
(1975, 14, NULL, 'CLAUDIA MERCEDES ', 'IBARRA', 'claudia_sim24@hotmail.com', NULL, '999999', 35, 2, 0, 38, 1, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS,  VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL Y DESAYUNO BUFFET, PASTEL PARA CUMPLEAÃ‘ERO Y DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS \" ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 22:08:39', 8),
(1976, 14, NULL, 'YERALDINE CRISTINA', 'OROZCO', 'ventas@volarenglobo.com.mx', NULL, '999999', 35, 2, 0, 36, 4, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS,  VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO Y  DESAYUNO Y FOTO IMPRESA ', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 22:24:18', 8),
(1977, 16, NULL, 'BERNARDETTE', 'MERE', ' tetemere@hotmail.com', NULL, '50253156468', NULL, 3, 0, 36, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet\nTransporte redondo CDMX TEOTIHUACÃN\n', NULL, NULL, NULL, NULL, 2, '123.00', 8697.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-01 22:48:16', 6),
(1978, 16, '1977', 'BERNARDETTE', 'MERE', ' tetemere@hotmail.com', NULL, '50253156468', NULL, 3, 0, 36, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet\nTransporte redondo CDMX TEOTIHUACÃN\n', NULL, NULL, NULL, NULL, 2, '900.00', 7920.00, 0, '195.00', 1, 0, NULL, 1, NULL, '2019-11-01 22:57:22', 8),
(1979, 9, NULL, 'XIANG', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-02 00:07:27', 0),
(1980, 9, NULL, 'XIANG', 'GAO', 'turismo@volarenglobo.com.mx', NULL, '9999', NULL, 5, 0, 36, 3, '2019-11-04', NULL, NULL, NULL, NULL, NULL, '5 pax compartido booking full', NULL, NULL, NULL, NULL, 2, '837.50', 13387.50, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-02 00:08:23', 8),
(1981, 9, NULL, 'LISSETTE NATHALY', 'OROZCO', 'turismo@volarenglobo.com.mx', NULL, '99999', 17, 1, 0, 36, 3, '2019-11-18', NULL, NULL, NULL, NULL, NULL, '1-pax compartido con transporte booking', NULL, NULL, NULL, NULL, 2, '100.00', 2350.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-02 00:12:15', 8),
(1982, 14, NULL, 'YADIRA', 'ZUÃ‘IGA', 'yadirazcr@hotmail.com', NULL, '50688741068', 35, 5, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 5 ADULTOS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX. INCLUYE COFFE BREAK, CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL Y DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '495.00', NULL, NULL, NULL, '0.00', 11995.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-02 12:13:46', 8),
(1983, 14, NULL, 'ROGELIO', 'FERNÃNDEZ ', 'rogeliofc@hotmail.com', NULL, '5539264580', 35, 1, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL DURANTE LA ACTIVIDAD EN TEOTIHUACÃN, TRANSPORTE CDMX-TEOTIHUACAN-CDMX CENTRO ', 'DESAYUNO ', '99.00', NULL, NULL, NULL, '0.00', 2899.00, 0, '90.00', 1, 0, NULL, 1, NULL, '2019-11-02 12:26:06', 8),
(1984, 16, NULL, 'MIGUEL ALBERTO', 'CHACÃ“N', 'muebleselesfuerzo3@gmail.com', NULL, '50251638962', NULL, 3, 0, 36, 2, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet', NULL, NULL, NULL, NULL, NULL, '0.00', 6420.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-02 14:34:27', 8),
(1985, 16, NULL, 'PAULINA ', 'MOLINA', 'pau.molina09@gmail.com', NULL, '5532321995', NULL, 2, 0, 36, 1, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '130.00', 1, 0, NULL, 1, NULL, '2019-11-02 16:21:18', 8),
(1986, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-02 16:24:02', 0),
(1987, 16, NULL, 'JOSE LUIS', 'PANTOJA', 'jlpantoja@gmail.com', NULL, '5522703627', NULL, 2, 0, 36, 1, '2019-11-13', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '130.00', 1, 0, NULL, 1, NULL, '2019-11-02 16:24:17', 8),
(1988, 16, '1938', 'JESUS', 'HERNANDEZ', 'jessayala2016@gmail.com', NULL, '5554308887', NULL, 14, 0, 36, 2, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', 'TRANSPORTE PARA 14 P', '4550.00', 'DESAYUNO BUFFET 14 P', '2100.00', NULL, '0.00', 34650.00, 0, '1057.00', 1, 0, NULL, 1, NULL, '2019-11-02 20:15:13', 8),
(1989, 14, NULL, 'MAYRA', 'FERRO', 'Mayara_f_b@hotmail.com', NULL, '558282167406', 35, 3, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN  ,SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO  CERTIFICADO PERSONALIZADO,  DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI,', 'ENTRADAS ZONA ARQUEO', '225.00', 'DESAYUNOS', '297.00', NULL, '0.00', 9822.00, 0, '184.00', 1, 0, NULL, 1, NULL, '2019-11-02 20:32:33', 8),
(1990, 14, NULL, 'HAROLDO', 'ESTUARDO', 'hgarquitecturahg@gmail.com', NULL, '50240737454', 35, 2, 0, 36, 4, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO,DESAYUNO BUFFET Y FOTO IMPRESA ', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-02 20:42:35', 6),
(1991, 14, NULL, 'LAURA', 'PERDOMO ', 'lamajiela.ing@gmail.com', NULL, '573192474132', 35, 5, 0, 36, 1, '2019-11-08', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 5 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN  SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO CERTIFICADO PERSONALIZADO DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '495.00', 'TRANSPORTE ZOCALI', '1750.00', NULL, '0.00', 15020.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-02 21:16:00', 6),
(1992, 14, NULL, 'XIOMARA ', 'BAUTISTA', 'xiomi.9317@gmail.com', NULL, '9999999', 35, 2, 0, 36, 1, '2019-11-14', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN SEGURO DE VIAJERO , BRINDIS CON VINO ESPUMOSO , CERTIFICADO PERSONALIZADO DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-02 21:33:15', 6),
(1993, 14, '1991', 'LAURA', 'PERDOMO ', 'lamajiela.ing@gmail.com', NULL, '573192474132', 35, 4, 0, 36, 1, '2019-11-08', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN  SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO CERTIFICADO PERSONALIZADO DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '536.00', 'TRANSPORTE ZOCALI', '1750.00', NULL, '0.00', 12686.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-02 21:36:09', 6),
(1994, 16, NULL, 'CARLOS ANDRÃ‰S', 'PEREZ', 'carlosap@gmail.com', NULL, '573017560517', NULL, 3, 0, 36, 1, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break', NULL, NULL, NULL, NULL, NULL, '0.00', 6900.00, 0, '255.00', 1, 0, NULL, 1, NULL, '2019-11-02 21:41:11', 8),
(1995, 14, '1993', 'LAURA', 'PERDOMO ', 'lamajiela.ing@gmail.com', NULL, '573192474132', 35, 4, 0, 36, 1, '2019-11-08', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN  SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO CERTIFICADO PERSONALIZADO DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS Y 1 ENTRAD', '611.00', 'TRANSPORTE ZOCALI', '1750.00', NULL, '0.00', 13361.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-02 22:03:40', 8),
(1996, 16, NULL, 'MAURICIO', 'M', 'mauromovil@hotmail.es', NULL, '4421608443', NULL, 3, 0, NULL, 1, '2019-11-03', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break', NULL, NULL, NULL, NULL, NULL, '0.00', 6900.00, 0, '245.00', 1, 0, NULL, 1, NULL, '2019-11-02 22:08:26', 8),
(1997, 14, NULL, 'HAISEL', 'CASTILLO ', 'hazelmabell@hotmail.com', NULL, '50688698851', 35, 8, 0, 36, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 5 PERSONAS SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', NULL, NULL, NULL, NULL, 2, '2400.00', 17120.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-02 22:16:15', 6),
(1998, 14, '1997', 'HAISEL', 'CASTILLO ', 'hazelmabell@hotmail.com', NULL, '50688698851', 35, 8, 0, 36, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 5 PERSONAS SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', NULL, NULL, NULL, NULL, 2, '2400.00', 23220.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-02 23:23:02', 6),
(1999, 16, NULL, 'GABRIELA', 'VIZCONDE', 'viz_mar@hotmail.com', NULL, '51947685992', NULL, 1, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet', NULL, NULL, NULL, NULL, NULL, '0.00', 2300.00, 0, '53.00', 1, 0, NULL, 1, NULL, '2019-11-03 01:18:35', 8),
(2000, 14, '1998', 'HAISEL', 'CASTILLO ', 'hazelmabell@hotmail.com', NULL, '50688698851', 35, 8, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 5 PERSONAS SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', NULL, NULL, NULL, NULL, 2, '2400.00', 23220.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-03 10:56:23', 8),
(2001, 14, NULL, 'RODNEY', 'REYES', 'ventas@volarenglobo.com.mx', NULL, '999999', 35, 2, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '151.00', 1, 0, NULL, 1, NULL, '2019-11-03 11:41:49', 8),
(2002, 9, NULL, 'ELEODORO', 'OLIVARES', 'turismo@volarenglobo.com.mx', NULL, '942945765', 35, 1, 0, 36, 3, '2019-11-06', NULL, NULL, NULL, NULL, NULL, '1-pax compartido booking con transporte', NULL, NULL, NULL, NULL, 2, '100.00', 2350.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-03 12:21:19', 8),
(2003, 16, NULL, 'MARIANA', 'CASTRO', 'marihi21@gmail.com', NULL, '573143585454', NULL, 2, 0, 36, 2, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet', NULL, NULL, NULL, NULL, NULL, '0.00', 5280.00, 0, '143.00', 1, 0, NULL, 1, NULL, '2019-11-03 14:38:45', 6),
(2004, 16, NULL, 'ROBERTO', 'HERRERA', 'robertoherrerab@me.com', NULL, '6561023151', NULL, 2, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-03 14:46:52', 3),
(2005, 9, NULL, 'ANITA', 'NASEER', 'turismo@volarenglobo.com.mx', NULL, '5215535721478', NULL, 2, 0, NULL, 3, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 2 pax guÃ­a Juan Gonez', 'AJUSTE', '100.00', NULL, NULL, NULL, '0.00', 4000.00, 0, '126.00', 1, 0, NULL, 1, NULL, '2019-11-03 15:01:39', 8),
(2006, 9, NULL, 'ANNETE ', 'PATINO', 'turismo@volarenglobo.com.mx', NULL, '121193142039', NULL, 4, 0, NULL, 3, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'PASAJEROS OPERADOR VIANEY TRANSPORTE REDONDO', 'TRANSPORTE REDONDO $', '1600.00', NULL, NULL, NULL, '0.00', 9400.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-03 15:29:47', 8),
(2007, 16, NULL, 'CARLOS', 'BEDOYA', 'carlosfbedoya@hotmail.com', '573128430329', '5579156210', NULL, 5, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet', NULL, NULL, NULL, NULL, NULL, '0.00', 11500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-03 15:46:49', 3),
(2008, 9, NULL, 'CAROLINA', 'CARO', 'turismo@volarenglobo.com.mx', NULL, '5556529331', 11, 1, 0, 36, 3, '2019-11-05', NULL, NULL, NULL, NULL, NULL, '1 pax compartido con transporte wayak', NULL, NULL, NULL, NULL, 2, '250.00', 2200.00, 0, '76.00', 1, 0, NULL, 1, NULL, '2019-11-03 16:55:41', 8),
(2009, 16, NULL, 'JORGE', 'ARCHE', 'jorge_arche@email.com', NULL, '593984755232', NULL, 2, 0, 36, 2, '2019-11-04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet', '2019-11-03 17:06:12', 6),
(2010, 16, '2009', 'JORGE', 'ARCE', 'jorge_arce@email.com', NULL, '593984755232', NULL, 2, 0, 36, 2, '2019-11-04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 4280.00, 0, '130.00', 1, 0, NULL, 1, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet', '2019-11-03 17:15:46', 8),
(2011, 14, NULL, 'RUDY', 'HUAMAN', 'Rudy.huamanq@gmail.com', NULL, '980314278', 35, 2, 0, 36, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO,  BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-03 17:51:39', 3),
(2012, 14, NULL, 'RUDY ', 'HUAMAN', 'Rudy.huamanq@gmail.com', NULL, '980314278', 35, 2, 0, 36, 4, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET Y FOTO IMPRESA ', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-03 17:55:50', 6),
(2013, 16, '2003', 'MARIANA', 'CASTRO', 'marihi21@gmail.com', NULL, '573143585454', NULL, 2, 0, 36, 2, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet', NULL, NULL, NULL, NULL, NULL, '0.00', 4280.00, 0, '143.00', 1, 0, NULL, 1, NULL, '2019-11-03 18:55:12', 8),
(2014, 16, NULL, 'FRANCISCO', 'GONZÃLEZ', 'fjgonzalez1@hotmail.com', NULL, '573125888102', NULL, 2, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nEntrada a pirÃ¡mides', NULL, NULL, NULL, NULL, NULL, '0.00', 4750.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-03 19:19:34', 8),
(2015, 14, '1764', 'KATHERINE ', 'HERNÃNDEZ ', 'Kat.dha11@live.com', NULL, '50683093056', 35, 2, 0, 36, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-03 21:28:05', 6),
(2016, 14, NULL, 'MA ALEJANDRA ', 'RAMÃREZ ', 'alejajjcf@hotmail.com', NULL, '5614030753', 35, 1, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONA ,VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN ,SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO', NULL, NULL, NULL, NULL, NULL, '0.00', 2300.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-03 22:18:32', 6),
(2017, 14, '2016', 'MA ALEJANDRA ', 'RAMÃREZ ', 'alejajjcf@hotmail.com', NULL, '5614030753', 35, 1, 0, 36, 1, '2019-11-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONA ,VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN ,SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO', NULL, NULL, NULL, NULL, 2, '300.00', 2140.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-03 22:32:23', 3),
(2018, 9, NULL, 'PEDRO ', ' GUZMAN', 'turismo@volarenglobo.com.mx', NULL, '17875389143', 11, 4, 0, 36, 3, '2019-12-28', NULL, NULL, NULL, NULL, NULL, '**** 2019-12-28 ****\nâ€ƒâ€ƒTicket Type: Traveler: 4 ()\nâ€ƒâ€ƒPrimary Redeemer: Pedro Guzman, 17875389143, pedro.guzman1@upr.edu\nâ€ƒâ€ƒValid Day: Dec 28, 2019\nâ€ƒâ€ƒItem: Teotihuacan Pyramids Hot-Air Balloon Flight / 5:00 AM, Flight with Transportation / 529019\nâ€ƒâ€ƒVoucher: 80713525, 80713526, 80713527, 80713528\nâ€ƒâ€ƒItinerary: 7491451748488\nâ€ƒâ€ƒCustomer Staying At: Hotel El Ejecutivo by Reforma Avenue; Viena 8 Col Juarez, Mexico City, CDMX \n', NULL, NULL, NULL, NULL, 2, '200.00', 9600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 10:29:17', 8),
(2019, 16, NULL, 'MOISES', 'ASSA', 'moises.assa14@gmail.com', NULL, '5591850065', NULL, 2, 0, 36, 4, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7500.00, 0, '132.00', 1, 0, NULL, 1, NULL, '2019-11-04 10:35:01', 8),
(2020, 16, NULL, 'ALEJANDRA', 'RAMIREZ', 'sakuraa_li@hotmail.com', NULL, '50688492885', NULL, 5, 0, 36, 2, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break ', NULL, NULL, NULL, NULL, NULL, '0.00', 10700.00, 0, '290.00', 1, 0, NULL, 1, NULL, '2019-11-04 10:47:23', 8),
(2021, 16, NULL, 'ANDREA', 'CHALARCA', 'andrea.chalarca@gmail.com', NULL, '56981371511', NULL, 3, 0, 36, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break /', NULL, NULL, NULL, NULL, NULL, '0.00', 6900.00, 0, '244.00', 1, 0, NULL, 1, NULL, '2019-11-04 11:01:57', 8),
(2022, 14, '1992', 'XIOMARA ', 'BAUTISTA', 'xiomi.9317@gmail.com', NULL, '9999999', 35, 2, 0, 36, 1, '2019-11-14', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN SEGURO DE VIAJERO , BRINDIS CON VINO ESPUMOSO , CERTIFICADO PERSONALIZADO DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '125.00', 1, 0, NULL, 1, NULL, '2019-11-04 11:48:25', 8),
(2023, 14, NULL, 'EDURADO', 'ARIAS', 'arq.arias09@gmail.com', NULL, '573003928932', 35, 2, 0, 39, 4, '0219-11-11', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA DE \"TE QUIERES CASAR CONMIGO\"  DESAYUNO EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', 'MARIACHI', '6000.00', NULL, NULL, NULL, '0.00', 13000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 11:56:13', 3),
(2024, 14, NULL, 'OWEN', 'ACEVEDO', 'owenacevedo@gmail.com', NULL, '7875288271', 35, 2, 0, 36, 1, '2019-11-10', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 42PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ,TRANSPORTE REDONDO ZONA CENTRO', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 12:34:18', 3),
(2025, 14, NULL, 'STEPFHANIE', 'DIAZ', 'stepfydiaz@gmail.com', NULL, '3143920265', 35, 4, 0, 36, 1, '0019-12-17', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 11596.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 13:16:10', 3),
(2026, 14, NULL, 'ESTEFANIA ', 'FRISANCHO', 'efrisancho@pucp.pe', NULL, '51986688019', 35, 2, 0, 36, 1, '2019-11-11', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 13:26:37', 3),
(2027, 14, NULL, 'ISIOCARI', 'SANCHEZ', 'isiokari@gmail.com', NULL, '7471854844', 35, 2, 0, 36, 4, '2020-01-02', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA , DESAYUNO EN RESTAURANTE Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 13:56:42', 3),
(2028, 16, NULL, 'MARYCARMEN', 'CALVO ORTEGA', 'mco.2192@gmail.com', NULL, '7771363674', NULL, 2, 0, 37, 4, '2019-12-14', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 14:08:44', 3),
(2029, 16, NULL, 'EDWIN', 'BARBOSA', 'Edwinoswal87@hotmail.com', NULL, '573173140407', NULL, 5, 0, 36, 2, '2019-11-06', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 10700.00, 0, '335.00', 1, 0, NULL, 1, NULL, '2019-11-04 14:14:43', 8),
(2030, 14, NULL, 'JOSE', 'QUIR', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 14:18:18', 0),
(2031, 14, '2015', 'KATHERINE ', 'HERNÃNDEZ ', 'Kat.dha11@live.com', NULL, '50683093056', 35, 2, 0, 36, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN,SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS ', '198.00', 'TRANSPORTE RED CENTR', '700.00', NULL, '0.00', 5498.00, 0, '134.00', 1, 0, NULL, 1, NULL, '2019-11-04 14:26:52', 8),
(2032, 14, '2012', 'RUDY ', 'HUAMAN', 'Rudy.huamanq@gmail.com', NULL, '980314278', 35, 2, 0, 36, 4, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET Y FOTO IMPRESA ', NULL, NULL, NULL, NULL, NULL, '0.00', 8000.00, 0, '132.00', 1, 0, NULL, 1, NULL, '2019-11-04 14:41:57', 6),
(2033, 14, '1956', 'MARIANA', 'MENDOZA', 'marianamj11@gmail.com', NULL, '50250458985', 35, 2, 0, 36, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 14:48:31', 8),
(2034, 16, NULL, 'ANDREW', 'E', 'scipioaffricanus@gmail.com', NULL, '19727407974', NULL, 5, 0, 36, 2, '2019-11-12', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / \n', NULL, NULL, NULL, NULL, NULL, '0.00', 10000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 15:27:14', 8),
(2035, 16, NULL, 'MARIA JOSE', 'BENITES', 'majobenitez@gmail.com', NULL, '50764856985', NULL, 3, 0, 36, 1, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 6900.00, 0, '0.00', 1, 0, NULL, 1, 'DEBEN FIRMAR DOS CARTAS DE PAGO POR CONEKTA MARIA JOSE BENITEZ PEDIDO 4329 $2299\nDIANA DIAZ PEDIDO 4332 $4598', '2019-11-04 15:29:55', 8),
(2036, 14, NULL, 'ALEJANDRA ', 'SERPAS', 'Alejandraalejandraserpas92@gmail.com', NULL, '999999999', 35, 3, 0, 36, 4, '2019-12-27', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA , DESAYUNO EN RESTAURANTE Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 10500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 15:43:12', 3),
(2037, 14, NULL, 'ALEJANDRA', 'SERPAS', 'Alalejandraserpas92@gmail.com', NULL, '999999', 35, 3, 0, 36, 1, '2019-12-27', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA , DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', NULL, NULL, NULL, NULL, 2, '900.00', 6420.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 15:54:03', 3),
(2038, 14, '2032', 'RUDY ', 'HUAMAN', 'ventas@volarenglobo.com.mx', NULL, '980314278', 35, 2, 0, 36, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '132.00', 1, 0, NULL, 1, NULL, '2019-11-04 16:06:40', 8),
(2039, 14, NULL, 'LOURDES MARIEL', 'MUÃ‘IZ', 'lulumarielmuniz@gmail.com', NULL, '5218333228447', 35, 3, 1, 36, 1, '2020-03-28', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 ADULTOS 1 MENOR , VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 8996.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 16:22:13', 3),
(2040, 14, NULL, 'GUALBERTO', 'SORIANO', 'cyfsoriano_10@hotmail.com', NULL, '5526646972', 11, 2, 0, 39, 4, '2019-11-23', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA \" TE QUIERES CASAR CONMIGO\"  DESAYUNO EN RESTAURANTE GRAN TEOCALLI Y FOTOGRAFIA IMPRESA A ELEGIR.', 'DESAYUNOS ADICIONALE', '1120.00', NULL, NULL, NULL, '0.00', 8120.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 16:27:06', 3),
(2041, 14, NULL, 'ALEJANDRA', 'MONESTEL', 'monestelalejandra@gmail.com', NULL, '88492885', 35, 2, 0, 36, 1, '2019-11-06', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET', 'TRANSPORTE RED CENTR', '700.00', 'DESAYUNOS', '198.00', NULL, '0.00', 5498.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 16:39:04', 3),
(2042, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 17:07:24', 0),
(2043, 14, NULL, 'RENE', 'CARDONA', 'rene_cardona18@outlook.com', NULL, '5525341117', 35, 2, 0, 39, 4, '2019-11-24', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE, FOTO IMPRESA Y DESPLIEGUE DE LONA \" TE QUIERES CASAR CONMIGO?\"', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 17:16:26', 3),
(2044, 16, NULL, 'ARACELI', 'ALCAZAR', 'ara.alcazargtz@gmail.com', NULL, '12142237057', NULL, 2, 0, NULL, 1, '2019-11-10', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 17:31:40', 8),
(2045, 16, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 17:35:02', 0),
(2046, 16, NULL, 'ANDRES ', 'MONCADA', 'moncada472@gmail.com', NULL, '573114408394', NULL, 2, 0, 36, 2, '2019-11-06', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nSi\nDesayuno buffet', NULL, NULL, NULL, NULL, NULL, '0.00', 4280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 17:35:06', 6),
(2047, 14, NULL, 'ESTEFANIA', 'CASTRO', 'estefirv@gmail.com', NULL, '50688428872', 35, 5, 0, 36, 1, '2019-12-16', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '495.00', NULL, NULL, NULL, '0.00', 11995.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 17:44:19', 6),
(2048, 16, NULL, 'ANTONIO', 'MARTÃNEZ', 'omarsin94@gmail.com', NULL, '5524999861', NULL, 2, 0, 45, 4, '2019-11-10', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 17:46:43', 6),
(2049, 14, '1884', 'JESSICA', 'DIAZ', 'jessik_dias@hotmail.com', NULL, '50763050473', NULL, 2, 0, 36, 1, '2019-11-07', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,  DESAYUNO BUFFET ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 17:48:56', 8),
(2050, 14, '2047', 'ESTEFANIA', 'CASTRO', 'estefirv@gmail.com', NULL, '50688428872', 35, 5, 0, 36, 1, '2019-12-16', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '495.00', NULL, NULL, NULL, '0.00', 14495.00, 0, '325.00', 1, 0, NULL, 1, NULL, '2019-11-04 17:53:17', 6),
(2051, 14, NULL, 'MARCELA JULIA', 'MAKAZATO', 'Nakazato.studio@gmail.com', NULL, '5558892700', 35, 5, 0, 36, 1, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 5 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, NULL, '0.00', 11500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 18:15:54', 3),
(2052, 14, NULL, 'ARTURO', 'DELIMA', 'Arturodl@hotmail.com', NULL, '5555062420', 11, 2, 2, 38, 1, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 ADULTOS 2 MENORES , VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y PASTEL PARA CUMPLEAÃ‘ERO ', 'DESAYUNOS', '396.00', NULL, NULL, NULL, '0.00', 8396.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 18:22:51', 3),
(2053, 16, NULL, 'DIANA ', 'GARCÃA DELGADO', ' dmgd_ius@hotmail.com', NULL, '5552180231', NULL, 2, 0, 36, 1, '2019-11-10', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet', NULL, NULL, NULL, NULL, NULL, '0.00', 4880.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 19:02:02', 3),
(2054, 14, NULL, 'ANA LARISSA', 'TECH', 'ventas@volarenglobo.com.mx', NULL, '99999', 35, 1, 0, 36, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET ', NULL, NULL, NULL, NULL, 2, '1.00', 2799.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 19:08:13', 6),
(2055, 16, NULL, 'JUAN FRANCISCO', 'DIAZ', 'jfranciscodiaz@hotmail.com', NULL, '593984535145', NULL, 2, 0, 36, 1, '2019-11-16', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet', NULL, NULL, NULL, NULL, 2, '82.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 19:08:43', 3),
(2056, 16, '2048', 'OMAR', 'RAMÃREZ', 'omarsin94@gmail.com', NULL, '5524999861', NULL, 2, 0, 45, 4, '2019-11-10', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '140.00', 1, 0, NULL, 1, NULL, '2019-11-04 19:13:25', 8),
(2057, 14, NULL, 'CAROLINA', 'SCHIEVENIN', 'ventas@volarenglobo.com.mx', NULL, '99999', 35, 1, 0, 36, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, 2, '1.00', 2799.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 19:13:36', 8),
(2058, 14, '2054', 'ANA LARISSA', 'TECH', 'ventas@volarenglobo.com.mx', NULL, '99999', 35, 1, 0, 36, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 1 PERSONA, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, 2, '1.00', 2799.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 19:15:08', 8),
(2059, 11, NULL, 'KATHERINE', 'NUNEZ LEONARDO', 'kathy_leoch@hotmail.com', NULL, '13479443151', 35, 2, 0, 36, 1, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'INCLUYE VUELO LIBRE SOBRE TEOTIHUACAN DE 45 A 60 MINUTOS COFFEE BREAK BRINDIS CON VINO ESPUMOSO PETILLANT DE FREIXENET CERTIFICADO DE VUELO SEGURO DE VIAJERO DURANTE LA ACTIVIDAD INCLUYE TRANSPORTE DESDE CDMX IDA Y VUELTA\nDESCUENTO ESPECIAL AMIGOS VOLAR EN GLOBO\n', NULL, NULL, NULL, NULL, 2, '600.00', 5000.00, 0, '295.00', 2, 0, NULL, 1, 'LLEGA AL HOTEL CITY EXPRESS PLUS DEL ANGEL 4:48 REGRESO A LA CONDESA O DONDE INDIQUEN CENTRO CDMX', '2019-11-04 21:17:06', 8),
(2060, 16, NULL, 'EDWIN', 'CELY', 'edwin_cely@hotmail.com', NULL, '573203149017', NULL, 3, 0, NULL, 2, '2019-11-05', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet', NULL, NULL, 'DESAYUNO ADICIONAL', '140.00', NULL, '0.00', 6560.00, 0, '215.00', 1, 0, NULL, 1, NULL, '2019-11-04 21:39:37', 8),
(2061, 9, NULL, 'LUI', 'ZHIBIN', 'hydesh32@hydegroup', '34665152178', '8618205098128', NULL, 2, 0, NULL, 3, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MIN APROXIMADAMENTE SOBRE EL VALLE DE TEOTIHUACAN. TRANSPORTE REDONDO CDMX. SEGURO DE VIAJERO. COFFEE BREAK ANTES DE VUELO. BRINDIS CON VINO ESPUMOSO. CERTIFICADO PERSONALIZADO ', NULL, NULL, NULL, NULL, NULL, '0.00', 4900.00, 0, '120.00', 1, 0, NULL, 2, NULL, '2019-11-04 21:49:48', 3),
(2062, 9, NULL, 'AXL ', 'CARMONA', 'turismo@volarenglobo.com.mx', NULL, '5618159745', 11, 2, 0, 36, 1, '2019-11-06', NULL, NULL, NULL, NULL, NULL, '2-pax compartido conekta ped 4324', NULL, NULL, NULL, NULL, 2, '82.00', 4798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-04 23:09:00', 1),
(2063, 16, NULL, 'HAROLD', 'GÃ“MEZ', 'curumi73@yahoo.es', NULL, '573163266234', NULL, 1, 0, 38, 2, '2019-11-08', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nDesayuno buffet\nDespliegue de lona Feliz cumple!', NULL, NULL, NULL, NULL, NULL, '0.00', 2640.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 09:43:08', 3),
(2064, 16, NULL, 'ELIZABETH', 'MALCA', 'elizabethgina.dg@gmail.com', NULL, '5531103787', NULL, 2, 0, 36, 1, '2019-11-06', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / \n\n', NULL, NULL, NULL, NULL, NULL, '0.00', 4600.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 10:21:07', 6),
(2065, 9, NULL, 'THACH ', ' HO', 'turismo@volarenglobo.com.mx', NULL, '17327187412', 11, 4, 0, 36, 3, '2019-11-26', NULL, NULL, NULL, NULL, NULL, '**** 2019-11-26 ****\nâ€ƒâ€ƒTicket Type: Traveler: 4 ()\nâ€ƒâ€ƒPrimary Redeemer: THACH HO, 17327187412, tnga2722@gmail.com\nâ€ƒâ€ƒValid Day: Nov 26, 2019\nâ€ƒâ€ƒItem: Teotihuacan Pyramids Hot-Air Balloon Flight / 6:00 AM, Flight Only / 525355\nâ€ƒâ€ƒVoucher: 80727056, 80727057, 80727058, 80727059\nâ€ƒâ€ƒItinerary: 7491875888942\n', NULL, NULL, NULL, NULL, NULL, '0.00', 7800.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 10:27:48', 8),
(2066, 16, NULL, 'IVONNE', 'LONNA', 'ivennelonna@gmail.com', NULL, '5541867424', NULL, 2, 2, 38, 4, '2019-11-17', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, 2, '2.00', 10598.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 10:33:26', 6),
(2067, 16, '2066', 'IVONNE', 'LONNA', 'ivonnelonna@gmail.com', NULL, '5541867424', NULL, 2, 2, 38, 4, '2019-11-17', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, 2, '2.00', 10598.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 10:37:09', 6),
(2068, 16, '2067', 'IVONNE', 'LONNA', 'ivonnelonna@gmail.com', NULL, '5541867424', NULL, 2, 2, 38, 4, '2019-11-17', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', 'TRANSPORTE REDONDO A', '1400.00', NULL, NULL, 2, '2.00', 11998.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 10:41:59', 3),
(2069, 9, NULL, 'MARIA JOSE', 'ROPAIN OLARTE', 'majo.ropain@hotmail.com', NULL, '5541906266', 11, 2, 0, 36, 1, '2019-11-07', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nTRANSPORTE REDONDO CDMX-TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, NULL, '0.00', 5600.00, 0, '112.00', 1, 0, NULL, 1, NULL, '2019-11-05 10:43:04', 6);
INSERT INTO `temp_volar` (`id_temp`, `idusu_temp`, `clave_temp`, `nombre_temp`, `apellidos_temp`, `mail_temp`, `telfijo_temp`, `telcelular_temp`, `procedencia_temp`, `pasajerosa_temp`, `pasajerosn_temp`, `motivo_temp`, `tipo_temp`, `fechavuelo_temp`, `tarifa_temp`, `hotel_temp`, `habitacion_temp`, `checkin_temp`, `checkout_temp`, `comentario_temp`, `otroscar1_temp`, `precio1_temp`, `otroscar2_temp`, `precio2_temp`, `tdescuento_temp`, `cantdescuento_temp`, `total_temp`, `piloto_temp`, `kg_temp`, `tipopeso_temp`, `globo_temp`, `hora_temp`, `idioma_temp`, `comentarioint_temp`, `register`, `status`) VALUES
(2070, 16, '2064', 'ELIZABETH', 'MALCA', 'elizabethgina.dg@gmail.com', NULL, '5531103787', NULL, 2, 0, 36, 2, '2019-11-06', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / \n\n', NULL, NULL, NULL, NULL, NULL, '0.00', 5280.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 10:45:08', 8),
(2071, 14, NULL, 'JOSE ANTONIO', 'QUIROS', 'ventas@volarenglobo.com.mx', NULL, '50689125979', 35, 2, 0, 36, 1, '2019-11-10', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2  PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 5798.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 10:45:22', 8),
(2072, 14, '2050', 'ESTEFANIA', 'CASTRO', 'estefirv@gmail.com', NULL, '50688428872', 35, 5, 0, 36, 1, '2019-12-16', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 5 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '495.00', NULL, NULL, NULL, '0.00', 14495.00, 0, '325.00', 1, 0, NULL, 1, NULL, '2019-11-05 11:04:57', 8),
(2073, 9, NULL, 'XIMENA', 'TURISKY', 'turismo@volarenglobo.com.mx', NULL, '999999', 11, 2, 0, 36, 3, '2019-11-06', NULL, NULL, NULL, NULL, NULL, '2 pax compartido turisky con transporte ', NULL, NULL, NULL, NULL, 2, '800.00', 4100.00, 0, '135.00', 1, 0, NULL, 1, NULL, '2019-11-05 11:18:32', 9),
(2074, 16, NULL, 'OLGA', 'MORA', 'omora33@hotmail.com', NULL, '5513015943', NULL, 8, 0, 36, 2, '2019-11-07', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break /', NULL, NULL, NULL, NULL, NULL, '0.00', 16000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 11:29:46', 6),
(2075, 14, '1990', 'HAROLDO', 'ESTUARDO', 'hgarquitecturahg@gmail.com', NULL, '50240737454', 35, 2, 0, 36, 4, '2019-11-08', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACÃN DURANTE 45 MINUTOS APROX.INCLUYE COFFE BREAK CAFÃ‰ TÃ‰ GALLETAS Y PAN, SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO,DESAYUNO BUFFET Y FOTO IMPRESA ', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '154.00', 1, 0, NULL, 1, NULL, '2019-11-05 11:38:39', 8),
(2076, 16, '2046', 'ANDRES ', 'MONCADA', 'moncada472@gmail.com', NULL, '573114408394', NULL, 3, 0, 36, 2, '2019-11-06', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido 45 a 60 minutos\nBrindis con vino espumoso\nCertificado de vuelo\nSeguro viajero\nCoffe break\nSi\nDesayuno buffet', NULL, NULL, NULL, NULL, NULL, '0.00', 6420.00, 0, '212.00', 1, 0, NULL, 1, NULL, '2019-11-05 11:52:38', 8),
(2077, 14, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 12:00:24', 0),
(2078, 14, '1613', 'LIZETH', 'BARRERA', 'lizpatbar@hotmail.com', NULL, '573132516299', 35, 2, 2, 36, 1, '2019-11-13', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 ADULTOS Y 2 MENORES, PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO. ', NULL, NULL, NULL, NULL, NULL, '0.00', 10000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 12:00:38', 3),
(2079, 14, '1949', 'IVETTE', 'ROMAB', 'Sugarpopanama@gmail.com', NULL, '50763144918', 35, 3, 0, 36, 1, '2019-11-11', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS , VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE, TE , GALLETAS Y PAN) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL DURANTE LA ACTIVIDAD', NULL, NULL, NULL, NULL, NULL, '0.00', 6900.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 12:12:20', 3),
(2080, 14, NULL, 'IVETTE ', 'ROMAB', 'Sugarpopanama@gmail.com', NULL, '50763144918', 35, 5, 0, 36, 1, '2019-11-11', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 5 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', NULL, NULL, NULL, NULL, NULL, '0.00', 11500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 12:13:01', 3),
(2081, 14, NULL, 'REBECA', 'ACUÃ‘A', 'rebecaacuna@fifco.com', NULL, '50688408674', 35, 5, 0, 36, 1, '2020-03-22', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 5 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ,TRANSPORTE CDMX-TEOTIHUACAN-CDMX (CENTRO)', 'DESAYUNOS', '495.00', NULL, NULL, NULL, '0.00', 14495.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 12:20:52', 3),
(2082, 14, NULL, 'TANIA ITZEL', 'VILLEGAS', 'tani.aboo@hotmail.com', NULL, '5540228784', 11, 2, 0, 37, 4, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO VIP PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO MÃ–ET , DESPLIEGUE DE LONA \"FELIZ ANIVERSARIO\" DESAYUNO EN RESTAURANTE , PAQUETE DE FOTOGRAFIAS ,   Y  1 SOUVERNIR', 'VIP', '500.00', NULL, NULL, NULL, '0.00', 9500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 12:30:25', 3),
(2083, 16, NULL, 'LIZETH', 'BARRERA', 'lizpatbar@hotmail.com', NULL, '573132516299', NULL, 2, 2, 36, 2, '2019-11-13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, '82.00', 9878.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 12:31:56', 3),
(2084, 14, NULL, 'CHRISTIAN', 'DE DIOS', 'ventas@volarenglobo.com.mx', NULL, '5215559959784', 35, 2, 0, 36, 1, '2019-11-11', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS , VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX. INCLUYE COFFE BREAK (CAFE, TE , GALLETAS Y PAN ) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL DURANTE LA ACTIVIDAD EN TEOTIHUACAN.', NULL, NULL, NULL, NULL, 2, '600.00', 4000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 13:01:05', 3),
(2085, 16, NULL, 'SALEM', 'ONTIVERO', 'salemontiveros@gmail.com', NULL, '6643337622', NULL, 5, 0, 36, 2, '2019-11-06', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 10000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 13:07:15', 6),
(2086, 14, NULL, 'PAOLA', 'JAIME', 'paojm@icloud.com', NULL, '573213431505', 35, 2, 1, 36, 1, '2020-01-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA  2 ADULTOS 1 MENOR , VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,TRANSPORTE CDMX-TEOTIHUACAN-CDMX (CENTRO)', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 8097.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 13:11:35', 3),
(2087, 14, NULL, 'PAOLA', 'JAIME', 'paojm@icloud.com', NULL, '573213431505', 35, 2, 1, 36, 4, '2020-01-04', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 ADULTOS 1 MENOR ,  VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI, TRANSPORTE CDMX-TEOTIHUACAN-CDMX ( CENTRO) ', NULL, NULL, NULL, NULL, NULL, '0.00', 10300.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 13:14:39', 3),
(2088, 16, '2085', 'SALEM', 'ONTIVERO', 'salemontiveros@gmail.com', NULL, '6643337622', NULL, 5, 0, 36, 2, '2019-11-06', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', NULL, NULL, NULL, NULL, NULL, '0.00', 10700.00, 0, '375.00', 1, 0, NULL, 1, NULL, '2019-11-05 13:17:04', 8),
(2089, 16, NULL, 'LUIS GABRIEL', 'AÃ‘AS', 'enftganas@gmail.com', NULL, '6642329362', NULL, 2, 0, NULL, 4, '2019-12-06', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7500.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 13:26:38', 3),
(2090, 14, NULL, 'JESUS', 'PALACIOS', 'Jesus_palacios95@hotmail.com', NULL, '5543531259', 35, 2, 0, 45, 4, '2019-11-10', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA \"TE AMO\" DESAYUNO EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 14:00:50', 3),
(2091, 14, NULL, 'MITZY', 'OBANDO', 'mobandor189@hotmail.es', NULL, '50670625588', 35, 5, 0, 36, 1, '2019-12-25', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA  5 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, ', NULL, NULL, NULL, NULL, NULL, '0.00', 14700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 14:19:34', 3),
(2092, 16, NULL, 'DAVID', 'MALDONADO', 'Davidmaldonado@gmail.com', NULL, '573183818640', NULL, 3, 0, 38, 2, '2019-11-07', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break / Despliegue de lona FELIZ CUMPLE!', NULL, NULL, NULL, NULL, NULL, '0.00', 7500.00, 0, '185.00', 1, 0, NULL, 1, NULL, '2019-11-05 14:20:46', 8),
(2093, 16, NULL, 'AMELIA', 'PANIAGUA', 'reserva@volarenglobo.com.mx', NULL, '50687087108', NULL, 2, 1, NULL, 2, '2019-11-04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 5700.00, 0, '190.00', 1, 0, NULL, 1, NULL, '2019-11-05 15:17:28', 8),
(2094, 16, '2074', 'OLGA', 'MORA', 'omora33@hotmail.com', NULL, '5513015943', NULL, 8, 0, 36, 2, '2019-11-07', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break /', '4 HABITACIONES DOBLE', '5200.00', NULL, NULL, NULL, '0.00', 21200.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 15:43:54', 6),
(2095, 14, NULL, 'PAULINA', 'DE LA O', 'pau16_delaov@hotmail.com', NULL, '5548844944', 35, 2, 1, 36, 1, '2019-11-16', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 ADULTOS 1 MENOR , VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 6597.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 15:54:39', 3),
(2096, 16, NULL, 'LAKSMI', 'LEAL', 'lakslr_98@hotmail.com', '573132843311', '5510730437', NULL, 3, 0, 36, 2, '2019-11-08', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', 'TRANSPORTE REDONDO A', '1050.00', NULL, NULL, NULL, '0.00', 7470.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 16:30:44', 6),
(2097, 9, NULL, 'MAYRA', 'TURISKY', 'turismo@volarenglobo.com.mx', NULL, '14052307297', 11, 2, 0, 36, 3, '2019-11-06', NULL, NULL, NULL, NULL, NULL, '2 pax compartido turisky ', NULL, NULL, NULL, NULL, 2, '800.00', 4100.00, 0, '170.00', 1, 0, NULL, 1, NULL, '2019-11-05 17:45:54', 8),
(2098, 9, NULL, 'FABIO  ', 'PAZ MIRANDA  ', 'hector@ruizmed.com.mx', NULL, '5510411697', 11, 2, 0, 36, 3, '2019-11-08', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, 2, '400.00', 3500.00, 0, '132.00', 1, 0, NULL, 1, NULL, '2019-11-05 17:52:24', 8),
(2099, 9, NULL, 'ABRAHM ', 'GÃ“MEZ LAGUNES', 'turismo@volarenglobo.com.mx', NULL, '5513719931', 11, 3, 0, 36, 3, '2019-12-31', NULL, NULL, NULL, NULL, NULL, '3 PAX COMPARTIDO CON TRANSPORTE TURISKY', NULL, NULL, NULL, NULL, 2, '1200.00', 6150.00, 0, '210.00', 1, 0, NULL, 1, NULL, '2019-11-05 18:47:17', 4),
(2100, 14, NULL, 'SOL ', 'SOTELO', 'solsotelo14@hotmail.com', NULL, '51980653558', 35, 4, 0, 37, 1, '2019-12-11', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ ANIVERSARIO\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', NULL, NULL, NULL, NULL, 2, '1200.00', 8560.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 18:50:21', 6),
(2101, 14, NULL, 'SOL', 'SOTELO', 'solsotelo14@hotmail.com', NULL, '51980653558', 35, 4, 0, 37, 4, '2019-12-11', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 4 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO,DESPLIEGUE DE LONA \"FELIZ ANIVERSARIO\" DESAYUNO EN RESTAURANTE  Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, 2, '1000.00', 13000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 18:53:55', 3),
(2102, 16, '2094', 'EDUARDO', 'MORA', 'moramorado@live.com', NULL, '5513015943', NULL, 8, 0, 36, 2, '2019-11-07', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Seguro viajero/ Coffee break /', '4 HABITACIONES DOBLE', '5200.00', NULL, NULL, NULL, '0.00', 21200.00, 0, '475.00', 1, 0, NULL, 1, NULL, '2019-11-05 18:56:41', 8),
(2103, 9, NULL, 'JUAN', 'OSORIO JIMENEZ', 'turismo@volarenglobo.com.mx', NULL, '62298517', 11, 2, 0, 36, 1, '2019-12-17', NULL, NULL, NULL, NULL, NULL, '2-pax compartido conekta ped 4341', NULL, NULL, NULL, NULL, 2, '2.00', 4598.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 22:57:17', 8),
(2104, 9, NULL, 'ELIZABETH CAROLA', 'LOPEZ NUÃ‘EZ', 'turismo@volarenglobo.com.mx', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 23:03:45', 0),
(2105, 9, NULL, 'ELIZABETH CAROLA ', 'LOPEZ NUÃ‘EZ', 'turismo@volarenglobo.com.mx', NULL, '56999411042', 35, 2, 0, 36, 3, '2019-11-09', NULL, NULL, NULL, NULL, NULL, '2-pax compartido con transporte booking', NULL, NULL, NULL, NULL, 2, '200.00', 4700.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-05 23:05:05', 8),
(2107, 19, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-06 09:53:26', 0),
(2108, 14, NULL, 'CARLOS ', 'SICAIROS', 'ventas@volarenglobo.com.mx', NULL, '5537802714', 11, 2, 0, 38, 1, '2019-11-09', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX INCLUYE COFFE BREAK (CAFE,TE,GALLETAS Y PAN) SEGURO DE VIAJERO, BRINDIS CON VINO ESPUMOSO, CERTIFICADO PERSONALIZADO, TRANSPORTE LOCAL DURANTE LA ACTIVIDAD, DESPLIEGUE DE LONA \"FELIZ CUMPLEAÃ‘OS\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI Y PASTEL PARA CUMPLEAÃ‘ERO (A)', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '156.00', 1, 0, NULL, 1, NULL, '2019-11-06 11:28:55', 8),
(2109, 9, NULL, 'DAN ', ' TOMA', 'turismo@volarenglobo.com.mx', NULL, '00491744573433', 35, 3, 0, 36, 3, '2019-11-13', NULL, NULL, NULL, NULL, NULL, '3 PAX COMPARTIDO BOOKING CON TRANSPORTE', NULL, NULL, NULL, NULL, 2, '300.00', 7050.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-06 11:34:29', 8),
(2110, 14, NULL, 'LISA', 'CHAVEZ', 'ventas@volarenglobo.com.mx', NULL, '50689634800', 35, 2, 0, 36, 1, '2019-12-14', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 6698.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-06 11:39:28', 8),
(2111, 14, NULL, 'MA LUISA ', 'PEREZ', 'maria@traduweb.com', NULL, '5510584998', 35, 3, 0, 36, 1, '2019-11-07', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 3 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLLI . ', 'DESAYUNOS', '297.00', NULL, NULL, NULL, '0.00', 9822.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-06 11:51:29', 6),
(2112, 14, '2111', 'MA LUISA ', 'PEREZ', 'maria@traduweb.com', NULL, '5510584998', 35, 2, 0, 36, 1, '2019-11-07', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLLI , GUIA EN INGLES, TRANSPORTE CDMX-TEOTIHUACAN-CDMX ( CENTRO ) ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 6848.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-06 12:43:20', 3),
(2113, 14, '1803', 'LAURA', 'CALDERON', 'monemyle@hotmail.com', NULL, '5545253810', 11, 7, 0, 36, 1, '2019-12-29', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 7 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI', NULL, NULL, NULL, NULL, 2, '2100.00', 14000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-06 12:46:29', 3),
(2114, 16, '2096', 'JESSICA', 'SURET', 'jessysule@gmail.com', '573132843311', '573134329967', NULL, 3, 0, 36, 2, '2019-11-08', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / ', 'TRANSPORTE REDONDO A', '1050.00', NULL, NULL, NULL, '0.00', 7470.00, 0, '180.00', 1, 0, NULL, 1, NULL, '2019-11-06 13:09:12', 8),
(2115, 16, NULL, 'ANA SOFIA', 'RODRIGUEZ', 'anasofiawillems@gmail.com', NULL, '5532582647', NULL, 2, 0, NULL, 4, '2019-12-12', NULL, NULL, NULL, NULL, NULL, 'Vuelo en globo exclusivo sobre el valle de TeotihuacÃ¡n 45 a 60 minutos/ Brindis en vuelo con vino espumoso Freixenet/ Certificado Personalizado de vuelo/ Seguro viajero/ Desayuno tipo Buffet  (Restaurante Gran Teocalli o Rancho Azteca)/ TransportaciÃ³n local / Despliegue de lona / Foto Impresa/ Coffee Break antes del vuelo CafÃ©, TÃ©, galletas, pan, fruta.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-06 13:29:35', 3),
(2116, 16, NULL, 'ANGIA', 'SANABRIA', 'angianette.sanabria@gmail.com', NULL, '50660504423', NULL, 6, 0, 36, 1, '2019-11-16', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, 2, '246.00', 17394.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-06 13:32:58', 6),
(2117, 14, NULL, 'LIONEL JOSE', 'RODRIGUEZ', 'lionelro121@gmail.com', NULL, '5522580024', 11, 2, 0, 37, 1, '2019-11-07', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ ANIVERSARIO\" DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', 'DESAYUNOS', '198.00', NULL, NULL, NULL, '0.00', 4798.00, 0, '145.00', 1, 0, NULL, 1, NULL, '2019-11-06 13:47:16', 8),
(2118, 14, NULL, 'GERSON ROMAN', 'QUESADA', 'luissunsin@gmail.com', '50688194284', '50688194284', NULL, 2, 1, 36, 1, '2019-11-14', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 2 ADULTOS 1 , VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', NULL, NULL, NULL, NULL, 2, '641.00', 6079.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-06 13:58:29', 3),
(2119, 16, '2116', 'ANGIA', 'SANABRIA', 'angianette.sanabria@gmail.com', NULL, '50660504423', NULL, 5, 0, 36, 1, '2019-11-16', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', 'TRANSPORTE Y DESAYUN', '640.00', NULL, NULL, 2, '205.00', 15135.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-06 13:58:29', 8),
(2120, 9, '2069', 'MARIA JOSE', 'ROPAIN OLARTE', 'majo.ropain@hotmail.com', NULL, '5541906266', 11, 2, 0, 36, 1, '2019-11-07', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO 2 PAX DE 45 MINUTOS APROX SOBRE EL VALLE DE TEOTIHUACAN.\nTRANSPORTE REDONDO CDMX-TEOTIHUACAN.\nSEGURO DE VIAJERO.\nCOFFEE BREAK ANTES DEL VUELO.\nBRINDIS CON VINO ESPUMOSO.\nCERTIFICADO PERSONALIZADO.', NULL, NULL, NULL, NULL, NULL, '0.00', 5600.00, 0, '112.00', 1, 0, NULL, 1, NULL, '2019-11-06 14:01:52', 4),
(2121, 14, NULL, 'CAROLINA', 'BOLAÃ‘OS', 'cbolanos19@hotmail.com', NULL, '50688539765', 35, 11, 0, 36, 1, '2020-03-21', NULL, NULL, NULL, NULL, NULL, 'VUELO COMPARTIDO PARA 11 ADULTOS , VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO BUFFET EN RESTAURANTE GRAN TEOCALLI ', NULL, NULL, NULL, NULL, 2, '3300.00', 29040.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-06 14:20:55', 3),
(2122, 14, '2100', 'SOL ', 'SOTELO', 'solsotelo14@hotmail.com', NULL, '51980653558', 35, 4, 0, 37, 4, '2019-12-11', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 4 PERSONAS, VUELO SOBRE EL VALLE DE TEOTIHUACAN, DURANTE 45 MINS APROX, INCLUYE COFFE BREAK (CAFÃ‰, TE, PAN GALLETAS) SEGURO DE VIAJERO, CERTIFICADO PERSONALIZADO, TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESPLIEGUE DE LONA \"FELIZ ANIVERSARIO\" DESAYUNO BUFFET EN RESTAURANTE Y FOTO IMPRESA', NULL, NULL, NULL, NULL, 2, '1000.00', 13000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-06 14:51:06', 8),
(2123, 16, NULL, 'ROSA HALINA', 'MARTINEZ', 'payareslegal@gmail.com', NULL, '573013713982', NULL, 6, 0, 36, 1, '2019-12-01', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet / Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', 'TRANSPORTE Y DESAYUN', '1280.00', NULL, NULL, 2, '246.00', 18674.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-06 15:27:48', 3),
(2124, 14, NULL, 'MILTON', 'BARRANCO', 'de_milton@hotmail.com', NULL, '5527416211', 11, 2, 1, 36, 4, '2019-11-23', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, 2, '1.00', 8799.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-06 16:16:52', 6),
(2125, 14, '2124', 'MILTON', 'BARRANCO', 'de_milton@hotmail.com', NULL, '5527416211', 11, 2, 1, 36, 4, '2019-11-23', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE Y FOTOGRAFIA IMPRESA A ELEGIR.', 'TRANSPORTE RED CENTR', '1050.00', NULL, NULL, 2, '1.00', 9849.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-06 16:18:58', 3),
(2126, 14, NULL, 'CINTHIA', 'MICAL', 'mailto:cynthia@panamadaytrips.com', NULL, '50762135989', 35, 2, 0, 36, 4, '2019-11-17', NULL, NULL, NULL, NULL, NULL, 'VUELO PRIVADO PARA 2 PERSONAS , VUELO SOBRE VALLE DE TEOTIHUACAN DURANTE 45 MINS APROX , COFFE BREAK INCLUIDO (CAFÃ‰,TE,CAFÃ‰,PAN) SEGURO DE VIAJERO,CERTIFICADO PERSONALIZADO,TRANSPORTE DURANTE LA ACTIVIDAD, BRINDIS CON VINO ESPUMOSO, DESAYUNO EN RESTAURANTE Y FOTOGRAFIA IMPRESA A ELEGIR.', NULL, NULL, NULL, NULL, NULL, '0.00', 7000.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-06 16:26:03', 8),
(2127, 16, NULL, 'JOSE', 'GOMEZ', 'elmachote85@gmail.com', NULL, '50925639', NULL, 3, 0, NULL, 1, '2019-12-07', NULL, NULL, NULL, NULL, NULL, 'Vuelo compartido sobre el Valle de TeotihuacÃ¡n, 45 min/ Certificado personalizado/ Brindis con vino blanco espumoso Freixenet o jugo de naranja/ Desayuno tipo Buffet (excepto bÃ¡sico)/ Seguro viajero/ Coffee break / Despliegue de lona segÃºn la ocasiÃ³n ', NULL, NULL, NULL, NULL, NULL, '0.00', 6555.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-06 17:07:06', 8),
(2129, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, '2019-11-21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0.00', 0.00, 0, '0.00', 1, 0, NULL, 1, NULL, '2019-11-20 10:03:34', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventasserv_volar`
--

CREATE TABLE `ventasserv_volar` (
  `id_vsv` int(11) NOT NULL COMMENT 'Llave Primaria',
  `idserv_vsv` int(11) DEFAULT NULL COMMENT 'Servicio',
  `idventa_vsv` int(11) DEFAULT NULL COMMENT 'Venta',
  `cantidad_vsv` int(11) DEFAULT NULL COMMENT 'Cantidad',
  `register` datetime DEFAULT current_timestamp() COMMENT 'Register',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `ventasserv_volar`
--

INSERT INTO `ventasserv_volar` (`id_vsv`, `idserv_vsv`, `idventa_vsv`, `cantidad_vsv`, `register`, `status`) VALUES
(1, 1, 9, 4, '2019-08-06 00:00:00', 1),
(2, 2, 9, 2, '2019-08-06 00:00:00', 1),
(3, 1, 10, 3, '2019-08-06 00:00:00', 1),
(4, 2, 10, 2, '2019-08-06 00:00:00', 1),
(5, 1, 11, 5, '2019-08-06 00:00:00', 1),
(6, 2, 11, 3, '2019-08-06 00:00:00', 1),
(7, 3, 11, 2, '2019-08-06 00:00:00', 1),
(8, 4, 11, 2, '2019-08-06 00:00:00', 1),
(9, 5, 11, 2, '2019-08-06 00:00:00', 1),
(10, 11, 11, 2, '2019-08-06 00:00:00', 1),
(11, 38, 12, 1, '2019-09-26 00:00:00', 1),
(12, 38, 13, 2, '2019-09-26 00:00:00', 1),
(13, 7, 14, 2, '2019-09-26 00:00:00', 1),
(14, 8, 14, 2, '2019-09-26 00:00:00', 1),
(15, 7, 15, 7, '2019-09-27 00:00:00', 1),
(16, 8, 15, 1, '2019-09-27 00:00:00', 1),
(17, 16, 16, 5, '2019-09-27 00:00:00', 1),
(18, 38, 17, 7, '2019-09-27 00:00:00', 1),
(19, 38, 18, 1, '2019-09-28 00:00:00', 1),
(20, 38, 19, 1, '2019-09-28 00:00:00', 1),
(21, 38, 20, 1, '2019-09-28 00:00:00', 1),
(22, 38, 21, 1, '2019-09-28 00:00:00', 1),
(23, 38, 22, 1, '2019-09-28 00:00:00', 1),
(24, 7, 23, 1, '2019-09-28 00:00:00', 1),
(25, 16, 24, 1, '2019-09-28 00:00:00', 1),
(26, 16, 25, 1, '2019-09-28 00:00:00', 1),
(27, 7, 26, 1, '2019-09-28 00:00:00', 1),
(28, 16, 26, 1, '2019-09-28 00:00:00', 1),
(29, 7, 27, 1, '2019-09-28 00:00:00', 1),
(30, 16, 27, 1, '2019-09-28 00:00:00', 1),
(31, 7, 28, 1, '2019-09-28 00:00:00', 1),
(32, 16, 28, 1, '2019-09-28 00:00:00', 1),
(33, 38, 29, 1, '2019-09-28 00:00:00', 1),
(34, 38, 30, 1, '2019-09-28 00:00:00', 1),
(35, 38, 31, 2, '2019-09-28 00:00:00', 1),
(36, 16, 32, 1, '2019-09-28 00:00:00', 1),
(37, 16, 33, 1, '2019-09-28 00:00:00', 1),
(38, 7, 34, 1, '2019-09-28 00:00:00', 1),
(39, 16, 35, 1, '2019-09-28 00:00:00', 1),
(40, 38, 36, 1, '2019-09-28 00:00:00', 1),
(41, 16, 37, 2, '2019-09-28 00:00:00', 1),
(42, 7, 38, 1, '2019-09-28 00:00:00', 1),
(43, 16, 38, 1, '2019-09-28 00:00:00', 1),
(44, 7, 39, 1, '2019-10-01 00:00:00', 1),
(45, 7, 40, 1, '2019-10-02 00:00:00', 1),
(46, 16, 40, 1, '2019-10-02 00:00:00', 1),
(47, 7, 41, 1, '2019-10-02 00:00:00', 1),
(48, 16, 41, 1, '2019-10-02 00:00:00', 1),
(49, 7, 42, 1, '2019-10-02 00:00:00', 1),
(50, 16, 43, 1, '2019-10-02 00:00:00', 1),
(51, 38, 44, 2, '2019-10-02 00:00:00', 1),
(52, 38, 45, 1, '2019-10-02 00:00:00', 1),
(53, 7, 46, 1, '2019-10-08 00:00:00', 1),
(54, 8, 46, 1, '2019-10-08 00:00:00', 1),
(55, 16, 46, 1, '2019-10-08 00:00:00', 1),
(56, 7, 47, 1, '2019-10-08 00:00:00', 1),
(57, 38, 48, 2, '2019-10-08 00:00:00', 1),
(58, 7, 49, 1, '2019-10-08 00:00:00', 1),
(59, 16, 49, 1, '2019-10-08 00:00:00', 1),
(60, 38, 50, 1, '2019-10-09 12:39:01', 1),
(61, 7, 51, 1, '2019-10-09 12:56:54', 1),
(62, 8, 51, 1, '2019-10-09 12:56:54', 1),
(63, 16, 52, 1, '2019-10-09 12:57:41', 1),
(64, 7, 53, 1, '2019-10-09 12:58:26', 1),
(65, 7, 54, 1, '2019-10-11 12:40:38', 1),
(66, 7, 55, 1, '2019-10-11 12:41:46', 1),
(67, 16, 55, 1, '2019-10-11 12:41:46', 1),
(68, 7, 56, 1, '2019-10-11 12:43:15', 1),
(69, 16, 57, 2, '2019-10-11 12:43:51', 1),
(70, 7, 58, 1, '2019-10-11 12:44:29', 1),
(71, 16, 58, 1, '2019-10-11 12:44:29', 1),
(72, 7, 59, 1, '2019-10-11 12:45:23', 1),
(73, 7, 60, 1, '2019-10-11 12:46:08', 1),
(74, 16, 60, 1, '2019-10-11 12:46:08', 1),
(75, 38, 61, 1, '2019-10-11 12:47:09', 1),
(76, 38, 62, 2, '2019-10-11 12:49:08', 1),
(77, 38, 63, 1, '2019-10-11 12:50:12', 1),
(78, 38, 64, 2, '2019-10-11 12:51:26', 1),
(79, 38, 65, 1, '2019-10-12 13:18:14', 1),
(80, 7, 66, 1, '2019-10-12 13:19:10', 1),
(81, 16, 66, 2, '2019-10-12 13:19:10', 1),
(82, 16, 67, 1, '2019-10-13 10:43:58', 1),
(83, 7, 68, 1, '2019-10-13 10:58:52', 1),
(84, 16, 68, 2, '2019-10-13 10:58:52', 1),
(85, 7, 69, 1, '2019-10-13 10:59:51', 1),
(86, 16, 69, 1, '2019-10-13 10:59:51', 1),
(87, 38, 70, 2, '2019-10-13 11:03:22', 1),
(88, 7, 71, 1, '2019-10-13 11:40:54', 1),
(89, 8, 71, 1, '2019-10-13 11:40:54', 1),
(90, 16, 71, 1, '2019-10-13 11:40:54', 1),
(91, 7, 72, 1, '2019-10-13 11:42:25', 1),
(92, 8, 72, 1, '2019-10-13 11:42:25', 1),
(93, 16, 72, 1, '2019-10-13 11:42:25', 1),
(94, 7, 73, 1, '2019-10-13 11:43:40', 1),
(95, 38, 74, 3, '2019-10-13 11:44:58', 1),
(96, 7, 75, 1, '2019-10-13 12:06:00', 1),
(97, 8, 75, 1, '2019-10-13 12:06:00', 1),
(98, 16, 75, 1, '2019-10-13 12:06:00', 1),
(99, 7, 76, 1, '2019-10-13 12:06:44', 1),
(100, 16, 76, 1, '2019-10-13 12:06:44', 1),
(101, 16, 77, 1, '2019-10-13 12:07:31', 1),
(102, 38, 78, 1, '2019-10-14 23:45:10', 1),
(103, 7, 79, 1, '2019-10-14 23:47:00', 1),
(104, 38, 79, 1, '2019-10-14 23:47:00', 1),
(105, 7, 80, 1, '2019-10-14 23:48:42', 1),
(106, 7, 81, 2, '2019-10-14 23:50:12', 1),
(107, 16, 81, 2, '2019-10-14 23:50:12', 1),
(108, 7, 82, 6, '2019-10-15 17:34:02', 1),
(109, 8, 82, 2, '2019-10-15 17:34:02', 1),
(110, 16, 82, 2, '2019-10-15 17:34:02', 1),
(111, 7, 83, 1, '2019-10-17 18:20:41', 1),
(112, 5, 84, 1, '2019-10-18 09:16:01', 1),
(113, 7, 85, 4, '2019-10-23 13:16:25', 1),
(114, 16, 85, 2, '2019-10-23 13:16:25', 1),
(115, 7, 86, 1, '2019-10-23 13:16:52', 1),
(116, 7, 87, 1, '2019-10-23 13:17:36', 1),
(117, 8, 87, 1, '2019-10-23 13:17:36', 1),
(118, 16, 87, 1, '2019-10-23 13:17:36', 1),
(119, 38, 88, 2, '2019-10-23 13:22:07', 1),
(120, 5, 89, 2, '2019-11-06 10:36:33', 1);

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
  `pagocupon_venta` double(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Pago con Cupón',
  `tipomoneda_venta` int(11) NOT NULL COMMENT 'Tipo de Moneda',
  `preciomoneda_venta` double(10,2) NOT NULL COMMENT 'Precio de Moneda',
  `total_venta` double(10,2) DEFAULT NULL COMMENT 'Total',
  `fechavta_venta` date DEFAULT current_timestamp() COMMENT 'Fecha de Venta',
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Register',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT 'Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci COMMENT='Ventas de CItio';

--
-- Volcado de datos para la tabla `ventas_volar`
--

INSERT INTO `ventas_volar` (`id_venta`, `idusu_venta`, `comentario_venta`, `otroscar1_venta`, `precio1_venta`, `otroscar2_venta`, `precio2_venta`, `tipodesc_venta`, `cantdesc_venta`, `pagoefectivo_venta`, `pagotarjeta_venta`, `pagocupon_venta`, `tipomoneda_venta`, `preciomoneda_venta`, `total_venta`, `fechavta_venta`, `register`, `status`) VALUES
(10, 1, 'prueba servicios', NULL, NULL, NULL, NULL, NULL, NULL, 300.00, 3000.00, 0.00, 0, 0.00, 3300.00, '2019-08-06', '2019-10-08 20:03:06', 0),
(11, 1, 'Aqui va un comentario muy grande para poner la descripciÃ³n de la venta qeu se acaba de realiazar desde el sitio por alguien que se encuentre por ahi ', NULL, NULL, NULL, NULL, NULL, NULL, 500.00, 11230.00, 0.00, 0, 0.00, 11730.00, '2019-08-06', '2019-10-08 20:03:06', 0),
(12, 18, '2  126 IMAN MADERA 150\n1 138 LLAVERO FIBRA 100', NULL, NULL, NULL, NULL, 1, 100.00, 400.00, NULL, 0.00, 0, 0.00, 400.00, '2019-09-26', '2019-10-08 20:03:06', 1),
(13, 18, '2 149 FOTOS TIERRA', NULL, NULL, NULL, NULL, 1, 400.00, NULL, 600.00, 0.00, 0, 0.00, 600.00, '2019-09-26', '2019-10-08 20:03:06', 1),
(14, 18, '2 158 FOTO Y VIDEO 1,000', NULL, NULL, NULL, NULL, NULL, NULL, 2000.00, NULL, 0.00, 0, 0.00, 2000.00, '2019-09-26', '2019-10-08 20:03:06', 1),
(15, 18, '6 140 FOTOS MICRO SD\n1 158 FOTOS Y VIDEO EN MICRO SD', NULL, NULL, NULL, NULL, NULL, NULL, 3500.00, 500.00, 0.00, 0, 0.00, 4000.00, '2019-09-27', '2019-10-08 20:03:06', 1),
(16, 18, '9 145 FOTO IMPRESA POSTAL', NULL, NULL, NULL, NULL, 1, 100.00, 700.00, 200.00, 0.00, 0, 0.00, 900.00, '2019-09-27', '2019-10-08 20:03:06', 1),
(17, 18, '2 056 GORRA 150\n2 056 GORRA 200\n4 138 LLAVERO FIBRA 100\n7 126 IMÃN MADERA 150\n4 127 IMÃN MADERA CH 100\n1 007 BARRO GLOBO 100\n2 124 BOLSA VINIL 200', NULL, NULL, NULL, NULL, 1, 450.00, 2600.00, 450.00, 0.00, 0, 0.00, 3050.00, '2019-09-27', '2019-10-08 20:03:06', 1),
(18, 18, '1 138 LAVERO FIBRA 100\n1 127 IMAN MADERA CH 100', NULL, NULL, NULL, NULL, 1, 300.00, 200.00, NULL, 0.00, 0, 0.00, 200.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(19, 18, '1 047 TENDEDERO CH 250', NULL, NULL, NULL, NULL, 1, 250.00, NULL, 250.00, 0.00, 0, 0.00, 250.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(20, 18, '1 065 GLOBO VGAP 300', NULL, NULL, NULL, NULL, 1, 200.00, 300.00, NULL, 0.00, 0, 0.00, 300.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(21, 18, '1 065 GLOBO VGAP 300', NULL, NULL, NULL, NULL, 1, 200.00, NULL, 300.00, 0.00, 0, 0.00, 300.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(22, 18, '1 127 IMAN CH 100', NULL, NULL, NULL, NULL, 1, 400.00, NULL, 100.00, 0.00, 0, 0.00, 100.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(23, 18, '1 140 FOROS MICRO SD', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 500.00, 0.00, 0, 0.00, 500.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(24, 18, '1 145 FOTO POSTAL 100', NULL, NULL, NULL, NULL, 1, 100.00, NULL, 100.00, 0.00, 0, 0.00, 100.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(25, 18, '1 155 FOTO IMPRESA INCLUIDA', NULL, NULL, NULL, NULL, 1, 200.00, NULL, NULL, 0.00, 0, 0.00, 0.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(26, 18, '1 140 FOTOS MICRO SD \n1 145 FOTO POSTAL 100', NULL, NULL, NULL, NULL, 1, 100.00, NULL, 600.00, 0.00, 0, 0.00, 600.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(27, 18, '1 145 FOTO POSTAL \n1 140 FOTOS MICRO SD ', NULL, NULL, NULL, NULL, 1, 100.00, 600.00, NULL, 0.00, 0, 0.00, 600.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(28, 18, '1 140 FOTOS MICRO SD\n2 145 FOTO POSTAL ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 700.00, 0.00, 0, 0.00, 700.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(29, 18, '1 149 FOROS MICRO SD', NULL, NULL, NULL, NULL, 1, 200.00, NULL, 300.00, 0.00, 0, 0.00, 300.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(30, 18, '1 147 FOTO DIGITAL', NULL, NULL, NULL, NULL, 1, 400.00, 100.00, NULL, 0.00, 0, 0.00, 100.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(31, 18, '2 140 FOTOS MICRO SD ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1000.00, 0.00, 0, 0.00, 1000.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(32, 18, '2 145 FOTO POSTAL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 200.00, 0.00, 0, 0.00, 200.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(33, 18, '1 155 FOTO IMPRESA INCLUIDA', NULL, NULL, NULL, NULL, 1, 200.00, NULL, NULL, 0.00, 0, 0.00, 0.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(34, 18, '1 140 FOTOS MICRO SD', NULL, NULL, NULL, NULL, NULL, NULL, 500.00, NULL, 0.00, 0, 0.00, 500.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(35, 18, '1 145 FOTO POSTAL ', NULL, NULL, NULL, NULL, 1, 100.00, 100.00, NULL, 0.00, 0, 0.00, 100.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(36, 18, '2 014 ARETES ', NULL, NULL, NULL, NULL, 1, 400.00, 100.00, NULL, 0.00, 0, 0.00, 100.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(37, 18, '2 146 FOTOS ENMARCADAS ', NULL, NULL, NULL, NULL, 1, 100.00, 300.00, NULL, 0.00, 0, 0.00, 300.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(38, 18, '1 140 FOTOS MICRO SD\n1 145 FOTO POSTAL', NULL, NULL, NULL, NULL, 1, 100.00, 600.00, NULL, 0.00, 0, 0.00, 600.00, '2019-09-28', '2019-10-08 20:03:06', 1),
(39, 18, '1 149 FOTOS TIERRA\n1 155 FOTO IMPRESA INCLUIDA', NULL, NULL, NULL, NULL, 1, 200.00, 300.00, NULL, 0.00, 0, 0.00, 300.00, '2019-10-01', '2019-10-08 20:03:06', 1),
(40, 18, '1 140 FOTOSMICRO SD\n1 145 FOTO POSTAL', NULL, NULL, NULL, NULL, 1, 100.00, 600.00, NULL, 0.00, 0, 0.00, 600.00, '2019-10-02', '2019-10-08 20:03:06', 1),
(41, 18, '1 140 FOTOS MICRO SD\n1 145 FOTO POSTAL', NULL, NULL, NULL, NULL, 1, 100.00, NULL, 600.00, 0.00, 0, 0.00, 600.00, '2019-10-02', '2019-10-08 20:03:06', 1),
(42, 18, '1 149 FOTOS TIERRA', NULL, NULL, NULL, NULL, 1, 200.00, NULL, 300.00, 0.00, 0, 0.00, 300.00, '2019-10-02', '2019-10-08 20:03:06', 1),
(43, 18, '1 155 FOTO IMPRESA INCLUIDA', NULL, NULL, NULL, NULL, 1, 200.00, NULL, NULL, 0.00, 0, 0.00, 0.00, '2019-10-02', '2019-10-08 20:03:06', 1),
(44, 18, '1 007 BARRO GLOBO\n2 127 IMAN MADERA CH\n2 138 LLAVERO FRIBRA\n2 072 LLAVERO KEY', NULL, NULL, NULL, NULL, 1, 400.00, 600.00, NULL, 0.00, 0, 0.00, 600.00, '2019-10-02', '2019-10-08 20:03:06', 1),
(45, 18, '1 091 PORTARETRATO LIZ\n1 037 ALAJERO', NULL, NULL, NULL, NULL, 1, 100.00, NULL, 400.00, 0.00, 0, 0.00, 400.00, '2019-10-02', '2019-10-08 20:03:06', 1),
(46, 18, '1 158 FOTO Y VIDEO 1,000\n1 155 FOTO IMPRESA INCLUIDA', NULL, NULL, NULL, NULL, 1, 200.00, 1000.00, NULL, 0.00, 0, 0.00, 1000.00, '2019-10-08', '2019-10-08 20:03:06', 1),
(47, 18, '1 149 FOTOS TIERRA ', NULL, NULL, NULL, NULL, 1, 200.00, 300.00, NULL, 0.00, 0, 0.00, 300.00, '2019-10-08', '2019-10-08 20:03:06', 1),
(48, 18, '1 171 SOMBRERO 700\n1 127 IMAN MADERA CH 100', NULL, NULL, NULL, NULL, 1, 200.00, 800.00, NULL, 0.00, 0, 0.00, 800.00, '2019-10-08', '2019-10-08 20:03:06', 1),
(49, 18, '1 149 FOTOS TIERRA 300\n1 142 FOTO IMPRESA 200', NULL, NULL, NULL, NULL, 1, 200.00, 500.00, NULL, 0.00, 0, 0.00, 500.00, '2019-10-08', '2019-10-08 20:03:06', 1),
(50, 18, '1 014 ARETES 50', NULL, NULL, NULL, NULL, 1, 450.00, 50.00, NULL, 0.00, 0, 0.00, 50.00, NULL, '2019-10-09 12:39:01', 1),
(51, 18, '1 158 FOTOS Y VIDEO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1000.00, 0.00, 0, 0.00, 1000.00, NULL, '2019-10-09 12:56:54', 1),
(52, 18, '2 145 FOTO POSTAL', NULL, NULL, NULL, NULL, NULL, NULL, 200.00, NULL, 0.00, 0, 0.00, 200.00, NULL, '2019-10-09 12:57:41', 1),
(53, 18, '1 149 FOTOS TIERRA', NULL, NULL, NULL, NULL, 1, 200.00, 300.00, NULL, 0.00, 0, 0.00, 300.00, NULL, '2019-10-09 12:58:26', 1),
(54, 18, '1 140 FOTOS MICRO SD ', NULL, NULL, NULL, NULL, 1, NULL, NULL, 500.00, 0.00, 0, 0.00, 500.00, NULL, '2019-10-11 12:40:38', 1),
(55, 18, '1 149 FOTOS TIERRA 300 \n1 145 FOTO POSTAL 100', NULL, NULL, NULL, NULL, 1, 300.00, 400.00, NULL, 0.00, 0, 0.00, 400.00, NULL, '2019-10-11 12:41:46', 1),
(56, 18, '2 147 FOTOS DIGITAL', NULL, NULL, NULL, NULL, 1, 300.00, 200.00, NULL, 0.00, 0, 0.00, 200.00, NULL, '2019-10-11 12:43:15', 1),
(57, 18, '4 145 FOTOS POSTAL', NULL, NULL, NULL, NULL, NULL, NULL, 400.00, NULL, 0.00, 0, 0.00, 400.00, NULL, '2019-10-11 12:43:51', 1),
(58, 18, '1 140 FOTOS MICRO SD \n1 145 FOTO POSTAL', NULL, NULL, NULL, NULL, 1, 100.00, 600.00, NULL, 0.00, 0, 0.00, 600.00, NULL, '2019-10-11 12:44:29', 1),
(59, 18, '1 140 FOTOS MICRO SD', NULL, NULL, NULL, NULL, NULL, NULL, 500.00, NULL, 0.00, 0, 0.00, 500.00, NULL, '2019-10-11 12:45:23', 1),
(60, 18, '1 140 FOTOS MICRO SD\n1 145 FOTO POSTAL', NULL, NULL, NULL, NULL, 1, 100.00, NULL, 600.00, 0.00, 0, 0.00, 600.00, NULL, '2019-10-11 12:46:08', 1),
(61, 18, '1 127 IMAN MADERA CH 100\n1 014 ARETES 50 \n1 027 COLLAR 100', NULL, NULL, NULL, NULL, 1, 250.00, 250.00, NULL, 0.00, 0, 0.00, 250.00, NULL, '2019-10-11 12:47:09', 1),
(62, 18, '1 137 PORTARETRATO JOEL \n2 126 IMAN MADERA\n1 052 GLOBO TEXTIL CH', NULL, NULL, NULL, NULL, 1, 350.00, NULL, 650.00, 0.00, 0, 0.00, 650.00, NULL, '2019-10-11 12:49:08', 1),
(63, 18, '1 104 TAZA', NULL, NULL, NULL, NULL, 1, 400.00, 100.00, NULL, 0.00, 0, 0.00, 100.00, NULL, '2019-10-11 12:50:12', 1),
(64, 18, '1 137 PORTA RETRATO JOEL\n1 140 FOTOS MICRO SD\n1 145 FOTO POSTAL', NULL, NULL, NULL, NULL, 1, 150.00, NULL, 850.00, 0.00, 0, 0.00, 850.00, NULL, '2019-10-11 12:51:26', 1),
(65, 18, '2 126 IMAN MADERA ', NULL, NULL, NULL, NULL, 1, 200.00, NULL, 300.00, 0.00, 0, 0.00, 300.00, NULL, '2019-10-12 13:18:14', 1),
(66, 18, '1 140 FOTOS MICRO SD\n3 145 FOTO POSTAL', NULL, NULL, NULL, NULL, 1, 100.00, 800.00, NULL, 0.00, 0, 0.00, 800.00, NULL, '2019-10-12 13:19:10', 1),
(67, 1, '2 145 FOTO POSTAL 100', NULL, NULL, NULL, NULL, NULL, NULL, 200.00, NULL, 0.00, 0, 0.00, 200.00, NULL, '2019-10-13 10:43:58', 1),
(68, 1, '1 140 FOTOS MICRO SD 500\n1 146 FOTO ENMARCADA 150\n1 147 FOTO DIGITAL 100', NULL, NULL, NULL, NULL, 1, 150.00, 750.00, NULL, 0.00, 0, 0.00, 750.00, NULL, '2019-10-13 10:58:52', 1),
(69, 1, '1 147 FOTO DIGITAL\n1 140 FOTOS MICRO SD\n1 145 FOTO POSTAL\n', NULL, NULL, NULL, NULL, NULL, NULL, 600.00, 100.00, 0.00, 0, 0.00, 700.00, NULL, '2019-10-13 10:59:51', 1),
(70, 1, '1  052 GLOBO TEXTIL CH 150\n2 126 IMAN MADERA 150\n1 099 SEPARADOR ANIMALITOS\n1 137 PORTA RETRATO JOEL', NULL, NULL, NULL, NULL, 1, 285.00, 450.00, 265.00, 0.00, 0, 0.00, 715.00, NULL, '2019-10-13 11:03:22', 1),
(71, 18, '1 158 FOTO Y VIDEO 1000\n1 145 FOTO POSTAL 100', NULL, NULL, NULL, NULL, 1, 100.00, NULL, 1100.00, 0.00, 0, 0.00, 1100.00, NULL, '2019-10-13 11:40:54', 1),
(72, 18, '1 158 FOTOS Y VIDEO\n1 155 FOTO IMPRESA INCLUIDA \n1 145 FOTO POSTAL', NULL, NULL, NULL, NULL, 1, 100.00, 1100.00, NULL, 0.00, 0, 0.00, 1100.00, NULL, '2019-10-13 11:42:25', 1),
(73, 18, '1 140 FOTOS MICRO SD', NULL, NULL, NULL, NULL, 1, 50.00, 450.00, NULL, 0.00, 0, 0.00, 450.00, NULL, '2019-10-13 11:43:39', 1),
(74, 18, '1 137 PORTA RETRATO JOEL 250\n1 005 IMAN AZUCAR 120\n1 171 SOBRERO 700', NULL, NULL, NULL, NULL, 1, 430.00, NULL, 1070.00, 0.00, 0, 0.00, 1070.00, NULL, '2019-10-13 11:44:58', 1),
(75, 18, '1 158 FOTOS Y VIDEO 1000\n1 145 FOTO POSTAL', NULL, NULL, NULL, NULL, 1, 100.00, NULL, 1100.00, 0.00, 0, 0.00, 1100.00, NULL, '2019-10-13 12:06:00', 1),
(76, 18, '1 140 FOTOS MICRO SD 500\n1 145 FOTO POSTAL 100', NULL, NULL, NULL, NULL, 1, 100.00, NULL, 600.00, 0.00, 0, 0.00, 600.00, NULL, '2019-10-13 12:06:44', 1),
(77, 18, '1 147 FOTO DIGITAL 100', NULL, NULL, NULL, NULL, 1, 100.00, 100.00, NULL, 0.00, 0, 0.00, 100.00, NULL, '2019-10-13 12:07:31', 1),
(78, 18, '1 073 LLAVERO RESINA 50\n1 046 GLOBO CANTOYA 50\n1 126 GLOBO MADERA 150', NULL, NULL, NULL, NULL, 1, 250.00, 250.00, NULL, 0.00, 0, 0.00, 250.00, NULL, '2019-10-14 23:45:10', 1),
(79, 18, '1 140 FOTOS MICRO SD 500\n1 081 PANTALLA CHICA 120\n\nEL PAGO LO REALIZARON EN USD EL TIPO DE CAMBIO ES 17.50', NULL, NULL, NULL, NULL, 1, 380.00, 620.00, NULL, 0.00, 0, 0.00, 620.00, NULL, '2019-10-14 23:47:00', 1),
(80, 18, '3 147 FOTO DIGITAL 300\n1 155 FOTO IMPRESA\n1 154 FOTOS INCLUIDAS', NULL, NULL, NULL, NULL, 1, 200.00, NULL, 300.00, 0.00, 0, 0.00, 300.00, NULL, '2019-10-14 23:48:42', 1),
(81, 18, '2 140 FOTOS MICRO SD\n2 145 FOTO POSTAL', NULL, NULL, NULL, NULL, NULL, NULL, 1200.00, 200.00, 0.00, 0, 0.00, 1400.00, NULL, '2019-10-14 23:50:12', 1),
(82, 18, '3 140 FOTOS MICRO SD\n2 158 FOTOS Y VIDEO\n1 149 FOTOS TIERRA\n3 145 FOTO POSTAL', NULL, NULL, NULL, NULL, 1, 400.00, 2600.00, 1400.00, 0.00, 0, 0.00, 4000.00, NULL, '2019-10-15 17:34:02', 1),
(83, 18, '1 140 FOTOS MICRO SD', NULL, NULL, NULL, NULL, NULL, NULL, 500.00, NULL, 0.00, 0, 0.00, 500.00, NULL, '2019-10-17 18:20:41', 1),
(84, 18, 'DESAYUNO TIPO BUFFET ', NULL, NULL, NULL, NULL, NULL, NULL, 140.00, NULL, 0.00, 0, 0.00, 140.00, NULL, '2019-10-18 09:16:01', 1),
(85, 18, '4 140 FOTOS MICRO SD 500\n4 145 FOTO POSTAL 100', NULL, NULL, NULL, NULL, NULL, NULL, 2400.00, NULL, 0.00, 0, 0.00, 2400.00, NULL, '2019-10-23 13:16:25', 1),
(86, 18, '1 149 FOTOS TIERRA 300', NULL, NULL, NULL, NULL, 1, 200.00, NULL, 300.00, 0.00, 0, 0.00, 300.00, NULL, '2019-10-23 13:16:52', 1),
(87, 18, '1 158 FOTOS Y VIDEO 1000\n1 145 FOTO POSTAL 100', NULL, NULL, NULL, NULL, 1, 100.00, NULL, 1100.00, 0.00, 0, 0.00, 1100.00, NULL, '2019-10-23 13:17:36', 1),
(88, 18, '2 138 LLAVERO FIBRA 200\n1 014 ARETES 50\n1 068 STICKER 75\n2 126 IMAN MADERA CH\n1 062 IMAN RESINA', NULL, NULL, NULL, NULL, 1, 425.00, 575.00, NULL, 0.00, 0, 0.00, 575.00, NULL, '2019-10-23 13:22:07', 1),
(89, 11, 'GUANAJUATENSES', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 280.00, 0.00, 0, 0.00, 280.00, NULL, '2019-11-06 10:36:33', 1),
(90, 1, 'f', 'sasa', 23.00, NULL, NULL, NULL, NULL, NULL, 1.20, 0.00, 100, 19.00, 1.20, NULL, '2019-11-20 11:06:30', 1),
(91, 1, 'f', 'sasa', 23.00, NULL, NULL, NULL, NULL, NULL, 1.20, 0.00, 100, 19.00, 1.20, NULL, '2019-11-20 11:06:44', 1),
(92, 1, 'f', 'sasa', 23.00, NULL, NULL, NULL, NULL, NULL, 1.20, 0.00, 100, 19.00, 1.20, NULL, '2019-11-20 11:06:56', 1),
(93, 1, 'f', 'sasa', 23.00, NULL, NULL, NULL, NULL, NULL, 1.20, 0.00, 100, 19.00, 1.20, NULL, '2019-11-20 11:07:02', 1),
(94, 1, 'f', 'sasa', 23.00, NULL, NULL, NULL, NULL, NULL, 1.20, 0.00, 100, 19.00, 1.20, NULL, '2019-11-20 11:07:22', 1),
(95, 1, 'f', 'sasa', 23.00, NULL, NULL, NULL, NULL, NULL, 1.20, 0.00, 100, 19.00, 1.20, NULL, '2019-11-20 11:07:47', 1),
(96, 1, 'dddddd', 'wq', 23.00, NULL, NULL, NULL, NULL, NULL, NULL, 1.20, 100, 19.00, 1.20, NULL, '2019-11-20 11:09:58', 1),
(97, 1, 'dddddd', 'wq', 23.00, NULL, NULL, NULL, NULL, NULL, NULL, 1.20, 100, 19.00, 1.20, NULL, '2019-11-20 11:11:44', 1),
(98, 1, 'fs', 'd', 12.00, NULL, NULL, NULL, NULL, 0.57, NULL, 0.00, 101, 21.00, 0.57, '2019-11-20', '2019-11-20 11:13:30', 1),
(99, 1, 'pruebaaaa', 'prueb', 150.00, NULL, NULL, 1, 50.00, 5.21, NULL, 0.00, 100, 19.00, 5.21, '2019-11-20', '2019-11-20 11:48:02', 1);

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
  `register` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Registro',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `volar_usuarios`
--

INSERT INTO `volar_usuarios` (`id_usu`, `nombre_usu`, `apellidop_usu`, `apellidom_usu`, `depto_usu`, `puesto_usu`, `correo_usu`, `telefono_usu`, `contrasena_usu`, `usuario_usu`, `nss_usu`, `sd_usu`, `sdi_usu`, `fiscal_usu`, `isr_usu`, `imss_usu`, `infonavit_usu`, `subsidio_usu`, `quincenal_usu`, `complemento_usu`, `falta_usu`, `banco_usu`, `cuenta_usu`, `register`, `status`) VALUES
(1, 'ENRIQUE', 'DAMASCO', 'ALDUCIN', 1, 1, 'enriquealducin@volarenglobo.com.mx', '5529227672', 'c4ca4238a0b923820dcc509a6f75849b', 'Quique', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-03-29 23:20:06', 1),
(3, 'SONIA', 'ALDUCIN', 'GUAJARDO', 3, 3, 'contabilidad@volarenglobo.com.mx', '5568177013', '86cd30166d3e74003ae788951843b8cd', 'sony', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-04-10 09:27:49', 1),
(8, 'RICARDO', 'CRUZ', 'ROCHA', 7, 17, 'ricardo@volarenglobo.com.mx', '5551068115', 'f8981fe3fb8b73cc6ecc519b69cfe8eb', 'Ricardo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 16:34:09', 1),
(9, 'ALEJANDRA', 'RAMIREZ', 'SERRANO', 5, 15, 'turismo@volarenglobo.com.mx', '5530704317', '746034988c74912ec9ca4b11cebfa5c4', 'turismo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-05-21 16:35:26', 1),
(11, 'SERGIO', 'RAMIREZ', 'GARCIA', 5, 7, 'sergio@volarenglobo.com.mx', '5555023615', 'bd0552744e0fe89e995c367ee4acc101', 'checolate', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-06-25 07:52:34', 1),
(14, 'ALEJANDRA', 'MONTES DE OCA', 'FEREGRINO', 8, 13, 'ventas@volarenglobo.com.mx', '5524900000', '9c779f56f336b3c812343434f57b6a0e', 'alemonts', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-22 18:14:20', 1),
(15, 'CHRSITOFFER MICHELLE', 'OLIVIA', 'HERNANDEZ', 7, 17, 'auxiliar@volarenglobo.com.mx', '5545935376', 'af4481c642771f7196660028b2e019a7', 'Chris', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-08-22 18:54:31', 1),
(16, 'SUSANA', 'SALAZAR', 'VIQUEZ', 8, 13, 'reserva@volarenglobo.com.mx', '5510998008', '8ef747720bc83aed6640295831a32d83', 'reserva', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-02 14:39:09', 1),
(17, 'ANA MARIA', 'ROCHA', 'MUÃ‘OZ', 3, 21, 'contabilidad@volarenglobo.com.mx', '5539773436', '807b9be210ec6018b61f32498bd5abab', 'anny', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-04 12:34:03', 1),
(18, 'MARIA DE JESUS', 'SORIANO', 'AGUILAR', 4, 12, 'admonteoti@volarenglobo.com.mx', '5560233534', 'c6e04c6343a907c961108fef4a8199dd', 'marichuy', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-18 19:02:11', 1),
(19, 'SERGIO', 'RAMIREZ', 'SERRANO', 4, 12, 'zergio@volarenglobo.com.mx', '5530203538', '774b7402e65d38a52b7642337156455e', 'zergioram', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-09-19 07:48:32', 1),
(20, 'TEMPORAL', 'VOLAR', 'GLOBO', 2, 6, 'volarenglobo@yahoo.es', '5558706611', 'e34c64a05273012b2868d8b04b812089', 'tempo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-11 14:52:57', 1),
(21, 'JESUS FEDERICO', 'DELGADILLO', 'PADILLA', 4, 4, 'volarenglobo@yahoo.es', '55214878921', '612d8188c841646720aa267872283488', 'chuyin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-14 18:23:19', 1),
(22, 'KAREN', 'GUTIERREZ', 'VELEZ', 4, 12, 'karen-02020@hotmail.com', '5584783772', '5012dfe49ed4d720f6ec078745ba7d85', 'karengo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-11-06 09:46:12', 1);

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
-- Indices de la tabla `cargosextras_volar`
--
ALTER TABLE `cargosextras_volar`
  ADD PRIMARY KEY (`id_ce`);

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
  MODIFY `id_bc` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `bitpagos_volar`
--
ALTER TABLE `bitpagos_volar`
  MODIFY `id_bp` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=773;

--
-- AUTO_INCREMENT de la tabla `cargosextras_volar`
--
ALTER TABLE `cargosextras_volar`
  MODIFY `id_ce` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=17;

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
  MODIFY `id_extra` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=102;

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
  MODIFY `id_habitacion` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=26;

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
  MODIFY `id_puv` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=546;

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
  MODIFY `id_rep` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=70;

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
  MODIFY `id_sv` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=3605;

--
-- AUTO_INCREMENT de la tabla `subpermisos_volar`
--
ALTER TABLE `subpermisos_volar`
  MODIFY `id_sp` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=91;

--
-- AUTO_INCREMENT de la tabla `temp_volar`
--
ALTER TABLE `temp_volar`
  MODIFY `id_temp` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=2130;

--
-- AUTO_INCREMENT de la tabla `ventasserv_volar`
--
ALTER TABLE `ventasserv_volar`
  MODIFY `id_vsv` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=121;

--
-- AUTO_INCREMENT de la tabla `ventas_volar`
--
ALTER TABLE `ventas_volar`
  MODIFY `id_venta` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=100;

--
-- AUTO_INCREMENT de la tabla `volar_usuarios`
--
ALTER TABLE `volar_usuarios`
  MODIFY `id_usu` int(4) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `vueloscat_volar`
--
ALTER TABLE `vueloscat_volar`
  MODIFY `id_vc` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Llave Primaria', AUTO_INCREMENT=18;

DELIMITER $$
--
-- Eventos
--
CREATE  EVENT `cancelaReservas` ON SCHEDULE EVERY 1 DAY STARTS '2019-08-28 01:47:37' ON COMPLETION PRESERVE ENABLE COMMENT 'Cancelar reservas que tengan mas de 30 dias' DO Update temp_volar set status = 0 where  fechavuelo_temp < DATE_SUB(NOW(), INTERVAL 30 DAY) and status not in(1,7)$$

CREATE  EVENT `cancelarReservasSinCot` ON SCHEDULE EVERY 1 MINUTE STARTS '2019-09-03 12:29:00' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE temp_volar set status=0 where status=2$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
