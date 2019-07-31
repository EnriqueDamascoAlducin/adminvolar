$("#depto").on("change",function(){
	cargarPuestos();
});
function cargarPuestos(){
	url="controladores/query_json.php";
	hotel=$("#depto").val();
	if(hotel==""){
		return false;
	}
	var1="id_habitacion as value, nombre_habitacion as text";
	var2="habitaciones_volar";
	var3="status<>0 AND idhotel_habitacion="+hotel;
	//abrir_gritter("a","select " + var1 + " from "+ var2+ " where " + var3, "info");
    parametros={var1:var1,var2:var2,var3:var3};
  	$("#habitacion").empty().append("<option value=''>Selecciona una habitación </option>");
  	$.ajax({
      data: parametros,
      dataType:"json",
      url:'controladores/query_json.php',
      type:"POST",
      success: function(data){	
        $.each( data, function( key, value ) {
		  text=value.text;
		  val=value.value;
		  attr="";
		  if(val==puesto){
		  	attr="selected";
		  }
		  $("#habitacion").append("<option value='"+val+"' "+attr+">"+text+"</option>");
		});
      },
      error:function(){
      	alert("Error al cargar habitación");
      }

    }); 
}
function guardarUsuario(id){
	accion="actualizar";
	if(id==""){
		accion="agregar";
	}
	error = 0;
	nombre = $("#nombre").val();
	apellidop = $("#apellidop").val();
	apellidom = $("#apellidom").val();
	depto = $("#depto").val();
	puesto = $("#puesto").val();
	correo = $("#correo").val();
	telefono = $("#telefono").val();
	usuario = $("#usuario").val();
	contrasena = $("#contrasena").val();
	puesto = 1;
	if(nombre==""){
		abrir_gritter("Advertencia","Ingresa un nombre","warning");
		error++;
	}
	if(apellidop==""){
		abrir_gritter("Advertencia","Ingresa un Apellido","warning");
		error++;
	}
	if(depto==""){
		abrir_gritter("Advertencia","Ingresa un Departamento","warning");
		error++;
	}
	if(puesto==""){
		abrir_gritter("Advertencia","Ingresa un Puesto","warning");
		error++;
	}
	if(correo==""){
		abrir_gritter("Advertencia","Ingresa un correo","warning");
		error++;
	}
	if(telefono==""){
		abrir_gritter("Advertencia","Ingresa un telefono","warning");
		error++;
	}
	if(usuario==""){
		abrir_gritter("Advertencia","Ingresa un Usuario","warning");
		error++;
	}
	if(contrasena=="" && accion=="agregar"){
		abrir_gritter("Advertencia","Ingresa una contraseña","warning");
		error++;
	}
	if(error>0){
		return false;
	}
	//contrasenaOld = $("#contrasenaOld").val();
	
	$.ajax({
		url:'controladores/usuariosController.php',
		method: "POST",
  		data: {nombre:nombre,apellidop,apellidop,apellidom:apellidom,depto:depto,puesto:puesto,correo:correo,telefono:telefono,usuario:usuario,contrasena:contrasena,idusu:id},
  		success:function(response){
  			if(response==""){

         		abrir_gritter("Error","Error al Asignar Permisos" ,"danger");
  			}else if(response=="Ya existe el usuario"){
		         abrir_gritter("Exito", response ,"warning");
		         $("#usuario").focus();
  			}else{
		         abrir_gritter("Exito","Usuario "+ response ,"info");
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