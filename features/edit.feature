@javascript
Feature: As a user I should be able to edit pages on the site

  Scenario: As a user I should be able to view a page with custom content at a specified path
    Given a page exists at a custom path with custom content
    When I visit that page's edit path
    Then I should be able to edit that page's content

