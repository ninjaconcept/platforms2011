Feature: Manage conferences
  In order to have conferences
  As an admin
  I want to manage conferences
  
  
  Background:
    Given a user exists with email: "stefan@lesscode.de", password: "lesscode", is_administrator: false
    And I am logged in with "stefan@lesscode.de/lesscode"  
  
  Scenario: No access for non admins
    Given I am logged out
    And a user exists with email: "heiko@lesscode.de", password: "lesscode", is_administrator: false
    And I am logged in with "heiko@lesscode.de/lesscode"
    When I go to "/admin/conferences"
    Then I should be on "/"
    And I should see "You are not allowed to access this page. Please contact your admin if necessary!"