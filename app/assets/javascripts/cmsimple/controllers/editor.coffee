Mercury.one = (eventName, callback)->
  jQuery(window).one("mercury:#{eventName}", callback)

Mercury.PageEditor::setFrameSource = (url, queryParams)->
  newUrl = "#{url}?_=#{new Date().getTime()}"
  newUrl = "#{newUrl}&#{queryParams}" unless Spine.isBlank(queryParams)
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

    @bind 'pathLoaded', @proxy @ensureProperState

    @initialLoad ->
      Spine.Route.setup(history: true)

  initialLoad: (callback)->
    @initializing = true
    callback.call()
    @initializing = false

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
    @current_page.bind 'version', @proxy @viewVersion

  loadNewPageFromPath: (path)->
    @setCurrentPage(CMSimple.Page.forPath(path))
    @loadCurrentSnippets()
    @loadPath(path)

  initializeMercury: ->
    @mercury = new Mercury.PageEditor(null, saveStyle: 'form')
    Mercury.on 'saved', =>
      CMSimple.Page.fetch(@current_page.id)
    @loadCurrentSnippets()

  loadCurrentSnippets: ->
    Mercury.Snippet.clearAll()
    Mercury.Snippet.load(@current_page.snippets())

  reload: ->
    if @pathChange(@current_page.editPath())
      @navigate @current_page.editPath()
    else
      @loadPath @current_page.path()

  viewVersion: (page, version)->
    @navigate "#{page.editPath()}?version=#{version}"

  loadPath: (path)->
    return unless path
    if @initializing
      #spine doesn't proxy the queryparams through when loading so we have to grab it ourselves
      queryParams = window.location.search.replace('?', '')
    else
      [path, queryParams] = path.split('?')
    @mercury.setFrameSource(path, queryParams)
    @trigger 'pathLoaded', path, queryParams

  pathChange: (path)->
    matches = window.location.href.match(/[http|https]:\/\/.[^\/]*(\/editor\/?.*)/)
    currentPath = matches[1]
    currentPath isnt path

  ensureProperState: (path, queryParams)->
    if queryParams?.match(/version=/)
      $('.mercury-button').not('.mercury-historyPanel-button').addClass('disabled')
      Mercury.one 'ready', -> Mercury.trigger('focus:window')
    else
      $('.mercury-button').not('.mercury-historyPanel-button').removeClass('disabled')


