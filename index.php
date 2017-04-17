<?php
session_start();

if( !isset( $_SESSION['uid'] ) ){
  header('Location: /tribunal/login/');
  die;

}

?>
<!DOCTYPE html>
<html lang="es" ng-app="tribunalModule">
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
	<link rel="stylesheet" href="app/css/ionicons.min.css">
	<link rel="stylesheet" href="app/css/AdminLTE.css">
	<link rel="stylesheet" href="app/css/_all-skinsAdminLTE.css">
	<link rel="stylesheet" href="app/css/animate.css">

	<!-- iCheck
    <link rel="stylesheet" href="plugins/iCheck/flat/blue.css">
    Morris chart
    <link rel="stylesheet" href="plugins/morris/morris.css">
    jvectormap
    <link rel="stylesheet" href="plugins/jvectormap/jquery-jvectormap-1.2.2.css">
    Date Picker
    <link rel="stylesheet" href="plugins/datepicker/datepicker3.css">
    Daterange picker 
    <link rel="stylesheet" href="plugins/daterangepicker/daterangepicker-bs3.css">
    bootstrap wysihtml5 - text editor 
    <link rel="stylesheet" href="plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css">-->

	<!-- Fin Librerias CSS-->
	<link href="app/css/styles.css" rel="stylesheet">
	
	<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body class="hold-transition skin-blue sidebar-mini">

	<div class="wrapper">

	  <!-- Main Header -->
	  <header class="main-header">

	    <!-- Logo -->
	    <a href="index2.html" class="logo">
	      <!-- mini logo for sidebar mini 50x50 pixels -->
	      <span class="logo-mini"><b>T</b>AG</span>
	      <!-- logo for regular state and mobile devices -->
	      <span class="logo-lg"><b>Tribu</b>nal</span>
	    </a>

	    <!-- Header Navbar -->
	    <nav class="navbar navbar-static-top" role="navigation">
	      <!-- Sidebar toggle button-->
	      <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
	        <span class="sr-only">Toggle navigation</span>
	      </a>
	      <!-- Navbar Right Menu -->
	      <div class="navbar-custom-menu">
	        <ul class="nav navbar-nav">


	          <!-- Messages: style can be found in dropdown.less-->
	          <li class="dropdown messages-menu"
	          	  ng-include="'public/main/views/message.view.html'">
	          </li>
	          <!-- /.messages-menu -->



	          <!-- Notifications Menu -->
	          <li class="dropdown notifications-menu"
	          	  ng-include="'public/main/views/notifications.view.html'">
	          </li>



	          

	          <!-- User Account Menu -->
	          <li class="dropdown user user-menu"
	          	  ng-include="'public/main/views/user.view.html'">
	          </li>



	          <!-- Control Sidebar Toggle Button -->
	          <li>
	            <a href="#" data-toggle="control-sidebar"><i class="fa fa-gears"></i></a>
	          </li>
	        </ul>
	      </div>
	    </nav>
	  </header>
	  <!-- Left side column. contains the logo and sidebar -->
	  <aside class="main-sidebar"
	  		 ng-include="'public/main/views/menu.view.html'">
	  </aside>

	  <!-- Content Wrapper. Contains page content -->
	  <div class="content-wrapper">
	    <!-- Content Header (Page header) -->
	    <section class="content-header">
	      <h1>
	        Tribunal Agroambiental
	        <small>Optional description</small>
	      </h1>
	    </section>

	    <!-- Main content -->
	    <section class="content" ng-view>
		  
	      <!-- Your Page Content Here -->
	    </section>
	    <!-- /.content -->
	  </div>
	  <!-- /.content-wrapper -->

	  <!-- Main Footer -->
	  <footer class="main-footer">
	    <!-- To the right -->
	    <div class="pull-right hidden-xs">
	      Por: ...
	    </div>
	    <!-- Default to the left -->
	    <strong>Copyright &copy; 2017 <a href="#">Tribunal Agroambiental</a>.</strong> Todos los derechos reservados.
	  </footer>

	  <!-- Control Sidebar -->
	  <aside class="control-sidebar control-sidebar-dark">
	    <!-- Create the tabs -->
	    <ul class="nav nav-tabs nav-justified control-sidebar-tabs" style="margin:0;">
	      <li class="active"><a href="#control-sidebar-home-tab" data-toggle="tab"><i class="fa fa-home"></i></a></li>
	      <li><a href="#control-sidebar-settings-tab" data-toggle="tab"><i class="fa fa-gears"></i></a></li>
	    </ul>
	    <!-- Tab panes -->
	    <div class="tab-content">
	      <!-- Home tab content -->
	      <div class="tab-pane active" id="control-sidebar-home-tab">
	        <h3 class="control-sidebar-heading">Registrar</h3>
	        <ul class="sidebar-menu">
	          <li data-toggle="modal" data-target="#noticias"><a href="#"><i class="fa fa-link"></i> <span>Noticias</span></a></li>
	          <li data-toggle="modal" data-target="#cumple"><a href="#"><i class="fa fa-link"></i> <span>Cumpleaños</span></a></li>
	          <li data-toggle="modal" data-target="#efemerides"><a href="#"><i class="fa fa-link"></i> <span>Efemerides</span></a></li>
	          <li data-toggle="modal" data-target="#avisos"><a href="#"><i class="fa fa-link"></i> <span>Avisos</span></a></li>
	          <li data-toggle="modal" data-target="#fotos"><a href="#"><i class="fa fa-link"></i> <span>Fotos</span></a></li>
	        </ul>
	        <!-- /.control-sidebar-menu -->

	      </div>
	      <!-- /.tab-pane -->
	      <!-- Stats tab content -->
	      <div class="tab-pane" id="control-sidebar-stats-tab">Stats Tab Content</div>
	      <!-- /.tab-pane -->
	      <!-- Settings tab content -->
	      <div class="tab-pane" id="control-sidebar-settings-tab">
	        <form method="post">
	          <h3 class="control-sidebar-heading">General Settings</h3>

	          <div class="form-group">
	            <label class="control-sidebar-subheading">
	              Report panel usage
	              <input type="checkbox" class="pull-right" checked>
	            </label>

	            <p>
	              Some information about this general settings option
	            </p>
	          </div>
	          <!-- /.form-group -->
	        </form>
	      </div>
	      <!-- /.tab-pane -->
	    </div>
	  </aside>
	  <!-- /.control-sidebar -->
	  <!-- Add the sidebar's background. This div must be placed
	       immediately after the control sidebar -->
	  <div class="control-sidebar-bg"></div>
	</div>
	<!-- ./wrapper -->



	
	<!-- Todas las librerias externas -->
	<script src="app/lib/jquery.min.js"></script>
	<script src="app/lib/jquery-ui.min.js"></script>
	<!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
    <script>
      $.widget.bridge('uibutton', $.ui.button);
    </script>
	<script src="app/lib/angular.min.js"></script>
	<script src="app/lib/angular-resource.min.js"></script>
	<script src="app/lib/angular-route.min.js "></script>
	<script src="app/lib/angular-touch.min.js"></script>
	<script src="app/lib/loading-bar.min.js"></script>
	<script src="app/lib/jcs-auto-validate.js"></script>
	<script src="app/lib/bootstrap.min.js"></script>
	<script src="app/lib/AdminLTE.js"></script>
	<!--<script src="app/lib/dashboard.js"></script>-->
	<!--<script src="app/lib/demoAdminLTE.js"></script>-->
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
