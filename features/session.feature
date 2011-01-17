Feature: Session
  In order to access restricted pages
  As a signed in user
  I want to sign in
  
  Background:
    Given a user exists with email: "oli@plat-forms.org", password: "supersecret"
  
  
  Scenario Outline: Login fails
    Given I am on "/users/sign_in"
    And I fill in the following:
      | Email | <email> |
      | Password | <password> | 
    And I press "Sign in"
    Then I should see "Invalid email or password."
    And I should be on "/users/sign_in"
  
    Examples:
      | email           | password    |
      |                 |             |
      | oli             |             |
      | oli@plat-forms.org |             |
      | oli@plat-forms.org | bad pass    |
      |                 | supersecret |
      | oli             | supersecret |
  
  
  Scenario: Login with valid data
    Given I am on "/users/sign_in"
    And I fill in the following:
      | Email | oli@plat-forms.org |
      | Password | supersecret | 
    And I press "Sign in"
    Then I should see "Signed in successfully."
    And I should be on "/"
    And I should see "Welcome to Platforms 2011"
    And I should see "Edit registration"
    And I should see "Logout"
    
    
  Scenario: Logout
    Given I am logged in with "oli@plat-forms.org/supersecret"
    And I am on "/pages"
    When I follow "Logout"
    Then I should see "Signed out successfully."
    And I should be on "/"
    And I should see "Welcome to Platforms 2011"
    
    