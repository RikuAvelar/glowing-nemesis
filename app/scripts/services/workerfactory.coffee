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
        worker = new Worker @scriptPath

        terminator = ->
          # after 5 minutes, force terminate the worker
          $timeout ->
            worker.terminate()
          , 5 * 60 * 1000

        workerTimeout = terminator()

        worker.addEventListener "message", (oEvent) =>
          result = oEvent.data
          switch result.status
            when 'complete' then deferred.resolve result.data
            when 'progress'
              $timeout.cancel(workerTimeout)
              workerTimeout = terminator
              deferred.notify result.data
            when 'failed'
              $timeout.cancel(workerTimeout)
              deferred.reject result.data
            else console.log "#{@scriptName} returned state #{result.state} : #{JSON.stringify result.data}"

        worker.postMessage post
        deferred.promise
