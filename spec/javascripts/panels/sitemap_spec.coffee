describe 'CMSimple.Panels.Sitemap', ->
  beforeEach ->
    stubs.ajax()
    CMSimple.Page.destroyAll()
    @single     = CMSimple.Page.create path: '/single', title: 'Single', id: 4
    @parent     = CMSimple.Page.create path: '/parent', title: 'Parent', id: 1
    @child      = CMSimple.Page.create path: '/child', title: 'Child', parent_id: @parent.id, id: 2
    @grandchild = CMSimple.Page.create path: '/grandchild', title: 'grandchild', parent_id: @child.id, id: 3
    setFixtures(sandbox(class: 'mercury-toolbar-container'))

  it 'renders each page in an li', ->
    new CMSimple.Panels.Sitemap().render()
    expect($('ul.sitemap li').length).toEqual(4)

  it 'calls renderPages for children', ->
    panel = new CMSimple.Panels.Sitemap()
    spyOn(panel, 'renderPages').andCallThrough()
    panel.render()
    expect(panel.renderPages.callCount).toEqual(3)

  it 'binds click events to the article element for the page', ->
    panel = new CMSimple.Panels.Sitemap()
    spyOn(panel, 'handleClick')
    panel.render()
    $('ul.sitemap li article').click()
    expect(panel.handleClick).toHaveBeenCalled()


