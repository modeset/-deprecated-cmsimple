class CMSimple.Panels.Sitemap.Tree extends Spine.Controller
  elements:
    'ul.sitemap': 'sitemap'

  constructor: (@el)->
    super el: @el
    @bindEvents()

  bindEvents: ->
    $('button.add', @el).click @proxy @addNewPage
    CMSimple.Page.bind 'refresh change', _.debounce (=> @render()), 100

  refresh: ->
    CMSimple.Page.fetch()

  render: ->
    @sitemap.html ''
    @renderPages(@sitemap, CMSimple.Page.roots())
    $('li', @sitemap).click @proxy @pageClick
    @initializeSortable()
    @trigger 'redraw'

  initializeSortable: ->
    new CMSimple.Panels.Sitemap.Sortable(@sitemap)

  renderPages: (container, pages)->
    for page in pages
      item = @renderPage(page)
      container.append(item)
      if page.children().first()
        @renderPages($('ul.child', item), page.sortedChildren())

  renderPage: (page)->
    $(JST['cmsimple/views/sitemap_page'](page))

  pageClick: (e)->
    page_id = $(e.target).data('id') || $($(e.target).parents('[data-id]')).data('id')
    @navigate(CMSimple.Page.find(page_id).editPath())

  addNewPage: ->
    Mercury.trigger 'action', action: 'newPage'

