describe 'CMSimple.Editor', ->
  beforeEach ->
    @page = new CMSimple.Page slug: 'about'
    spyOn(CMSimple.Editor::, 'initializeMercury')
    @editor = new CMSimple.Editor @page
    @editor.mercury =
                iframe:
                  data: (->)
                setFrameSource: ((path)-> @path = path)

  describe 'initialization', ->

    it 'calls loadMercury', ->
      expect(CMSimple.Editor::initializeMercury).toHaveBeenCalled()

    it 'sets CMSimple.Editor.current_page to the page passed to the constructor', ->
      expect(CMSimple.Editor.current_page).toEqual(@page)
      expect(@editor.current_page).toEqual(@page)

  describe 'reloading with page changes', ->

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

  describe 'loading a new page', ->
    beforeEach ->
      @otherPage = new CMSimple.Page slug: 'contact'
      @otherPage.save ajax: false
      spyOn(Mercury.Snippet, 'clearAll').andCallThrough()
      spyOn(Mercury.Snippet, 'load')
      @editor.loadNewPageFromPath('/contact')

    it 'sets the current page to the page with the matching path', ->
      expect(@editor.current_page).toEqual(@otherPage)

    it 'reloads the snippets', ->
      expect(Mercury.Snippet.clearAll).toHaveBeenCalled()
      expect(Mercury.Snippet.load).toHaveBeenCalled()

    it 'loads the new path in mercury', ->
      expect(@editor.mercury.path).toEqual(@otherPage.path())

