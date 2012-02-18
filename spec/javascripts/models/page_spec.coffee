describe 'CMSimple.Page', ->

  describe 'path changes', ->
    beforeEach ->
      @page = new CMSimple.Page(path: '/about')

    it 'return false for pathChanged() when the model was created', ->
      expect(@page.pathChanged()).toEqual(false)

    it 'returns true for pathChanged() when the path has been modified', ->
      @page.path = '/about_us'
      expect(@page.pathChanged()).toEqual(true)

