require 'spec_helper'

describe Cmsimple::Error::PageNotFound do
  it "should report its path to the unfound page" do
    error = Cmsimple::Error::PageNotFound.new("/front-page")
    expect(error.message).to eq("'/front-page' is not a viewable page")
  end
end
