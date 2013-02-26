require 'spec_helper'

describe 'Routing Constraints', type: :routing do
  it 'should raise a PageNotFoundError if no route matches' do
    expect(get: '/foo').to_not be_routable
  end
end
