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

    let(:request) { ActionDispatch::TestRequest.new() }

    context "does not find a path to follow" do
      before do
        request.expects(:fullpath).returns('/foo').at_least_once
        request.expects(:params).returns(path: '/path')
      end
      it "does not raise and error" do
        expect(Cmsimple::Path.from_request(request)).to_not raise_error(ActiveRecord::RecordNotFound)
      end

      it "returns nil" do
        expect(Cmsimple::Path.from_request(request)).to eq(nil)
      end
    end

    context "default: finding the path via fullpath" do

      it "finds the redirect" do
        request.expects(:fullpath).returns('/path').at_least_once
        subject.uri = '/path'
        subject.redirect_uri = '/some-other-path'
        subject.save
        expect(Cmsimple::Path.from_request(request).destination.uri).to eq('/some-other-path')
      end

      it "finds the redirect when the path has an extension" do
        request.expects(:fullpath).returns('/LegacyCrap.aspx').at_least_once
        subject.uri = '/LegacyCrap.aspx'
        subject.redirect_uri = '/some-other-path'
        subject.save
        expect(Cmsimple::Path.from_request(request).destination.uri).to eq('/some-other-path')
      end
    end

    context "cant find the path via fullpath" do
      before do
        request.expects(:fullpath).returns('/foo').at_least_once
      end

      it 'returns the path that has a uri matching the request path' do
        request.expects(:params).returns(path: '/path')
        subject.uri = '/path'
        subject.redirect_uri = '/some-other-path'
        subject.save
        Cmsimple::Path.from_request(request).destination.uri.should == '/some-other-path'
      end

      it "returns the path with the associated page" do
        page = Cmsimple::Page.create title: 'About'
        Cmsimple::Path.create uri: '/about', page: page
        request.expects(:params).returns(path: '/about')
        Cmsimple::Path.from_request(request).destination.title.should == 'About'
      end

      it "returns the path where the associated page is marked as root" do
        page = Cmsimple::Page.create title: 'Home', is_root: true
        Cmsimple::Path.create uri: '/home', page: page
        request.expects(:params).returns(path: '/home')
        Cmsimple::Path.from_request(request).destination.title.should == 'Home'
      end

      it "normalizes the path before querying" do
        subject.uri = '/path'
        subject.redirect_uri = '/some-other-path'
        subject.save
        request.expects(:params).returns(path: '//path')
        Cmsimple::Path.from_request(request).destination.uri.should == '/some-other-path'
        request.expects(:params).returns(path: '//path/')
        Cmsimple::Path.from_request(request).destination.uri.should == '/some-other-path'
        request.expects(:params).returns(path: 'path')
        Cmsimple::Path.from_request(request).destination.uri.should == '/some-other-path'
        request.expects(:params).returns(path: '/Path')
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
