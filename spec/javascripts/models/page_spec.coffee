describe 'CMSimple.Page', ->

  describe 'snippets', ->
    beforeEach ->
      @page = new CMSimple.Page
                        path: '/about'
                        content:
                          example2:
                            value: 'HTML'
                            snippets:
                              snippet_2:
                                name: 'example'
                                options:
                                  first_name: 'Barny'
                                  last_name: 'Rubble'

                          example1:
                            value: 'HTML'
                            snippets:
                              snippet_1:
                                name: 'example'
                                options:
                                  first_name: 'Fred'
                                  last_name: 'Flinstone'

    it 'return a flattened object of snippets across regions', ->
      expect(@page.snippets().snippet_1.options.first_name).toEqual('Fred')
      expect(@page.snippets().snippet_2.options.first_name).toEqual('Barny')

  describe 'acts as a tree', ->
    beforeEach ->
      stubs.ajax()
      CMSimple.Page.destroyAll()
      @single     = CMSimple.Page.create path: '/single', title: 'Single', id: 4
      @parent     = CMSimple.Page.create path: '/parent', title: 'Parent', id: 1
      @child      = CMSimple.Page.create path: '/child', title: 'Child', parent_id: @parent.id, id: 2
      @grandchild = CMSimple.Page.create path: '/grandchild', title: 'grandchild', parent_id: @child.id, id: 3

    it 'can grab a child', ->
      expect(@parent.children().first()).toEqual(@child)

    it 'can grab a parent', ->
      expect(@child.parent().id).toEqual(@parent.id)
      expect(@grandchild.parent().id).toEqual(@child.id)

    it 'can grab all the roots', ->
      roots = CMSimple.Page.roots()
      titles = _.compact(_.pluck(roots, 'title'))
      expect(roots.length).toEqual(2)
      expect(titles).toContain('Parent')
      expect(titles).toContain('Single')

    describe 'update all positions', ->
      it 'can bulk update to positions', ->
        CMSimple.Page.updatePositions([1,2,3,4])
        expect(@single.position).toEqual(3)
        expect(@parent.position).toEqual(0)
        expect(@child.position).toEqual(1)
        expect(@grandchild.position).toEqual(2)

