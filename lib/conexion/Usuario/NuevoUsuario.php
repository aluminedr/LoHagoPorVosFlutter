<?php
require_once '../Conexion.php';
$nombreUsuario= $_POST['nombreUsuario'];
$mailUsuario=$_POST['mailUsuario'];
$authKey='jfhkjhgfh';
$claveUsuario=$_POST['claveUsuario'];
$idRol=1;
$eliminado=0;
  
$query="INSERT INTO usuario(nombreUsuario, mailUsuario, auth_key, claveUsuario, idRol, email_verified_at, remember_token, created_at, updated_at, eliminado)
	 VALUES ('$nombreUsuario','$mailUsuario','$authKey','$claveUsuario','$idRol','2019-09-20 15:50:00','asd','2019-09-20 15:50:00','2019-09-20 15:50:00','$eliminado')";
  	$exeQuery = mysqli_query($con, $query) ;

	if($exeQuery) {
		echo (json_encode(array('code' =>1, 'message' => 'Registro exitoso')));
	}else {
		echo(json_encode(array('code' =>2, 'message' => 'Registro fallido')));
 	}


 ?>