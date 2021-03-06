// ================================================
//   Controlador de usuarios
// ================================================
angular.module('userModule').controller('userCtrl', ['$scope', '$rootScope', 'userService', function($scope, $rootScope, userService){

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

	userService.cargarJAgro().then(function(data) {
		$scope.jabro = data;
	});
	userService.cargarDep().then(function( data ) {
		$scope.department = data;
	});

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

		user.cellphone = parseInt(user.cellphone);
		angular.copy( user, $scope.userSel );
		if($rootScope.userTYPE == 'supad') {
			$(".supad").prop('disabled', true);
			console.log('jodanse');
		}
		$("#modal_user").modal();
	}

	$scope.llenar_jagroambiental= function( user,id,cod_ja ) {
		user.id_jagroambiental = id;
		user.cod_ja = cod_ja;
		//console.log(id+' - '+cod_ja+' - '+$scope.viewJA);
	}

	// ================================================
	//   Funcion para guardar
	// ================================================
	$scope.guardar = function( user, frmUser){

		userService.guardar( user ).then(function(){

			// codigo cuando se actualizo
			$("#modal_user").modal('hide');
			$scope.userSel = {};

			frmUser.autoValidateFormOptions.resetForm();

		});

	}
	// ================================================
	//   Funcion para eliminar
	// ================================================
	$scope.eliminar = function( id_person,id ){

		swal({
			title: "¿Esta seguro de dar de baja al usuario?",
			text: "¡Si confirma esta acción dara de baja al usuario!",
			type: "warning",
			showCancelButton: true,
			confirmButtonColor: "#DD6B55",
			confirmButtonText: "Si, Desactivar!",
			closeOnConfirm: false
		},
		function(){
			userService.eliminar( id ).then(function(data){
				if( data.error == 'not')
					swal("¡Correcto!", "ID: "+data.id+" "+data.msj, "success");
				else 
					swal("ERROR SERVER", "¡"+data+"!", "error");
			});
		});

	}

}]);
