'use strict'

###*
 # @ngdoc function
 # @name pfdbApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the pfdbApp
###
angular.module('pfdbApp')
  .controller 'MainCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
