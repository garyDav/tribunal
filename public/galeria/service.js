(function(angular) {

	'use strict';
	angular.module('galeriaModule').factory('galeriaService',['$http','$q','$rootScope',
		function($http,$q,$rootScope) {
			var self= {

				'cargando'		: false,
				'err'     		: false, 
				'conteo' 		: 0,
				'img' 			: [],
				'pag_actual'    : 1,
				'pag_siguiente' : 1,
				'pag_anterior'  : 1,
				'total_paginas' : 1,
				'paginas'	    : [],
				'idUltimo'		: 0,

				cargarPagina: function(pag) {
					var d = $q.defer();

					$http.get('rest/v1/img/' + pag )
						.success(function( data ){
							console.log(data.img.length);

							if(data) {

								self.idUltimo = data.img[0].id;

								self.err           = data.err;
								self.conteo        = data.conteo;
								self.img           = data.img;
								self.pag_actual    = data.pag_actual;
								self.pag_siguiente = data.pag_siguiente;
								self.pag_anterior  = data.pag_anterior;
								self.total_paginas = data.total_paginas;
								self.paginas       = data.paginas;

							}
							return d.resolve();
						});

					return d.promise;
				},
				guardar: function(data) {
					//console.log(data);
					var d = $q.defer();

					$http.post('rest/v1/img/' , data )
					.success(function( response ){

						if ( response.error == 'not' ) {
							self.cargarPagina( self.pag_actual );
							d.resolve();
							swal("CORRECTO", "¡"+response.msj+"!", "success");
						} else 
						if ( response.error == 'yes' )
							swal("ERROR", "¡"+response.msj+"!", "error");
						else {
							swal("ERROR SERVER", "¡"+response+"!", "error");
							console.error(response);
						}

					}).error(function( err ) {
						d.reject(err);
						console.error(err);
					});

					return d.promise;
				}

			};

			return self;
		}
	]);

})(window.angular);
