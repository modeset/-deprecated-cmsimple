Feature: As a user I should be able to visit pages on the site

  Scenario: As a user I should be able to view the home page
    When I go to the home page
    Then I should see "Hello"
