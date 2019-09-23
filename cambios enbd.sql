movimientos en BD
agregar idioma_temp,
ALTER TABLE `temp_volar` ADD `tipopeso_temp` TINYINT NOT NULL DEFAULT '1' COMMENT 'Tipo de Peso(Kg, lb)' AFTER `kg_temp`;
ALTER TABLE `temp_volar` ADD `idioma_temp` TINYINT NOT NULL DEFAULT '1' COMMENT 'Idioma' AFTER `hora_temp`;

modificar getReservaData, getReservaREsumen,remplazarReserva, registrarPago
