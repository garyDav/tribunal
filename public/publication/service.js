angular.module('publicationModule').factory('publicationService', ['$http', '$q', function($http, $q){

	var self = {

		'cargando'		: false,
		'err'     		: false, 
		'conteo' 		: 0,
		'pub' 			: [],
		'pag_actual'    : 1,
		'pag_siguiente' : 1,
		'pag_anterior'  : 1,
		'total_paginas' : 1,
		'paginas'	    : [],

		formatDate: function( date ) {
			var d = new Date(date);
			var month = '' + (d.getMonth() + 1);
			var day = '' + d.getDate();
			var year = d.getFullYear();

			if (month.length < 2) month = '0' + month;
			if (day.length < 2) day = '0' + day;

			return [year, month, day].join('-');
		},


		guardar: function( publication,type ){

			var d = $q.defer();

			$http.post('rest/v1/publication/'+type+'/' , publication )
			.success(function( response ){

				if ( response.error == 'not' ) {
					self.cargarPagina( self.pag_actual  );
					d.resolve();
					swal("CORRECTO", "¡"+response.msj+"!", "success");
				} else 
				if ( response.error == 'yes' )
					swal("ERROR", "¡"+response.msj+"!", "error");
				else {
					swal("ERROR SERVER", "¡"+response+"!", "error");
					console.error(response);
				}

			}.error(function( response ) {
				console.error(response);
			}));

			return d.promise;

		},

		eliminar: function( id ){

			var d = $q.defer();

			$http.delete('rest/v1/publication/' + id )
				.success(function( response ){

					self.cargarPagina( self.pag_actual  );
					d.resolve(response);

				});

			return d.promise;

		},

		cargarPagina: function( pag,type ){

			var d = $q.defer();

			$http.get('rest/v1/publication/' + pag + '/' + type )
				.success(function( data ){
					console.log(data);

					if(data) {

						self.err           = data.err;
						self.conteo        = data.conteo;
						self.pub   		   = data.publication;
						self.pag_actual    = data.pag_actual;
						self.pag_siguiente = data.pag_siguiente;
						self.pag_anterior  = data.pag_anterior;
						self.total_paginas = data.total_paginas;
						self.paginas       = data.paginas;

					}
					return d.resolve();
				});

			return d.promise;
		}


	};

	return self;

}]);
