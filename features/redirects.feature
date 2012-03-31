@javascript
Feature: As a user I should be able to add redirects on the site

  Background:
    Given a page exists at a custom path with custom content
    And I visit that page's edit path

  Scenario: As a user I add a redirect from the redirects panel
    When I open the redirects
    And I add a new redirect
    Then I should see the path in the redirects

    When I visit the new redirect
    Then I should be redirected to the about page

  Scenario: As a user I should not be able to add a duplicate redirect from the redirects panel
    When I open the redirects
    And I add a new duplicate redirect
    Then I should not see the duplicate path in the redirects
    And I should be alerted to the duplicate redirect

  Scenario: As a user I delete a redirect from the redirects panel
    Given I open the redirects
    And I add a new redirect
    When I delete the redirect
    Then I should not see the path in the redirects

