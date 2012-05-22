module StepUtils
  def wait_for_client_page_refresh
    page.driver.execute_script("window.page_refreshed = false; CMSimple.Page.one('refresh', function(){ window.page_refreshed = true; });")
    yield
    wait_until(10) do
      page.evaluate_script('window.page_refreshed') == true
      # not sure why this makes the tests pass
      sleep(1)
    end
  end
end
World(StepUtils)
