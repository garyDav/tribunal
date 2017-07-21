(function(angular){

	angular.module('cumpleModule')
	.config(['$routeProvider',function($routeProvider) {
		$routeProvider.
			when('/felicitar',{
				templateUrl: 'public/cumple/views/list.view.html',
				controller: 'cumpleCtrl'
			});
	}])

} )(window.angular);
