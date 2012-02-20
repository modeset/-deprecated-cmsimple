describe 'CMSimple.Editor', ->
  beforeEach ->
    @page = new CMSimple.Page path: '/about'
    spyOn(CMSimple.Editor::, 'initializeMercury')
    @editor = new CMSimple.Editor @page
    @editor.mercury =
                iframe:
                  data: (->)
                setFrameSource: (->)

  describe 'initialization', ->

    it 'calls loadMercury', ->
      expect(CMSimple.Editor::initializeMercury).toHaveBeenCalled()

    it 'sets CMSimple.Editor.current_page to the page passed to the constructor', ->
      expect(CMSimple.Editor.current_page).toEqual(@page)
      expect(@editor.current_page).toEqual(@page)

  describe 'path changes', ->

    it 'returns true when the path argument does not match the window.location', ->
      spyOn(String::, 'match').andCallFake(-> ['http://cmsimple.dev/editor/about_us', '/editor/about_us'])
      expect(@editor.pathChange('/editor/contact_us')).toEqual(true)

    it 'calls navigate if the path does not match the current page path on a reload call', ->
      spyOn(String::, 'match').andCallFake(-> ['http://cmsimple.dev/editor/about_us', '/editor/about_us'])
      spyOn(@editor, 'navigate')
      @editor.reload()
      expect(@editor.navigate).toHaveBeenCalled()

    it 'calls loadPath if the path does match the current page path on a reload call', ->
      spyOn(String::, 'match').andCallFake(-> ['http://cmsimple.dev/editor/about', '/editor/about'])
      spyOn(@editor, 'loadPath')
      @editor.reload()
      expect(@editor.loadPath).toHaveBeenCalled()

