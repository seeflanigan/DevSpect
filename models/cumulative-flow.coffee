class CumulativeFlow
  http = require('http')

  initialize: (project_name) ->
    @databaseName = project_name

  findAll: (callback) ->
    api_base_url = process.env.DEVSPECT_API_BASE_URL || 'http://localhost:4567'

    console.log api_base_url

    url = "#{ api_base_url }/cfd"

    http.get(url, (res) ->
      body = ""
      res.on "data", (chunk) ->
        body += chunk

      res.on "end", ->

        callback null, body

    ).on "error", (e) ->
      console.log "Got error: " + e.message

exports.CumulativeFlow = CumulativeFlow
