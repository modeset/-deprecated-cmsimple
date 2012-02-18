class CMSimple.Page extends Spine.Model
  @configure 'Page', 'path', 'template'
  @extend Spine.Model.Ajax

  snippets: ->
    _.reduce @content, ((memo, region)-> _.extend(memo, region.snippets)), {}

  fromForm: (form)->
    values = form.toJSON()
    values = values.page if values.page
    @load(values)

  load: (atts)->
    @originalAttributes = atts unless @originalAttributes
    super

  pathChanged: ->
    @originalAttributes.path && @path isnt @originalAttributes.path

