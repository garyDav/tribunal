(function(angular){

	angular.module('communicateModule')
	.config(['$routeProvider',function($routeProvider) {
		$routeProvider.
			when('/mensajes/:id',{
				templateUrl: 'public/communicate/views/list.view.html',
				controller: 'communicateCtrl'
			});
	}])

} )(window.angular);