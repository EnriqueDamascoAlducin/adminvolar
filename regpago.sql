BEGIN
IF(SELECT COUNT(id_bp) as pagos from bitpagos_volar  where idres_bp= )>0 THEN
    IF (SELECT (ifnull(sum(cantidad_bp),0)+  ) from bitpagos_volar where idres_bp= )>(Select total_temp FROM temp_volar where id_temp  = ) THEN
        SET respuesta = 'ERROR EN PAGO';
    ELSEIF (=0) THEN
        INSERT INTO bitpagos_volar (idres_bp,idreg_bp,metodo_bp,banco_bp,referencia_bp,cantidad_bp,fecha_bp,comision_bp) VALUES (,,,,,,,);
        SET respuesta = CONCAT('Registrado|',LAST_INSERT_ID());
        IF(=83) THEN
            UPDATE bitpagos_volar set status = 2 WHERE id_bp = LAST_INSERT_ID();
              IF (SELECT (sum(cantidad_bp) ) from bitpagos_volar where idres_bp in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID()) )=(Select total_temp FROM temp_volar where id_temp  in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID())) THEN
                  UPDATE temp_volar set status = 8 WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID());
              ELSE
                  UPDATE temp_volar set status = 8 WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID());
              END IF;
        END IF;
    ELSE
        UPDATE bitpagos_volar SET idconc_bp=, fechaconc_bp= CURRENT_TIMESTAMP, status = 3 WHERE id_bp = ;
        SET respuesta = 'Conciliado';
          IF (SELECT (sum(cantidad_bp)+  ) from bitpagos_volar where idres_bp in (SELECT idres_bp from bitpagos_volar where id_bp = ) )=(Select total_temp FROM temp_volar where id_temp  in (SELECT idres_bp from bitpagos_volar where id_bp = )) THEN
              UPDATE temp_volar set status = 8  WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp =  );
          ELSE
              UPDATE temp_volar set status = 4 WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp =  );
          END IF;
    END IF;

  ELSEIF(SELECT total_temp from temp_volar where id_temp=) <  THEN
    SET respuesta = 'ERROR EN PAGO';

  ELSE
    INSERT INTO bitpagos_volar (idres_bp,idreg_bp,metodo_bp,banco_bp,referencia_bp,cantidad_bp,fecha_bp,comision_bp) VALUES (,,,,,,,);
    SET respuesta = CONCAT('Registrado|',LAST_INSERT_ID());

    IF(=83) THEN
        UPDATE bitpagos_volar set status = 2 WHERE id_bp = LAST_INSERT_ID();
          IF (SELECT (sum(cantidad_bp) ) from bitpagos_volar where idres_bp in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID()) )=(Select total_temp FROM temp_volar where id_temp  in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID())) THEN
              UPDATE temp_volar set status = 8 WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID());
          ELSE
              UPDATE temp_volar set status = 8 WHERE id_temp in (SELECT idres_bp from bitpagos_volar where id_bp = LAST_INSERT_ID());
          END IF;
    END IF;
  END IF;
END
