(function(angular) {

	'use strict';
	var app = angular.module('tribunalModule',['ngResource','ngRoute','angular-loading-bar','jcs-autoValidate','userModule']);

	app.config(['$locationProvider',function($locationProvider) {
		$locationProvider.html5Mode(true);
	}]);
	app.config(['cfpLoadingBarProvider',function(cfpLoadingBarProvider) {
		cfpLoadingBarProvider.includeSpinner = true;
	}]);

	app.config(['$routeProvider',function($routeProvider) {
		$routeProvider.
			when('/',{
				templateUrl: 'public/main/views/main.view.html'
			}).
			when('/404',{
				templateUrl: 'public/main/views/404.view.html'
			}).
			otherwise({
				redirectTo: '/404'
			});
	}]);

	app.factory('mainService', ['$http','$location', function( $http,$location ){
		var self = {
			logout: function() {
				$http.post('php/destroy_session.php');
				//$location.path('/login/#/ingresar');
				window.location="http://localhost/tribunal/login/";
			}
		};
		return self;
	}]);

	app.controller('mainCtrl', ['$scope', 'mainService', function($scope,mainService){
		$scope.salir = function() {
			mainService.logout();
			//console.log('Mierda');
		};

	}]);


})(window.angular);