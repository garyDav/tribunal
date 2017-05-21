angular.module('userModule').factory('userService', ['$http', '$q', function($http, $q){

	var self = {

		'cargando'		: false,
		'err'     		: false, 
		'conteo' 		: 0,
		'users' 		: [],
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


		guardar: function( user ){

			var d = $q.defer();
			var us = JSON.parse( JSON.stringify( user ) );
			us.fec_nac = self.formatDate(us.fec_nac);
			console.log(us);
			$http.post('rest/v1/person/' , us )
				.success(function( respuesta ){

					if ( respuesta.error == 'not' ) {
						us.id_person = respuesta.id;
						console.log(respuesta);
						console.log(us);
						$http.post('rest/v1/user/' , us )
							.success(function( respuesta ){

								if ( respuesta.error == 'not' ) {
									self.cargarPagina( self.pag_actual  );
									d.resolve();
									swal("CORRECTO", "¡"+respuesta.msj+"!", "success");
								} else 
								if ( respuesta.error == 'yes' )
									swal("ERROR", "¡"+respuesta.msj+"!", "error");
								else 
									swal("ERROR SERVER", "¡"+respuesta+"!", "error");
							});
					} else 
					if ( respuesta.error == 'yes' )
						swal("ERROR", "¡"+respuesta.msj+"!", "error");
					else 
						swal("ERROR SERVER", "¡"+respuesta+"!", "error");
				});

			return d.promise;

		},

		eliminar: function( id_person,id ){

			var d = $q.defer();

			$http.delete('rest/v1/user/' + id )
				.success(function( respuesta ){

					if ( respuesta.error == 'not' ) {
						$http.delete('rest/v1/person/' + id_person )
							.success(function( respuesta ){

								if ( respuesta.error == 'not' ) {
									self.cargarPagina( self.pag_actual  );
									d.resolve(respuesta);
								} else 
									swal("ERROR SERVER", "¡"+respuesta+"!", "error");
							});
					} else 
						swal("ERROR SERVER", "¡"+respuesta+"!", "error");
						

				});


			return d.promise;

		},

		cargarJAgro: function() {
			var d = $q.defer();

			$http.get('rest/v1/j_agroambiental/').success(function( data ) {
				d.resolve(data);
			});

			return d.promise;
		},

		cargarDep: function() {
			var d = $q.defer();

			$http.get('rest/v1/department').success(function( data ) {
				d.resolve(data);
			});

			return d.promise;
		},

		cargarPagina: function( pag ){

			var d = $q.defer();

			$http.get('rest/v1/user/' + pag )
				.success(function( data ){

					if(data) {
						data.user.forEach(function(element,index,array) {
							element.pwd = '';
							var values = element.fec_nac.split("-");
							var dia = values[2];
							var mes = values[1];
							var ano = values[0];
							element.fec_nac = new Date(ano, mes, dia);
						});

						self.err           = data.err;
						self.conteo        = data.conteo;
						self.users         = data.user;
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


// ================================================
//   Filtros
// ================================================
angular.module('userModule').filter( 'edad', function(){

	return function(fecha){
		if( fecha ){
			var values=fecha.split("-");
			var dia = values[2];
			var mes = values[1];
			var ano = values[0];

			// cogemos los valores actuales
			var fecha_hoy = new Date();
			var ahora_ano = fecha_hoy.getYear();
			var ahora_mes = fecha_hoy.getMonth()+1;
			var ahora_dia = fecha_hoy.getDate();

			// realizamos el calculo
			var edad = (ahora_ano + 1900) - ano;
			if ( ahora_mes < mes )
			{
			    edad--;
			}
			if ((mes == ahora_mes) && (ahora_dia < dia))
			{
			    edad--;
			}
			if (edad > 1900)
			{
			    edad -= 1900;
			}
			return edad;
		}
	}
});