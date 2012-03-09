jQuery(window).bind 'mercury:ready', ->
  Mercury.modalHandlers.editMetadata = ->
    new CMSimple.Panels.PageMetadata(@element, @, 'edit')

  Mercury.modalHandlers.newPage = ->
    new CMSimple.Panels.PageMetadata(@element, @, 'new')
