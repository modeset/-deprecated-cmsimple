jQuery(window).bind 'mercury:ready', ->

  bindPanel = (panel, element, modal, args...)->
    Mercury.modalHandlers.currentHandler?.dispose()
    panel = new panel(element, modal, args...)
    Mercury.modalHandlers.currentHandler = panel

  Mercury.modalHandlers.editMetadata = ->
    bindPanel CMSimple.Panels.PageMetadata, @element, @, 'edit'

  Mercury.modalHandlers.newPage = ->
    bindPanel CMSimple.Panels.PageMetadata, @element, @, 'new'

  Mercury.modalHandlers.publish = ->
    bindPanel CMSimple.Panels.Publish, @element, @
