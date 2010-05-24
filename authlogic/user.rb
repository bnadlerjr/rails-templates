# == Description
# Represents a user of the application. Uses +acts_as_authentic+ for 
# authentication support. Has simple support for roles, which are implemented
# using a serialized plain text array. 
class User < ActiveRecord::Base
  acts_as_authentic

  serialize :roles, Array
  before_validation_on_create :make_default_roles

  attr_accessible :password, :password_confirmation, 
                  :email,    :first_name, 
                  :last_name

  # The possible roles that a user can have
  ROLES = ['admin']

  # Returns the first and last names of the user.
  def full_name
    "#{first_name} #{last_name}"
  end

  # Returns the first name and the first initial of the last name of the user.
  def short_name
    "#{first_name} #{last_name.first}."
  end

  # Delivers password reset instructions to the user using +Notifier+ model.
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.deliver_password_reset_instructions(self)  
  end

  # Returns +true+ if the user is an administrator.
  def admin?; has_role?("admin"); end

  # Returns +true+ if the user has the given role in it's array.
  def has_role?(role); roles.include?(role); end

  # Adds the given role to the user's role array.
  def add_role(role); self.roles << role; end

  # Removes the given role from the user's role array.
  def remove_role(role); self.roles.delete(role); end

  # Clears all roles from the user's role array.
  def clear_roles; self.roles = []; end

  private

  def make_default_roles
    clear_roles if roles.nil?
  end
end
