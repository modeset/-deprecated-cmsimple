describe 'CMSimple.Path', ->
  beforeEach ->
    stubs.ajax()
    CMSimple.Path.destroyAll()

  describe 'has a unique uri', ->

    it 'fails validation if there is another path with the same uri', ->
      CMSimple.Path.create uri: '/about', redirect_uri: '/about-us'
      path = new CMSimple.Path uri: '/about', redirect_uri: '/something'
      expect(path.isValid()).toEqual(false)

    it 'passes validation if there is another path with the same uri', ->
      CMSimple.Path.create uri: '/about', redirect_uri: '/about-us'
      path = new CMSimple.Path uri: '/about-us', redirect_uri: '/something'
      expect(path.isValid()).toEqual(true)

    it 'does not check itself when checking paths', ->
      path = new CMSimple.Path uri: '/about', redirect_uri: '/about-us'
      path.save(ajax: false)
      expect(path.isValid()).toEqual(true)

  describe '.allRedirects does not return valid non redirect paths', ->

    it 'returns just the paths where the uri is not destinationPath', ->
      page = CMSimple.Page.create title: 'About'
      redirect = CMSimple.Path.create uri: '/about', redirect_uri: '/about-us'
      CMSimple.Path.create uri: '/about', page_id: page.id
      expect(CMSimple.Path.allRedirects()).toEqual([redirect])

    it 'returns just the paths where the associated page is not the root', ->
      page = CMSimple.Page.create title: 'About', is_root: true
      redirect = CMSimple.Path.create uri: '/about', redirect_uri: '/about-us'
      CMSimple.Path.create uri: '/about', page_id: page.id
      expect(CMSimple.Path.allRedirects()).toEqual([redirect])

