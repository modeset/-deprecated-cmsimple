describe 'CMSimple.Panels.Sitemap.Panel', ->
  beforeEach ->
    delete CMSimple.Panels.Sitemap.instance
    spyOn(Mercury.Panel.prototype, 'position')
    spyOn(CMSimple.Page, 'bind')
    @refreshSpy = spyOn(CMSimple.Panels.Sitemap.Tree.prototype, 'refresh')

    setFixtures(sandbox(div: 'mercury-toolbar-container'))

  describe 'CMSimple.Panels.Sitemap.toggle()', ->
    it 'instanciates the panel', ->
      CMSimple.Panels.Sitemap.toggle()
      expect(CMSimple.Panels.Sitemap.instance.constructor).toBe(CMSimple.Panels.Sitemap.Panel)

    it 'instanciates it only once', ->
      constructor = spyOn(CMSimple.Panels.Sitemap.Panel.__super__, 'constructor').andCallThrough()
      CMSimple.Panels.Sitemap.toggle()
      expect(constructor).toHaveBeenCalled()
      expect(constructor.callCount).toEqual(1)

    it 'calls toggle on panel', ->
      toggle = spyOn(CMSimple.Panels.Sitemap.Panel.prototype, 'toggle').andCallThrough()
      CMSimple.Panels.Sitemap.toggle()
      expect(toggle).toHaveBeenCalled()
      expect(@refreshSpy).toHaveBeenCalled()

