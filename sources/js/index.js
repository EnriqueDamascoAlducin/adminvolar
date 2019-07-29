function abrir_gritter(titulo,texto, clase){
  $.gritter.add({
      // (string | mandatory) the heading of the notification
      title: titulo,
      // (string | mandatory) the text inside the notification
      text: "<span style='color:white'>"+texto+"</span>",
      class_name: 'gritter gritter-'+clase
  });
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
	tables();
}
function tables(){
	$(".DataTable").DataTable().destroy();
	$(".DataTable").DataTable({
		"autoWidth": true,
		"scrollX": true,
		"searching": true,
		"lengthChange":true, 
        "order": [[ 0, "desc" ]]
		
	});
}
