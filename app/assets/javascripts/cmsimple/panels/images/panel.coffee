class CMSimple.Panels.ImageLibrary extends Mercury.Panel

  constructor: ()->
    super(null, 'insertMedia', title: 'Image Library', appendTo: '.mercury-toolbar-container', closeButton: true)
    @button = $('.mercury-insertMedia-button')
    @loadContent JST['cmsimple/views/image_library']()

    @list = new CMSimple.Panels.ImageLibrary.List($('ul.media-grid'))
    @selection = new CMSimple.Panels.ImageLibrary.Selection()

    @bindPanelEvents()


  toggle: ->
    super
    if @visible
      CMSimple.Image.fetch()
      @resize()


  bindPanelEvents: ->
    $('#add_image', @element).on('click', @toggleUploader)
    $('.image-filter', @element).on('submit', @filterImages)
    $(window).bind 'cmsimple:images:uploaded', => @imageUploaded()

    @list.bind 'image:selected', (img)=>
      @selection.set(img)

    @selection.bind 'filter', (geometry)=>
      @list.filterByGeometry(geometry)
      $('.filter', @element).val(geometry)


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


  filterImages: (e)=>
    e.preventDefault()
    query = $(e.target).find('input.filter').val()
    if Spine.isBlank(query)
      @list.render()
    else
      @list.filterByGeometry(query)

