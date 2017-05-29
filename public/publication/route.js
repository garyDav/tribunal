(function(angular) {
	'use strict';

	angular.module('publicationModule')
	.config(['$routeProvider',function($routeProvider) {
		$routeProvider.
			when('/admin/noticias',{
				templateUrl: 'public/publication/views/admin.noticias.view.html',
				controller: 'publicationCtrl'
			}).
			when('/admin/efemerides',{
				templateUrl: 'public/publication/views/admin.efemerides.view.html',
				controller: 'publicationCtrl'
			}).
			when('/admin/avisos',{
				templateUrl: 'public/publication/views/admin.avisos.view.html',
				controller: 'publicationCtrl'
			}).
			when('/admin/reglamentos',{
				templateUrl: 'public/publication/views/admin.reglamentos.view.html',
				controller: 'publicationCtrl'
			}).
			when('/admin/normativas',{
				templateUrl: 'public/publication/views/admin.normativas.view.html',
				controller: 'publicationCtrl'
			}).
			when('/noticias',{
				templateUrl: 'public/publication/views/list.noticias.view.html',
				controller: 'publicationCtrl'
			}).
			when('/efemerides',{
				templateUrl: 'public/publication/views/list.efemerides.view.html',
				controller: 'publicationCtrl'
			}).
			when('/avisos',{
				templateUrl: 'public/publication/views/list.avisos.view.html',
				controller: 'publicationCtrl'
			}).
			when('/reglamentos',{
				templateUrl: 'public/publication/views/list.reglamentos.view.html',
				controller: 'publicationCtrl'
			}).
			when('/normativas',{
				templateUrl: 'public/publication/views/list.normativas.view.html',
				controller: 'publicationCtrl'
			});
	}]);


})(window.angular);