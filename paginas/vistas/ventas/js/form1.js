function isNumber(event){
	var iKeyCode = (event.which) ? event.which : event.keyCode
    if ((iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) )
        return false;

    return true;
}

function validarValor(id){
	if($("#"+id).val().trim()==''){
		$("#"+id).val(0);
	}
}
function aumentar(id){
	var valActual = ($("#cantidad_"+id).val());
	if(valActual==''){
		valActual=0;
	}
	var nuevoValor = parseInt(valActual)+1;
	$("#cantidad_"+id).val(nuevoValor);
}
function disminuir(id){
	var valActual = $("#cantidad_"+id).val();
	if(valActual==''){
		valActual=0;
	}
	var nuevoValor = parseInt(valActual)-1;
	if(nuevoValor<0){
		$("#cantidad_"+id).val(0);
		abrir_gritter("Advertencia","No puedes poner un valor menor a 0","warning");
	}else{
		$("#cantidad_"+id).val(nuevoValor);
	}
}

function cotizar(accion){
	$("#cuerpoModal").html("");
	$("#btnConfirmar").hide();
	serviciosValor=[];
	serviciosId=[];
	servicios = $("input[name^='cantidad_']");
	comentario=$("#comentario").val();
	otroscar1=$("#otroscar1").val();
	precio1=$("#precio1").val();
	otroscar2=$("#otroscar2").val();
	precio2=$("#precio2").val();
	tipodesc=$("#tipodesc").val();
	cantdesc=$("#cantdesc").val();
	pagoefectivo=$("#pagoefectivo").val();
	pagotarjeta=$("#pagotarjeta").val();
	if(comentario.trim()==''){
		abrir_gritter("Advertencia","Agrega un comentario","warning");
		return false;
	}
	if(pagoefectivo.trim()=='' && pagotarjeta.trim()=='' && accion!='calcular' && accion!='cotizar'){
		abrir_gritter("Advertencia","Agrega un pago","warning");
		return false;
	}
	servicios.each( function () {
		if($(this).val()>0){
			serviciosValor.push($(this).val());
			serviciosId.push($(this).attr("id"));
		}
  	});
  	parametros={
  		serviciosId:serviciosId,
  		serviciosValor:serviciosValor,
  		comentario:comentario,
		otroscar1:otroscar1,
		precio1:precio1,
		otroscar2:otroscar2,
		precio2:precio2,
		tipodesc:tipodesc,
		cantdesc:cantdesc,
		pagoefectivo:pagoefectivo,
		accion:accion,
		pagotarjeta:pagotarjeta
  	};
  	if(accion=='cotizar'){
  		url="vistas/ventas/forms/resumenVta.php";
  	}else if(accion=='calcular'){
  		url="vistas/ventas/forms/calcularVta.php";
  	}else{
		url="controladores/ventasController.php";
  	}
	
  	$.ajax({
		url:url,
		method: "POST",
  		data: parametros,
  		beforeSend:function(){
			$("#cuerpoModal").html("<img src='../sources/images/icons/cargando.gif'>");
  		},
  		success:function(response){
  			if(accion=='calcular' ){
				$("#totalVta").html('Total: '+response);
			}else if(accion=='cotizar'){
				$("#cuerpoModal").html(response);	
				$("#btnConfirmar").show();
			}else{
				if(response.includes('correctamente'))
					abrir_gritter("Correcto",response,"info");
				else
					abrir_gritter("Error",response,"danger");
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