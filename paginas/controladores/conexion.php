<?php
	Class Conexion{
		private $servidor;
		private $bd ;
		private $usr;
		private $pass;
		public $con;

		function Conexion(){
			$this->servidor="localhost";
			$this->bd = "volar";
			$this->usr="Siswebs";
			$this->pass="Portero1";

		}

		function conectar(){
			$this->con = new PDO("mysql:host=$this->servidor;dbname=$this->bd", $this->usr, $this->pass);
			if($this->con){
				return "Conectado";
			}else{
				return "Error";
			}
		}
		function consulta($campos,$tabla,$filtro=""){
			$where = "";
			if($filtro!=""){
				$where = " Where ".$filtro;
			}
			$sql= "Select ". $campos ." From ". $tabla ."". $where;
			$data= $this->con->query($sql)->fetchALL (PDO::FETCH_OBJ);
			return $data;
		}
		function insertar($tabla, $campos, $valores){
			$sql="INSERT INTO $tabla ($campos) VALUES ($valores)";
			$data= $this->con->query($sql);
			if($data){
				return "ok";
			}else{
				return "error";
			}
		}
		function actualizar($tabla, $set, $filtro){
			if($filtro==""){
				$where="";
			}else{
				$where = " WHERE $filtro ";
			}
			$sql="UPDATE $tabla SET $set $where";
			
			$data= $this->con->query($sql);
			if($data){
				return "ok";
			}else{
				return "falla";
			}
		}
		function query($sql){
			$data= $this->con->query($sql);
			return $data;
		}

	}
	$con=new Conexion();
	$con->conectar();
?>
