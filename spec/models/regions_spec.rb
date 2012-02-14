require 'spec_helper'
describe Cmsimple::Regions do

  describe 'region proxy' do
    it 'defines instance methods for each region in the hash' do
      regions = Cmsimple::Regions.new content: {value: 'hello'}
      regions.should respond_to :content
    end

    it 'defines instance methods for each region in the hash' do
      regions = Cmsimple::Regions.new content: {value: 'hello'}
      regions.content.should be_a(Cmsimple::Regions::Region)
    end
  end

  describe Cmsimple::Regions::Region do

    it 'returns the value on to_s' do
      regions = Cmsimple::Regions.new content: {value: 'hello'}
      regions.content.to_s.should == 'hello'
    end

    it 'returns an empty string for a non-existent region' do
      regions = Cmsimple::Regions.new nil
      regions.content.to_s.should == ''
    end

    describe 'Snippets' do
      before do
        @region = Cmsimple::Regions::Region.new(value: "<div>some content</div><div>[snippet_0/0]</div>",
                                                snippets: {snippet_0: {name: 'example',
                                                                       options: { first_name: 'Fred',
                                                                                  last_name: 'Flinstone'
                                                }}})
      end

      it "has an array of snippets" do
        @region.snippets.should be_a(Array)
        @region.snippets.first.should be_a(Cmsimple::Regions::Snippet)
      end

      it "sets values for name" do
        @region.snippets.first.name.should == 'example'
      end

      it "sets values for options" do
        @region.snippets.first.options.should be_a(Hash)
        @region.snippets.first.options[:first_name].should == 'Fred'
      end

      it "returns a string to match against the html for interpolations" do
        @region.snippets.first.matcher.should =~ '[snippet_0/0]'
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
end
