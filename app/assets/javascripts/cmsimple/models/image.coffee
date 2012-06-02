class CMSimple.Image extends Spine.Model
  @configure 'Image', 'attachment', 'width', 'height', 'content_type', 'file_size', 'created_at'
  @extend Spine.Model.Ajax

  @url: '/cmsimple/images'


  @allWithinGeometry: (query)->
    geometry = new CMSimple.Image.Geometry(query)
    @select (item)->
      geometry.inRange item.width, item.height


# 500x200
# <800x<800
# >100x>300

class CMSimple.Image.Geometry
  constructor: (@query)->
    @parse()

  parse: ->
    return unless @query
    [width, height] = @query?.split('x')
    @widthQualifier = width?.match(/[\<|\>]/)?[0]
    @heightQualifier = height?.match(/[\<|\>]/)?[0]
    @width = parseInt(width?.replace(/\D/, ''), 10)
    @height = parseInt(height?.replace(/\D/, ''), 10)

  inRange: (width, height)->
    @widthQualifies(width) and @heightQualifies(height)

  widthQualifies: (width)->
    @qualifiedDimension width, @width, @widthQualifier

  heightQualifies: (height)->
    @qualifiedDimension height, @height, @heightQualifier

  qualifiedDimension: (input, dimension, qualifier)->
    return true unless dimension
    input = parseInt(input, 10)
    switch qualifier
      when '<'
        input <= dimension
      when '>'
        input >= dimension
      else
        input is dimension

