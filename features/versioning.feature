@javascript
Feature: As a user I should be able to view different versions of pages on the site

  Background:
    Given a page exists at a custom path with custom content
    And I visit that page's edit path

  Scenario: As a user I should be able to see the versions
    that have been created when I publish a page
    Given I open the sitemap
    And I add a new page
    When I publish the current page
    And I open the page's history
    Then I there should be one version in the history panel

  Scenario: As a user I should be able to view the page
    at a particular version that has been published
    Given I open the sitemap
    And I add a new page
    And I publish the current page
    When I publish a new version of the current page
    And I open the page's history
    And I view the old version
    Then I should see the old version
    # When I view the new version
    # Then I should see the new version

