'use strict'

describe 'Controller: DatabasedownloadCtrl', ->

  # load the controller's module
  beforeEach module 'pfdbApp'

  DatabasedownloadCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    DatabasedownloadCtrl = $controller 'DatabasedownloadCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
