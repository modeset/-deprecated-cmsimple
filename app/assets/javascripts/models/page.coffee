class CMSimple.Page extends Spine.Model
  @configure 'Page', 'path', 'template', 'title', 'parent_id', 'position'
  @extend Spine.Model.Ajax

  @belongsTo 'parent', 'CMSimple.Page', 'parent_id'
  @hasMany 'children', 'CMSimple.Page', 'parent_id'

  @roots: ->
    @select (page)->
      not page.parent_id

  snippets: ->
    _.reduce @content, ((memo, region)-> _.extend(memo, region.snippets)), {}

  fromForm: (form)->
    values = form.toJSON()
    values = values.page if values.page
    @load(values)

  reload: (options)->
    @trigger 'reload', options

  editPath: ->
    "/editor#{@path}"

