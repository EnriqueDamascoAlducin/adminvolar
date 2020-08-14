function abrir_gritter(titulo,texto, clase){
  $.gritter.add({
      // (string | mandatory) the heading of the notification
      title: titulo,
      // (string | mandatory) the text inside the notification
      text: "<span style='color:white'>"+texto+"</span>",
      class_name: 'gritter gritter-'+clase
  });
} 
function cambiarTamanoModal(modal,tamano,accion){
	if(accion=='agregar'){
		$("#"+modal).addClass("modal-"+tamano);
	}else if(accion=='resetear'){
		$("#"+modal).removeClass("modal-"+tamano);
		$("#"+modal).removeClass("modal-md");
	}
}

function isNumber(event){
	var iKeyCode = (event.which) ? event.which : event.keyCode
    if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57))
        return false;

    return true;
}
function abrirPagina(url,id){
	parametros={id:id};
	$("#contenedor").empty();
  	$.ajax({
		url:url,
		method: "POST",
  		data: parametros,
  		success:function(response){
			$("#contenedor").append(response);	
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
function ocultar(id,tipo){
	if(tipo==0){
		$("#menuIzq").css("max-width","0%");
		$("#simbolo1").removeClass("fa-arrow-left").addClass("fa-arrow-right");
		$("#simbolo").attr("onclick","ocultar('menu',1)");
		$("#menuDer").css("max-width","100%").css("width","100%").css("left","0%");

	}else{
		$("#menuIzq").css("max-width","20%").css("width","20%");
		$("#simbolo1").removeClass("fa-arrow-right").addClass("fa-arrow-left");
		$("#simbolo").attr("onclick","ocultar('menu',0)");
		$("#menuDer").css("max-width","80%").css("width","80%").css("left","20%");

	}
	tables(0,"asc");
}
/*function tables(){
	$(".DataTable").DataTable().destroy();
	$(".DataTable").DataTable({
		"autoWidth": true,
		"scrollX": true,
		"searching": true,
		"lengthChange":true, 
        "order": [[ 0, "asc" ]]
		
	});
}*/
function tables(filas,forma){
	$(".DataTable").DataTable().destroy();
	$(".DataTable").DataTable({
		"autoWidth": true,
		"scrollX": true,
		"searching": true,
		"lengthChange":true, 
        "order": [[ filas, forma ]]
		
	});
}

$('.modal').on('hidden.bs.modal', function () {
  $(".modal-body").html('');
})


function isNumberPositiveInt(event){
	var iKeyCode = (event.which) ? event.which : event.keyCode
	
    if (iKeyCode == 46 || iKeyCode == 45 || iKeyCode == 43 || iKeyCode == 42 || iKeyCode == 47  || iKeyCode == 101 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57))
        return false;

    return true;
}