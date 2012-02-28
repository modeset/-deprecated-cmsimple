class CMSimple.Panels.Sitemap.Sortable extends Spine.Controller
  constructor: (@el)->
    super el: @el
    @setup()

  setup: ->
    @el.nestedSortable
              items: 'li'
              listType: 'ul'
              helper: 'clone'
              connectWith: 'ul.child'
              update: @proxy @update

    @el.disableSelection()

  update: (e, sortable)->
    @updatePagePositions()
    @updatePageParent(sortable.item)

  updatePageParent: (el)->
    page_id = el.data('id')
    parent_id = el.parents('li').data('id') || null
    page = CMSimple.Page.find(page_id)
    page.updateAttributes(parent_id: parent_id)

  updatePagePositions: ->
    ids = _($('li', @el)).map (el) -> $(el).data('id')
    CMSimple.Page.updatePositions(ids)

