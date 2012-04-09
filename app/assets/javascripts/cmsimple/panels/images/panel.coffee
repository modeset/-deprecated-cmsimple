class CMSimple.Panels.ImageLibrary extends Mercury.Panel

  @toggle: (region)->
    @instance ?= new CMSimple.Panels.ImageLibrary()
    @instance.toggle(region)

  constructor: ()->
    super(null, 'insertMedia', title: 'Image Library', appendTo: '.mercury-toolbar-container', closeButton: true)
    @button = $('.mercury-insertMedia-button')
    @loadContent JST['cmsimple/views/image_library']()

    @list = new CMSimple.Panels.ImageLibrary.List($('ul.media-grid'))

    @list.bind 'image:selected', (img)=>
      options = {value: img}
      @region.execCommand 'insertImage', options

    @bindPanelEvents()

  toggle: (region)->
    @region = region
    super
    @resize() if @visible

  bindPanelEvents: ->
    $('#add_image', @element).on('click', @toggleUploader)
    $(window).bind 'cmsimple:images:uploaded', => @imageUploaded()

  toggleUploader: (e) ->
    target = $(e.target)
    form = $('.add-image-action', @element)
    form.toggleClass('active')
    if form.hasClass('active')
      target.text('Cancel')
    else
      target.text('Add Image')

  imageUploaded: ->
    CMSimple.Image.fetch()
    @closeUploader()

  closeUploader: ->
    $('#add_image', @element).text('Add Image')
    $('.add-image-action', @element).removeClass('active')

