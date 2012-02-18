jQuery(window).bind 'mercury:ready', ->
  Mercury.modalHandlers.editMetadata = ->
    new CMSimple.Panels.PageMetadata(@element, @)

