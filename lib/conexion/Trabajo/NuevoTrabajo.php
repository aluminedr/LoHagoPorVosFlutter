<?php
require_once '../Conexion.php';
$idTipoTrabajo= 1;
$idCategoriaTrabajo=$_POST['idCategoriaTrabajo'];
$titulo=$_POST['titulo'];
$descripcion=$_POST['descripcion'];
$monto=$_POST['monto'];
$idPersona=$_POST['idPersona'];
$dateNow = date("Y-m-d H:i:s");
$eliminado=0;
  
$query="INSERT INTO trabajo(idTipoTrabajo, idCategoriaTrabajo, idPersona, titulo, descripcion, monto, created_at, updated_at,eliminado)
	 VALUES ('$idTipoTrabajo','$idCategoriaTrabajo','$idPersona','$titulo','$descripcion','$monto','$dateNow','$dateNow','$eliminado')";
  	$exeQuery = mysqli_query($con, $query) ;

	if($exeQuery) {
		echo (json_encode(array('code' =>1, 'message' => 'Registro exitoso')));
	}else {
		echo(json_encode(array('code' =>2, 'message' => 'Registro fallido')));
 	}


 ?>