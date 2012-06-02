#= require cmsimple/panels/images/panel
class CMSimple.Panels.ImageLibrary.List extends Spine.Controller
  events:
    'click .media-actions > .info' : 'toggleInfo'
    'click .media-info > .close' : 'toggleInfo'
    'click [data-full-url]' : 'triggerImage'
    'click .delete' : 'deleteImage'

  constructor: (el)->
    super el: $(el)

    CMSimple.Image.bind 'refresh change', => @render()

  render: ->
    @html('')
    @addImage image for image in CMSimple.Image.all()

  filterByGeometry: (geometry)->
    @html('')
    @addImage image for image in CMSimple.Image.allWithinGeometry(geometry)

  addImage: (image)->
    @append JST['cmsimple/views/image_library_item'](image)

  toggleInfo: (e) ->
    e.preventDefault()
    info = $(e.target).parents('li').first().find('.media-info')[0]
    $(info).toggleClass('active')

  triggerImage: (e)->
    img = $(e.target)
    image = CMSimple.Image.find(img.data('id'))
    @trigger 'image:selected',
        src: img.data('full-url'),
        alt: image.title,
        'image-id': image.id

  deleteImage: (e)->
    e.preventDefault()
    link = $(e.target)
    if confirm 'Are you sure you would like to delete this image?'
      id = link.parents('[data-id]').data('id')
      image = CMSimple.Image.find(id)
      image.destroy()

