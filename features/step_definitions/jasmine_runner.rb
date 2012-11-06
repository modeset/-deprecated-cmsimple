Then /all jasmine specs should pass/ do
  visit '/jasmine'
  wait_until 10 do
    page.evaluate_script('jasmine.getEnv().reporter.subReporters_[1].finished') == true
  end
  page.should have_css(".bar.passingAlert", :visible => true)
end
