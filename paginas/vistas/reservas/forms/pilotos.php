<?php
foreach ($_POST as $valores) {
  echo "<option>".$valores."</option>";
}

$var1=$_POST['var1'];
$var2=$_POST['var2'];
$var3= $_POST['var3'];
$var4=str_replace("selecciona", "SELECT"," (". $_POST['var4'].")");
?>
