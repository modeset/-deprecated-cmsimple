require 'spec_helper'
describe Cmsimple::Regions do

  it 'defines instance methods for each region in the hash' do
    regions = Cmsimple::Regions.new content: {value: 'hello'}
    regions.should respond_to :content
  end

  it 'returns the value on to_s' do
    regions = Cmsimple::Regions.new content: {value: 'hello'}
    regions.content.html_safe.should == 'hello'
  end
end
