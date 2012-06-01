class CMSimple.Panels.Versions extends Mercury.Panel

  constructor: ()->
    super(null, 'historyPanel', title: 'History', closeButton: true)

    @button = $('.mercury-historyPanel-button')

    @loadContent JST['cmsimple/views/versions']()
    @panelActions = $('.panel-actions', @element)
    @viewCurrentButton = $('.view-current', @panelActions)

    @list = new CMSimple.Panels.Versions.List($('ul.versions', @element))
    @list.bind 'viewVersion', => @showActionsPanel()

    @bindPanelEvents()

  toggle: ->
    super
    if @visible
      CMSimple.Version.fetch(CMSimple.Editor.current_page)
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

  bindPanelEvents: ->
    @viewCurrentButton.on 'click', (e)=> @reset()

  reset: ->
    @list.reset()
    @panelActions.hide()
    CMSimple.Editor.current_page.reload()

  showActionsPanel: ->
    @panelActions.show()

