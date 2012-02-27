class CMSimple.Panels.PageMetadata extends Spine.Controller

  elements:
    'form' : 'form'
    '.mercury-modal-content' : 'content'

  events:
    'submit form' : 'submit'

  constructor: (container, @modal, @action)->
    super el: container

  submit: (e)->
    e.preventDefault()
    @page = @pageForAction().fromForm(@form)
    @page.save
      ajax:
        error: @proxy @error
      success: @proxy @success

  pageForAction: ->
    if @action is 'edit'
      CMSimple.Editor.current_page
    else
      CMSimple.Page

  success: ->
    @modal.hide()
    Mercury.silent = true

    if @action is 'edit'
      @page.reload()
    else
      @navigate @page.editPath()

  error: (event, data)->
    @content.html event.responseText
    alert('Please fill in the required fields.')

