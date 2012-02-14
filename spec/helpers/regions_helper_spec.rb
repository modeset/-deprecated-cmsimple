require 'spec_helper'
require 'cell/test_case'
describe Cmsimple::RegionsHelper do
  it 'returns the value of the region' do
    region(Cmsimple::Regions::Region.new value: '<h1>blah</h1>').should == '<h1>blah</h1>'
  end

  describe 'snippets' do
    include Cell::TestCase::TestMethods
    before do
      @region = Cmsimple::Regions::Region.new(value: "<div>some content</div><div>[snippet_0/0]</div>",
                                              snippets: {snippet_0: {name: 'example',
                                                                     options: { first_name: 'Fred',
                                                                                last_name: 'Flinstone'
                                              }}})
    end

    it 'renders the snippets when present' do
      rendered_region = region(@region)
      rendered_region.should have_selector('h1', content: 'Fred Flinstone')
    end
  end
end
