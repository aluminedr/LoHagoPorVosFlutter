<?php
require_once '../Conexion.php';
$nombreUsuario= 'unNombre';
$mailUsuario=$_POST['mailUsuario'];
$authKey='jfhkjhgfh';
$claveUsuario=$_POST['claveUsuario'];
$idRol=1;
$eliminado=0;
  
$query="INSERT INTO usuario(nombreUsuario, mailUsuario, auth_key, claveUsuario, idRol, eliminado)
	 VALUES ('$nombreUsuario','$mailUsuario','$authKey','$claveUsuario','$idRol','$eliminado')";
  	$exeQuery = mysqli_query($con, $query) ;

	if($exeQuery) {
		echo (json_encode(array('code' =>1, 'message' => 'Registro exitoso')));
	}else {
		echo(json_encode(array('code' =>2, 'message' => 'Registro fallido')));
 	}


 ?>