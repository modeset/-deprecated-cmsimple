#= require cmsimple
describe 'CMSimple.Panels.Sitemap.Panel', ->
  beforeEach ->
    spyOn(Mercury.Panel.prototype, 'position')
    spyOn(CMSimple.Page, 'bind')
    @refreshSpy = spyOn(CMSimple.Panels.Sitemap.Tree.prototype, 'refresh')

    fixture.set sandbox(div: 'mercury-toolbar-container')


