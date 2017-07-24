<?php if(!defined('SPECIALCONSTANT')) die(json_encode([array('id'=>'0','error'=>'Acceso Denegado')]));

$app->get('/img/:pag',function($pag) use($app) {
	try {
		//sleep(1);
		if( !isset( $pag ) )
			$pag = 1;

		$res = get_todo_paginado( 'img',$pag );

		$app->response->headers->set('Content-type','application/json');
		$app->response->headers->set('Access-Control-Allow-Origin','*');
		$app->response->status(200);
		$app->response->body(json_encode($res));
	}catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));


$app->post("/img/",function() use($app) {
	try {
		$postdata = file_get_contents("php://input");

		$request = json_decode($postdata);
		$request = (array) $request;
		$conex = getConex();
		$res = array( 'err'=>'yes','msj'=>'No se pudo hacer nada' );

		$sql = "CALL pInsertImg(
					'". '' . "',
					'". $request['description'] . "',
					'". $request['img'] . "' );";

		$hecho = $conex->prepare( $sql );
		$hecho->execute();
		$conex = null;

		$res = $hecho->fetchObject();

		$app->response->headers->set('Content-type','application/json');
		$app->response->status(200);
		$app->response->body(json_encode($res));

	}catch(PDOException $e) {
		echo "Error: ".$e->getMessage();
	}
});