require 'spec_helper'
describe Cmsimple::RegionProxy do

  describe 'region proxy' do
    it 'defines instance methods for each region in the hash' do
      regions = Cmsimple::RegionProxy.new content: {value: 'hello'}
      regions.should respond_to :content
    end

    it 'defines instance methods for each region in the hash' do
      regions = Cmsimple::RegionProxy.new content: {value: 'hello'}
      regions.content.should be_a(Cmsimple::Region)
    end

    it 'returns a NillRegion if no region present' do
      regions = Cmsimple::RegionProxy.new nil
      regions.content.should be_a(Cmsimple::Region)
    end
  end

end
