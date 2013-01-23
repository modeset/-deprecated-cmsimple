#= require cmsimple

describe 'CMSimple.Image.Geometry', ->

  describe 'absolute geometry', ->
    beforeEach ->
      @geometry = new CMSimple.Image.Geometry('200x300')

    it 'matches if the width and height are the same', ->
      expect(@geometry.inRange(200, 300)).toEqual(true)

    it 'does not match if the width is not exact', ->
      expect(@geometry.inRange(300, 300)).toEqual(false)

    it 'does not match if the height is not exact', ->
      expect(@geometry.inRange(300, 500)).toEqual(false)

  describe 'less than geometry', ->
    beforeEach ->
      @geometry = new CMSimple.Image.Geometry('<300x<300')

    it 'matches if the width and height matches the geometry', ->
      expect(@geometry.inRange(300, 300)).toEqual(true)

    it 'matches if the width and height are less than the geometry', ->
      expect(@geometry.inRange(200, 200)).toEqual(true)

    it 'does no match if the width is greater than the geometry', ->
      expect(@geometry.inRange(400, 200)).toEqual(false)

  describe 'greater than geometry', ->
    beforeEach ->
      @geometry = new CMSimple.Image.Geometry('>300x>300')

    it 'matches if the width and height matches the geometry', ->
      expect(@geometry.inRange(300, 300)).toEqual(true)

    it 'matches if the width and height are greater than the geometry', ->
      expect(@geometry.inRange(400, 400)).toEqual(true)

    it 'does no match if the width is less than the geometry', ->
      expect(@geometry.inRange(200, 200)).toEqual(false)

  describe 'mixed geometries', ->

    it 'matches less than and absolute', ->
      geometry = new CMSimple.Image.Geometry('<300x300')
      expect(geometry.inRange(200, 300)).toEqual(true)
      expect(geometry.inRange(200, 301)).toEqual(false)

  describe 'bad geometries', ->
    it 'can handle null', ->
      geometry = new CMSimple.Image.Geometry(null)
      expect(geometry.inRange(1, 1)).toEqual(true)

    it 'can handle empty string', ->
      geometry = new CMSimple.Image.Geometry(' ')
      expect(geometry.inRange(1, 1)).toEqual(true)

    it 'can handle partial query', ->
      geometry = new CMSimple.Image.Geometry('50')
      expect(geometry.inRange(50, 1)).toEqual(true)
      expect(geometry.inRange(5, 1)).toEqual(false)

