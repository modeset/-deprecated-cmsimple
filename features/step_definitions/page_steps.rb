
Given 'a page exists at a custom path with custom content' do
  @content = '<h1>Hello!</h1>'
  @page = Cmsimple::Page.create!(title: 'About', published: true)
  @path = @page.uri
  @page.update_content({:editable1 => {:value => @content}})
  @page.publish!
end

When "I visit that page's path" do
  visit @path
end

When "I save and reload the page" do
  step(%{I click on the "save" button})
  visit current_path
end

When "I visit that page's edit path" do
  visit ['/editor', @path].join
end

When "I visit the current page's public path" do
  visit current_path.gsub('/editor', '')
end

When "I visit the current page's edit path" do
  visit ['/editor', current_path].join
end

When "I add a new redirect" do
  step %(the editor won't prompt when leaving the page)
  click_button 'Add Redirect'
  fill_in 'From', :with => '/redirect-path'
  fill_in 'To', :with => '/about'
  click_button 'Create'
end

When "I delete the redirect" do
  within '.mercury-panel .redirects' do
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

When "I expand the toolbar if necessary" do
  page.first(:css, '.mercury-toolbar-expander').try(:click)
end

When "I edit the page's metadata" do
  step %{the toolbar should be visible}
  step %{I expand the toolbar if necessary}
  step %{I click on the "editMetadata" button}
  step %{the modal window should be visible}
end

When "I open the sitemap" do
  step %{the toolbar should be visible}
  step %{I expand the toolbar if necessary}
  step %{I click on the "sitemap" button}
  step %{the sitemap panel should be visible}
end

When "I open the redirects" do
  step %{the toolbar should be visible}
  step %{I expand the toolbar if necessary}
  step %{I click on the "redirects" button}
  step %{the redirect panel should be visible}
end

When "I open the page's history" do
  step %{the toolbar should be visible}
  step %{I expand the toolbar if necessary}
  step %{I click on the "history" button}
  step %{the history panel should be visible}
end

When "I view the old version" do
  within '.mercury-panel .versions' do
    link = all('.view').last
    link.click
  end
end

When "I add a new page" do
  click_button 'Add Page'
  step %{the modal window should be visible}
  fill_in 'Title', :with => 'Some new page'
  click_button 'Create Page'
end

When "I add a new home page" do
  click_button 'Add Page'
  step %{the modal window should be visible}
  fill_in 'Title', :with => 'Some new home page'
  check 'Home Page'
  click_button 'Create Page'
end

When(/^I change the template to "([^"]*)"/) do |template|
  select template, :from => 'Template'
  click_button 'Update Page'
end

When (/^I change the seo info of the page/) do
  fill_in 'Keywords', :with => 'some_keyword, someother_keyword'
  fill_in 'Description', :with => 'This is a description of the page'
  fill_in 'Browser title', :with => 'This is a new title for the browser'
  click_button 'Update Page'
end

When(/^I change the slug to "([^"]*)"/) do |path|
  fill_in 'Slug', :with => path
  click_button 'Update Page'
  expect(page).to_not have_content('Update Page')
end

When "I publish the current page" do
  step %{I change the contents of editable1 to "This is a published page"}
  step %{I click on the "save" button}
  step %{I click on the "publish" button}
  step %{the modal window should be visible}
  wait_for_client_page_refresh do
    click_button 'Publish'
  end
end

When "I make changes to the current page" do
  step %{I change the contents of editable1 to "This is changed content"}
  wait_for_client_page_refresh do
    step %{I click on the "save" button}
  end
end

When "I publish a new version of the current page" do
  step %{I change the contents of editable1 to "This is a new version"}
  step %{I click on the "save" button}
  step %{I click on the "publish" button}
  step %{the modal window should be visible}
  click_button 'Publish'
end

Then "I should see that page's content" do
  expect(page.driver.response.body).to match(/#{@content}/)
end

Then "I should see that page's content in it's template" do
  region = <<-HTML
<section data-mercury='full' id='editable1'>
#{@content}
</section>
  HTML
  expect(page.driver.response.body).to match(/#{region}/)
end

Then "I should be able to edit that page's content" do
  within_frame 'mercury_iframe' do
    within "section[data-mercury='full']" do
      expect(page.body).to match(/#{@content}/)
    end
  end
end

Then "I should be redirected to the new page" do
  expect(current_path).to eq("/editor/some-new-page")
end

Then "I should be redirected to the home page" do
  expect(current_path).to match(/^\/editor\/?$/)
end

Then "I should be redirected to the about page" do
  expect(current_path).to eq("/about")
end

Then (/I should see the (.+) in the sitemap/) do |page|
  within '.mercury-panel .sitemap' do
    expect(page).to have_content "#{page}"
  end
end

Then "I should see the path in the redirects" do
  within '.mercury-panel .redirects' do
    expect(page).to have_content "/redirect-path"
  end
end

Then "I should not see the path in the redirects" do
  within '.mercury-panel' do
    expect(page).to_not have_content "/redirect-path"
  end
end

Then "I should not see the duplicate path in the redirects" do
  within '.mercury-panel' do
    expect(page).to_not have_content "/about"
  end
end

Then "I should be alerted to the duplicate redirect" do
  expect(page).to have_content 'Source URL must be unique'
end

Then (/^I should see that seo info on the page/) do
  allow_hidden_elements do

    visit current_path.gsub('/editor', '')
    within('title') do
      expect(page).to have_content('This is a new title for the browser')
    end

    expect(page).to have_css('meta[name="keywords"]')
    expect(page).to have_css('meta[content="some_keyword, someother_keyword"]')
    expect(page).to have_css('meta[name="description"]')
    expect(page).to have_css('meta[content="This is a description of the page"]')

  end
end

Then "the current page should be publicly available" do
  step %(I visit the current page's public path)
  expect(current_path).to_not match(/\/editor/)
  expect(page).to have_content('This is a published page')
end

Then "the current page should only show published content" do
  step %(the current page should be publicly available)
end

Then "I there should be one version in the history panel" do
  within '.mercury-panel .versions' do
    expect(page).to have_selector 'li', count: 1
  end
end

Then "I should see the old version" do
  within_frame 'mercury_iframe' do
    within "section[data-mercury='full']" do
      expect(page).to have_content('This is a published page')
    end
  end
end

Then "there should be an indication of unpublished changes" do
  step %{I wait for ajax requests to complete}
  within '.mercury-primary-toolbar' do
    expect(page).to have_selector '.mercury-publish-button.unpublished'
  end
end

Then "there should not be an indication of unpublished changes" do
  within '.mercury-primary-toolbar' do
    expect(page).to_not have_selector '.mercury-publish-button.unpublished'
  end
end
