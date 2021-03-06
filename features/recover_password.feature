Feature: Recover password
  In order to use my account again
  As a user
  I want to recover my password

  Scenario: Recover
    Given a user exists with email: "oli@plat-forms.org", password: "supersecret"
    And the email queue is empty
    And I am on "/users/sign_in"
    And  I follow "Forgot your password?"
    Then I am on "/users/password/new"
    When I fill in "Email" with "oli@plat-forms.org"
    And I press "Send me reset password instructions"
    Then I should see "You will receive an email with instructions about how to reset your password in a few minutes."
    And I should be on "/users/sign_in"
    And 1 email should be delivered to oli@plat-forms.org
    And email should contain "Someone has requested a link to change your password, and you can do this through the link below."
    And email should link to "http://localhost:3000/users/password/edit\?reset_password_token\="  
  
