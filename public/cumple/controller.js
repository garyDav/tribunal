(function(angular) {

	'use strict';
	angular.module('cumpleModule').controller('cumpleCtrl',['$scope','cumpleService',
		function($scope,cumpleService) {
			$scope.activar('','','Cumpleaños','lista de cumpleañeros');
			$scope.birthday = [];
			$scope.tipo = 'sem';

			$("#tod").change(function () {
				if ($(this).is(':checked')) {
				    $('.cump').prop('checked', true);
				} else {
				    $('.cump').prop('checked', false);
				}
			});
			
			$scope.cumple = function(self,form) {
				var elem = $(".cump:checked");
				var vec = [];

				if(elem.length > 0){
					for(var i=0;i<elem.length;i++) {
						vec[i] = elem[i].id;
					}
				}
				vec.forEach(function(e,i,v) {
					cumpleService.enviarMensaje(e,self.msj).then(function(response) {
						console.log(i);
						if ( response.error == 'not' ) {
							swal("CORRECTO", "¡"+response.msj+"!", "success");
						}
					});
				});
			};

			$scope.escogerTipo = function(tipo) {
				cumpleService.cargarTipo(tipo).then(function(response) {
					$scope.birthday = response;
					console.log($scope.birthday);
				});
			};

			$scope.escogerTipo($scope.tipo);

			console.log('enter cumple');
		}
	]);


})(window.angular);
