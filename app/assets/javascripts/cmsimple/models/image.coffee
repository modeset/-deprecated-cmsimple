class CMSimple.Image extends Spine.Model
  @configure 'Image', 'attachment', 'width', 'height', 'content_type', 'file_size', 'created_at'
  @extend Spine.Model.Ajax

  @url: '/cmsimple/images'

