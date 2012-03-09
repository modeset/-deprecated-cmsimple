class CMSimple.Panels.ImageLibrary extends Mercury.Panel

  @toggle: (region)->
    @instance ?= new CMSimple.Panels.ImageLibrary()
    @instance.toggle()

  constructor: ()->
    super(null, 'insertMedia', title: 'Image Library', appendTo: '.mercury-toolbar-container', closeButton: true)
    @button = $('.mercury-insertMedia-button')
    @loadContent JST['views/image_library']()

    # MK junk!
    @testActions()

  toggle: ->
    super
    @resize() if @visible


  # Gabe, these are some test actions for the info bar and uploader form
  # Let's discuss when you have a chance, need to be optimized a bunch!!
  testActions: ->
    $('.media-actions > .info').on('click', @toggleInfo)
    $('.media-info > .close').on('click', @toggleInfo)
    $('#add_image').on('click', @toggleUploader)


  toggleInfo: (e) ->
    e.preventDefault()
    info = $(e.target).parents('li').first().find('.media-info')[0]
    $(info).toggleClass('active')

  toggleUploader: (e) ->
    target = $(e.target)
    form = $(target.siblings('.add-image-action')[0])
    form.toggleClass('active')
    if form.hasClass('active') then target.text('Cancel') else target.text('Add Image')

