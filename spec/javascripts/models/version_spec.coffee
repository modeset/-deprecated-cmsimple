#= require cmsimple
#= require support/stubs

describe 'CMSimple.Version', ->
  beforeEach ->
    @ajax = stubs.ajax()
    CMSimple.Version.destroyAll()

  describe 'nested resource urls', ->
    beforeEach ->
      @page = CMSimple.Page.create title: 'About', id: 1
      @ajax.reset()

    it 'uses the url of the page to request versions via fetch', ->
      CMSimple.Version.fetch(@page)
      expect(@ajax).toHaveBeenCalledWith
        contentType: 'application/json'
        dataType: 'json'
        processData: false
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
        type: 'GET'
        url: '/pages/1/versions'

    it 'uses the url of the page to create a member url for versions', ->
      version = CMSimple.Version.create page_id: @page.id, id: 1
      expect(version.url()).toEqual("/pages/#{@page.id}/versions/#{version.id}")

    it 'can append segments to the url', ->
      version = CMSimple.Version.create page_id: @page.id, id: 1
      expect(version.url('revert_to')).toEqual("/pages/#{@page.id}/versions/#{version.id}/revert_to")

