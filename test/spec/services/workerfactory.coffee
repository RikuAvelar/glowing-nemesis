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
      terminate: jasmine.createSpy 'terminate'

    inject (_WorkerFactory_, _$timeout_, _$rootScope_) ->
      WorkerFactory = _WorkerFactory_
      $timeout = _$timeout_
      $rootScope = _$rootScope_

  afterEach ->
    window.Worker = SavedWorker

  it 'should return a promise when run', ->
    # arrange
    Worker = new WorkerFactory "scriptName"
    callback = jasmine.createSpy "callback"

    # act
    promise = Worker.run()
      .then callback

    $rootScope.$apply()

    # assert
    expect callback
      .toHaveBeenCalledWith true

  it 'should be able to receive either a full path, or a worker name', ->
    # arrange
    localWorker = new Worker 'script'
    externalWorker = new Worker '/externalWorkers/script', true

    #act

    #assert

    expect localWorker.scriptPath
      .toBe "#{localWorker.BASE_PATH}/script"
    expect externalWorker.scriptPath
      .toBe '/externalWorkers/script'

  it 'should automatically terminate unresponsive workers after 5 minutes', ->
    # arrange
    ResponsiveWorker = new Worker 'responsive'
    UnresponsiveWorker = new Worker 'unresponsive'

    jasmine.stub UnresponsiveWorker, 'postMessage'

    # act
    ResponsiveWorker.run()
    UnresponsiveWorker.run()
    $timeout.flush()

    # assert
    expect ResponsiveWorker.terminate
      .not.toHaveBeenCalled()
    expect UnresponsiveWorker.terminate
      .toHaveBeenCalled()
