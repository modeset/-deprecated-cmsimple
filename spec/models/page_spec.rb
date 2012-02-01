require 'spec_helper'
describe Cmsimple::Page do
  subject { Cmsimple::Page.new }
  it {should validate_presence_of(:path) }
  it {should validate_presence_of(:content) }
end
