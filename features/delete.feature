@javascript
Feature: As a user I should be able to delete pages on the site

  Scenario: As a user I should be able to delete a page
    Given a page exists at a custom path with custom content
    And I visit that page's edit path
    And I edit the page's metadata
    And the editor won't prompt when leaving the page
    And I accept confirmations
    When I follow "Delete"
    Then I should be redirected to the home page

