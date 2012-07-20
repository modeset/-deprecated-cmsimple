describe 'CMSimple.Page', ->

  describe 'snippets', ->
    beforeEach ->
      @page = new CMSimple.Page
                        slug: 'about'
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

  describe 'default slug', ->
    beforeEach ->
      stubs.ajax()

    it 'sets the slug from the title', ->
      about = CMSimple.Page.create title: 'About'
      expect(about.slug).toEqual('about')

    it 'does not change the slug if a title is not passed', ->
      about = CMSimple.Page.create title: 'About'
      about.load {}
      expect(about.slug).toEqual('about')

    it 'does not overrite the slug with the title if there is a slug', ->
      about = CMSimple.Page.create title: 'About', slug: 'something-else'
      about.load {title: 'A Different title'}
      expect(about.slug).toEqual('something-else')

    it 'removes multiple spaces', ->
      about = CMSimple.Page.create title: 'About a dog'
      expect(about.slug).toEqual('about-a-dog')

  describe 'is root', ->
    beforeEach ->
      stubs.ajax()
      @about = CMSimple.Page.create title: 'About', is_root: true, id: 1

    it 'finds the page with is root set to true for the path /', ->
      page = CMSimple.Page.forPath('/')
      expect(@about).toEqual(page)

    it 'can retrieve the original path when passed options to the path method', ->
      expect(@about.path(ignoreRoot: true)).toEqual('/about')

    it 'children request a parents path ignoring the root', ->
      @child  = CMSimple.Page.create title: 'Child', parent_id: @about.id, id: 2
      expect(@child.path()).toEqual('/about/child')


  describe 'acts as a tree', ->
    beforeEach ->
      stubs.ajax()
      CMSimple.Page.destroyAll()
      @single     = CMSimple.Page.create title: 'Single', id: 4
      @parent     = CMSimple.Page.create title: 'Parent', id: 1
      @child      = CMSimple.Page.create title: 'Child', parent_id: @parent.id, id: 2
      @grandchild = CMSimple.Page.create title: 'Grand Child', parent_id: @child.id, id: 3

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

