class User < ActiveRecord::Base
  acts_as_authentic

  serialize :roles, Array
  before_validation_on_create :make_default_roles
  attr_accessible :password, :password_confirmation, :email, :first_name, :last_name

  def full_name
    "#{first_name} #{last_name}"
  end

  def short_name
    "#{first_name} #{last_name.first}."
  end

  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.deliver_password_reset_instructions(self)  
  end

  # Role support
  def admin?; has_role?("admin"); end
  def has_role?(role); roles.include?(role); end
  def add_role(role); self.roles << role; end
  def remove_role(role); self.roles.delete(role); end
  def clear_roles; self.roles = []; end

  private

  def make_default_roles
    clear_roles if roles.nil?
  end
end