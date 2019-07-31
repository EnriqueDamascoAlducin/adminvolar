DELIMITER //
CREATE PROCEDURE registrarPago(IN _pago bigint,IN _reserva bigint , IN _usuario int,IN _metodo int , IN _banco int,IN _referencia varchar(200),IN _cantidad double(10,2), IN _fechaPago varchar(30),IN _usuarioCOncilia int,OUT respuesta varchar(25))
BEGIN
	IF (SELECT (sum(cantidad_bp)+ _cantidad ) from bitpagos_volar where idres_bp=_reserva )>(Select total_temp FROM temp_volar where id_temp  = _reserva) THEN
    	SET respuesta = 'ERROR EN PAGO';
    ELSEIF (_usuarioConcilia=0) THEN
    	INSERT INTO bitpagos_volar (idres_bp,idreg_bp,metodo_bp,banco_bp,referencia_bp,cantidad_bp,fecha_bp) VALUES (_reserva,_usuario,_metodo,_banco,_referencia,_cantidad,_fechaPago);
        SET respuesta = 'Registrado';
    ELSE
    	UPDATE bitpagos_volar SET idconc_bp=_usuarioCOncilia, fechaconc_bp= CURRENT_TIMESTAMP WHERE id_bp = _pago;
        SET respuesta = 'Conciliado';
    END IF;
END//