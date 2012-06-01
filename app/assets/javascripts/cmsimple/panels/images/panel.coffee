class CMSimple.Panels.ImageLibrary extends Mercury.Panel

  constructor: ()->
    super(null, 'insertMedia', title: 'Image Library', appendTo: '.mercury-toolbar-container', closeButton: true)
    @button = $('.mercury-insertMedia-button')
    @loadContent JST['cmsimple/views/image_library']()

    @list = new CMSimple.Panels.ImageLibrary.List($('ul.media-grid'))

    @list.bind 'image:selected', (img)=>
      options = {value: img}
      @region.execCommand 'insertImage', options

    @bindPanelEvents()

  toggle: ->
    super
    if @visible
      CMSimple.Image.fetch()
      @resize()

  bindPanelEvents: ->
    $('#add_image', @element).on('click', @toggleUploader)
    $(window).bind 'cmsimple:images:uploaded', => @imageUploaded()

    Mercury.on 'region:focused', (event, options) =>
      @region = options.region

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

