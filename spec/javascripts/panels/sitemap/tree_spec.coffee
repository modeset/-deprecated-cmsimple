describe 'CMSimple.Panels.Sitemap.Tree', ->
  beforeEach ->
    stubs.ajax()
    CMSimple.Page.unbind()
    CMSimple.Page.destroyAll()
    @single     = CMSimple.Page.create path: '/single', title: 'Single', id: 4
    @parent     = CMSimple.Page.create path: '/parent', title: 'Parent', id: 1
    @child      = CMSimple.Page.create path: '/child', title: 'Child', parent_id: @parent.id, id: 2
    @grandchild = CMSimple.Page.create path: '/grandchild', title: 'grandchild', parent_id: @child.id, id: 3
    html = '''
      <div class='mercury-panel'>
        <button class='add'>Add Page</button>
        <ul class='sitemap'>
        </ul>
      </div>
    '''
    @container = $(html)
    setFixtures(@container)

  describe 'rendering', ->
    it 'renders each page in an li', ->
      new CMSimple.Panels.Sitemap.Tree(@container).render()
      expect($('ul.sitemap li').length).toEqual(4)

    it 'calls renderPages for children', ->
      panel = new CMSimple.Panels.Sitemap.Tree(@container)
      spyOn(panel, 'renderPages').andCallThrough()
      panel.render()
      expect(panel.renderPages.callCount).toEqual(3)

    it 'calls render when refreshed', ->
      spyOn(CMSimple.Page, 'fetch').andCallFake -> CMSimple.Page.trigger 'refresh'
      panel = new CMSimple.Panels.Sitemap.Tree(@container)
      spyOn(panel, 'render')
      runs ->
        panel.refresh()
      waits 100
      runs ->
        expect(panel.render).toHaveBeenCalled()

  describe 'event binding and setup', ->
    it 'binds click events to the article element for the page', ->
      panel = new CMSimple.Panels.Sitemap.Tree(@container)
      spyOn(panel, 'pageClick')
      panel.render()
      $('ul.sitemap li article').click()
      expect(panel.pageClick).toHaveBeenCalled()

    it 'initializes the sortable helper', ->
      panel = new CMSimple.Panels.Sitemap.Tree(@container)
      sortableSpy = spyOn(CMSimple.Panels.Sitemap.Sortable.__super__, 'constructor').andCallThrough()
      panel.render()
      expect(sortableSpy).toHaveBeenCalled()

    it 'binds the add page event', ->
      spyOn(Mercury, 'trigger')
      panel = new CMSimple.Panels.Sitemap.Tree(@container)
      $('button.add').click()
      expect(Mercury.trigger).toHaveBeenCalledWith('action', action: 'newPage')

