(function(angular) {

	'use strict';
	angular.module('galeriaModule').controller('galeriaCtrl',['$scope','galeriaService','uploadGaleria',
		function($scope,galeriaService,uploadGaleria) {
			$scope.find = function() {
				$scope.activar('mGaleria','','Galería','lista de galería');

				$scope.load 	= true;
				$scope.imagenes	= [];

				$scope.moverA = function( pag ){
					galeriaService.cargarPagina( pag ).then( function(){
						$scope.imagenes = galeriaService;
						console.log($scope.imagenes);
						$scope.load = false;
					});
				};
				$scope.moverA(1);

				$scope.activar = function(id) {
					if(id == 1)
						return 'active';
				};

				
			};

			$scope.findOne = function() {
				$scope.guardarGaleria = function(self,form) {
					//console.log(self);

					if( self.img ) {

						if( typeof self.img == 'object' )
							uploadGaleria.saveImg(self.img).then(function( data ) {
								if ( data.error == 'not' ) {
									self.img = data.src;
									galeriaService.guardar( self ).then(function(){
										// codigo cuando se inserto o actualizo
										$("#modal_galeria").modal('hide');
										self = {};

										form.autoValidateFormOptions.resetForm();
									});
								} else 
								if ( data.error == 'yes' )
									swal("ERROR", "¡"+data.msj+"!", "error");
								else {
									swal("ERROR SERVER", "¡"+data+"!", "error");
									console.error(data);
								}
							});
						else {
							galeriaService.guardar( self ).then(function(){
								// codigo cuando se inserto o actualizo
								$("#modal_galeria").modal('hide');
								self = {};

								form.autoValidateFormOptions.resetForm();
							});
						}

					} else {
						swal("ERROR", "¡Inserte una imagen!", "error");
					}
				};
			};

			

		}
	]);


})(window.angular);
