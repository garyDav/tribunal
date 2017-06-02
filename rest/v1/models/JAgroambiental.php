<?php if(!defined('SPECIALCONSTANT')) die(json_encode([array('id'=>'0','error'=>'Acceso Denegado')]));

$app->get('/j_agroambiental/',function() use($app) {
	try {
		
		$conex = getConex();

		$sql = "SELECT * FROM j_agroambiental;";
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

$app->get('/department/j_agroambiental/',function() use($app) {
	try {
		
		$conex = getConex();

		$sql = "SELECT id,name,cod_dep,'' ja FROM department;";
		$result = $conex->prepare( $sql );

		$result->execute();

		$dep = $result->fetchAll(PDO::FETCH_OBJ);
		foreach ($dep as $valor) {
			$idDep = $valor->id;
			$sql = "SELECT ja.name,ja.cod_ja FROM j_agroambiental ja,municipality m,department d,province pr WHERE ja.id_municipality=m.id AND m.id_province=pr.id AND pr.id_department=d.id AND d.id='$idDep';";
			$result = $conex->prepare( $sql );
			$result->execute();
			$valor->ja = $result->fetchAll(PDO::FETCH_OBJ);
		}
		$conex = null;

		$app->response->headers->set('Content-type','application/json');
		$app->response->headers->set('Access-Control-Allow-Origin','*');
		$app->response->status(200);
		$app->response->body(json_encode($dep));

	}catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));

$app->get('/j_agroambiental/:id',function($id) use($app) {
	try {
		//sleep(1);
		if( isset( $id ) ){
			$pag = $id;
		}else{
			$pag = 1;
		}
		$res = get_todo_paginado( 'j_agroambiental', $pag );

		$app->response->headers->set('Content-type','application/json');
		$app->response->headers->set('Access-Control-Allow-Origin','*');
		$app->response->status(200);
		$app->response->body(json_encode($res));
	}catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));

$app->post("/j_agroambiental/",function() use($app) {
	try {
		$postdata = file_get_contents("php://input");

		$request = json_decode($postdata);
		$request = (array) $request;
		$conex = getConex();
		$res = array( 'err'=>'yes','msj'=>'Puta no se pudo hacer nada, revisa mierda' );

		if( isset( $request['id'] )  ){  // ACTUALIZAR

			$sql = "UPDATE j_agroambiental 
						SET
							id_municipality= '". $request['id_municipality'] ."',
							name 	   	   = '". $request['name'] ."',
							cod_ja         = '". $request['cod_ja'] ."'
					WHERE id=" . $request['id'].";";

			$hecho = $conex->prepare( $sql );
			$hecho->execute();
			$conex = null;
			
			$res = array( 'id'=>$request['id'], 'error'=>'not', 'msj'=>'Registro actualizado' );

		}else{  // INSERT

			$salt = '#/$02.06$/#_#/$25.10$/#';
			$pwd = md5($salt.$request['pwd']);
			$pwd = sha1($salt.$pwd);

			$sql = "CALL pInsertJAgroambiental(
						'". $request['id_municipality'] . "',
						'". $request['name'] . "',
						'". $request['cod_ja'] . "' );";

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

$app->delete('/j_agroambiental/:id',function($id) use($app) {
	try {
		$conex = getConex();
		$result = $conex->prepare("DELETE FROM j_agroambiental WHERE id='$id'");

		$result->execute();
		$conex = null;

		$app->response->headers->set('Content-type','application/json');
		$app->response->status(200);
		$app->response->body(json_encode(array('id'=>$id,'error'=>'not','msj'=>'Registro eliminado correctamente.')));

	} catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));

