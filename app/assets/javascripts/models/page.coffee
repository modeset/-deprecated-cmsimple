class CMSimple.Page extends Spine.Model
  @configure 'Page', 'path', 'template', 'title', 'parent_id'
  @extend Spine.Model.Ajax

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

