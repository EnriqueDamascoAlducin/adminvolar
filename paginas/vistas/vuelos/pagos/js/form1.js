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
