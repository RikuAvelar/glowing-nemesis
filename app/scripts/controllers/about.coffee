'use strict'

###*
 # @ngdoc function
 # @name pfdbApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the pfdbApp
###
angular.module('pfdbApp')
  .controller 'AboutCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
