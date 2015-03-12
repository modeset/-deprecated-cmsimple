require 'spec_helper'

describe Cmsimple::Path do

  after(:each) do
    Cmsimple::Page.destroy_all
    Cmsimple::Path.destroy_all
  end

  subject { Cmsimple::Path.new }

  it { should validate_presence_of(:uri) }
  it { should belong_to(:page) }

  it 'downcases its URI on save' do
    page = Cmsimple::Page.create title: 'Test'
    path = Cmsimple::Path.create page: page, uri: '/TestRedirect'
    expect(path.uri).to eq('/testredirect')
  end

  describe 'destination' do

    it 'is required' do
      expect(subject).to_not be_valid
      expect(subject.errors[:destination]).to_not be_empty
    end

    it 'returns the destination path when a page is associated' do
      subject.page = Cmsimple::Page.new uri: '/some-path'
      expect(subject.destination.uri).to eq('/some-path')
    end

    it 'returns the destination path when it is a redirect' do
      subject.redirect_uri = '/some-other-path'
      expect(subject.destination.uri).to eq('/some-other-path')
      expect(subject).to be_redirect
    end

    it 'returns a redirect if the path does not match the page path' do
      subject.uri = '/path'
      subject.page = Cmsimple::Page.new uri: '/some-other-path'
      expect(subject.destination).to be_a(Cmsimple::Path::Redirect)
      expect(subject).to be_redirect
    end
  end

  describe '#from_request' do

    let(:request) { ActionDispatch::TestRequest.new }

    context "when there is no path to follow" do
      before do
        expect(request).to receive(:fullpath).and_return('foo').at_least(:once)
        expect(request).to receive(:params).and_return(path: '/path').at_least(:once)
      end
      it "does not raise an error" do
        expect{ Cmsimple::Path.from_request(request) }.to_not raise_error
      end

      it "returns nil" do
        expect(Cmsimple::Path.from_request(request)).to eq(nil)
      end
    end

    context 'without a path parameter' do
      it "should send you to Cmsimple root path" do
        Cmsimple::Page.create!(is_root: true, uri: "/foo", slug: "foo", title: "Foo")
        expect(Cmsimple::Path).to_not receive(:find_from_request)
        expect(request).to receive(:params).and_return({}).at_least(:once)
        expect(Cmsimple::Path.from_request(request).destination.uri).to eq("/foo")
      end
    end

    context "when a path exists that matches the full request path" do
      before { expect(request).to receive(:params).and_return(path:nil) }

      it "finds the redirect" do
        expect(request).to receive(:fullpath).and_return('/path')
        subject.uri = '/path'
        subject.redirect_uri = '/some-other-path'
        subject.save
        expect(Cmsimple::Path.from_request(request).destination.uri).to eq('/some-other-path')
      end

      it "finds the redirect when the path has an extension" do
        expect(request).to receive(:fullpath).and_return('/Legacy.aspx')
        subject.uri = '/Legacy.aspx'
        subject.redirect_uri = '/some-other-path'
        subject.save
        expect(Cmsimple::Path.from_request(request).destination.uri).to eq('/some-other-path')
      end
    end

    context "when a path exists that matches the globbed request path" do
      before do
        expect(request).to receive(:fullpath).and_return('/foo').at_least(:once)
      end

      it 'returns the path that has a uri matching the request path' do
        expect(request).to receive(:params).and_return(path: '/path').at_least(:once)
        subject.uri = '/path'
        subject.redirect_uri = '/some-other-path'
        subject.save
        expect(Cmsimple::Path.from_request(request).destination.uri).to eq('/some-other-path')
      end

      it "returns the path with the associated page" do
        page = Cmsimple::Page.create title: 'About'
        Cmsimple::Path.create uri: '/about', page: page
        expect(request).to receive(:params).and_return(path: '/about').at_least(:once)
        expect(Cmsimple::Path.from_request(request).destination.title).to eq('About')
      end

      it "returns the path where the associated page is marked as root" do
        page = Cmsimple::Page.create title: 'Home', is_root: true
        Cmsimple::Path.create uri: '/home', page: page
        expect(request).to receive(:params).and_return(path: '/home').at_least(:once)
        expect(Cmsimple::Path.from_request(request).destination.title).to eq('Home')
      end

      context 'normalizing the path before querying' do
        before do
          subject.uri = '/path'
          subject.redirect_uri = '/some-other-path'
          subject.save
        end

        it 'removes front slashes' do
          expect(request).to receive(:params).and_return(path: '//path').at_least(:once)
          expect(Cmsimple::Path.from_request(request).destination.uri).to eq('/some-other-path')
        end

        it 'removes trailing slashes' do
        expect(request).to receive(:params).and_return(path: '//path/').at_least(:once)
        expect(Cmsimple::Path.from_request(request).destination.uri).to eq('/some-other-path')
        end

        it 'adds a forward slash to the path' do
          expect(request).to receive(:params).and_return(path: 'path').at_least(:once)
          expect(Cmsimple::Path.from_request(request).destination.uri).to eq('/some-other-path')
        end

        it 'ignores case' do
          expect(request).to receive(:params).and_return(path: '/Path').at_least(:once)
          expect(Cmsimple::Path.from_request(request).destination.uri).to eq('/some-other-path')
        end
      end
    end
  end

  describe "#from_request!" do
    let(:request) { ActionDispatch::TestRequest.new }

    it "raises ActiveRecord::RecordNotFound when no records are found" do
      expect(Cmsimple::Path).to receive(:from_request).with(request).and_return(nil)
      expect { Cmsimple::Path.from_request!(request) }.to raise_error ActiveRecord::RecordNotFound
    end

  end
end
