Feature: Signup
  In order to access restricted pages
  As a registered user
  I want to signup
  
  
  Scenario: Signup form
    Given I am on the home page
    When I am on "/users/sign_up"
    Then I should see "Sign up"
    And I should see "Username"
    And I should see "Email"
    And I should see "Password"
    And I should see "Password confirmation"
    And I should see "Full name"
    And I should see "Town"
    And I should see "Country"
    And I should see "GPS"
    And I should see "Sign up"
    And I should see "Sign in"
    And I should see "Forgot your password?"
    And I should see "Didn't receive unlock instructions?"
  
  @focus
  Scenario: Sign up with valid data
    Given I am on "/users/sign_up"
    And I fill in the following:
      | Username              | stefan                |
      | Email                 | stefan@plat-forms.org |
      | Password              | superpass             |
      | Password confirmation | superpass             |
      | Full name             | Stefan Botzenhart     |
      | Town                  | Karlsruhe             |
      | Country               | Germany               |
      | GPS                   |                       |
    When I press "Sign up"
    Then I should see "You have signed up successfully. If enabled, a confirmation was sent to your e-mail."
    And I should be on "/"
    And I should see "Welcome to Platforms 2011"
    And 1 email should be delivered to stefan@plat-forms.org
    # And "stefan@plat-forms.org" should have subject: Confirmation instructions
    When I click the first link in email
    Then I should see "Your account was successfully confirmed. You are now signed in."
  

  Scenario Outline: Signup with invalid data
    Given I am on "/users/sign_up"
    And I fill in the following:
      | Username              | <username>              |
      | Email                 | <email>                 |
      | Password              | <password>              |
      | Password confirmation | <password_confirmation> |
      | Full name             | <full_name>             |
      | Town                  | <town>                  |
      | Country               | <country>               |
    When I press "Sign up"
    And I should see "<error_message>"
    And I should be on "/users"
    
    Examples:
      | email                 | password   | password_confirmation | username | full_name | town   | country | error_message                                  |
      |                       |            |                       |          |           |        |         | 6 errors prohibited this user from being saved |
      | stefan@plat-forms.org |            |                       |          |           |        |         | 5 errors prohibited this user from being saved |
      | stefan@plat-forms.org | superpass  |                       | stefan   | Stevie B  | Munich | Germany | 1 error prohibited this user from being saved  |
      | stefan@plat-forms.org | superpass  | superpass1            | stefan   | Stevie B  | Munich | Germany | 1 error prohibited this user from being saved  |
      | stefan@plat-forms.org | superpass1 | superpass             | stefan   | Stevie B  | Munich | Germany | 1 error prohibited this user from being saved  |
  
  