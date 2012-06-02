class CMSimple.Panels.ImageLibrary.Selection extends Spine.Controller
  constructor: ->
    super
    @bindEvents()


  set: (img)->
    if @selectedImage
      @selectedImage.attr('src', img.src)
      snippet = Mercury.Snippet.find @selectedImage.parents('[data-snippet]').data('snippet')
      snippet.options.snippet[@selectedImage.data('snippet-image')] = img.src

    else if @region.type == 'editable'
      options = {value: img}
      @region.execCommand 'insertImage', options


  clearSelection: ->
    if @selectedImage
      @selectedImage.removeClass('selected-image')
      @selectedImage = null
      @trigger 'filter', null


  setSelection: (el)->
    @selectedImage?.removeClass('selected-image')
    @selectedImage = el
    @selectedImage.addClass('selected-image')
    if geometry = @selectedImage.data('image-geometry')
      @trigger 'filter', geometry


  bindEvents: ->
    Mercury.on 'region:focused', (event, options) =>
      @bindRegion(options.region)


  bindRegion: (region)->
    _clearSelection = => @clearSelection()
    if @region
      # unbind current region if user selected a new region
      @region.element.off 'click', _clearSelection
      @region.element.find('[data-snippet-image]').off('click')

    if @region = region
      @region.element.on 'click', _clearSelection
      @region.element.find('[data-snippet-image]').on 'click', (e)=>
        e.stopPropagation()
        @setSelection($(e.target))


