require 'spec_helper'
describe Cmsimple::Region do

  it 'returns the value on to_s' do
    region = Cmsimple::Region.new value: 'hello'
    expect(region.to_s).to eq('hello')
  end

  it 'returns an empty string for a non-existent region' do
    region = Cmsimple::Region.new nil
    expect(region.to_s).to eq('')
  end

end
