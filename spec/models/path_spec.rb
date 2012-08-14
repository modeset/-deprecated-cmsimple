require 'spec_helper'
describe Cmsimple::Path do
  subject { Cmsimple::Path.new }
  it { should validate_presence_of(:uri) }
  it { should belong_to(:page) }

  it 'downcases its URI on save' do
    page = Cmsimple::Page.create title: 'Test'
    path = Cmsimple::Path.create page: page, uri: '/TestRedirect'
    path.uri.should == '/testredirect'
  end

  describe 'destination' do

    it 'is required' do
      subject.should_not be_valid
      subject.errors[:destination].should_not be_empty
    end

    it 'returns the destination path when a page is associated' do
      subject.page = Cmsimple::Page.new path: '/some-path'
      subject.destination.path.should == '/some-path'
    end

    it 'returns the destination path when it is a redirect' do
      subject.redirect_uri = '/some-other-path'
      subject.destination.path.should == '/some-other-path'
      subject.should be_redirect
    end

    it 'returns a redirect if the path does not match the page path' do
      subject.uri = '/path'
      subject.page = Cmsimple::Page.new path: '/some-other-path'
      subject.destination.should be_a(Cmsimple::Path::Redirect)
      subject.should be_redirect
    end

  end

  describe 'from_request' do

    it 'returns the path that has a uri mathing the request path' do
      subject.uri = '/path'
      subject.redirect_uri = '/some-other-path'
      subject.save
      Cmsimple::Path.from_request(OpenStruct.new(path: '/path')).destination.path.should == '/some-other-path'
    end

    it "returns the path with the associated page" do
      page = Cmsimple::Page.create title: 'About'
      Cmsimple::Path.create uri: '/about', page: page
      Cmsimple::Path.from_request(OpenStruct.new(path: '/about')).destination.title.should == 'About'
    end

    it "returns the path where the associated page is marked as root" do
      page = Cmsimple::Page.create title: 'Home', is_root: true
      Cmsimple::Path.create uri: '/home', page: page
      Cmsimple::Path.from_request(OpenStruct.new(path: '/')).destination.title.should == 'Home'
    end

    it "normalizes the path before querying" do
      subject.uri = '/path'
      subject.redirect_uri = '/some-other-path'
      subject.save
      Cmsimple::Path.from_request(OpenStruct.new(path: '//path')).destination.path.should == '/some-other-path'
      Cmsimple::Path.from_request(OpenStruct.new(path: '//path/')).destination.path.should == '/some-other-path'
      Cmsimple::Path.from_request(OpenStruct.new(path: 'path')).destination.path.should == '/some-other-path'
      Cmsimple::Path.from_request(OpenStruct.new(path: '/Path')).destination.path.should == '/some-other-path'
    end
  end
end
