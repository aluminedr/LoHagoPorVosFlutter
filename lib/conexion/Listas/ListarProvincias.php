<?php
require_once '../Conexion.php';

$consulta = "SELECT * FROM provincia";

$resultado = mysqli_query($con,$consulta);

$resultadoConsulta = array();

while ($datos  = mysqli_fetch_assoc($resultado))
{
	$resultadoConsulta[] = $datos;
}


echo json_encode($resultadoConsulta);


?>