class User < ActiveRecord::Base
  acts_as_authentic

  def full_name
    "\#{first_name} \#{last_name}"
  end

  def short_name
    "\#{first_name} \#{last_name.first}."
  end

  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.deliver_password_reset_instructions(self)  
  end
end