<?php if(!defined('SPECIALCONSTANT')) die(json_encode([array('id'=>'0','error'=>'Acceso Denegado')]));

$app->get('/communicate/:id',function($id) use($app) {
	try {
		$conex = getConex();

		$sql = "SELECT c.message,c.fec,per.name,per.last_name FROM communicate c,user u,person per WHERE c.id_use=u.id AND c.id_usr=u.id AND u.id_person=per.id AND c.id_usr='$id';";
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

$app->post("/communicate/",function() use($app) {
	try {
		$postdata = file_get_contents("php://input");

		$request = json_decode($postdata);
		$request = (array) $request;
		$conex = getConex();
		$res = array( 'err'=>'yes','msj'=>'Puta no se pudo hacer nada, revisa mierda' );

		if( isset( $request['id'] )  ){  // ACTUALIZAR

			$sql = "UPDATE communicate 
						SET
							id_use  		  = '". $request['id_use'] ."',
							id_usr 	   	  = '". $request['id_usr'] ."',
							message          = '". $request['message'] ."'
					WHERE id=" . $request['id'].";";

			$hecho = $conex->prepare( $sql );
			$hecho->execute();
			$conex = null;
			
			$res = array( 'id'=>$request['id'], 'error'=>'not', 'msj'=>'Registro actualizado' );

		}else{  // INSERT

			$sql = "CALL pInsertCommunicate(
						'". $request['id_use'] . "',
						'". $request['id_usr'] . "',
						'". $request['message'] . "' );";

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

$app->delete('/communicate/:id',function($id) use($app) {
	try {
		$conex = getConex();
		$result = $conex->prepare("DELETE FROM communicate WHERE id='$id'");

		$result->execute();
		$conex = null;

		$app->response->headers->set('Content-type','application/json');
		$app->response->status(200);
		$app->response->body(json_encode(array('id'=>$id,'error'=>'not','msj'=>'Registro eliminado correctamente.')));

	} catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));

