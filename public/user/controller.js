// ================================================
//   Controlador de usuarios
// ================================================
angular.module('userModule').controller('userCtrl', ['$scope', 'userService', function($scope, userService){

	$scope.activar('mUsers','','Usuarios','lista de usuarios');
	$scope.users   = {};
	$scope.userSel = {};
	$scope.viewJA = false;
	$scope.load = true;
	$scope.jabro = [];
	$scope.department = [];

	//Edad Minima
	var em = new Date();
	em.setFullYear(em.getFullYear()-70);
	$scope.edadMinima = ""+em.getFullYear()+"-01-01";

	//Edad Maxima
	var me = new Date();
	me.setFullYear(me.getFullYear()-18);
	$scope.edadMaxima = ""+me.getFullYear()+"-01-01";


	$scope.moverA = function( pag ){
		$scope.load = true;

		userService.cargarPagina( pag ).then( function(){
			$scope.users = userService;
			$scope.load = false;
		});

	};

	$scope.moverA(1);

	// ================================================
	//   Mostrar modal de edicion
	// ================================================
	$scope.mostrarModal = function( user ){

		//console.log( user );
		//angular.copy( user, $scope.userSel );
		userService.cargarJAgro().then(
			function(data) {
				$scope.jabro = data;
			}
		);
		userService.cargarDep().then(function( data ) {
			$scope.department = data;
		});
		$("#modal_user").modal();

	}

	$scope.llenar_jagroambiental= function( user,id,cod_ja,frmUser ) {
		user.id_jagroambiental = id;
		user.cod_ja = cod_ja;
		$scope.viewJA = false;
		console.log(id+' - '+cod_ja+' - '+$scope.viewJA);
	}

	// ================================================
	//   Funcion para guardar
	// ================================================
	$scope.guardar = function( user, frmUser){
		console.log(user);

		/*userService.guardar( user ).then(function(){

			// codigo cuando se actualizo
			$("#modal_user").modal('hide');
			$scope.userSel = {};

			frmUser.autoValidateFormOptions.resetForm();

		});*/


	}
	// ================================================
	//   Funcion para eliminar
	// ================================================
	$scope.eliminar = function( id ){

		swal({
			title: "¿Esta seguro de eliminar?",
			text: "¡Si confirma esta acción eliminará el registro!",
			type: "warning",
			showCancelButton: true,
			confirmButtonColor: "#DD6B55",
			confirmButtonText: "Si, Eliminar!",
			closeOnConfirm: false
		},
		function(){
			userService.eliminar( id ).then(function(){
				swal("Eliminado!", "Registro eliminado correctamente.", "success");
			});
		});

	}

}]);
