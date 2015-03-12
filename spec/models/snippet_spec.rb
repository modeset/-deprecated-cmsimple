require 'spec_helper'

describe Cmsimple::Snippet do
  subject { Cmsimple::Snippet.new 'name', {} }

  it_should_behave_like 'ActiveModel'

  describe 'options' do
    let(:snippet) { Cmsimple::Snippet.new 'snippet_0', { name: 'example', snippet: {first_name: 'Fred', last_name: 'Flintstone'} } }

    it "sets values for name" do
      expect(snippet.name).to eq('example')
    end

    it "sets values for options" do
      expect(snippet.options).to be_a(Hash)
      expect(snippet.options[:first_name]).to eq('Fred')
    end

    it 'can access options with via method calls' do
      expect(snippet.first_name).to eq('Fred')
      expect(snippet.last_name).to eq('Flintstone')
    end

    it "returns a string to match against the html for interpolations" do
      expect(snippet.matcher).to match('[snippet_0/0]')
    end
  end

  describe 'created via a region' do
    before do
      @region = Cmsimple::Region.new(value: "<div>some content</div><div>[snippet_0/0]</div>",
                                              snippets: {snippet_0: {name: 'example',
                                                                     first_name: 'Fred',
                                                                     last_name: 'Flinstone'
                                              }})
    end

    it "has an array of snippets" do
      expect(@region.snippets).to be_a(Array)
      expect(@region.snippets.first).to be_a(Cmsimple::Snippet)
    end

    it "sets values for options when not nested under the snippet key" do
      expect(@region.snippets.first.first_name).to eq('Fred')
    end

    describe '#render_snippets' do
      it 'interpolates the result of the block into the region html' do
        @region.render_snippets do |snippet|
          "<span>#{snippet.options[:first_name]} #{snippet.options[:last_name]}</span>"
        end
        expect(@region.to_s).to eq('<div>some content</div><div><span>Fred Flinstone</span></div>')
      end
    end
  end
end
