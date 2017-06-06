(function(angular) {

	'use strict';
	var app = angular.module('tribunalModule',[
			'ngResource',
			'ngRoute',
			'angular-loading-bar',
			'jcs-autoValidate',
			'userModule',
			'publicationModule'], 
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
                        	if(attrs.coincide != '')
	                            if (ctrl.$isEmpty(viewValue) || viewValue.indexOf(attrs.coincide) === -1) {
	                                ctrl.$setValidity('coincide', false);
	                                return undefined;
	                            } else {
	                                ctrl.$setValidity('coincide', true);
	                                return viewValue;
	                            }
	                        /*else {
	                        	ctrl.$setValidity('parse', false);
	                        }*/
                        };

                        ctrl.$parsers.push(validateFn);
                        ctrl.$formatters.push(validateFn);
                    }
                };
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

		/*$scope.$watch('userSelMain.pwdN',function() {
			if(!$scope.userSelMain.pwdA)
				swal("ERROR", "¡Antes debe ingresar su contraseña atigua!", "error");
		});*/

		$scope.init = function() {
			mainService.data().then( function(){
				mainService.mainUser($rootScope.userID).then(function( data ) {
					$scope.mainUser = data;
				});
			});
		};

		$scope.mostrarUserModal = function(){
			$scope.init();
			$scope.userSelMain = {};

			$scope.mainUser.cellphone = parseInt($scope.mainUser.cellphone);
			$scope.userSelMain = $scope.mainUser;
			$("#modal_userMain").modal();
		};

		mainService.cargar().then( function(){
			$scope.config = mainService.config;
		});

		$scope.cancelarUserMain = function(frmUser) {
			location.reload();
		}

		$scope.editarUserMain = function(user,frmUser) {
			if( (user.pwdN != '' || user.pwdR != '') && (user.pwdA == null || user.pwdA == '') ) {
				swal("ERROR", "¡Antes debe ingresar su contraseña atigua!", "error");
			}
			else {
			if(typeof user.src == 'object')
				upload.saveImg(user.src).then(function( data ) {
					if ( data.error == 'not' ) {
						user.src = data.src;
						$scope.mainUser.src = data.src;
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
			$scope.userSelMain = {};

			frmUser.autoValidateFormOptions.resetForm();
			$("#modal_userMain").modal('hide');
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

			$scope.mPrincipal  = '';
			$scope.mAvisos     = '';
			$scope.mInstructivo = '';
			$scope.mCircular   = '';
			$scope.mComunicado = '';
			$scope.mNormativa  = '';
			$scope.mReglamento = '';

			$scope[menu] = 'active';
			$scope[submenu] = 'active';
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
	app.controller('principalCtrl', ['$scope','publicationService', function($scope,publicationService){
		$scope.activar('mPrincipal','','Principal','información');

		$scope.publication   = {};
		$scope.comment       = {
			id_publication : '',
			id_user        : '',
			description    : ''
		};
		$scope.pubPrincipal  = {}
		$scope.load 		 = true;

		console.log($scope.pubPrincipal.length);

		publicationService.cargarPublicacionPrincipal().then( function( data ) {
			$scope.pubPrincipal = data;
		} );

		$scope.moverA = function( pag ){
			publicationService.cargarPaginaReverse( pag,'noticias_efemerides' ).then( function(){
				$scope.publication = publicationService;
				$scope.load = false;
				//console.log($scope.publication);
			});
		};
		$scope.moverA(1);

		$scope.comentarPrincipal = function(pubId,userId,comment,form) {
			$scope.comment = {
				id_publication : pubId,
				id_user        : userId,
				description    : comment
			};
			publicationService.guardarCommnet( $scope.comment ).then(function( data ){
				// codigo cuando se inserto o actualizo
				if ( data.error == 'not' ) {
					$scope.comment = {};
					form.autoValidateFormOptions.resetForm();

					data.fec = new Date(data.fec);
					$scope.pubPrincipal.comentarios.push( data );

					swal("CORRECTO", "¡"+data.msj+"!", "success");
				} else {
					swal("ERROR SERVER", "¡"+data+"!", "error");
				}
			});
		};

		$scope.comentar = function(pubId,userId,comment,form) {
			$scope.comment = {
				id_publication : pubId,
				id_user        : userId,
				description    : comment
			};
			publicationService.guardarCommnet( $scope.comment ).then(function( data ){
				// codigo cuando se inserto o actualizo
				if ( data.error == 'not' ) {
					$scope.comment = {};
					console.log(data);
					form.autoValidateFormOptions.resetForm();
					
					$scope.publication.pub.forEach( function(element,index,array) {
						if( element.id == data.idPub ) {
							data.fec = new Date(data.fec);
							element.comentarios.push( data );
							//console.log(data.fec);
						}
					});

					swal("CORRECTO", "¡"+data.msj+"!", "success");
				} else {
					swal("ERROR SERVER", "¡"+data+"!", "error");
				}
			});
		};


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

	app.filter( 'reducirTexto', function(){
		return function(palabra){
			if( palabra ){
				if( palabra.length > 22)
					return palabra.substr(0,22)+' ...';
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

	app.service('uploadPub',['$http','$q',function($http,$q) {
		var self = {
			saveImg : function(img) {
				var d = $q.defer();
				var formData = new FormData();
				formData.append('img',img);
				$http.post('php/publication.php',formData,{
					headers: { 'Content-Type': undefined }
				}).success(function( data ) {
					d.resolve( data );
				}).error(function(msj, code) {
					d.reject( msj );
				});
				return d.promise;
			},
			saveDoc : function(doc) {
				var d = $q.defer();
				var formData = new FormData();
				formData.append('doc',doc);
				$http.post('php/publicationDoc.php',formData,{
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
