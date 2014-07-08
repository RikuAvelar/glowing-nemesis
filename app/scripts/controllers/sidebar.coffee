'use strict'

###*
 # @ngdoc function
 # @name pfdbApp.controller:SidebarCtrl
 # @description
 # # SidebarCtrl
 # Controller of the pfdbApp
###
angular.module('pfdbApp')
  .controller 'SidebarCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
