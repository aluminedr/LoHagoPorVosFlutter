<?php
require_once '../Conexion.php';

$ID=$_GET['ID'];
/*
$query = "SELECT * FROM tb_client where id_client='$ID'";

*/$query="SELECT * FROM usuario WHERE idUsuario='$ID'";

$result = mysqli_query($con,$query);

$array = array();

while ($row  = mysqli_fetch_assoc($result))
{
	$array[] = $row;
}


echo ($result) ?
json_encode(array("code" => 1, "result"=>$array)) :
json_encode(array("code" => 0, "message"=>"Data not found !"));


?>