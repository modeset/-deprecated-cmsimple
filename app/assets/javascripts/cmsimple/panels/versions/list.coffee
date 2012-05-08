#= require cmsimple/panels/versions/panel
class CMSimple.Panels.Versions.List extends Spine.Controller
  events:
    'click .view' : 'viewVersion'
    'click .revert' : 'revertVersion'

  constructor: (el)->
    super el: $(el)

    CMSimple.Version.bind 'refresh change', => @render()
    CMSimple.Version.fetch(CMSimple.Editor.current_page)

  render: ->
    @html('')
    @addVersion version for version in CMSimple.Editor.current_page.versions()

  addVersion: (version)->
    @append JST['cmsimple/views/versions_item'](version)

  viewVersion: (e)->
    e.preventDefault()
    button = $(e.target)
    id = @idFromTarget(button)
    CMSimple.Editor.current_page.trigger('version', id)
    @toggleViewButton(button)
    @trigger 'viewVersion'

  revertVersion: (e)->
    e.preventDefault()
    if confirm 'Are you sure you would like to revert to this version?'
      button = $(e.target)
      id = @idFromTarget(button)
      CMSimple.Version.find(id).revertTo()
      @toggleViewButton(button)

  idFromTarget: (target)->
    item = target
    id = item.data('id') || $(item.parents('[data-id]')[0]).data('id')

  toggleViewButton: (button)->
    @reset()
    $('.btn', button.parent()).show()
    button.hide()

  reset: ->
    @$('.revert').hide()
    @$('.view').show()

