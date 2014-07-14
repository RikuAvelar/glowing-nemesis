'use strict'

###*
 # @ngdoc function
 # @name pfdbApp.controller:DatabasedownloadCtrl
 # @description
 # # DatabasedownloadCtrl
 # Controller of the pfdbApp
###
angular.module('pfdbApp')
  .controller 'DatabasedownloadCtrl', ($scope, WorkerFactory) ->
    fetcher = new WorkerFactory('spreadsheetFetcher')

    connectDB = (type, db) ->
    	db.hasLocal = db.storage.store(type);

    fetchDB = (type, db) ->
    	fetcher.run db.key
    		.then (data) -> db.storage.insert data

    $scope.databases =
    	feats: 
    		key: '0AhwDI9kFz9SddEJPRDVsYVczNVc2TlF6VDNBYTZqbkE'
    		storage: TAFFY()

    connectDB for type, db of $scope.databases

    $scope.fetchAll = ->
    	fetchDB for type, db of $scope.databases