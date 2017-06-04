<?php if(!defined('SPECIALCONSTANT')) die(json_encode([array('id'=>'0','error'=>'Acceso Denegado')]));

$app->get('/comment/:id',function($id) use($app) {
	try {
		$conex = getConex();

		$sql = "SELECT c.description,c.fec,per.name,per.last_name FROM comment c,user u,person per WHERE c.id_user=u.id AND u.id_person=per.id AND c.id_publication='$id';";
		$result = $conex->prepare( $sql );

		$result->execute();
		$conex = null;

		$res = $result->fetchAll(PDO::FETCH_OBJ);

		$app->response->headers->set('Content-type','application/json');
		$app->response->headers->set('Access-Control-Allow-Origin','*');
		$app->response->status(200);
		$app->response->body(json_encode($res));
	}catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));

$app->post("/comment/",function() use($app) {
	try {
		$postdata = file_get_contents("php://input");

		$request = json_decode($postdata);
		$request = (array) $request;
		$conex = getConex();
		$res = array( 'err'=>'yes','msj'=>'No se pudo hacer nada.' );

		if( isset( $request['id'] )  ){  // ACTUALIZAR

			$sql = "UPDATE comment 
						SET
							id_publication = '". $request['id_publication'] ."',
							id_user 	   = '". $request['id_user'] ."',
							description    = '". $request['description'] ."'
					WHERE id=" . $request['id'].";";

			$hecho = $conex->prepare( $sql );
			$hecho->execute();
			$conex = null;
			
			$res = array( 'id'=>$request['id'], 'error'=>'not', 'msj'=>'Registro actualizado' );

		}else{  // INSERT

			$sql = "CALL pInsertComment(
						'". $request['id_publication'] . "',
						'". $request['id_user'] . "',
						'". $request['description'] . "' );";

			$hecho = $conex->prepare( $sql );
			$hecho->execute();
			$conex = null;

			$res = $hecho->fetchObject();

		}

		$app->response->headers->set('Content-type','application/json');
		$app->response->status(200);
		$app->response->body(json_encode($res));

	}catch(PDOException $e) {
		echo "Error: ".$e->getMessage();
	}
});

$app->delete('/comment/:id',function($id) use($app) {
	try {
		$conex = getConex();
		$result = $conex->prepare("DELETE FROM comment WHERE id='$id'");

		$result->execute();
		$conex = null;

		$app->response->headers->set('Content-type','application/json');
		$app->response->status(200);
		$app->response->body(json_encode(array('id'=>$id,'error'=>'not','msj'=>'Registro eliminado correctamente.')));

	} catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));

