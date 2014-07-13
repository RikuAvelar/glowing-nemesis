###*
 # @ngdoc function
 # @name pfdbapp.workers:spreadsheetFetcher
 # @param {key}
 # @description
 # # Spreadsheet Fetcher
 # Returns the json data of a Google Spreadsheet from its key
###
'use strict'

baseImportUrl = '../../bower_components'

importScripts "#{baseImportUrl}/lodash/dist/lodash.min.js", "#{baseImportUrl}/q/q.js", "./utils/twix.js"

fetch = (key) ->
  deferred = Q.defer()
  # xhr = saw.jsonp "//spreadsheets.google.com/feeds/list/#{key}/od6/public/values?alt=json-in-script&callback=sawp"
  xhr = Twix.ajax
      url: "https://spreadsheets.google.com/feeds/list/#{key}/od6/public/values?alt=json"
      success: deferred.resolve
      error: deferred.reject
  xhr.addEventListener 'progress', (oEvent) ->
    deferred.notify oEvent.loaded / oEvent.total if oEvent.lengthComputable
  deferred.promise

self.addEventListener 'message', (oEvent) ->
  key = oEvent.data
  fetch key
    .then (rawData) ->
      cleanData = _.map rawData.feed.entry, (row) ->
        dataRow = _.pick row, (val, key) -> key.indexOf('gsx$') is 0 and val.$t?

        keys = _.chain dataRow
          .keys()
          .map (key) -> key.substring 4
          .value()
        values = _.chain dataRow
          .values()
          .map (cell) -> cell.$t
          .value()
        cleanRow = _.zipObject keys, values

      self.postMessage
        status: 'complete'
        data: cleanData

      self.terminate()
    , (err) ->
      self.postMessage
        status: 'failed'
        data: err
      self.teminate()
    , (completionRate) ->
      self.postMessage
       status: 'progress'
       data: completionRate
