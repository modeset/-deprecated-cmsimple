describe 'CMSimple.Panels.ImageLibrary.Selection', ->
  beforeEach ->

    html = '''
      <div class="mercury-snippet example-snippet" data-snippet="snippet_3" contenteditable="false" data-version="1">
        <div class="item">
          <img data-image-geometry="&lt;100x&lt;100" data-snippet-image="image_1" src="" style="float: left; padding-right: 5px;">
          <h3>title</h3>
          <p>summary</p>
        </div>
      </div>
    '''
    @snippetHTML = $(html)
    setFixtures(@snippetHTML)

  describe 'selecting snippet images', ->

    beforeEach ->
      @region = {element: @snippetHTML}
      @selection = new CMSimple.Panels.ImageLibrary.Selection()
      @selection.bindRegion(@region)


    describe '#setSelection', ->
      beforeEach ->
        @img = @snippetHTML.find('img')
        @selection.bind 'filter', (geometry)=> @geometry = geometry
        @selection.setSelection(@img)

      it 'sets the img to the selecteImaged', ->
        expect(@selection.selectedImage).toEqual(@img)

      it 'sets the img class to have .selected-image', ->
        expect(@img.hasClass('selected-image')).toEqual(true)

      it 'triggers the filter event with the img geometry', ->
        expect(@geometry).toEqual('<100x<100')


    describe '#clearSelection', ->
      beforeEach ->
        @img = @snippetHTML.find('img')
        @selection.bind 'filter', (geometry)=> @geometry = geometry
        @selection.setSelection(@img)
        @selection.clearSelection()

      it 'unsets the img to the selecteImaged', ->
        expect(@selection.selectedImage).toEqual(null)

      it 'unsets the img class to have .selected-image', ->
        expect(@img.hasClass('selected-image')).toEqual(false)

      it 'triggers the filter event with null', ->
        expect(@geometry).toEqual(null)


    describe '#bindRegion', ->

      it 'binds to click on the attributed image', ->
        spyOn @selection, 'setSelection'
        @snippetHTML.find('img').click()
        expect(@selection.setSelection).toHaveBeenCalled()

      it 'clears the selection if a click happens off the image', ->
        spyOn @selection, 'setSelection'
        spyOn @selection, 'clearSelection'
        @snippetHTML.find('div').click()
        expect(@selection.setSelection).wasNotCalled()
        expect(@selection.clearSelection).toHaveBeenCalled()


  describe 'setting the image src', ->
    beforeEach ->
      @snippetMock = {options: {snippet: {}}}
      @snippetSpy = spyOn(Mercury.Snippet, 'find').andCallFake(=> @snippetMock)

      @region = {element: @snippetHTML, type: -> 'full'}
      @img = @snippetHTML.find('img')

      @selection = new CMSimple.Panels.ImageLibrary.Selection()
      @selection.region = @region
      @selection.selectedImage = @img

    it 'sets the src on the snippet image', ->
      @selection.set({src: 'foo.png'})
      expect(@img.attr('src')).toEqual('foo.png')

    it 'finds the snippet the image is in', ->
      @selection.set({src: 'foo.png'})
      expect(@snippetSpy).toHaveBeenCalledWith('snippet_3')

    it 'sets the src value on the snippet options', ->
      @selection.set({src: 'foo.png'})
      expect(@snippetMock.options.snippet.image_1).toEqual('foo.png')

    it 'calls the region execCommand if it does not have a selectedImage', ->
      @selection.selectedImage = null
      @region.execCommand = ->
      spyOn @region, 'execCommand'
      @selection.set({src: 'foo.png'})
      expect(@region.execCommand).toHaveBeenCalledWith('insertImage', {value: {src: 'foo.png'}})

