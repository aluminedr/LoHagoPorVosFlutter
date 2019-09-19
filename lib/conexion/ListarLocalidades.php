<?php
require_once 'Connexion.php';

$where = "where true";
if (isset($_POST['idProvincia'])){
    $idProvincia = $_POST['idProvincia'];
    $where.=" and idProvincia=".$idProvincia;
}

$consulta = "SELECT * FROM localidad " . $where;

$resultado = mysqli_query($con,$consulta);

$resultadoConsulta = array();

while ($datos  = mysqli_fetch_assoc($resultado))
{
	$resultadoConsulta[] = $datos;
}


echo json_encode($resultadoConsulta);


?>