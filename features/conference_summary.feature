Feature: Conference summary
  In order to have a valuable summary page
  As a member
  I want to see detailed information
  
  
  Scenario: no conferences
    Given no conference exists
    And I am on "/"
    When I am on "/conferences"
    Then I should see "No conferences found!"
    And I should not see "New Conference"
  
  
  Scenario: conference without attendees
    Given a user exists with username: "stefan", email: "stefan@lesscode.de", password: "lesscode", is_administrator: false
    And I am logged in with "stefan@lesscode.de/lesscode"
    And a conference exists with name: "Less Conf"
    When I am on "/conferences/less-conf"
    Then I should see "Conference 'Less Conf'"
    And I should see "Creator: username"
    And I should see "Attendees"
    And I should see "Nobody attends this conference!"  
  