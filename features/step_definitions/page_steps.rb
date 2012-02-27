
Given 'a page exists at a custom path with custom content' do
  @content = '<h1>Hello!</h1>'
  @path    = '/about'
  @page = Cmsimple::Page.create(path: @path, title: 'About')
  @page.update_content({:editable1 => {:value => @content}})
end

When "I visit that page's path" do
  visit @path
end

When "I save and reload the page" do
  step(%{I click on the "Save" button})
  visit current_path
end

When "I visit that page's edit path" do
  visit ['/editor', @path].join
end

Then "I should see that page's content" do
  page.driver.response.body.should =~ /#{@content}/
end

Then "I should see that page's content in it's template" do
  page.driver.response.body.should =~ /#{@content}/
  template = "<section class='mercury-region' data-type='editable' id='editable1'>"
  page.driver.response.body.should =~ /#{template}/
  puts page.driver.response.body
end

Then "I should be able to edit that page's content" do
  sleep(1)
  within_frame 'mercury_iframe' do
    within '.mercury-region' do
      page.body.should =~ /#{@content}/
    end
  end
end

Then "I should be redirected to the new page" do
  current_path.should == '/editor/some_new_page'
end

Then "I should see the page in the sitemap" do
  within '.mercury-panel' do
    page.should have_content 'Some new page'
  end
end

When "I edit the page's metadata" do
  step %{I click on the "editMetadata" button}
  step %{the modal window should be visible}
end

When "I open the sitemap" do
  step %{I click on the "sitemap" button}
  step %{the sitemap panel should be visible}
end

When "I add a new page" do
  click_button 'Add Page'
  step %{the modal window should be visible}
  fill_in 'Title', :with => 'Some new page'
  fill_in 'Path', :with => '/some_new_page'
  click_button 'Create Page'
end

When /^I change the template to "([^"]*)"/ do |template|
  select template, :from => 'Template'
  click_button 'Update Page'
end

When /^I change the path to "([^"]*)"/ do |path|
  fill_in 'Path', :with => path
  click_button 'Update Page'
end

