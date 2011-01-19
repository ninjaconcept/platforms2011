Feature: Session
  In order to access restricted pages
  As a signed in user
  I want to sign in
  
  Background:
    Given a user exists with username: "oliver", email: "oli@plat-forms.org", password: "supersecret"
  
  
  Scenario Outline: Login fails
    Given I am on "/users/sign_in"
    And I fill in the following:
      | Username | <username> |
      | Password | <password> | 
    And I press "Sign in"
    Then I should see "Invalid username or password."
    And I should be on "/users/sign_in"
  
    Examples:
      | username | password    |
      | oli      |             |
      | oliver   |             |
      |          |             |
      | oliver   | bad pass    |
      |          | supersecret |
      | oli      | supersecret |
  
  
  Scenario: Login with valid data
    Given I am on "/users/sign_in"
    And I fill in the following:
      | Username | oliver |
      | Password | supersecret | 
    And I press "Sign in"
    Then I should see "Signed in successfully."
    And I should be on "/"
    And I should see "Welcome to CaP"
    And I should see "Edit registration"
    And I should see "Logout"
    
    
  Scenario: Logout
    Given I am logged in with "oliver/supersecret"
    And I am on "/pages"
    When I follow "Logout"
    Then I should see "Signed out successfully."
    And I should be on "/"
    And I should see "Welcome to CaP"
    
    