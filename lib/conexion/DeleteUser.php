<?php
 require_once 'Connexion.php';



                                    $idUsuario=$_POST['idUsuario'];
                                   
  
$query="DELETE FROM usuario WHERE idUsuario='$idUsuario'";
  	$exeQuery = mysqli_query($con, $query) ;

	 if($exeQuery){
	 echo (json_encode(array('code' =>1, 'message' => 'Supprime avec succee')));
}else {echo(json_encode(array('code' =>2, 'message' => 'Non Terminer')));
 }


 ?>