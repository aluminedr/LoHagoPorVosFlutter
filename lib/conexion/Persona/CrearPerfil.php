<?php
require_once '../Conexion.php';


$nombrePersona= $_POST['nombrePersona'];
$apellidoPersona=$_POST['apellidoPersona'];
$dniPersona=$_POST['dniPersona'];
$telefonoPersona=$_POST['telefonoPersona'];
$idLocalidad=$_POST['idLocalidad'];
$imagenPersona='jaj';
$idUsuario=$_POST['idUsuario'];
$eliminado=0;
  
$query="INSERT INTO persona(nombrePersona, apellidoPersona, dniPersona, telefonoPersona, idLocalidad, imagenPersona, idUsuario, eliminado)
	 VALUES ('$nombrePersona','$apellidoPersona','$dniPersona','$telefonoPersona','$idLocalidad','$imagenPersona','$idUsuario','$eliminado')";
  	$exeQuery = mysqli_query($con, $query) ;

	if($exeQuery) {
		echo (json_encode(array('code' =>1, 'message' => 'Registro exitoso')));
	}else {
		echo(json_encode(array('code' =>2, 'message' => 'Registro fallido')));
 	}


 ?>