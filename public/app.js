(function(angular) {

	'use strict';
	var app = angular.module('tribunalModule',[
			'ngResource',
			'ngRoute',
			'angular-loading-bar',
			'jcs-autoValidate',
			'userModule'], 
		["$provide", function($provide) {
		var PLURAL_CATEGORY = {ZERO: "zero", ONE: "one", TWO: "two", FEW: "few", MANY: "many", OTHER: "other"};
		$provide.value("$locale", {
		  "DATETIME_FORMATS": {
		    "AMPMS": [
		      "a.m.",
		      "p.m."
		    ],
		    "DAY": [
		      "domingo",
		      "lunes",
		      "martes",
		      "mi\u00e9rcoles",
		      "jueves",
		      "viernes",
		      "s\u00e1bado"
		    ],
		    "MONTH": [
		      "enero",
		      "febrero",
		      "marzo",
		      "abril",
		      "mayo",
		      "junio",
		      "julio",
		      "agosto",
		      "septiembre",
		      "octubre",
		      "noviembre",
		      "diciembre"
		    ],
		    "SHORTDAY": [
		      "dom",
		      "lun",
		      "mar",
		      "mi\u00e9",
		      "jue",
		      "vie",
		      "s\u00e1b"
		    ],
		    "SHORTMONTH": [
		      "ene",
		      "feb",
		      "mar",
		      "abr",
		      "may",
		      "jun",
		      "jul",
		      "ago",
		      "sep",
		      "oct",
		      "nov",
		      "dic"
		    ],
		    "fullDate": "EEEE, d 'de' MMMM 'de' y",
		    "longDate": "d 'de' MMMM 'de' y",
		    "medium": "dd/MM/yyyy HH:mm:ss",
		    "mediumDate": "dd/MM/yyyy",
		    "mediumTime": "HH:mm:ss",
		    "short": "dd/MM/yy HH:mm",
		    "shortDate": "dd/MM/yy",
		    "shortTime": "HH:mm"
		  },
		  "NUMBER_FORMATS": {
		    "CURRENCY_SYM": "\u20ac",
		    "DECIMAL_SEP": ",",
		    "GROUP_SEP": ".",
		    "PATTERNS": [
		      {
		        "gSize": 3,
		        "lgSize": 3,
		        "macFrac": 0,
		        "maxFrac": 3,
		        "minFrac": 0,
		        "minInt": 1,
		        "negPre": "-",
		        "negSuf": "",
		        "posPre": "",
		        "posSuf": ""
		      },
		      {
		        "gSize": 3,
		        "lgSize": 3,
		        "macFrac": 0,
		        "maxFrac": 2,
		        "minFrac": 2,
		        "minInt": 1,
		        "negPre": "-",
		        "negSuf": "\u00a0\u00a4",
		        "posPre": "",
		        "posSuf": "\u00a0\u00a4"
		      }
		    ]
		  },
		  "id": "es-es",
		  "pluralCat": function (n) {  if (n == 1) {   return PLURAL_CATEGORY.ONE;  }  return PLURAL_CATEGORY.OTHER;}
		});
		}]).run([
        'bootstrap3ElementModifier',
        function (bootstrap3ElementModifier) {
              bootstrap3ElementModifier.enableValidationStateIcons(true);
       }]);

	angular.module('jcs-autoValidate')
	.run([
	    'defaultErrorMessageResolver',
	    function (defaultErrorMessageResolver) {
	        // To change the root resource file path
	        defaultErrorMessageResolver.setI18nFileRootPath('app/lib');
	        defaultErrorMessageResolver.setCulture('es-co');

	        defaultErrorMessageResolver.getErrorMessages().then(function (errorMessages) {
	          errorMessages['coincide'] = 'Su contraseña no coincide';
	          errorMessages['parse'] = 'Debe ingresar la nueva contraseña';
	        });
	    }
	]);
	app.directive('coincide', [
            function() {
                return {
                    restrict: 'A',
                    require: 'ngModel',
                    link: function(scope, elm, attrs, ctrl) {
                        var validateFn = function (viewValue) {
                        	if(attrs.coincide)
	                            if (ctrl.$isEmpty(viewValue) || viewValue.indexOf(attrs.coincide) === -1) {
	                                ctrl.$setValidity('coincide', false);
	                                return undefined;
	                            } else {
	                                ctrl.$setValidity('coincide', true);
	                                return viewValue;
	                            }
	                        else {
	                        	ctrl.$setValidity('parse', false);
	                        }
                        };

                        ctrl.$parsers.push(validateFn);
                        ctrl.$formatters.push(validateFn);
                    }
                }
            }]);

	app.config(['$locationProvider',function($locationProvider) {
		$locationProvider.html5Mode(true);
	}]);
	app.config(['cfpLoadingBarProvider',function(cfpLoadingBarProvider) {
		cfpLoadingBarProvider.includeSpinner = true;
	}]);

	app.config(['$routeProvider',function($routeProvider) {
		$routeProvider.
			when('/',{
				templateUrl: 'public/main/views/main.view.html',
				controller: 'principalCtrl'
			}).
			when('/404',{
				templateUrl: 'public/main/views/404.view.html'
			}).
			otherwise({
				redirectTo: '/404'
			});
	}]);

	app.factory('mainService', ['$http','$location','$q','$rootScope', function( $http,$location,$q,$rootScope ){
		var self = {
			logout: function() {
				$http.post('php/destroy_session.php');
				//$location.path('login/#/');
				window.location="login/";
			},
			config:{},
			cargar: function(){
				var d = $q.defer();
				$http.get('configuracion.json')
					.success(function(data){
						self.config = data;
						d.resolve();
					})
					.error(function(){
						d.reject();
						console.error("No se pudo cargar el archivo de configuración");
					});

				return d.promise;
			},
			editarUser: function(user) {
				return $http.put('rest/v1/user/'+user.id,user);
			},
			data: function() {
				var d = $q.defer();

				$http.get('php/data.php' )
					.success(function( data ){
						if(data) {
							if( data.error == 'yes' ) {
								$http.post('php/destroy_session.php');
								window.location="login/";
							} else {
								if(data.error == 'not') {
									$rootScope.userID = data.userID;
									$rootScope.userTYPE = data.userTYPE;
								}
							}

						}
						return d.resolve();
					});

				return d.promise;
			},
			mainUser: function(id) {
				var d = $q.defer();
				$http.get('rest/v1/user/view/'+id)
					.success(function( data ) {
						d.resolve(data);
					});
				return d.promise;
			}
		};
		return self;
	}]);

	app.controller('mainCtrl', ['$scope', 'mainService','$rootScope','upload', function($scope,mainService,$rootScope,upload){
		$scope.config = {};
		$scope.titulo    = "";
		$scope.subtitulo = "";
		$scope.mainUser = {};
		$scope.userSelMain = {};
		$scope.nameImg = "";
		$scope.editUser = {};

		/*$scope.$watch('userSelMain.pwdR',function() {
			if(!$scope.userSelMain.pwdN) {
				$scope.frmUser.autoValidateFormOptions.resetForm();
				console.log($rootScope.frmUser);
			}else
				console.log('joder');
		});*/

		$scope.init = function() {
			mainService.data().then( function(){
				mainService.mainUser($rootScope.userID).then(function( data ) {
					$scope.mainUser = data;
				});				
			});
		};

		$scope.mostrarUserModal = function(){
			$scope.mainUser.cellphone = parseInt($scope.mainUser.cellphone);
			$scope.userSelMain = $scope.mainUser;
			$("#modal_userMain").modal();
		};

		mainService.cargar().then( function(){
			$scope.config = mainService.config;
		});

		$scope.editarUserMain = function(user,frmUser) {
			console.log(user);
			
			if(user.src)
				upload.saveImg(user.src).then(function( data ) {
					if ( data.error == 'not' ) {
						user.src = data.src;
						mainService.editarUser(user).success(function(response){
							$scope.editUser = response;
							if( $scope.editUser.error == 'not' )
								swal("CORRECTO", "¡"+data.msj+" - "+$scope.editUser.msj+"!", "success");
							else
								if ( $scope.editUser.error == 'yes' )
								swal("ERROR", "¡"+$scope.editUser.msj+"!", "error");
							else 
								swal("ERROR SERVER", "¡"+$scope.editUser+"!", "error");
						})
						.error(function(response){
							console.error(response);
						});
					} else 
					if ( data.error == 'yes' )
						swal("ERROR", "¡"+data.msj+"!", "error");
					else 
						swal("ERROR SERVER", "¡"+data+"!", "error");
				});
			else {
				mainService.editarUser(user).success(function(response){
					$scope.editUser = response;
					if( $scope.editUser.error == 'not' )
						swal("CORRECTO", "¡"+$scope.editUser.msj+"!", "success");
					else
						if ( $scope.editUser.error == 'yes' )
						swal("ERROR", "¡"+$scope.editUser.msj+"!", "error");
					else 
						swal("ERROR SERVER", "¡"+$scope.editUser+"!", "error");
				})
				.error(function(response){
					console.error(response);
				});
			}
		};

		// ================================================
		//   Funciones Globales del Scope
		// ================================================
		$scope.activar = function( menu, submenu, titulo, subtitulo ){

			$scope.titulo = "";
			$scope.subtitulo = "";

			$scope.titulo = titulo;
			$scope.subtitulo = subtitulo;

			$scope.mPrincipal = "";

			$scope[menu] = 'active';
		};

		$scope.sidebar = function(control1,control2,control3) {
			$(control1).click();
			$(control1).show();
			
			$(control2).hide();
			$(control3).hide();
		};

		$scope.salir = function() {
			mainService.logout();
		};

	}]);

	// ================================================
	//   Controlador de principal
	// ================================================
	app.controller('principalCtrl', ['$scope', function($scope){
		$scope.activar('mPrincipal','','Principal','información');
	}]);

	// ================================================
	//   Filtros
	// ================================================
	app.filter( 'quitarletra', function(){

		return function(palabra){
			if( palabra ){
				if( palabra.length > 1)
					return palabra.substr(1);
				else
					return palabra;
			}
		}
	});

	// ================================================
	//   Directiva para archivos
	// ================================================
	app.directive('fileModel',['$parse',function($parse) {
		return {
			restrict: 'A',
			link: function(scope, iElement, iAttrs) {
				iElement.on('change',function(e) {
					$parse(iAttrs.fileModel).assign(scope,iElement[0].files[0]);
				});
			}
		};
	}]);


	// ================================================
	//   Servicio para cargar archivos
	// ================================================
	app.service('upload',['$http','$q',function($http,$q) {
		var self = {
			saveImg : function(img) {
				var d = $q.defer();
				var formData = new FormData();
				formData.append('img',img);
				$http.post('php/server.php',formData,{
					headers: { 'Content-Type': undefined }
				}).success(function( data ) {
					d.resolve( data );
				}).error(function(msj, code) {
					d.reject( msj );
				});
				return d.promise;
			}
		};
		return self;
	}]);


})(window.angular);
