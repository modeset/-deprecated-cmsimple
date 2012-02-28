class CMSimple.Panels.ImageLibrary extends Mercury.Panel
  @toggle: (region)->
    @instance ?= new CMSimple.Panels.ImageLibrary()
    @instance.toggle()

  constructor: ()->
    super(null, 'insertMedia', title: 'Image Library', appendTo: '.mercury-toolbar-container', closeButton: true)
    @button = $('.mercury-insertMedia-button')
    @loadContent JST['views/image_library']()

  toggle: ->
    super
    @resize() if @visible
