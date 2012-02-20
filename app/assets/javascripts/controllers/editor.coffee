Mercury.PageEditor::setFrameSource = (url)->
  newUrl = "#{url}?_=#{new Date().getTime()}"
  @iframe.get(0).contentWindow.document.location.href = newUrl

class CMSimple.Editor extends Spine.Controller
  el: 'body'
  constructor: (@current_page)->
    super()
    @setCurrentPage(@current_page)
    @initializeMercury()

    @routes
      '/editor/*path': (params)=>
        path = "/#{params.match[1]}"
        @loadPath(path)

    Spine.Route.setup(history: true)

  setCurrentPage: (page)->
    @current_page.unbind() if @current_page
    @current_page = page
    CMSimple.Editor.current_page = @current_page
    @current_page.save(ajax: false)
    @current_page.bind 'reload', @proxy @reload

  initializeMercury: ->
    @mercury = new Mercury.PageEditor(null, saveStyle: 'form')
    @loadCurrentSnippets()

  loadCurrentSnippets: ->
    Mercury.Snippet.load(@current_page.snippets())

  reload: ->
    if @pathChange(@current_page.editPath())
      @navigate @current_page.editPath()
    else
      @loadPath @current_page.path

  loadPath: (path)->
    return unless path
    @mercury.iframe.data('loaded', false)
    @mercury.setFrameSource(path)

  pathChange: (path)->
    matches = window.location.href.match(/[http|https]:\/\/.[^\/]*(\/editor\/.*)/)
    currentPath = matches[1]
    currentPath isnt path

