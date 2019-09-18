<?php
 require_once 'Connexion.php';


$idTipoTrabajo= 1;
$idCategoriaTrabajo=$_POST['idCategoriaTrabajo'];
$descripcion=$_POST['descripcion'];
$monto=$_POST['monto'];
$eliminado=0;
  
$query="INSERT INTO trabajo(idTipoTrabajo, idCategoriaTrabajo, descripcion, monto, eliminado)
	 VALUES ('$idTipoTrabajo','$idCategoriaTrabajo','$descripcion','$monto','$eliminado')";
  	$exeQuery = mysqli_query($con, $query) ;

	if($exeQuery) {
		echo (json_encode(array('code' =>1, 'message' => 'Registro exitoso')));
	}else {
		echo(json_encode(array('code' =>2, 'message' => 'Registro fallido')));
 	}


 ?>