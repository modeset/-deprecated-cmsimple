class CMSimple.Path extends Spine.Model
  @configure 'Path', 'uri', 'redirect_uri', 'page_id', 'updated_at', 'created_at'
  @extend Spine.Model.Ajax

  @belongsTo 'page', 'CMSimple.Page', 'page_id'

  @allRedirects: ->
    results = @select (item)-> not item.page()?.isRoot() && item.uri isnt item.destinationPath()
    _(results).sortBy (item)-> item.uri

  uriIsUnique: ->
    not _(@constructor.all()).any (path)=>
      path.uri is @uri and not @eql(path)

  validate: ->
    unless @uri
      return "Source URL is required"

    unless @uriIsUnique()
      return "Source URL must be unique"

    unless @redirect_uri || @page_id
      return "Destination redirect URL is required"

    return null

  destinationPath: ->
    if @page() then @page().path() else @redirect_uri


