@javascript
Feature: As a user I should be able to create pages on the site

  Background:
    Given a page exists at a custom path with custom content
    And I visit that page's edit path

  Scenario: As a user I add a page from the sitemap panel
    Given I open the sitemap
    And I add a new page
    When I publish the current page
    Then the current page should be publicly available

