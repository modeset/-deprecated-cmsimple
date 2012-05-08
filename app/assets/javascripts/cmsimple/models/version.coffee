class CMSimple.Version extends Spine.Model
  @configure 'Version', 'template', 'content', 'published_at', 'updated_at', 'created_at'
  @extend Spine.Model.Ajax

  @belongsTo 'page', 'CMSimple.Page', 'page_id'

  @fetch: (page, params={})->
    throw 'CMSimple.Page instance required to fetch versions' unless page
    url = page.url('versions')
    super _.extend {url: url}, params

  @allForPage: (page)->
    results = @select (item)-> item.page().id is page.id
    (_(results).sortBy (item)-> moment(item.published_at)).reverse()

  url: (args...) ->
    args.unshift @page().url('versions', @id)
    args.join('/')

  revertTo: ->
    $.ajax
      type: 'PUT'
      url: @url('revert_to'),
      success: =>
        @page().reload()
      error: ->
        console?.log 'error', arguments
        alert('There was an error reverting to the requested version')

