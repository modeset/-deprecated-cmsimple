require 'spec_helper'
require 'cell/test_case'
describe Cmsimple::RegionsHelper do
  include Cell::TestCase::TestMethods

  it 'returns the value of the region' do
    region_content(Cmsimple::Region.new value: '<h1>blah</h1>').should == '<h1>blah</h1>'
  end

  describe 'rendering a region' do
    before do
      @region = Cmsimple::Region.new(value: "<div>some content</div><div>[snippet_0/0]</div>",
                                              snippets: {snippet_0: {name: 'example',
                                                                     options: { first_name: 'Fred',
                                                                                last_name: 'Flinstone'
                                              }}})
      @page = mock('page', :regions => mock('regions', :body => @region, :heading => Cmsimple::Region.new({})))
    end

    it 'renders without a wrapper tag if no tag provided' do
      content = render_region(:body)
      content.should have_selector('h1', content: 'Fred Flinstone')
    end

    it 'renders block if region has no content' do
      content = render_region(:heading) do
        'blah'
      end
      content.should == 'blah'
    end

    it 'renders the region with a wrapper if a tag is specified' do
      content = render_region(:body, tag: :section, html: {class: 'blah'})
      content.should have_selector('h1', content: 'Fred Flinstone')
      content.should have_selector('section.mercury-editable.blah')
      content.should have_selector('section#body')
    end
  end

  describe 'snippets' do
    before do
      @region = Cmsimple::Region.new(value: "<div>some content</div><div>[snippet_0/0]</div>",
                                              snippets: {snippet_0: {name: 'example',
                                                                     options: { first_name: 'Fred',
                                                                                last_name: 'Flinstone'
                                              }}})
    end

    it 'renders the snippets when present' do
      rendered_region = region_content(@region)
      rendered_region.should have_selector('h1', content: 'Fred Flinstone')
    end
  end
end
