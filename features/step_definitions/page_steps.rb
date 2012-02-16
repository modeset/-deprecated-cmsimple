
Given 'a page exists at a custom path with custom content' do
  @content = '<h1>Hello!</h1>'
  @path    = '/about'
  @page = Cmsimple::Page.create(path: @path)
  @page.update_content({:content => {:value => @content}})
end

When "I visit that page's path" do
  visit @path
end

When "I visit that page's edit path" do
  visit ['/editor', @path].join
end

Then "I should see that page's content" do
  page.driver.response.body.should =~ /#{@content}/
end

Then "I should see that page's content in it's template" do
  page.driver.response.body.should =~ /#{@content}/
  template = "<section class='mercury-region' data-type='editable' id='content'>"
  page.driver.response.body.should =~ /#{template}/
  puts page.driver.response.body
end

Then "I should be able to edit that page's content" do
  sleep(1)
  within_frame 'mercury_iframe' do
    page.body.should =~ /#{@content}/
  end
end
