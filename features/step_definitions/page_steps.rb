Given 'a page exists at a custom path with custom content' do
  @content = 'Hello!'
  @path    = '/about'
  @page = Cmsimple::Page.create(content: @content, path: @path)
end

When "I visit that page's path" do
  visit @path
end

Then "I should see that page's content" do
  page.driver.response.body.should =~ /#{@content}/
end

