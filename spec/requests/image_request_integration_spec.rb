require 'spec_helper'

describe 'ImageRequest', type: :request do
  after do
    Cmsimple::Image.destroy_all
  end
  let(:file) { Rack::Test::UploadedFile.new(['spec', 'fixtures', 'rails.png'].join('/'), 'image/png')}
  context '#create' do
    it 'adds an image' do
      image = {title: 'my title', attachment: file}
      expect{post '/cmsimple/images', image: image}.to change{Cmsimple::Image.count}.by(1)
      expect(Cmsimple::Image.where(title: 'my title').length).to eq(1)
    end
  end
end
