require 'spec_helper'

describe 'PathRequests' do
  let(:path) { {path: {page_id: '1', uri: '/foo', redirect_uri: '/bar'}} }
  after do
    Cmsimple::Path.destroy_all
  end
  context '#create' do
    it 'can create a new redirect' do
      expect {post '/paths', path, {'HTTP_ACCEPT' => 'application/json'}}.to change {Cmsimple::Path.count}.by(1)
      expect(Cmsimple::Path.where(redirect_uri: '/bar').first.page_id).to eq(1)
    end
  end
end
