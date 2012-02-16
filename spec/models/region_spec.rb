require 'spec_helper'
describe Cmsimple::Region do

  it 'returns the value on to_s' do
    region = Cmsimple::Region.new value: 'hello'
    region.to_s.should == 'hello'
  end

  it 'returns an empty string for a non-existent region' do
    region = Cmsimple::Region.new nil
    region.to_s.should == ''
  end

end
