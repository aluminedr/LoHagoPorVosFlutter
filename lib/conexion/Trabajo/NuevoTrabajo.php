<?php
require_once '../Conexion.php';
$idTipoTrabajo= 1;
$idCategoriaTrabajo=$_POST['idCategoriaTrabajo'];
$descripcion=$_POST['descripcion'];
$monto=$_POST['monto'];
$idPersona=$_POST['idPersona'];
print($idPersona);
$eliminado=0;
  
$query="INSERT INTO trabajo(idTipoTrabajo, idCategoriaTrabajo, idPersona, descripcion, monto, created_at, updated_at,eliminado)
	 VALUES ('$idTipoTrabajo','$idCategoriaTrabajo','$idPersona','$descripcion','$monto','2019-09-20 15:50:00','2019-09-20 15:50:00','$eliminado')";
  	$exeQuery = mysqli_query($con, $query) ;

	if($exeQuery) {
		echo (json_encode(array('code' =>1, 'message' => 'Registro exitoso')));
	}else {
		echo(json_encode(array('code' =>2, 'message' => 'Registro fallido')));
 	}


 ?>