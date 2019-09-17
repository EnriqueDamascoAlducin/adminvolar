<?php
 require 'fpdf.php';

 Class PDF extends FPDF{

 	function Header(){
 		//Imagen, SETX,SETY, tamaño
 		$this->Image('https://volarenglobo.com.mx/admin1/sources/images/icons/logo.png',5,5,20);
 		$this->SetFont('Arial','B','18');
 		$this->Cell(30);
 		$this->Cell(120,10,utf8_decode('Cotización de Vuelo'),0,0,'C');
 		$this->Image('https://volarenglobo.com.mx/admin1/sources/images/icons/logo.png',180,5,20);
 		$this->Ln(15);
 	}
 	function Footer(){
			$this->SetY(-15);
			$this->SetFont('Arial','I', 8);
			$this->Cell(0,10, 'Pagina '.$this->PageNo().'/{nb}',0,0,'C' );
 	}
 }
?>