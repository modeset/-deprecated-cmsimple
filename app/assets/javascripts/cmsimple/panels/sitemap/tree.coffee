#= require cmsimple/panels/sitemap/sortable
#= require cmsimple/models/page
#= require cmsimple/views/sitemap/_page

class CMSimple.Panels.Sitemap.Tree extends Spine.Controller
  elements:
    'ul.sitemap': 'sitemap'

  events:
    'click article .caret' : 'toggleChildren'

  constructor: (@el)->
    super el: @el
    @bindEvents()
    @openPages = {}

  bindEvents: ->
    $('button.add', @el).click @proxy @addNewPage
    CMSimple.Page.bind 'refresh change', _.debounce (=> @render()), 300

  refresh: ->
    CMSimple.Page.fetch()

  render: ->
    return if @sorting
    @sitemap.html ''
    @renderPages(@sitemap, CMSimple.Page.roots())
    $('li', @sitemap).click @proxy @pageClick
    @initializeSortable()
    @trigger 'redraw'

  initializeSortable: ->
    sortable = new CMSimple.Panels.Sitemap.Sortable(@sitemap)
    sortable.bind 'beforeUpdatePositions', => @sorting = true
    sortable.bind 'afterUpdatePositions', => @sorting = false

  renderPages: (container, pages)->
    for page in pages
      item = @renderPage(page)
      container.append(item)
      if page.children().first()
        @renderPages($('ul.child', item), page.sortedChildren())

  renderPage: (page)->
    $(JST['cmsimple/views/sitemap/_page'](page: page, open: @openPages[page.id]))

  pageClick: (e)->
    target = $(e.target)
    unless target.hasClass('caret')
      page_id = target.data('id') || $($(e.target).parents('[data-id]')).data('id')
      @navigate(CMSimple.Page.find(page_id).editPath())

  addNewPage: ->
    Mercury.trigger 'action', action: 'newPage'

  toggleChildren: (e)->
    item = $(e.target).closest('[data-id]')
    item.find('> ul.child').toggleClass('hidden')
    item.find('> article .caret').toggleClass('north')
    @toggleOpenReference(item.data('id'))

  toggleOpenReference: (page_id)->
    @openPages[page_id] = !@openPages[page_id]

