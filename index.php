<?php
session_start();

if( !isset( $_SESSION['uid'] ) ){
  header('Location: /tribunal/login/');
  die;

}

?>
<!DOCTYPE html>
<html lang="en" ng-app="tribunalModule">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title>Tribunal Agroambiental</title>

	<base href="/tribunal/">
	<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
	<meta name="description" content="Sistema del Tribunal Agroambiental">
	<meta name="author" content="Anonimo">


	<!-- Librerias CSS-->
	<link rel="stylesheet" href="app/css/loading-bar.min.css">
	<link rel="stylesheet" href="app/css/bootstrap.min.css">
	<link rel="stylesheet" href="app/css/font-awesome.css">
	<!-- Fin Librerias CSS-->
	<link href="app/css/styles.css" rel="stylesheet">
	
	<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body>


	<div>
		<nav ng-include="'public/main/views/nav.view.html'"></nav>
		<section ng-view></section>
	</div>
	
	<!-- Todas las librerias externas -->
	<script src="app/lib/jquery.js"></script>
	<script src="app/lib/angular.min.js"></script>
	<script src="app/lib/angular-resource.min.js"></script>
	<script src="app/lib/angular-route.min.js "></script>
	<script src="app/lib/angular-touch.min.js"></script>
	<script src="app/lib/loading-bar.min.js"></script>
	<script src="app/lib/jcs-auto-validate.js"></script>
	<script src="app/lib/bootstrap.min.js"></script>
	<!--<script src="js/ie10-viewport-bug-workaround.js"></script>-->
	<!-- Fin todas las librerias externas -->

	<!-- Module -->
	<script src="public/user/module.js"></script>
	<!-- Fin Module -->
	
	<!-- Route -->
	<script src="public/user/route.js"></script>
	<!-- Fin Route -->

	<script src="public/app.js"></script>

	<script src="public/give/module.js"></script>
</body>
</html>
