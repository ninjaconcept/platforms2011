Feature: Manage conferences
  In order to have conferences
  As an admin
  I want to manage conferences
  
  
  Background:
    Given a user exists with email: "stefan@lesscode.de", password: "lesscode", is_administrator: true
    And I am logged in with "stefan@lesscode.de/lesscode"
    And no conference exists  
  
  Scenario: No access for non admins
    Given I am logged out
    And a user exists with email: "heiko@lesscode.de", password: "lesscode", is_administrator: false
    And I am logged in with "heiko@lesscode.de/lesscode"
    When I go to "/admin/conferences"
    Then I should be on "/"
    And I should see "You are not allowed to access this page. Please contact your admin if necessary!"
    
  @focus
  Scenario: create a new conferences
    Given I am on "/admin/conferences"
    And I should see "Listing conferences"
    And I follow "New Conference"
    When I fill in the following:
      | Name | conference 1|
      | Description | lorem ipsum |
      | Location | bcc Berliner Congress Center, Berlin, Germany |
    And I check "Life Science"
    And I select "2010" from "conference_start_date_1i"
    And I select "February" from "conference_start_date_2i"
    And I select "10" from "conference_start_date_3i"
    
    And I select "2010" from "conference_end_date_1i"
    And I select "February" from "conference_end_date_2i"
    And I select "20" from "conference_end_date_3i"
    
    And I press "Create"
    Then I should be on "/admin/conferences"
    And I should see the following table at "#conferences":
      | Name         |  Location |
      | conference 1 | bcc Berliner Congress Center, Berlin, Germany |