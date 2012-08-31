require 'spec_helper'

describe Cmsimple::Snippet do
  subject { Cmsimple::Snippet.new 'name', {} }

  it_should_behave_like 'ActiveModel'

  describe 'options' do
    let(:snippet) { Cmsimple::Snippet.new 'snippet_0', { name: 'example', snippet: {first_name: 'Fred', last_name: 'Flintstone'} } }

    it "sets values for name" do
      snippet.name.should == 'example'
    end

    it "sets values for options" do
      snippet.options.should be_a(Hash)
      snippet.options[:first_name].should == 'Fred'
    end

    it 'can access options with via method calls' do
      snippet.first_name.should == 'Fred'
      snippet.last_name.should == 'Flintstone'
    end

    it "returns a string to match against the html for interpolations" do
      snippet.matcher.should =~ '[snippet_0/0]'
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
      @region.snippets.should be_a(Array)
      @region.snippets.first.should be_a(Cmsimple::Snippet)
    end

    it "sets values for options when not nested under the snippet key" do
      @region.snippets.first.first_name.should == 'Fred'
    end

    describe '#render_snippets' do
      it 'interpolates the result of the block into the region html' do
        @region.render_snippets do |snippet|
          "<span>#{snippet.options[:first_name]} #{snippet.options[:last_name]}</span>"
        end
        @region.to_s.should == '<div>some content</div><div><span>Fred Flinstone</span></div>'
      end
    end
  end
end
