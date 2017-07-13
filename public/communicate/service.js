(function(angular) {

	'use strict';
	angular.module('communicateModule').factory('communicateService',['$http','$q','$rootScope',
		function($http,$q,$rootScope) {
			var self= {

				'cargando'		: false,
				'err'     		: false, 
				'conteo' 		: 0,
				'communicate' 	: [],
				'pag_actual'    : 1,
				'pag_siguiente' : 1,
				'pag_anterior'  : 1,
				'total_paginas' : 1,
				'paginas'	    : [],
				'mNoLeidos'		: 0,
				'userDate'		: {
					'name': '',
					'last_name': '',
					'last_connection': ''
				},

				timeVerbal: function(fecha) {
					//var fecha = '2017-06-12 06:18:20';
					var tiempo = new Date();
					var fDia = Number(fecha.substr(8,2));
					var fMes = Number(fecha.substr(5,2));
					var fAnio = Number(fecha.substr(0,4));
				 	var dias = new Array('dom','lun','mar','mie','jue','vie','sab');
				 	var meses = new Array('Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Set','Oct','Nov','Dic');
					var verbal = '';
					var hora = 0;
					var fechaObj = new Date(fecha);


				 	if( fAnio == tiempo.getUTCFullYear() ) {
						if( fDia == tiempo.getDate() && fMes == (tiempo.getMonth()+1) ) {
							if( (parseInt(fecha.substr(11,2)) > 12) ){
								hora = parseInt(fecha.substr(11,2));
								hora -= 12;
								if( hora < 10 )
									hora = "0"+hora;
								verbal += hora+fecha.substr(13,3)+" PM";
							}
							else{
								verbal += fecha.substr(11,5)+" AM";
							}
						} else {
							if( fMes == (tiempo.getMonth()+1) ) {
								if( fDia >= tiempo.getDate()-6 ) {
									verbal = dias[fechaObj.getDay()];
										if( fDia == tiempo.getDate()-1 )
											verbal = 'ayer';
								} else {
									verbal = 'fec: '+fecha.substr(8,2);
								}
							} else {
								verbal = meses[fMes-1];
							}
						}
					} else {
						verbal = meses[fMes-1]+' del '+fechaObj.getUTCFullYear();
					}
	

				 	return verbal;
				},

				cargarPagina: function( pag ){

					var d = $q.defer();

					$http.get('php/data.php' )
					.success(function( data ){
						if(data) {
							if(data.error == 'not') {
								$http.get('rest/v1/communicate/'+ data.userID+ '/' + pag )
								.success(function( response ){

									var conteo = 0;
									if(response) {
										//console.log(response);
										response.communicate.forEach(function(element,index,array) {
											element.fec = self.timeVerbal(element.fec);
											element.last_connection = new Date(element.last_connection);
											//element.last_connection = self.timeVerbal(element.last_connection);
											if( !Number(element.viewed) )
												conteo ++;
										});

										self.err           = response.err;
										self.conteo        = response.conteo;
										self.communicate   = response.communicate;
										self.pag_actual    = response.pag_actual;
										self.pag_siguiente = response.pag_siguiente;
										self.pag_anterior  = response.pag_anterior;
										self.total_paginas = response.total_paginas;
										self.paginas       = response.paginas;
										self.mNoLeidos	   = conteo;

									}
									return d.resolve();
								})
								.error(function( err ) {
									console.error(err);
									return d.rejet();
								});
							}

						}
					});

					return d.promise;
				},

				loadAllMessages: function(id) {
					var d = $q.defer();

					$http.get('rest/v1/messages/'+id+'/'+$rootScope.userID).success(function( response ){
						if(response) {
							self.cargarPagina(1);
							response.forEach(function(element,index,array) {
								if(element.id_use != $rootScope.userID) {
									self.userDate.name = element.name;
									self.userDate.last_name = element.last_name;
									self.userDate.last_connection = new Date(element.last_connection);
								}
								element.fec = new Date(element.fec);
							});
							console.log(response);
							d.resolve(response);
						}
					}).error(function( err ){
						d.reject(err);
						console.error(err);
					});

					return d.promise;
				},

				saveMessage: function(data) {
					var d = $q.defer();

					$http.post('rest/v1/communicate',data).success(function(response) {
						//self.loadAllMessages(data.id_usr);
						d.resolve(response);
					}).error(function(err) {
						console.error(err);
						d.reject(err);
					});

					return d.promise;

				},

				cargarUsers: function() {
					var d = $q.defer();

					$http.get('rest/v1/mensaje/user/'+$rootScope.userID).success(function(response) {
						d.resolve(response);
					}).error(function(err) {
						console.error(err);
						d.reject(err);
					});

					return d.promise;
				}


			};

			return self;
		}
	]);

})(window.angular);