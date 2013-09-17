require 'spec_helper'
describe Cmsimple::Page do
  subject { Cmsimple::Page.new }
  it {should validate_presence_of(:title) }
  it {should have_many(:children)}
  it {should belong_to(:parent)}
  it {should have_many(:versions)}

  let(:page) { Cmsimple::Page.create title: 'About' }

  describe '#update_content' do
    before do
      subject.uri = '/about'
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
      @childless = Cmsimple::Page.create(title: 'Misc', uri: '/Misc')
      @page = Cmsimple::Page.create(title: 'Home', uri: '/')
      @child = Cmsimple::Page.create(title: 'About', uri: '/about')
      @page.children << @child
      @descendant = Cmsimple::Page.create(title: 'Contact', uri: '/about/contact')
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

    describe '#root' do
      it "returns the root of the page tree" do
        @descendant.root.id.should == @page.id
      end

      it "returns the current page if it is a root" do
        @page.root.id.should == @page.id
      end
    end
  end

  describe 'path generation' do

    it 'returns a default slug from the title' do
      subject.title = 'About Us'
      subject.slug.should == 'about-us'
    end

    it "doesn't override the slug if it is manually set" do
      subject.slug = 'about'
      subject.title = 'About Us'
      subject.slug.should == 'about'
    end

    it 'saves the default slug' do
      subject.title = 'About Us'
      subject.save
      Cmsimple::Page.find(subject.id).slug.should == 'about-us'
    end

    it 'sets the path to the the slug on save if no parent' do
      subject.title = 'About Us'
      subject.save
      Cmsimple::Page.find(subject.id).uri.should == '/about-us'
    end

    it 'sets the path to the the slug on save if no parent' do
      about = Cmsimple::Page.create title: 'About'
      subject.parent = about
      subject.title = 'Contact Us'
      subject.save
      Cmsimple::Page.find(subject.id).uri.should == '/about/contact-us'
    end
  end

  describe 'can only have one root page' do
    before do
      subject.title = 'About Us'
      subject.is_root = true
      subject.save
    end

    it 'can only have one root' do
      Cmsimple::Page.create title: 'About', is_root: true
      Cmsimple::Page.where(is_root: true).count.should == 1
    end

    it 'must have at least one root' do
      subject.is_root = false
      subject.should_not be_valid
    end
  end

  describe 'paths' do
    it 'creates a path after save' do
      expect { Cmsimple::Page.create title: 'About' }.to change{ Cmsimple::Path.count }.by(1)
    end

    it "doesn't create a path if one already exists with the same uri" do
      Cmsimple::Path.create uri: '/about', redirect_uri: '/'
      expect { Cmsimple::Page.create title: 'About' }.to change{ Cmsimple::Path.count }.by(0)
    end
  end

  describe 'publishing' do

    it "has published_at set to nil by default" do
      page.published_at.should be_nil
    end

    describe '#publish!' do
      it 'sets the published_at date to now' do
        Timecop.freeze(Time.now) do
          page.publish!
          page.published_at.to_s.should == Time.zone.now.to_s
        end
      end

      it 'creates a new published verson' do
        expect { page.publish! }.to change { page.versions.count }.by(1)
      end
    end

    describe '#unpublished_changes?' do
      it 'has unpublished changes if it was never published' do
        page.published_at.should be_nil
        page.unpublished_changes?.should be_true
      end

      it 'does not have unpublished changes once it is published' do
        page.publish!
        page.unpublished_changes?.should be_false
      end
    end

    describe '#unpublish!' do
      before do
        page.publish!
      end

      it 'sets published_at to nil' do
        page.unpublish!
        page.published_at.should be_nil
      end
    end

    describe 'published scope' do
      it 'returns the published page' do
        page.publish!
        Cmsimple::Page.published.first.should == page
      end

      it 'does not return the page if it is not published' do
        Cmsimple::Page.published.first.should be_nil
      end

      it 'does not return the page if it is to be published in the future' do
        page.published_at = 2.weeks.from_now
        page.save!
        Cmsimple::Page.published.first.should be_nil
      end
    end

    describe 'consuming published content' do
      before do
        page.update_content({:content => {:value => 'content version 1'}})
        page.publish!
      end

      it 'returns puslished content when in published mode if there are unpublished changes' do
        page.update_content({:content => {:value => 'content version 2'}})
        page.as_published!
        page.regions.content.to_s.should == 'content version 1'
      end
    end
  end

  describe 'versioning' do

    before do
      page.update_content({:content => {:value => 'content version 1'}})
      page.publish!
      page.update_content({:content => {:value => 'content version 2'}})
      page.publish!
      page.update_content({:content => {:value => 'content version 3'}})
      page.publish!
      page.versions.reload
    end

    describe 'can return a page at a specific version' do
      it 'returns the page with the content from the requested version' do
        version = page.versions.last
        page.at_version!(version.id)
        page.regions.content.to_s.should == 'content version 1'
      end

      it 'returns the page with the content from another requested version' do
        version = page.versions.second
        page.at_version!(version.id)
        page.regions.content.to_s.should == 'content version 2'
      end
    end

    describe 'reverting' do
      it 'can revert to a specific version' do
        version = page.versions.last
        page.revert_to!(version.id)
        Cmsimple::Page.find(page.id).regions.content.to_s.should == 'content version 1'
      end

      it 'can not revert to a version that is not from the pages history' do
        other_page = Cmsimple::Page.create title: 'Contact'
        other_page.update_content({:content => {:value => 'content version 1'}})
        other_page.publish!
        expect{ page.revert_to!(other_page.versions.first.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
