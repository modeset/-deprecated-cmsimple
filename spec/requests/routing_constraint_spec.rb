require 'spec_helper'

describe 'Routing Constraints' do
  it 'should raise a PageNotFoundError if no route matches' do
    expect {
      get '/foo'
    }.to raise_error Cmsimple::PageNotFoundError
    get '/foo'
    puts "request", request
  end
end
