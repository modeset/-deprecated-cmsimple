class CMSimple.Panels.Sitemap extends Mercury.Panel
  @toggle: (region)->
    @instance ?= new CMSimple.Panels.Sitemap()
    @instance.toggle()

  constructor: ()->
    super(null, 'Sitemap', title: 'Site Map', appendTo: '.mercury-toolbar-container', closeButton: true)
    @button = $('.mercury-sitemap-button')

  toggle: ->
    super
    @refresh() if @visible

  refresh: ->
    CMSimple.Page.one 'refresh', => @render()
    CMSimple.Page.fetch()

  render: ->
    @loadContent JST['views/sitemap'](pages: CMSimple.Page.all())
    @bindLinks()
    @resize()

  bindLinks: ->
    $('a', @element).click (e)->
      e.preventDefault()
      Spine.Route.navigate($(e.target).attr('href'))

