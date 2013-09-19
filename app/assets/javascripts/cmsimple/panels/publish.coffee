#= require cmsimple/models/page

class CMSimple.Panels.Publish extends Spine.Controller

  elements:
    '.mercury-modal-content' : 'content'

  events:
    'submit form' : 'submit'

  constructor: (container, @modal)->
    super el: container
    @el.off 'ajax:beforeSend'

  submit: (e)->
    e.preventDefault()
    form = $(e.target)
    @page = CMSimple.Editor.current_page.fromForm(form)
    args =
      ajax:
        error: @proxy @error
      success: @proxy @success
    @page.save(args)

  success: ->
    @modal.hide()
    Mercury.silent = true
    @page.reload()

  error: (event, data)->
    @content.html event.responseText
    alert('The current page was unable to be published')

