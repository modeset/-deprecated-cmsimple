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


