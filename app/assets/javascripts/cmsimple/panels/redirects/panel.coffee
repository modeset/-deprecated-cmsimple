class CMSimple.Panels.Redirects extends Mercury.Panel

  @toggle: (region)->
    @instance ?= new CMSimple.Panels.Redirects()
    @instance.toggle()

  constructor: ()->
    super(null, 'redirects', title: 'Redirects', closeButton: true)
    @loadContent JST['cmsimple/views/redirects']()
    @setElements()
    @bindPanelEvents()

    @form = new CMSimple.Panels.Redirects.Form($('.add-redirect-form'))

    CMSimple.Path.bind 'refresh change', => @render()

    if CMSimple.Page.count() > 1
      CMSimple.Path.fetch()
    else
      CMSimple.Page.one 'refresh', -> CMSimple.Path.fetch()
      CMSimple.Page.fetch()

  render: ->
    @list.html('')
    @addPath path for path in CMSimple.Path.allRedirects()

  addPath: (path)->
    @list.append(JST['cmsimple/views/redirects_path'](path))

  toggle: ->
    super
    @resize() if @visible

  setElements: ->
    @button = $('.mercury-redirects-button')
    @list = $('ul.redirects', @el)

  bindPanelEvents: ->

  # Overwriting the bindEvents to prevent the mousedown trap in the parent class
  bindEvents: ->
    Mercury.on 'resize', => @position(@visible)

    Mercury.on 'hide:panels', (event, panel) =>
      return if panel == @
      @button.removeClass('pressed')
      @hide()

    @titleElement.find('.mercury-panel-close').on 'click', (event) ->
      event.preventDefault()
      Mercury.trigger('hide:panels')


