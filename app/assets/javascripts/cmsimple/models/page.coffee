class CMSimple.Page extends Spine.Model
  @configure 'Page', 'template', 'title', 'parent_id', 'position', 'slug', 'is_root', 'browser_title', 'keywords', 'description', 'published', 'unpublished_changes'
  @extend Spine.Model.Ajax

  @belongsTo 'parent', 'CMSimple.Page', 'parent_id'
  @hasMany 'children', 'CMSimple.Page', 'parent_id'

  @roots: ->
    pages = @select (page)-> not page.parent_id
    _(pages).sortBy (record)-> record.position

  @forPath: (path)->
    _(@select (page)-> page.path() is path).first()

  @updatePositions: (ids, options={})->
    for id in ids
      position = ids.indexOf(id)
      page = CMSimple.Page.find(id)
      if page.position isnt position
        page.updateAttributes(position: position)

  snippets: ->
    _(@content).reduce ((memo, region)-> _.extend(memo, region.snippets)), {}

  sortedChildren: ->
    _(@children().all()).sortBy (record)-> record.position

  hasChildren: ->
    @children().all().length > 0

  publishedState: ->
    if @published
      if @unpublished_changes
        'has-changes'
      else
        'published'
    else
      'unpublished'

  versions: ->
    CMSimple.Version.allForPage(@)

  fromForm: (form)->
    values = form.toJSON()
    values = values.page if values.page
    #fix for views depending on realtime change events of children
    values.parent_id = parseInt(values.parent_id, 0) if values.parent_id
    @load(values)

  reinflate: @::reload

  reload: ->
    @constructor.fetch
      id: @id
      success: => @trigger 'reload'

  editPath: ->
    "/editor#{@path()}"

  isRoot: ->
    # handle the form values pre refresh from server
    @is_root is true or @is_root is '1'

  load: (values)->
    values = @normalizeSlug(values)
    super(values)

  path: (options={})->
    return '/' if (not options.ignoreRoot) && @isRoot()
    parent_path = if @parent() then @parent().path(ignoreRoot: true) else ''
    path = [parent_path, @slug].join('/')
    path = path.replace(/\/+/, '/')
    path = path.replace(/\/$/, '')
    path

  normalizeSlug: (values)->
    return values unless values.title

    if Spine.isBlank(values.slug) && Spine.isBlank(@slug)
      values.slug = values.title

    unless Spine.isBlank(values.slug)
      values.slug = @escape(values.slug)

    return values

  escape: (string)->
    return '' unless string
    string = string.replace(/[^\x00-\x7F]+/g, '') # Remove anything non-ASCII entirely (e.g. diacritics).
    string = string.replace(/[^\w_ \-]+/ig, '') # Remove unwanted chars.
    string = string.replace(/[ \-]+/ig, '-') # No more than one of the separator in a row.
    string = string.replace(/^\-|\-$/ig, '') # Remove leading/trailing separator.
    string.toLowerCase()

