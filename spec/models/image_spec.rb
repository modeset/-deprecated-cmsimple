require 'spec_helper'
describe Cmsimple::Image do
  include CarrierWave::Test::Matchers

  before do
    @file_fixture_path = Cmsimple::Engine.root.join('spec', 'fixtures', 'rails.png')
    @file_fixture = File.open(@file_fixture_path)
    I18n.enforce_available_locales = false
  end

  after do
    @file_fixture.close
    Cmsimple::Image.all.each { |img| img.attachment.remove! }
  end

  subject { Cmsimple::Image.new }
  it { should validate_presence_of(:attachment) }

  describe 'image attachment uploader' do
    it 'has an uploader mounted to attachment' do
      subject.attachment.should be_a(ImageAttachmentUploader)
    end
  end

  describe 'attachment attributes' do
    before do
      @image = Cmsimple::Image.new attachment: @file_fixture
      @image.save!
    end

    it 'sets content_type from the file' do
      @image.content_type.should == 'image/png'
    end

    it 'sets file_size from the file' do
      @image.file_size.should == @file_fixture.size
    end

    it 'sets width from the file' do
      @image.width.should == 50
    end

    it 'sets height from the file' do
      @image.height.should == 64
    end
  end
end
