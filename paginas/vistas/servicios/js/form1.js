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

         		abrir_gritter("Correcto",response ,"info");
			}else{

         		abrir_gritter("Error","Error al registrar su servicio" ,"danger");
			}
		}
	});
	e.preventDefault();
}
$("#imagen").on("change",function(e){
	
	var data = e.originalEvent.target.files[0];
    if(data.size<1258291){
		validarImagen(this);
	}else{
		abrir_gritter("Alerta","No puedes cargar un archivo mayor a un mega","warning");
		$(this).val('');
      	$('form img').attr('src', "../sources/images/globos/noimage.png");
		return false;
	}
});
function validarImagen(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    
    reader.onload = function(e) {
      $('form img').attr('src', e.target.result);
    }
    
    reader.readAsDataURL(input.files[0]);
  }
}