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
      subject.page = Cmsimple::Page.new uri: '/some-path'
      subject.destination.uri.should == '/some-path'
    end

    it 'returns the destination path when it is a redirect' do
      subject.redirect_uri = '/some-other-path'
      subject.destination.uri.should == '/some-other-path'
      subject.should be_redirect
    end

    it 'returns a redirect if the path does not match the page path' do
      subject.uri = '/path'
      subject.page = Cmsimple::Page.new uri: '/some-other-path'
      subject.destination.should be_a(Cmsimple::Path::Redirect)
      subject.should be_redirect
    end
  end

  describe '#from_request' do

    let(:request) { ActionDispatch::TestRequest.new }

    context "when there is no path to follow" do
      before do
        request.stub(:fullpath).and_return('/foo')
        request.stub(:params).and_return(path: '/path')
      end
      it "does not raise an error" do
        expect(Cmsimple::Path.from_request(request)).to_not raise_error(ActiveRecord::RecordNotFound)
      end

      it "returns nil" do
        expect(Cmsimple::Path.from_request(request)).to eq(nil)
      end
    end

    context 'without a path parameter' do
      it "should send you to Cmsimple root path" do
        page = Cmsimple::Page.create!(is_root: true, uri: "/foo", slug: "foo", title: "Foo")
        Cmsimple::Path.should_not_receive(:find_from_request)
        request.stub(:fullpath).and_return('/editor')
        request.stub(:params).and_return({})
        expect(Cmsimple::Path.from_request(request).destination.uri).to eq("/foo")
      end
    end

    context "when a path exists that matches the full request path" do
      before { request.stub(:params).and_return(path:nil) }

      it "finds the redirect" do
        request.stub(:fullpath).and_return('/path')
        subject.uri = '/path'
        subject.redirect_uri = '/some-other-path'
        subject.save
        expect(Cmsimple::Path.from_request(request).destination.uri).to eq('/some-other-path')
      end

      it "finds the redirect when the path has an extension" do
        request.stub(:fullpath).and_return('/Legacy.aspx')
        subject.uri = '/Legacy.aspx'
        subject.redirect_uri = '/some-other-path'
        subject.save
        expect(Cmsimple::Path.from_request(request).destination.uri).to eq('/some-other-path')
      end
    end

    context "when a path exists that matches the globbed request path" do
      before do
        request.stub(:fullpath).and_return('/foo')
      end

      it 'returns the path that has a uri matching the request path' do
        request.stub(:params).and_return(path: '/path')
        subject.uri = '/path'
        subject.redirect_uri = '/some-other-path'
        subject.save
        Cmsimple::Path.from_request(request).destination.uri.should == '/some-other-path'
      end

      it "returns the path with the associated page" do
        page = Cmsimple::Page.create title: 'About'
        Cmsimple::Path.create uri: '/about', page: page
        request.stub(:params).and_return(path: '/about')
        Cmsimple::Path.from_request(request).destination.title.should == 'About'
      end

      it "returns the path where the associated page is marked as root" do
        page = Cmsimple::Page.create title: 'Home', is_root: true
        Cmsimple::Path.create uri: '/home', page: page
        request.stub(:params).and_return(path: '/home')
        Cmsimple::Path.from_request(request).destination.title.should == 'Home'
      end

      it "normalizes the path before querying" do
        subject.uri = '/path'
        subject.redirect_uri = '/some-other-path'
        subject.save
        request.stub(:params).and_return(path: '//path')
        Cmsimple::Path.from_request(request).destination.uri.should == '/some-other-path'
        request.stub(:params).and_return(path: '//path/')
        Cmsimple::Path.from_request(request).destination.uri.should == '/some-other-path'
        request.stub(:params).and_return(path: 'path')
        Cmsimple::Path.from_request(request).destination.uri.should == '/some-other-path'
        request.stub(:params).and_return(path: '/Path')
        Cmsimple::Path.from_request(request).destination.uri.should == '/some-other-path'
      end
    end
  end

  describe "#from_request!" do
    let(:request) { ActionDispatch::TestRequest.new }

    it "raises ActiveRecord::RecordNotFound when no records are found" do
      Cmsimple::Path.should_receive(:from_request).with(request).and_return(nil)
      request.stub(:fullpath).and_return('/foo')
      request.stub(:params).and_return(path: '/foo')
      expect { Cmsimple::Path.from_request!(request) }.to raise_error ActiveRecord::RecordNotFound
    end

  end
end
