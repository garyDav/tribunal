(function(angular) {

	'use strict';
	angular.module('communicateModule').factory('communicateService',['$http','$q',
		function($http,$q) {
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

				timeVerbal: function(fecha) {
					//var fecha = '2017-06-12 06:18:20';
					var tiempo = new Date();
					var fDia = Number(fecha.substr(8,2));
					var fMes = Number(fecha.substr(5,2));
					var fAnio = Number(fecha.substr(0,4));
				 	var dias = new Array('dom','lun','mar','mie','jue','vie','sab');
					var verbal = '';
					var hora = 0;
					var fechaObj = new Date(fecha);


				 	if( fAnio == tiempo.getUTCFullYear() ) {
				 		if( fDia == tiempo.getDate() ) {
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
				 				} else {
				 					verbal = 'fecha';
				 				}
				 			} else {
				 				verbal = 'fecha y mes';
				 			}
				 		}
				 	} else {
				 		verbal = 'mes y año';
				 	}
 	
					/*var cadena = fecha.substr(8,2)+" de ";
					var mes = parseInt(fecha.substr(5,2));
				 	switch(mes){
			 			case 1:cadena+="Enero";break;
			 			case 2:cadena+="Febrero";break;
			 			case 3:cadena+="Marzo";break;
			 			case 4:cadena+="Abril";break;
			 			case 5:cadena+="Mayo";break;
			 			case 6:cadena+="Junio";break;
			 			case 7:cadena+="Julio";break;
			 			case 8:cadena+="Agosto";break;
			 			case 9:cadena+="Septiembre";break;
			 			case 10:cadena+="Octubre";break;
			 			case 11:cadena+="Noviembre";break;
			 			case 12:cadena+="Diciembre";break;
			 			default:break;
				 	}*/

				 	/*if(""+tiempo.getUTCFullYear() !== fecha.substr(0,4)){
				 		cadena += " del "+fecha.substr(0,4);
				 	}

				 	if(fecha.substr(8,2) === ""+tiempo.getDate()){
						cadena = "Hoy";
					}
					else if(fecha.substr(8,2) === ""+(tiempo.getDate()-1)){
						cadena = "Ayer";
					}
				 	if((parseInt(fecha.substr(11,2))>=12)){
				 		cadena += " a las "+fecha.substr(11,5)+" PM";
				 	}
				 	else{
				 		cadena += " a las "+fecha.substr(11,5)+" AM";
				 	}*/
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
										response.communicate.forEach(function(element,index,array) {
											element.fec = self.timeVerbal(element.fec);
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
				}


			};

			return self;
		}
	]);

})(window.angular);