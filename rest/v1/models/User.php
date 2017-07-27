<?php if(!defined('SPECIALCONSTANT')) die(json_encode([array('id'=>'0','error'=>'Acceso Denegado')]));

$app->get('/department/',function() use($app) {
	try {
		$conex = getConex();

		$sql = "SELECT * FROM department;";
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

$app->get('/user/:id',function($id) use($app) {
	try {
		//sleep(1);
		if( isset( $id ) ){
			$pag = $id;
		}else{
			$pag = 1;
		}
		$res = get_paginado_user( $pag );

		$app->response->headers->set('Content-type','application/json');
		$app->response->headers->set('Access-Control-Allow-Origin','*');
		$app->response->status(200);
		$app->response->body(json_encode($res));
	}catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));

$app->get('/user/view/:id',function($id) use($app) {
	try {
		$conex = getConex();

		$sql = "SELECT per.ci,per.ex,per.name,per.last_name,per.fec_nac,per.sex,u.id,u.id_person,u.id_jagroambiental,u.email,u.cellphone,u.src,u.registered,u.cod_dep,u.cod_ja,u.cod_all,'' pwdA,'' pwdN,'' pwdR FROM user u,person per WHERE u.id_person=per.id AND u.id='$id';";
		$result = $conex->prepare( $sql );

		$result->execute();
		$conex = null;

		$res = $result->fetchObject();

		$app->response->headers->set('Content-type','application/json');
		$app->response->headers->set('Access-Control-Allow-Origin','*');
		$app->response->status(200);
		$app->response->body(json_encode($res));
	}catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));

$app->post("/user/",function() use($app) {
	try {
		$postdata = file_get_contents("php://input");

		$request = json_decode($postdata);
		$request = (array) $request;
		$conex = getConex();
		$res = array( 'err'=>'yes','msj'=>'Revisa' );
		
		$salt = '#/$02.06$/#_#/$25.10$/#';
		$pwd = md5($salt.$request['pwd']);
		$pwd = sha1($salt.$pwd);

		if( isset( $request['id'] )  ){  // ACTUALIZAR

			$sql = "UPDATE user 
						SET
							email  		  = '". $request['email'] ."',
							position      = '". $request['position'] ."',
							pwd 	   	  = '". $pwd ."',
							type  		  = '". $request['type'] ."',
							cellphone     = '". $request['cellphone'] ."',
							status 		  = '". $request['status'] ."'
					WHERE id=" . $request['id'].";";

			$hecho = $conex->prepare( $sql );
			$hecho->execute();
			$conex = null;
			
			$res = array( 'id'=>$request['id'], 'error'=>'not', 'msj'=>'Usuario actualizado' );

		}else{  // INSERT
			$cod_ja = $request['cod_ja'];
			$sql = "SELECT dep.cod_dep FROM j_agroambiental j,municipality mu,province pr,department dep WHERE 	j.id_municipality=mu.id AND mu.id_province=pr.id AND pr.id_department=dep.id AND j.cod_ja='$cod_ja';";
			$hecho = $conex->prepare( $sql );
			$hecho->execute();
			$cod_dep = $hecho->fetchObject()->cod_dep;

			$sql = "CALL pInsertUser(
						'". $request['id_person'] . "',
						'". $request['id_jagroambiental'] . "',
						'". $request['email'] . "',
						'". $request['position'] . "',
						'". $pwd . "',
						'". 'user' . "',
						'". $request['cellphone'] . "',
						'". $cod_dep . "',
						'". $request['cod_ja'] . "',
						'". 'T-0000' . "' );";

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

$app->put("/user/:id",function($id) use($app) {
	$jsonmessage = \Slim\Slim::getInstance()->request();
  	$objDatos = json_decode($jsonmessage->getBody());

	$email = $objDatos->email;
	$cellphone = $objDatos->cellphone;
	$pwdA = $objDatos->pwdA;
	$pwdN = $objDatos->pwdN;
	$pwdR = $objDatos->pwdR;
	$src = $objDatos->src;

	if( $pwdA == null )
		$pwdA = '';
	if( $src == null )
		$src = '';

	if( $pwdA && $pwdN && $pwdR ) {
		$salt = '#/$02.06$/#_#/$25.10$/#';
		$pwdA = md5($salt.$pwdA);
		$pwdA = sha1($salt.$pwdA);

		$pwdN = md5($salt.$pwdN);
		$pwdN = sha1($salt.$pwdN);

		$pwdR = md5($salt.$pwdR);
		$pwdR = sha1($salt.$pwdR);
	}

	try {
		$conex = getConex();
		$result = $conex->prepare("CALL pUpdateUser('$id','$email','$cellphone','$pwdA','$pwdN','$pwdR','$src');");

		$result->execute();
		$conex = null;
		$res = $result->fetchObject();

		$app->response->headers->set('Content-type','application/json');
		$app->response->status(200);
		$app->response->body(json_encode($res));

	}catch(PDOException $e) {
		echo "Error: ".$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));

$app->delete('/user/:id',function($id) use($app) {
	try {
		$conex = getConex();
		$result = $conex->prepare("UPDATE user SET status='baja' WHERE id='$id'");

		$result->execute();
		$conex = null;

		$app->response->headers->set('Content-type','application/json');
		$app->response->status(200);
		$app->response->body(json_encode(array('id'=>$id,'error'=>'not','msj'=>'Se dio de baja al usuario correctamente.')));

	} catch(PDOException $e) {
		echo 'Error: '.$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));


$app->post("/login/",function() use($app) {
	$objDatos = json_decode(file_get_contents("php://input"));

	$correo = $objDatos->email;
	$contra = $objDatos->pwd;
	//sleep(3);

	try {
		$conex = getConex();

		$salt = '#/$02.06$/#_#/$25.10$/#';
		$contra = md5($salt.$contra);
		$contra = sha1($salt.$contra);

		$result = $conex->prepare("CALL pSession('$correo','$contra');");

		$result->execute();
		$res = $result->fetchObject();
		if($res->error == 'not'){
			$_SESSION['uid'] = uniqid('ang_');
			$_SESSION['userID'] = $res->id;
			$_SESSION['userTYPE'] = $res->type;
		}

		$conex = null;

		$app->response->headers->set("Content-type","application/json");
		$app->response->headers->set('Access-Control-Allow-Origin','*');
		$app->response->status(200);
		$app->response->body(json_encode($res));
	}catch(PDOException $e) {
		echo "Error: ".$e->getMessage();
	}
});






$app->put("/user/connection/:id",function($id) use($app) {
	try {
		$conex = getConex();
		$fec_actual = date("Y-m-d H:i:s");
		$sql = "UPDATE user SET last_connection='$fec_actual' WHERE id='$id';";
		$result = $conex->prepare($sql);

		$result->execute();
		$conex = null;
		$res = array('error'=>'not','msj'=>'ultima conexion actualizado');

		$app->response->headers->set('Content-type','application/json');
		$app->response->status(200);
		$app->response->body(json_encode($res));

	}catch(PDOException $e) {
		echo "Error: ".$e->getMessage();
	}
})->conditions(array('id'=>'[0-9]{1,11}'));
