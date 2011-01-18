Feature: Manage categories
  In order to have categories
  As an admin
  I want to manage categories
  
  
  Background:
    Given a user exists with email: "stefan@lesscode.de", password: "lesscode", is_administrator: true
    And I am logged in with "stefan@lesscode.de/lesscode"
    And no category exists
  
  Scenario: No access for non admins
    Given I am logged out
    And a user exists with email: "heiko@lesscode.de", password: "lesscode", is_administrator: false
    And I am logged in with "heiko@lesscode.de/lesscode"
    When I go to "/admin/categories"
    Then I should be on "/"
    And I should see "You are not allowed to access this page. Please contact your admin if necessary!"
    
  
  Scenario: create a new category
    Given I am on "/admin/categories"
    And I should see "Listing categories"
    And I follow "New Category"
    When I fill in "Name" with "category 1"
    And I press "Create"
    Then I should be on "/admin/categories"
    And I should see the following table at "#categories":
      | Name       | Parent     |
      | category 1 |            |
  
  
  Scenario: create a new sub-category
    Given a category exists with name: "category 1"
    And I am on "/admin/categories/new"
    When I fill in "Name" with "category 2"
    And I select "category 1" from "Parent"
    And I press "Create"
    Then I should be on "/admin/categories"
    And I should see the following table at "#categories":
      | Name       | Parent     |
      | category 1 |            |
      | category 2 | category 1 |
  