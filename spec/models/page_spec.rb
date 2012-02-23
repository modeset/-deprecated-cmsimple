require 'spec_helper'
describe Cmsimple::Page do
  subject { Cmsimple::Page.new }
  it {should validate_presence_of(:path) }
  it {should validate_presence_of(:title) }
  it {should have_many(:children)}
  it {should belong_to(:parent)}

  describe '#update_content' do
    before do
      subject.path = '/about'
      subject.save
    end

    it "updates content to a hash when json is given to #update_content" do
      subject.update_content({'content' => 'hello world'})
      subject.content.should be_a Hash
      subject.content['content'].should == 'hello world'
    end
  end

  describe '#descendants' do
    before do
      @childless = Cmsimple::Page.create(title: 'Misc', path: '/Misc')
      @page = Cmsimple::Page.create(title: 'Home', path: '/')
      @child = Cmsimple::Page.create(title: 'About', path: '/about')
      @page.children << @child
      @descendant = Cmsimple::Page.create(title: 'Contact', path: '/about/contact')
      @child.children << @descendant
    end

    it 'retrieves all the descendants for a page' do
      @page.descendants.map(&:title).should =~ ['About', 'Contact']
    end

    it 'returns nothing for a page with no descendants' do
      @childless.descendants.should be_empty
    end

    describe '.for_parent_select' do
      it 'only returns pages that arent direct descendants' do
        Cmsimple::Page.for_parent_select(@page).map(&:title).should =~ ['Misc']
        Cmsimple::Page.for_parent_select(@child).map(&:title).should =~ ['Misc', 'Home']
        Cmsimple::Page.for_parent_select(@childless).map(&:title).should =~ ['Home', 'About', 'Contact']
      end
    end
  end


end
