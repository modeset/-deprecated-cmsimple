require 'spec_helper'
describe Cmsimple::Page do
  subject { Cmsimple::Page.new }
  it {should validate_presence_of(:path) }

  describe '#update_content' do
    before do
      subject.path = '/about'
      subject.save
    end

    it "updates content to a hash when json is given to #update_content" do
      subject.update_content(%{{"content":"hello world"}})
      subject.content.should be_a Hash
      subject.content['content'].should == 'hello world'
    end
  end

end
