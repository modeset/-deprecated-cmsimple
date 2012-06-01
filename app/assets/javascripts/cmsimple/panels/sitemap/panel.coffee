class CMSimple.Panels.Sitemap extends Mercury.Panel
  constructor: ->
    super(null, 'Sitemap', title: 'Site Map', appendTo: '.mercury-toolbar-container', closeButton: true)
    @button = $('.mercury-sitemap-button')
    @render()
    @initializeTree()

  initializeTree: ->
    @tree = new CMSimple.Panels.Sitemap.Tree(@element)
    # @tree.bind 'redraw', => @resize()

  render: ->
    @loadContent JST['cmsimple/views/sitemap']()

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
    unless @visible
      @tree.refresh()
    super
    @resize()

