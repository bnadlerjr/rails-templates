Given /^I am an authenticated user$/ do
  Factory.create(:user)
  visit root_url
  fill_in :email, :with => 'john.doe@example.com'
  fill_in :password, :with => 'secret'
  click_button :login
  assert_contain 'successful' # Fail early if we're not logged in
end

Given /^I am an authenticated administrator$/ do
  admin = Factory.create(:user)
  admin.email = 'admin@example.com'
  admin.add_role('admin')
  admin.save
  visit root_url
  fill_in :email, :with => 'admin@example.com'
  fill_in :password, :with => 'secret'
  click_button :login
  assert_contain 'successful' # Fail early if we're not logged in  
end

