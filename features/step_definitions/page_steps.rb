
Given 'a page exists at a custom path with custom content' do
  @content = '<h1>Hello!</h1>'
  @path    = '/about'
  @page = Cmsimple::Page.create(content: @content, path: @path)
end

When "I visit that page's path" do
  visit @path
end

Then "I should see that page's content" do
  page.driver.response.body.should =~ /#{@content}/
end

Then "I should see that page's content in it's template" do
  page.driver.response.body.should =~ /#{@content}/
  template = "<section class='content'>"
  page.driver.response.body.should =~ /#{template}/
  puts page.driver.response.body
end
