(function(angular) {

	'use strict';
	angular.module('cumpleModule').factory('cumpleService',['$http','$q','$rootScope',
		function($http,$q,$rootScope) {
			var self= {
				cargarTipo: function(tipo) {
					var d = $q.defer();
					$http.get('rest/v1/cumple/'+tipo).success(function(response) {
						d.resolve(response);
					}).error(function(err) {
						d.reject(err);
						console.error(err);
					});

					return d.promise;
				},
				enviarMensaje: function(idR,mensaje) {
					var d = $q.defer();
					var data = {
						id_use: $rootScope.userID,
						id_usr: idR,
						message: mensaje
					};

					$http.post('rest/v1/communicate/cumple/',data).success(function(response) {
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