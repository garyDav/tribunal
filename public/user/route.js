(function(angular) {
	'use strict';

	angular.module('userModule')
	.config(['$routeProvider',function($routeProvider) {
		$routeProvider.
			when('/usuarios',{
				templateUrl: 'public/user/views/list.view.html'
			});
	}]);


})(window.angular);