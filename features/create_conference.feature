Feature: Create conference
  In order to have conferences
  As a member
  I want to create new conferences  
  
  
  Background:
    Given a user exists with email: "stefan@lesscode.de", password: "lesscode", is_administrator: false
    And I am logged in with "stefan@lesscode.de/lesscode"


  Scenario: only logged in users can create conferences
    Given I am logged out
    When I go to "/conferences/new"
    Then I should be on "/users/sign_in"
    And I should see "You need to sign in or sign up before continuing."
  
  
  Scenario: create a new conferences      
    Given I am on "/conferences"
    And I should see "Listing conferences"
    And I follow "New Conference"
    When I fill in the following:
      | Name        | conference 1                                  |
      | Description | lorem ipsum                                   |
      | Location    | bcc Berliner Congress Center, Berlin, Germany |
    And I check "Life Science"
    And I select "2010" from "conference_start_date_1i"
    And I select "February" from "conference_start_date_2i"
    And I select "10" from "conference_start_date_3i"

    And I select "2010" from "conference_end_date_1i"
    And I select "February" from "conference_end_date_2i"
    And I select "20" from "conference_end_date_3i"

    And I press "Create"
    Then I should be on "/conferences/conference-1"
    And I should see "Conference 'conference 1'"
    And I should see "bcc Berliner Congress Center, Berlin, Germany"
    And I should see "lorem ipsum"
    And I should see "2010-02-10"
    And I should see "2010-02-20"

  