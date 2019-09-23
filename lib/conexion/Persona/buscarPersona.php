<?php
require_once '../Conexion.php';
$idUsuario=$_POST['idUsuario'];
$query="SELECT * FROM persona WHERE idUsuario='$idUsuario'";

$result = mysqli_query($con,$query);

$array = array();

while ($row  = mysqli_fetch_assoc($result))
{
	$array[] = $row;
}

echo json_encode($array);


?>