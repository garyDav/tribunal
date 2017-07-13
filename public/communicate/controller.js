(function(angular) {

	'use strict';
	angular.module('communicateModule').controller('communicateCtrl',['$scope','communicateService','$rootScope','$routeParams',
		function($scope,communicateService,$rootScope,$routeParams) {
			$scope.find = function() {
				$scope.listMessages = {};
				$scope.load 		= true;
				$scope.mensajes 	= ''; 

				$scope.moverA = function(pag) {
					communicateService.cargarPagina(pag).then(function(){
						$scope.load = false;
						$scope.listMessages = communicateService;
						if( $scope.listMessages.mNoLeidos == 1 )
							$scope.mensajes = 'mensaje no leido';
						else
							$scope.mensajes = 'mensajes no leidos';
						//console.log($scope.listMessages);
					});
				};
				$scope.moverA(1);
			};
			$scope.findAll = function() {
				$scope.activar('','','Mensajes','');
				$scope.listAllMessages = [];
				$scope.userM 		   = [];
				$scope.userSel 		   = {};
				$scope.listMessagesId = {
					name: '',
					last_connection: '',
					messages: []
				};
				$scope.myMessage = {
					id_use: '',
					id_usr: '',
					message: ''
				};
				$scope.loadAll = true;
				$scope.loadMessage = true;
				var pag = $routeParams.id;
				
				/*communicateService.loadAllMessages().then(function( response ){
					$scope.loadAll = false;
					$scope.listAllMessages = response;
					console.log($scope.listAllMessages);
				});*/


				$scope.moverMen = function(pag) {
					communicateService.cargarPagina(pag).then(function(){
						$scope.loadAll = false;
						$scope.listAllMessages = communicateService;
						//console.log($scope.listAllMessages);
					});
				};
				$scope.moverMen(1);

				$scope.loadAllMessage = function(id) {
					$scope.loadMessage = true;
					$scope.myMessage.id_usr = id;
					$scope.myMessage.message = '';
					communicateService.loadAllMessages(id).then(function( response ) {
						if(response[0]) {
							$scope.loadMessage = false;
							$scope.listMessagesId = {
								name: communicateService.userDate.name+' '+communicateService.userDate.last_name,
								last_connection: communicateService.userDate.last_connection,
								messages: response
							};
							//console.log($scope.listMessagesId);
						}
					});
					//communicateService.loadAllMessages(id);
				};

				$scope.loadAllMessage(pag);

				$scope.sendMessage = function(form,myMessage) {
					myMessage.id_use = $rootScope.userID;
					communicateService.saveMessage(myMessage).then(function(response) {
						$scope.loadAllMessage(myMessage.id_usr);
						myMessage.message = '';
					});
				};

				$scope.sendMessageNew = function(form,myMessage) {
					myMessage.id_use = $rootScope.userID;
					communicateService.saveMessage(myMessage).then(function(response) {
						//$scope.loadAllMessage(myMessage.id_usr);
						myMessage.message = '';
						if ( response.error == 'not' ) {
							swal("CORRECTO", "¡"+response.msj+"!", "success");
						}
						console.log(response);
					});
				};

				communicateService.cargarUsers().then(function(response) {
					$scope.userM = response;
					console.log(response);
				});

				$scope.newMessage= function( user,id ) {
					user.id_usr = id;
					//console.log(user);
				};

			};

		}
	]);


})(window.angular);
