<!DOCTYPE html>
<?php
  @session_start();
  if(isset($_SESSION['servidor'])){
    $servidor = $_SESSION['servidor'];
    $produccion = $_SESSION['produccion'];
  }

  if(isset($_SESSION['usuario'])){
    session_destroy();
    session_unset();
  }
  $_SESSION['servidor'] = $servidor;
  $_SESSION['produccion'] = $produccion;
 ?>

<html lang="en">
<head>
  <title>Volar en Globo</title>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
<!--===============================================================================================-->  
  <link rel="icon" type="image/png" href="sources/images/icons/logo.png"/>
<!--===============================================================================================-->
  <link rel="stylesheet" type="text/css" href="sources/vendor/bootstrap/css/bootstrap.min.css">
<!--===============================================================================================-->
  <link rel="stylesheet" type="text/css" href="sources/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
<!--===============================================================================================-->
  <link rel="stylesheet" type="text/css" href="sources/fonts/iconic/css/material-design-iconic-font.min.css">
<!--===============================================================================================-->
  <link rel="stylesheet" type="text/css" href="sources/vendor/animate/animate.css">
<!--===============================================================================================-->  
  <link rel="stylesheet" type="text/css" href="sources/vendor/css-hamburgers/hamburgers.min.css">
<!--===============================================================================================-->
  <link rel="stylesheet" type="text/css" href="sources/vendor/animsition/css/animsition.min.css">
<!--===============================================================================================-->
  <link rel="stylesheet" type="text/css" href="sources/vendor/select2/select2.min.css">
<!--===============================================================================================-->  
  <link rel="stylesheet" type="text/css" href="sources/vendor/daterangepicker/daterangepicker.css">
<!--===============================================================================================-->
  <link rel="stylesheet" type="text/css" href="sources/css/util.css">
  <link rel="stylesheet" type="text/css" href="sources/css/main.css">
<!--===============================================================================================-->
  <link rel="stylesheet" type="text/css" href="sources/gritter/css/jquery.gritter.css">
  <link rel="stylesheet" type="text/css" href="sources/gritter/css/clase.css">
<!--===============================================================================================-->

</head>
<body>
  
  
  <div class="container-login100" style="background-image: url('sources/images/fondos/login.png');">
    <div class="wrap-login100 p-l-55 p-r-55 p-t-80 p-b-30" style="opacity: .8;">
      <form class="login100-form validate-form"  onsubmit ="validarSesion(event)" id="loginForm">
        <span class="login100-form-title p-b-37">
          <?php if(!$produccion) { echo "Pruebas de ";} ?>
          Sistema de Administración de Volar en Globo
        </span>

        <div class="wrap-input100 validate-input m-b-20" data-validate="Ingresa tu Usuario">
          <input class="input100" type="text" id="user" name="user" placeholder="Usuario" autofocus="">
          <span class="focus-input100"></span>
        </div>

        <div class="wrap-input100 validate-input m-b-25" data-validate = "Ingresa la Contraseña">
          <input class="input100" type="password" id="pass" name="pass" placeholder="Contraseña">
          <span class="focus-input100"></span>
        </div>

        <div class="container-login100-form-btn">
          <button class="login100-form-btn" type="submit">
            Iniciar Sesión
          </button>
        </div>

        <div class="text-center p-t-57 p-b-20">
          <span class="txt1">
            <hr>
          </span>
        </div>


      </form>

      
    </div>
  </div>
  
  

  <div id="dropDownSelect1"></div>
  
<!--===============================================================================================-->
  <script src="sources/vendor/jquery/jquery-3.2.1.min.js"></script>
<!--===============================================================================================-->
  <script src="sources/vendor/animsition/js/animsition.min.js"></script>
<!--===============================================================================================-->
  <script src="sources/vendor/bootstrap/js/popper.js"></script>
  <script src="sources/vendor/bootstrap/js/bootstrap.min.js"></script>
<!--===============================================================================================-->
  <script src="sources/vendor/select2/select2.min.js"></script>
<!--===============================================================================================-->
  <script src="sources/vendor/daterangepicker/moment.min.js"></script>
  <script src="sources/vendor/daterangepicker/daterangepicker.js"></script>
<!--===============================================================================================-->
  <script src="sources/vendor/countdowntime/countdowntime.js"></script>
<!--===============================================================================================-->
  <script src="sources/js/main.js"></script>

<!--===============================================================================================-->
  <script src="sources/gritter/js/jquery.gritter.js"></script>

  <script type="text/javascript" src="sources/js/login.js"></script>
  <?php 
  if(isset($_GET['s'])){
?>
<script type="text/javascript">
    abrir_gritter("Error","Se ha terminado tu Sesión","danger");
</script>
<?php
  }
?>
</body>
</html>