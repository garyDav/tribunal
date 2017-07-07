<?php

if(!is_dir('../app/documents/'))
	mkdir('../app/documents/',777);
if($_FILES['doc']) {
	if(is_uploaded_file($_FILES['doc']['tmp_name'])) {
		//Definir nombres
		$e = 'yes';
		$msj = '';
		$name = '';

		$nombre = $_FILES['doc']['name'];
		$nombre = strtolower($nombre);
		$tipo = $_FILES['doc']['type'];
		$tipo = strtolower($tipo);
		$size = $_FILES['doc']['size'];
		$error = $_FILES['doc']['error'];
		$extension = substr($tipo,strpos($tipo,'/')+1);
		$name = $nombre.'-'.substr(time(),-3).'.'.$extension;
		$lugar = '../app/documents/';
		//Fin de definir nombres

		if(!empty($nombre) && isset($nombre)) {
			if($error == 0) {
				if( strpos($tipo,'doc') || strpos($tipo,'docx') || strpos($tipo,'pdf') || strpos($tipo,'xls') || strpos($tipo,'xlsx') || strpos($tipo,'odt') || strpos($tipo,'ott') || strpos($tipo,'txt') ) {
					if($size < 5777168) { //5Megas
						if(move_uploaded_file($_FILES['doc']['tmp_name'], $lugar.$name)) {
							$msj = 'Documento subido';
							$e = 'not';
						}
					} else
						$msj = 'Documento demasiado grande.';
				} else
					$msj = 'Formato incorrecto del documento.';
			} else
				$msj = 'Error al subir el documento.';
		} else
			$msj = 'El documento no se subio bien.';
	} else
		$msj = 'Por favor elija un documento.';
	print_r(json_encode(array('error'=>$e,'msj'=>$msj,'src'=>$name)));
}
?>