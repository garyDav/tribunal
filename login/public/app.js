(function(angular){

	'use strict';
	var app = angular.module('loginModule',['ngResource','ngRoute','angular-loading-bar','jcs-autoValidate']);

	/*app.config(['$locationProvider',function($locationProvider) {
		$locationProvider.html5Mode(true);
	}]);*/

	angular.module('jcs-autoValidate').run([
		'defaultErrorMessageResolver',
		function (defaultErrorMessageResolver) {
			// To change the root resource file path
			
			defaultErrorMessageResolver.setI18nFileRootPath('../app/lib');
			defaultErrorMessageResolver.setCulture('es-CO');

			defaultErrorMessageResolver.getErrorMessages().then(function (errorMessages) {
				/*errorMessages['edadMinima'] = 'Debe de ser mayor a {0} años de edad.';
				errorMessages['edadMaxima'] = 'Debe de ser menor a {0} años de edad.';*/
			});
		}
	]);


	app.config(['cfpLoadingBarProvider',function(cfpLoadingBarProvider) {
		cfpLoadingBarProvider.includeSpinner = true;
	}]);

	app.config(['$routeProvider',function($routeProvider) {
		$routeProvider.
			when('/',{
				templateUrl: 'public/views/signin.view.html'
			}).
			when('/404',{
				templateUrl: 'public/views/404.view.html'
			}).
			otherwise({
				redirectTo: '/404'
			});
	}]);

	app.factory('loginService', ['$http','$q', function( $http, $q ){
		var self = {
			login: function( datos ){
				var d = $q.defer();
				$http.post('../rest/v1/login/', datos)
					 .success(function( data ){

					 	console.log( data );
					 	d.resolve( data );


					 });
				return d.promise;
			}
		};
		return self;
	}]);

	app.controller('mainCtrl', ['$scope','loginService', function($scope,loginService){
		console.log('enter function mainCtrl');
		$scope.invalid = false;
		$scope.load = false;
		$scope.message = '';

		$scope.data = {};
		$scope.$watch( 'data.email',function() {
			$scope.invalid = false;
		} );
		$scope.$watch( 'data.pwd',function() {
			$scope.invalid = false;
		} );

		$scope.ingresar = function( valid,data ) {

			$scope.invalid = false;
			$scope.load = true;
			$('#load').modal('show');

			loginService.login( data ).then(
				function( data ) {
					console.log(data);
					if( data.error.length > 1 ) {
						$scope.invalid = true;
						$scope.load = false;
						$scope.message = data.error;
						$('#load').modal('hide');
					} else {
						console.log( data );
						window.location = '../';
					}
				});

		};
		$scope.cancelar = function() {
			$scope.invalid = false;
		};

	}]);




})(window.angular);

