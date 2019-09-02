
$("#hotel").on("change",function(){
	if( $(this).val() == 0){
		$("#divDatos").show();
	}else{
		$("#divDatos").hide();
	}
});
