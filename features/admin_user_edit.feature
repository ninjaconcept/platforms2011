Feature: Admin user edit
  In order to adminstrate the system
  As an admin user
  I want to administer user data

  Scenario: No access for normal users
    Given a user exists with email: "stefan@lesscode.de", password: "lesscode", is_administrator: false
    And I am logged in with "stefan@lesscode.de/lesscode"
    When I go to "/admin/users"
    Then I should be on "/"
    And I should see "You are not allowed to access this page. Please contact your admin if necessary!" 
  
  Scenario: access /admin/users
    Given a user exists with email: "stefan@lesscode.de", password: "lesscode", is_administrator: true
    And a user exists with is_administrator: false
    And I am logged in with "stefan@lesscode.de/lesscode"
    When I go to "/admin/users"
    Then I should see "Listing users"

  Scenario: make another user an admin
    Given a user exists with email: "stefan@lesscode.de", password: "lesscode", is_administrator: true
    And a user exist with id: 1000, is_administrator: false
    And I am logged in with "stefan@lesscode.de/lesscode"
    When I go to "/admin/users"
    And I follow "Edit" within "#user_1000"
    When I check "Is administrator"
    And I press "Update"
    Then I should see "User was successfully updated."
  