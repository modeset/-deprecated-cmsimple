module StepUtils
  def wait_for_client_page_refresh
    page.driver.execute_script("window.page_refreshed = false; CMSimple.Page.one('refresh', function(){ window.page_refreshed = true; });")
    yield
    wait_until do
      page.evaluate_script('window.page_refreshed') == true
    end
  end
end
World(StepUtils)
