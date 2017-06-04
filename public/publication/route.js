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






			when('/circulares',{
				templateUrl: 'public/publication/views/users/user.circular.view.html',
				controller: 'pubCircularCtrl'
			}).
			when('/instructivos',{
				templateUrl: 'public/publication/views/users/user.instructivo.view.html',
				controller: 'pubInstructivoCtrl'
			}).
			when('/comunicados',{
				templateUrl: 'public/publication/views/users/user.comunicado.view.html',
				controller: 'pubComunicadoCtrl'
			}).
			when('/normativas',{
				templateUrl: 'public/publication/views/users/user.normativa.view.html',
				controller: 'pubNormativaCtrl'
			}).
			when('/reglamentos',{
				templateUrl: 'public/publication/views/users/user.reglamento.view.html',
				controller: 'pubReglamentoCtrl'
			});
	}]);


})(window.angular);