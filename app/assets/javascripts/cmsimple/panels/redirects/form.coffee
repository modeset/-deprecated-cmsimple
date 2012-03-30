#= require cmsimple/panels/redirects/panel
class CMSimple.Panels.Redirects.Form extends Spine.Controller
  elements:
    '.add' : 'addButton'
    '.cancel' : 'cancelButton'
    'form' : 'form'

  events:
    'click .add' : 'addNewRedirect'
    'click .cancel' : 'hideRedirectForm'
    'submit form' : 'create'

  constructor: (el)->
    super el: $(el)

  create: (e)->
    e.preventDefault()
    @path?.unbind()
    @path = CMSimple.Path.fromForm(@form)
    @path.bind 'error', @proxy @validationError
    @path.save
      success: @proxy @success
      ajax:
        error: @proxy @error

  success: ->
    @hideRedirectForm()

  error: (xhr, status, message)->
    errors = JSON.parse(xhr.responseText).errors
    message = []
    message.push "#{field} : #{error}" for field, error of errors
    alert(message.join('\n'))
    @path.destroy(ajax: false)

  validationError: (record, message)->
    alert(message)

  addNewRedirect: (e)->
    e.preventDefault()
    @addButton.hide()
    $('form').show()

  hideRedirectForm: (e)->
    e.preventDefault() if e
    @addButton.show()
    $('form').hide()
    $('form input[type="text"]').val('')

