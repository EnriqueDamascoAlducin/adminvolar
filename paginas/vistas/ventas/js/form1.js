function isNumber(event){
	var iKeyCode = (event.which) ? event.which : event.keyCode

    if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57))
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
	serviciosValor=[];
	serviciosId=[];
	servicios = $("input[name^='cantidad_']");
	servicios.each( function () {
		if($(this).val()>0){
			serviciosValor.push($(this).val());
			serviciosId.push($(this).attr("id"));
		}
		
  	});
  	alert(serviciosValor);
}