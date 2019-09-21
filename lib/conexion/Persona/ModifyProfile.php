<?php
require_once '../Conexion.php';

  $idUsuario=$_POST['idUsuario'];
  $idPersona = $_POST['idPersona'];
  $mailUsuario=$_POST['mailUsuario'];
  $claveUsuario=$_POST['claveUsuario'];
  $nombrePersona = $_POST['nombrePersona'];
  $apellidoPersona =$_POST['apellidoPersona'];
  $dniPersona=$_POST['dniPersona'];
  $idLocalidad=$_POST['idLocalidad'];
  $telefonoPersona =$_POST['telefonoPersona'];
 
 
  
$query="UPDATE usuario SET 
			    mailUsuario='$mailUsuario',
			    claveUsuario='$claveUsuario'
                 
         WHERE idUsuario='$idUsuario'";

$query.="UPDATE persona SET 
          nombrePersona='$nombrePersona',
			    apellidoPersona='$apellidoPersona',
          dniPersona='$dniPersona',
			    idLocalidad='$idLocalidad',
			    telefonoPersona='$telefonoPersona'
                 
				 WHERE idPersona='$idPersona'";

 
   $exeQuery = mysqli_query($con, $query) ;


	 if($exeQuery){
	 echo (json_encode(array('code' =>1, 'message' => 'Modificacion exitosa')));
}else {echo(json_encode(array('code' =>2, 'message' => 'Modificacion fallida')));
 }


 ?>