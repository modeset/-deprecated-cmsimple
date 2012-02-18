class CMSimple.Editor extends Spine.Controller
  el: 'body'
  constructor: (@current_page)->
    CMSimple.Editor.current_page = @current_page
    @current_page.save(ajax: false)
    super()
    @loadMercury()

  loadMercury: ->
    @mercury = new Mercury.PageEditor(null, saveStyle: 'form')
    Mercury.Snippet.load(@current_page.snippets())

