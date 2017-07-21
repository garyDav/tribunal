(function(angular){

	angular.module('galeriaModule')
	.config(['$routeProvider',function($routeProvider) {
		$routeProvider.
			when('/galeria',{
				templateUrl: 'public/galeria/views/list.view.html',
				controller: 'galeriaCtrl'
			});
	}])

} )(window.angular);
