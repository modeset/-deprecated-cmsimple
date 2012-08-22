#= require cmsimple/models/page
#= require cmsimple/models/path
#= require cmsimple/views/redirects/_path

class CMSimple.Panels.Redirects.List extends Spine.Controller
  events:
    'click a.remove' : 'destroy'

  constructor: (el)->
    super el: $(el)

    CMSimple.Path.bind 'refresh change', => @render()

  refresh: ->
    # TODO: should this be a model method?
    if CMSimple.Page.count() > 1
      CMSimple.Path.fetch()
    else
      CMSimple.Page.one 'refresh', -> CMSimple.Path.fetch()
      CMSimple.Page.fetch()

  render: ->
    @html('')
    @addPath path for path in CMSimple.Path.allRedirects()

  addPath: (path)->
    @append JST['cmsimple/views/redirects/_path'](path)

  destroy: (e)->
    e.preventDefault()
    item = $(e.target)
    id = item.data('id') || $(item.parents('[data-id]')[0]).data('id')
    CMSimple.Path.destroy(id)

