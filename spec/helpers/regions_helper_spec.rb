require 'spec_helper'
require 'cell/test_case'
describe Cmsimple::RegionsHelper, type: :helper do
  include Cell::TestCase::TestMethods

  it 'returns the value of the region' do
    html = region_content(Cmsimple::Region.new value: '<h1>blah</h1>')
    expect(html).to eq('<h1>blah</h1>')
  end

  describe 'rendering a region' do
    before do
      @region = Cmsimple::Region.new(value: "<div>some content</div><div>[snippet_0/0]</div>",
                                              snippets: {snippet_0: {name: 'example',
                                                                     options: { first_name: 'Fred',
                                                                                last_name: 'Flinstone'
                                              }}})
      @page = double('page', :regions => double('regions', :body => @region, :heading => Cmsimple::Region.new({})))
    end

    it 'renders without a wrapper tag if no tag provided' do
      content = render_region(:body)
      expect(content).to have_selector('h1', text: 'Fred Flinstone')
    end

    it 'renders block if region has no content' do
      content = render_region(:heading) do
        'blah'
      end
      expect(content).to eq('blah')
    end

    it 'renders the region with a wrapper if a tag is specified' do
      content = render_region(:body, tag: :section)
      expect(content).to have_selector('h1', text: 'Fred Flinstone')
      expect(content).to have_selector("section[data-mercury='full']")
      expect(content).to have_selector('section#body')
    end

    it 'renders the region with a wrapper and set class and region type from options' do
      content = render_region(:body, tag: :section, html: {class: 'blah'}, region_type: 'snippets')
      expect(content).to have_selector('h1', text: 'Fred Flinstone')
      expect(content).to have_selector('section.blah')
      expect(content).to have_selector("section[data-mercury='snippets']")
      expect(content).to have_selector('section#body')
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
      expect(rendered_region).to have_selector('h1', text: 'Fred Flinstone')
    end
  end

end
