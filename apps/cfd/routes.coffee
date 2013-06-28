Project = require('../../models/project').Project
CumulativeFlow = require('../../models/cumulative-flow').CumulativeFlow
{upperFirst, toDateFormat} = require '../formatters'

accessAllowed = (req, res, next) ->
  project_name = req.params.project

  if req.isAuthenticated()
    for proj in req.user.projects when proj._id == "project/#{project_name}"
        return next()

  prj = new Project project_name
  prj.isPublic (err, found) ->
    return next() if found
    req.flash 'error', ' You do not have access to this project.'
    res.redirect '/'

routes = (app) ->
  app.get '/cfd/:project?', accessAllowed, (req, res) ->
    project_name = req.params.project
    cfd = new CumulativeFlow project_name
    cfd.findAll (err, docs) ->
      if (err)
        res.render "#{__dirname}/views/index",
          title: 'Cumulative Flow Diagram'
          charttitle: 'Project Does Not Exist'
          stylesheet: 'cfd'
          err: err
          cfds: null
          series: JSON.stringify(series)

      prj = new Project project_name

      prj.displayName (err, display_name) ->
        if (err)
          display_name = project_name

        res.render "#{__dirname}/views/index",
          title: 'Cumulative Flow Diagram'
          charttitle: upperFirst(display_name)
          stylesheet: 'cfd'
          err: err
          cfds: docs
          series: docs

module.exports = routes
