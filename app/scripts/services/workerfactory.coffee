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

    class PromisingWorker
      constructor: (@script) ->

      # Create a new worker, andd return a promise that it will finish
      run: (post) ->
        deferred = $q.defer()
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
