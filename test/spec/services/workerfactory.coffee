'use strict'

describe 'Service: WorkerFactory', ->

  # load the service's module
  beforeEach module 'pfdbApp'

  # instantiate service
  WorkerFactory = {}
  $timeout = {}
  SavedWorker = Worker
  $rootScope = {}

  beforeEach ->
    listener = ->
    window.Worker = class FakeWorker
      addEventListener: (type, cb) ->
        listener = cb
      postMessage: ->
        listener {state: 'progress', data: {}}
        listener {state: 'complete', data: true}

    inject (_WorkerFactory_, _$timeout_, _$rootScope_) ->
      WorkerFactory = _WorkerFactory_
      $timeout = _$timeout_
      $rootScope = _$rootScope_

  afterEach ->
    window.Worker = SavedWorker

  it 'should return a promise when run', ->
    Worker = new WorkerFactory "scriptName.js"
    callback = jasmine.createSpy "callback"
    promise = Worker.run()
      .then callback

    $rootScope.$apply()

    expect callback
      .toHaveBeenCalledWith true

