@.stubs = {}
stubs.ajax = ->
  jqXHR = $.Deferred()

  $.extend jqXHR,
    readyState: 0
    setRequestHeader: -> @
    getAllResponseHeaders: -> null
    getResponseHeader: -> null
    overrideMimeType: -> @
    abort: -> @
    success: jqXHR.done
    error: jqXHR.fail
    complete: jqXHR.done

  spyOn($, "ajax").andReturn(jqXHR)
