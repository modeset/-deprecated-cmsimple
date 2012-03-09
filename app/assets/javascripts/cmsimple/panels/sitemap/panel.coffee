class CMSimple.Panels.Sitemap
  @toggle: (region)->
    @instance ?= new CMSimple.Panels.Sitemap.Panel()
    @instance.toggle()

class CMSimple.Panels.Sitemap.Panel extends Mercury.Panel
  constructor: ->
    super(null, 'Sitemap', title: 'Site Map', appendTo: '.mercury-toolbar-container', closeButton: true)
    @button = $('.mercury-sitemap-button')
    @render()
    @initializeTree()

  initializeTree: ->
    @tree = new CMSimple.Panels.Sitemap.Tree(@element)

  render: ->
    @loadContent JST['cmsimple/views/sitemap']()
    @resize()

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

  toggle: ->
    @tree.refresh() unless @visible
    super

