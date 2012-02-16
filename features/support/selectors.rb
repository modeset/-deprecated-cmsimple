
module HtmlSelectorsHelpers
  # Maps a name to a selector. Used primarily by the
  #
  #   When /^(.+) within (.+)$/ do |step, scope|
  #
  # step definitions in web_steps.rb
  #
  def selector_for(locator)

    # add in for mercury support
    result = mercury_selector_for(locator)
    return result if result.present?

    case locator
      when /the page/
        "html > body"
      when /"(.+)"/
        $1
      else
        raise "Can't find mapping from \"#{locator}\" to a selector.\n" +
                      "Now, go and add a mapping in #{__FILE__}"
    end
  end
end
World(HtmlSelectorsHelpers)
