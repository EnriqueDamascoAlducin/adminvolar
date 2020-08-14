$("#pais").on("change",function(){
	cargarEstados();
});
function cargarEstados(){
	pais = $("#pais").val();
	if(pais=="") return false;
	var1 = "id_estado as value, nombre_estado as text";
	var2 = "estados_volar";
	var3 = "status<>0 and pais_estado ="+pais;

	parametros ={var1:var1,var2:var2,var3:var3};
	url="controladores/query_json.php";
	$("#estado").html("<option value=''>Seleccione un Estado</option>");
	$.ajax({
		data : parametros,
		url : url,
		dataType : 'json',
		type: 'POST',
		beforeSend:function(){
			abrir_gritter("Espere","Cargando Estado","info");
		},
		success:function(estados){
			$.each(estados,function(index,value){
				valor = value.value;
				texto = value.text;
				sel ="";
				if(estado != "" && estado == valor){
					sel = "selected";
				}else if( valor=="2159"){
					sel ="selected";
				}
				$("#estado").append("<option value='"+valor+"' "+sel+">"+texto+"</option>");
			});

		},
		error:function(jqXHR, textStatus, errorThrown){
			alert("Error");
			console.error(textStatus + "->"+jqXHR+"->"+errorThrown);
		}
	});
}

function enviarForm(){
	if(validarCampos()){
		formulario = $("#clienteForm");
		url = formulario.attr("action");
		type = formulario.attr("method");
		parametros = formulario.serialize();
		$.ajax({
			url:url,
			type:type,
			data:parametros,
			beforeSend:function(){
				abrir_gritter("Alerta","Registrando Cliente","info");
			},
			success:function(respuesta){
				if(respuesta=="error"){
					abrir_gritter("Error","No se pudo registrar al cliente","danger");
				}else{
					abrir_gritter("Exito","Se registro al cliente "+ respuesta, "success");
				}
			},
			error:function(jqXHR, textStatus, errorThrown){
				abrir_gritter("Error",textStatus,"danger");

			}
		});
	}
}
cargarEstados();
