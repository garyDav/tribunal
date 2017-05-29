<?php if(!defined('SPECIALCONSTANT')) die(json_encode([array('id'=>'0','error'=>'Acceso Denegado')]));

$app->get('/publication/:id/:type',function($id,$type) use($app) {
	try {
		//sleep(1);
		if( isset( $id ) ){
			$pag = $id;
		}else{
			$pag = 1;
		}
		if($type == 'avisos')
			$res = get_publication_paginado_avisos( $pag );
		else
			$res = get_publication_paginado( $pag,$type );

		$app->response->headers->set('Content-type','application/json');
		$app->response->headers->set('Access-Control-Allow-Origin','*');
		$app->response->status(200);
		$app->response->body(json_encode( $res ));
	}catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));


$app->post("/publication/",function() use($app) {
	try {
		$postdata = file_get_contents("php://input");

		$request = json_decode($postdata);
		$request = (array) $request;
		$conex = getConex();
		$res = array( 'err'=>'yes','msj'=>'No se pudo hacer nada' );

		if( isset( $request['id'] )  ){  // UPDATE

			$sql = "UPDATE publication 
						SET
							id_user    = '". $request['id_user'] ."',
							title 	   = '". $request['title'] ."',
							description= '". $request['description'] ."',
							img        = '". $request['img'] ."',
							img        = '". $request['doc'] ."',
							cod        = '". $request['cod'] ."'
					WHERE id=" . $request['id'].";";

			$hecho = $conex->prepare( $sql );
			$hecho->execute();
			$conex = null;
			
			$res = array( 'id'=>$request['id'], 'error'=>'not', 'msj'=>'Registro actualizado' );

		}else{  // INSERT

			$sql = "CALL pInsertPublication(
						'". $request['id_user'] . "',
						'". $request['title'] . "',
						'". $request['description'] . "',
						'". $request['img'] . "',
						'". $request['doc'] . "',
						'". $request['cod'] . "' );";

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

$app->delete('/publication/:id',function($id) use($app) {
	try {
		$conex = getConex();
		$result = $conex->prepare("DELETE FROM publication WHERE id='$id'");

		$result->execute();
		$conex = null;

		$app->response->headers->set('Content-type','application/json');
		$app->response->status(200);
		$app->response->body(json_encode(array('id'=>$id,'error'=>'not','msj'=>'Registro eliminado correctamente.')));

	} catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));

