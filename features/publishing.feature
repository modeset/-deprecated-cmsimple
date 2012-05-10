@javascript
Feature: As a user I should be able to create pages on the site

  Background:
    Given a page exists at a custom path with custom content
    And I visit that page's edit path

  Scenario: As a user I have to publish pages for them to be public
    Given I open the sitemap
    And I add a new page
    When I publish the current page
    Then the current page should be publicly available

  Scenario: As a user changes to a page don't appear to the public until they are published
    Given I open the sitemap
    And I add a new page
    And I publish the current page
    When I make changes to the current page
    Then the current page should only show published content

  Scenario: A user should see an indication of having unpublished changes
    Given I open the sitemap
    When I add a new page
    Then there should be an indication of unpublished changes

    When I publish the current page
    Then there should not be an indication of unpublished changes

    When I make changes to the current page
    Then there should be an indication of unpublished changes

