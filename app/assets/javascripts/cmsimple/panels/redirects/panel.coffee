class CMSimple.Panels.Redirects extends Mercury.Panel

  constructor: ()->
    super(null, 'redirects', title: 'Redirects', closeButton: true)
    @button = $('.mercury-redirects-button')
    @loadContent JST['cmsimple/views/redirects']()

    @form = new CMSimple.Panels.Redirects.Form($('.add-redirect-form'))
    @list = new CMSimple.Panels.Redirects.List($('ul.redirects', @element))

  toggle: ->
    super
    if @visible
      @list.refresh()
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


