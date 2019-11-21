function abrir_gritter(titulo,texto, clase){
  $.gritter.add({
      // (string | mandatory) the heading of the notification
      title: titulo,
      // (string | mandatory) the text inside the notification
      text: "<span style='color:white'>"+texto+"</span>",
      class_name: 'gritter gritter-'+clase
  });
}
function validarSesion(e){
  usuario= $("#user").val();
  pass= $("#pass").val();

  if(usuario.trim()==""){
  	abrir_gritter("Error","Debe Ingresar un usuario","warning");
  	$("#user").focus();
  	return false;
  }
  if(pass.trim()==""){
  	abrir_gritter("Error","Debe Ingresar su contraseña","warning");
  	$("#pass").focus();
  	return false;
  }

	parametros=$("#loginForm").serialize();
  	$.ajax({
  		url:"paginas/controladores/loginController.php",
  		method: "POST",
  		data: parametros,
  		success:function(response){
  			if(response.includes("Bienvenido")){
  				abrir_gritter("Bienvenido",response,"success");
  				setTimeout(function(){
		  				window.location.replace("paginas/");
  				},2000);
  			}else{
  				abrir_gritter("Error","Usuario y/o Contraseña Incorrecto "  ,"danger");
  				$("#user").focus();
  			}

  		},
  		error:function(){

  		},
  		statusCode: {
		    404: function() {

          abrir_gritter("Error","URL NO encontrada" ,"danger");
		    }
		  }
	  });
  	e.preventDefault();
}
