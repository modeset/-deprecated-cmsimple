
Given 'a page exists at a custom path with custom content' do
  @content = '<h1>Hello!</h1>'
  @page = Cmsimple::Page.create!(title: 'About')
  @path = @page.path
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
  current_path.should == '/editor/some-new-page'
end

Then "I should be redirected to the home page" do
  current_path.should == '/editor/'
end

Then "I should be redirected to the about page" do
  current_path.should == '/about'
end

Then "I should see the page in the sitemap" do
  within '.mercury-panel' do
    page.should have_content 'Some new page'
  end
end

Then "I should see the path in the redirects" do
  within '.mercury-panel' do
    page.should have_content '/redirect-path'
  end
end

Then "I should not see the path in the redirects" do
  within '.mercury-panel' do
    page.should_not have_content '/redirect-path'
  end
end

Then "I should not see the duplicate path in the redirects" do
  within '.mercury-panel' do
    page.should_not have_content '/about'
  end
end

Then "I should be alerted to the duplicate redirect" do
  page.should have_content 'Source URL must be unique'
end

When "I add a new redirect" do
  step %(the editor won't prompt when leaving the page)
  click_button 'Add Redirect'
  fill_in 'From', :with => '/redirect-path'
  fill_in 'To', :with => '/about'
  click_button 'Create'
end

When "I delete the redirect" do
  within '.mercury-panel' do
    link = find '.remove'
    link.click
  end
end

When "I add a new duplicate redirect" do
  step %(the editor won't prompt when leaving the page)
  page.driver.execute_script("window.alert = function(message){jQuery('body').append('<span>' + message + '</span>')}")
  click_button 'Add Redirect'
  fill_in 'From', :with => '/about'
  fill_in 'To', :with => '/about-us'
  click_button 'Create'
end

When "I visit the new redirect" do
  step %(the editor won't prompt when leaving the page)
  visit '/redirect-path'
end

When "I edit the page's metadata" do
  step %{I click on the "editMetadata" button}
  step %{the modal window should be visible}
end

When "I open the sitemap" do
  step %{I click on the "sitemap" button}
  step %{the sitemap panel should be visible}
end

When "I open the redirects" do
  step %{I click on the "redirects" button}
  step %{the redirect panel should be visible}
end

When "I add a new page" do
  click_button 'Add Page'
  step %{the modal window should be visible}
  fill_in 'Title', :with => 'Some new page'
  fill_in 'Slug', :with => 'some-new-page'
  click_button 'Create Page'
end

When "I add a new home page" do
  click_button 'Add Page'
  step %{the modal window should be visible}
  fill_in 'Title', :with => 'Some new page'
  fill_in 'Slug', :with => 'some-new-page'
  check 'Home Page'
  click_button 'Create Page'
end

When /^I change the template to "([^"]*)"/ do |template|
  select template, :from => 'Template'
  click_button 'Update Page'
end

When /^I change the seo info of the page/ do
  fill_in 'Keywords', :with => 'some_keyword, someother_keyword'
  fill_in 'Description', :with => 'This is a description of the page'
  fill_in 'Browser title', :with => 'This is a new title for the browser'
  click_button 'Update Page'
end

Then /^I should see that seo info on the page/ do
  visit current_path.gsub('/editor', '')
  within('title') do
    page.should have_content('This is a new title for the browser')
  end
  page.should have_css('meta[name="keywords"]')
  page.should have_css('meta[content="some_keyword, someother_keyword"]')
  page.should have_css('meta[name="description"]')
  page.should have_css('meta[content="This is a description of the page"]')
end

When /^I change the slug to "([^"]*)"/ do |path|
  fill_in 'Slug', :with => path
  click_button 'Update Page'
end

