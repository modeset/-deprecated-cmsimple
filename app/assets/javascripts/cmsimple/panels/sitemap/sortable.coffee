#= require cmsimple/models/page

class CMSimple.Panels.Sitemap.Sortable extends Spine.Controller
  constructor: (@el)->
    super el: @el
    @setup()

  setup: ->
    @el.nestedSortable
              connectWith: 'ul.child'
              forcePlaceholderSize: true
              handle: 'article'
              helper: 'clone'
              items: 'li'
              listType: 'ul'
              stop: @proxy @update
              activate: @proxy @activate
              deactivate: @proxy @deactivate
              tolerance: 'pointer',
              toleranceElement: '> article'

    @el.disableSelection()

    @el.bind 'sortable:refresh', _.debounce(=> @el.nestedSortable('refreshPositions'))

  activate: ->
    @el.find('> li').on 'hover', @over

  deactivate: ->
    @el.find('> li').off 'hover'

  over: ->
    item = $(@)

    return if item.hasClass('ui-sortable-helper')

    unless item.hasClass('open')
      item.addClass('open')
      item.find('ul.hidden').removeClass('hidden')
      item.trigger('sortable:refresh')

  update: (e, sortable)->
    @updatePagePositions()
    @updatePageParent(sortable.item)

  updatePageParent: (el)->
    page_id = el.data('id')
    parent_id = el.parents('li').data('id') || null
    page = CMSimple.Page.find(page_id)
    page.updateAttributes(parent_id: parent_id)

  updatePagePositions: ->
    @trigger('beforeUpdatePositions')
    ids = _($('li', @el)).map (el) -> $(el).data('id')
    CMSimple.Page.updatePositions(ids)
    @trigger('afterUpdatePositions')

