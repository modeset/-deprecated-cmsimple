require 'spec_helper'
describe Cmsimple::RegionsProxy do

  describe 'region proxy' do
    it 'defines instance methods for each region in the hash' do
      regions = Cmsimple::RegionsProxy.new content: {value: 'hello'}
      expect(regions).to respond_to :content
    end

    it 'defines instance methods for each region in the hash' do
      regions = Cmsimple::RegionsProxy.new content: {value: 'hello'}
      expect(regions.content).to be_a(Cmsimple::Region)
    end

    it 'returns a NillRegion if no region present' do
      regions = Cmsimple::RegionsProxy.new nil
      expect(regions.content).to be_a(Cmsimple::Region)
    end
  end

  describe '#snippets_hash' do
    before do
      @regions = Cmsimple::RegionsProxy.new(
                                        content: {value: "<div>some content</div><div>[snippet_0/0]</div>",
                                              snippets: {snippet_0: {name: 'example',
                                                                     options: { first_name: 'Fred',
                                                                                last_name: 'Flinstone'
                                              }}}},
                                        header: {value: "<div>some content</div><div>[snippet_1/0]</div>",
                                              snippets: {snippet_1: {name: 'example',
                                                                     options: { first_name: 'Fred',
                                                                                last_name: 'Flinstone'
                                              }}}}
                                           )
    end

    it "pull each snippet up into a single hash" do
      expect(@regions.snippets_hash).to have_key(:snippet_1)
      expect(@regions.snippets_hash).to have_key(:snippet_0)
    end

    it "has only the snippets in the hash" do
      expect(@regions.snippets_hash.keys.length).to eq(2)
    end
  end

end
