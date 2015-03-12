module StepUtils
  def wait_for_client_page_refresh
    page.driver.execute_script("window.__page_refreshed = false; CMSimple.Page.one('refresh', function(){ window.__page_refreshed = true; });")
    yield
    page.evaluate_script('window.__page_refreshed') == true
  end

  def allow_hidden_elements
    Capybara.ignore_hidden_elements = false
    yield
    Capybara.ignore_hidden_elements = true
  end
end
World(StepUtils)
