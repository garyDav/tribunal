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

		$sql = "SELECT 'Algo anda mal' name;";
		foreach ($res['publication'] as $valor) {
			$cod = $valor->cod;
			if( $cod == 'T-0000' )
				$valor->destinatario = 'Todos los usuarios';
			else {
				$conex = getConex();
				if( !(strpos($cod, 'D-') === false) ) {
					$sql = "SELECT name FROM department WHERE cod_dep='$cod';";
				}
				if( !(strpos($cod, 'JA-') === false) )
					$sql = "SELECT name FROM j_agroambiental WHERE cod_ja='$cod';";
				$result = $conex->prepare( $sql );
				$result->execute();
				$valor->destinatario = $result->fetchObject()->name;
				//$valor->destinatario = $sql;
			}
		}

		$app->response->headers->set('Content-type','application/json');
		$app->response->headers->set('Access-Control-Allow-Origin','*');
		$app->response->status(200);
		$app->response->body(json_encode( $res ));
	}catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));

$app->get('/publication/reverse/:pag/:type',function($pag,$type) use($app) {
	try {
		sleep(1);
		if( isset( $pag ) )
			$pag = $pag;
		else
		$pag = 1;

		$res = get_publication_paginado_reverse( $pag,$type );

		foreach ($res['publication'] as $valor) {
			$conex = getConex();
			$idPub = $valor->id;
			$sql = "SELECT c.id,c.description,c.fec,per.name,per.last_name,per.sex,u.src FROM comment c,publication p,user u,person per WHERE c.id_publication=p.id AND c.id_user=u.id AND u.id_person=per.id AND c.id_publication='$idPub';";
			$result = $conex->prepare( $sql );
			$result->execute();
			$valor->comentarios = $result->fetchAll(PDO::FETCH_OBJ);
			//$valor->comentarios = 'putaMarta';
		}
		$conex = null;

		/*$sql = "SELECT 'Algo anda mal' name;";
		foreach ($res['publication'] as $valor) {
			$cod = $valor->cod;
			if( $cod == 'T-0000' )
				$valor->destinatario = 'Todos los usuarios';
			else {
				$conex = getConex();
				if( !(strpos($cod, 'D-') === false) ) {
					$sql = "SELECT name FROM department WHERE cod_dep='$cod';";
				}
				if( !(strpos($cod, 'JA-') === false) )
					$sql = "SELECT name FROM j_agroambiental WHERE cod_ja='$cod';";
				$result = $conex->prepare( $sql );
				$result->execute();
				$valor->destinatario = $result->fetchObject()->name;
				//$valor->destinatario = $sql;
			}
		}*/

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
		if( $request['img'] == null )
			$request['img'] =  '';
		if( $request['cod'] == null )
			$request['cod'] =  '';
		

		if( isset( $request['id'] ) ){  // UPDATE

			$sql = "UPDATE publication 
						SET
							id_user    = '". $request['id_user'] ."',
							title 	   = '". $request['title'] ."',
							description= '". $request['description'] ."',
							type	   = '". $request['type'] ."',
							img        = '". $request['img'] ."',
							doc        = '". $request['doc'] ."',
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
						'". $request['type'] . "',
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

