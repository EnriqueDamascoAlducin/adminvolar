DELIMITER//
CREATE PROCEDURE getUsuarioInfo(IN _idUsu int)
BEGIN 
	Select id_usu,IFNULL(nombre_usu,'') as nombre_usu,IFNULL(apellidop_usu,'') as apellidop_usu, IFNULL(apellidom_usu,'') as apellidom_usu, IFNULL(depto_usu,'') as depto_usu, 
    IFNULL(puesto_usu,'') as puesto_usu, IFNULL(correo_usu,'') as correo_usu, IFNULL(telefono_usu,'') as telefono_usu, IFNULL(contrasena_usu,'') as contrasena_usu, IFNULL(usuario_usu,'') as usuario_usu,
END//