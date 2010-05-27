Feature: Login
	As a user
	I want to login to the application
	So that I can use it

	Background:
		Given I am on the Login page

	Scenario: Existing User
		Given a user: "john_doe" exists
		When I fill in "email" with "john.doe@example.com"
			And I fill in "password" with "secret"
			And I press "Login"
		Then I should see "Login successful!"
			And I should see "john.doe@example.com"
			And I should be on the root page

	Scenario: Bad Email
		When I fill in "email" with "bademail@example.com"
			And I fill in "password" with "secret"
			And I press "Login"
		Then I should see "Incorrect email or password. Please try again."

	Scenario: Bad Password
		When I fill in "email" with "john.doe@example.com"
			And I fill in "password" with "badpassword"
			And I press "Login"
			Then I should see "Incorrect email or password. Please try again."

    Scenario: Logout
        Given I am an authenticated user
            And I am on the Users page
        When I follow "Logout"
        Then I should see "Logout successful!"
            And I should be on the new_user_session page
