class CMSimple.Panels.Sitemap extends Mercury.Panel
  @toggle: (region)->
    @instance ?= new CMSimple.Panels.Sitemap()
    @instance.toggle()

  constructor: ()->
    super(null, 'Sitemap', title: 'Site Map', appendTo: '.mercury-toolbar-container', closeButton: true)
    @button = $('.mercury-sitemap-button')

  toggle: ->
    super
    @refresh() if @visible

  refresh: ->
    CMSimple.Page.one 'refresh', => @render()
    CMSimple.Page.fetch()

  render: ->
    @loadContent JST['views/sitemap']()
    @sitemap = $('ul.sitemap', @element)
    @renderPages(@sitemap, CMSimple.Page.roots())
    @resize()

  renderPages: (container, pages)->
    for page in pages
      item = @renderPage(page)
      container.append(item)
      if page.children().first()
        @renderPages($('ul.child', item), page.children().all())

  renderPage: (page)->
    item = $(JST['views/sitemap_page'](page))
    item.click (e)=> @handleClick(e)
    return item

  handleClick: (e)->
    e.preventDefault()
    page_id = $(e.target).data('id') || $($(e.target).parent('[data-id]')).data('id')
    Spine.Route.navigate(CMSimple.Page.find(page_id).editPath())

