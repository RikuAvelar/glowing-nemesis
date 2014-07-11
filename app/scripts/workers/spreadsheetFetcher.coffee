'use strict'

baseUrl = '../../bower_components/'

importScript baseUrl + 'lodash/dist/lodash.min.js', baseUrl + 'jquery/dist/jquery.min.js', baseUrl + 'taffydb/taffy.js'

fetch = (url) ->
	fetchPromise = $.getJSON url

self.addEventListener 'message', (url) ->
	fetch url
		.then (rawData) ->
			_.map rawData.feed.entry, (row) ->
				cleanRow = _.pick row, (key) -> key.indexOf 'gsx$' is 0

				keys = _.chain cleanRow 
					.keys()
					.map (key) -> key.substring 4
					.value()

				values = _.values cleanRow

				_.zipObject keys values
		.then (cleanData) ->
			self.postMessage cleanData