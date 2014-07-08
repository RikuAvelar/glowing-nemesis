'use strict'

###*
 # @ngdoc service
 # @name pfdbApp.WorkerFactory
 # @description
 # # WorkerFactory
 # Returns a promise-oriented Web Worker Constructor
###
angular.module('pfdbApp')
  .factory 'WorkerFactory', ($q) ->

    class PromisingWorker
      constructor: (@script) ->

      # Create a new worker, andd return a promise that it will finish
      run: (post) ->
        deferred = $q.defer()
        worker = new Worker @script
        worker.addEventListener "message", (result) ->
          if result.state is 'complete'
            deferred.resolve result.data
          else
            deferred.notify result.data

        worker.postMessage post
        deferred.promise
