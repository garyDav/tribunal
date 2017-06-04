// ================================================
//   Controlador de usuarios
// ================================================
angular.module('publicationModule').controller('publicationCtrl', ['$scope', '$rootScope', 'publicationService', 'uploadPub' , 
	function($scope, $rootScope, publicationService,uploadPub){

		$scope.activar('mPublication','','Publicacion','lista de publicaciones');
		$scope.publication   = {};
		$scope.pubSel 		 = {
			id : '',
			id_user : '',
			doc : '',
			cod : '',
			title : '',
			description : '',
			type : '',
			img : ''
		};
		$scope.dep_ja 		 = {};
		$scope.load 		 = true;

		$scope.find = function(type) {
			$scope.load = true;

			$scope.moverA = function( pag ){
				publicationService.cargarPagina( pag,type ).then( function(){
					$scope.publication = publicationService;
					$scope.load = false;
				});
			};
			$scope.moverA(1);

			publicationService.cargarDepJa().then( function(data) {
				$scope.dep_ja = data;
			});
		};

		// ================================================
		//   Mostrar modal de publicacion
		// ================================================
		$scope.mostrarModal = function( modal,pub ){
			//angular.copy( pub, $scope.pubSel );
			console.log(pub);
			$scope.pubSel = {
				id : pub.id,
				id_user : $rootScope.userID,
				doc : pub.doc,
				cod : pub.cod,
				title : pub.title,
				description : pub.description,
				type : pub.type,
				img : pub.img,
				dest: pub.destinatario
			};
			//$scope.$apply();
			console.log($scope.pubSel);
			$(modal).modal();
		};

		// ================================================
		//   Funcion para guardar
		// ================================================
		$scope.guardarAvisos = function( pub, frmPublicacion, type, modal){
			if(type=='noticia')
				pub.type='noticia';
			if(type=='efemerides')
				pub.type='efemerides';
			$scope.pubSel = {
				id : pub.id,
				id_user : $rootScope.userID,
				doc : '',
				cod : pub.cod,
				title : pub.title,
				description : pub.description,
				type : pub.type,
				img : pub.img
			};
			console.log($scope.pubSel);
			if( typeof $scope.pubSel.img == 'object' )
				uploadPub.saveImg($scope.pubSel.img).then(function( data ) {
					if ( data.error == 'not' ) {
						$scope.pubSel.img = data.src;
						publicationService.guardar( $scope.pubSel,type ).then(function(){
							// codigo cuando se inserto o actualizo
							$(modal).modal('hide');
							$scope.pubSel = {};

							frmPublicacion.autoValidateFormOptions.resetForm();
						});
					} else 
					if ( data.error == 'yes' )
						swal("ERROR", "¡"+data.msj+"!", "error");
					else {
						swal("ERROR SERVER", "¡"+data+"!", "error");
						console.error(data);
					}
				});
			else {
				console.log('Enter function');
				publicationService.guardar( $scope.pubSel,type ).then(function(){
					// codigo cuando se inserto o actualizo
					$(modal).modal('hide');
					$scope.pubSel = {};

					frmPublicacion.autoValidateFormOptions.resetForm();
				});
			}

		};


		$scope.guardarNorRe = function( pub, frmPublicacion, type, modal){
			pub.type=type;
			$scope.pubSel = {
				id : pub.id,
				id_user : $rootScope.userID,
				doc : pub.doc,
				cod : pub.cod,
				title : pub.title,
				description : pub.description,
				type : pub.type,
				img : ''
			};
			console.log($scope.pubSel);
			if( typeof $scope.pubSel.doc == 'object' )
				uploadPub.saveDoc($scope.pubSel.doc).then(function( data ) {
					if ( data.error == 'not' ) {
						$scope.pubSel.doc = data.src;
						publicationService.guardar( $scope.pubSel,type ).then(function(){
							// codigo cuando se inserto o actualizo
							$(modal).modal('hide');
							$scope.pubSel = {};

							frmPublicacion.autoValidateFormOptions.resetForm();
						});
					} else 
					if ( data.error == 'yes' )
						swal("ERROR", "¡"+data.msj+"!", "error");
					else {
						swal("ERROR SERVER", "¡"+data+"!", "error");
						console.error(data);
					}
				});
			else {
				publicationService.guardar( $scope.pubSel,type ).then(function(){
					// codigo cuando se inserto o actualizo
					$(modal).modal('hide');
					$scope.pubSel = {};

					frmPublicacion.autoValidateFormOptions.resetForm();
				});
			}

		};
		// ================================================
		//   Funcion para eliminar
		// ================================================
		$scope.eliminar = function( id ){

			swal({
				title: "¿Esta seguro de dar de baja al usuario?",
				text: "¡Si confirma esta acción dara de baja al usuario!",
				type: "warning",
				showCancelButton: true,
				confirmButtonColor: "#DD6B55",
				confirmButtonText: "Si, Desactivar!",
				closeOnConfirm: false
			},
			function(){
				publicationService.eliminar( id ).then(function(data){
					if( data.error == 'not')
						swal("¡Correcto!", "ID: "+data.id+" "+data.msj, "success");
					else {
						swal("ERROR SERVER", "¡"+data+"!", "error");
						console.error(data);
					}
				});
			});

		};

	}
]);


angular.module('publicationModule').controller('pubInstructivoCtrl', ['$scope','publicationService',
	function($scope, publicationService) {
		console.log('pubInstructivoCtrl');
		$scope.activar('mAvisos','mInstructivo','Instructivos','');

		$scope.publication   = {};
		$scope.comment       = {
			id_publication : '',
			id_user        : '',
			description    : ''
		};
		$scope.load 		 = true;

		$scope.moverA = function( pag ){
			publicationService.cargarPaginaReverse( pag,'instructivo' ).then( function(){
				$scope.publication = publicationService;
				$scope.load = false;
				console.log($scope.publication.pub[0]);
			});
		};
		$scope.moverA(1);

		$scope.mostrarModal = function(pubId){
			$('#PubImagen'+pubId).modal();
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

	}
]);

angular.module('publicationModule').controller('pubCircularCtrl', ['$scope','publicationService',
	function($scope, publicationService) {
		console.log('pubCircularCtrl');
		$scope.activar('mAvisos','mCircular','Circulares','');

		$scope.publication   = {};
		$scope.load 		 = true;

		$scope.moverA = function( pag ){
			publicationService.cargarPaginaReverse( pag,'circular' ).then( function(){
				$scope.publication = publicationService;
				$scope.load = false;
				console.log($scope.publication);
			});
		};
		$scope.moverA(1);

		$scope.comentar = function(pubId,userId,coment,form) {
			console.log(pubId+' '+userId+' '+coment);
		}
	}
]);

angular.module('publicationModule').controller('pubComunicadoCtrl', ['$scope','publicationService',
	function($scope, publicationService) {
		console.log('pubComunicadoCtrl');
		$scope.activar('mAvisos','mComunicado','Comunicados','');

		$scope.publication   = {};
		$scope.load 		 = true;

		$scope.moverA = function( pag ){
			publicationService.cargarPaginaReverse( pag,'comunicado' ).then( function(){
				$scope.publication = publicationService;
				$scope.load = false;
				console.log($scope.publication);
			});
		};
		$scope.moverA(1);
	}
]);

angular.module('publicationModule').controller('pubNormativaCtrl', ['$scope','publicationService',
	function($scope, publicationService) {
		console.log('pubNormativaCtrl');
		$scope.activar('mNormativa','','Normativas','');

		$scope.publication   = {};
		$scope.load 		 = true;

		$scope.moverA = function( pag ){
			publicationService.cargarPaginaReverse( pag,'normativa' ).then( function(){
				$scope.publication = publicationService;
				$scope.load = false;
				console.log($scope.publication);
			});
		};
		$scope.moverA(1);
	}
]);

angular.module('publicationModule').controller('pubReglamentoCtrl', ['$scope','publicationService',
	function($scope, publicationService) {
		console.log('pubReglamentoCtrl');
		$scope.activar('mReglamento','','Reglamentos','');

		$scope.publication   = {};
		$scope.load 		 = true;

		$scope.moverA = function( pag ){
			publicationService.cargarPaginaReverse( pag,'reglamento' ).then( function(){
				$scope.publication = publicationService;
				$scope.load = false;
				console.log($scope.publication);
			});
		};
		$scope.moverA(1);
	}
]);
