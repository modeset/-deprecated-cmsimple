Mercury.PageEditor::setFrameSource = (url)->
  newUrl = "#{url}?_=#{new Date().getTime()}"
  @iframe.data('loaded', false)
  @iframe.get(0).contentWindow.document.location.href = @iframeSrc(newUrl, true)

Mercury.Snippet.clearAll = ->
  delete @all
  @all = []
  $('.mercury-snippet-toolbar').remove()

class CMSimple.Editor extends Spine.Controller
  el: 'body'
  constructor: (page)->
    super()
    @setCurrentPage(page)
    @initializeMercury()

    @routes
      '/editor/*path': (params)=>
        path = "/#{params.match[1]}"
        @routeToPath(path)
      '/editor': (params)=>
        @routeToPath('/')

    Spine.Route.setup(history: true)

  routeToPath: (path)->
    if @current_page and @current_page.path() is path
      @loadPath(path)
    else
      @loadNewPageFromPath(path)

  setCurrentPage: (page)->
    return unless page
    @current_page.unbind() if @current_page
    @current_page = page
    CMSimple.Editor.current_page = @current_page
    @current_page.save(ajax: false) if @current_page.isNew()
    @current_page.bind 'reload', @proxy @reload

  loadNewPageFromPath: (path)->
    @setCurrentPage(CMSimple.Page.forPath(path))
    @loadCurrentSnippets()
    @loadPath(path)

  initializeMercury: ->
    @mercury = new Mercury.PageEditor(null, saveStyle: 'form')
    @loadCurrentSnippets()

  loadCurrentSnippets: ->
    Mercury.Snippet.clearAll()
    Mercury.Snippet.load(@current_page.snippets())

  reload: ->
    if @pathChange(@current_page.editPath())
      @navigate @current_page.editPath()
    else
      @loadPath @current_page.path()

  loadPath: (path)->
    return unless path
    @mercury.setFrameSource(path)

  pathChange: (path)->
    matches = window.location.href.match(/[http|https]:\/\/.[^\/]*(\/editor\/?.*)/)
    currentPath = matches[1]
    currentPath isnt path

