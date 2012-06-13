
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
    @bind 'pathLoaded', =>
      @checkPublishedState()

    CMSimple.Page.bind 'refresh', @proxy @checkPublishedState

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
    @mercury = new Mercury.PageEditor(null, saveStyle: 'json')

    Mercury.on 'saved', =>
      CMSimple.Page.fetch(id: @current_page.id)
    Mercury.one 'ready', =>
      @checkPublishedState()

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
    @mercury.loadIframeSrc _([path, queryParams]).compact().join('?')
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

  checkPublishedState: (record)->
    publishButton = $('.mercury-publish-button')
    if @current_page.reinflate().unpublished_changes
      publishButton.addClass('unpublished')
    else
      publishButton.removeClass('unpublished')

