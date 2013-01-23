#= require cmsimple

describe 'CMSimple.Panels.Sitemap.Sortable', ->
  beforeEach ->
    @page1 = CMSimple.Page.create path: '/page1', title: 'Page 1', id: 1
    @page2 = CMSimple.Page.create path: '/page2', title: 'Page 2', id: 2
    @page3 = CMSimple.Page.create path: '/page3', title: 'Page 3', id: 3, parent_id: 2
    @page4 = CMSimple.Page.create path: '/page4', title: 'Page 4', id: 4, parent_id: 3
    @page5 = CMSimple.Page.create path: '/page5', title: 'Page 5', id: 5

    html = '''
      <ul class='sitemap'>
        <li data-id='1'>
          <article>Page 1</article>
        </li>
        <li data-id='2'>
          <article>Page 2</article>
          <ul class='child'>
            <li data-id='3'>
              <article>Page 3</article>
              <ul class='child'>
                <li data-id='4'>
                  <article>Page 4</article>
                  <ul class='child'>
                  </ul
                </li>
              </ul
            </li>
          </ul
        </li>
        <li data-id='5'>
          <article>Page 5</article>
          <ul class='child'>
          </ul
        </li>
      </ul>
    '''
    fixture.set html
    @treeHTML = $(fixture.el)

  it 'binds to nestedSortable on initialization', ->
    pluginSpy = spyOn($.fn, 'nestedSortable').andCallThrough()
    selectionSpy = spyOn($.fn, 'disableSelection').andCallThrough()
    new CMSimple.Panels.Sitemap.Sortable(@treeHTML)
    expect(pluginSpy).toHaveBeenCalled()
    expect(selectionSpy).toHaveBeenCalled()

  describe '#update', ->
    beforeEach ->
      @sortable = new CMSimple.Panels.Sitemap.Sortable(@treeHTML)

    it 'updates the parent of the element that was moved', ->
      spyOn(CMSimple.Page, 'find').andCallThrough()
      spyOn(CMSimple.Page.prototype, 'updateAttributes')
      @sortable.update({}, item: $("li[data-id='4']"))
      expect(CMSimple.Page.find).toHaveBeenCalledWith(4)
      expect(CMSimple.Page.prototype.updateAttributes).toHaveBeenCalledWith(parent_id: 3)

    it 'calls updatePositions on CMSimple.Page', ->
      spyOn(CMSimple.Page, 'updatePositions')
      @sortable.update({}, item: $("li[data-id='4']"))
      expect(CMSimple.Page.updatePositions).toHaveBeenCalledWith([1,2,3,4,5])

