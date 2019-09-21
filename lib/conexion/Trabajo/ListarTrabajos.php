<?php
require_once '../Conexion.php';

$where = "where true";
if (isset($_POST['idCategoriaTrabajo'])){
    $idCategoriaTrabajo = $_POST['idCategoriaTrabajo'];
    $where.=" and idCategoriaTrabajo=".$idCategoriaTrabajo;
}

$consulta = "SELECT * FROM trabajo " . $where;

$resultado = mysqli_query($con,$consulta);

$resultadoConsulta = array();

while ($datos  = mysqli_fetch_assoc($resultado))
{
	$resultadoConsulta[] = $datos;
}

echo json_encode($resultadoConsulta);


?>