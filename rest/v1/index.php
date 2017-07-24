<?php
//Libreria de Slim
require '../vendor/Slim/Slim.php';
//end Libreria.

\Slim\Slim::registerAutoloader();

$app = new \Slim\Slim();

session_start();
//if( isset( $_SESSION['user'] ) )
	define('SPECIALCONSTANT',true);

//EntidadesRESTFULL
require 'models/connect.php';
require 'models/general.php';

require 'models/Person.php';
require 'models/User.php';
require 'models/Comment.php';
require 'models/Communicate.php';
require 'models/JAgroambiental.php';
require 'models/Publication.php';
require 'models/Reporte.php';
require 'models/Img.php';
//end EntidadesRESTFULL

$app->run();



?>

