module StepUtils
  def wait_for_client_page_refresh
    page.driver.execute_script("window.__page_refreshed = false; CMSimple.Page.one('refresh', function(){ window.__page_refreshed = true; });")
    yield
    wait_until(10) do
      page.evaluate_script('window.__page_refreshed') == true
      # not sure why this makes the tests pass
      sleep(1)
    end
  end
  def wait_for_mercury_ready
    page.driver.execute_script("window.__mercury_ready = false; Mercury.one('ready', function(){ window.__mercury_ready = true; });")
    yield if block_given?
    wait_until(10) do
      page.evaluate_script('window.__mercury_ready') == true
      # not sure why this makes the tests pass
      sleep(1)
    end
  end
end
World(StepUtils)
