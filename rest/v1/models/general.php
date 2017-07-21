<?php if(!defined("SPECIALCONSTANT")) die(json_encode([array("id"=>"0","nombre"=>"Acceso Denegado")]));


// ================================================
//   Funcion que pagina cualquier TABLA
// ================================================
function get_todo_paginado( $tabla, $pagina = 1, $por_pagina = 10 ){

	$conex = getConex();

	$sql = "SELECT count(*) as cuantos from $tabla";

	$result = $conex->prepare($sql);
	$result->execute();
	$res = $result->fetchObject();
	$cuantos = $res->cuantos;


	$total_paginas = ceil( $cuantos / $por_pagina );

	if( $pagina > $total_paginas ){
		$pagina = $total_paginas;
	}


	$pagina -= 1;  // 0
	$desde   = $pagina * $por_pagina; // 0 * 20 = 0
	if( $desde < 0 )
		$desde = 0;

	if( $pagina >= $total_paginas-1 ){
		$pag_siguiente = 1;
	}else{
		$pag_siguiente = $pagina + 2;
	}

	if( $pagina < 1 ){
		$pag_anterior = $total_paginas;
	}else{
		$pag_anterior = $pagina;
	}


	$sql = "SELECT * from $tabla limit $desde, $por_pagina";
	$result = $conex->prepare($sql);
	$result->execute();
	$datos = $result->fetchAll(PDO::FETCH_OBJ);

	$arrPaginas = array();
	for ($i=0; $i < $total_paginas; $i++) { 
		array_push($arrPaginas, $i+1);
	}


	$respuesta = array(
			'err'     		=> false, 
			'conteo' 		=> $cuantos,
			$tabla 			=> $datos,
			'pag_actual'    => ($pagina+1),
			'pag_siguiente' => $pag_siguiente,
			'pag_anterior'  => $pag_anterior,
			'total_paginas' => $total_paginas,
			'paginas'	    => $arrPaginas
			);


	return  $respuesta;

}

function get_paginado_communicate( $id, $pagina = 1, $por_pagina = 8 ){

	$conex = getConex();

	$sql = "SELECT count(*) as cuantos FROM communicate c,user u,person per WHERE c.id_use=u.id AND u.id_person=per.id AND c.id_usr='$id' AND (c.viewed='0' OR c.viewed='1') GROUP BY u.id DESC;";

	$result = $conex->prepare($sql);
	$result->execute();
	$res = $result->fetchObject();
	if( !$res )
		$cuantos = 0;
	else
		$cuantos = $res->cuantos;


	$total_paginas = ceil( $cuantos / $por_pagina );

	if( $pagina > $total_paginas ){
		$pagina = $total_paginas;
	}


	$pagina -= 1;  // 0
	$desde   = $pagina * $por_pagina; // 0 * 20 = 0
	if( $desde < 0 )
		$desde = 0;

	if( $pagina >= $total_paginas-1 ){
		$pag_siguiente = 1;
	}else{
		$pag_siguiente = $pagina + 2;
	}

	if( $pagina < 1 ){
		$pag_anterior = $total_paginas;
	}else{
		$pag_anterior = $pagina;
	}


	$sql = "SELECT DISTINCT
  				u.id,per.name,per.last_name,per.sex,u.src,u.last_connection,
  				(SELECT message FROM communicate WHERE id_use=u.id AND id_usr='$id' ORDER BY id DESC LIMIT 1) message,
  				(SELECT fec FROM communicate WHERE id_use=u.id AND id_usr='$id' ORDER BY id DESC LIMIT 1) fec,
  				(SELECT viewed FROM communicate WHERE id_use=u.id AND id_usr='$id' ORDER BY id DESC LIMIT 1) viewed
			FROM communicate c,user u,person per 
 				WHERE c.id_use=u.id AND u.id_person=per.id AND c.id_use<>'$id' AND id_usr='$id' AND (c.viewed='0' OR c.viewed='1') ORDER BY c.id DESC limit $desde, $por_pagina;";
	$result = $conex->prepare($sql);
	$result->execute();
	$datos = $result->fetchAll(PDO::FETCH_OBJ);

	$arrPaginas = array();
	for ($i=0; $i < $total_paginas; $i++) { 
		array_push($arrPaginas, $i+1);
	}


	$respuesta = array(
			'err'     		=> false, 
			'conteo' 		=> $cuantos,
			'communicate' 	=> $datos,
			'pag_actual'    => ($pagina+1),
			'pag_siguiente' => $pag_siguiente,
			'pag_anterior'  => $pag_anterior,
			'total_paginas' => $total_paginas,
			'paginas'	    => $arrPaginas
			);


	return  $respuesta;

}

function get_paginado_user( $pagina = 1, $por_pagina = 20 ){

	$conex = getConex();

	$sql = "SELECT count(*) as cuantos from person p,user u WHERE u.id_person=p.id;";

	$result = $conex->prepare($sql);
	$result->execute();
	$res = $result->fetchObject();
	$cuantos = $res->cuantos;


	$total_paginas = ceil( $cuantos / $por_pagina );

	if( $pagina > $total_paginas ){
		$pagina = $total_paginas;
	}


	$pagina -= 1;  // 0
	$desde   = $pagina * $por_pagina; // 0 * 20 = 0
	if( $desde < 0 )
		$desde = 0;

	if( $pagina >= $total_paginas-1 ){
		$pag_siguiente = 1;
	}else{
		$pag_siguiente = $pagina + 2;
	}

	if( $pagina < 1 ){
		$pag_anterior = $total_paginas;
	}else{
		$pag_anterior = $pagina;
	}


	$sql = "SELECT * from person p,user u WHERE u.id_person=p.id limit $desde, $por_pagina";
	$result = $conex->prepare($sql);
	$result->execute();
	$datos = $result->fetchAll(PDO::FETCH_OBJ);

	$arrPaginas = array();
	for ($i=0; $i < $total_paginas; $i++) { 
		array_push($arrPaginas, $i+1);
	}


	$respuesta = array(
			'err'     		=> false, 
			'conteo' 		=> $cuantos,
			'user' 			=> $datos,
			'pag_actual'    => ($pagina+1),
			'pag_siguiente' => $pag_siguiente,
			'pag_anterior'  => $pag_anterior,
			'total_paginas' => $total_paginas,
			'paginas'	    => $arrPaginas
			);


	return  $respuesta;

}

function get_publication_paginado_reverse( $pagina = 1, $type , $idUser , $por_pagina = 7 ){

	$conex = getConex();

	//$sql = "SELECT count(*) as cuantos FROM publication p,user u WHERE (p.id_user=u.id) AND (u.cod_dep=p.cod OR u.cod_ja=p.cod OR u.cod_all=p.cod);";
	//Obteniendo codigos del user logueado
	$sql = "SELECT cod_dep,cod_ja,cod_all FROM user WHERE id='$idUser';";

	$result = $conex->prepare($sql);
	$result->execute();
	$res = $result->fetchObject();

	$cod_dep = $res->cod_dep;
	$cod_ja  = $res->cod_ja;
	$cod_all = $res->cod_all;

	if ( $type == 'noticias_efemerides' ) {
		$sql = "SELECT count(*) as cuantos FROM publication p,user u WHERE p.id_user=u.id AND (p.type='noticia' OR p.type='efemerides') AND (p.cod='$cod_dep' OR p.cod='$cod_ja' OR p.cod='$cod_all');";
	} else {
		$sql = "SELECT count(*) as cuantos FROM publication p,user u WHERE p.id_user=u.id AND p.type='$type' AND (p.cod='$cod_dep' OR p.cod='$cod_ja' OR p.cod='$cod_all');";
	}

	$result = $conex->prepare($sql);
	$result->execute();
	$res = $result->fetchObject();
	$cuantos = $res->cuantos;


	$total_paginas = ceil( $cuantos / $por_pagina );

	if( $pagina > $total_paginas ){
		$pagina = $total_paginas;
	}


	$pagina -= 1;  // 0
	$desde   = $pagina * $por_pagina; // 0 * 20 = 0
	if( $desde < 0 )
		$desde = 0;

	if( $pagina >= $total_paginas-1 ){
		$pag_siguiente = 1;
	}else{
		$pag_siguiente = $pagina + 2;
	}

	if( $pagina < 1 ){
		$pag_anterior = $total_paginas;
	}else{
		$pag_anterior = $pagina;
	}

	if ( $type == 'noticias_efemerides' ) {
		$sql = "SELECT p.id,p.title,p.description,p.fec,p.img,p.doc,p.cod,'' destinatario,'' comentarios,u.email,u.position,u.src,u.cellphone,u.type userType,ja.name AS ja_name,per.name,per.last_name,per.sex FROM publication p,user u,person per,j_agroambiental ja WHERE p.id_user=u.id AND u.id_person=per.id AND u.id_jagroambiental=ja.id AND (p.type='noticia' OR p.type='efemerides') AND (p.cod='$cod_dep' OR p.cod='$cod_ja' OR p.cod='$cod_all') ORDER BY p.id DESC limit $desde, $por_pagina;";
	} else {
		$sql = "SELECT p.id,p.title,p.description,p.fec,p.img,p.doc,p.cod,'' destinatario,'' comentarios,u.email,u.position,u.src,u.cellphone,u.type userType,ja.name AS ja_name,per.name,per.last_name,per.sex FROM publication p,user u,person per,j_agroambiental ja WHERE p.id_user=u.id AND u.id_person=per.id AND u.id_jagroambiental=ja.id AND p.type='$type' AND (p.cod='$cod_dep' OR p.cod='$cod_ja' OR p.cod='$cod_all') ORDER BY p.id DESC limit $desde, $por_pagina;";
	}
	$result = $conex->prepare($sql);
	$result->execute();
	$datos = $result->fetchAll(PDO::FETCH_OBJ);

	$arrPaginas = array();
	for ($i=0; $i < $total_paginas; $i++) { 
		array_push($arrPaginas, $i+1);
	}


	$respuesta = array(
			'err'     		=> false, 
			'conteo' 		=> $cuantos,
			'publication' 	=> $datos,
			'pag_actual'    => ($pagina+1),
			'pag_siguiente' => $pag_siguiente,
			'pag_anterior'  => $pag_anterior,
			'total_paginas' => $total_paginas,
			'paginas'	    => $arrPaginas
			);


	return  $respuesta;

}

function get_publication_paginado( $pagina = 1, $type = 'avisos' , $por_pagina = 20 ){

	$conex = getConex();

	//$sql = "SELECT count(*) as cuantos FROM publication p,user u WHERE (p.id_user=u.id) AND (u.cod_dep=p.cod OR u.cod_ja=p.cod OR u.cod_all=p.cod);";
	$sql = "SELECT count(*) as cuantos FROM publication p,user u WHERE p.id_user=u.id AND p.type='$type';";

	$result = $conex->prepare($sql);
	$result->execute();
	$res = $result->fetchObject();
	$cuantos = $res->cuantos;


	$total_paginas = ceil( $cuantos / $por_pagina );

	if( $pagina > $total_paginas ){
		$pagina = $total_paginas;
	}


	$pagina -= 1;  // 0
	$desde   = $pagina * $por_pagina; // 0 * 20 = 0
	if( $desde < 0 )
		$desde = 0;

	if( $pagina >= $total_paginas-1 ){
		$pag_siguiente = 1;
	}else{
		$pag_siguiente = $pagina + 2;
	}

	if( $pagina < 1 ){
		$pag_anterior = $total_paginas;
	}else{
		$pag_anterior = $pagina;
	}


	$sql = "SELECT p.id,p.title,p.description,p.fec,p.img,p.doc,p.cod,'' destinatario,u.email,u.position,u.cellphone,u.type userType,ja.name AS ja_name,per.name,per.last_name FROM publication p,user u,person per,j_agroambiental ja WHERE p.id_user=u.id AND u.id_person=per.id AND u.id_jagroambiental=ja.id AND p.type='$type' limit $desde, $por_pagina;";
	$result = $conex->prepare($sql);
	$result->execute();
	$datos = $result->fetchAll(PDO::FETCH_OBJ);

	$arrPaginas = array();
	for ($i=0; $i < $total_paginas; $i++) { 
		array_push($arrPaginas, $i+1);
	}


	$respuesta = array(
			'err'     		=> false, 
			'conteo' 		=> $cuantos,
			'publication' 	=> $datos,
			'pag_actual'    => ($pagina+1),
			'pag_siguiente' => $pag_siguiente,
			'pag_anterior'  => $pag_anterior,
			'total_paginas' => $total_paginas,
			'paginas'	    => $arrPaginas
			);


	return  $respuesta;

}

function get_publication_paginado_avisos( $pagina = 1, $por_pagina = 20 ){

	$conex = getConex();

	//$sql = "SELECT count(*) as cuantos FROM publication p,user u WHERE (p.id_user=u.id) AND (u.cod_dep=p.cod OR u.cod_ja=p.cod OR u.cod_all=p.cod);";
	$sql = "SELECT count(*) as cuantos FROM publication p,user u 
			WHERE p.id_user=u.id AND (p.type='instructivo' OR p.type='circular' OR p.type='comunicado');";

	$result = $conex->prepare($sql);
	$result->execute();
	$res = $result->fetchObject();
	$cuantos = $res->cuantos;


	$total_paginas = ceil( $cuantos / $por_pagina );

	if( $pagina > $total_paginas ){
		$pagina = $total_paginas;
	}


	$pagina -= 1;  // 0
	$desde   = $pagina * $por_pagina; // 0 * 20 = 0
	if( $desde < 0 )
		$desde = 0;

	if( $pagina >= $total_paginas-1 ){
		$pag_siguiente = 1;
	}else{
		$pag_siguiente = $pagina + 2;
	}

	if( $pagina < 1 ){
		$pag_anterior = $total_paginas;
	}else{
		$pag_anterior = $pagina;
	}


	$sql = "SELECT p.id,p.title,p.description,p.fec,p.img,p.type,p.cod,'' destinatario,u.email,u.position,u.cellphone,u.type userType,ja.name AS ja_name,per.name,per.last_name FROM publication p,user u,person per,j_agroambiental ja WHERE p.id_user=u.id AND u.id_person=per.id AND u.id_jagroambiental=ja.id AND (p.type='instructivo' OR p.type='circular' OR p.type='comunicado') limit $desde, $por_pagina;";
	$result = $conex->prepare($sql);
	$result->execute();
	$datos = $result->fetchAll(PDO::FETCH_OBJ);

	$arrPaginas = array();
	for ($i=0; $i < $total_paginas; $i++) { 
		array_push($arrPaginas, $i+1);
	}


	$respuesta = array(
			'err'     		=> false, 
			'conteo' 		=> $cuantos,
			'publication' 	=> $datos,
			'pag_actual'    => ($pagina+1),
			'pag_siguiente' => $pag_siguiente,
			'pag_anterior'  => $pag_anterior,
			'total_paginas' => $total_paginas,
			'paginas'	    => $arrPaginas
			);


	return  $respuesta;

}

?>
