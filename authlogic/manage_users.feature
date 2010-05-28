Feature: Manage users
  In order to control access to the application
  As a administrator
  I want to manage the application's users

	Background:
		Given I am an authenticated administrator
			And jane exists
			And I am on the users page
		
	Scenario: View User List
	  Then I should see "Email Address"
			And I should see "Admin?"
			And I should see "Yes"
			And I should see "No"
	
	Scenario: Create New User
		When I follow "Create New User"
			And I fill in "Email" with "joe.smith@example.com"
			And I fill in "First Name" with "Joe"
			And I fill in "Last Name" with "Smith"
			And I fill in "Password" with "foobar"
			And I fill in "Password Confirmation" with "foobar"
			And I press "Create User"
		Then I should see "User was successfully created."
		
	Scenario: View User Information
	  When I follow "jane.doe@example.com"
	  Then I should see "Email:"
			And I should see "jane.doe@example.com"
			And I should see "Login count"
			And I should see "Last request at"
			And I should see "Last login at"
			And I should see "Current login at"
			And I should see "Last login IP"
			And I should see "Current login IP"
			And I should see "Admin?"
	
	Scenario: Edit User Screen
		When I follow "Edit"
		Then I should see "Edit User"
	
	Scenario: Edit User
		When I follow "Edit"
			And I fill in "Email" with "new.smith@example.com"
			And I fill in "First Name" with "New"
			And I fill in "Last Name" with "Smith"
			And I fill in "Password" with "foobarbaz"
			And I fill in "Password Confirmation" with "foobarbaz"
			And I check "admin"
			And I press "Update User"
		Then I should see "User was successfully updated."
		
	Scenario: Delete User
		When I follow "Delete" within "tr#user_2"
		Then I should see "User was deleted."
