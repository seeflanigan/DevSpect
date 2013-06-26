class CumulativeFlow
  http = require('http')

  initialize: (project_name) ->
    @databaseName = project_name

  findAll: (callback) ->
    url = "http://localhost:4567/cfd"

    http.get(url, (res) ->
      body = ""
      res.on "data", (chunk) ->
        body += chunk

      res.on "end", ->
        data = JSON.parse(body)

        records = for key, value of data
          record = { points: value }
          record.date = new Date(key)
          record

        callback null, records

    ).on "error", (e) ->
      console.log "Got error: " + e.message

exports.CumulativeFlow = CumulativeFlow
