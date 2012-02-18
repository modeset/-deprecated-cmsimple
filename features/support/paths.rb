
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  PATHS = {
    "the home page" => '/'
  }
  def path_to(page_name)
    PATHS[page_name] || page_name.gsub('"', '')
  end
end

World(NavigationHelpers)
