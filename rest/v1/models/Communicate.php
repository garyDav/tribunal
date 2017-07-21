<?php if(!defined('SPECIALCONSTANT')) die(json_encode([array('id'=>'0','error'=>'Acceso Denegado')]));

$app->get('/cumple/:tipo',function($tipo) use($app) {
	try {

		$conex = getConex();
		$anio = date('Y');
		$mes = date('m');
		$dia = date('d');

		$result = $conex->prepare("CALL tSelectCumple('$anio','$mes','$dia','$tipo');");

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

$app->post("/communicate/cumple/",function() use($app) {
	try {
		$postdata = file_get_contents("php://input");

		$request = json_decode($postdata);
		$request = (array) $request;
		$conex = getConex();

		$sql = "CALL pInsertCommunicate(
					'". $request['id_use'] . "',
					'". $request['id_usr'] . "',
					'". $request['message'] . "',
					'2' );";

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





$app->get('/communicate/:id/:p',function($id,$p) use($app) {
	try {

		if( isset( $p ) ){
			$pag = $p;
		}else{
			$pag = 1;
		}

		$res = get_paginado_communicate( $id, $pag );

		$app->response->headers->set('Content-type','application/json');
		$app->response->headers->set('Access-Control-Allow-Origin','*');
		$app->response->status(200);
		$app->response->body(json_encode($res));
	}catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));

$app->get('/messages/:ide/:idr',function($ide,$idr) use($app) {
	try {
		$conex = getConex();
		//Sleep(1);

		$result = $conex->prepare("UPDATE communicate SET viewed='1' WHERE id_usr='$idr' AND id_use='$ide';");
		$result->execute();
		$sql = "SELECT c.id,c.message,c.fec,u.src,c.id_use,c.id_usr,per.sex,per.name,per.last_name,u.last_connection FROM communicate c,user u,person per WHERE c.id_use=u.id AND u.id_person=per.id AND (c.viewed='0' OR c.viewed='1') AND (c.id_use='$ide' AND c.id_usr='$idr' OR c.id_use='$idr' AND c.id_usr='$ide');";
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


$app->get('/mensaje/user/:id',function($id) use($app) {
	try {
		$conex = getConex();

		$sql = "SELECT u.id,per.name,per.last_name FROM user u,person per WHERE u.id_person=per.id AND u.id<>'$id';";
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

		$sql = "CALL pInsertCommunicate(
					'". $request['id_use'] . "',
					'". $request['id_usr'] . "',
					'". $request['message'] . "',
					'0' );";

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

