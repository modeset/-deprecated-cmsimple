require 'spec_helper'
describe Cmsimple::Image do
  subject { Cmsimple::Image.new }
  it { should validate_presence_of(:attachment) }

  describe 'image attachment uploader' do
    it 'has an uploader mounted to attachment' do
      subject.attachment.should be_a(ImageAttachmentUploader)
    end
  end
end
