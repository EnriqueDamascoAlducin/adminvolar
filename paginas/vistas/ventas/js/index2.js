function verPermisos(usuario,modulo){
	url="vistas/usuarios/forms/permisos.php";
	parametros={usuario:usuario,modulo,modulo};
  	$.ajax({
		url:url,
		method: "POST",
  		data: parametros,
  		success:function(response){
			$("#cuerpoModal").html(response);	
  		},
  		error:function(){
  		
          abrir_gritter("Error","Error desconocido" ,"danger");
  		},
  		statusCode: {
		    404: function() {
		     
          abrir_gritter("Error","URL NO encontrada" ,"danger");
		    }
		  }
	});
}
function guardarPermiso(permiso,usuario){
	status = 0;
	if($("#permiso_"+permiso).is(":checked")){
		status =1;
	}
	$.ajax({
		url:'controladores/usuariosController.php',
		method: "POST",
  		data: {permiso:permiso,usuario,usuario,status:status,accion:'permisos'},
  		success:function(response){
  			if(response==""){

         		abrir_gritter("Error","Error al Asignar Permisos" ,"danger");
  			}else{
		         abrir_gritter("Exito","Permiso "+ response ,"info");
  			}
  			
  		},
  		error:function(){
  		
          abrir_gritter("Error","Error desconocido" ,"danger");
  		},
  		statusCode: {
		    404: function() {
		     
          abrir_gritter("Error","URL NO encontrada" ,"danger");
		    }
		  }
	});
}