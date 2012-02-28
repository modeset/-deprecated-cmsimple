class CMSimple.Page extends Spine.Model
  @configure 'Page', 'path', 'template', 'title', 'parent_id', 'position'
  @extend Spine.Model.Ajax

  @belongsTo 'parent', 'CMSimple.Page', 'parent_id'
  @hasMany 'children', 'CMSimple.Page', 'parent_id'

  @roots: ->
    pages = @select (page)->
      not page.parent_id
    _.sortBy pages, (record)-> record.position

  @updatePositions: (ids, options={})->
    for id in ids
      position = ids.indexOf(id)
      page = CMSimple.Page.find(id)
      if page.position isnt position
        page.updateAttributes(position: position)

  snippets: ->
    _.reduce @content, ((memo, region)-> _.extend(memo, region.snippets)), {}

  sortedChildren: ->
    _.sortBy @children().all(), (record)-> record.position

  fromForm: (form)->
    values = form.toJSON()
    values = values.page if values.page
    #fix for views depending on realtime change events of children
    values.parent_id = parseInt(values.parent_id, 0) if values.parent_id
    @load(values)

  reload: (options)->
    @trigger 'reload', options

  editPath: ->
    "/editor#{@path}"

