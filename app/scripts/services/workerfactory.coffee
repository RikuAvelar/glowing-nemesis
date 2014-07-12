'use strict'

###*
 # @ngdoc service
 # @name pfdbApp.WorkerFactory
 # @description
 # # WorkerFactory
 # Returns a promise-oriented Web Worker Constructor
###
angular.module('pfdbApp')
  .factory 'WorkerFactory', ($q, $timeout) ->

    BASE_PATH = '/scripts/workers/'

    class PromisingWorker
      constructor: (@scriptName, isAbsoluteUrl = false) ->
        @BASE_PATH = BASE_PATH
        this.scriptPath = if isAbsoluteUrl then @scriptName else BASE_PATH + @scriptName

      # Create a new worker, andd return a promise that it will finish
      run: (post) ->
        deferred = $q.defer()
        script = if @isAbsoluteUrl then @scriptName else @BASE_PATH + @scriptName
        worker = new Worker @script

        terminator = ->
          # after 5 minutes, force terminate the worker
          $timeout ->
            worker.terminate()
          , 5 * 60 * 1000

        workerTimeout = terminator()

        worker.addEventListener "message", (result) ->
          if result.state is 'complete'
            deferred.resolve result.data
          else
            $timeout.cancel(workerTimeout)
            workerTimeout = terminator
            deferred.notify result.data

        worker.postMessage post
        deferred.promise
