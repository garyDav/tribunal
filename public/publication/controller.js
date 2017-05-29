// ================================================
//   Controlador de usuarios
// ================================================
angular.module('publicationModule').controller('publicationCtrl', ['$scope', '$rootScope', 'publicationService', 
	function($scope, $rootScope, publicationService){

		$scope.activar('mPublication','','Publicacion','lista de publicaciones');
		$scope.publication   = {};
		$scope.pubSel 		 = {};
		$scope.load 		 = true;

		$scope.find = function(type) {
			$scope.load = true;

			$scope.moverA = function( pag ){
				publicationService.cargarPagina( pag,type ).then( function(){
					$scope.publication = publicationService;
					$scope.load = false;
				});
			};
			$scope.moverA(1);
		};

		// ================================================
		//   Mostrar modal de publicacion
		// ================================================
		$scope.mostrarModal = function( user ){

			user.cellphone = parseInt(user.cellphone);
			angular.copy( user, $scope.userSel );
			$("#modal_user").modal();
		};

		// ================================================
		//   Funcion para guardar
		// ================================================
		$scope.guardar = function( user, frmUser){

			publicationService.guardar( user ).then(function(){

				// codigo cuando se actualizo
				$("#modal_user").modal('hide');
				$scope.userSel = {};

				frmUser.autoValidateFormOptions.resetForm();

			});

		};
		// ================================================
		//   Funcion para eliminar
		// ================================================
		$scope.eliminar = function( id ){

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
				publicationService.eliminar( id ).then(function(data){
					if( data.error == 'not')
						swal("¡Correcto!", "ID: "+data.id+" "+data.msj, "success");
					else {
						swal("ERROR SERVER", "¡"+data+"!", "error");
						console.error(data);
					}
				});
			});

		};

	}
]);
