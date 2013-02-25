@javascript
Feature: As a user I should be able to create pages on the site

  Background:
    Given a page exists at a custom path with custom content
    And I visit that page's edit path

  Scenario: As a user I add a page from the sitemap panel
    When I open the sitemap
    And I add a new page
    Then I should be redirected to the new page
    And I should see the page in the sitemap

  Scenario: As a user I add a new home page from the sitemap panel
    When I open the sitemap
    And I add a new home page
    Then I should be redirected to the home page
    And I should see the page in the sitemap
