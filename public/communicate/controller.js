(function(angular) {

	'use strict';
	angular.module('communicateModule').controller('communicateCtrl',['$scope','communicateService','$rootScope',
		function($scope,communicateService,$rootScope) {
			$scope.find = function() {
				$scope.listMessages = {};
				$scope.load 		= true;
				$scope.mensajes 	= ''; 

				$scope.moverA = function(pag) {
					communicateService.cargarPagina(pag).then(function(){
						$scope.load = false;
						$scope.listMessages = communicateService;
						if( $scope.listMessages.mNoLeidos == 1 )
							$scope.mensajes = 'mensaje no leido';
						else
							$scope.mensajes = 'mensajes no leidos';
						console.log($scope.listMessages);
					});
				};
				$scope.moverA(1);
			};
			/*$scope.findAll = function() {
				$scope.listMessages = {};
				$scope.load 		= true;
				
				$scope.moverA = function(pag) {
					communicateService.cargarPagina(pag).then(function(){
						$scope.listMessages = communicateService;
						console.log($scope.listMessages);
					});
				};
			};*/

		}
	]);


})(window.angular);
