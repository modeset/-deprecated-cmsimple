require 'spec_helper'

describe Cmsimple::Snippet do
  subject { Cmsimple::Snippet.new 'name', {} }

  it_should_behave_like 'ActiveModel'

  before do
    @region = Cmsimple::Region.new(value: "<div>some content</div><div>[snippet_0/0]</div>",
                                            snippets: {snippet_0: {name: 'example',
                                                                   options: { first_name: 'Fred',
                                                                              last_name: 'Flinstone'
                                            }}})
  end

  it "has an array of snippets" do
    @region.snippets.should be_a(Array)
    @region.snippets.first.should be_a(Cmsimple::Snippet)
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
