require 'spec_helper'

describe Cmsimple::Version do
  subject { Cmsimple::Version.new }
  it { should belong_to :page }
  it { should validate_presence_of(:published_at) }
end
