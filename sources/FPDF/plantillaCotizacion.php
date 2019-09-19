<?php
 require 'fpdf.php';

 Class PDF extends FPDF{

 	function Header(){
 		//Imagen, SETX,SETY, tamaño
 		$this->Image( $_SERVER['DOCUMENT_ROOT'].'/admin1/sources/images/icons/header.jpg',10,10,185);
 		$this->Ln(15);
 	}
 	/*function Footer(){
			$this->SetY(-15);
			$this->SetFont('Arial','I', 8);
			$this->Cell(0,10, 'Pagina '.$this->PageNo().'/{nb}',0,0,'C' );
 	}*/
 }
?>