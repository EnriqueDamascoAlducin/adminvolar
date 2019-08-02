function guardarServicio(e) {
	var parametros = new FormData($("#formulario")[0]);
	$.ajax({
		data:parametros,
		url:'controladores/serviciosController.php',
		type:'POST',
		contentType:false,
		processData:false,
		success:function(response){
			if(response=="Actualizado" || response == 'Registrado'){

         		abrir_gritter("Correcot",response ,"info");
			}else{

         		abrir_gritter("Error","Error al registrar su servicio" ,"danger");
			}
		}
	});
	e.preventDefault();
}