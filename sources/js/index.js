function abrir_gritter(titulo,texto, clase){
  $.gritter.add({
      // (string | mandatory) the heading of the notification
      title: titulo,
      // (string | mandatory) the text inside the notification
      text: "<span style='color:white'>"+texto+"</span>",
      class_name: 'gritter gritter-'+clase
  });
} 