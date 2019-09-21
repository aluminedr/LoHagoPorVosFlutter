<?php
require_once '../Conexion.php';
$mailUsuario=$_POST['mailUsuario'];
$claveUsuario=$_POST['claveUsuario'];


$consulta = "SELECT * FROM usuario where mailUsuario='$mailUsuario' and claveUsuario='$claveUsuario'";

$resultado = mysqli_query($con,$consulta);

$resultadoConsulta = array();

while ($datos  = mysqli_fetch_assoc($resultado))
{
	$resultadoConsulta[] = $datos;
}


echo json_encode($resultadoConsulta);


?>